# Source preparation

Ghidra decompilation of `UnityShaderCompiler.exe` (image base `0x140000000`).
Function names and leading comments are the annotations recorded in the Ghidra
database; the bodies are otherwise unedited decompiler output. See
[`shader_compiler_analysis.md`](../shader_compiler_analysis.md) for the prose
description of the same pipeline.

## `GenerateD3dHlslStageSource` — `0x1400b9770`

D3D/HLSL frontend

```c
/* D3D/HLSL frontend. Prepends the keyword macros, UNITY_VERSION and the SHADER_STAGE_* defines,
   runs ProcessShaderPreprocessor, validates the stage slots and copies the per-stage source out.
   Only this frontend produces DXBC. */

void GenerateD3dHlslStageSource
               (undefined8 param_1,undefined4 param_2,undefined8 *param_3,undefined8 *param_4,
               undefined8 *param_5,longlong *param_6,longlong *param_7,longlong *param_8,
               longlong param_9,undefined4 param_10,undefined8 param_11,uint param_12,
               undefined1 param_13,ulonglong param_14,undefined4 param_15,int param_16,
               undefined4 param_17,int param_18,ulonglong param_19,undefined8 param_20,
               longlong *param_21,undefined4 *param_22,undefined8 param_23)

{
  int iVar1;
  undefined8 uVar2;
  char cVar3;
  longlong *plVar4;
  longlong lVar5;
  longlong lVar6;
  uint uVar7;
  undefined4 uVar8;
  ulonglong uVar9;
  undefined8 *puVar10;
  ulonglong uVar11;
  ulonglong uVar12;
  char *pcVar13;
  uint uVar14;
  longlong lVar15;
  longlong lVar16;
  longlong lVar17;
  ulonglong in_stack_fffffffffffff838;
  undefined8 in_stack_fffffffffffff840;
  undefined8 in_stack_fffffffffffff848;
  undefined4 uVar18;
  undefined8 *local_768;
  longlong local_760;
  undefined8 *local_758;
  longlong local_750;
  undefined8 local_748;
  undefined8 local_740;
  char local_738;
  undefined7 uStack_737;
  longlong local_728;
  byte local_719;
  undefined2 local_718;
  undefined8 local_710 [3];
  byte local_6f1;
  undefined2 local_6f0;
  undefined4 *local_6e8;
  undefined8 local_6e0;
  undefined4 local_6d8;
  undefined2 local_6d2;
  undefined4 *local_6d0;
  undefined8 local_6c8;
  undefined4 local_6c0;
  undefined2 local_6ba;
  undefined8 local_6b8;
  undefined2 local_6b0;
  undefined8 local_6a8;
  undefined8 local_6a0;
  undefined8 local_698;
  undefined2 local_690;
  undefined8 local_688;
  undefined8 local_680;
  undefined8 local_678;
  undefined2 local_670;
  undefined8 local_668;
  undefined8 local_660;
  undefined1 local_658;
  undefined7 uStack_657;
  byte local_639;
  undefined2 local_638;
  undefined1 local_628 [8];
  undefined8 local_620;
  undefined4 local_618;
  int local_614;
  undefined4 local_610;
  int local_608;
  ulonglong local_600;
  ulonglong local_5f0;
  undefined4 local_5e8;
  undefined8 local_5e0;
  undefined8 local_5d8;
  undefined1 local_5d0;
  undefined1 local_5cf;
  undefined4 local_5cc;
  undefined4 local_5c8;
  undefined4 local_5c4;
  undefined8 local_5c0;
  ulonglong local_5b8;
  byte local_5a1;
  undefined8 local_598 [5];
  undefined1 local_570 [360];
  undefined1 local_408 [32];
  undefined1 local_3e8 [56];
  longlong local_3b0 [2];
  ulonglong local_3a0;
  ulonglong local_398;
  ulonglong local_390;
  undefined2 local_388;
  ulonglong local_380;
  ulonglong local_378;
  longlong local_370;
  undefined2 local_368;
  ulonglong local_360;
  ulonglong local_358;
  undefined1 local_348 [16];
  undefined1 local_338 [96];
  longlong local_2d8;
  byte local_2c9;
  longlong local_2b0;
  byte local_2a1;
  longlong local_288;
  byte local_279;
  ulonglong local_220;
  undefined8 local_208;
  byte local_1e9;
  undefined2 local_1e8;
  undefined4 local_1e0;
  undefined4 local_1dc;
  undefined4 local_1d8;
  undefined1 local_1d0 [360];
  undefined8 local_68;
  undefined8 local_60;
  undefined2 local_58;
  undefined8 local_50;
  undefined8 local_48;
  uint local_40;
  undefined4 local_3c;
  
  uVar8 = (undefined4)((ulonglong)in_stack_fffffffffffff840 >> 0x20);
  uVar18 = (undefined4)((ulonglong)in_stack_fffffffffffff848 >> 0x20);
  if (*param_21 != param_21[1]) {
    param_21[1] = *param_21;
  }
  FUN_140015c70(local_628);
  local_5c4 = param_10;
  local_5d0 = (undefined1)param_12;
  local_5cf = param_13;
  local_5e0 = param_11;
  FUN_140054d80(local_408,DAT_140728518,DAT_140728518 + DAT_140728528 * 0x28);
  FUN_140019e80(local_3e8,&PTR_DAT_140728538);
  if (*(byte *)((longlong)param_3 + 0x1f) < 0x40) {
    local_760 = 0x1f - (longlong)*(char *)((longlong)param_3 + 0x1f);
    local_768 = param_3;
  }
  else {
    local_760 = param_3[2];
    local_768 = (undefined8 *)*param_3;
  }
  FUN_1400c0f50(local_408,&local_768);
  if (*(byte *)((longlong)param_3 + 0x1f) < 0x40) {
    lVar5 = 0x1f - (longlong)*(char *)((longlong)param_3 + 0x1f);
  }
  else {
    lVar5 = param_3[2];
  }
  if (*(byte *)((longlong)param_4 + 0x1f) < 0x40) {
    lVar6 = 0x1f - (longlong)*(char *)((longlong)param_4 + 0x1f);
  }
  else {
    lVar6 = param_4[2];
  }
  if (local_5a1 < 0x40) {
    local_5b8 = 0x1f;
  }
  if (local_5b8 <= (ulonglong)(lVar6 + 1 + lVar5)) {
    FUN_140056c90(&local_5c0);
  }
  if (&local_5c0 != param_3) {
    if (*(byte *)((longlong)param_3 + 0x1f) < 0x40) {
      lVar5 = 0x1f - (longlong)*(char *)((longlong)param_3 + 0x1f);
    }
    else {
      lVar5 = param_3[2];
      param_3 = (undefined8 *)*param_3;
    }
    FUN_140054780(&local_5c0,param_3,lVar5);
  }
  param_12 = CONCAT31(param_12._1_3_,0x2f);
  FUN_1400543f0(&local_5c0,&param_12,1);
  if (*(byte *)((longlong)param_4 + 0x1f) < 0x40) {
    lVar5 = 0x1f - (longlong)*(char *)((longlong)param_4 + 0x1f);
  }
  else {
    lVar5 = param_4[2];
    param_4 = (undefined8 *)*param_4;
  }
  FUN_1400543f0(&local_5c0,param_4,lVar5);
  FUN_1400b1740(param_19,local_3b0);
  if (local_598 != param_5) {
    if (*(byte *)((longlong)param_5 + 0x1f) < 0x40) {
      lVar5 = 0x1f - (longlong)*(char *)((longlong)param_5 + 0x1f);
    }
    else {
      lVar5 = param_5[2];
      param_5 = (undefined8 *)*param_5;
    }
    FUN_140054780(local_598,param_5,lVar5);
  }
  uVar9 = param_7[2] + param_6[2] + 2;
  uVar12 = 0;
  if (local_378 >> 1 < uVar9) {
    if ((~(byte)local_378 & 1) == 0) {
      uVar11 = uVar12;
      if (uVar9 != 0) {
        uVar11 = FUN_1400e4280(uVar9 * 0x50,8,local_388,0,
                               "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\Allocators.h"
                               ,CONCAT44(uVar8,0x9c));
      }
      FUN_140558820(uVar11,local_390,local_380 * 0x50);
      local_378 = uVar9 * 2;
      local_390 = uVar11;
    }
    else {
      local_378 = uVar9 * 2;
      local_390 = FUN_1400e42a0(local_390,uVar9 * 0x50,8,local_388,
                                in_stack_fffffffffffff838 & 0xffffffff00000000,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\Allocators.h"
                                ,CONCAT44(uVar18,0xa3));
    }
  }
  FUN_1400b0fb0(param_10,&local_390);
  uVar9 = uVar12;
  if (param_6[2] != 0) {
    do {
      puVar10 = (undefined8 *)(*param_6 + uVar9);
      uVar11 = local_380 + 1;
      if (local_378 >> 1 < uVar11) {
        FUN_140057330(&local_390);
      }
      lVar5 = (local_390 - 0x50) + uVar11 * 0x50;
      local_380 = uVar11;
      if (lVar5 != 0) {
        local_758 = (undefined8 *)PTR_DAT_1407285a0;
        local_750 = DAT_1407285a8;
        if (*(byte *)((longlong)puVar10 + 0x1f) < 0x40) {
          local_760 = 0x1f - (longlong)*(char *)((longlong)puVar10 + 0x1f);
        }
        else {
          local_760 = puVar10[2];
          puVar10 = (undefined8 *)*puVar10;
        }
        local_768 = puVar10;
        FUN_140014b30(lVar5,&local_768,0x4b);
        FUN_140014b30(lVar5 + 0x28,&local_758,0x4b);
      }
      uVar14 = (int)uVar12 + 1;
      uVar12 = (ulonglong)uVar14;
      uVar9 = uVar9 + 0x28;
    } while ((ulonglong)(longlong)(int)uVar14 < (ulonglong)param_6[2]);
  }
  uVar12 = 0;
  uVar9 = uVar12;
  if (param_7[2] != 0) {
    do {
      puVar10 = (undefined8 *)(*param_7 + uVar9);
      uVar11 = local_380 + 1;
      if (local_378 >> 1 < uVar11) {
        FUN_140057330(&local_390);
      }
      lVar5 = (local_390 - 0x50) + uVar11 * 0x50;
      local_380 = uVar11;
      if (lVar5 != 0) {
        local_768 = (undefined8 *)PTR_DAT_1407285a0;
        local_760 = DAT_1407285a8;
        if (*(byte *)((longlong)puVar10 + 0x1f) < 0x40) {
          local_750 = 0x1f - (longlong)*(char *)((longlong)puVar10 + 0x1f);
        }
        else {
          local_750 = puVar10[2];
          puVar10 = (undefined8 *)*puVar10;
        }
        local_758 = puVar10;
        FUN_140014b30(lVar5,&local_758,0x4b);
        FUN_140014b30(lVar5 + 0x28,&local_768,0x4b);
      }
      uVar14 = (int)uVar12 + 1;
      uVar12 = (ulonglong)uVar14;
      uVar9 = uVar9 + 0x28;
    } while ((ulonglong)(longlong)(int)uVar14 < (ulonglong)param_7[2]);
  }
  lVar5 = 0;
  FUN_140054d80(&local_370,*param_8,*param_8 + param_8[2] * 0x28);
  PrepareStageSourceSegment(param_10,&local_370);
  puVar10 = (undefined8 *)FUN_1400e16b0(&local_738,0x393fc3d);
  local_3a0 = local_3a0 + 1;
  if (local_398 >> 1 < local_3a0) {
    FUN_140057330(local_3b0);
  }
  lVar6 = local_3b0[0] + -0x50 + local_3a0 * 0x50;
  if (lVar6 != 0) {
    if (*(byte *)((longlong)puVar10 + 0x1f) < 0x40) {
      local_760 = 0x1f - (longlong)*(char *)((longlong)puVar10 + 0x1f);
    }
    else {
      local_760 = puVar10[2];
      puVar10 = (undefined8 *)*puVar10;
    }
    local_758 = (undefined8 *)PTR_s_UNITY_VERSION_140728550;
    local_750 = DAT_140728558;
    local_768 = puVar10;
    FUN_140014b30(lVar6,&local_758,0x4b);
    FUN_140014b30(lVar6 + 0x28,&local_768,0x4b);
  }
  if ((local_719 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_737,local_738),local_718,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  uVar9 = local_3a0 + 1;
  if (local_398 >> 1 < uVar9) {
    FUN_140057330(local_3b0);
  }
  lVar6 = local_3b0[0] + -0x50 + uVar9 * 0x50;
  lVar15 = -1;
  local_3a0 = uVar9;
  if (lVar6 != 0) {
    local_768 = (undefined8 *)PTR_DAT_1407285a0;
    local_760 = DAT_1407285a8;
    local_758 = (undefined8 *)(&PTR_s_SHADER_STAGE_VERTEX_140728d98)[param_16];
    local_750 = -1;
    do {
      local_750 = local_750 + 1;
    } while (*(char *)((longlong)local_758 + local_750) != '\0');
    FUN_140014b30(lVar6,&local_758,0x4b);
    FUN_140014b30(lVar6 + 0x28,&local_768,0x4b);
  }
  iVar1 = param_18;
  local_608 = param_18;
  local_600 = param_19;
  FUN_140015ef0(local_338);
  FUN_1400afd40(local_1d0);
  local_68 = 0x21;
  local_60 = 0;
  local_58 = 0x19;
  local_50 = 0;
  local_48 = 1;
  local_3c = 0;
  uVar7 = 1;
  local_40 = 1 << ((byte)iVar1 & 0x1f);
  local_6e8 = &DAT_14058aa4c;
  local_6e0 = 0;
  local_6d8 = 0;
  local_6d2 = 1;
  local_6d0 = &DAT_14058aa4c;
  local_6c8 = 0;
  local_6c0 = 0;
  local_6ba = 1;
  local_638 = 0x4b;
  local_658 = 0;
  local_639 = 0x1f;
  local_678 = 0;
  local_670 = 0x4d;
  local_668 = 0;
  local_660 = 1;
  local_698 = 0;
  local_690 = 0x4d;
  local_688 = 0;
  local_680 = 1;
  local_6b8 = 0;
  local_6b0 = 0x4d;
  local_6a8 = 0;
  local_6a0 = 1;
  uVar14 = local_40 & 0xdfdde30;
  puVar10 = &DAT_140728090;
  lVar6 = 0x1c;
  param_12 = uVar14;
  do {
    uVar9 = local_360;
    if (((uVar14 & uVar7) != 0) && ((&DAT_1405887d0)[lVar5] == '\0')) {
      uVar12 = local_360 + 1;
      if (local_358 >> 1 < uVar12) {
        FUN_1400575b0(&local_370);
      }
      lVar16 = local_370 + uVar9 * 0x28;
      uVar14 = param_12;
      local_360 = uVar12;
      if (lVar16 != 0) {
        FUN_140014a90(lVar16,puVar10,local_368);
        uVar14 = param_12;
      }
    }
    lVar5 = lVar5 + 1;
    puVar10 = puVar10 + 5;
    uVar7 = uVar7 << 1 | (uint)((int)uVar7 < 0);
    lVar6 = lVar6 + -1;
  } while (lVar6 != 0);
  do {
    lVar15 = lVar15 + 1;
  } while (PTR_s____UNITY__Original_start_of_shad_140728020[lVar15] != '\0');
  lVar5 = FUN_140056850(param_1,PTR_s____UNITY__Original_start_of_shad_140728020,0,lVar15);
  uVar8 = 0;
  if (lVar5 != -1) {
    uVar8 = FUN_1400e8530(param_1,0,lVar5,1,0);
  }
  ProcessShaderPreprocessor
            (&local_5c0,param_1,local_408,&local_390,local_3b0,&local_370,&DAT_1407284f0,0xe,
             &local_658,&local_678,&local_6e8,&local_698,&local_6b8,local_348,0);
  uVar2 = param_23;
  ProcessPreprocessorPragmaState(&local_698,&local_6b8,param_23);
  FUN_1400bd110(&local_678,param_2,uVar8,param_15,local_338,uVar2);
  uVar12 = local_390;
  lVar5 = (longlong)(local_380 * 0x50) / 0x50;
  lVar6 = (longlong)(local_3a0 * 0x50) / 0x50;
  lVar15 = local_3a0 - lVar6;
  uVar9 = lVar5 + local_3a0;
  if (local_398 >> 1 < uVar9) {
    FUN_140059880(local_3b0,uVar9,0);
  }
  lVar6 = lVar6 * 0x50 + local_3b0[0];
  local_3a0 = uVar9;
  FUN_140558820(lVar5 * 0x50 + lVar6,lVar6,lVar15 * 0x50);
  if (lVar5 != 0) {
    lVar15 = lVar6 - uVar12;
    lVar16 = (uVar12 - lVar6) + 0x28;
    lVar17 = uVar12 - lVar6;
    do {
      if (lVar6 != 0) {
        FUN_1400149f0(lVar6,lVar17 + lVar6);
        FUN_1400149f0(lVar16 + lVar15 + lVar6,lVar16 + lVar6);
      }
      lVar6 = lVar6 + 0x50;
      lVar5 = lVar5 + -1;
    } while (lVar5 != 0);
  }
  local_768 = DAT_1407284f0;
  local_750 = DAT_140728500;
  local_760 = DAT_140728500;
  if (DAT_14072850f < 0x40) {
    local_760 = 0x1f - (longlong)(char)DAT_14072850f;
    local_768 = &DAT_1407284f0;
    local_750 = 0x1f - (longlong)(char)DAT_14072850f;
  }
  local_758 = local_768;
  FUN_140014b30(&local_738,&local_758,0x4b);
  FUN_140014b30(local_710,&local_768,0x4b);
  uVar9 = local_380;
  local_380 = 0;
  if (uVar9 != 0) {
    FUN_14000fd90(local_390);
  }
  if ((local_6f1 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(local_710[0],local_6f0,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  if ((local_719 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_737,local_738),local_718,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  cVar3 = CheckStageSlotsNotEmpty(local_338,param_2,uVar2);
  if ((cVar3 == '\0') && (cVar3 = FUN_14008ee50(uVar2), cVar3 == '\0')) {
    if (param_9 != 0) {
      local_718 = 1;
      local_719 = 0x1f;
      local_758 = (undefined8 *)0x0;
      local_750 = CONCAT62(local_750._2_6_,(short)param_8[1]);
      local_748 = 0;
      local_740 = 1;
      local_738 = cVar3;
      FUN_140054d80(&local_758,*param_8,*param_8 + param_8[2] * 0x28);
      FUN_140095b10(&local_758,0,&local_738);
      if (local_719 < 0x40) {
        local_728 = 0x1f - (longlong)(char)local_719;
      }
      pcVar13 = &local_738;
      if (0x3f < local_719) {
        pcVar13 = (char *)CONCAT71(uStack_737,local_738);
      }
      FUN_140057e90(param_1,param_11,0,pcVar13,local_728);
      if ((local_719 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(CONCAT71(uStack_737,local_738),local_718,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
    }
    iVar1 = param_16;
    local_614 = param_16;
    local_610 = param_17;
    local_5d8 = param_1;
    PrepareCompileRequestSource(local_570,local_338);
    local_5cc = local_1e0;
    local_5c8 = local_1dc;
    local_5e8 = local_1d8;
    if (local_2c9 < 0x40) {
      local_2d8 = 0x1f - (longlong)(char)local_2c9;
    }
    uVar9 = param_19;
    if (local_2d8 == 0) {
      if (local_2a1 < 0x40) {
        local_2b0 = 0x1f - (longlong)(char)local_2a1;
      }
      if ((local_2b0 == 0) && ((param_19 >> 0x11 & 1) != 0)) {
        uVar9 = param_19 & 0xfffffffffffcffff;
      }
    }
    if (local_279 < 0x40) {
      local_288 = 0x1f - (longlong)(char)local_279;
    }
    if ((local_288 == 0) && ((uVar9 >> 0xc & 1) != 0)) {
      uVar9 = uVar9 & 0xffffffffffffefff;
    }
    local_5f0 = local_220 | param_14;
    local_618 = param_2;
    SetCompilerAvailabilityMacros
              (*(ulonglong *)(&DAT_140728a90 + (longlong)param_18 * 8) | uVar9,local_3b0);
    local_5f0 = local_5f0 | 0x8000;
    local_620 = param_20;
    if (iVar1 == 6) {
      plVar4 = (longlong *)(**(code **)(*DAT_14074ece0 + 0x30))();
    }
    else {
      plVar4 = (longlong *)(**(code **)(*DAT_14074ece0 + 0x18))(DAT_14074ece0,local_628);
    }
    if (plVar4 != (longlong *)0x0) {
      CollectCompiledPrograms(uVar2,local_628,plVar4);
      cVar3 = FUN_14008ee50(uVar2);
      if (cVar3 == '\0') {
        lVar5 = (**(code **)(*plVar4 + 8))(plVar4);
        if (lVar5 != 0) {
          lVar6 = (**(code **)(*plVar4 + 0x10))(plVar4);
          FUN_1400af770(param_21,lVar5,lVar5 + lVar6);
        }
        uVar8 = (**(code **)(*plVar4 + 0x20))(plVar4);
        *param_22 = uVar8;
      }
      (**(code **)(*DAT_14074ece0 + 0x38))(DAT_14074ece0,plVar4);
    }
  }
  FUN_140018570(&local_6b8);
  FUN_140018570(&local_698);
  FUN_140017d70(&local_678);
  if ((local_639 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_657,local_658),local_638,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  FUN_1400171d0(&local_6d0);
  FUN_1400171d0(&local_6e8);
  FUN_140017d70(&local_60);
  FUN_1400aff80(local_1d0);
  if ((local_1e9 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(local_208,local_1e8,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  _eh_vector_destructor_iterator_(local_338,0x28,7,FUN_140017380);
  FUN_140019570(local_628);
  return;
}
```

