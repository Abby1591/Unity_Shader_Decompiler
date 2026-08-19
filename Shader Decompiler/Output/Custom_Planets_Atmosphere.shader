Shader "Custom/Planets_Atmosphere"
{
    Properties
    {
        _Highatmospherecolor ("High atmosphere color", Color) = (0.5,0.5,0.5,0)
        _Lowatmospherecolor ("Low atmosphere color", Color) = (0.5,0.5,0.5,1)
        _Inneratmosphere ("Inner atmosphere", Color) = (0.5,0.5,0.5,1)
        _Outeratmospherelimit ("Outer atmosphere limit", Range(0, 1)) = 0.548887
        _Outeratmopsheredensity ("Outer atmopshere density", Range(0, 1)) = 1
        _Inneratmopsheredensity ("Inner atmopshere density", Range(0, 1)) = 0.08092485
        _Innerouterlimit ("Inner outer limit", Range(0, 1)) = 0.6647399
        _Inneroutersmoothness ("Inner outer smoothness", Range(0, 1)) = 0.2572428
        _DisplacementAtmosphere ("Displacement atmosphere", Range(0, 0.1)) = 0.1
    }
    SubShader
    {
        Tags { "IGNOREPROJECTOR"="true" "QUEUE"="Transparent" "RenderType"="Transparent" }
        LOD 200
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDBASE" "QUEUE"="Transparent" "RenderType"="Transparent" "SHADOWSUPPORT"="true" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Blend SrcAlpha OneMinusSrcColor
            HLSLPROGRAM
            cbuffer _Globals : register(b0)
            {
                float4 _LightColor0;
                float4 _Highatmospherecolor;
                float4 _Lowatmospherecolor;
                float _Outeratmopsheredensity;
                float _Inneratmopsheredensity;
                float _Innerouterlimit;
                float _Inneroutersmoothness;
                float _Outeratmospherelimit;
                float4 _Inneratmosphere;
                float _DisplacementAtmosphere;
                float4 cb0_values[9];
            };
            cbuffer UnityPerDraw : register(b1)
            {
                float4x4 unity_ObjectToWorld;
                float4x4 unity_WorldToObject;
                float3 _WorldSpaceCameraPos;
                float4 cb1_values[7];
            };
            cbuffer UnityPerFrame : register(b2)
            {
                float4 _WorldSpaceLightPos0;
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
            };
            struct program10Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
            };
            struct program10Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program1Output vert(program1Input i)
            {
                program1Output o = (program1Output)0;
                float4 r0_xyzw_3 = ((rsqrt(dot(i.normal0.xyzx, i.normal0.xyzx))).xxxx * i.normal0.xyzx);
                float r0_x_3 = r0_xyzw_3.x;
                float r0_y_1 = r0_xyzw_3.y;
                float r0_z_1 = r0_xyzw_3.z;
                float4 r0_xyzw_4 = (float4(r0_x_3, r0_y_1, r0_z_1, r0_x_3) * _DisplacementAtmosphere.xxxx);
                float r0_x_4 = r0_xyzw_4.x;
                float r0_y_2 = r0_xyzw_4.y;
                float r0_z_2 = r0_xyzw_4.z;
                float r0_w_1 = 0;
                float4 r0_xyzw_5 = (float4(r0_x_4, r0_y_2, r0_z_2, r0_w_1) + i.position0.xyzw);
                float4 r1_xyzw_3 = mad(unity_ObjectToWorld[2], r0_xyzw_5.zzzz, mad(unity_ObjectToWorld[0], r0_xyzw_5.xxxx, (r0_xyzw_5.yyyy * unity_ObjectToWorld[1])));
                o.texcoord0.xyzw = mad(unity_ObjectToWorld[3], r0_xyzw_5.wwww, r1_xyzw_3);
                float4 r0_xyzw_6 = (r1_xyzw_3 + unity_ObjectToWorld[3]);
                o.sv_Position0.xyzw = mad(unity_MatrixVP[3], r0_xyzw_6.wwww, mad(unity_MatrixVP[2], r0_xyzw_6.zzzz, mad(unity_MatrixVP[0], r0_xyzw_6.xxxx, (r0_xyzw_6.yyyy * unity_MatrixVP[1]))));
                float worldNormal_x_7 = dot(i.normal0.xyzx, unity_WorldToObject[0].xyzx);
                float worldNormal_y_5 = dot(i.normal0.xyzx, unity_WorldToObject[1].xyzx);
                float worldNormal_z_5 = dot(i.normal0.xyzx, unity_WorldToObject[2].xyzx);
                float r0_w_4 = dot(float4(worldNormal_x_7, worldNormal_y_5, worldNormal_z_5, worldNormal_x_7), float4(worldNormal_x_7, worldNormal_y_5, worldNormal_z_5, worldNormal_x_7));
                float r0_w_5 = rsqrt(r0_w_4);
                o.texcoord1.xyz = ((r0_w_5.xxxx * float4(worldNormal_x_7, worldNormal_y_5, worldNormal_z_5, worldNormal_x_7))).xyz;
                return o;
            }
            #pragma fragment frag
            program10Output frag(program10Input i)
            {
                program10Output o = (program10Output)0;
                float3 r0_xyz_1 = ((-i.texcoord0.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float r0_w_3 = dot(i.texcoord1.xyzx, i.texcoord1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float3 unitWorldNormal_xyz_1 = ((r0_w_4.xxxx * i.texcoord1.xyzx)).xyz;
                float r0_x_5 = (max(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0) + 1);
                float r0_y_3 = (-_Inneroutersmoothness + _Innerouterlimit);
                float r0_y_4 = max(r0_y_3, 0);
                float r0_z_3 = (-r0_y_4 + r0_x_5);
                float r0_w_5 = (_Inneroutersmoothness + _Innerouterlimit);
                float r0_w_6 = min(r0_w_5, 1);
                float r0_y_5 = (-r0_y_4 + r0_w_6);
                float r0_y_6 = ((float4(1, 1, 1, 1) / r0_y_5)).y;
                float r0_y_7 = (r0_y_6 * r0_z_3);
                float r0_z_4 = mad(r0_y_7, -2, 3);
                float r0_y_8 = (r0_y_7 * r0_y_7);
                float r0_y_9 = (r0_y_8 * r0_z_4);
                float r0_z_5 = ((float4(1, 1, 1, 1) / _Outeratmospherelimit)).z;
                float r0_x_9 = (r0_z_5 * exp2((log2(r0_x_5) * 7)));
                float r0_z_6 = mad(r0_x_9, -2, 3);
                float r0_x_10 = (r0_x_9 * r0_x_9);
                float r0_w_7 = (r0_x_10 * r0_z_6);
                float4 r0_xyzw_10 = mad(r0_y_9.xxxx, (((mad(r0_w_7.xxxx, ((_Highatmospherecolor.xyzx + -_Lowatmospherecolor.xyzx)).xyzx, _Lowatmospherecolor.xyzx)).xyzx + -_Inneratmosphere.xyzx)).xxyz, _Inneratmosphere.xxyz);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_7 = r0_xyzw_10.z;
                float r0_w_8 = r0_xyzw_10.w;
                float r1_w_1 = dot(_WorldSpaceLightPos0.xyzx, _WorldSpaceLightPos0.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float3 lightDir_xyz_4 = ((r1_w_2.xxxx * _WorldSpaceLightPos0.xyzx)).xyz;
                float nDotL_x_2 = dot(unitWorldNormal_xyz_1.xyzx, lightDir_xyz_4.xyzx);
                float r1_y_2 = mad(nDotL_x_2, 0.875, 0.125);
                o.sv_Target0.w = (mad(r0_y_9, mad(mad(-r0_z_6, r0_x_10, 1), _Outeratmopsheredensity, -_Inneratmopsheredensity), _Inneratmopsheredensity) * (nDotL_x_2 + nDotL_x_2));
                float4 r1_xyzw_4 = ((max(r1_y_2, 0)).xxxx * _LightColor0.xyzx);
                float r1_x_4 = r1_xyzw_4.x;
                float r1_y_3 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                o.sv_Target0.xyz = ((float4(r0_y_10, r0_z_7, r0_w_8, r0_y_10) * float4(r1_x_4, r1_y_3, r1_z_2, r1_x_4))).xyz;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Offset -1, -1
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4 _Highatmospherecolor;
                float4x4 unity_WorldToObject;
                float4 _Lowatmospherecolor;
                float _Outeratmopsheredensity;
                float _Inneratmopsheredensity;
                float _Innerouterlimit;
                float _Inneroutersmoothness;
                float _Outeratmospherelimit;
                float4 _Inneratmosphere;
                float _DisplacementAtmosphere;
                float4 cb0_values[12];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            Texture2D t0 : register(t0);
            struct program16Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
            };
            struct program16Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program25Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program25Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program16Output vert(program16Input i)
            {
                program16Output o = (program16Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.texcoord0.xyzw = r0_xyzw_4;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_WorldToObject[1].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.zzzz, (mad(unity_ObjectToWorld[2].xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_ObjectToWorld[3].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program25Output frag(program25Input i)
            {
                program25Output o = (program25Output)0;
                float3 r0_xyz_1 = ((-i.texcoord0.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float r0_w_3 = dot(i.texcoord1.xyzx, i.texcoord1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float3 unitWorldNormal_xyz_1 = ((r0_w_4.xxxx * i.texcoord1.xyzx)).xyz;
                float r0_x_5 = (max(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0) + 1);
                float r0_y_3 = (-cb0_values[9].w + cb0_values[9].z);
                float r0_y_4 = max(r0_y_3, 0);
                float r0_z_3 = (-r0_y_4 + r0_x_5);
                float r0_w_5 = (cb0_values[9].w + cb0_values[9].z);
                float r0_w_6 = min(r0_w_5, 1);
                float r0_y_5 = (-r0_y_4 + r0_w_6);
                float r0_y_6 = ((float4(1, 1, 1, 1) / r0_y_5)).y;
                float r0_y_7 = (r0_y_6 * r0_z_3);
                float r0_z_4 = mad(r0_y_7, -2, 3);
                float r0_y_8 = (r0_y_7 * r0_y_7);
                float r0_y_9 = (r0_y_8 * r0_z_4);
                float r0_z_5 = ((float4(1, 1, 1, 1) / cb0_values[10].x)).z;
                float r0_x_9 = (r0_z_5 * exp2((log2(r0_x_5) * 7)));
                float r0_z_6 = mad(r0_x_9, -2, 3);
                float r0_x_10 = (r0_x_9 * r0_x_9);
                float r0_w_7 = (r0_x_10 * r0_z_6);
                float4 r0_xyzw_10 = mad(r0_y_9.xxxx, (((mad(r0_w_7.xxxx, ((_Inneratmosphere.xyzx + -cb0_values[8].xyzx)).xyzx, cb0_values[8].xyzx)).xyzx + -cb0_values[11].xyzx)).xxyz, cb0_values[11].xxyz);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_7 = r0_xyzw_10.z;
                float r0_w_8 = r0_xyzw_10.w;
                float3 r2_xyz_4 = (mad(_WorldSpaceLightPos0.wwww, -i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r1_w_1 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float r1_x_2 = dot(unitWorldNormal_xyz_1.xyzx, ((r1_w_2.xxxx * r2_xyz_4.xyzx)).xyzx);
                float r1_y_2 = mad(r1_x_2, 0.875, 0.125);
                float r0_x_14 = (mad(r0_y_9, mad(mad(-r0_z_6, r0_x_10, 1), cb0_values[9].x, -cb0_values[9].y), cb0_values[9].y) * (r1_x_2 + r1_x_2));
                float r1_y_3 = dot(i.texcoord2.xyzx, i.texcoord2.xyzx);
                float4 r2_xyzw_6 = t0.Sample(s0, r1_y_3.xxxx);
                float4 r1_xyzw_4 = (r2_xyzw_6.xxxx * cb0_values[6].xxyz);
                float r1_y_4 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                float r1_w_3 = r1_xyzw_4.w;
                float4 r1_xyzw_5 = (float4(r1_y_4, r1_z_2, r1_w_3, r1_y_4) * (max(r1_y_2, 0)).xxxx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_5 = r1_xyzw_5.y;
                float r1_z_3 = r1_xyzw_5.z;
                float4 r0_xyzw_11 = (float4(r0_y_10, r0_y_10, r0_z_7, r0_w_8) * float4(r1_x_5, r1_x_5, r1_y_5, r1_z_3));
                float r0_y_11 = r0_xyzw_11.y;
                float r0_z_8 = r0_xyzw_11.z;
                float r0_w_9 = r0_xyzw_11.w;
                o.sv_Target0.xyz = ((r0_x_14.xxxx * float4(r0_y_11, r0_z_8, r0_w_9, r0_y_11))).xyz;
                o.sv_Target0.w = 0;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Offset -1, -1
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4 _Highatmospherecolor;
                float4x4 unity_WorldToObject;
                float4 _Lowatmospherecolor;
                float _Outeratmopsheredensity;
                float _Inneratmopsheredensity;
                float _Innerouterlimit;
                float _Inneroutersmoothness;
                float _Outeratmospherelimit;
                float4 _Inneratmosphere;
                float _DisplacementAtmosphere;
                float4 cb0_values[12];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            Texture2D t0 : register(t0);
            struct program20Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
            };
            struct program20Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct program29Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct program29Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program20Output vert(program20Input i)
            {
                program20Output o = (program20Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.texcoord0.xyzw = r0_xyzw_4;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xy = (mad(unity_WorldToObject[1].xyxx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[0].xyxx, r0_xyzw_4.zzzz, (mad(unity_ObjectToWorld[2].xyxx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_ObjectToWorld[3].xyxx)).xyxx)).xyxx)).xyxx)).xy;
                return o;
            }
            #pragma fragment frag
            program29Output frag(program29Input i)
            {
                program29Output o = (program29Output)0;
                float3 r0_xyz_1 = ((-i.texcoord0.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float r0_w_3 = dot(i.texcoord1.xyzx, i.texcoord1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float3 unitWorldNormal_xyz_1 = ((r0_w_4.xxxx * i.texcoord1.xyzx)).xyz;
                float r0_x_5 = (max(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0) + 1);
                float r0_y_3 = (-cb0_values[9].w + cb0_values[9].z);
                float r0_y_4 = max(r0_y_3, 0);
                float r0_z_3 = (-r0_y_4 + r0_x_5);
                float r0_w_5 = (cb0_values[9].w + cb0_values[9].z);
                float r0_w_6 = min(r0_w_5, 1);
                float r0_y_5 = (-r0_y_4 + r0_w_6);
                float r0_y_6 = ((float4(1, 1, 1, 1) / r0_y_5)).y;
                float r0_y_7 = (r0_y_6 * r0_z_3);
                float r0_z_4 = mad(r0_y_7, -2, 3);
                float r0_y_8 = (r0_y_7 * r0_y_7);
                float r0_y_9 = (r0_y_8 * r0_z_4);
                float r0_z_5 = ((float4(1, 1, 1, 1) / cb0_values[10].x)).z;
                float r0_x_9 = (r0_z_5 * exp2((log2(r0_x_5) * 7)));
                float r0_z_6 = mad(r0_x_9, -2, 3);
                float r0_x_10 = (r0_x_9 * r0_x_9);
                float r0_w_7 = (r0_x_10 * r0_z_6);
                float4 r0_xyzw_10 = mad(r0_y_9.xxxx, (((mad(r0_w_7.xxxx, ((_Inneratmosphere.xyzx + -cb0_values[8].xyzx)).xyzx, cb0_values[8].xyzx)).xyzx + -cb0_values[11].xyzx)).xxyz, cb0_values[11].xxyz);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_7 = r0_xyzw_10.z;
                float r0_w_8 = r0_xyzw_10.w;
                float3 r2_xyz_4 = (mad(_WorldSpaceLightPos0.wwww, -i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r1_w_1 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float r1_x_2 = dot(unitWorldNormal_xyz_1.xyzx, ((r1_w_2.xxxx * r2_xyz_4.xyzx)).xyzx);
                float r1_y_2 = mad(r1_x_2, 0.875, 0.125);
                float r0_x_14 = (mad(r0_y_9, mad(mad(-r0_z_6, r0_x_10, 1), cb0_values[9].x, -cb0_values[9].y), cb0_values[9].y) * (r1_x_2 + r1_x_2));
                float4 r2_xyzw_6 = t0.Sample(s0, i.texcoord2.xyxx);
                float4 r1_xyzw_3 = (r2_xyzw_6.wwww * cb0_values[6].xxyz);
                float r1_y_3 = r1_xyzw_3.y;
                float r1_z_2 = r1_xyzw_3.z;
                float r1_w_3 = r1_xyzw_3.w;
                float4 r1_xyzw_5 = (float4(r1_y_3, r1_z_2, r1_w_3, r1_y_3) * (max(r1_y_2, 0)).xxxx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_4 = r1_xyzw_5.y;
                float r1_z_3 = r1_xyzw_5.z;
                float4 r0_xyzw_11 = (float4(r0_y_10, r0_y_10, r0_z_7, r0_w_8) * float4(r1_x_5, r1_x_5, r1_y_4, r1_z_3));
                float r0_y_11 = r0_xyzw_11.y;
                float r0_z_8 = r0_xyzw_11.z;
                float r0_w_9 = r0_xyzw_11.w;
                o.sv_Target0.xyz = ((r0_x_14.xxxx * float4(r0_y_11, r0_z_8, r0_w_9, r0_y_11))).xyz;
                o.sv_Target0.w = 0;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Offset -1, -1
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4 _Highatmospherecolor;
                float4x4 unity_WorldToObject;
                float4 _Lowatmospherecolor;
                float _Outeratmopsheredensity;
                float _Inneratmopsheredensity;
                float _Innerouterlimit;
                float _Inneroutersmoothness;
                float _Outeratmospherelimit;
                float4 _Inneratmosphere;
                float _DisplacementAtmosphere;
                float4 cb0_values[12];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            TextureCube t1 : register(t1);
            struct program20Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
            };
            struct program20Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct program28Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program28Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program20Output vert(program20Input i)
            {
                program20Output o = (program20Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.texcoord0.xyzw = r0_xyzw_4;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xy = (mad(unity_WorldToObject[1].xyxx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[0].xyxx, r0_xyzw_4.zzzz, (mad(unity_ObjectToWorld[2].xyxx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_ObjectToWorld[3].xyxx)).xyxx)).xyxx)).xyxx)).xy;
                return o;
            }
            #pragma fragment frag
            program28Output frag(program28Input i)
            {
                program28Output o = (program28Output)0;
                float3 r0_xyz_1 = ((-i.texcoord0.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float r0_w_3 = dot(i.texcoord1.xyzx, i.texcoord1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float3 unitWorldNormal_xyz_1 = ((r0_w_4.xxxx * i.texcoord1.xyzx)).xyz;
                float r0_x_5 = (max(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0) + 1);
                float r0_y_3 = (-cb0_values[9].w + cb0_values[9].z);
                float r0_y_4 = max(r0_y_3, 0);
                float r0_z_3 = (-r0_y_4 + r0_x_5);
                float r0_w_5 = (cb0_values[9].w + cb0_values[9].z);
                float r0_w_6 = min(r0_w_5, 1);
                float r0_y_5 = (-r0_y_4 + r0_w_6);
                float r0_y_6 = ((float4(1, 1, 1, 1) / r0_y_5)).y;
                float r0_y_7 = (r0_y_6 * r0_z_3);
                float r0_z_4 = mad(r0_y_7, -2, 3);
                float r0_y_8 = (r0_y_7 * r0_y_7);
                float r0_y_9 = (r0_y_8 * r0_z_4);
                float r0_z_5 = ((float4(1, 1, 1, 1) / cb0_values[10].x)).z;
                float r0_x_9 = (r0_z_5 * exp2((log2(r0_x_5) * 7)));
                float r0_z_6 = mad(r0_x_9, -2, 3);
                float r0_x_10 = (r0_x_9 * r0_x_9);
                float r0_w_7 = (r0_x_10 * r0_z_6);
                float4 r0_xyzw_10 = mad(r0_y_9.xxxx, (((mad(r0_w_7.xxxx, ((_Inneratmosphere.xyzx + -cb0_values[8].xyzx)).xyzx, cb0_values[8].xyzx)).xyzx + -cb0_values[11].xyzx)).xxyz, cb0_values[11].xxyz);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_7 = r0_xyzw_10.z;
                float r0_w_8 = r0_xyzw_10.w;
                float3 r2_xyz_4 = (mad(_WorldSpaceLightPos0.wwww, -i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r1_w_1 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float r1_x_2 = dot(unitWorldNormal_xyz_1.xyzx, ((r1_w_2.xxxx * r2_xyz_4.xyzx)).xyzx);
                float r1_y_2 = mad(r1_x_2, 0.875, 0.125);
                float r0_x_14 = (mad(r0_y_9, mad(mad(-r0_z_6, r0_x_10, 1), cb0_values[9].x, -cb0_values[9].y), cb0_values[9].y) * (r1_x_2 + r1_x_2));
                float r1_y_3 = dot(i.texcoord2.xyzx, i.texcoord2.xyzx);
                float4 r2_xyzw_6 = t0.Sample(s1, r1_y_3.xxxx);
                float4 r3_xyzw_1 = t1.Sample(s0, i.texcoord2.xyzx);
                float r1_y_4 = (r2_xyzw_6.x * r3_xyzw_1.w);
                float4 r1_xyzw_5 = (r1_y_4.xxxx * cb0_values[6].xxyz);
                float r1_y_5 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float r1_w_3 = r1_xyzw_5.w;
                float r1_x_5 = ((float4(r1_y_5, r1_z_2, r1_w_3, r1_y_5) * (max(r1_y_2, 0)).xxxx)).x;
                float4 r1_xyzw_6 = (float4(r1_y_5, r1_z_2, r1_w_3, r1_y_5) * (max(r1_y_2, 0)).xxxx);
                float r1_y_6 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                float4 r0_xyzw_11 = (float4(r0_y_10, r0_y_10, r0_z_7, r0_w_8) * float4(r1_x_5, r1_x_5, r1_y_6, r1_z_3));
                float r0_y_11 = r0_xyzw_11.y;
                float r0_z_8 = r0_xyzw_11.z;
                float r0_w_9 = r0_xyzw_11.w;
                o.sv_Target0.xyz = ((r0_x_14.xxxx * float4(r0_y_11, r0_z_8, r0_w_9, r0_y_11))).xyz;
                o.sv_Target0.w = 0;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Offset -1, -1
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4 _Highatmospherecolor;
                float4x4 unity_WorldToObject;
                float4 _Lowatmospherecolor;
                float _Outeratmopsheredensity;
                float _Inneratmopsheredensity;
                float _Innerouterlimit;
                float _Inneroutersmoothness;
                float _Outeratmospherelimit;
                float4 _Inneratmosphere;
                float _DisplacementAtmosphere;
                float4 cb0_values[12];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            struct program20Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
            };
            struct program20Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct program27Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
            };
            struct program27Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program20Output vert(program20Input i)
            {
                program20Output o = (program20Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.texcoord0.xyzw = r0_xyzw_4;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xy = (mad(unity_WorldToObject[1].xyxx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[0].xyxx, r0_xyzw_4.zzzz, (mad(unity_ObjectToWorld[2].xyxx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_ObjectToWorld[3].xyxx)).xyxx)).xyxx)).xyxx)).xy;
                return o;
            }
            #pragma fragment frag
            program27Output frag(program27Input i)
            {
                program27Output o = (program27Output)0;
                float4 r0_xyzw_3 = t0.Sample(s0, ((((i.texcoord2.xyxx / i.texcoord2.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx);
                float r0_y_4 = dot(i.texcoord2.xyzx, i.texcoord2.xyzx);
                float4 r1_xyzw_1 = t1.Sample(s1, r0_y_4.xxxx);
                float4 r0_xyzw_8 = ((((r0_xyzw_3.w * asfloat(asint((float)((0 < i.texcoord2.z))) & asint(1065353216))) * r1_xyzw_1.x)).xxxx * cb0_values[6].xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_5 = r0_xyzw_8.y;
                float r0_z_2 = r0_xyzw_8.z;
                float3 r1_xyz_2 = (mad(_WorldSpaceLightPos0.wwww, -i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_2 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_3 = rsqrt(r0_w_2);
                float r0_w_4 = dot(i.texcoord1.xyzx, i.texcoord1.xyzx);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 unitWorldNormal_xyz_1 = ((r0_w_5.xxxx * i.texcoord1.xyzx)).xyz;
                float r0_w_6 = dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_3.xxxx * r1_xyz_2.xyzx)).xyzx);
                float r0_w_7 = (r0_w_6 + r0_w_6);
                float4 r0_xyzw_9 = (float4(r0_x_8, r0_y_5, r0_z_2, r0_x_8) * (max(mad(r0_w_6, 0.875, 0.125), 0)).xxxx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_6 = r0_xyzw_9.y;
                float r0_z_3 = r0_xyzw_9.z;
                float4 r1_xyzw_6 = (-i.texcoord0.xyzx + _WorldSpaceCameraPos.xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_4 = r1_xyzw_6.z;
                float r1_w_2 = dot(float4(r1_x_6, r1_y_4, r1_z_4, r1_x_6), float4(r1_x_6, r1_y_4, r1_z_4, r1_x_6));
                float r1_w_3 = rsqrt(r1_w_2);
                float4 r1_xyzw_7 = (r1_w_3.xxxx * float4(r1_x_6, r1_y_4, r1_z_4, r1_x_6));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_z_5 = r1_xyzw_7.z;
                float r1_x_10 = (max(dot(unitWorldNormal_xyz_1.xyzx, float4(r1_x_7, r1_y_5, r1_z_5, r1_x_7)), 0) + 1);
                float r1_y_6 = (-cb0_values[9].w + cb0_values[9].z);
                float r1_y_7 = max(r1_y_6, 0);
                float r1_z_6 = (-r1_y_7 + r1_x_10);
                float r1_w_4 = (cb0_values[9].w + cb0_values[9].z);
                float r1_w_5 = min(r1_w_4, 1);
                float r1_y_8 = (-r1_y_7 + r1_w_5);
                float r1_y_9 = ((float4(1, 1, 1, 1) / r1_y_8)).y;
                float r1_y_10 = (r1_y_9 * r1_z_6);
                float r1_z_7 = mad(r1_y_10, -2, 3);
                float r1_y_11 = (r1_y_10 * r1_y_10);
                float r1_y_12 = (r1_y_11 * r1_z_7);
                float r1_z_8 = ((float4(1, 1, 1, 1) / cb0_values[10].x)).z;
                float r1_x_14 = (r1_z_8 * exp2((log2(r1_x_10) * 7)));
                float r1_z_9 = mad(r1_x_14, -2, 3);
                float r1_x_15 = (r1_x_14 * r1_x_14);
                float r1_w_6 = (r1_x_15 * r1_z_9);
                float r0_w_8 = (r0_w_7 * mad(r1_y_12, mad(mad(-r1_z_9, r1_x_15, 1), cb0_values[9].x, -cb0_values[9].y), cb0_values[9].y));
                float4 r1_xyzw_19 = mad(r1_w_6.xxxx, ((_Inneratmosphere.xyzx + -cb0_values[8].xyzx)).xxyz, cb0_values[8].xxyz);
                float r1_x_19 = r1_xyzw_19.x;
                float r1_z_10 = r1_xyzw_19.z;
                float r1_w_7 = r1_xyzw_19.w;
                float4 r1_xyzw_20 = (float4(r1_x_19, r1_x_19, r1_z_10, r1_w_7) + -cb0_values[11].xxyz);
                float r1_x_20 = r1_xyzw_20.x;
                float r1_z_11 = r1_xyzw_20.z;
                float r1_w_8 = r1_xyzw_20.w;
                float4 r1_xyzw_21 = mad(r1_y_12.xxxx, float4(r1_x_20, r1_z_11, r1_w_8, r1_x_20), cb0_values[11].xyzx);
                float r1_x_21 = r1_xyzw_21.x;
                float r1_y_13 = r1_xyzw_21.y;
                float r1_z_12 = r1_xyzw_21.z;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_y_6, r0_z_3, r0_x_9) * float4(r1_x_21, r1_y_13, r1_z_12, r1_x_21));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_7 = r0_xyzw_10.y;
                float r0_z_4 = r0_xyzw_10.z;
                o.sv_Target0.xyz = ((r0_w_8.xxxx * float4(r0_x_10, r0_y_7, r0_z_4, r0_x_10))).xyz;
                o.sv_Target0.w = 0;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Offset -1, -1
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4 _Highatmospherecolor;
                float4x4 unity_WorldToObject;
                float4 _Lowatmospherecolor;
                float _Outeratmopsheredensity;
                float _Inneratmopsheredensity;
                float _Innerouterlimit;
                float _Inneroutersmoothness;
                float _Outeratmospherelimit;
                float4 _Inneratmosphere;
                float _DisplacementAtmosphere;
                float4 cb0_values[12];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            Texture2D t0 : register(t0);
            struct program20Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
            };
            struct program20Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct program25Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program25Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program20Output vert(program20Input i)
            {
                program20Output o = (program20Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.texcoord0.xyzw = r0_xyzw_4;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xy = (mad(unity_WorldToObject[1].xyxx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[0].xyxx, r0_xyzw_4.zzzz, (mad(unity_ObjectToWorld[2].xyxx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_ObjectToWorld[3].xyxx)).xyxx)).xyxx)).xyxx)).xy;
                return o;
            }
            #pragma fragment frag
            program25Output frag(program25Input i)
            {
                program25Output o = (program25Output)0;
                float3 r0_xyz_1 = ((-i.texcoord0.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float r0_w_3 = dot(i.texcoord1.xyzx, i.texcoord1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float3 unitWorldNormal_xyz_1 = ((r0_w_4.xxxx * i.texcoord1.xyzx)).xyz;
                float r0_x_5 = (max(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0) + 1);
                float r0_y_3 = (-cb0_values[9].w + cb0_values[9].z);
                float r0_y_4 = max(r0_y_3, 0);
                float r0_z_3 = (-r0_y_4 + r0_x_5);
                float r0_w_5 = (cb0_values[9].w + cb0_values[9].z);
                float r0_w_6 = min(r0_w_5, 1);
                float r0_y_5 = (-r0_y_4 + r0_w_6);
                float r0_y_6 = ((float4(1, 1, 1, 1) / r0_y_5)).y;
                float r0_y_7 = (r0_y_6 * r0_z_3);
                float r0_z_4 = mad(r0_y_7, -2, 3);
                float r0_y_8 = (r0_y_7 * r0_y_7);
                float r0_y_9 = (r0_y_8 * r0_z_4);
                float r0_z_5 = ((float4(1, 1, 1, 1) / cb0_values[10].x)).z;
                float r0_x_9 = (r0_z_5 * exp2((log2(r0_x_5) * 7)));
                float r0_z_6 = mad(r0_x_9, -2, 3);
                float r0_x_10 = (r0_x_9 * r0_x_9);
                float r0_w_7 = (r0_x_10 * r0_z_6);
                float4 r0_xyzw_10 = mad(r0_y_9.xxxx, (((mad(r0_w_7.xxxx, ((_Inneratmosphere.xyzx + -cb0_values[8].xyzx)).xyzx, cb0_values[8].xyzx)).xyzx + -cb0_values[11].xyzx)).xxyz, cb0_values[11].xxyz);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_7 = r0_xyzw_10.z;
                float r0_w_8 = r0_xyzw_10.w;
                float3 r2_xyz_4 = (mad(_WorldSpaceLightPos0.wwww, -i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r1_w_1 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float r1_x_2 = dot(unitWorldNormal_xyz_1.xyzx, ((r1_w_2.xxxx * r2_xyz_4.xyzx)).xyzx);
                float r1_y_2 = mad(r1_x_2, 0.875, 0.125);
                float r0_x_14 = (mad(r0_y_9, mad(mad(-r0_z_6, r0_x_10, 1), cb0_values[9].x, -cb0_values[9].y), cb0_values[9].y) * (r1_x_2 + r1_x_2));
                float r1_y_3 = dot(i.texcoord2.xyzx, i.texcoord2.xyzx);
                float4 r2_xyzw_6 = t0.Sample(s0, r1_y_3.xxxx);
                float4 r1_xyzw_4 = (r2_xyzw_6.xxxx * cb0_values[6].xxyz);
                float r1_y_4 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                float r1_w_3 = r1_xyzw_4.w;
                float4 r1_xyzw_5 = (float4(r1_y_4, r1_z_2, r1_w_3, r1_y_4) * (max(r1_y_2, 0)).xxxx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_5 = r1_xyzw_5.y;
                float r1_z_3 = r1_xyzw_5.z;
                float4 r0_xyzw_11 = (float4(r0_y_10, r0_y_10, r0_z_7, r0_w_8) * float4(r1_x_5, r1_x_5, r1_y_5, r1_z_3));
                float r0_y_11 = r0_xyzw_11.y;
                float r0_z_8 = r0_xyzw_11.z;
                float r0_w_9 = r0_xyzw_11.w;
                o.sv_Target0.xyz = ((r0_x_14.xxxx * float4(r0_y_11, r0_z_8, r0_w_9, r0_y_11))).xyz;
                o.sv_Target0.w = 0;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Offset -1, -1
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4 _Highatmospherecolor;
                float4x4 unity_WorldToObject;
                float4 _Lowatmospherecolor;
                float _Outeratmopsheredensity;
                float _Inneratmopsheredensity;
                float _Innerouterlimit;
                float _Inneroutersmoothness;
                float _Outeratmospherelimit;
                float4 _Inneratmosphere;
                float _DisplacementAtmosphere;
                float4 cb0_values[12];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            Texture2D t0 : register(t0);
            struct program18Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
            };
            struct program18Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
            };
            struct program29Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct program29Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program18Output vert(program18Input i)
            {
                program18Output o = (program18Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.texcoord0.xyzw = r0_xyzw_4;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float4 r1_xyzw_3 = (r0_xyzw_4.yyyy * unity_ObjectToWorld[3]);
                float4 r1_xyzw_4 = mad(unity_ObjectToWorld[2], r0_xyzw_4.xxxx, r1_xyzw_3);
                float4 r1_xyzw_5 = mad(unity_WorldToObject[0], r0_xyzw_4.zzzz, r1_xyzw_4);
                o.texcoord2.xyzw = mad(unity_WorldToObject[1], r0_xyzw_4.wwww, r1_xyzw_5);
                return o;
            }
            #pragma fragment frag
            program29Output frag(program29Input i)
            {
                program29Output o = (program29Output)0;
                float3 r0_xyz_1 = ((-i.texcoord0.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float r0_w_3 = dot(i.texcoord1.xyzx, i.texcoord1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float3 unitWorldNormal_xyz_1 = ((r0_w_4.xxxx * i.texcoord1.xyzx)).xyz;
                float r0_x_5 = (max(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0) + 1);
                float r0_y_3 = (-cb0_values[9].w + cb0_values[9].z);
                float r0_y_4 = max(r0_y_3, 0);
                float r0_z_3 = (-r0_y_4 + r0_x_5);
                float r0_w_5 = (cb0_values[9].w + cb0_values[9].z);
                float r0_w_6 = min(r0_w_5, 1);
                float r0_y_5 = (-r0_y_4 + r0_w_6);
                float r0_y_6 = ((float4(1, 1, 1, 1) / r0_y_5)).y;
                float r0_y_7 = (r0_y_6 * r0_z_3);
                float r0_z_4 = mad(r0_y_7, -2, 3);
                float r0_y_8 = (r0_y_7 * r0_y_7);
                float r0_y_9 = (r0_y_8 * r0_z_4);
                float r0_z_5 = ((float4(1, 1, 1, 1) / cb0_values[10].x)).z;
                float r0_x_9 = (r0_z_5 * exp2((log2(r0_x_5) * 7)));
                float r0_z_6 = mad(r0_x_9, -2, 3);
                float r0_x_10 = (r0_x_9 * r0_x_9);
                float r0_w_7 = (r0_x_10 * r0_z_6);
                float4 r0_xyzw_10 = mad(r0_y_9.xxxx, (((mad(r0_w_7.xxxx, ((_Inneratmosphere.xyzx + -cb0_values[8].xyzx)).xyzx, cb0_values[8].xyzx)).xyzx + -cb0_values[11].xyzx)).xxyz, cb0_values[11].xxyz);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_7 = r0_xyzw_10.z;
                float r0_w_8 = r0_xyzw_10.w;
                float3 r2_xyz_4 = (mad(_WorldSpaceLightPos0.wwww, -i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r1_w_1 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float r1_x_2 = dot(unitWorldNormal_xyz_1.xyzx, ((r1_w_2.xxxx * r2_xyz_4.xyzx)).xyzx);
                float r1_y_2 = mad(r1_x_2, 0.875, 0.125);
                float r0_x_14 = (mad(r0_y_9, mad(mad(-r0_z_6, r0_x_10, 1), cb0_values[9].x, -cb0_values[9].y), cb0_values[9].y) * (r1_x_2 + r1_x_2));
                float4 r2_xyzw_6 = t0.Sample(s0, i.texcoord2.xyxx);
                float4 r1_xyzw_3 = (r2_xyzw_6.wwww * cb0_values[6].xxyz);
                float r1_y_3 = r1_xyzw_3.y;
                float r1_z_2 = r1_xyzw_3.z;
                float r1_w_3 = r1_xyzw_3.w;
                float4 r1_xyzw_5 = (float4(r1_y_3, r1_z_2, r1_w_3, r1_y_3) * (max(r1_y_2, 0)).xxxx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_4 = r1_xyzw_5.y;
                float r1_z_3 = r1_xyzw_5.z;
                float4 r0_xyzw_11 = (float4(r0_y_10, r0_y_10, r0_z_7, r0_w_8) * float4(r1_x_5, r1_x_5, r1_y_4, r1_z_3));
                float r0_y_11 = r0_xyzw_11.y;
                float r0_z_8 = r0_xyzw_11.z;
                float r0_w_9 = r0_xyzw_11.w;
                o.sv_Target0.xyz = ((r0_x_14.xxxx * float4(r0_y_11, r0_z_8, r0_w_9, r0_y_11))).xyz;
                o.sv_Target0.w = 0;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Offset -1, -1
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4 _Highatmospherecolor;
                float4x4 unity_WorldToObject;
                float4 _Lowatmospherecolor;
                float _Outeratmopsheredensity;
                float _Inneratmopsheredensity;
                float _Innerouterlimit;
                float _Inneroutersmoothness;
                float _Outeratmospherelimit;
                float4 _Inneratmosphere;
                float _DisplacementAtmosphere;
                float4 cb0_values[12];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            TextureCube t1 : register(t1);
            struct program18Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
            };
            struct program18Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
            };
            struct program28Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program28Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program18Output vert(program18Input i)
            {
                program18Output o = (program18Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.texcoord0.xyzw = r0_xyzw_4;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float4 r1_xyzw_3 = (r0_xyzw_4.yyyy * unity_ObjectToWorld[3]);
                float4 r1_xyzw_4 = mad(unity_ObjectToWorld[2], r0_xyzw_4.xxxx, r1_xyzw_3);
                float4 r1_xyzw_5 = mad(unity_WorldToObject[0], r0_xyzw_4.zzzz, r1_xyzw_4);
                o.texcoord2.xyzw = mad(unity_WorldToObject[1], r0_xyzw_4.wwww, r1_xyzw_5);
                return o;
            }
            #pragma fragment frag
            program28Output frag(program28Input i)
            {
                program28Output o = (program28Output)0;
                float3 r0_xyz_1 = ((-i.texcoord0.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float r0_w_3 = dot(i.texcoord1.xyzx, i.texcoord1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float3 unitWorldNormal_xyz_1 = ((r0_w_4.xxxx * i.texcoord1.xyzx)).xyz;
                float r0_x_5 = (max(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0) + 1);
                float r0_y_3 = (-cb0_values[9].w + cb0_values[9].z);
                float r0_y_4 = max(r0_y_3, 0);
                float r0_z_3 = (-r0_y_4 + r0_x_5);
                float r0_w_5 = (cb0_values[9].w + cb0_values[9].z);
                float r0_w_6 = min(r0_w_5, 1);
                float r0_y_5 = (-r0_y_4 + r0_w_6);
                float r0_y_6 = ((float4(1, 1, 1, 1) / r0_y_5)).y;
                float r0_y_7 = (r0_y_6 * r0_z_3);
                float r0_z_4 = mad(r0_y_7, -2, 3);
                float r0_y_8 = (r0_y_7 * r0_y_7);
                float r0_y_9 = (r0_y_8 * r0_z_4);
                float r0_z_5 = ((float4(1, 1, 1, 1) / cb0_values[10].x)).z;
                float r0_x_9 = (r0_z_5 * exp2((log2(r0_x_5) * 7)));
                float r0_z_6 = mad(r0_x_9, -2, 3);
                float r0_x_10 = (r0_x_9 * r0_x_9);
                float r0_w_7 = (r0_x_10 * r0_z_6);
                float4 r0_xyzw_10 = mad(r0_y_9.xxxx, (((mad(r0_w_7.xxxx, ((_Inneratmosphere.xyzx + -cb0_values[8].xyzx)).xyzx, cb0_values[8].xyzx)).xyzx + -cb0_values[11].xyzx)).xxyz, cb0_values[11].xxyz);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_7 = r0_xyzw_10.z;
                float r0_w_8 = r0_xyzw_10.w;
                float3 r2_xyz_4 = (mad(_WorldSpaceLightPos0.wwww, -i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r1_w_1 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float r1_x_2 = dot(unitWorldNormal_xyz_1.xyzx, ((r1_w_2.xxxx * r2_xyz_4.xyzx)).xyzx);
                float r1_y_2 = mad(r1_x_2, 0.875, 0.125);
                float r0_x_14 = (mad(r0_y_9, mad(mad(-r0_z_6, r0_x_10, 1), cb0_values[9].x, -cb0_values[9].y), cb0_values[9].y) * (r1_x_2 + r1_x_2));
                float r1_y_3 = dot(i.texcoord2.xyzx, i.texcoord2.xyzx);
                float4 r2_xyzw_6 = t0.Sample(s1, r1_y_3.xxxx);
                float4 r3_xyzw_1 = t1.Sample(s0, i.texcoord2.xyzx);
                float r1_y_4 = (r2_xyzw_6.x * r3_xyzw_1.w);
                float4 r1_xyzw_5 = (r1_y_4.xxxx * cb0_values[6].xxyz);
                float r1_y_5 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float r1_w_3 = r1_xyzw_5.w;
                float r1_x_5 = ((float4(r1_y_5, r1_z_2, r1_w_3, r1_y_5) * (max(r1_y_2, 0)).xxxx)).x;
                float4 r1_xyzw_6 = (float4(r1_y_5, r1_z_2, r1_w_3, r1_y_5) * (max(r1_y_2, 0)).xxxx);
                float r1_y_6 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                float4 r0_xyzw_11 = (float4(r0_y_10, r0_y_10, r0_z_7, r0_w_8) * float4(r1_x_5, r1_x_5, r1_y_6, r1_z_3));
                float r0_y_11 = r0_xyzw_11.y;
                float r0_z_8 = r0_xyzw_11.z;
                float r0_w_9 = r0_xyzw_11.w;
                o.sv_Target0.xyz = ((r0_x_14.xxxx * float4(r0_y_11, r0_z_8, r0_w_9, r0_y_11))).xyz;
                o.sv_Target0.w = 0;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Offset -1, -1
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4 _Highatmospherecolor;
                float4x4 unity_WorldToObject;
                float4 _Lowatmospherecolor;
                float _Outeratmopsheredensity;
                float _Inneratmopsheredensity;
                float _Innerouterlimit;
                float _Inneroutersmoothness;
                float _Outeratmospherelimit;
                float4 _Inneratmosphere;
                float _DisplacementAtmosphere;
                float4 cb0_values[12];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            struct program18Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
            };
            struct program18Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
            };
            struct program27Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
            };
            struct program27Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program18Output vert(program18Input i)
            {
                program18Output o = (program18Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.texcoord0.xyzw = r0_xyzw_4;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float4 r1_xyzw_3 = (r0_xyzw_4.yyyy * unity_ObjectToWorld[3]);
                float4 r1_xyzw_4 = mad(unity_ObjectToWorld[2], r0_xyzw_4.xxxx, r1_xyzw_3);
                float4 r1_xyzw_5 = mad(unity_WorldToObject[0], r0_xyzw_4.zzzz, r1_xyzw_4);
                o.texcoord2.xyzw = mad(unity_WorldToObject[1], r0_xyzw_4.wwww, r1_xyzw_5);
                return o;
            }
            #pragma fragment frag
            program27Output frag(program27Input i)
            {
                program27Output o = (program27Output)0;
                float4 r0_xyzw_3 = t0.Sample(s0, ((((i.texcoord2.xyxx / i.texcoord2.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx);
                float r0_y_4 = dot(i.texcoord2.xyzx, i.texcoord2.xyzx);
                float4 r1_xyzw_1 = t1.Sample(s1, r0_y_4.xxxx);
                float4 r0_xyzw_8 = ((((r0_xyzw_3.w * asfloat(asint((float)((0 < i.texcoord2.z))) & asint(1065353216))) * r1_xyzw_1.x)).xxxx * cb0_values[6].xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_5 = r0_xyzw_8.y;
                float r0_z_2 = r0_xyzw_8.z;
                float3 r1_xyz_2 = (mad(_WorldSpaceLightPos0.wwww, -i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_2 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_3 = rsqrt(r0_w_2);
                float r0_w_4 = dot(i.texcoord1.xyzx, i.texcoord1.xyzx);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 unitWorldNormal_xyz_1 = ((r0_w_5.xxxx * i.texcoord1.xyzx)).xyz;
                float r0_w_6 = dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_3.xxxx * r1_xyz_2.xyzx)).xyzx);
                float r0_w_7 = (r0_w_6 + r0_w_6);
                float4 r0_xyzw_9 = (float4(r0_x_8, r0_y_5, r0_z_2, r0_x_8) * (max(mad(r0_w_6, 0.875, 0.125), 0)).xxxx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_6 = r0_xyzw_9.y;
                float r0_z_3 = r0_xyzw_9.z;
                float4 r1_xyzw_6 = (-i.texcoord0.xyzx + _WorldSpaceCameraPos.xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_4 = r1_xyzw_6.z;
                float r1_w_2 = dot(float4(r1_x_6, r1_y_4, r1_z_4, r1_x_6), float4(r1_x_6, r1_y_4, r1_z_4, r1_x_6));
                float r1_w_3 = rsqrt(r1_w_2);
                float4 r1_xyzw_7 = (r1_w_3.xxxx * float4(r1_x_6, r1_y_4, r1_z_4, r1_x_6));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_z_5 = r1_xyzw_7.z;
                float r1_x_10 = (max(dot(unitWorldNormal_xyz_1.xyzx, float4(r1_x_7, r1_y_5, r1_z_5, r1_x_7)), 0) + 1);
                float r1_y_6 = (-cb0_values[9].w + cb0_values[9].z);
                float r1_y_7 = max(r1_y_6, 0);
                float r1_z_6 = (-r1_y_7 + r1_x_10);
                float r1_w_4 = (cb0_values[9].w + cb0_values[9].z);
                float r1_w_5 = min(r1_w_4, 1);
                float r1_y_8 = (-r1_y_7 + r1_w_5);
                float r1_y_9 = ((float4(1, 1, 1, 1) / r1_y_8)).y;
                float r1_y_10 = (r1_y_9 * r1_z_6);
                float r1_z_7 = mad(r1_y_10, -2, 3);
                float r1_y_11 = (r1_y_10 * r1_y_10);
                float r1_y_12 = (r1_y_11 * r1_z_7);
                float r1_z_8 = ((float4(1, 1, 1, 1) / cb0_values[10].x)).z;
                float r1_x_14 = (r1_z_8 * exp2((log2(r1_x_10) * 7)));
                float r1_z_9 = mad(r1_x_14, -2, 3);
                float r1_x_15 = (r1_x_14 * r1_x_14);
                float r1_w_6 = (r1_x_15 * r1_z_9);
                float r0_w_8 = (r0_w_7 * mad(r1_y_12, mad(mad(-r1_z_9, r1_x_15, 1), cb0_values[9].x, -cb0_values[9].y), cb0_values[9].y));
                float4 r1_xyzw_19 = mad(r1_w_6.xxxx, ((_Inneratmosphere.xyzx + -cb0_values[8].xyzx)).xxyz, cb0_values[8].xxyz);
                float r1_x_19 = r1_xyzw_19.x;
                float r1_z_10 = r1_xyzw_19.z;
                float r1_w_7 = r1_xyzw_19.w;
                float4 r1_xyzw_20 = (float4(r1_x_19, r1_x_19, r1_z_10, r1_w_7) + -cb0_values[11].xxyz);
                float r1_x_20 = r1_xyzw_20.x;
                float r1_z_11 = r1_xyzw_20.z;
                float r1_w_8 = r1_xyzw_20.w;
                float4 r1_xyzw_21 = mad(r1_y_12.xxxx, float4(r1_x_20, r1_z_11, r1_w_8, r1_x_20), cb0_values[11].xyzx);
                float r1_x_21 = r1_xyzw_21.x;
                float r1_y_13 = r1_xyzw_21.y;
                float r1_z_12 = r1_xyzw_21.z;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_y_6, r0_z_3, r0_x_9) * float4(r1_x_21, r1_y_13, r1_z_12, r1_x_21));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_7 = r0_xyzw_10.y;
                float r0_z_4 = r0_xyzw_10.z;
                o.sv_Target0.xyz = ((r0_w_8.xxxx * float4(r0_x_10, r0_y_7, r0_z_4, r0_x_10))).xyz;
                o.sv_Target0.w = 0;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Offset -1, -1
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4 _Highatmospherecolor;
                float4x4 unity_WorldToObject;
                float4 _Lowatmospherecolor;
                float _Outeratmopsheredensity;
                float _Inneratmopsheredensity;
                float _Innerouterlimit;
                float _Inneroutersmoothness;
                float _Outeratmospherelimit;
                float4 _Inneratmosphere;
                float _DisplacementAtmosphere;
                float4 cb0_values[12];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            Texture2D t0 : register(t0);
            struct program18Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
            };
            struct program18Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
            };
            struct program25Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program25Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program18Output vert(program18Input i)
            {
                program18Output o = (program18Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.texcoord0.xyzw = r0_xyzw_4;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                float4 r1_xyzw_3 = (r0_xyzw_4.yyyy * unity_ObjectToWorld[3]);
                float4 r1_xyzw_4 = mad(unity_ObjectToWorld[2], r0_xyzw_4.xxxx, r1_xyzw_3);
                float4 r1_xyzw_5 = mad(unity_WorldToObject[0], r0_xyzw_4.zzzz, r1_xyzw_4);
                o.texcoord2.xyzw = mad(unity_WorldToObject[1], r0_xyzw_4.wwww, r1_xyzw_5);
                return o;
            }
            #pragma fragment frag
            program25Output frag(program25Input i)
            {
                program25Output o = (program25Output)0;
                float3 r0_xyz_1 = ((-i.texcoord0.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float r0_w_3 = dot(i.texcoord1.xyzx, i.texcoord1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float3 unitWorldNormal_xyz_1 = ((r0_w_4.xxxx * i.texcoord1.xyzx)).xyz;
                float r0_x_5 = (max(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0) + 1);
                float r0_y_3 = (-cb0_values[9].w + cb0_values[9].z);
                float r0_y_4 = max(r0_y_3, 0);
                float r0_z_3 = (-r0_y_4 + r0_x_5);
                float r0_w_5 = (cb0_values[9].w + cb0_values[9].z);
                float r0_w_6 = min(r0_w_5, 1);
                float r0_y_5 = (-r0_y_4 + r0_w_6);
                float r0_y_6 = ((float4(1, 1, 1, 1) / r0_y_5)).y;
                float r0_y_7 = (r0_y_6 * r0_z_3);
                float r0_z_4 = mad(r0_y_7, -2, 3);
                float r0_y_8 = (r0_y_7 * r0_y_7);
                float r0_y_9 = (r0_y_8 * r0_z_4);
                float r0_z_5 = ((float4(1, 1, 1, 1) / cb0_values[10].x)).z;
                float r0_x_9 = (r0_z_5 * exp2((log2(r0_x_5) * 7)));
                float r0_z_6 = mad(r0_x_9, -2, 3);
                float r0_x_10 = (r0_x_9 * r0_x_9);
                float r0_w_7 = (r0_x_10 * r0_z_6);
                float4 r0_xyzw_10 = mad(r0_y_9.xxxx, (((mad(r0_w_7.xxxx, ((_Inneratmosphere.xyzx + -cb0_values[8].xyzx)).xyzx, cb0_values[8].xyzx)).xyzx + -cb0_values[11].xyzx)).xxyz, cb0_values[11].xxyz);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_7 = r0_xyzw_10.z;
                float r0_w_8 = r0_xyzw_10.w;
                float3 r2_xyz_4 = (mad(_WorldSpaceLightPos0.wwww, -i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r1_w_1 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float r1_x_2 = dot(unitWorldNormal_xyz_1.xyzx, ((r1_w_2.xxxx * r2_xyz_4.xyzx)).xyzx);
                float r1_y_2 = mad(r1_x_2, 0.875, 0.125);
                float r0_x_14 = (mad(r0_y_9, mad(mad(-r0_z_6, r0_x_10, 1), cb0_values[9].x, -cb0_values[9].y), cb0_values[9].y) * (r1_x_2 + r1_x_2));
                float r1_y_3 = dot(i.texcoord2.xyzx, i.texcoord2.xyzx);
                float4 r2_xyzw_6 = t0.Sample(s0, r1_y_3.xxxx);
                float4 r1_xyzw_4 = (r2_xyzw_6.xxxx * cb0_values[6].xxyz);
                float r1_y_4 = r1_xyzw_4.y;
                float r1_z_2 = r1_xyzw_4.z;
                float r1_w_3 = r1_xyzw_4.w;
                float4 r1_xyzw_5 = (float4(r1_y_4, r1_z_2, r1_w_3, r1_y_4) * (max(r1_y_2, 0)).xxxx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_5 = r1_xyzw_5.y;
                float r1_z_3 = r1_xyzw_5.z;
                float4 r0_xyzw_11 = (float4(r0_y_10, r0_y_10, r0_z_7, r0_w_8) * float4(r1_x_5, r1_x_5, r1_y_5, r1_z_3));
                float r0_y_11 = r0_xyzw_11.y;
                float r0_z_8 = r0_xyzw_11.z;
                float r0_w_9 = r0_xyzw_11.w;
                o.sv_Target0.xyz = ((r0_x_14.xxxx * float4(r0_y_11, r0_z_8, r0_w_9, r0_y_11))).xyz;
                o.sv_Target0.w = 0;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Offset -1, -1
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4 _Highatmospherecolor;
                float4x4 unity_WorldToObject;
                float4 _Lowatmospherecolor;
                float _Outeratmopsheredensity;
                float _Inneratmopsheredensity;
                float _Innerouterlimit;
                float _Inneroutersmoothness;
                float _Outeratmospherelimit;
                float4 _Inneratmosphere;
                float _DisplacementAtmosphere;
                float4 cb0_values[8];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[21];
            };
            cbuffer UnityLighting : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 cb2_values[1];
            };
            struct program17Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
            };
            struct program17Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
            };
            struct program26Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
            };
            struct program26Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program17Output vert(program17Input i)
            {
                program17Output o = (program17Output)0;
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
            program26Output frag(program26Input i)
            {
                program26Output o = (program26Output)0;
                float3 viewDir_xyz_1 = ((-i.texcoord0.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(viewDir_xyz_1.xyzx, viewDir_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float3 unitViewDir_xyz_2 = ((r0_w_2.xxxx * viewDir_xyz_1.xyzx)).xyz;
                float r0_w_3 = dot(i.texcoord1.xyzx, i.texcoord1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float3 unitWorldNormal_xyz_1 = ((r0_w_4.xxxx * i.texcoord1.xyzx)).xyz;
                float nDotV_x_3 = dot(unitWorldNormal_xyz_1.xyzx, unitViewDir_xyz_2.xyzx);
                float r0_x_5 = (max(nDotV_x_3, 0) + 1);
                float r0_y_3 = (-_Inneroutersmoothness + _Innerouterlimit);
                float r0_y_4 = max(r0_y_3, 0);
                float r0_z_3 = (-r0_y_4 + r0_x_5);
                float r0_w_5 = (_Inneroutersmoothness + _Innerouterlimit);
                float r0_w_6 = min(r0_w_5, 1);
                float r0_y_5 = (-r0_y_4 + r0_w_6);
                float r0_y_6 = ((float4(1, 1, 1, 1) / r0_y_5)).y;
                float r0_y_7 = (r0_y_6 * r0_z_3);
                float r0_z_4 = mad(r0_y_7, -2, 3);
                float r0_y_8 = (r0_y_7 * r0_y_7);
                float r0_y_9 = (r0_y_8 * r0_z_4);
                float r0_z_5 = ((float4(1, 1, 1, 1) / _Outeratmospherelimit)).z;
                float r0_x_9 = (r0_z_5 * exp2((log2(r0_x_5) * 7)));
                float r0_z_6 = mad(r0_x_9, -2, 3);
                float r0_x_10 = (r0_x_9 * r0_x_9);
                float r0_w_7 = (r0_x_10 * r0_z_6);
                float4 r0_xyzw_10 = mad(r0_y_9.xxxx, (((mad(r0_w_7.xxxx, ((_Highatmospherecolor.xyzx + -_Lowatmospherecolor.xyzx)).xyzx, _Lowatmospherecolor.xyzx)).xyzx + -_Inneratmosphere.xyzx)).xxyz, _Inneratmosphere.xxyz);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_7 = r0_xyzw_10.z;
                float r0_w_8 = r0_xyzw_10.w;
                float3 r2_xyz_4 = (mad(_WorldSpaceLightPos0.wwww, -i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r1_w_1 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float r1_x_2 = dot(unitWorldNormal_xyz_1.xyzx, ((r1_w_2.xxxx * r2_xyz_4.xyzx)).xyzx);
                float r1_y_2 = mad(r1_x_2, 0.875, 0.125);
                float r0_x_14 = (mad(r0_y_9, mad(mad(-r0_z_6, r0_x_10, 1), _Outeratmopsheredensity, -_Inneratmopsheredensity), _Inneratmopsheredensity) * (r1_x_2 + r1_x_2));
                float4 r1_xyzw_5 = ((max(r1_y_2, 0)).xxxx * _LightColor0.xyzx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_3 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float4 r0_xyzw_11 = (float4(r0_y_10, r0_y_10, r0_z_7, r0_w_8) * float4(r1_x_5, r1_x_5, r1_y_3, r1_z_2));
                float r0_y_11 = r0_xyzw_11.y;
                float r0_z_8 = r0_xyzw_11.z;
                float r0_w_9 = r0_xyzw_11.w;
                o.sv_Target0.xyz = ((r0_x_14.xxxx * float4(r0_y_11, r0_z_8, r0_w_9, r0_y_11))).xyz;
                o.sv_Target0.w = 0;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Offset -1, -1
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4 _Highatmospherecolor;
                float4x4 unity_WorldToObject;
                float4 _Lowatmospherecolor;
                float _Outeratmopsheredensity;
                float _Inneratmopsheredensity;
                float _Innerouterlimit;
                float _Inneroutersmoothness;
                float _Outeratmospherelimit;
                float4 _Inneratmosphere;
                float _DisplacementAtmosphere;
                float4 cb0_values[12];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            Texture2D t0 : register(t0);
            struct program16Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
            };
            struct program16Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program29Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float2 texcoord2 : TEXCOORD2;
            };
            struct program29Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program16Output vert(program16Input i)
            {
                program16Output o = (program16Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.texcoord0.xyzw = r0_xyzw_4;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_WorldToObject[1].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.zzzz, (mad(unity_ObjectToWorld[2].xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_ObjectToWorld[3].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program29Output frag(program29Input i)
            {
                program29Output o = (program29Output)0;
                float3 r0_xyz_1 = ((-i.texcoord0.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float r0_w_3 = dot(i.texcoord1.xyzx, i.texcoord1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float3 unitWorldNormal_xyz_1 = ((r0_w_4.xxxx * i.texcoord1.xyzx)).xyz;
                float r0_x_5 = (max(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0) + 1);
                float r0_y_3 = (-cb0_values[9].w + cb0_values[9].z);
                float r0_y_4 = max(r0_y_3, 0);
                float r0_z_3 = (-r0_y_4 + r0_x_5);
                float r0_w_5 = (cb0_values[9].w + cb0_values[9].z);
                float r0_w_6 = min(r0_w_5, 1);
                float r0_y_5 = (-r0_y_4 + r0_w_6);
                float r0_y_6 = ((float4(1, 1, 1, 1) / r0_y_5)).y;
                float r0_y_7 = (r0_y_6 * r0_z_3);
                float r0_z_4 = mad(r0_y_7, -2, 3);
                float r0_y_8 = (r0_y_7 * r0_y_7);
                float r0_y_9 = (r0_y_8 * r0_z_4);
                float r0_z_5 = ((float4(1, 1, 1, 1) / cb0_values[10].x)).z;
                float r0_x_9 = (r0_z_5 * exp2((log2(r0_x_5) * 7)));
                float r0_z_6 = mad(r0_x_9, -2, 3);
                float r0_x_10 = (r0_x_9 * r0_x_9);
                float r0_w_7 = (r0_x_10 * r0_z_6);
                float4 r0_xyzw_10 = mad(r0_y_9.xxxx, (((mad(r0_w_7.xxxx, ((_Inneratmosphere.xyzx + -cb0_values[8].xyzx)).xyzx, cb0_values[8].xyzx)).xyzx + -cb0_values[11].xyzx)).xxyz, cb0_values[11].xxyz);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_7 = r0_xyzw_10.z;
                float r0_w_8 = r0_xyzw_10.w;
                float3 r2_xyz_4 = (mad(_WorldSpaceLightPos0.wwww, -i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r1_w_1 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float r1_x_2 = dot(unitWorldNormal_xyz_1.xyzx, ((r1_w_2.xxxx * r2_xyz_4.xyzx)).xyzx);
                float r1_y_2 = mad(r1_x_2, 0.875, 0.125);
                float r0_x_14 = (mad(r0_y_9, mad(mad(-r0_z_6, r0_x_10, 1), cb0_values[9].x, -cb0_values[9].y), cb0_values[9].y) * (r1_x_2 + r1_x_2));
                float4 r2_xyzw_6 = t0.Sample(s0, i.texcoord2.xyxx);
                float4 r1_xyzw_3 = (r2_xyzw_6.wwww * cb0_values[6].xxyz);
                float r1_y_3 = r1_xyzw_3.y;
                float r1_z_2 = r1_xyzw_3.z;
                float r1_w_3 = r1_xyzw_3.w;
                float4 r1_xyzw_5 = (float4(r1_y_3, r1_z_2, r1_w_3, r1_y_3) * (max(r1_y_2, 0)).xxxx);
                float r1_x_5 = r1_xyzw_5.x;
                float r1_y_4 = r1_xyzw_5.y;
                float r1_z_3 = r1_xyzw_5.z;
                float4 r0_xyzw_11 = (float4(r0_y_10, r0_y_10, r0_z_7, r0_w_8) * float4(r1_x_5, r1_x_5, r1_y_4, r1_z_3));
                float r0_y_11 = r0_xyzw_11.y;
                float r0_z_8 = r0_xyzw_11.z;
                float r0_w_9 = r0_xyzw_11.w;
                o.sv_Target0.xyz = ((r0_x_14.xxxx * float4(r0_y_11, r0_z_8, r0_w_9, r0_y_11))).xyz;
                o.sv_Target0.w = 0;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Offset -1, -1
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4 _Highatmospherecolor;
                float4x4 unity_WorldToObject;
                float4 _Lowatmospherecolor;
                float _Outeratmopsheredensity;
                float _Inneratmopsheredensity;
                float _Innerouterlimit;
                float _Inneroutersmoothness;
                float _Outeratmospherelimit;
                float4 _Inneratmosphere;
                float _DisplacementAtmosphere;
                float4 cb0_values[12];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            TextureCube t1 : register(t1);
            struct program16Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
            };
            struct program16Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program28Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program28Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program16Output vert(program16Input i)
            {
                program16Output o = (program16Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.texcoord0.xyzw = r0_xyzw_4;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_WorldToObject[1].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.zzzz, (mad(unity_ObjectToWorld[2].xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_ObjectToWorld[3].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program28Output frag(program28Input i)
            {
                program28Output o = (program28Output)0;
                float3 r0_xyz_1 = ((-i.texcoord0.xyzx + _WorldSpaceCameraPos.xyzx)).xyz;
                float r0_w_1 = dot(r0_xyz_1.xyzx, r0_xyz_1.xyzx);
                float r0_w_2 = rsqrt(r0_w_1);
                float r0_w_3 = dot(i.texcoord1.xyzx, i.texcoord1.xyzx);
                float r0_w_4 = rsqrt(r0_w_3);
                float3 unitWorldNormal_xyz_1 = ((r0_w_4.xxxx * i.texcoord1.xyzx)).xyz;
                float r0_x_5 = (max(dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_2.xxxx * r0_xyz_1.xyzx)).xyzx), 0) + 1);
                float r0_y_3 = (-cb0_values[9].w + cb0_values[9].z);
                float r0_y_4 = max(r0_y_3, 0);
                float r0_z_3 = (-r0_y_4 + r0_x_5);
                float r0_w_5 = (cb0_values[9].w + cb0_values[9].z);
                float r0_w_6 = min(r0_w_5, 1);
                float r0_y_5 = (-r0_y_4 + r0_w_6);
                float r0_y_6 = ((float4(1, 1, 1, 1) / r0_y_5)).y;
                float r0_y_7 = (r0_y_6 * r0_z_3);
                float r0_z_4 = mad(r0_y_7, -2, 3);
                float r0_y_8 = (r0_y_7 * r0_y_7);
                float r0_y_9 = (r0_y_8 * r0_z_4);
                float r0_z_5 = ((float4(1, 1, 1, 1) / cb0_values[10].x)).z;
                float r0_x_9 = (r0_z_5 * exp2((log2(r0_x_5) * 7)));
                float r0_z_6 = mad(r0_x_9, -2, 3);
                float r0_x_10 = (r0_x_9 * r0_x_9);
                float r0_w_7 = (r0_x_10 * r0_z_6);
                float4 r0_xyzw_10 = mad(r0_y_9.xxxx, (((mad(r0_w_7.xxxx, ((_Inneratmosphere.xyzx + -cb0_values[8].xyzx)).xyzx, cb0_values[8].xyzx)).xyzx + -cb0_values[11].xyzx)).xxyz, cb0_values[11].xxyz);
                float r0_y_10 = r0_xyzw_10.y;
                float r0_z_7 = r0_xyzw_10.z;
                float r0_w_8 = r0_xyzw_10.w;
                float3 r2_xyz_4 = (mad(_WorldSpaceLightPos0.wwww, -i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r1_w_1 = dot(r2_xyz_4.xyzx, r2_xyz_4.xyzx);
                float r1_w_2 = rsqrt(r1_w_1);
                float r1_x_2 = dot(unitWorldNormal_xyz_1.xyzx, ((r1_w_2.xxxx * r2_xyz_4.xyzx)).xyzx);
                float r1_y_2 = mad(r1_x_2, 0.875, 0.125);
                float r0_x_14 = (mad(r0_y_9, mad(mad(-r0_z_6, r0_x_10, 1), cb0_values[9].x, -cb0_values[9].y), cb0_values[9].y) * (r1_x_2 + r1_x_2));
                float r1_y_3 = dot(i.texcoord2.xyzx, i.texcoord2.xyzx);
                float4 r2_xyzw_6 = t0.Sample(s1, r1_y_3.xxxx);
                float4 r3_xyzw_1 = t1.Sample(s0, i.texcoord2.xyzx);
                float r1_y_4 = (r2_xyzw_6.x * r3_xyzw_1.w);
                float4 r1_xyzw_5 = (r1_y_4.xxxx * cb0_values[6].xxyz);
                float r1_y_5 = r1_xyzw_5.y;
                float r1_z_2 = r1_xyzw_5.z;
                float r1_w_3 = r1_xyzw_5.w;
                float r1_x_5 = ((float4(r1_y_5, r1_z_2, r1_w_3, r1_y_5) * (max(r1_y_2, 0)).xxxx)).x;
                float4 r1_xyzw_6 = (float4(r1_y_5, r1_z_2, r1_w_3, r1_y_5) * (max(r1_y_2, 0)).xxxx);
                float r1_y_6 = r1_xyzw_6.y;
                float r1_z_3 = r1_xyzw_6.z;
                float4 r0_xyzw_11 = (float4(r0_y_10, r0_y_10, r0_z_7, r0_w_8) * float4(r1_x_5, r1_x_5, r1_y_6, r1_z_3));
                float r0_y_11 = r0_xyzw_11.y;
                float r0_z_8 = r0_xyzw_11.z;
                float r0_w_9 = r0_xyzw_11.w;
                o.sv_Target0.xyz = ((r0_x_14.xxxx * float4(r0_y_11, r0_z_8, r0_w_9, r0_y_11))).xyz;
                o.sv_Target0.w = 0;
                return o;
            }
            ENDHLSL
        }
        Pass
        {
            Tags { "IGNOREPROJECTOR"="true" "LIGHTMODE"="FORWARDADD" "QUEUE"="Transparent" "RenderType"="Transparent" }
            Cull Back
            ZTest LEqual
            ZWrite Off
            Offset -1, -1
            Blend One One
            HLSLPROGRAM
            cbuffer UnityPerDraw : register(b0)
            {
                float4x4 unity_ObjectToWorld;
                float4 _LightColor0;
                float4 _Highatmospherecolor;
                float4x4 unity_WorldToObject;
                float4 _Lowatmospherecolor;
                float _Outeratmopsheredensity;
                float _Inneratmopsheredensity;
                float _Innerouterlimit;
                float _Inneroutersmoothness;
                float _Outeratmospherelimit;
                float4 _Inneratmosphere;
                float _DisplacementAtmosphere;
                float4 cb0_values[12];
            };
            cbuffer UnityPerFrame : register(b1)
            {
                float3 _WorldSpaceCameraPos;
                float4x4 unity_MatrixVP;
                float4 cb1_values[7];
            };
            cbuffer cb2 : register(b2)
            {
                float4 _WorldSpaceLightPos0;
                float4 cb2_values[21];
            };
            SamplerState s0 : register(s0);
            SamplerState s1 : register(s1);
            Texture2D t0 : register(t0);
            Texture2D t1 : register(t1);
            struct program16Input
            {
                float4 position0 : POSITION0;
                float3 normal0 : NORMAL0;
            };
            struct program16Output
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float3 texcoord2 : TEXCOORD2;
            };
            struct program27Input
            {
                float4 sv_Position0 : SV_POSITION0;
                float4 texcoord0 : TEXCOORD0;
                float3 texcoord1 : TEXCOORD1;
                float4 texcoord2 : TEXCOORD2;
            };
            struct program27Output
            {
                float4 sv_Target0 : SV_Target0;
            };
            #pragma vertex vert
            program16Output vert(program16Input i)
            {
                program16Output o = (program16Output)0;
                float4 worldPos_xyzw_2 = mad(cb1_values[0].xyzw, i.position0.xxxx, (i.position0.yyyy * cb1_values[1].xyzw));
                float4 worldPos_xyzw_3 = mad(cb1_values[2].xyzw, i.position0.zzzz, worldPos_xyzw_2);
                float4 worldPos_xyzw_1 = (worldPos_xyzw_3 + cb1_values[3].xyzw);
                float4 r0_xyzw_4 = mad(cb1_values[3].xyzw, i.position0.wwww, worldPos_xyzw_3);
                float4 clipPos_xyzw_2 = mad(cb2_values[17].xyzw, worldPos_xyzw_1.xxxx, (worldPos_xyzw_1.yyyy * cb2_values[18].xyzw));
                float4 clipPos_xyzw_3 = mad(cb2_values[19].xyzw, worldPos_xyzw_1.zzzz, clipPos_xyzw_2);
                o.sv_Position0.xyzw = mad(cb2_values[20].xyzw, worldPos_xyzw_1.wwww, clipPos_xyzw_3);
                o.texcoord0.xyzw = r0_xyzw_4;
                float worldNormal_x_2 = dot(i.normal0.xyzx, cb1_values[4].xyzx);
                float worldNormal_y_2 = dot(i.normal0.xyzx, cb1_values[5].xyzx);
                float worldNormal_z_2 = dot(i.normal0.xyzx, cb1_values[6].xyzx);
                float r1_w_2 = dot(float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2), float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2));
                float r1_w_3 = rsqrt(r1_w_2);
                o.texcoord1.xyz = ((r1_w_3.xxxx * float4(worldNormal_x_2, worldNormal_y_2, worldNormal_z_2, worldNormal_x_2))).xyz;
                o.texcoord2.xyz = (mad(unity_WorldToObject[1].xyzx, r0_xyzw_4.wwww, (mad(unity_WorldToObject[0].xyzx, r0_xyzw_4.zzzz, (mad(unity_ObjectToWorld[2].xyzx, r0_xyzw_4.xxxx, ((r0_xyzw_4.yyyy * unity_ObjectToWorld[3].xyzx)).xyzx)).xyzx)).xyzx)).xyz;
                return o;
            }
            #pragma fragment frag
            program27Output frag(program27Input i)
            {
                program27Output o = (program27Output)0;
                float4 r0_xyzw_3 = t0.Sample(s0, ((((i.texcoord2.xyxx / i.texcoord2.wwww)).xyxx + float4(0.5, 0.5, 0, 0))).xyxx);
                float r0_y_4 = dot(i.texcoord2.xyzx, i.texcoord2.xyzx);
                float4 r1_xyzw_1 = t1.Sample(s1, r0_y_4.xxxx);
                float4 r0_xyzw_8 = ((((r0_xyzw_3.w * asfloat(asint((float)((0 < i.texcoord2.z))) & asint(1065353216))) * r1_xyzw_1.x)).xxxx * cb0_values[6].xyzx);
                float r0_x_8 = r0_xyzw_8.x;
                float r0_y_5 = r0_xyzw_8.y;
                float r0_z_2 = r0_xyzw_8.z;
                float3 r1_xyz_2 = (mad(_WorldSpaceLightPos0.wwww, -i.texcoord0.xyzx, _WorldSpaceLightPos0.xyzx)).xyz;
                float r0_w_2 = dot(r1_xyz_2.xyzx, r1_xyz_2.xyzx);
                float r0_w_3 = rsqrt(r0_w_2);
                float r0_w_4 = dot(i.texcoord1.xyzx, i.texcoord1.xyzx);
                float r0_w_5 = rsqrt(r0_w_4);
                float3 unitWorldNormal_xyz_1 = ((r0_w_5.xxxx * i.texcoord1.xyzx)).xyz;
                float r0_w_6 = dot(unitWorldNormal_xyz_1.xyzx, ((r0_w_3.xxxx * r1_xyz_2.xyzx)).xyzx);
                float r0_w_7 = (r0_w_6 + r0_w_6);
                float4 r0_xyzw_9 = (float4(r0_x_8, r0_y_5, r0_z_2, r0_x_8) * (max(mad(r0_w_6, 0.875, 0.125), 0)).xxxx);
                float r0_x_9 = r0_xyzw_9.x;
                float r0_y_6 = r0_xyzw_9.y;
                float r0_z_3 = r0_xyzw_9.z;
                float4 r1_xyzw_6 = (-i.texcoord0.xyzx + _WorldSpaceCameraPos.xyzx);
                float r1_x_6 = r1_xyzw_6.x;
                float r1_y_4 = r1_xyzw_6.y;
                float r1_z_4 = r1_xyzw_6.z;
                float r1_w_2 = dot(float4(r1_x_6, r1_y_4, r1_z_4, r1_x_6), float4(r1_x_6, r1_y_4, r1_z_4, r1_x_6));
                float r1_w_3 = rsqrt(r1_w_2);
                float4 r1_xyzw_7 = (r1_w_3.xxxx * float4(r1_x_6, r1_y_4, r1_z_4, r1_x_6));
                float r1_x_7 = r1_xyzw_7.x;
                float r1_y_5 = r1_xyzw_7.y;
                float r1_z_5 = r1_xyzw_7.z;
                float r1_x_10 = (max(dot(unitWorldNormal_xyz_1.xyzx, float4(r1_x_7, r1_y_5, r1_z_5, r1_x_7)), 0) + 1);
                float r1_y_6 = (-cb0_values[9].w + cb0_values[9].z);
                float r1_y_7 = max(r1_y_6, 0);
                float r1_z_6 = (-r1_y_7 + r1_x_10);
                float r1_w_4 = (cb0_values[9].w + cb0_values[9].z);
                float r1_w_5 = min(r1_w_4, 1);
                float r1_y_8 = (-r1_y_7 + r1_w_5);
                float r1_y_9 = ((float4(1, 1, 1, 1) / r1_y_8)).y;
                float r1_y_10 = (r1_y_9 * r1_z_6);
                float r1_z_7 = mad(r1_y_10, -2, 3);
                float r1_y_11 = (r1_y_10 * r1_y_10);
                float r1_y_12 = (r1_y_11 * r1_z_7);
                float r1_z_8 = ((float4(1, 1, 1, 1) / cb0_values[10].x)).z;
                float r1_x_14 = (r1_z_8 * exp2((log2(r1_x_10) * 7)));
                float r1_z_9 = mad(r1_x_14, -2, 3);
                float r1_x_15 = (r1_x_14 * r1_x_14);
                float r1_w_6 = (r1_x_15 * r1_z_9);
                float r0_w_8 = (r0_w_7 * mad(r1_y_12, mad(mad(-r1_z_9, r1_x_15, 1), cb0_values[9].x, -cb0_values[9].y), cb0_values[9].y));
                float4 r1_xyzw_19 = mad(r1_w_6.xxxx, ((_Inneratmosphere.xyzx + -cb0_values[8].xyzx)).xxyz, cb0_values[8].xxyz);
                float r1_x_19 = r1_xyzw_19.x;
                float r1_z_10 = r1_xyzw_19.z;
                float r1_w_7 = r1_xyzw_19.w;
                float4 r1_xyzw_20 = (float4(r1_x_19, r1_x_19, r1_z_10, r1_w_7) + -cb0_values[11].xxyz);
                float r1_x_20 = r1_xyzw_20.x;
                float r1_z_11 = r1_xyzw_20.z;
                float r1_w_8 = r1_xyzw_20.w;
                float4 r1_xyzw_21 = mad(r1_y_12.xxxx, float4(r1_x_20, r1_z_11, r1_w_8, r1_x_20), cb0_values[11].xyzx);
                float r1_x_21 = r1_xyzw_21.x;
                float r1_y_13 = r1_xyzw_21.y;
                float r1_z_12 = r1_xyzw_21.z;
                float4 r0_xyzw_10 = (float4(r0_x_9, r0_y_6, r0_z_3, r0_x_9) * float4(r1_x_21, r1_y_13, r1_z_12, r1_x_21));
                float r0_x_10 = r0_xyzw_10.x;
                float r0_y_7 = r0_xyzw_10.y;
                float r0_z_4 = r0_xyzw_10.z;
                o.sv_Target0.xyz = ((r0_w_8.xxxx * float4(r0_x_10, r0_y_7, r0_z_4, r0_x_10))).xyz;
                o.sv_Target0.w = 0;
                return o;
            }
            ENDHLSL
        }
    }
    Fallback "Diffuse"
}
