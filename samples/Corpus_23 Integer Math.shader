Shader "Corpus/23 Integer Math"
{
    Properties
    {
        _IntA ("Int A", Float) = 7
        _IntB ("Int B", Float) = 3
        _UInt ("UInt", Float) = 255
        _Float ("Float", Float) = 1.5
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
            cbuffer _UnityPerDrawCB_b0
            {
                float4x4 unity_ObjectToWorld;
                float4 cb0_values[3];
            };
            cbuffer _UnityPerFrameCB_b1
            {
                float4x4 unity_MatrixVP : packoffset(c17);
            };
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
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION;
                float2 texcoord0 : TEXCOORD0;
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
                o.texcoord0.xy = (i.texcoord0.xyxx).xy;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float r0_x_1 = firstbithigh(unity_ObjectToWorld[2]);
                float r0_y_1 = (r0_x_1 == -1);
                float r0_y_2 = firstbitlow(unity_ObjectToWorld[2]);
                float r0_y_3 = countbits(unity_ObjectToWorld[2]);
                float r0_y_4 = reversebits(unity_ObjectToWorld[2]);
                float r0_x_6 = (r0_y_4 + (r0_y_3 + (r0_y_2 + (r0_y_1 ? NaN : (-r0_x_1 + 31)))));
                float r0_y_5 = asfloat(asint(unity_ObjectToWorld[2]) << asint(3));
                float r0_z_1 = asfloat(asint(unity_ObjectToWorld[2]) >> asint(2));
                float r0_y_6 = (r0_z_1 + r0_y_5);
                float4 r0_xyzw_2 = asfloat(asint(cb0_values[2].xxxz) & asint(uint4(0, 0, 2147483648, 240)));
                float r0_z_2 = r0_xyzw_2.z;
                float r0_w_1 = r0_xyzw_2.w;
                float r0_y_7 = (r0_w_1 + r0_y_6);
                float r0_w_2 = asfloat(asint(unity_ObjectToWorld[2]) | asint(15));
                float r0_y_8 = (r0_w_2 + r0_y_7);
                float r0_w_3 = asfloat(asint(unity_ObjectToWorld[2]) ^ asint(170));
                float r0_y_9 = (r0_w_3 + r0_y_8);
                float r0_w_4 = ~unity_ObjectToWorld[2];
                float r0_y_10 = (r0_w_4 + r0_y_9);
                float r0_y_11 = (float)(r0_y_10);
                float r0_w_5 = (-unity_ObjectToWorld[2] + unity_ObjectToWorld[2]);
                float2 r1_xy_1 = ((cb0_values[2].yzyy + cb0_values[2].xwxx)).xy;
                float r0_w_6 = (r0_w_5 + r1_xy_1.x);
                float r0_w_7 = mad(unity_ObjectToWorld[2], unity_ObjectToWorld[2], r0_w_6);
                float4 r1_xyzw_2 = max(cb0_values[2].yyxy, int4(0, 1, 0, 0));
                float r1_y_2 = r1_xyzw_2.y;
                float r1_z_1 = r1_xyzw_2.z;
                float r1_w_1 = asfloat(asint(r1_y_2) ^ asint(unity_ObjectToWorld[2]));
                float r1_w_2 = asfloat(asint(r1_w_1) & asint(2147483648));
                float r2_x_2 = (r3_x / max(unity_ObjectToWorld[2], -unity_ObjectToWorld[2]));
                float4 r1_xyzw_3 = min(r1_z_1.xxxx, int4(0, 10, 6, 0));
                float r1_y_3 = r1_xyzw_3.y;
                float r1_z_2 = r1_xyzw_3.z;
                float r2_y_1 = -r2_x_2;
                float r1_w_3 = ((r1_w_2 != 0) ? r2_y_1 : r2_x_2);
                float r0_w_8 = (r0_w_7 + r1_w_3);
                float r1_w_4 = -r3_x;
                float r0_z_3 = ((r0_z_2 != 0) ? r1_w_4 : r3_x);
                float r0_z_4 = (r0_z_3 + r0_w_8);
                float r0_z_5 = mad(unity_ObjectToWorld[2], 3, r0_z_4);
                float r0_w_9 = asfloat(asint(unity_ObjectToWorld[2]) >> asint(1));
                float r0_z_6 = (r0_w_9 + r0_z_5);
                float2 r0_xz_7 = ((float)(float4(r0_x_6, r0_x_6, r0_z_6, r0_x_6))).xz;
                float r0_y_12 = (r0_y_11 + r0_xz_7.y);
                float r0_y_13 = f32tof16(unity_ObjectToWorld[2]);
                float r0_y_14 = f16tof32(r0_y_13);
                float r0_y_15 = (r0_y_14 + unity_ObjectToWorld[2]);
                float r0_y_16 = ((float)(r1_xy_1.y) + r0_y_15);
                float r0_y_17 = (r1_z_2 >= 2);
                float4 r0_xyzw_18 = (r0_y_17.xxxx ? float4(0, 3E-45, 4E-45, 0) : float4(0, 1E-45, 3E-45, 0));
                float r0_y_18 = r0_xyzw_18.y;
                float r0_z_8 = r0_xyzw_18.z;
                float r0_w_10 = (r1_z_2 >= r0_z_8);
                float4 r0_xyzw_19 = (r0_w_10.xxxx ? float4(0, 8E-45, 6E-45, 0) : float4(r0_y_18, r0_y_18, r0_z_8, r0_y_18));
                float r0_y_19 = r0_xyzw_19.y;
                float r0_z_9 = r0_xyzw_19.z;
                float r0_w_11 = asfloat(asint(r0_w_10) & asint((float)((r1_z_2 >= r0_z_9))));
                float4 r0_xyzw_20 = (r0_w_11.xxxx ? float4(0, 3.4E-44, 7E-45, 0) : float4(r0_y_19, r0_y_19, r0_z_9, r0_y_19));
                float r0_y_20 = r0_xyzw_20.y;
                float r0_z_10 = r0_xyzw_20.z;
                float r0_w_12 = asfloat(asint(r0_w_11) & asint((float)((r1_z_2 >= r0_z_10))));
                float4 r0_xyzw_21 = (r0_w_12.xxxx ? float4(0, 1.68E-43, 8E-45, 0) : float4(r0_y_20, r0_y_20, r0_z_10, r0_y_20));
                float r0_y_21 = r0_xyzw_21.y;
                float r0_z_11 = r0_xyzw_21.z;
                float r0_z_12 = (r1_z_2 >= r0_z_11);
                float r0_y_22 = (float)(r0_y_21);
                float r0_z_13 = asfloat(asint(r0_z_12) & asint(r0_w_12));
                float r0_y_23 = ((r0_z_13 != 0) ? 720 : r0_y_22);
                float r0_y_24 = (i.texcoord0.x * 10);
                float r0_y_25 = (int)(r0_y_24);
                float r0_z_14 = asfloat(asint(r0_y_25) & asint(31));
                float r0_y_26 = asfloat(asint(unity_ObjectToWorld[2]) << asint(r0_y_25));
                float r0_z_15 = (-r0_z_14 + 32);
                float r0_z_16 = asfloat(asint(unity_ObjectToWorld[2]) >> asint(r0_z_15));
                float r0_y_27 = asfloat(asint(r0_z_16) | asint(r0_y_26));
                float r0_y_28 = (float)(r0_y_27);
                float r0_y_29 = (0 < unity_ObjectToWorld[2]);
                float r0_y_30 = asfloat(asint(r0_y_29) & asint(1065353216));
                float r0_y_31 = max(unity_ObjectToWorld[2], unity_ObjectToWorld[2]);
                float r0_y_32 = (r0_y_31 + r1_y_3);
                float r0_z_17 = min(unity_ObjectToWorld[2], unity_ObjectToWorld[2]);
                float r0_y_33 = (r0_z_17 + r0_y_32);
                float r0_y_34 = (float)(r0_y_33);
                float r0_x_14 = ((r0_y_34 + (r0_y_30 + (r0_y_28 + (r0_y_23 + (r0_y_16 + (r0_xz_7.x + r0_y_12)))))) * 0.01);
                o.sv_Target0.xyz = (frac(r0_x_14.xxxx)).xyz;
                o.sv_Target0.w = 1;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Diffuse"
}