## `GenerateGlslStageSource` — `0x1400b8600`

GLSL frontend

```c
/* WARNING: Removing unreachable block (ram,0x0001400b8cd6) */
/* WARNING: Type propagation algorithm not settling */
/* GLSL frontend. Prepends keyword #defines, drops the #version line, extracts pragmas, rewrites "//
   #pragma " to "#pragma ", injects GLSLSupport.glslinc / UnityStereoExtensions.glslinc /
   UnityStereoSupport.glslinc and renames texture2D -> textureExternal, texture2DProj ->
   textureProjExternal. */

void GenerateGlslStageSource
               (undefined8 *param_1,undefined4 param_2,longlong *param_3,undefined8 param_4,
               undefined8 param_5,longlong *param_6,longlong *param_7)

{
  undefined1 *puVar1;
  undefined4 uVar2;
  undefined4 uVar3;
  undefined *puVar4;
  char cVar5;
  undefined4 uVar6;
  longlong lVar7;
  char *pcVar8;
  char *pcVar9;
  char *pcVar10;
  ulonglong uVar11;
  undefined8 uVar12;
  ulonglong uVar13;
  undefined1 *puVar14;
  undefined8 *puVar15;
  ulonglong uVar16;
  undefined1 *puVar17;
  uint uVar18;
  undefined1 *puVar19;
  longlong lVar20;
  ulonglong uVar21;
  ulonglong uVar22;
  undefined4 in_stack_00000078;
  int in_stack_00000090;
  ulonglong in_stack_00000098;
  longlong *in_stack_000000a8;
  undefined4 *in_stack_000000b0;
  undefined8 in_stack_000000b8;
  undefined4 **local_768;
  ulonglong local_760;
  undefined1 local_758 [8];
  longlong *local_750;
  ulonglong local_748;
  char local_740;
  undefined7 uStack_73f;
  ulonglong local_738;
  ulonglong local_730;
  byte local_721;
  undefined2 local_720;
  undefined8 local_718 [2];
  longlong local_708;
  byte local_6f9;
  undefined2 local_6f8;
  ulonglong local_6f0;
  undefined8 local_6e8 [3];
  byte local_6c9;
  undefined2 local_6c8;
  undefined1 local_6c0;
  undefined7 uStack_6bf;
  ulonglong local_6b0;
  byte local_6a1;
  undefined2 local_6a0;
  longlong local_698 [2];
  ulonglong local_688;
  byte local_679;
  undefined2 local_678;
  undefined1 local_670;
  undefined7 uStack_66f;
  ulonglong local_660;
  byte local_651;
  undefined2 local_650;
  undefined8 local_648;
  undefined2 local_640;
  undefined8 local_638;
  undefined8 uStack_630;
  undefined4 *local_628;
  undefined8 local_620;
  undefined4 local_618;
  undefined2 local_612;
  undefined1 local_608 [96];
  longlong local_5a8;
  byte local_599;
  longlong local_580;
  byte local_571;
  longlong local_558;
  byte local_549;
  ulonglong local_4f0;
  undefined8 local_4d8;
  byte local_4b9;
  undefined2 local_4b8;
  undefined1 local_4a0 [360];
  undefined8 local_338;
  undefined8 local_330;
  undefined2 local_328;
  undefined8 local_320;
  undefined8 local_318;
  int local_310;
  undefined4 local_30c;
  undefined1 local_308 [632];
  undefined1 local_90 [104];
  
  FUN_140015ef0(local_608);
  FUN_1400afd40(local_4a0);
  local_338 = 0x21;
  uVar22 = 0;
  local_330 = 0;
  local_328 = 0x19;
  local_320 = 0;
  local_318 = 1;
  local_30c = 0;
  local_310 = 1 << ((byte)in_stack_00000090 & 0x1f);
  SplitSourceByPragmaDirective(param_1,param_2,in_stack_00000078,local_608,in_stack_000000b8);
  if ((local_310 == 0) || (cVar5 = FUN_14008ee50(in_stack_000000b8), cVar5 != '\0'))
  goto LAB_1400b95bb;
  uVar11 = (ulonglong)_tls_index;
  if ((*(int *)(*(longlong *)((longlong)ThreadLocalStoragePointer + uVar11 * 8) + 0x1c) <
       DAT_14074fcd0) && (FUN_1403d6258(&DAT_14074fcd0), uVar13 = uVar22, DAT_14074fcd0 == -1)) {
    do {
      if ("#define "[uVar13] == '\0') goto LAB_1400b969a;
      uVar13 = uVar13 + 1;
    } while (uVar13 < 9);
    uVar13 = 9;
LAB_1400b969a:
    DAT_1407285d8 = uVar13;
    atexit((_func_5014 *)&DAT_1405753d0);
    _Init_thread_footer(&DAT_14074fcd0);
  }
  if ((*(int *)(*(longlong *)((longlong)ThreadLocalStoragePointer + uVar11 * 8) + 0x1c) <
       DAT_14074fcd4) && (FUN_1403d6258(&DAT_14074fcd4), uVar11 = uVar22, DAT_14074fcd4 == -1)) {
    do {
      if ((&DAT_140584ac4)[uVar11] == '\0') goto LAB_1400b96f8;
      uVar11 = uVar11 + 1;
    } while (uVar11 < 4);
    uVar11 = 4;
LAB_1400b96f8:
    DAT_1407285e8 = uVar11;
    atexit((_func_5014 *)&DAT_1405753f0);
    _Init_thread_footer(&DAT_14074fcd4);
  }
  local_6a0 = 1;
  local_6c0 = 0;
  local_6a1 = 0x1f;
  uVar11 = uVar22;
  uVar13 = uVar22;
  if (param_6[2] != 0) {
    do {
      FUN_1400543f0(&local_6c0,PTR_s__define_1407285d0,DAT_1407285d8);
      puVar15 = (undefined8 *)(*param_6 + uVar11);
      if (*(byte *)((longlong)puVar15 + 0x1f) < 0x40) {
        lVar20 = 0x1f - (longlong)*(char *)((longlong)puVar15 + 0x1f);
      }
      else {
        lVar20 = puVar15[2];
        puVar15 = (undefined8 *)*puVar15;
      }
      FUN_1400543f0(&local_6c0,puVar15,lVar20);
      FUN_1400543f0(&local_6c0,PTR_DAT_1407285e0,DAT_1407285e8);
      uVar18 = (int)uVar13 + 1;
      uVar11 = uVar11 + 0x28;
      uVar13 = (ulonglong)uVar18;
    } while ((ulonglong)(longlong)(int)uVar18 < (ulonglong)param_6[2]);
  }
  uVar11 = uVar22;
  uVar13 = uVar22;
  if (param_7[2] != 0) {
    do {
      FUN_1400543f0(&local_6c0,PTR_s__define_1407285d0,DAT_1407285d8);
      puVar15 = (undefined8 *)(*param_7 + uVar11);
      if (*(byte *)((longlong)puVar15 + 0x1f) < 0x40) {
        lVar20 = 0x1f - (longlong)*(char *)((longlong)puVar15 + 0x1f);
      }
      else {
        lVar20 = puVar15[2];
        puVar15 = (undefined8 *)*puVar15;
      }
      FUN_1400543f0(&local_6c0,puVar15,lVar20);
      FUN_1400543f0(&local_6c0,PTR_DAT_1407285e0,DAT_1407285e8);
      uVar18 = (int)uVar13 + 1;
      uVar11 = uVar11 + 0x28;
      uVar13 = (ulonglong)uVar18;
    } while ((ulonglong)(longlong)(int)uVar18 < (ulonglong)param_7[2]);
  }
  lVar20 = FUN_140056850(param_1,"#version ",0,9);
  uVar11 = uVar22;
  if (lVar20 != -1) {
    local_758[0] = 10;
    lVar20 = FUN_140056850(param_1,local_758,lVar20,1);
    uVar11 = lVar20 + 1;
  }
  local_6f8 = *(undefined2 *)(param_1 + 4);
  local_718[0]._0_1_ = 0;
  local_6f9 = 0x1f;
  lVar20 = local_708;
  local_6f0 = uVar11;
  if (local_718 != param_1) {
    if (*(byte *)((longlong)param_1 + 0x1f) < 0x40) {
      lVar20 = 0x1f - (longlong)*(char *)((longlong)param_1 + 0x1f);
      puVar15 = param_1;
    }
    else {
      lVar20 = param_1[2];
      puVar15 = (undefined8 *)*param_1;
    }
    local_718[0]._0_1_ = 0;
    local_6f9 = 0x1f;
    lVar7 = FUN_140056c90(local_718,lVar20);
    FUN_140558820(lVar7,puVar15,lVar20);
    *(undefined1 *)(lVar7 + lVar20) = 0;
    if (local_6f9 < 0x40) {
      local_6f9 = 0x1f - (char)lVar20;
      lVar20 = local_708;
    }
  }
  local_708 = lVar20;
  local_678 = 0x4b;
  local_698[0]._0_1_ = '\0';
  local_679 = 0x1f;
  local_650 = 0x4b;
  local_670 = 0;
  local_651 = 0x1f;
  FUN_1400bae40(param_1,uVar11,local_698,&local_670,&local_768,in_stack_000000b8,in_stack_00000090);
  cVar5 = FUN_14008ee50(in_stack_000000b8);
  if (cVar5 == '\0') {
    if (local_768 != (undefined4 **)0x0) {
      if (local_679 < 0x40) {
        local_688 = 0x1f - (longlong)(char)local_679;
      }
      local_750 = local_698;
      if (0x3f < local_679) {
        local_750 = (longlong *)CONCAT71(local_698[0]._1_7_,(char)local_698[0]);
      }
      local_748 = local_688;
      uVar12 = FUN_14001aaa0(local_6e8,&local_670,&local_750);
      FUN_1400545d0(local_718,uVar12);
      if ((local_6c9 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(local_6e8[0],local_6c8,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      if (local_651 < 0x40) {
        local_6f0 = 0x1f - (longlong)(char)local_651;
      }
      else {
        local_6f0 = local_660;
      }
    }
    if ((local_651 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(uStack_66f,local_670),local_650,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    if ((local_679 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(local_698[0]._1_7_,(char)local_698[0]),local_678,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
  }
  else {
    if ((local_651 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(uStack_66f,local_670),local_650,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    if ((local_679 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(local_698[0]._1_7_,(char)local_698[0]),local_678,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
  }
  FUN_140015c70(local_308);
  local_720 = local_6a0;
  if (local_6a1 < 0x40) {
    local_6b0 = 0x1f - (longlong)(char)local_6a1;
  }
  puVar14 = &local_6c0;
  if (0x3f < local_6a1) {
    puVar14 = (undefined1 *)CONCAT71(uStack_6bf,local_6c0);
  }
  local_740 = '\0';
  local_721 = 0x1f;
  lVar20 = FUN_140056c90(&local_740,local_6b0);
  FUN_140558820(lVar20,puVar14,local_6b0);
  *(undefined1 *)(lVar20 + local_6b0) = 0;
  if (local_721 < 0x40) {
    local_721 = 0x1f - (char)local_6b0;
    local_6b0 = local_730;
  }
  local_730 = local_6b0;
  FUN_1400b1740(in_stack_00000098,local_90);
  pcVar8 = (char *)FUN_1400bf730(local_6e8,local_308,in_stack_00000090);
  if ((byte)pcVar8[0x1f] < 0x40) {
    lVar20 = 0x1f - (longlong)pcVar8[0x1f];
  }
  else {
    lVar20 = *(longlong *)(pcVar8 + 0x10);
    pcVar8 = *(char **)pcVar8;
  }
  uVar11 = local_730;
  if (lVar20 != 0) {
    uVar13 = local_730;
    if (local_721 < 0x40) {
      uVar13 = 0x1f - (longlong)(char)local_721;
    }
    uVar11 = uVar13 + lVar20;
    uVar21 = local_738;
    if (local_721 < 0x40) {
      uVar21 = 0x1f;
    }
    if (uVar21 < uVar11) {
      uVar16 = uVar21 * 2;
      if (uVar21 * 2 <= uVar11) {
        uVar16 = uVar11;
      }
      pcVar9 = &local_740;
      if (0x3f < local_721) {
        pcVar9 = (char *)CONCAT71(uStack_73f,local_740);
      }
      if (pcVar9 <= pcVar8) {
        uVar21 = local_730;
        if (local_721 < 0x40) {
          uVar21 = 0x1f - (longlong)(char)local_721;
        }
        if (pcVar8 < pcVar9 + uVar21) {
          pcVar10 = &local_740;
          if (0x3f < local_721) {
            pcVar10 = (char *)CONCAT71(uStack_73f,local_740);
          }
          pcVar9 = (char *)FUN_140056c90(&local_740,uVar16);
          pcVar8 = pcVar9 + ((longlong)pcVar8 - (longlong)pcVar10);
          goto LAB_1400b8c1e;
        }
      }
      pcVar9 = (char *)FUN_140056c90(&local_740,uVar16);
    }
    else {
      pcVar9 = &local_740;
      if (0x3f < local_721) {
        pcVar9 = (char *)CONCAT71(uStack_73f,local_740);
      }
    }
LAB_1400b8c1e:
    FUN_140558820(pcVar9 + uVar13,pcVar8,lVar20);
    pcVar9[uVar11] = '\0';
    if (local_721 < 0x40) {
      local_721 = 0x1f - (char)uVar11;
      uVar11 = local_730;
    }
  }
  local_730 = uVar11;
  if ((local_6c9 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(local_6e8[0],local_6c8,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  if ((*(int *)(*(longlong *)((longlong)ThreadLocalStoragePointer + (ulonglong)_tls_index * 8) +
               0x1c) < DAT_14074fcd8) &&
     (FUN_1403d6258(&DAT_14074fcd8), uVar11 = uVar22, DAT_14074fcd8 == -1)) {
    do {
      if ("UNITY_SETUP_STEREO_RENDERING"[uVar11] == '\0') goto LAB_1400b9642;
      uVar11 = uVar11 + 1;
    } while (uVar11 < 0x1d);
    uVar11 = 0x1d;
LAB_1400b9642:
    DAT_1407285f8 = uVar11;
    atexit((_func_5014 *)&DAT_140575c70);
    _Init_thread_footer(&DAT_14074fcd8);
  }
  uVar11 = DAT_1407285f8;
  puVar4 = PTR_s_UNITY_SETUP_STEREO_RENDERING_1407285f0;
  lVar20 = FUN_140056850(local_718,PTR_s_UNITY_SETUP_STEREO_RENDERING_1407285f0,0,DAT_1407285f8);
  if (lVar20 == -1) {
    FUN_1400543f0(&local_740,"#include \"GLSLSupport.glslinc\"\n",0x1f);
    uVar11 = local_730;
  }
  else {
    local_748 = 0;
    local_750 = (longlong *)&DAT_140578094;
    local_768 = (undefined4 **)puVar4;
    local_760 = uVar11;
    FUN_1400e22b0(local_718,&local_768,&local_750,0);
    uVar11 = local_730;
    if (local_721 < 0x40) {
      uVar11 = 0x1f - (longlong)(char)local_721;
    }
    uVar13 = uVar11 + 0x29;
    uVar21 = local_738;
    if (local_721 < 0x40) {
      uVar21 = 0x1f;
    }
    if (uVar21 < uVar13) {
      uVar16 = uVar21 * 2;
      if (uVar21 * 2 <= uVar13) {
        uVar16 = uVar13;
      }
      pcVar8 = &local_740;
      if (0x3f < local_721) {
        pcVar8 = (char *)CONCAT71(uStack_73f,local_740);
      }
      if (pcVar8 < "include \"UnityStereoExtensions.glslinc\"\n") {
        uVar21 = local_730;
        if (local_721 < 0x40) {
          uVar21 = 0x1f - (longlong)(char)local_721;
        }
        if ("#include \"UnityStereoExtensions.glslinc\"\n" < pcVar8 + uVar21) {
          pcVar8 = &local_740;
          if (0x3f < local_721) {
            pcVar8 = (char *)CONCAT71(uStack_73f,local_740);
          }
          lVar20 = -(longlong)pcVar8;
          pcVar10 = (char *)FUN_140056c90(&local_740,uVar16);
          uVar12 = *(undefined8 *)
                    (pcVar10 + (longlong)"#include \"UnityStereoExtensions.glslinc\"\n" + lVar20 + 8
                    );
          *(undefined8 *)(pcVar10 + uVar11) =
               *(undefined8 *)
                (pcVar10 + (longlong)"#include \"UnityStereoExtensions.glslinc\"\n" + lVar20);
          *(undefined8 *)(pcVar10 + uVar11 + 8) = uVar12;
          pcVar8 = pcVar10 + (longlong)
                             ("#include \"UnityStereoExtensions.glslinc\"\n" + lVar20 + 0x10);
          uVar6 = *(undefined4 *)(pcVar8 + 4);
          uVar2 = *(undefined4 *)(pcVar8 + 8);
          uVar3 = *(undefined4 *)(pcVar8 + 0xc);
          pcVar9 = pcVar10 + uVar11 + 0x10;
          *(undefined4 *)pcVar9 = *(undefined4 *)pcVar8;
          *(undefined4 *)(pcVar9 + 4) = uVar6;
          *(undefined4 *)(pcVar9 + 8) = uVar2;
          *(undefined4 *)(pcVar9 + 0xc) = uVar3;
          *(undefined8 *)(pcVar10 + uVar11 + 0x20) =
               *(undefined8 *)
                (pcVar10 +
                (longlong)("#include \"UnityStereoExtensions.glslinc\"\n" + lVar20 + 0x20));
          pcVar10[uVar11 + 0x28] =
               pcVar10[(longlong)("#include \"UnityStereoExtensions.glslinc\"\n" + lVar20 + 0x28)];
          goto LAB_1400b8e4c;
        }
      }
      pcVar10 = (char *)FUN_140056c90(&local_740,uVar16);
      builtin_strncpy(pcVar10 + uVar11,"#include \"UnityStereoExtensions.glslinc\"\n",0x29);
    }
    else {
      pcVar10 = &local_740;
      if (0x3f < local_721) {
        pcVar10 = (char *)CONCAT71(uStack_73f,local_740);
      }
      builtin_strncpy(pcVar10 + uVar11,"#include \"UnityStereoExtensions.glslinc\"\n",0x29);
    }
LAB_1400b8e4c:
    pcVar10[uVar13] = '\0';
    if (local_721 < 0x40) {
      local_721 = 0x1f - (char)uVar13;
      uVar13 = local_730;
    }
    local_730 = uVar13;
    FUN_1400543f0(&local_740,"#include \"GLSLSupport.glslinc\"\n",0x1f);
    uVar13 = local_730;
    if (local_721 < 0x40) {
      uVar13 = 0x1f - (longlong)(char)local_721;
    }
    uVar11 = uVar13 + 0x26;
    if (local_721 < 0x40) {
      local_738 = 0x1f;
    }
    if (local_738 < uVar11) {
      uVar21 = local_738 * 2;
      if (local_738 * 2 <= uVar11) {
        uVar21 = uVar11;
      }
      pcVar8 = &local_740;
      if (0x3f < local_721) {
        pcVar8 = (char *)CONCAT71(uStack_73f,local_740);
      }
      if (pcVar8 < "include \"UnityStereoSupport.glslinc\"\n") {
        uVar16 = local_730;
        if (local_721 < 0x40) {
          uVar16 = 0x1f - (longlong)(char)local_721;
        }
        if ("#include \"UnityStereoSupport.glslinc\"\n" < pcVar8 + uVar16) {
          pcVar8 = &local_740;
          if (0x3f < local_721) {
            pcVar8 = (char *)CONCAT71(uStack_73f,local_740);
          }
          lVar20 = -(longlong)pcVar8;
          pcVar8 = (char *)FUN_140056c90(&local_740,uVar21);
          uVar12 = *(undefined8 *)
                    (pcVar8 + (longlong)"#include \"UnityStereoSupport.glslinc\"\n" + lVar20 + 8);
          *(undefined8 *)(pcVar8 + uVar13) =
               *(undefined8 *)
                (pcVar8 + (longlong)"#include \"UnityStereoSupport.glslinc\"\n" + lVar20);
          *(undefined8 *)(pcVar8 + uVar13 + 8) = uVar12;
          uVar12 = *(undefined8 *)
                    (pcVar8 + (longlong)
                              ("#include \"UnityStereoSupport.glslinc\"\n" + lVar20 + 0x10) + 8);
          *(undefined8 *)(pcVar8 + uVar13 + 0x10) =
               *(undefined8 *)
                (pcVar8 + (longlong)("#include \"UnityStereoSupport.glslinc\"\n" + lVar20 + 0x10));
          *(undefined8 *)(pcVar8 + uVar13 + 0x10 + 8) = uVar12;
          *(undefined4 *)(pcVar8 + uVar13 + 0x20) =
               *(undefined4 *)
                (pcVar8 + (longlong)("#include \"UnityStereoSupport.glslinc\"\n" + lVar20 + 0x20));
          *(undefined2 *)(pcVar8 + uVar13 + 0x24) =
               *(undefined2 *)
                (pcVar8 + (longlong)("#include \"UnityStereoSupport.glslinc\"\n" + lVar20 + 0x24));
          goto LAB_1400b8fae;
        }
      }
      pcVar8 = (char *)FUN_140056c90(&local_740,uVar21);
      builtin_strncpy(pcVar8 + uVar13,"#include \"UnityStereoSupport.glslinc\"\n",0x26);
    }
    else {
      pcVar8 = &local_740;
      if (0x3f < local_721) {
        pcVar8 = (char *)CONCAT71(uStack_73f,local_740);
      }
      builtin_strncpy(pcVar8 + uVar13,"#include \"UnityStereoSupport.glslinc\"\n",0x26);
    }
LAB_1400b8fae:
    pcVar8[uVar11] = '\0';
    if (local_721 < 0x40) {
      local_721 = 0x1f - (char)uVar11;
      uVar11 = local_730;
    }
  }
  local_730 = uVar11;
  if (local_599 < 0x40) {
    local_5a8 = 0x1f - (longlong)(char)local_599;
  }
  if (local_5a8 == 0) {
    if (local_571 < 0x40) {
      local_580 = 0x1f - (longlong)(char)local_571;
    }
    if ((local_580 == 0) && ((in_stack_00000098 >> 0x11 & 1) != 0)) {
      in_stack_00000098 = in_stack_00000098 & 0xfffffffffffcffff;
    }
  }
  if (local_549 < 0x40) {
    local_558 = 0x1f - (longlong)(char)local_549;
  }
  if ((local_558 == 0) && ((in_stack_00000098 >> 0xc & 1) != 0)) {
    in_stack_00000098 = in_stack_00000098 & 0xffffffffffffefff;
  }
  FUN_14005b790(local_718,&local_740);
  uVar11 = local_730;
  if (local_721 < 0x40) {
    uVar11 = 0x1f - (longlong)(char)local_721;
  }
  pcVar8 = &local_740;
  if (0x3f < local_721) {
    pcVar8 = (char *)CONCAT71(uStack_73f,local_740);
  }
  FUN_140057e90(local_718,local_6f0,0,pcVar8,uVar11);
  local_648 = 0;
  local_640 = DAT_140728520;
  local_638 = 0;
  uStack_630 = 1;
  FUN_140054d80(&local_648,DAT_140728518,DAT_140728518 + DAT_140728528 * 0x28);
  local_768 = &local_628;
  local_628 = &DAT_14058aa4c;
  local_620 = 0;
  local_618 = 0;
  local_612 = DAT_14072854e;
  FUN_140019e80(&local_628,&PTR_DAT_140728538);
  if (*(byte *)((longlong)param_3 + 0x1f) < 0x40) {
    local_748 = 0x1f - (longlong)*(char *)((longlong)param_3 + 0x1f);
  }
  else {
    local_748 = param_3[2];
    param_3 = (longlong *)*param_3;
  }
  local_750 = param_3;
  FUN_1400c0f50(&local_648,&local_750);
  FUN_140093350(local_718,&local_648,in_stack_000000b8,in_stack_00000090);
  cVar5 = FUN_14008ee50(in_stack_000000b8);
  uVar11 = uVar22;
  if (cVar5 == '\0') {
    do {
      if ("// #pragma "[uVar11] == '\0') goto LAB_1400b91b4;
      uVar11 = uVar11 + 1;
    } while (uVar11 < 0xc);
    uVar11 = 0xc;
LAB_1400b91b4:
    local_750 = (longlong *)0x140588a38;
    local_760 = uVar22;
    do {
      if ("#pragma "[local_760] == '\0') goto LAB_1400b91dc;
      local_760 = local_760 + 1;
    } while (local_760 < 9);
    local_760 = 9;
LAB_1400b91dc:
    local_768 = (undefined4 **)0x14057f730;
    local_748 = uVar11;
    FUN_1400e22b0(local_718,&local_768,&local_750,0);
    local_748 = uVar22;
    do {
      if ((&DAT_14057df28)[local_748] == '\0') goto LAB_1400b9225;
      local_748 = local_748 + 1;
    } while (local_748 < 2);
    local_748 = 2;
LAB_1400b9225:
    local_750 = (longlong *)&DAT_14057df28;
    uVar11 = uVar22;
    do {
      local_760 = uVar11;
      if ((&DAT_140585b8c)[uVar11] == '\0') break;
      uVar11 = uVar11 + 1;
      local_760 = 2;
    } while (uVar11 < 2);
    local_768 = (undefined4 **)&DAT_140585b8c;
    FUN_1400e22b0(local_718,&local_768,&local_750,0);
    if (in_stack_00000090 == 9) {
      if ((local_4f0 & 0x800) == 0) {
        uVar12 = FUN_14005dba0(local_6e8,local_718);
        FUN_1400545d0(local_718,uVar12);
      }
      else {
        uVar12 = FUN_14005d470();
        FUN_1400545d0(local_718,uVar12);
      }
    }
    else {
      uVar12 = FUN_14005e6f0();
      FUN_1400545d0(local_718,uVar12);
    }
    uVar11 = uVar22;
    if ((local_6c9 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(local_6e8[0],local_6c8,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    do {
      if ("texture2D"[uVar11] == '\0') goto LAB_1400b9314;
      uVar11 = uVar11 + 1;
    } while (uVar11 < 10);
    uVar11 = 10;
LAB_1400b9314:
    local_750 = (longlong *)0x14057d2a0;
    local_760 = uVar22;
    do {
      if ("textureExternal"[local_760] == '\0') goto LAB_1400b933c;
      local_760 = local_760 + 1;
    } while (local_760 < 0x10);
    local_760 = 0x10;
LAB_1400b933c:
    local_768 = (undefined4 **)0x140588968;
    local_748 = uVar11;
    FUN_1400e22b0(local_718,&local_768,&local_750,0);
    local_748 = uVar22;
    do {
      if ("texture2DProj"[local_748] == '\0') goto LAB_1400b937a;
      local_748 = local_748 + 1;
    } while (local_748 < 0xe);
    local_748 = 0xe;
LAB_1400b937a:
    local_750 = (longlong *)0x140588978;
    do {
      if ("textureProjExternal"[uVar22] == '\0') goto LAB_1400b93a6;
      uVar22 = uVar22 + 1;
    } while (uVar22 < 0x14);
    uVar22 = 0x14;
LAB_1400b93a6:
    local_768 = (undefined4 **)0x140588988;
    local_760 = uVar22;
    FUN_1400e22b0(local_718,&local_768,&local_750,0);
    uVar6 = FUN_14008e9e0(in_stack_00000098,in_stack_00000090);
    *in_stack_000000b0 = uVar6;
    if ((local_6f9 & 0xc0) == 0x80) {
      lVar20 = local_708;
      if (local_6f9 < 0x40) {
        lVar20 = 0x1f - (longlong)(char)local_6f9;
      }
      FUN_140056c90(local_718,lVar20);
    }
    puVar14 = (undefined1 *)CONCAT71(local_718[0]._1_7_,(undefined1)local_718[0]);
    lVar20 = local_708;
    puVar19 = puVar14;
    if (local_6f9 < 0x40) {
      lVar20 = 0x1f - (longlong)(char)local_6f9;
      puVar19 = (undefined1 *)local_718;
    }
    if ((local_6f9 & 0xc0) == 0x80) {
      lVar7 = local_708;
      if (local_6f9 < 0x40) {
        lVar7 = 0x1f - (longlong)(char)local_6f9;
      }
      FUN_140056c90(local_718,lVar7);
      puVar14 = (undefined1 *)CONCAT71(local_718[0]._1_7_,(undefined1)local_718[0]);
    }
    puVar17 = (undefined1 *)local_718;
    if (0x3f < local_6f9) {
      puVar17 = puVar14;
    }
    puVar19 = puVar19 + (lVar20 - (longlong)puVar17);
    if ((undefined1 *)(in_stack_000000a8[2] - *in_stack_000000a8) < puVar19) {
      FUN_1400c9830(in_stack_000000a8,puVar19);
      puVar14 = (undefined1 *)*in_stack_000000a8;
      if (puVar19 == (undefined1 *)0x0) {
LAB_1400b94ff:
        in_stack_000000a8[1] = (longlong)puVar14;
      }
      else {
        lVar20 = (longlong)puVar17 - (longlong)puVar14;
        do {
          *puVar14 = puVar14[lVar20];
          puVar14 = puVar14 + 1;
          puVar19 = puVar19 + -1;
        } while (puVar19 != (undefined1 *)0x0);
        in_stack_000000a8[1] = (longlong)puVar14;
      }
    }
    else {
      lVar20 = in_stack_000000a8[1];
      lVar7 = *in_stack_000000a8;
      puVar14 = (undefined1 *)*in_stack_000000a8;
      if ((undefined1 *)(lVar20 - lVar7) < puVar19) {
        if (puVar14 != (undefined1 *)in_stack_000000a8[1]) {
          do {
            *puVar14 = *puVar17;
            puVar14 = puVar14 + 1;
            puVar17 = puVar17 + 1;
          } while (puVar14 != (undefined1 *)in_stack_000000a8[1]);
        }
        puVar14 = (undefined1 *)in_stack_000000a8[1];
        lVar20 = (longlong)puVar19 - (lVar20 - lVar7);
        if (lVar20 != 0) {
          lVar7 = (longlong)puVar17 - (longlong)puVar14;
          do {
            *puVar14 = puVar14[lVar7];
            puVar14 = puVar14 + 1;
            lVar20 = lVar20 + -1;
          } while (lVar20 != 0);
        }
        goto LAB_1400b94ff;
      }
      puVar1 = puVar14 + (longlong)puVar19;
      for (; puVar19 != (undefined1 *)0x0; puVar19 = puVar19 + -1) {
        *puVar14 = *puVar17;
        puVar14 = puVar14 + 1;
        puVar17 = puVar17 + 1;
      }
      in_stack_000000a8[1] = (longlong)puVar1;
    }
  }
  FUN_140055550(&local_628);
  FUN_140018ba0(&local_648);
  if ((local_721 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_73f,local_740),local_720,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  FUN_140019570(local_308);
  if ((local_6f9 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(local_718[0]._1_7_,(undefined1)local_718[0]),local_6f8,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  if ((local_6a1 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_6bf,local_6c0),local_6a0,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
LAB_1400b95bb:
  FUN_140017d70(&local_330);
  FUN_1400aff80(local_4a0);
  if ((local_4b9 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(local_4d8,local_4b8,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  _eh_vector_destructor_iterator_(local_608,0x28,7,FUN_140017380);
  return;
}
```

