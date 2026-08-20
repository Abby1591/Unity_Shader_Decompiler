Shader "Custom/Armor_Shader_UNLIT"
{
    Properties
    {
        _ArmorColor ("Armor Color", Color) = (1,0.639,0,0.7)
        _EmissionColor ("Emission Color", Color) = (1,0.75,0,0)
        _EmissionScale ("Emission Scale", Range(0.01, 10)) = 4.5
        _AnimationSpeed ("Animation Speed", Float) = 30
        _AnimationAmount ("Animation Amount", Range(0, 1)) = 0.3
        _RippleSize ("Ripple Size", Range(1, 200)) = 200
    }
    SubShader
    {
        Tags { "FORCENOSHADOWCASTING"="true" "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent" "RenderType"="Transparent" }
        LOD 300
        Pass
        {
            Tags { "FORCENOSHADOWCASTING"="true" "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            cbuffer UnityPerCamera : register(b0)
            {
                float4 _ArmorColor;
                float4 _ProjectionParams;
                float4 _EmissionColor;
                float _EmissionScale;
                float _AnimationSpeed;
                float _AnimationAmount;
                float _RippleSize;
                float4 cb0_values[7];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4 _Time;
                float4x4 unity_WorldToObject;
                float3 _WorldSpaceCameraPos;
                float4 cb1_values[7];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 glstate_lightmodel_ambient;
                float4x4 unity_MatrixVP;
                float4 cb2_values[21];
            };
            struct program1Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
            };
            struct program1Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
            };
            struct program3Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
            };
            struct program3Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program1Output vert(program1Input i)
            {
                program1Output o = (program1Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.texcoord0.xyzw = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                float4 clipPos_xyzw_4 = (worldPos_xyzw_1.yyyy * unity_MatrixVP[1]);
                float4 clipPos_xyzw_5 = mad(unity_MatrixVP[0], worldPos_xyzw_1.xxxx, clipPos_xyzw_4);
                float4 clipPos_xyzw_6 = mad(unity_MatrixVP[2], worldPos_xyzw_1.zzzz, clipPos_xyzw_5);
                float4 clipPos_xyzw_7 = mad(unity_MatrixVP[3], worldPos_xyzw_1.wwww, clipPos_xyzw_6);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                float worldNormal_x_2 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float r0_y_8 = (clipPos_xyzw_7.y * _ProjectionParams.x);
                float4 r1_xyzw_3 = (float4(clipPos_xyzw_7.x, clipPos_xyzw_7.x, clipPos_xyzw_7.w, r0_y_8) * float4(0.5, 0, 0.5, 0.5));
                float r1_x_3 = r1_xyzw_3.x;
                float r1_z_3 = r1_xyzw_3.z;
                float r1_w_4 = r1_xyzw_3.w;
                o.texcoord2.zw = (clipPos_xyzw_7.zzzw).zw;
                o.texcoord2.xy = ((r1_z_3.xxxx + float4(r1_x_3, r1_w_4, r1_x_3, r1_x_3))).xy;
                return o;
            }
            #pragma fragment frag
            program3Output frag(program3Input i)
            {
                program3Output o = (program3Output)0;
                float2 r0_xy_1 = ((i.texcoord2.xyxx / i.texcoord2.wwww)).xy;
                float2 r0_zw_1 = ((r0_xy_1.xxxy + float4(0, 0, -1, -0))).zw;
                float r0_z_2 = dot(r0_zw_1.xyxx, r0_zw_1.xyxx);
                float r0_z_3 = sqrt(r0_z_2);
                float r0_z_4 = sin(r0_z_3);
                float4 r1_xyzw_1 = (_RippleSize.xxxx + float4(53, 37, 61, 47));
                float3 r2_xyz_1 = ((_Time.xxxx * float4(345, 300, 390, 0))).xyz;
                float r0_z_5 = mad(-r0_z_4, r1_xyzw_1.z, r2_xyz_1.y);
                float r0_z_6 = sin(r0_z_5);
                float r0_z_7 = (r0_z_6 * 0.3);
                float r0_w_2 = dot(r0_xy_1.xyxx, r0_xy_1.xyxx);
                float r0_w_3 = sqrt(r0_w_2);
                float r0_w_4 = sin(r0_w_3);
                float r0_w_5 = mad(-r0_w_4, r1_xyzw_1.w, r2_xyz_1.z);
                float r0_w_6 = sin(r0_w_5);
                float r0_z_8 = mad(r0_w_6, 0.6, r0_z_7);
                float4 r3_xyzw_1 = (r0_xy_1.xyxy + float4(-1, -1, -0, -1));
                float r0_y_2 = dot(r3_xyzw_1.zwzz, r3_xyzw_1.zwzz);
                float r0_w_7 = dot(r3_xyzw_1.xyxx, r3_xyzw_1.xyxx);
                float4 r0_xyzw_3 = sqrt(float4(r0_y_2, r0_y_2, r0_y_2, r0_w_7));
                float r0_y_3 = r0_xyzw_3.y;
                float r0_w_8 = r0_xyzw_3.w;
                float r0_w_9 = sin(r0_w_8);
                float r0_w_10 = mad(-r0_w_9, r1_xyzw_1.x, r2_xyz_1.x);
                float4 r0_xyzw_4 = sin(float4(r0_y_3, r0_y_3, r0_y_3, r0_w_10));
                float r0_y_4 = r0_xyzw_4.y;
                float r0_w_11 = r0_xyzw_4.w;
                float r0_y_5 = mad(-r0_y_4, r1_xyzw_1.y, r2_xyz_1.x);
                float r0_y_6 = sin(r0_y_5);
                float r0_y_7 = mad(r0_y_6, 0.4, r0_z_8);
                float r0_y_8 = mad(r0_w_11, 0.5, r0_y_7);
                float r0_z_9 = (_RippleSize + 83);
                float r0_x_6 = (mad(sin(mad(sin(r0_xy_1.y), r0_z_9, r2_xyz_1.z)), 0.9, r0_y_8) * 10);
                float r0_y_9 = mad(r0_x_6, -2, 3);
                float4 viewDir_xyzw_10 = (-i.texcoord0.xxyz + _WorldSpaceCameraPos.xxyz);
                float viewDir_y_10 = viewDir_xyzw_10.y;
                float viewDir_z_10 = viewDir_xyzw_10.z;
                float viewDir_w_12 = viewDir_xyzw_10.w;
                float4 unitViewDir_xyzw_11 = (float4(viewDir_y_10, viewDir_y_10, viewDir_z_10, viewDir_w_12) * (rsqrt(dot(float4(viewDir_y_10, viewDir_z_10, viewDir_w_12, viewDir_y_10), float4(viewDir_y_10, viewDir_z_10, viewDir_w_12, viewDir_y_10)))).xxxx);
                float unitViewDir_y_11 = unitViewDir_xyzw_11.y;
                float unitViewDir_z_11 = unitViewDir_xyzw_11.z;
                float unitViewDir_w_13 = unitViewDir_xyzw_11.w;
                float r0_y_12 = dot(float4(unitViewDir_y_11, unitViewDir_z_11, unitViewDir_w_13, unitViewDir_y_11), i.texcoord1.xyzx);
                float r0_y_13 = (-r0_y_12 + 1);
                float r0_y_14 = log2(r0_y_13);
                float r0_z_12 = mad(-_EmissionScale, 0.3, 3);
                float r0_y_15 = (r0_y_14 * r0_z_12);
                float r0_y_16 = exp2(r0_y_15);
                float4 r1_xyzw_4 = (glstate_lightmodel_ambient.xyzx + glstate_lightmodel_ambient.xyzx);
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_2 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                float4 r0_xyzw_17 = mad(r0_y_16.xxxx, _EmissionColor.xxyz, float4(r1_x_4, r1_x_4, r1_y_2, r1_z_2));
                float r0_y_17 = r0_xyzw_17.y;
                float r0_z_13 = r0_xyzw_17.z;
                float r0_w_14 = r0_xyzw_17.w;
                float4 r0_xyzw_18 = (float4(r0_y_17, r0_y_17, r0_z_13, r0_w_14) * _ArmorColor.xxyz);
                float r0_y_18 = r0_xyzw_18.y;
                float r0_z_14 = r0_xyzw_18.z;
                float r0_w_15 = r0_xyzw_18.w;
                o.sv_Target0.xyz = ((float4(r0_y_18, r0_z_14, r0_w_15, r0_y_18) * _EmissionScale.xxxx)).xyz;
                float r0_y_19 = (float)(_AnimationSpeed);
                float r0_y_20 = (r0_y_19 * _Time.x);
                float r0_y_21 = sin(r0_y_20);
                float r0_y_22 = (r0_y_21 * _AnimationAmount);
                float r0_y_23 = (-abs(r0_y_22) + _ArmorColor.w);
                o.sv_Target0.w = (((((((r0_x_6 * r0_x_6) * r0_y_9) * 0.0003) / r0_y_17) / r0_z_13) / r0_w_14) + r0_y_23);
                return o;
            }
            ENDHLSL
        }
    }
    SubShader
    {
        Tags { "FORCENOSHADOWCASTING"="true" "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent" "RenderType"="Transparent" }
        LOD 200
        Pass
        {
            Tags { "FORCENOSHADOWCASTING"="true" "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _ArmorColor;
                float4x4 unity_WorldToObject;
                float4 _EmissionColor;
                float _EmissionScale;
                float _AnimationSpeed;
                float _AnimationAmount;
                float4 cb0_values[7];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 _Time;
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[21];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 glstate_lightmodel_ambient;
                float4 cb2_values[1];
            };
            struct program5Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
            };
            struct program5Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
            };
            struct program6Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
            };
            struct program6Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program5Output vert(program5Input i)
            {
                program5Output o = (program5Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.texcoord0.xyzw = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_7 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_7 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_7 = dot(float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7));
                float r0_w_8 = rsqrt(r0_w_7);
                o.texcoord1.xyz = ((r0_w_8.xxxx * float4(worldNormal_x_7, worldNormal_y_7, worldNormal_z_7, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program6Output frag(program6Input i)
            {
                program6Output o = (program6Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord0.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_2 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r0_y_3 = mad(-_EmissionScale, 0.3, 3);
                float4 r0_xyzw_4 = (glstate_lightmodel_ambient.xxyz + glstate_lightmodel_ambient.xxyz);
                float r0_y_4 = r0_xyzw_4.y;
                float r0_z_3 = r0_xyzw_4.z;
                float r0_w_3 = r0_xyzw_4.w;
                float4 r0_xyzw_8 = mad((exp2((log2((dot(unitViewDir_xyz_2.xyzx, i.texcoord1.xyzx) + 1)) * r0_y_3))).xxxx, _EmissionColor.xyzx, float4(r0_y_4, r0_z_3, r0_w_3, r0_y_4));
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_5 = r0_xyzw_8.y;
                float r0_z_4 = r0_xyzw_8.z;
                float4 r0_xyzw_9 = (float4(r0_x_8, r0_y_5, r0_z_4, r0_x_8) * _ArmorColor.xyzx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_6 = r0_xyzw_9.y;
                float r0_z_5 = r0_xyzw_9.z;
                o.sv_Target0.xyz = ((float4(r0_x_9, r0_y_6, r0_z_5, r0_x_9) * _EmissionScale.xxxx)).xyz;
                o.sv_Target0.w = ((sin(((float)(_AnimationSpeed) * _Time.x)) * _AnimationAmount) + _ArmorColor.w);
                return o;
            }
            ENDHLSL
        }
    }
    SubShader
    {
        Tags { "FORCENOSHADOWCASTING"="true" "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent" "RenderType"="Transparent" }
        LOD 100
        Pass
        {
            Tags { "FORCENOSHADOWCASTING"="true" "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _ArmorColor;
                float _ArmorAlpha;
                float4 _EmissionColor;
                float _EmissionScale;
                float4 cb0_values[7];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float4 glstate_lightmodel_ambient;
                float4x4 unity_MatrixVP;
                float4 cb1_values[21];
            };
            struct program7Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
            };
            struct program7Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
            };
            struct program9Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
            };
            struct program9Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program7Output vert(program7Input i)
            {
                program7Output o = (program7Output)0;
                #define UnityObjectToClipPos(v) mul(unity_MatrixVP, v)
                float4 worldPos_xyzw_2 = mad(unity_ObjectToWorld[0], i.position0.xxxx, (i.position0.yyyy * unity_ObjectToWorld[1]));
                float4 worldPos_xyzw_3 = mad(unity_ObjectToWorld[2], i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + unity_ObjectToWorld[3]);
                o.texcoord0.xyzw = mad(unity_ObjectToWorld[3], i.position0.wwww, worldPos_xyzw_3);
                o.sv_Position0.xyzw = UnityObjectToClipPos(worldPos_xyzw_1);
                o.texcoord1.xyz = (float4(0, 0, 0, 0)).xyz;
                return o;
            }
            #pragma fragment frag
            program9Output frag(program9Input i)
            {
                program9Output o = (program9Output)0;
                o.sv_Target0.xyz = (((((mad(glstate_lightmodel_ambient.xyzx, float4(2, 2, 2, 0), _EmissionColor.xyzx)).xyzx * _ArmorColor.xyzx)).xyzx * _EmissionScale.xxxx)).xyz;
                o.sv_Target0.w = _ArmorAlpha;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Unlit"
}
