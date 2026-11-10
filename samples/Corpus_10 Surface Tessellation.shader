Shader "Corpus/10 Surface Tessellation"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo", 2D) = "" {}
        _Tess ("Tessellation", Range(1, 32)) = 4
        _Disp ("Displacement", Range(0, 1)) = 0.1
        _Phong ("Phong Strength", Range(0, 1)) = 0.5
    }
    SubShader
    {
        Tags { "QUEUE"="Geometry" "RenderType"="Opaque" }
        LOD 400
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDBASE" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            cbuffer _StubCB : register(b1) { float4x4 unity_MatrixVP; };
            struct v2f { float4 pos : SV_POSITION; };
            v2f vert(float4 v : POSITION) { v2f o; o.pos = mul(unity_MatrixVP, v); return o; }
            float4 frag(v2f i) : SV_Target { return 0; }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="FORWARDADD" "QUEUE"="Geometry" "RenderType"="Opaque" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend One One
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float4 _LightColor0 : packoffset(c2);
                float4 _Color : packoffset(c4);
                float _Tess : packoffset(c5.x);
                float _Disp : packoffset(c5.y);
                float _Phong : packoffset(c5.z);
                float4 _MainTex_ST : packoffset(c6);
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float4 _Time;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerDrawCB_b2
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb2_values[46];
            };
            cbuffer _UnityPerFrameCB_b3
            {
                float4x4 unity_MatrixVP;
                float4 cb3_values[7];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[21];
            };
            struct program34Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program34Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program35Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program35Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program36Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program36Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program37Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program37Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program38Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program38Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program39Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program39Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program40Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program40Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program41Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program41Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program46Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program46Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program47Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program47Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program48Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program48Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program49Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program49Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program50Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program50Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program51Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program51Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program52Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program52Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            struct program53Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program53Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord4 : TEXCOORD4;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord5 : TEXCOORD5;
                float4 texcoord6 : TEXCOORD6;
            };
            program41Output hull(program41Input i)
            {
                program41Output o = (program41Output)0;
                // TODO: unhandled IR node — hs_fork_phase
                float r0_y_1 = inputforkinstanceid0.x;
                o.internaltesspos0.x = max(_Tess, 1);
                return o;
            }
            program53Output domain(program53Input i)
            {
                program53Output o = (program53Output)0;
                float4 r1_xyzw_3 = mad(inputcontrolpoint2.xyzw, inputdomainpoint0.zzzz, mad(inputcontrolpoint0.xyzw, inputdomainpoint0.xxxx, (inputdomainpoint0.yyyy * inputcontrolpoint1.xyzw)));
                float r0_y_1 = dot(r1_xyzw_3.xyzx, inputcontrolpoint1.xyzx);
                float4 r0_xyzw_3 = mad(-inputcontrolpoint1.xyzx, ((dot(inputcontrolpoint1.xyzx, inputcontrolpoint1.xyzx) + r0_y_1)).xxxx, r1_xyzw_3.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_2 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = (float4(r0_x_3, r0_y_2, r0_z_1, r0_x_3) * inputdomainpoint0.yyyy);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_3 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float r0_w_1 = dot(inputcontrolpoint0.xyzx, inputcontrolpoint0.xyzx);
                float r0_w_2 = (-r0_w_1 + dot(r1_xyzw_3.xyzx, inputcontrolpoint0.xyzx));
                float4 r2_xyzw_2 = mad(-inputcontrolpoint0.xyzx, r0_w_2.xxxx, r1_xyzw_3.xyzx);
                float r2_x_2 = r2_xyzw_2.x;
                float r2_y_1 = r2_xyzw_2.y;
                float r2_z_1 = r2_xyzw_2.z;
                float4 r0_xyzw_5 = mad(float4(r2_x_2, r2_y_1, r2_z_1, r2_x_2), inputdomainpoint0.xxxx, float4(r0_x_4, r0_y_3, r0_z_2, r0_x_4));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_3 = r0_xyzw_5.z;
                float r0_w_3 = dot(inputcontrolpoint2.xyzx, inputcontrolpoint2.xyzx);
                float r0_w_4 = (-r0_w_3 + dot(r1_xyzw_3.xyzx, inputcontrolpoint2.xyzx));
                float4 r2_xyzw_4 = mad(-inputcontrolpoint2.xyzx, r0_w_4.xxxx, r1_xyzw_3.xyzx);
                float r2_x_4 = r2_xyzw_4.x;
                float r2_y_2 = r2_xyzw_4.y;
                float r2_z_2 = r2_xyzw_4.z;
                float4 r0_xyzw_6 = mad(float4(r2_x_4, r2_y_2, r2_z_2, r2_x_4), inputdomainpoint0.zzzz, float4(r0_x_5, r0_y_4, r0_z_3, r0_x_5));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_5 = r0_xyzw_6.y;
                float r0_z_4 = r0_xyzw_6.z;
                float r0_w_5 = (-_Phong + 1);
                float4 r0_xyzw_7 = mad(_Phong.xxxx, float4(r0_x_6, r0_y_5, r0_z_4, r0_x_6), ((r1_xyzw_3.xyzx * r0_w_5.xxxx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_6 = r0_xyzw_7.y;
                float r0_z_5 = r0_xyzw_7.z;
                float2 r1_xy_7 = (mad(inputcontrolpoint2.xyxx, inputdomainpoint0.zzzz, (mad(inputcontrolpoint0.xyxx, inputdomainpoint0.xxxx, ((inputdomainpoint0.yyyy * inputcontrolpoint1.xyxx)).xyxx)).xyxx)).xy;
                float r0_w_6 = (r1_xy_7.y * 10);
                float r0_w_7 = mad(-_Time.y, 0.5, r0_w_6);
                float r0_w_8 = cos(r0_w_7);
                float r1_z_5 = mad(r1_xy_7.x, 12, _Time.y);
                o.texcoord0.xy = (mad(r1_xy_7.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float r0_w_9 = (r0_w_8 * sin(r1_z_5));
                float4 r1_xyzw_9 = (inputdomainpoint0.yyyy * inputcontrolpoint1.xyzx);
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_8 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = mad(inputcontrolpoint0.xyzx, inputdomainpoint0.xxxx, float4(r1_x_9, r1_y_8, r1_z_6, r1_x_9));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_9 = r1_xyzw_10.y;
                float r1_z_7 = r1_xyzw_10.z;
                float4 r1_xyzw_11 = mad(inputcontrolpoint2.xyzx, inputdomainpoint0.zzzz, float4(r1_x_10, r1_y_9, r1_z_7, r1_x_10));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_10 = r1_xyzw_11.y;
                float r1_z_8 = r1_xyzw_11.z;
                float4 r2_xyzw_5 = (r0_w_9.xxxx * float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11));
                float r2_x_5 = r2_xyzw_5.x;
                float r2_y_3 = r2_xyzw_5.y;
                float r2_z_3 = r2_xyzw_5.z;
                float4 r0_xyzw_8 = mad(float4(r2_x_5, r2_y_3, r2_z_3, r2_x_5), _Disp.xxxx, float4(r0_x_7, r0_y_6, r0_z_5, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_7 = r0_xyzw_8.y;
                float r0_z_6 = r0_xyzw_8.z;
                float4 r2_xyzw_6 = (r0_y_7.xxxx * cb3_values[1].xyzw);
                float4 r2_xyzw_7 = mad(cb3_values[0].xyzw, r0_x_8.xxxx, r2_xyzw_6);
                float4 r0_xyzw_9 = mad(cb3_values[2].xyzw, r0_z_6.xxxx, r2_xyzw_7);
                float4 r2_xyzw_8 = (r0_xyzw_9 + cb3_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb3_values[3].xyzx, r1_xyzw_3.wwww, r0_xyzw_9.xyzx)).xyz;
                float4 r0_xyzw_10 = (r2_xyzw_8.yyyy * cb4_values[18].xyzw);
                float4 r0_xyzw_11 = mad(cb4_values[17].xyzw, r2_xyzw_8.xxxx, r0_xyzw_10);
                float4 r0_xyzw_12 = mad(cb4_values[19].xyzw, r2_xyzw_8.zzzz, r0_xyzw_11);
                float4 r0_xyzw_13 = mad(cb4_values[20].xyzw, r2_xyzw_8.wwww, r0_xyzw_12);
                o.sv_Position0.xyzw = r0_xyzw_13;
                o.texcoord4.x = r0_xyzw_13.z;
                o.texcoord5.zw = (r0_xyzw_13.zzzw).zw;
                float r2_x_9 = dot(float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11), cb3_values[4].xyzx);
                float r2_y_7 = dot(float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11), cb3_values[5].xyzx);
                float r2_z_7 = dot(float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11), cb3_values[6].xyzx);
                float r0_z_12 = dot(float4(r2_x_9, r2_y_7, r2_z_7, r2_x_9), float4(r2_x_9, r2_y_7, r2_z_7, r2_x_9));
                float r0_z_13 = rsqrt(r0_z_12);
                float4 r1_xyzw_12 = (r0_z_13.xxxx * float4(r2_x_9, r2_y_7, r2_z_7, r2_x_9));
                float r1_x_12 = r1_xyzw_12.x;
                float r1_y_11 = r1_xyzw_12.y;
                float r1_z_9 = r1_xyzw_12.z;
                o.texcoord1.xyz = (float4(r1_x_12, r1_y_11, r1_z_9, r1_x_12)).xyz;
                float r0_z_14 = (r1_y_11 * r1_y_11);
                float r0_z_15 = mad(r1_x_12, r1_x_12, -r0_z_14);
                float4 r1_xyzw_13 = (float4(r1_y_11, r1_z_9, r1_z_9, r1_x_12) * float4(r1_x_12, r1_y_11, r1_z_9, r1_z_9));
                float r2_x_10 = dot(cb2_values[42].xyzw, r1_xyzw_13);
                float r2_y_8 = dot(cb2_values[43].xyzw, r1_xyzw_13);
                float r2_z_8 = dot(cb2_values[44].xyzw, r1_xyzw_13);
                o.texcoord3.xyz = (mad(cb2_values[45].xyzx, r0_z_15.xxxx, float4(r2_x_10, r2_y_8, r2_z_8, r2_x_10))).xyz;
                float r0_y_13 = (r0_xyzw_13.y * cb1_values[5].x);
                float4 r0_xyzw_14 = (r0_xyzw_13.xxwx * float4(0.5, 0, 0.5, 0));
                float r0_x_14 = r0_xyzw_14.x;
                float r0_z_16 = r0_xyzw_14.z;
                float r0_w_15 = (r0_y_13 * 0.5);
                o.texcoord5.xy = ((r0_z_16.xxxx + float4(r0_x_14, r0_w_15, r0_x_14, r0_x_14))).xy;
                o.texcoord6.xyzw = float4(0, 0, 0, 0);
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "LIGHTMODE"="DEFERRED" "QUEUE"="Geometry" "RenderType"="Opaque" }
            Cull Back
            ZTest LEqual
            ZWrite On
            HLSLPROGRAM
            cbuffer _GlobalsCB_b0
            {
                float _Tess;
                float _Disp;
                float _Phong;
                float4 _MainTex_ST;
                float4 cb0_values[16];
            };
            cbuffer _UnityPerCameraCB_b1
            {
                float4 _Time;
                float4 cb1_values[6];
            };
            cbuffer _UnityPerDrawCB_b2
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float4 cb2_values[46];
            };
            cbuffer _UnityPerFrameCB_b3
            {
                float4x4 unity_MatrixVP;
                float4 cb3_values[7];
            };
            cbuffer cb4 : register(b4)
            {
                float4 cb4_values[21];
            };
            struct program125Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program125Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program126Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program126Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program127Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program127Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program128Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program128Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program129Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program129Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program130Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program130Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program131Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program131Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program132Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program132Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program133Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program133Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program134Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program134Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program135Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program135Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program136Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program136Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program137Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program137Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program138Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program138Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program139Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program139Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program140Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program140Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program141Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program141Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program142Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program142Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program143Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program143Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program144Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program144Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program145Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program145Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program146Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program146Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program152Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program152Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program153Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program153Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program154Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program154Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program155Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program155Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program156Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program156Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program157Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program157Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program158Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program158Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program159Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program159Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program160Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program160Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program161Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program161Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program162Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program162Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program163Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program163Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program164Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program164Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program165Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program165Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program166Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program166Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program167Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program167Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program168Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program168Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program169Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program169Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program170Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program170Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program171Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program171Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program172Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program172Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program173Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program173Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord3 : TEXCOORD3;
                float3 texcoord1 : TEXCOORD1;
                float texcoord5 : TEXCOORD5;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program174Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program174Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program175Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program175Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program176Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program176Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program177Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program177Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float texcoord5 : TEXCOORD5;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float3 texcoord3 : TEXCOORD3;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program189Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program189Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program190Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program190Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program191Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program191Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program192Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program192Output
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program195Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program195Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program196Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program196Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };
            struct program197Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program197Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
            };
            struct program198Input
            {
                float4 internaltesspos0 : INTERNALTESSPOS0;
                float4 tangent0 : TANGENT0;
                float3 normal0 : NORMAL0;
                float4 texcoord0 : TEXCOORD0;
                float4 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
                float4 texcoord3 : TEXCOORD3;
                float4 color0 : COLOR0;
            };
            struct program198Output
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
                float4 texcoord4 : TEXCOORD4;
                float3 texcoord5 : TEXCOORD5;
            };
            program192Output hull(program192Input i)
            {
                program192Output o = (program192Output)0;
                // TODO: unhandled IR node — hs_fork_phase
                float r0_y_1 = inputforkinstanceid0.x;
                o.internaltesspos0.x = max(_Tess, 1);
                return o;
            }
            program198Output domain(program198Input i)
            {
                program198Output o = (program198Output)0;
                float4 r1_xyzw_3 = mad(inputcontrolpoint2.xyzw, inputdomainpoint0.zzzz, mad(inputcontrolpoint0.xyzw, inputdomainpoint0.xxxx, (inputdomainpoint0.yyyy * inputcontrolpoint1.xyzw)));
                float r0_y_1 = dot(r1_xyzw_3.xyzx, inputcontrolpoint1.xyzx);
                float4 r0_xyzw_3 = mad(-inputcontrolpoint1.xyzx, ((dot(inputcontrolpoint1.xyzx, inputcontrolpoint1.xyzx) + r0_y_1)).xxxx, r1_xyzw_3.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_2 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = (float4(r0_x_3, r0_y_2, r0_z_1, r0_x_3) * inputdomainpoint0.yyyy);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_3 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float r0_w_1 = dot(inputcontrolpoint0.xyzx, inputcontrolpoint0.xyzx);
                float r0_w_2 = (-r0_w_1 + dot(r1_xyzw_3.xyzx, inputcontrolpoint0.xyzx));
                float4 r2_xyzw_2 = mad(-inputcontrolpoint0.xyzx, r0_w_2.xxxx, r1_xyzw_3.xyzx);
                float r2_x_2 = r2_xyzw_2.x;
                float r2_y_1 = r2_xyzw_2.y;
                float r2_z_1 = r2_xyzw_2.z;
                float4 r0_xyzw_5 = mad(float4(r2_x_2, r2_y_1, r2_z_1, r2_x_2), inputdomainpoint0.xxxx, float4(r0_x_4, r0_y_3, r0_z_2, r0_x_4));
                float r0_x_5 = r0_xyzw_5.x;
                float r0_y_4 = r0_xyzw_5.y;
                float r0_z_3 = r0_xyzw_5.z;
                float r0_w_3 = dot(inputcontrolpoint2.xyzx, inputcontrolpoint2.xyzx);
                float r0_w_4 = (-r0_w_3 + dot(r1_xyzw_3.xyzx, inputcontrolpoint2.xyzx));
                float4 r2_xyzw_4 = mad(-inputcontrolpoint2.xyzx, r0_w_4.xxxx, r1_xyzw_3.xyzx);
                float r2_x_4 = r2_xyzw_4.x;
                float r2_y_2 = r2_xyzw_4.y;
                float r2_z_2 = r2_xyzw_4.z;
                float4 r0_xyzw_6 = mad(float4(r2_x_4, r2_y_2, r2_z_2, r2_x_4), inputdomainpoint0.zzzz, float4(r0_x_5, r0_y_4, r0_z_3, r0_x_5));
                float r0_x_6 = r0_xyzw_6.x;
                float r0_y_5 = r0_xyzw_6.y;
                float r0_z_4 = r0_xyzw_6.z;
                float r0_w_5 = (-_Phong + 1);
                float4 r0_xyzw_7 = mad(_Phong.xxxx, float4(r0_x_6, r0_y_5, r0_z_4, r0_x_6), ((r1_xyzw_3.xyzx * r0_w_5.xxxx)).xyzx);
                float r0_x_7 = r0_xyzw_7.x;
                float r0_y_6 = r0_xyzw_7.y;
                float r0_z_5 = r0_xyzw_7.z;
                float2 r1_xy_7 = (mad(inputcontrolpoint2.xyxx, inputdomainpoint0.zzzz, (mad(inputcontrolpoint0.xyxx, inputdomainpoint0.xxxx, ((inputdomainpoint0.yyyy * inputcontrolpoint1.xyxx)).xyxx)).xyxx)).xy;
                float r0_w_6 = (r1_xy_7.y * 10);
                float r0_w_7 = mad(-_Time.y, 0.5, r0_w_6);
                float r0_w_8 = cos(r0_w_7);
                float r1_z_5 = mad(r1_xy_7.x, 12, _Time.y);
                o.texcoord0.xy = (mad(r1_xy_7.xyxx, _MainTex_ST.xyxx, _MainTex_ST.zwzz)).xy;
                float r0_w_9 = (r0_w_8 * sin(r1_z_5));
                float4 r1_xyzw_9 = (inputdomainpoint0.yyyy * inputcontrolpoint1.xyzx);
                float r1_x_9 = r1_xyzw_9.x;
                float r1_y_8 = r1_xyzw_9.y;
                float r1_z_6 = r1_xyzw_9.z;
                float4 r1_xyzw_10 = mad(inputcontrolpoint0.xyzx, inputdomainpoint0.xxxx, float4(r1_x_9, r1_y_8, r1_z_6, r1_x_9));
                float r1_x_10 = r1_xyzw_10.x;
                float r1_y_9 = r1_xyzw_10.y;
                float r1_z_7 = r1_xyzw_10.z;
                float4 r1_xyzw_11 = mad(inputcontrolpoint2.xyzx, inputdomainpoint0.zzzz, float4(r1_x_10, r1_y_9, r1_z_7, r1_x_10));
                float r1_x_11 = r1_xyzw_11.x;
                float r1_y_10 = r1_xyzw_11.y;
                float r1_z_8 = r1_xyzw_11.z;
                float4 r2_xyzw_5 = (r0_w_9.xxxx * float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11));
                float r2_x_5 = r2_xyzw_5.x;
                float r2_y_3 = r2_xyzw_5.y;
                float r2_z_3 = r2_xyzw_5.z;
                float4 r0_xyzw_8 = mad(float4(r2_x_5, r2_y_3, r2_z_3, r2_x_5), _Disp.xxxx, float4(r0_x_7, r0_y_6, r0_z_5, r0_x_7));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_7 = r0_xyzw_8.y;
                float r0_z_6 = r0_xyzw_8.z;
                float4 r2_xyzw_6 = (r0_y_7.xxxx * cb3_values[1].xyzw);
                float4 r2_xyzw_7 = mad(cb3_values[0].xyzw, r0_x_8.xxxx, r2_xyzw_6);
                float4 r0_xyzw_9 = mad(cb3_values[2].xyzw, r0_z_6.xxxx, r2_xyzw_7);
                float4 r2_xyzw_8 = (r0_xyzw_9 + cb3_values[3].xyzw);
                o.texcoord2.xyz = (mad(cb3_values[3].xyzx, r1_xyzw_3.wwww, r0_xyzw_9.xyzx)).xyz;
                float4 r0_xyzw_10 = (r2_xyzw_8.yyyy * cb4_values[18].xyzw);
                float4 r0_xyzw_11 = mad(cb4_values[17].xyzw, r2_xyzw_8.xxxx, r0_xyzw_10);
                float4 r0_xyzw_12 = mad(cb4_values[19].xyzw, r2_xyzw_8.zzzz, r0_xyzw_11);
                o.sv_Position0.xyzw = mad(cb4_values[20].xyzw, r2_xyzw_8.wwww, r0_xyzw_12);
                float r0_x_13 = dot(float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11), cb3_values[4].xyzx);
                float r0_y_12 = dot(float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11), cb3_values[5].xyzx);
                float r0_z_11 = dot(float4(r1_x_11, r1_y_10, r1_z_8, r1_x_11), cb3_values[6].xyzx);
                float r0_w_14 = dot(float4(r0_x_13, r0_y_12, r0_z_11, r0_x_13), float4(r0_x_13, r0_y_12, r0_z_11, r0_x_13));
                float r0_w_15 = rsqrt(r0_w_14);
                float4 r0_xyzw_14 = (r0_w_15.xxxx * float4(r0_x_13, r0_y_12, r0_z_11, r0_x_13));
                float r0_x_14 = r0_xyzw_14.x;
                float r0_y_13 = r0_xyzw_14.y;
                float r0_z_12 = r0_xyzw_14.z;
                o.texcoord1.xyz = (float4(r0_x_14, r0_y_13, r0_z_12, r0_x_14)).xyz;
                o.texcoord4.xyzw = float4(0, 0, 0, 0);
                float r0_w_16 = (r0_y_13 * r0_y_13);
                float r0_w_17 = mad(r0_x_14, r0_x_14, -r0_w_16);
                float4 r1_xyzw_12 = (float4(r0_y_13, r0_z_12, r0_z_12, r0_x_14) * float4(r0_x_14, r0_y_13, r0_z_12, r0_z_12));
                float r0_x_15 = dot(cb2_values[42].xyzw, r1_xyzw_12);
                float r0_y_14 = dot(cb2_values[43].xyzw, r1_xyzw_12);
                float r0_z_13 = dot(cb2_values[44].xyzw, r1_xyzw_12);
                o.texcoord5.xyz = (mad(cb2_values[45].xyzx, r0_w_17.xxxx, float4(r0_x_15, r0_y_14, r0_z_13, r0_x_15))).xyz;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Standard"
}