## `GenerateMetalShaderStageSource` — `0x1400ba6e0`

Metal frontend

```c
/* Metal (MSL) frontend. Extracts pragmas, prepends keyword macros and SHADER_STAGE_*, rewrites "//
   #pragma ", converts ' to ", then fills VGlobals/FGlobals via FUN_140062940 / FUN_1400630c0 /
   FUN_1400625d0 / FUN_1400621e0 / FUN_1400640f0. */

void GenerateMetalShaderStageSource(char *param_1,undefined4 param_2)

{
  char cVar1;
  ulonglong uVar2;
  ulonglong uVar3;
  undefined8 *puVar4;
  char *pcVar5;
  longlong *plVar6;
  ulonglong uVar7;
  longlong lVar8;
  longlong lVar9;
  uint uVar10;
  longlong *in_stack_00000030;
  longlong *in_stack_00000038;
  undefined4 in_stack_00000078;
  int in_stack_00000080;
  undefined8 in_stack_000000a0;
  undefined8 in_stack_000000a8;
  int *in_stack_000000b0;
  undefined8 in_stack_000000b8;
  char *local_398;
  ulonglong local_390;
  char *local_388;
  ulonglong local_380;
  undefined1 local_378;
  undefined7 uStack_377;
  byte local_359;
  undefined2 local_358;
  undefined8 local_350 [3];
  byte local_331;
  undefined2 local_330;
  longlong local_328 [3];
  byte abStack_309 [273];
  undefined8 local_1f8;
  byte local_1d9;
  undefined2 local_1d8;
  undefined1 local_1c0 [360];
  undefined8 local_58;
  undefined8 local_50;
  undefined2 local_48;
  undefined8 local_40;
  undefined8 local_38;
  undefined8 local_30;
  
  FUN_140015ef0(local_328);
  FUN_1400afd40(local_1c0);
  local_58 = 0x21;
  uVar7 = 0;
  local_50 = 0;
  local_48 = 0x19;
  local_40 = 0;
  local_38 = 1;
  local_30 = 0x4000;
  SplitSourceByPragmaDirective(param_1,param_2,in_stack_00000078,local_328,in_stack_000000b8);
  cVar1 = CheckStageSlotsNotEmpty(local_328,param_2,in_stack_000000b8);
  if ((cVar1 == '\0') && (cVar1 = FUN_14008ee50(in_stack_000000b8), cVar1 == '\0')) {
    *in_stack_000000b0 = (in_stack_00000080 != 0) + 0x17;
    uVar3 = (ulonglong)_tls_index;
    if ((*(int *)(*(longlong *)((longlong)ThreadLocalStoragePointer + uVar3 * 8) + 0x1c) <
         DAT_14074fcdc) && (FUN_1403d6258(&DAT_14074fcdc), uVar2 = uVar7, DAT_14074fcdc == -1)) {
      do {
        if ("#define "[uVar2] == '\0') goto LAB_1400bac4b;
        uVar2 = uVar2 + 1;
      } while (uVar2 < 9);
      uVar2 = 9;
LAB_1400bac4b:
      DAT_140728608 = uVar2;
      atexit((_func_5014 *)&DAT_1405753e0);
      _Init_thread_footer(&DAT_14074fcdc);
    }
    if ((*(int *)(*(longlong *)((longlong)ThreadLocalStoragePointer + uVar3 * 8) + 0x1c) <
         DAT_14074fce0) && (FUN_1403d6258(&DAT_14074fce0), uVar3 = uVar7, DAT_14074fce0 == -1)) {
      do {
        if ((&DAT_140584ac4)[uVar3] == '\0') goto LAB_1400babf2;
        uVar3 = uVar3 + 1;
      } while (uVar3 < 4);
      uVar3 = 4;
LAB_1400babf2:
      DAT_140728618 = uVar3;
      atexit((_func_5014 *)&DAT_140575400);
      _Init_thread_footer(&DAT_14074fce0);
    }
    local_358 = 1;
    local_378 = 0;
    local_359 = 0x1f;
    uVar3 = uVar7;
    uVar2 = uVar7;
    if (in_stack_00000030[2] != 0) {
      do {
        FUN_1400543f0(&local_378,PTR_s__define_140728600,DAT_140728608);
        puVar4 = (undefined8 *)(*in_stack_00000030 + uVar3);
        if (*(byte *)((longlong)puVar4 + 0x1f) < 0x40) {
          lVar8 = 0x1f - (longlong)*(char *)((longlong)puVar4 + 0x1f);
        }
        else {
          lVar8 = puVar4[2];
          puVar4 = (undefined8 *)*puVar4;
        }
        FUN_1400543f0(&local_378,puVar4,lVar8);
        FUN_1400543f0(&local_378,PTR_DAT_140728610,DAT_140728618);
        uVar10 = (int)uVar2 + 1;
        uVar3 = uVar3 + 0x28;
        uVar2 = (ulonglong)uVar10;
      } while ((ulonglong)(longlong)(int)uVar10 < (ulonglong)in_stack_00000030[2]);
    }
    uVar3 = uVar7;
    uVar2 = uVar7;
    if (in_stack_00000038[2] != 0) {
      do {
        FUN_1400543f0(&local_378,PTR_s__define_140728600,DAT_140728608);
        puVar4 = (undefined8 *)(*in_stack_00000038 + uVar3);
        if (*(byte *)((longlong)puVar4 + 0x1f) < 0x40) {
          lVar8 = 0x1f - (longlong)*(char *)((longlong)puVar4 + 0x1f);
        }
        else {
          lVar8 = puVar4[2];
          puVar4 = (undefined8 *)*puVar4;
        }
        FUN_1400543f0(&local_378,puVar4,lVar8);
        FUN_1400543f0(&local_378,PTR_DAT_140728610,DAT_140728618);
        uVar10 = (int)uVar2 + 1;
        uVar3 = uVar3 + 0x28;
        uVar2 = (ulonglong)uVar10;
      } while ((ulonglong)(longlong)(int)uVar10 < (ulonglong)in_stack_00000038[2]);
    }
    FUN_1400543f0(&local_378,PTR_s__define_140728600,DAT_140728608);
    lVar9 = (longlong)in_stack_00000080;
    lVar8 = -1;
    do {
      lVar8 = lVar8 + 1;
    } while ((&PTR_s_SHADER_STAGE_VERTEX_140728d98)[lVar9][lVar8] != '\0');
    FUN_1400543f0(&local_378,(&PTR_s_SHADER_STAGE_VERTEX_140728d98)[lVar9]);
    FUN_1400543f0(&local_378,PTR_DAT_140728610,DAT_140728618);
    if ((byte)param_1[0x1f] < 0x40) {
      local_380 = 0x1f - (longlong)param_1[0x1f];
    }
    else {
      local_380 = *(ulonglong *)(param_1 + 0x10);
      param_1 = *(char **)param_1;
    }
    local_388 = param_1;
    FUN_14001aaa0(local_350,&local_378,&local_388);
    local_380 = uVar7;
    do {
      if ("// #pragma "[local_380] == '\0') goto LAB_1400ba9db;
      local_380 = local_380 + 1;
    } while (local_380 < 0xc);
    local_380 = 0xc;
LAB_1400ba9db:
    local_388 = "// #pragma ";
    local_390 = uVar7;
    do {
      if ("#pragma "[local_390] == '\0') goto LAB_1400baa04;
      local_390 = local_390 + 1;
    } while (local_390 < 9);
    local_390 = 9;
LAB_1400baa04:
    local_398 = "#pragma ";
    FUN_1400e22b0(local_350,&local_398,&local_388,0);
    local_380 = uVar7;
    do {
      if ((&DAT_14057df28)[local_380] == '\0') goto LAB_1400baa45;
      local_380 = local_380 + 1;
    } while (local_380 < 2);
    local_380 = 2;
LAB_1400baa45:
    local_388 = "\'";
    do {
      local_390 = uVar7;
      if ((&DAT_140585b8c)[uVar7] == '\0') break;
      uVar7 = uVar7 + 1;
      local_390 = 2;
    } while (uVar7 < 2);
    local_398 = "\"";
    FUN_1400e22b0(local_350,&local_398,&local_388,0);
    pcVar5 = "FGlobals";
    if (in_stack_00000080 == 0) {
      pcVar5 = "VGlobals";
    }
    cVar1 = FUN_140062940(local_350,pcVar5,in_stack_000000a0,in_stack_000000b8);
    if ((((cVar1 != '\0') &&
         (cVar1 = FUN_1400630c0(local_350,in_stack_000000a0,in_stack_000000b8), cVar1 != '\0')) &&
        (cVar1 = FUN_1400625d0(local_350,in_stack_000000a0,in_stack_000000b8), cVar1 != '\0')) &&
       (cVar1 = FUN_1400621e0(local_350,in_stack_000000a0,in_stack_000000b8), cVar1 != '\0')) {
      plVar6 = local_328 + lVar9 * 5;
      if (0x3f < abStack_309[lVar9 * 0x28]) {
        plVar6 = (longlong *)*plVar6;
      }
      FUN_1400640f0(in_stack_000000a8,plVar6,local_350,0);
    }
    if ((local_331 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(local_350[0],local_330,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    if ((local_359 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(uStack_377,local_378),local_358,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
  }
  FUN_140017d70(&local_50);
  FUN_1400aff80(local_1c0);
  if ((local_1d9 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(local_1f8,local_1d8,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  _eh_vector_destructor_iterator_(local_328,0x28,7,FUN_140017380);
  return;
}
```

## `SplitSourceByPragmaDirective` — `0x1400bd520`

pragma extraction and per-stage split

```c
/* WARNING: Type propagation algorithm not settling */
/* Extracts #pragma directives into the pragma set and cuts the preprocessed text into per-stage
   sources framed by "// SHADER_STAGE_<stage>_begin"/"_end". */

void SplitSourceByPragmaDirective
               (undefined8 param_1,uint param_2,undefined4 param_3,longlong param_4,
               undefined8 param_5)

{
  byte bVar1;
  longlong lVar2;
  undefined8 uVar3;
  uint uVar4;
  longlong lVar5;
  ulonglong uVar6;
  char *******pppppppcVar7;
  char ******ppppppcVar8;
  char *******pppppppcVar9;
  char ******ppppppcVar10;
  ulonglong uVar11;
  ulonglong uVar12;
  char ******ppppppcVar13;
  ulonglong uVar14;
  longlong lVar15;
  uint uVar16;
  undefined1 local_e8;
  uint7 uStack_e7;
  ulonglong local_e0;
  ulonglong local_d8;
  byte local_c9;
  undefined2 local_c8;
  char *******local_c0 [2];
  longlong local_b0;
  byte local_a1;
  undefined2 local_a0;
  ulonglong local_98;
  longlong local_90;
  undefined8 local_88;
  char *******local_80;
  longlong local_78;
  undefined1 local_70;
  undefined1 local_51;
  undefined2 local_50;
  
  lVar15 = -1;
  do {
    lVar15 = lVar15 + 1;
  } while (PTR_s____UNITY__Original_start_of_shad_140728020[lVar15] != '\0');
  lVar15 = FUN_140056850(param_1,PTR_s____UNITY__Original_start_of_shad_140728020,0);
  local_88 = 0;
  if (lVar15 != -1) {
    local_88 = FUN_1400e8530(param_1,0,lVar15,0,0);
  }
  uVar3 = local_88;
  lVar5 = FUN_1400e8800(param_1,&DAT_14074ecf0,0);
  local_50 = 0x4b;
  local_70 = 0;
  local_51 = 0x1f;
  uVar6 = (ulonglong)param_2;
  lVar15 = 0;
  do {
    while( true ) {
      lVar2 = lVar5;
      if (lVar2 == -1) {
        *(undefined4 *)(param_4 + 0x120) = param_3;
        FUN_14008a940(param_4 + 0x2d0);
        CheckVertexAndFragmentPresent(param_3,param_2,param_4,param_5);
        return;
      }
      uVar6 = FUN_1400e8530(param_1,lVar15,lVar2,0,(longlong)(int)uVar6);
      uVar11 = DAT_14074ed00;
      if (DAT_14074ed0f < 0x40) {
        uVar11 = 0x1f - (longlong)(char)DAT_14074ed0f;
      }
      local_98 = uVar6;
      local_90 = lVar2;
      FUN_1400e86c0(local_c0,param_1,lVar2 + uVar11);
      local_80 = local_c0[0];
      local_78 = local_b0;
      if (local_a1 < 0x40) {
        local_78 = 0x1f - (longlong)(char)local_a1;
        local_80 = (char *******)local_c0;
      }
      FUN_14001aaa0(&local_e8,&DAT_14074ecf0,&local_80);
      uVar4 = (int)uVar6 - (int)uVar3;
      uVar16 = param_2;
      if ((int)param_2 < (int)uVar4) {
        uVar16 = uVar4;
      }
      lVar5 = FUN_1400e8800(param_1,&DAT_14074ecf0,lVar2 + uVar11);
      if ((local_a1 & 0xc0) == 0x80) {
        lVar15 = local_b0;
        if (local_a1 < 0x40) {
          lVar15 = 0x1f - (longlong)(char)local_a1;
        }
        FUN_140056c90(local_c0,lVar15);
      }
      pppppppcVar7 = (char *******)local_c0;
      if (0x3f < local_a1) {
        pppppppcVar7 = local_c0[0];
      }
      if ((*(char *)pppppppcVar7 == ' ') || (*(char *)pppppppcVar7 == '\t')) break;
      if ((local_c9 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(CONCAT71(uStack_e7,local_e8),local_c8,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                           );
      }
      lVar15 = lVar2;
      uVar3 = local_88;
      if ((local_a1 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(local_c0[0],local_a0,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                           );
        uVar3 = local_88;
      }
    }
    if (local_c9 < 0x40) {
      local_c9 = 0x1f;
    }
    else {
      local_d8 = 0;
    }
    ppppppcVar10 = (char ******)&local_e8;
    if ((local_c9 & 0xc0) != 0) {
      ppppppcVar10 = (char ******)CONCAT71(uStack_e7,local_e8);
    }
    *(undefined1 *)ppppppcVar10 = 0;
    uVar6 = DAT_14074ed00;
    if (((longlong)(char)DAT_14074ed0f & 0xc0U) == 0) {
      uVar6 = 0x1f - (longlong)(char)DAT_14074ed0f;
    }
    ppppppcVar10 = (char ******)&DAT_14074ecf0;
    if (0x3f < DAT_14074ed0f) {
      ppppppcVar10 = DAT_14074ecf0;
    }
    if ((local_c9 & 0xc0) == 0x80) {
      local_e8 = 0;
      local_c9 = 0x1f;
      ppppppcVar13 = (char ******)((ulonglong)uStack_e7 << 8);
      ppppppcVar8 = (char ******)&local_e8;
    }
    else if (local_c9 < 0x40) {
      ppppppcVar13 = (char ******)CONCAT71(uStack_e7,local_e8);
      ppppppcVar8 = (char ******)&local_e8;
    }
    else {
      ppppppcVar13 = (char ******)CONCAT71(uStack_e7,local_e8);
      ppppppcVar8 = ppppppcVar13;
    }
    if (ppppppcVar10 < ppppppcVar8) {
LAB_1400bd815:
      bVar1 = local_c9 >> 6;
      if (bVar1 == 0) {
LAB_1400bd829:
        local_e8 = 0;
        local_c9 = 0x1f;
      }
      else if (bVar1 == 1) {
        *(undefined1 *)ppppppcVar13 = 0;
        local_d8 = 0;
      }
      else if (bVar1 == 2) goto LAB_1400bd829;
      ppppppcVar8 = (char ******)FUN_140056c90(&local_e8,uVar6);
      FUN_140558820(ppppppcVar8,ppppppcVar10,uVar6);
    }
    else {
      uVar11 = local_d8;
      if (local_c9 < 0x40) {
        uVar11 = 0x1f - (longlong)(char)local_c9;
      }
      if ((char ******)((longlong)ppppppcVar8 + uVar11) <= ppppppcVar10) goto LAB_1400bd815;
      ppppppcVar8 = (char ******)&local_e8;
      if (0x3f < local_c9) {
        ppppppcVar8 = ppppppcVar13;
      }
      FUN_140558820(ppppppcVar8,ppppppcVar10,uVar6);
    }
    *(undefined1 *)((longlong)ppppppcVar8 + uVar6) = 0;
    if ((local_c9 & 0xc0) == 0) {
      local_c9 = 0x1f - (char)uVar6;
      uVar6 = local_d8;
    }
    local_d8 = uVar6;
    lVar15 = local_b0;
    if (((longlong)(char)local_a1 & 0xc0U) == 0) {
      lVar15 = 0x1f - (longlong)(char)local_a1;
    }
    pppppppcVar7 = (char *******)local_c0;
    if (0x3f < local_a1) {
      pppppppcVar7 = local_c0[0];
    }
    uVar6 = local_d8;
    if (lVar15 != 0) {
      uVar11 = local_d8;
      if (local_c9 < 0x40) {
        uVar11 = 0x1f - (longlong)(char)local_c9;
      }
      uVar6 = uVar11 + lVar15;
      uVar12 = local_e0;
      if (local_c9 < 0x40) {
        uVar12 = 0x1f;
      }
      if (uVar12 < uVar6) {
        uVar14 = uVar12 * 2;
        if (uVar12 * 2 <= uVar6) {
          uVar14 = uVar6;
        }
        pppppppcVar9 = (char *******)&local_e8;
        if (0x3f < local_c9) {
          pppppppcVar9 = (char *******)CONCAT71(uStack_e7,local_e8);
        }
        if (pppppppcVar9 <= pppppppcVar7) {
          uVar12 = local_d8;
          if (local_c9 < 0x40) {
            uVar12 = 0x1f - (longlong)(char)local_c9;
          }
          if (pppppppcVar7 < (char *******)((longlong)pppppppcVar9 + uVar12)) {
            pppppppcVar9 = (char *******)&local_e8;
            if (0x3f < local_c9) {
              pppppppcVar9 = (char *******)CONCAT71(uStack_e7,local_e8);
            }
            ppppppcVar10 = (char ******)FUN_140056c90(&local_e8,uVar14);
            pppppppcVar7 = (char *******)
                           ((longlong)ppppppcVar10 +
                           ((longlong)pppppppcVar7 - (longlong)pppppppcVar9));
            goto LAB_1400bd96b;
          }
        }
        ppppppcVar10 = (char ******)FUN_140056c90(&local_e8,uVar14);
      }
      else {
        ppppppcVar10 = (char ******)&local_e8;
        if (0x3f < local_c9) {
          ppppppcVar10 = (char ******)CONCAT71(uStack_e7,local_e8);
        }
      }
LAB_1400bd96b:
      FUN_140558820((longlong)ppppppcVar10 + uVar11,pppppppcVar7,lVar15);
      *(undefined1 *)((longlong)ppppppcVar10 + uVar6) = 0;
      if (local_c9 < 0x40) {
        local_c9 = 0x1f - (char)uVar6;
        uVar6 = local_d8;
      }
    }
    local_d8 = uVar6;
    ParseShaderPragmaDirective(local_c0,&local_e8,uVar16,param_4,param_5);
    if ((local_c9 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(uStack_e7,local_e8),local_c8,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                         );
    }
    uVar6 = local_98;
    lVar15 = local_90;
    uVar3 = local_88;
    if ((local_a1 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(local_c0[0],local_a0,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                         );
      uVar6 = local_98;
      lVar15 = local_90;
      uVar3 = local_88;
    }
  } while( true );
}
```

## `ParseShaderPragmaDirective` — `0x1400c48f0`

`#pragma` parser

```c
/* Shader pragma parser (single parser for all commands). Recognizes surface, target,
   only_renderers, exclude_renderers, hardware_tier_variants, multi_compile*, shader_feature*,
   skip_variants, use_dxc, never_use_dxc, prefer_hlslcc, metal_use_hlslcc, glsl_no_optimize,
   enable_d3d11_debug_symbols, instancing_options, raytracing, ... and reports "Unrecognized #pragma
   directive" for the rest. */

void ParseShaderPragmaDirective
               (ulonglong param_1,undefined8 *param_2,int param_3,longlong param_4,
               undefined8 param_5)

{
  byte ****ppppbVar1;
  bool bVar2;
  char cVar3;
  char cVar4;
  uint uVar5;
  undefined8 uVar6;
  undefined4 *puVar7;
  undefined8 *puVar8;
  ulonglong uVar9;
  byte ****ppppbVar10;
  byte ****ppppbVar11;
  char *pcVar12;
  byte *pbVar13;
  byte bVar14;
  uint uVar15;
  longlong lVar16;
  int iVar17;
  longlong lVar18;
  undefined8 in_stack_ffffffffffffff08;
  undefined4 uVar20;
  ulonglong uVar19;
  undefined8 in_stack_ffffffffffffff18;
  undefined4 uVar21;
  char local_c8;
  undefined7 uStack_c7;
  longlong local_b8;
  byte local_a9;
  undefined2 local_a8;
  undefined8 local_a0;
  byte ***local_98 [2];
  longlong local_88;
  byte local_79;
  undefined2 local_78;
  int local_70 [2];
  undefined8 local_68 [3];
  byte local_49;
  undefined2 local_48;
  
  uVar21 = (undefined4)((ulonglong)in_stack_ffffffffffffff18 >> 0x20);
  uVar20 = (undefined4)((ulonglong)in_stack_ffffffffffffff08 >> 0x20);
  local_a0 = FUN_1400e8dc0(param_1,0);
  FUN_1400e8c10(local_98,param_1,&local_a0);
  local_a0 = FUN_1400e8dc0(param_1,local_a0);
  cVar4 = '\x01';
  ppppbVar10 = (byte ****)local_98[0];
  lVar18 = local_88;
  if (local_79 < 0x40) {
    ppppbVar10 = local_98;
    lVar18 = 0x1f - (longlong)(char)local_79;
  }
  pcVar12 = "profiles";
  ppppbVar11 = (byte ****)((longlong)ppppbVar10 + lVar18);
  for (; ppppbVar10 < ppppbVar11; ppppbVar10 = (byte ****)((longlong)ppppbVar10 + 1)) {
    if (*(byte *)ppppbVar10 != *pcVar12) {
      iVar17 = (uint)*(byte *)ppppbVar10 - (uint)(byte)*pcVar12;
      goto LAB_1400c49ae;
    }
    if (*pcVar12 == 0) goto LAB_1400c4a19;
    pcVar12 = pcVar12 + 1;
  }
  iVar17 = -(uint)(byte)*pcVar12;
LAB_1400c49ae:
  if (iVar17 == 0) {
    uVar6 = FUN_14001b190(&local_c8,
                          "Note: #pragma profiles is ignored (use #pragma target instead): ",param_2
                         );
    FUN_140089820(param_5,uVar6,param_3,1,CONCAT44(uVar20,0x1c));
    ppppbVar10 = (byte ****)local_98[0];
    bVar14 = local_79;
    if ((local_a9 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(uStack_c7,local_c8),local_a8,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
      ppppbVar10 = (byte ****)local_98[0];
      bVar14 = local_79;
    }
    goto LAB_1400c5c21;
  }
LAB_1400c4a19:
  ppppbVar10 = (byte ****)local_98[0];
  lVar18 = local_88;
  if (local_79 < 0x40) {
    ppppbVar10 = local_98;
    lVar18 = 0x1f - (longlong)(char)local_79;
  }
  pcVar12 = "surface";
  ppppbVar11 = (byte ****)((longlong)ppppbVar10 + lVar18);
  for (; ppppbVar10 < ppppbVar11; ppppbVar10 = (byte ****)((longlong)ppppbVar10 + 1)) {
    if (*(byte *)ppppbVar10 != *pcVar12) {
      iVar17 = (uint)*(byte *)ppppbVar10 - (uint)(byte)*pcVar12;
      goto LAB_1400c4a5e;
    }
    if (*pcVar12 == 0) goto LAB_1400c4a94;
    pcVar12 = pcVar12 + 1;
  }
  iVar17 = -(uint)(byte)*pcVar12;
LAB_1400c4a5e:
  if (iVar17 == 0) {
    FUN_1400bda60(param_1,local_a0,param_2,param_3,param_4,param_5);
    ppppbVar10 = (byte ****)local_98[0];
    bVar14 = local_79;
    goto LAB_1400c5c21;
  }
LAB_1400c4a94:
  local_a8 = 0x4b;
  local_c8 = '\0';
  local_a9 = 0x1f;
  puVar7 = (undefined4 *)FUN_140056c90(&local_c8,6);
  *puVar7 = 0x74726576;
  *(undefined2 *)(puVar7 + 1) = 0x7865;
  *(undefined1 *)((longlong)puVar7 + 6) = 0;
  if (local_a9 < 0x40) {
    local_a9 = 0x19;
  }
  else {
    local_b8 = 6;
  }
  uVar6 = CONCAT44(uVar21,param_3);
  cVar3 = FUN_1400c6110(local_98,&local_c8,0,param_2,param_1,&local_a0,uVar6,param_4,param_5);
  uVar20 = (undefined4)((ulonglong)uVar6 >> 0x20);
  if ((local_a9 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_c7,local_c8),local_a8,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  ppppbVar10 = (byte ****)local_98[0];
  bVar14 = local_79;
  if (cVar3 != '\0') goto LAB_1400c5c21;
  local_a8 = 0x4b;
  local_a9 = 0x1f;
  local_c8 = cVar3;
  puVar8 = (undefined8 *)FUN_140056c90(&local_c8,8);
  *puVar8 = 0x746e656d67617266;
  *(undefined1 *)(puVar8 + 1) = 0;
  if (local_a9 < 0x40) {
    local_a9 = 0x17;
  }
  else {
    local_b8 = 8;
  }
  uVar6 = CONCAT44(uVar20,param_3);
  cVar3 = FUN_1400c6110(local_98,&local_c8,1,param_2,param_1,&local_a0,uVar6,param_4,param_5);
  uVar20 = (undefined4)((ulonglong)uVar6 >> 0x20);
  if ((local_a9 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_c7,local_c8),local_a8,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  ppppbVar10 = (byte ****)local_98[0];
  bVar14 = local_79;
  if (cVar3 != '\0') goto LAB_1400c5c21;
  local_a8 = 0x4b;
  local_a9 = 0x1f;
  local_c8 = cVar3;
  puVar7 = (undefined4 *)FUN_140056c90(&local_c8,4);
  *puVar7 = 0x6c6c7568;
  *(undefined1 *)(puVar7 + 1) = 0;
  if (local_a9 < 0x40) {
    local_a9 = 0x1b;
  }
  else {
    local_b8 = 4;
  }
  uVar6 = CONCAT44(uVar20,param_3);
  cVar3 = FUN_1400c6110(local_98,&local_c8,2,param_2,param_1,&local_a0,uVar6,param_4,param_5);
  uVar20 = (undefined4)((ulonglong)uVar6 >> 0x20);
  if ((local_a9 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_c7,local_c8),local_a8,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  ppppbVar10 = (byte ****)local_98[0];
  bVar14 = local_79;
  if (cVar3 != '\0') goto LAB_1400c5c21;
  local_a8 = 0x4b;
  local_a9 = 0x1f;
  local_c8 = cVar3;
  puVar7 = (undefined4 *)FUN_140056c90(&local_c8,6);
  *puVar7 = 0x616d6f64;
  *(undefined2 *)(puVar7 + 1) = 0x6e69;
  *(undefined1 *)((longlong)puVar7 + 6) = 0;
  if (local_a9 < 0x40) {
    local_a9 = 0x19;
  }
  else {
    local_b8 = 6;
  }
  uVar6 = CONCAT44(uVar20,param_3);
  cVar3 = FUN_1400c6110(local_98,&local_c8,3,param_2,param_1,&local_a0,uVar6,param_4,param_5);
  uVar20 = (undefined4)((ulonglong)uVar6 >> 0x20);
  if ((local_a9 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_c7,local_c8),local_a8,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  ppppbVar10 = (byte ****)local_98[0];
  bVar14 = local_79;
  if (cVar3 != '\0') goto LAB_1400c5c21;
  local_a8 = 0x4b;
  local_a9 = 0x1f;
  local_c8 = cVar3;
  puVar8 = (undefined8 *)FUN_140056c90(&local_c8,8);
  *puVar8 = 0x797274656d6f6567;
  *(undefined1 *)(puVar8 + 1) = 0;
  if (local_a9 < 0x40) {
    local_a9 = 0x17;
  }
  else {
    local_b8 = 8;
  }
  uVar6 = CONCAT44(uVar20,param_3);
  cVar3 = FUN_1400c6110(local_98,&local_c8,4,param_2,param_1,&local_a0,uVar6,param_4,param_5);
  uVar20 = (undefined4)((ulonglong)uVar6 >> 0x20);
  if ((local_a9 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_c7,local_c8),local_a8,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  ppppbVar10 = (byte ****)local_98[0];
  bVar14 = local_79;
  if (cVar3 != '\0') goto LAB_1400c5c21;
  local_a8 = 0x4b;
  local_a9 = 0x1f;
  local_c8 = cVar3;
  pcVar12 = (char *)FUN_140056c90(&local_c8,10);
  builtin_strncpy(pcVar12,"raytracing",0xb);
  if (local_a9 < 0x40) {
    local_a9 = 0x15;
  }
  else {
    local_b8 = 10;
  }
  puVar8 = &local_a0;
  uVar19 = param_1;
  cVar3 = FUN_1400c6110(local_98,&local_c8,6,param_2,param_1,puVar8,CONCAT44(uVar20,param_3),param_4
                        ,param_5);
  if ((local_a9 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_c7,local_c8),local_a8,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  bVar14 = local_79;
  ppppbVar10 = (byte ****)local_98[0];
  if (cVar3 != '\0') goto LAB_1400c5c21;
  lVar16 = (longlong)(char)local_79;
  ppppbVar11 = (byte ****)local_98[0];
  lVar18 = local_88;
  if (local_79 < 0x40) {
    ppppbVar11 = local_98;
    lVar18 = 0x1f - lVar16;
  }
  pcVar12 = "target";
  ppppbVar1 = (byte ****)((longlong)ppppbVar11 + lVar18);
  for (; ppppbVar11 < ppppbVar1; ppppbVar11 = (byte ****)((longlong)ppppbVar11 + 1)) {
    if (*(byte *)ppppbVar11 != *pcVar12) {
      iVar17 = (uint)*(byte *)ppppbVar11 - (uint)(byte)*pcVar12;
      goto LAB_1400c4f1d;
    }
    if (*pcVar12 == 0) goto LAB_1400c4f71;
    pcVar12 = pcVar12 + 1;
  }
  iVar17 = -(uint)(byte)*pcVar12;
LAB_1400c4f1d:
  if (iVar17 == 0) {
    FUN_1400c5c60(param_2,param_1,&local_a0,param_3,param_4,param_5);
LAB_1400c4f40:
    bVar2 = false;
  }
  else {
LAB_1400c4f71:
    ppppbVar11 = (byte ****)local_98[0];
    lVar18 = local_88;
    if (local_79 < 0x40) {
      ppppbVar11 = local_98;
      lVar18 = 0x1f - lVar16;
    }
    pcVar12 = "require";
    ppppbVar1 = (byte ****)((longlong)ppppbVar11 + lVar18);
    for (; ppppbVar11 < ppppbVar1; ppppbVar11 = (byte ****)((longlong)ppppbVar11 + 1)) {
      if (*(byte *)ppppbVar11 != *pcVar12) {
        iVar17 = (uint)*(byte *)ppppbVar11 - (uint)(byte)*pcVar12;
        goto LAB_1400c4fbb;
      }
      if (*pcVar12 == 0) goto LAB_1400c4ffb;
      pcVar12 = pcVar12 + 1;
    }
    iVar17 = -(uint)(byte)*pcVar12;
LAB_1400c4fbb:
    if (iVar17 == 0) {
      FUN_140091ef0(param_2,param_1,&local_a0,param_3,uVar19 & 0xffffffffffffff00,
                    (ulonglong)puVar8 & 0xffffffffffffff00,param_4 + 0x2d0,param_5);
      goto LAB_1400c4f40;
    }
LAB_1400c4ffb:
    ppppbVar11 = (byte ****)local_98[0];
    lVar18 = local_88;
    if (local_79 < 0x40) {
      ppppbVar11 = local_98;
      lVar18 = 0x1f - lVar16;
    }
    pbVar13 = &DAT_140588304;
    ppppbVar1 = (byte ****)((longlong)ppppbVar11 + lVar18);
    for (; ppppbVar11 < ppppbVar1; ppppbVar11 = (byte ****)((longlong)ppppbVar11 + 1)) {
      if (*(byte *)ppppbVar11 != *pbVar13) {
        iVar17 = (uint)*(byte *)ppppbVar11 - (uint)*pbVar13;
        goto LAB_1400c5043;
      }
      if (*pbVar13 == 0) goto LAB_1400c504b;
      pbVar13 = pbVar13 + 1;
    }
    iVar17 = -(uint)*pbVar13;
LAB_1400c5043:
    if (iVar17 == 0) goto LAB_1400c4f40;
LAB_1400c504b:
    ppppbVar11 = (byte ****)local_98[0];
    lVar18 = local_88;
    if (local_79 < 0x40) {
      ppppbVar11 = local_98;
      lVar18 = 0x1f - lVar16;
    }
    pcVar12 = "no_auto_normalization";
    ppppbVar1 = (byte ****)((longlong)ppppbVar11 + lVar18);
    for (; ppppbVar11 < ppppbVar1; ppppbVar11 = (byte ****)((longlong)ppppbVar11 + 1)) {
      if (*(byte *)ppppbVar11 != *pcVar12) {
        iVar17 = (uint)*(byte *)ppppbVar11 - (uint)(byte)*pcVar12;
        goto LAB_1400c509f;
      }
      if (*pcVar12 == 0) goto LAB_1400c50a8;
      pcVar12 = pcVar12 + 1;
    }
    iVar17 = -(uint)(byte)*pcVar12;
LAB_1400c509f:
    if (iVar17 == 0) goto LAB_1400c4f40;
LAB_1400c50a8:
    ppppbVar11 = (byte ****)local_98[0];
    lVar18 = local_88;
    if (local_79 < 0x40) {
      ppppbVar11 = local_98;
      lVar18 = 0x1f - lVar16;
    }
    pcVar12 = "glsl_no_auto_normalization";
    ppppbVar1 = (byte ****)((longlong)ppppbVar11 + lVar18);
    for (; ppppbVar11 < ppppbVar1; ppppbVar11 = (byte ****)((longlong)ppppbVar11 + 1)) {
      if (*(byte *)ppppbVar11 != *pcVar12) {
        iVar17 = (uint)*(byte *)ppppbVar11 - (uint)(byte)*pcVar12;
        goto LAB_1400c50fc;
      }
      if (*pcVar12 == 0) goto LAB_1400c5104;
      pcVar12 = pcVar12 + 1;
    }
    iVar17 = -(uint)(byte)*pcVar12;
LAB_1400c50fc:
    if (iVar17 == 0) goto LAB_1400c4f40;
LAB_1400c5104:
    ppppbVar11 = (byte ****)local_98[0];
    lVar18 = local_88;
    if (local_79 < 0x40) {
      ppppbVar11 = local_98;
      lVar18 = 0x1f - lVar16;
    }
    pcVar12 = "profileoption";
    ppppbVar1 = (byte ****)((longlong)ppppbVar11 + lVar18);
    for (; ppppbVar11 < ppppbVar1; ppppbVar11 = (byte ****)((longlong)ppppbVar11 + 1)) {
      if (*(byte *)ppppbVar11 != *pcVar12) {
        iVar17 = (uint)*(byte *)ppppbVar11 - (uint)(byte)*pcVar12;
        goto LAB_1400c515b;
      }
      if (*pcVar12 == 0) goto LAB_1400c5163;
      pcVar12 = pcVar12 + 1;
    }
    iVar17 = -(uint)(byte)*pcVar12;
LAB_1400c515b:
    if (iVar17 == 0) goto LAB_1400c4f40;
LAB_1400c5163:
    ppppbVar11 = (byte ****)local_98[0];
    lVar18 = local_88;
    if (local_79 < 0x40) {
      ppppbVar11 = local_98;
      lVar18 = 0x1f - lVar16;
    }
    pcVar12 = "fragmentoption";
    ppppbVar1 = (byte ****)((longlong)ppppbVar11 + lVar18);
    for (; ppppbVar11 < ppppbVar1; ppppbVar11 = (byte ****)((longlong)ppppbVar11 + 1)) {
      if (*(byte *)ppppbVar11 != *pcVar12) {
        iVar17 = (uint)*(byte *)ppppbVar11 - (uint)(byte)*pcVar12;
        goto LAB_1400c51c1;
      }
      if (*pcVar12 == 0) goto LAB_1400c51ca;
      pcVar12 = pcVar12 + 1;
    }
    iVar17 = -(uint)(byte)*pcVar12;
LAB_1400c51c1:
    if (iVar17 == 0) goto LAB_1400c4f40;
LAB_1400c51ca:
    ppppbVar11 = (byte ****)local_98[0];
    if (local_79 < 0x40) {
      local_88 = 0x1f - lVar16;
      ppppbVar11 = local_98;
    }
    pcVar12 = "metal_use_hlslcc";
    ppppbVar1 = (byte ****)((longlong)ppppbVar11 + local_88);
    for (; ppppbVar11 < ppppbVar1; ppppbVar11 = (byte ****)((longlong)ppppbVar11 + 1)) {
      if (*(byte *)ppppbVar11 != *pcVar12) {
        iVar17 = (uint)*(byte *)ppppbVar11 - (uint)(byte)*pcVar12;
        goto LAB_1400c5211;
      }
      if (*pcVar12 == 0) goto LAB_1400c5219;
      pcVar12 = pcVar12 + 1;
    }
    iVar17 = -(uint)(byte)*pcVar12;
LAB_1400c5211:
    if (iVar17 == 0) goto LAB_1400c4f40;
LAB_1400c5219:
    cVar3 = FUN_14001a650(local_98,"metal_use_hlsl2glsl");
    if ((cVar3 != '\0') || (cVar3 = FUN_14001a650(local_98,"glsl_no_optimize"), cVar3 != '\0'))
    goto LAB_1400c4f40;
    cVar3 = FUN_14001a650(local_98,"only_renderers");
    if (cVar3 != '\0') {
      uVar15 = 0;
      while( true ) {
        FUN_1400e8c10(&local_c8,param_1,&local_a0);
        uVar20 = (undefined4)(uVar19 >> 0x20);
        lVar18 = local_b8;
        if (local_a9 < 0x40) {
          lVar18 = 0x1f - (longlong)(char)local_a9;
        }
        if (lVar18 == 0) break;
        local_a0 = FUN_1400e8dc0(param_1,local_a0);
        uVar5 = FUN_14008d360(&local_c8);
        uVar20 = (undefined4)(uVar19 >> 0x20);
        if (uVar5 == 0xffffffff) {
          uVar6 = FUN_14001b190(local_68,"Unrecognized renderer for #pragma only_renderers: ",
                                &local_c8);
          uVar19 = CONCAT44(uVar20,0x1c);
          FUN_140089820(param_5,uVar6,param_3,1,uVar19);
          if ((local_49 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(local_68[0],local_48,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          cVar4 = '\0';
        }
        else {
          uVar15 = uVar15 | uVar5;
          if (uVar5 == 0x4200) {
            uVar9 = FUN_1400e7be0(&local_c8);
            *(ulonglong *)(param_4 + 0x2d0) = *(ulonglong *)(param_4 + 0x2d0) | uVar9;
          }
        }
        if ((local_a9 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(CONCAT71(uStack_c7,local_c8),local_a8,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
        }
      }
      if ((local_a9 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(CONCAT71(uStack_c7,local_c8),local_a8,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      if (uVar15 == 0) {
        local_a8 = 0x4b;
        local_c8 = '\0';
        local_a9 = 0x1f;
        FUN_140054780(&local_c8,"#pragma only_renderers did not contain any renderers, ignoring",
                      0x3e);
        FUN_140089820(param_5,&local_c8,param_3,1,CONCAT44(uVar20,0x1c));
        ppppbVar10 = (byte ****)local_98[0];
        bVar14 = local_79;
        if ((local_a9 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(CONCAT71(uStack_c7,local_c8),local_a8,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
          ppppbVar10 = (byte ****)local_98[0];
          bVar14 = local_79;
        }
        goto LAB_1400c5c21;
      }
      *(uint *)(param_4 + 0x2f8) = uVar15;
LAB_1400c5a88:
      ppppbVar10 = (byte ****)local_98[0];
      bVar14 = local_79;
      if (cVar4 == '\0') goto LAB_1400c5c21;
      goto LAB_1400c4f40;
    }
    cVar3 = FUN_14001a650(local_98,"exclude_renderers");
    if (cVar3 != '\0') {
      while( true ) {
        FUN_1400e8c10(&local_c8,param_1,&local_a0);
        lVar18 = local_b8;
        if (local_a9 < 0x40) {
          lVar18 = 0x1f - (longlong)(char)local_a9;
        }
        if (lVar18 == 0) break;
        local_a0 = FUN_1400e8dc0(param_1,local_a0);
        uVar15 = FUN_14008d360(&local_c8);
        uVar20 = (undefined4)(uVar19 >> 0x20);
        if (uVar15 == 0xffffffff) {
          uVar6 = FUN_14001b190(local_68,"Unrecognized renderer for #pragma exclude_renderers: ",
                                &local_c8);
          uVar19 = CONCAT44(uVar20,0x1c);
          FUN_140089820(param_5,uVar6,param_3,1,uVar19);
          if ((local_49 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(local_68[0],local_48,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          cVar4 = '\0';
        }
        else {
          *(uint *)(param_4 + 0x2f8) = *(uint *)(param_4 + 0x2f8) & ~uVar15;
        }
        if ((local_a9 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(CONCAT71(uStack_c7,local_c8),local_a8,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
        }
      }
      if ((local_a9 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(CONCAT71(uStack_c7,local_c8),local_a8,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      goto LAB_1400c5a88;
    }
    cVar3 = FUN_14001a650(local_98,"hardware_tier_variants");
    uVar20 = (undefined4)(uVar19 >> 0x20);
    if (cVar3 != '\0') {
      FUN_1400e8c10(&local_c8,param_1,&local_a0);
      uVar15 = FUN_14008d360(&local_c8);
      if (uVar15 == 0xffffffff) {
        uVar6 = FUN_14001b190(local_68,"Unrecognized renderer for #pragma hardware_tier_variants: ",
                              &local_c8);
        FUN_140089820(param_5,uVar6,param_3,1,CONCAT44(uVar20,0x1c));
        if ((local_49 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(local_68[0],local_48,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
        }
        cVar4 = '\0';
      }
      else {
        *(uint *)(param_4 + 0x2fc) = *(uint *)(param_4 + 0x2fc) | uVar15;
      }
      if ((local_a9 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(CONCAT71(uStack_c7,local_c8),local_a8,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      goto LAB_1400c5a88;
    }
    cVar3 = FUN_14001a650(local_98,"debug");
    if (cVar3 != '\0') {
      *(ulonglong *)(param_4 + 0x118) = *(ulonglong *)(param_4 + 0x118) | 2;
      goto LAB_1400c4f40;
    }
    cVar3 = FUN_14001a650(local_98,"enable_d3d11_debug_symbols");
    if (cVar3 != '\0') {
      *(ulonglong *)(param_4 + 0x118) = *(ulonglong *)(param_4 + 0x118) | 4;
      goto LAB_1400c4f40;
    }
    cVar3 = FUN_14001a650(local_98,"enable_ray_tracing_shader_debug_symbols");
    if (cVar3 != '\0') {
      *(ulonglong *)(param_4 + 0x118) = *(ulonglong *)(param_4 + 0x118) | 0x1000000;
      goto LAB_1400c4f40;
    }
    cVar3 = FUN_14001a650(local_98,"hlslcc_bytecode_disassembly");
    if (cVar3 != '\0') {
      *(ulonglong *)(param_4 + 0x118) = *(ulonglong *)(param_4 + 0x118) | 8;
      goto LAB_1400c4f40;
    }
    cVar3 = FUN_14001a650(local_98,"disable_fastmath");
    if (cVar3 != '\0') {
      *(ulonglong *)(param_4 + 0x118) = *(ulonglong *)(param_4 + 0x118) | 0x80000;
      goto LAB_1400c4f40;
    }
    cVar3 = FUN_14001a650(local_98,"prefer_hlslcc");
    if ((cVar3 != '\0') || (cVar3 = FUN_14001a650(local_98,"prefer_hlsl2glsl"), cVar3 != '\0'))
    goto LAB_1400c5c21;
    ppppbVar11 = local_98;
    if (0x3f < bVar14) {
      ppppbVar11 = ppppbVar10;
    }
    cVar3 = FUN_1400e02f0(ppppbVar11,"multi_compile");
    if (cVar3 != '\0') goto LAB_1400c4f40;
    ppppbVar10 = local_98;
    if (0x3f < local_79) {
      ppppbVar10 = (byte ****)local_98[0];
    }
    cVar3 = FUN_1400e02f0(ppppbVar10,"shader_feature");
    if (cVar3 != '\0') goto LAB_1400c4f40;
    ppppbVar10 = local_98;
    if (0x3f < local_79) {
      ppppbVar10 = (byte ****)local_98[0];
    }
    cVar3 = FUN_1400e02f0(ppppbVar10,"multi_compile_local");
    if (cVar3 != '\0') goto LAB_1400c4f40;
    ppppbVar10 = local_98;
    if (0x3f < local_79) {
      ppppbVar10 = (byte ****)local_98[0];
    }
    cVar3 = FUN_1400e02f0(ppppbVar10,"shader_feature_local");
    if (cVar3 != '\0') goto LAB_1400c4f40;
    ppppbVar10 = local_98;
    if (0x3f < local_79) {
      ppppbVar10 = (byte ****)local_98[0];
    }
    cVar3 = FUN_1400e02f0(ppppbVar10,"dynamic_branch");
    if (cVar3 != '\0') goto LAB_1400c4f40;
    ppppbVar10 = local_98;
    if (0x3f < local_79) {
      ppppbVar10 = (byte ****)local_98[0];
    }
    cVar3 = FUN_1400e02f0(ppppbVar10,"skip_variants");
    if ((((cVar3 != '\0') ||
         (cVar3 = FUN_14001a650(local_98,"force_concat_matrices"), cVar3 != '\0')) ||
        (cVar3 = FUN_14001a650(local_98,"lighting"), cVar3 != '\0')) ||
       (cVar3 = FUN_14001a650(local_98,"warning"), cVar3 != '\0')) goto LAB_1400c4f40;
    cVar3 = FUN_14001a650(local_98,"instancing_options");
    if (cVar3 != '\0') {
      FUN_1400bc820(param_1,local_a0,param_3,param_4,param_5);
      goto LAB_1400c4f40;
    }
    ppppbVar10 = local_98;
    if (0x3f < local_79) {
      ppppbVar10 = (byte ****)local_98[0];
    }
    cVar3 = FUN_1400e02f0(ppppbVar10,"argument");
    if ((cVar3 != '\0') ||
       (cVar3 = FUN_14001a650(local_98,"PSSL_target_output_format"), cVar3 != '\0'))
    goto LAB_1400c4f40;
    cVar3 = FUN_14001a650(local_98,"enable_bounds_check_block_accesses");
    if (cVar3 != '\0') {
      *(ulonglong *)(param_4 + 0x118) = *(ulonglong *)(param_4 + 0x118) | 0x400000000;
      goto LAB_1400c4f40;
    }
    cVar3 = FUN_14001a650(local_98,"glsl_es2");
    if (cVar3 != '\0') {
      *(ulonglong *)(param_4 + 0x118) = *(ulonglong *)(param_4 + 0x118) | 0x800;
      goto LAB_1400c4f40;
    }
    cVar3 = FUN_14001a650(local_98,"pssl2");
    if (cVar3 != '\0') {
      *(ulonglong *)(param_4 + 0x118) = *(ulonglong *)(param_4 + 0x118) | 0x20000;
      goto LAB_1400c4f40;
    }
    cVar3 = FUN_14001a650(local_98,"editor_sync_compilation");
    if (cVar3 != '\0') {
      *(ulonglong *)(param_4 + 0x118) = *(ulonglong *)(param_4 + 0x118) | 0x400000;
      goto LAB_1400c4f40;
    }
    cVar3 = FUN_14001a650(local_98,"enable_cbuffer");
    if (cVar3 != '\0') {
      *(ulonglong *)(param_4 + 0x118) = *(ulonglong *)(param_4 + 0x118) | 0x2000000;
      goto LAB_1400c4f40;
    }
    cVar3 = FUN_14001a650(local_98,"skip_optimizations");
    uVar20 = (undefined4)(uVar19 >> 0x20);
    if (cVar3 != '\0') {
      while( true ) {
        FUN_1400e8c10(&local_c8,param_1,&local_a0);
        lVar18 = local_b8;
        if (local_a9 < 0x40) {
          lVar18 = 0x1f - (longlong)(char)local_a9;
        }
        if (lVar18 == 0) break;
        local_a0 = FUN_1400e8dc0(param_1,local_a0);
        iVar17 = FUN_14008d360(&local_c8);
        uVar20 = (undefined4)(uVar19 >> 0x20);
        if (iVar17 == -1) {
          uVar6 = FUN_14001b190(local_68,"Unrecognized renderer for #pragma skip_optimizations: ",
                                &local_c8);
          uVar19 = CONCAT44(uVar20,0x1c);
          FUN_140089820(param_5,uVar6,param_3,1,uVar19);
          if ((local_49 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(local_68[0],local_48,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          cVar4 = '\0';
        }
        else if (*(int *)(param_4 + 0x2f8) == iVar17) {
          *(ulonglong *)(param_4 + 0x118) = *(ulonglong *)(param_4 + 0x118) | 0x4000000;
        }
        if ((local_a9 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(CONCAT71(uStack_c7,local_c8),local_a8,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
        }
      }
      if ((local_a9 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(CONCAT71(uStack_c7,local_c8),local_a8,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      goto LAB_1400c5a88;
    }
    cVar4 = FUN_14001a650(local_98,"use_dxc");
    if (cVar4 != '\0') {
      lVar18 = param_4 + 0x158;
      uVar6 = 1;
LAB_1400c5a67:
      cVar4 = FUN_140090e40(lVar18,param_5,uVar6,param_1,local_a0,(longlong)param_3);
      goto LAB_1400c5a88;
    }
    cVar4 = FUN_14001a650(local_98,"never_use_dxc");
    if (cVar4 != '\0') {
      lVar18 = param_4 + 0x15c;
      uVar6 = 0;
      goto LAB_1400c5a67;
    }
    cVar4 = FUN_14001a650(local_98,"enable_bindsets");
    if (cVar4 != '\0') {
      *(ulonglong *)(param_4 + 0x118) = *(ulonglong *)(param_4 + 0x118) | 0x20000000;
      goto LAB_1400c4f40;
    }
    cVar4 = FUN_14001a650(local_98,"max_recursion_depth");
    if (cVar4 != '\0') {
      FUN_1400e8c10(&local_c8,param_1,&local_a0);
      local_70[0] = 1;
      pcVar12 = &local_c8;
      if (0x3f < local_a9) {
        pcVar12 = (char *)CONCAT71(uStack_c7,local_c8);
      }
      iVar17 = FUN_14005a3f0(pcVar12,&DAT_14058578c,local_70);
      if (iVar17 == 1) {
        iVar17 = 0;
        if (0 < local_70[0]) {
          iVar17 = local_70[0];
        }
        *(int *)(param_4 + 0x160) = iVar17;
        local_70[0] = iVar17;
      }
      if ((local_a9 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(CONCAT71(uStack_c7,local_c8),local_a8,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      goto LAB_1400c4f40;
    }
    cVar4 = FUN_14001a650(local_98,"metal_fxc_allow_float16_in_cpu_visible_buffers");
    if (cVar4 != '\0') {
      *(ulonglong *)(param_4 + 0x118) = *(ulonglong *)(param_4 + 0x118) | 0x40000000;
      goto LAB_1400c4f40;
    }
    uVar6 = FUN_14001b190(local_68,"Unrecognized #pragma directive: ",local_98);
    FUN_140089820(param_5,uVar6,param_3,1,CONCAT44(uVar20,0x1c));
    if ((local_49 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(local_68[0],local_48,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    bVar2 = true;
    FUN_1400543f0(param_4 + 0x168,&DAT_14058331c,3);
  }
  if (*(byte *)((longlong)param_2 + 0x1f) < 0x40) {
    lVar18 = 0x1f - (longlong)*(char *)((longlong)param_2 + 0x1f);
  }
  else {
    lVar18 = param_2[2];
    param_2 = (undefined8 *)*param_2;
  }
  FUN_1400543f0(param_4 + 0x168,param_2,lVar18);
  if (bVar2) {
    FUN_1400543f0(param_4 + 0x168," // Unity: Unrecognised #pragma directive",0x29);
  }
  FUN_14001b680(param_4 + 0x168,10);
  ppppbVar10 = (byte ****)local_98[0];
  bVar14 = local_79;
LAB_1400c5c21:
  if ((bVar14 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(ppppbVar10,local_78,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  return;
}
```

## `CheckStageSlotsNotEmpty` — `0x1400b84c0`

stage-slot validation

```c
/* Validates the 7-entry stage slot array. When every slot is empty the block is dropped with
   "CGPROGRAM block does not contain #pragma vertex, #pragma fragment or #pragma surface directive,
   skipping". */

undefined8 CheckStageSlotsNotEmpty(longlong param_1,undefined4 param_2,undefined8 param_3)

{
  byte *pbVar1;
  char *pcVar2;
  longlong lVar3;
  longlong lVar4;
  undefined1 local_38;
  undefined7 uStack_37;
  undefined8 local_28;
  byte local_19;
  undefined2 local_18;
  
  lVar4 = 0;
  pbVar1 = (byte *)(param_1 + 0x1f);
  while( true ) {
    if (*pbVar1 < 0x40) {
      lVar3 = 0x1f - (longlong)(char)*pbVar1;
    }
    else {
      lVar3 = *(longlong *)(pbVar1 + -0xf);
    }
    if (lVar3 != 0) break;
    lVar4 = lVar4 + 1;
    pbVar1 = pbVar1 + 0x28;
    if (6 < lVar4) {
      local_18 = 0x4b;
      local_38 = 0;
      local_19 = 0x1f;
      pcVar2 = (char *)FUN_140056c90(&local_38,0x68);
      builtin_strncpy(pcVar2,
                      "CGPROGRAM block does not contain #pragma vertex, #pragma fragment or #pragma surface directive, skipping"
                      ,0x69);
      if (local_19 < 0x40) {
        local_19 = 0xb7;
      }
      else {
        local_28 = 0x68;
      }
      FUN_140089820(param_3,&local_38,param_2,1,0x1c);
      if ((local_19 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(CONCAT71(uStack_37,local_38),local_18,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      return 1;
    }
  }
  return 0;
}
```

## `CheckVertexAndFragmentPresent` — `0x1400b3c90`

GLSL/Metal vertex+fragment requirement check

```c
void CheckVertexAndFragmentPresent
               (undefined8 param_1,ulonglong param_2,longlong param_3,undefined8 param_4)

{
  char *pcVar1;
  longlong lVar2;
  longlong lVar3;
  ulonglong uVar4;
  undefined1 local_48;
  undefined7 uStack_47;
  undefined8 local_38;
  byte local_29;
  undefined2 local_28;
  
  uVar4 = param_2 & 0xffffffff;
  if ((*(uint *)(param_3 + 0x2f8) & 0x1000) != 0) {
    *(uint *)(param_3 + 0x2f8) = *(uint *)(param_3 + 0x2f8) | 0x300000;
  }
  lVar3 = param_3;
  FUN_1400badb0(param_1,param_2,param_3,param_3 + 0x2d0);
  if (*(byte *)(lVar3 + 0x6f) < 0x40) {
    lVar2 = 0x1f - (longlong)*(char *)(lVar3 + 0x6f);
  }
  else {
    lVar2 = *(longlong *)(lVar3 + 0x60);
  }
  if (lVar2 == 0) {
    if (*(byte *)(lVar3 + 0x97) < 0x40) {
      lVar2 = 0x1f - (longlong)*(char *)(lVar3 + 0x97);
    }
    else {
      lVar2 = *(longlong *)(lVar3 + 0x88);
    }
    if (lVar2 == 0) goto LAB_1400b3e2a;
  }
  if (((*(ulonglong *)(lVar3 + 0x2d0) & 0x30000) == 0) && (*(longlong *)(lVar3 + 0x2d0) != 0x21)) {
    local_28 = 0x4b;
    local_48 = 0;
    local_29 = 0x1f;
    pcVar1 = (char *)FUN_140056c90(&local_48,99);
    builtin_strncpy(pcVar1,
                    "Program uses tessellation shaders, treating as if \'#pragma require tessellation tessHW\' was present"
                    ,100);
    if (local_29 < 0x40) {
      local_29 = 0xbc;
    }
    else {
      local_38 = 99;
    }
    FUN_140089820(param_4,&local_48,uVar4,1,0x1c);
    if ((local_29 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(uStack_47,local_48),local_28,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
  }
  *(ulonglong *)(param_3 + 0x2d0) = *(ulonglong *)(param_3 + 0x2d0) | 0x30000;
LAB_1400b3e2a:
  if (*(byte *)(param_3 + 0xbf) < 0x40) {
    lVar3 = 0x1f - (longlong)*(char *)(param_3 + 0xbf);
  }
  else {
    lVar3 = *(longlong *)(param_3 + 0xb0);
  }
  if ((lVar3 != 0) && ((*(uint *)(param_3 + 0x2d0) >> 0xc & 1) == 0)) {
    if (*(longlong *)(param_3 + 0x2d0) != 0x21) {
      local_28 = 0x4b;
      local_48 = 0;
      local_29 = 0x1f;
      pcVar1 = (char *)FUN_140056c90(&local_48,0x54);
      builtin_strncpy(pcVar1,
                      "Program uses geometry shaders, treating as if \'#pragma require geometry\' was present"
                      ,0x55);
      if (local_29 < 0x40) {
        local_29 = 0xcb;
      }
      else {
        local_38 = 0x54;
      }
      FUN_140089820(param_4,&local_48,uVar4,1,0x1c);
      if ((local_29 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(CONCAT71(uStack_47,local_48),local_28,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
    }
    *(ulonglong *)(param_3 + 0x2d0) = *(ulonglong *)(param_3 + 0x2d0) | 0x1000;
  }
  if (*(byte *)(param_3 + 0xe7) < 0x40) {
    lVar3 = 0x1f - (longlong)*(char *)(param_3 + 0xe7);
  }
  else {
    lVar3 = *(longlong *)(param_3 + 0xd8);
  }
  if (lVar3 == 0) {
    if (*(byte *)(param_3 + 0x10f) < 0x40) {
      lVar3 = 0x1f - (longlong)*(char *)(param_3 + 0x10f);
    }
    else {
      lVar3 = *(longlong *)(param_3 + 0x100);
    }
    if ((lVar3 == 0) && ((int)param_1 != 1)) {
      if (*(byte *)(param_3 + 0x1f) < 0x40) {
        lVar3 = 0x1f - (longlong)*(char *)(param_3 + 0x1f);
      }
      else {
        lVar3 = *(longlong *)(param_3 + 0x10);
      }
      if (lVar3 != 0) {
        if (*(byte *)(param_3 + 0x47) < 0x40) {
          lVar3 = 0x1f - (longlong)*(char *)(param_3 + 0x47);
        }
        else {
          lVar3 = *(longlong *)(param_3 + 0x38);
        }
        if (lVar3 != 0) {
          return;
        }
      }
      if ((*(uint *)(param_3 + 0x2f8) & 0xdfdde30) != 0) {
        local_28 = 0x4b;
        local_48 = 0;
        local_29 = 0x1f;
        pcVar1 = (char *)FUN_140056c90(&local_48,0x65);
        builtin_strncpy(pcVar1,
                        "Both vertex and fragment programs must be present in a shader snippet. Excluding it from compilation."
                        ,0x66);
        if (local_29 < 0x40) {
          local_29 = 0xba;
        }
        else {
          local_38 = 0x65;
        }
        FUN_140089820(param_4,&local_48,uVar4,1,0x1c);
        if ((local_29 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(CONCAT71(uStack_47,local_48),local_28,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
        }
        *(uint *)(param_3 + 0x2f8) = *(uint *)(param_3 + 0x2f8) & 0xf20221cf;
      }
    }
  }
  return;
}
```

## `ProcessShaderPreprocessor` — `0x140097870`

preprocessor

```c
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* Preprocessor core: expands macros/includes for one compile request. Reused by the graphics,
   compute and raytracing paths. */

void ProcessShaderPreprocessor
               (undefined8 param_1,byte *param_2,undefined8 param_3,undefined8 param_4,
               undefined8 param_5,undefined8 param_6,undefined8 param_7,undefined4 param_8,
               ulonglong param_9,undefined8 param_10,undefined8 param_11,undefined8 param_12,
               undefined8 param_13,undefined8 param_14,char param_15)

{
  ulonglong uVar1;
  undefined2 uVar2;
  undefined8 uVar3;
  ulonglong uVar4;
  byte *pbVar5;
  byte *pbVar6;
  ulonglong uVar7;
  longlong lVar8;
  int iVar9;
  undefined8 in_stack_fffffffffffffd78;
  undefined4 uVar10;
  undefined1 local_238 [8];
  undefined8 local_230;
  undefined2 local_228;
  undefined8 local_220;
  undefined8 uStack_218;
  undefined8 local_210;
  undefined2 local_208;
  undefined8 local_200;
  undefined8 uStack_1f8;
  undefined8 local_1f0;
  undefined4 local_1e8;
  char *local_1e0;
  ulonglong local_1d8;
  undefined8 local_1d0;
  undefined2 local_1c8;
  undefined8 local_1c0;
  undefined8 local_1b8;
  undefined1 local_1a8 [32];
  undefined1 local_188 [24];
  undefined1 local_170 [32];
  undefined1 local_150 [32];
  undefined1 local_130 [32];
  undefined1 local_110 [32];
  undefined1 local_f0 [32];
  undefined4 *local_d0;
  undefined2 local_ba;
  
  uVar10 = (undefined4)((ulonglong)in_stack_fffffffffffffd78 >> 0x20);
  local_1d8 = 0;
  do {
    if ("ShaderPreprocessor::Preprocess"[local_1d8] == '\0') goto LAB_1400978c5;
    local_1d8 = local_1d8 + 1;
  } while (local_1d8 < 0x1f);
  local_1d8 = 0x1f;
LAB_1400978c5:
  local_1e0 = "ShaderPreprocessor::Preprocess";
  FUN_1400afbc0(local_238,&local_1e0);
  local_1d0 = 0;
  local_1c8 = 1;
  local_1c0 = 0;
  local_1b8 = 1;
  if (param_15 == '\0') {
    uVar7 = DAT_140726d88;
    if (DAT_140726d97 < 0x40) {
      uVar7 = 0x1f - (longlong)(char)DAT_140726d97;
    }
    if (param_2[0x1f] < 0x40) {
      uVar4 = 0x1f - (longlong)(char)param_2[0x1f];
    }
    else {
      uVar4 = *(ulonglong *)(param_2 + 0x10);
    }
    if (uVar7 == uVar4) {
      uVar7 = DAT_140726d88;
      if (DAT_140726d97 < 0x40) {
        uVar7 = 0x1f - (longlong)(char)DAT_140726d97;
      }
      if (param_2[0x1f] < 0x40) {
        uVar4 = 0x1f - (longlong)(char)param_2[0x1f];
      }
      else {
        uVar4 = *(ulonglong *)(param_2 + 0x10);
      }
      if (uVar7 == uVar4) {
        if (param_2[0x1f] < 0x40) {
          uVar7 = 0x1f - (longlong)(char)param_2[0x1f];
          pbVar6 = param_2;
        }
        else {
          uVar7 = *(ulonglong *)(param_2 + 0x10);
          pbVar6 = *(byte **)param_2;
        }
        uVar4 = DAT_140726d88;
        if (DAT_140726d97 < 0x40) {
          uVar4 = 0x1f - (longlong)(char)DAT_140726d97;
        }
        pbVar5 = (byte *)&DAT_140726d78;
        if (0x3f < DAT_140726d97) {
          pbVar5 = (byte *)CONCAT71(DAT_140726d78._1_7_,(undefined1)DAT_140726d78);
        }
        uVar1 = uVar4;
        if (uVar7 < uVar4) {
          uVar1 = uVar7;
        }
        for (; uVar1 != 0; uVar1 = uVar1 - 1) {
          if (*pbVar5 != *pbVar6) {
            iVar9 = (uint)*pbVar5 - (uint)*pbVar6;
            goto LAB_1400979ea;
          }
          pbVar5 = pbVar5 + 1;
          pbVar6 = pbVar6 + 1;
        }
        iVar9 = (int)uVar4 - (int)uVar7;
LAB_1400979ea:
        if (iVar9 == 0) {
          FUN_140097f40(param_1,param_3,param_4,param_5,param_6,param_7,CONCAT44(uVar10,param_8),0,0
                        ,&local_1d0,param_9,param_10,param_11,param_12,param_13,param_14);
          goto LAB_140097e6c;
        }
      }
    }
  }
  if (param_2[0x1f] < 0x40) {
    uVar7 = 0x1f - (longlong)(char)param_2[0x1f];
  }
  else {
    uVar7 = *(ulonglong *)(param_2 + 0x10);
  }
  uVar4 = DAT_140726d88;
  if (DAT_140726d97 < 0x40) {
    uVar4 = 0x1f - (longlong)(char)DAT_140726d97;
  }
  if (0xfffff < uVar4) {
    if (DAT_140726d97 >> 6 == 0) {
LAB_140097ae6:
      DAT_140726d78._0_1_ = 0;
      DAT_140726d97 = 0x1f;
    }
    else if (DAT_140726d97 >> 6 == 1) {
      *(byte *)CONCAT71(DAT_140726d78._1_7_,(undefined1)DAT_140726d78) = 0;
      DAT_140726d88 = 0;
    }
    else if (DAT_140726d97 >> 6 == 2) goto LAB_140097ae6;
  }
  if (param_2 != (byte *)&DAT_140726d78) {
    if (param_2[0x1f] < 0x40) {
      lVar8 = 0x1f - (longlong)(char)param_2[0x1f];
    }
    else {
      lVar8 = *(longlong *)(param_2 + 0x10);
      param_2 = *(byte **)param_2;
    }
    FUN_140054780(&DAT_140726d78,param_2,lVar8);
  }
  FUN_140096d00(&DAT_140726cf8,0,&param_15);
  FUN_140096d00(&DAT_140726d48,0,&param_15);
  lVar8 = DAT_140726ce8;
  local_230 = 0;
  local_228 = 0x4d;
  local_220 = 0;
  uStack_218 = 1;
  local_210 = 0;
  local_208 = 0x4d;
  local_200 = 0;
  uStack_1f8 = 1;
  local_1f0 = 0;
  local_1e8 = 0;
  DAT_140726ce8 = 0;
  if (lVar8 != 0) {
    FUN_140096a70(DAT_140726cd8);
  }
  FUN_140017b90(&local_210);
  FUN_140017b90(&local_230);
  lVar8 = DAT_140726d38;
  local_230 = 0;
  local_228 = 0x4d;
  local_220 = 0;
  uStack_218 = 1;
  local_210 = 0;
  local_208 = 0x4d;
  local_200 = 0;
  uStack_1f8 = 1;
  local_1f0 = 0;
  local_1e8 = 0;
  DAT_140726d38 = 0;
  if (lVar8 != 0) {
    FUN_140096a70(DAT_140726d28);
  }
  FUN_140017b90(&local_210);
  FUN_140017b90(&local_230);
  FUN_140096ef0(local_1a8,param_3);
  FUN_1400985d0(param_1,param_7,param_8,&local_1d0,param_9,param_10,param_11,param_12,param_13,
                param_14,local_1a8);
  FUN_140098190(param_4,param_5,param_6,local_1a8);
  if (uVar7 < 0x100000) {
    FUN_14009e940();
    FUN_1400a72b0(local_1a8,0,0);
  }
  else {
    uVar3 = FUN_14009e800(&DAT_140726d78,local_1a8,0);
    FUN_14009ea90(uVar3,0x400);
    FUN_1400a72b0(local_1a8,uVar3,0);
    FUN_14009e930(uVar3);
    uVar10 = (undefined4)((ulonglong)param_11 >> 0x20);
    uVar7 = DAT_140726d18 * 0x10 - _DAT_140726cf8;
    if (uVar7 != 0) {
      uVar2 = DAT_140726d00;
      for (uVar7 = uVar7 >> 4; uVar10 = (undefined4)((ulonglong)param_11 >> 0x20),
          DAT_140726d00 = uVar2, uVar7 != 0; uVar7 = uVar7 - 1) {
        lVar8 = *(longlong *)(DAT_140726d08 + -8 + DAT_140726d18 * 8);
        if (lVar8 != 0) {
          FUN_140018ba0(lVar8);
          thunk_FUN_1403f2404(lVar8,uVar2,
                              "C:\\build\\output\\unity\\unity\\Runtime\\Utilities\\dynamic_block_array.h"
                              ,0x164);
        }
        *(undefined8 *)(DAT_140726d08 + -8 + DAT_140726d18 * 8) = 0;
        DAT_140726d18 = DAT_140726d18 + -1;
        uVar2 = DAT_140726d00;
      }
    }
    if ((~DAT_140726d20 & 1) != 0) {
      _DAT_140726d20 = DAT_140726d18 * 2;
      DAT_140726d08 =
           FUN_1400e42a0(DAT_140726d08,DAT_140726d18 * 8,8,DAT_140726d10,
                         param_9 & 0xffffffff00000000,
                         "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\Allocators.h"
                         ,CONCAT44(uVar10,0xa3));
    }
  }
  FUN_1400a8bc0(local_1a8);
  if (local_d0 != &DAT_14058aa4c) {
    thunk_FUN_1403f2404(local_d0,local_ba,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\hash_set.h"
                        ,0x44e);
  }
  FUN_140017b90(local_f0);
  FUN_140017b90(local_110);
  FUN_140017b90(local_130);
  FUN_140017b90(local_150);
  FUN_140018ba0(local_170);
  FUN_140017130(local_188);
  FUN_140018ba0(local_1a8);
LAB_140097e6c:
  FUN_140018ba0(&local_1d0);
  _guard_check_icall(local_238);
  return;
}
```

## `ProcessPreprocessorPragmaState` — `0x1400977c0`

preprocessor pragma-state helper

```c
void ProcessPreprocessorPragmaState(longlong *param_1,longlong *param_2,undefined8 param_3)

{
  longlong lVar1;
  ulonglong uVar2;
  ulonglong uVar3;
  ulonglong uVar4;
  
  uVar2 = 0;
  uVar3 = uVar2;
  uVar4 = uVar2;
  if (param_1[2] != 0) {
    do {
      lVar1 = *param_1 + uVar4;
      AppendProgramToResponse(param_3,lVar1,lVar1 + 0x28,*(undefined4 *)(lVar1 + 0x50),0,0x1c);
      uVar3 = uVar3 + 1;
      uVar4 = uVar4 + 0x58;
    } while (uVar3 < (ulonglong)param_1[2]);
  }
  uVar3 = uVar2;
  if (param_2[2] != 0) {
    do {
      lVar1 = *param_2 + uVar3;
      AppendProgramToResponse(param_3,lVar1,lVar1 + 0x28,*(undefined4 *)(lVar1 + 0x50),1,0x1c);
      uVar2 = uVar2 + 1;
      uVar3 = uVar3 + 0x58;
    } while (uVar2 < (ulonglong)param_2[2]);
  }
  return;
}
```

## `ProcessPreprocessorIncludeStack` — `0x140097ea0`

preprocessor include-stack helper

```c
void ProcessPreprocessorIncludeStack(void)

{
  FUN_140097f40();
  return;
}
```

## `SetCompilerAvailabilityMacros` — `0x1400b0e60`

`SHADER_AVAILABLE_*` / `SHADER_TARGET_AVAILABLE*` macros

```c
/* Defines the availability macros consumed by #if SHADER_API_* / #if SHADER_TARGET_* blocks:
   SHADER_AVAILABLE_<api> and SHADER_TARGET_AVAILABLE<target>, then adds the compiled-define set via
   FUN_1400b18a0. */

void SetCompilerAvailabilityMacros(undefined8 param_1,undefined8 param_2)

{
  char *pcVar1;
  undefined1 local_58;
  undefined7 uStack_57;
  undefined8 local_48;
  byte local_39;
  undefined2 local_38;
  undefined1 local_30;
  undefined7 uStack_2f;
  undefined8 local_20;
  byte local_11;
  undefined2 local_10;
  
  local_10 = 0x4b;
  local_30 = 0;
  local_11 = 0x1f;
  pcVar1 = (char *)FUN_140056c90(&local_30,0x11);
  builtin_strncpy(pcVar1,"SHADER_AVAILABLE_",0x12);
  if (local_11 < 0x40) {
    local_11 = 0xe;
  }
  else {
    local_20 = 0x11;
  }
  local_38 = 0x4b;
  local_58 = 0;
  local_39 = 0x1f;
  pcVar1 = (char *)FUN_140056c90(&local_58,0x17);
  builtin_strncpy(pcVar1,"SHADER_TARGET_AVAILABLE",0x18);
  if (local_39 < 0x40) {
    local_39 = 8;
  }
  else {
    local_48 = 0x17;
  }
  FUN_1400b18a0(param_1,&local_58,&local_30,param_2);
  if ((local_39 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_57,local_58),local_38,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  if ((local_11 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_2f,local_30),local_10,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  return;
}
```

## `PrepareCompileRequestSource` — `0x1400b0550`

compile-request source preparation

```c
undefined8 * PrepareCompileRequestSource(undefined8 *param_1,undefined8 *param_2)

{
  undefined8 *puVar1;
  longlong *plVar2;
  longlong lVar3;
  
  if (param_1 != param_2) {
    if (*(byte *)((longlong)param_2 + 0x1f) < 0x40) {
      lVar3 = 0x1f - (longlong)*(char *)((longlong)param_2 + 0x1f);
      puVar1 = param_2;
    }
    else {
      lVar3 = param_2[2];
      puVar1 = (undefined8 *)*param_2;
    }
    FUN_140054780(param_1,puVar1,lVar3);
  }
  plVar2 = param_2 + 5;
  if (param_1 + 5 != plVar2) {
    if (*(byte *)((longlong)param_2 + 0x47) < 0x40) {
      lVar3 = 0x1f - (longlong)*(char *)((longlong)param_2 + 0x47);
    }
    else {
      lVar3 = param_2[7];
      plVar2 = (longlong *)*plVar2;
    }
    FUN_140054780(param_1 + 5,plVar2,lVar3);
  }
  plVar2 = param_2 + 10;
  if (param_1 + 10 != plVar2) {
    if (*(byte *)((longlong)param_2 + 0x6f) < 0x40) {
      lVar3 = 0x1f - (longlong)*(char *)((longlong)param_2 + 0x6f);
    }
    else {
      lVar3 = param_2[0xc];
      plVar2 = (longlong *)*plVar2;
    }
    FUN_140054780(param_1 + 10,plVar2,lVar3);
  }
  plVar2 = param_2 + 0xf;
  if (param_1 + 0xf != plVar2) {
    if (*(byte *)((longlong)param_2 + 0x97) < 0x40) {
      lVar3 = 0x1f - (longlong)*(char *)((longlong)param_2 + 0x97);
    }
    else {
      lVar3 = param_2[0x11];
      plVar2 = (longlong *)*plVar2;
    }
    FUN_140054780(param_1 + 0xf,plVar2,lVar3);
  }
  plVar2 = param_2 + 0x14;
  if (param_1 + 0x14 != plVar2) {
    if (*(byte *)((longlong)param_2 + 0xbf) < 0x40) {
      lVar3 = 0x1f - (longlong)*(char *)((longlong)param_2 + 0xbf);
    }
    else {
      lVar3 = param_2[0x16];
      plVar2 = (longlong *)*plVar2;
    }
    FUN_140054780(param_1 + 0x14,plVar2,lVar3);
  }
  plVar2 = param_2 + 0x19;
  if (param_1 + 0x19 != plVar2) {
    if (*(byte *)((longlong)param_2 + 0xe7) < 0x40) {
      lVar3 = 0x1f - (longlong)*(char *)((longlong)param_2 + 0xe7);
    }
    else {
      lVar3 = param_2[0x1b];
      plVar2 = (longlong *)*plVar2;
    }
    FUN_140054780(param_1 + 0x19,plVar2,lVar3);
  }
  plVar2 = param_2 + 0x1e;
  if (param_1 + 0x1e != plVar2) {
    if (*(byte *)((longlong)param_2 + 0x10f) < 0x40) {
      lVar3 = 0x1f - (longlong)*(char *)((longlong)param_2 + 0x10f);
    }
    else {
      lVar3 = param_2[0x20];
      plVar2 = (longlong *)*plVar2;
    }
    FUN_140054780(param_1 + 0x1e,plVar2,lVar3);
  }
  plVar2 = param_2 + 0x26;
  param_1[0x23] = param_2[0x23];
  *(undefined4 *)(param_1 + 0x24) = *(undefined4 *)(param_2 + 0x24);
  *(undefined4 *)((longlong)param_1 + 0x124) = *(undefined4 *)((longlong)param_2 + 0x124);
  *(undefined4 *)(param_1 + 0x25) = *(undefined4 *)(param_2 + 0x25);
  if (param_1 + 0x26 != plVar2) {
    if (*(byte *)((longlong)param_2 + 0x14f) < 0x40) {
      lVar3 = 0x1f - (longlong)*(char *)((longlong)param_2 + 0x14f);
    }
    else {
      lVar3 = param_2[0x28];
      plVar2 = (longlong *)*plVar2;
    }
    FUN_140054780(param_1 + 0x26,plVar2,lVar3);
  }
  *(undefined4 *)(param_1 + 0x2b) = *(undefined4 *)(param_2 + 0x2b);
  *(undefined4 *)((longlong)param_1 + 0x15c) = *(undefined4 *)((longlong)param_2 + 0x15c);
  *(undefined4 *)(param_1 + 0x2c) = *(undefined4 *)(param_2 + 0x2c);
  return param_1;
}
```

## `PrepareStageSourceSegment` — `0x1400b1070`

per-stage source segment preparation

```c
void PrepareStageSourceSegment(int param_1,longlong *param_2)

{
  longlong lVar1;
  ulonglong uVar2;
  ulonglong uVar3;
  ulonglong uVar4;
  ulonglong uVar5;
  
  uVar2 = 0;
  uVar3 = uVar2;
  uVar5 = uVar2;
  do {
    if (uVar3 != (longlong)param_1) {
      if ((byte)(&DAT_14074ed3f)[uVar2] < 0x40) {
        lVar1 = 0x1f - (longlong)(char)(&DAT_14074ed3f)[uVar2];
      }
      else {
        lVar1 = *(longlong *)(&DAT_14074ed30 + uVar2);
      }
      if (lVar1 != 0) {
        lVar1 = param_2[2];
        uVar4 = lVar1 + 1;
        if ((ulonglong)param_2[3] >> 1 < uVar4) {
          FUN_1400575b0(param_2);
        }
        param_2[2] = uVar4;
        lVar1 = *param_2 + lVar1 * 0x28;
        if (lVar1 != 0) {
          FUN_140014a90(lVar1,&DAT_14074ed20 + (longlong)(int)uVar5 * 0x50,(short)param_2[1]);
        }
      }
    }
    uVar5 = (ulonglong)((int)uVar5 + 1);
    uVar3 = uVar3 + 1;
    uVar2 = uVar2 + 0x50;
  } while ((longlong)uVar2 < 4000);
  return;
}
```

## `PrepareComputeStageSource` — `0x1400b13b0`

compute stage source preparation

```c
void PrepareComputeStageSource(undefined8 *param_1,longlong *param_2)

{
  byte *pbVar1;
  longlong lVar2;
  byte bVar3;
  char cVar4;
  byte *pbVar5;
  byte *pbVar6;
  byte *pbVar7;
  ulonglong uVar8;
  ulonglong uVar9;
  byte *pbVar10;
  ulonglong uVar11;
  longlong lVar12;
  ulonglong uVar13;
  longlong lVar14;
  byte *local_90;
  longlong local_88;
  byte *local_80;
  ulonglong local_78;
  undefined *local_70;
  undefined8 local_68;
  byte local_60;
  uint7 uStack_5f;
  ulonglong local_58;
  ulonglong local_50;
  byte local_41;
  undefined2 local_40;
  
  local_40 = 1;
  local_60 = 0;
  local_41 = 0x1f;
  pbVar1 = (byte *)*param_1;
  lVar2 = param_1[2];
  if (pbVar1 != pbVar1 + lVar2 * 0x28) {
    pbVar10 = pbVar1 + 0x1f;
    do {
      local_90 = pbVar10 + -0x1f;
      if (*pbVar10 < 0x40) {
        local_88 = 0x1f - (longlong)(char)*pbVar10;
      }
      else {
        local_88 = *(longlong *)(pbVar10 + -0xf);
        local_90 = *(byte **)local_90;
      }
      cVar4 = FUN_1400e1210(&local_90);
      if (cVar4 == '\0') {
        uVar11 = local_50;
        if (&local_60 != pbVar10 + -0x1f) {
          if (*pbVar10 < 0x40) {
            uVar11 = 0x1f - (longlong)(char)*pbVar10;
            pbVar7 = pbVar10 + -0x1f;
          }
          else {
            uVar11 = *(ulonglong *)(pbVar10 + -0xf);
            pbVar7 = *(byte **)(pbVar10 + -0x1f);
          }
          if ((local_41 & 0xc0) == 0x80) {
            local_60 = 0;
            local_41 = 0x1f;
            pbVar6 = (byte *)((ulonglong)uStack_5f << 8);
            pbVar5 = &local_60;
          }
          else if (local_41 < 0x40) {
            pbVar6 = (byte *)CONCAT71(uStack_5f,local_60);
            pbVar5 = &local_60;
          }
          else {
            pbVar6 = (byte *)CONCAT71(uStack_5f,local_60);
            pbVar5 = pbVar6;
          }
          if (pbVar7 < pbVar5) {
LAB_1400b14db:
            bVar3 = local_41 >> 6;
            if (bVar3 == 0) {
LAB_1400b14ef:
              local_60 = 0;
              local_41 = 0x1f;
            }
            else if (bVar3 == 1) {
              *pbVar6 = 0;
              local_50 = 0;
            }
            else if (bVar3 == 2) goto LAB_1400b14ef;
            pbVar5 = (byte *)FUN_140056c90(&local_60,uVar11);
            FUN_140558820(pbVar5,pbVar7,uVar11);
          }
          else {
            uVar8 = local_50;
            if (local_41 < 0x40) {
              uVar8 = 0x1f - (longlong)(char)local_41;
            }
            if (pbVar5 + uVar8 <= pbVar7) goto LAB_1400b14db;
            pbVar5 = &local_60;
            if (0x3f < local_41) {
              pbVar5 = pbVar6;
            }
            FUN_140558820(pbVar5,pbVar7,uVar11);
          }
          pbVar5[uVar11] = 0;
          if (local_41 < 0x40) {
            local_41 = 0x1f - (char)uVar11;
            uVar11 = local_50;
          }
        }
        local_50 = uVar11;
        lVar12 = DAT_1407269f0;
        pbVar7 = PTR_s__KEYWORD_DECLARED_1407269e8;
        uVar11 = local_50;
        if (DAT_1407269f0 != 0) {
          uVar8 = local_50;
          if (local_41 < 0x40) {
            uVar8 = 0x1f - (longlong)(char)local_41;
          }
          uVar11 = uVar8 + DAT_1407269f0;
          uVar9 = local_58;
          if (local_41 < 0x40) {
            uVar9 = 0x1f;
          }
          if (uVar9 < uVar11) {
            uVar13 = uVar9 * 2;
            if (uVar9 * 2 <= uVar11) {
              uVar13 = uVar11;
            }
            pbVar6 = &local_60;
            if (0x3f < local_41) {
              pbVar6 = (byte *)CONCAT71(uStack_5f,local_60);
            }
            if (pbVar6 <= PTR_s__KEYWORD_DECLARED_1407269e8) {
              uVar9 = local_50;
              if (local_41 < 0x40) {
                uVar9 = 0x1f - (longlong)(char)local_41;
              }
              if (PTR_s__KEYWORD_DECLARED_1407269e8 < pbVar6 + uVar9) {
                pbVar7 = &local_60;
                if (0x3f < local_41) {
                  pbVar7 = (byte *)CONCAT71(uStack_5f,local_60);
                }
                lVar14 = (longlong)PTR_s__KEYWORD_DECLARED_1407269e8 - (longlong)pbVar7;
                pbVar6 = (byte *)FUN_140056c90(&local_60,uVar13);
                pbVar7 = pbVar6 + lVar14;
                goto LAB_1400b1612;
              }
            }
            pbVar6 = (byte *)FUN_140056c90(&local_60,uVar13);
          }
          else {
            pbVar6 = &local_60;
            if (0x3f < local_41) {
              pbVar6 = (byte *)CONCAT71(uStack_5f,local_60);
            }
          }
LAB_1400b1612:
          FUN_140558820(pbVar6 + uVar8,pbVar7,lVar12);
          pbVar6[uVar11] = 0;
          if (local_41 < 0x40) {
            local_41 = 0x1f - (char)uVar11;
            uVar11 = local_50;
          }
        }
        local_50 = uVar11;
        uVar11 = param_2[2] + 1;
        if ((ulonglong)param_2[3] >> 1 < uVar11) {
          FUN_140057330(param_2);
        }
        param_2[2] = uVar11;
        lVar12 = *param_2 + -0x50 + uVar11 * 0x50;
        if (lVar12 != 0) {
          local_70 = PTR_DAT_1407285a0;
          local_68 = DAT_1407285a8;
          local_78 = local_50;
          if (local_41 < 0x40) {
            local_78 = 0x1f - (longlong)(char)local_41;
          }
          local_80 = &local_60;
          if (0x3f < local_41) {
            local_80 = (byte *)CONCAT71(uStack_5f,local_60);
          }
          FUN_140014b30(lVar12,&local_80,0x4b);
          FUN_140014b30(lVar12 + 0x28,&local_70,0x4b);
        }
      }
      pbVar7 = pbVar10 + 9;
      pbVar10 = pbVar10 + 0x28;
    } while (pbVar7 != pbVar1 + lVar2 * 0x28);
  }
  if ((local_41 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_5f,local_60),local_40,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  return;
}
```

## `PrepareBackendSourceBuffer` — `0x1400bacc0`

backend source buffer preparation

```c
void PrepareBackendSourceBuffer(undefined8 param_1)

{
  ulonglong uVar1;
  undefined1 *local_28;
  ulonglong local_20;
  undefined1 *local_18;
  ulonglong local_10;
  
  uVar1 = 0;
  local_20 = uVar1;
  do {
    if ((&DAT_140579664)[local_20] == '\0') goto LAB_1400bacf6;
    local_20 = local_20 + 1;
  } while (local_20 < 2);
  local_20 = 2;
LAB_1400bacf6:
  local_28 = &DAT_140579664;
  local_10 = uVar1;
  do {
    if ((&DAT_140585974)[local_10] == '\0') goto LAB_1400bad23;
    local_10 = local_10 + 1;
  } while (local_10 < 3);
  local_10 = 3;
LAB_1400bad23:
  local_18 = &DAT_140585974;
  FUN_1400e22b0(param_1,&local_18,&local_28,0);
  local_10 = uVar1;
  do {
    if ((&DAT_140579664)[local_10] == '\0') goto LAB_1400bad55;
    local_10 = local_10 + 1;
  } while (local_10 < 2);
  local_10 = 2;
LAB_1400bad55:
  local_18 = &DAT_140579664;
  do {
    local_20 = uVar1;
    if ((&DAT_140585978)[uVar1] == '\0') break;
    uVar1 = uVar1 + 1;
    local_20 = 2;
  } while (uVar1 < 2);
  local_28 = &DAT_140585978;
  FUN_1400e22b0(param_1,&local_28,&local_18,0);
  return;
}
```

## `CollectCompiledPrograms` — `0x1400b1150`

append compiled programs to the response

```c
/* Collects per-program compile results into the response: virtual +0x30 gives the count, +0x38
   yields {name, bytecode, size, stage}; each is appended by AppendProgramToResponse, then
   FinalizeCompileResponse runs. */

void CollectCompiledPrograms(undefined8 param_1,longlong param_2,longlong *param_3)

{
  undefined1 uVar1;
  undefined4 uVar2;
  ulonglong uVar3;
  undefined1 *puVar4;
  undefined1 *puVar5;
  longlong lVar6;
  ulonglong uVar7;
  undefined1 local_res20 [8];
  undefined4 uVar8;
  undefined4 local_b8;
  undefined4 local_b4;
  undefined4 local_b0;
  undefined1 local_a8;
  undefined7 uStack_a7;
  longlong local_98;
  byte local_89;
  undefined2 local_88;
  undefined1 local_80;
  undefined7 uStack_7f;
  longlong local_70;
  byte local_61;
  undefined2 local_60;
  undefined1 *local_58;
  undefined1 *local_50 [2];
  
  uVar3 = (**(code **)(*param_3 + 0x30))(param_3);
  uVar7 = 0;
  if (uVar3 != 0) {
    do {
      puVar4 = local_res20;
      (**(code **)(*param_3 + 0x38))(param_3,uVar7,local_50,&local_58,&local_b4,puVar4,&local_b8);
      puVar5 = local_58;
      uVar2 = local_b8;
      uVar1 = local_res20[0];
      uVar8 = (undefined4)((ulonglong)puVar4 >> 0x20);
      local_b0 = local_b4;
      local_60 = 0x4b;
      local_80 = 0;
      local_61 = 0x1f;
      lVar6 = -1;
      do {
        lVar6 = lVar6 + 1;
      } while (local_58[lVar6] != '\0');
      if ((local_58 < &local_80) || (&local_80 <= local_58)) {
        local_80 = 0;
        local_61 = 0x1f;
        puVar4 = (undefined1 *)FUN_140056c90(&local_80,lVar6);
        FUN_140558820(puVar4,puVar5,lVar6);
      }
      else {
        puVar4 = &local_80;
        FUN_140558820(&local_80,local_58,lVar6);
      }
      puVar4[lVar6] = 0;
      puVar4 = local_50[0];
      if (local_61 < 0x40) {
        local_61 = 0x1f - (char)lVar6;
        lVar6 = local_70;
      }
      local_70 = lVar6;
      local_88 = 0x4b;
      local_a8 = 0;
      local_89 = 0x1f;
      lVar6 = -1;
      do {
        lVar6 = lVar6 + 1;
      } while (local_50[0][lVar6] != '\0');
      if ((local_50[0] < &local_a8) || (&local_a8 <= local_50[0])) {
        local_a8 = 0;
        local_89 = 0x1f;
        puVar5 = (undefined1 *)FUN_140056c90(&local_a8,lVar6);
        FUN_140558820(puVar5,puVar4,lVar6);
      }
      else {
        puVar5 = &local_a8;
        FUN_140558820(&local_a8,local_50[0],lVar6);
      }
      puVar5[lVar6] = 0;
      if (local_89 < 0x40) {
        local_89 = 0x1f - (char)lVar6;
        lVar6 = local_98;
      }
      local_98 = lVar6;
      AppendProgramToResponse(param_1,&local_a8,&local_80,local_b0,uVar1,CONCAT44(uVar8,uVar2));
      if ((local_89 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(CONCAT71(uStack_a7,local_a8),local_88,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      if ((local_61 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(CONCAT71(uStack_7f,local_80),local_60,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      uVar7 = uVar7 + 1;
    } while (uVar7 < uVar3);
  }
  FinalizeCompileResponse(param_1,*(undefined4 *)(param_2 + 0x20),*(undefined8 *)(param_2 + 0x28));
  return;
}
```

## `FinalizeCompileResponse` — `0x1400c1d10`

finalise response and emit a validation error

```c
/* Finalizes the compile response and can reject a result outright, e.g. "Surface shader Input
   structure needs INTERNAL_DATA for this WorldNormalVector or WorldReflectionVector usage". */

void FinalizeCompileResponse(longlong *param_1)

{
  longlong *plVar1;
  longlong lVar2;
  longlong lVar3;
  longlong *plVar4;
  char cVar5;
  undefined8 ***pppuVar6;
  longlong *plVar7;
  longlong local_88;
  longlong lStack_80;
  undefined1 local_78 [16];
  undefined8 **local_68 [3];
  byte local_49;
  undefined2 local_48;
  undefined8 local_40 [3];
  byte local_21;
  undefined2 local_20;
  undefined4 local_18;
  char local_14;
  undefined4 local_10;
  
  if (param_1[1] != 0) {
    local_88 = 0;
    lStack_80 = 0;
    local_88 = FUN_1400e40a0(0x80);
    *(longlong *)local_88 = local_88;
    *(longlong *)(local_88 + 8) = local_88;
    *(longlong *)(local_88 + 0x10) = local_88;
    *(undefined2 *)(local_88 + 0x18) = 0x101;
    plVar7 = *(longlong **)*param_1;
    if (plVar7 != (longlong *)*param_1) {
      do {
        FUN_1400149f0(local_68,plVar7 + 4);
        FUN_1400149f0(local_40,plVar7 + 9);
        local_18 = (undefined4)plVar7[0xe];
        local_14 = *(char *)((longlong)plVar7 + 0x74);
        local_10 = (undefined4)plVar7[0xf];
        if (local_14 == '\0') {
          pppuVar6 = local_68;
          if (0x3f < local_49) {
            pppuVar6 = (undefined8 ***)local_68[0];
          }
          cVar5 = FUN_1400e02f0(pppuVar6,"invalid subscript \'internalSurfaceTtoW0\'");
          if (cVar5 == '\0') {
            pppuVar6 = local_68;
            if (0x3f < local_49) {
              pppuVar6 = (undefined8 ***)local_68[0];
            }
            cVar5 = FUN_1400e02f0(pppuVar6,"\'internalSurfaceTtoW0\' :  no such field in structure")
            ;
            if (cVar5 == '\0') goto LAB_1400c1df5;
          }
          FUN_140054780(local_68,
                        "Surface shader Input structure needs INTERNAL_DATA for this WorldNormalVector or WorldReflectionVector usage"
                        ,0x6c);
        }
LAB_1400c1df5:
        FUN_1400884c0(&local_88,local_78,local_68);
        if ((local_21 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(local_40[0],local_20,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
        }
        if ((local_49 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(local_68[0],local_48,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
        }
        plVar1 = (longlong *)plVar7[2];
        if (*(char *)((longlong)plVar1 + 0x19) == '\0') {
          cVar5 = *(char *)(*plVar1 + 0x19);
          plVar7 = plVar1;
          plVar1 = (longlong *)*plVar1;
          while (cVar5 == '\0') {
            cVar5 = *(char *)(*plVar1 + 0x19);
            plVar7 = plVar1;
            plVar1 = (longlong *)*plVar1;
          }
        }
        else {
          cVar5 = *(char *)(plVar7[1] + 0x19);
          plVar4 = (longlong *)plVar7[1];
          plVar1 = plVar7;
          while ((plVar7 = plVar4, cVar5 == '\0' && (plVar1 == (longlong *)plVar7[2]))) {
            cVar5 = *(char *)(plVar7[1] + 0x19);
            plVar4 = (longlong *)plVar7[1];
            plVar1 = plVar7;
          }
        }
      } while (plVar7 != (longlong *)*param_1);
    }
    if (param_1 != &local_88) {
      lVar2 = *param_1;
      *param_1 = local_88;
      lVar3 = param_1[1];
      param_1[1] = lStack_80;
      local_88 = lVar2;
      lStack_80 = lVar3;
    }
    FUN_14000b880(&local_88,&local_88,*(undefined8 *)(local_88 + 8));
    thunk_FUN_1403f2404(local_88,0x80);
  }
  return;
}
```

## `AppendProgramToResponse` — `0x140089750`

add one `{name, bytecode}` program

```c
/* Appends one {name, bytecode} program entry to the IPC response. */

void AppendProgramToResponse
               (undefined8 param_1,undefined8 param_2,undefined8 param_3,undefined4 param_4,
               undefined1 param_5,undefined4 param_6)

{
  undefined1 local_78 [16];
  undefined8 local_68 [3];
  byte local_49;
  undefined2 local_48;
  undefined8 local_40 [3];
  byte local_21;
  undefined2 local_20;
  undefined4 local_18;
  undefined1 local_14;
  undefined4 local_10;
  
  FUN_1400149f0(local_68);
  FUN_1400149f0(local_40,param_3);
  local_14 = param_5;
  local_10 = param_6;
  local_18 = param_4;
  FUN_140012550(param_1,local_78,local_68);
  if ((local_21 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(local_40[0],local_20,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  if ((local_49 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(local_68[0],local_48,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  return;
}
```
