# Surface shader generator

Ghidra decompilation of `UnityShaderCompiler.exe` (image base `0x140000000`).
Function names and leading comments are the annotations recorded in the Ghidra
database; the bodies are otherwise unedited decompiler output. See
[`shader_compiler_analysis.md`](../shader_compiler_analysis.md) for the prose
description of the same pipeline.

## `ProcessSurfaceShaderBlock` — `0x1400c5ef0`

entry into surface expansion

```c
undefined1
ProcessSurfaceShaderBlock
          (undefined8 param_1,undefined8 *param_2,undefined4 param_3,int param_4,longlong param_5,
          undefined8 *param_6)

{
  undefined1 uVar1;
  char cVar2;
  ulonglong uVar3;
  longlong lVar4;
  longlong lVar5;
  undefined1 local_38 [8];
  longlong local_30 [3];
  
  lVar5 = (longlong)param_4;
  uVar1 = 0;
  local_30[0] = 0;
  local_30[1] = 0;
  local_30[0] = FUN_1400e40a0(0x80);
  *(longlong *)local_30[0] = local_30[0];
  *(longlong *)(local_30[0] + 8) = local_30[0];
  *(longlong *)(local_30[0] + 0x10) = local_30[0];
  *(undefined2 *)(local_30[0] + 0x18) = 0x101;
  if ((param_4 == 0) || (param_4 == 3)) {
    uVar1 = GenerateSurfaceShaderPasses(param_1,param_2,param_3,param_4,param_5,param_6);
  }
  else {
    if (*(byte *)(param_5 + 0x1f) < 0x40) {
      lVar4 = 0x1f - (longlong)*(char *)(param_5 + 0x1f);
    }
    else {
      lVar4 = *(longlong *)(param_5 + 0x10);
    }
    uVar3 = 0x1f;
    if (0x3f < *(byte *)(param_5 + 0x1f)) {
      uVar3 = *(ulonglong *)(param_5 + 8);
    }
    if (uVar3 <= (ulonglong)
                 (lVar4 + *(longlong *)(&DAT_140750430 + lVar5 * 8) + 3 + (&DAT_140750410)[lVar5]))
    {
      FUN_140056c90(param_5);
    }
    FUN_140054780(param_5,(&PTR_s_CGPROGRAM_140728d00)[lVar5],(&DAT_140750410)[lVar5]);
    local_38[0] = 10;
    FUN_1400543f0(param_5,local_38,1);
    if (*(byte *)((longlong)param_2 + 0x1f) < 0x40) {
      lVar4 = 0x1f - (longlong)*(char *)((longlong)param_2 + 0x1f);
    }
    else {
      lVar4 = param_2[2];
      param_2 = (undefined8 *)*param_2;
    }
    FUN_1400543f0(param_5,param_2,lVar4);
    local_38[0] = 10;
    FUN_1400543f0(param_5,local_38,1);
    FUN_1400543f0(param_5,(&PTR_DAT_140728d20)[lVar5],*(undefined8 *)(&DAT_140750430 + lVar5 * 8));
    local_38[0] = 10;
    FUN_1400543f0(param_5,local_38,1);
  }
  cVar2 = FUN_14008ee50(local_30);
  if (cVar2 != '\0') {
    FUN_1400895c0(*param_6,local_30);
    FUN_140054780(param_5,"// Shader  with errors was here\nPass { }\n",0x29);
  }
  FUN_14000b880(local_30,local_30,*(undefined8 *)(local_30[0] + 8));
  thunk_FUN_1403f2404(local_30[0],0x80);
  return uVar1;
}
```

## `GenerateSurfaceShaderPasses` — `0x1400bec60`

CGPROGRAM to generated passes; rejects mixed blocks

```c
/* Surface shader expansion: turns a CGPROGRAM block carrying #pragma surface into ordinary
   generated passes ("// Surface shader code generated based on:"). Rejects blocks that mix #pragma
   surface with other programs. */

undefined8
GenerateSurfaceShaderPasses
          (longlong param_1,undefined8 *param_2,undefined4 param_3,int param_4,undefined1 *param_5,
          undefined8 *param_6)

{
  undefined *puVar1;
  undefined *puVar2;
  ulonglong uVar3;
  char cVar4;
  longlong lVar5;
  undefined8 uVar6;
  char *pcVar7;
  byte *pbVar8;
  undefined1 *puVar9;
  undefined8 *puVar10;
  ulonglong uVar11;
  longlong lVar12;
  longlong *plVar13;
  longlong local_838;
  undefined8 local_830;
  undefined1 local_828;
  undefined7 uStack_827;
  longlong local_818;
  byte local_809;
  undefined2 local_808;
  undefined1 local_800;
  undefined7 uStack_7ff;
  longlong local_7f0;
  byte local_7e1;
  undefined2 local_7e0;
  undefined8 *local_7d8;
  longlong local_7d0;
  undefined8 *local_7c8;
  longlong local_7c0;
  undefined8 local_7b8 [3];
  byte local_799;
  undefined2 local_798;
  undefined8 local_790 [3];
  byte local_771;
  undefined2 local_770;
  undefined8 local_768 [3];
  byte local_749;
  undefined2 local_748;
  undefined8 local_740 [3];
  byte local_721;
  undefined2 local_720;
  undefined8 local_718 [3];
  byte local_6f9;
  undefined2 local_6f8;
  undefined8 local_6f0 [3];
  byte local_6d1;
  undefined2 local_6d0;
  undefined1 local_6c8 [304];
  undefined8 local_598;
  byte local_579;
  undefined2 local_578;
  undefined1 local_560 [360];
  undefined8 local_3f8 [2];
  longlong local_3e8;
  byte local_3d9;
  undefined2 local_3d8;
  undefined8 local_3d0;
  undefined8 local_3c8;
  longlong lStack_3c0;
  undefined2 local_3b8;
  undefined8 local_3b0;
  undefined8 local_3a8;
  undefined4 *local_3a0;
  undefined8 local_398;
  undefined4 local_390;
  undefined2 local_38a;
  undefined4 local_388;
  undefined8 local_380;
  undefined8 *local_378;
  undefined2 local_370;
  ulonglong local_368;
  ulonglong uStack_360;
  undefined4 local_358;
  undefined8 local_350;
  undefined8 local_348;
  undefined8 local_340;
  undefined8 local_338;
  undefined1 local_328 [71];
  byte local_2e1 [145];
  longlong local_250;
  byte local_241;
  undefined8 local_1f8;
  byte local_1d9;
  undefined2 local_1d8;
  undefined1 local_1c0 [360];
  undefined8 local_58;
  longlong local_50;
  undefined2 local_48;
  longlong local_40;
  undefined8 local_38;
  undefined4 local_30;
  undefined4 local_2c;
  undefined4 uVar14;
  
  local_838 = 0;
  local_830 = 0;
  local_838 = FUN_1400e40a0(0x80);
  *(longlong *)local_838 = local_838;
  *(longlong *)(local_838 + 8) = local_838;
  *(longlong *)(local_838 + 0x10) = local_838;
  *(undefined2 *)(local_838 + 0x18) = 0x101;
  FUN_140015ef0(local_328);
  FUN_1400afd40(local_1c0);
  local_58 = 0x21;
  local_50 = 0;
  local_48 = 0x19;
  local_40 = 0;
  local_38 = 1;
  local_30 = 0xffffffff;
  local_2c = 0;
  plVar13 = &local_838;
  SplitSourceByPragmaDirective(param_2,param_3,param_4,local_328,plVar13);
  uVar14 = (undefined4)((ulonglong)plVar13 >> 0x20);
  if (local_241 < 0x40) {
    local_250 = 0x1f - (longlong)(char)local_241;
  }
  if (local_250 == 0) {
    puVar1 = (&PTR_DAT_140728d20)[param_4];
    if (*(byte *)((longlong)param_2 + 0x1f) < 0x40) {
      local_7d0 = 0x1f - (longlong)*(char *)((longlong)param_2 + 0x1f);
    }
    else {
      local_7d0 = param_2[2];
      param_2 = (undefined8 *)*param_2;
    }
    local_7d8 = param_2;
    local_7c8 = (undefined8 *)FUN_1400c10e0(local_790,local_328);
    if (*(byte *)((longlong)local_7c8 + 0x1f) < 0x40) {
      local_7c0 = 0x1f - (longlong)*(char *)((longlong)local_7c8 + 0x1f);
    }
    else {
      local_7c0 = local_7c8[2];
      local_7c8 = (undefined8 *)*local_7c8;
    }
    puVar2 = (&PTR_s_CGPROGRAM_140728d00)[param_4];
    local_808 = 0x4b;
    lVar12 = -1;
    do {
      lVar12 = lVar12 + 1;
    } while (puVar2[lVar12] != '\0');
    local_828 = 0;
    local_809 = 0x1f;
    lVar5 = FUN_140056c90(&local_828,lVar12);
    FUN_140558820(lVar5,puVar2,lVar12);
    *(undefined1 *)(lVar5 + lVar12) = 0;
    if (local_809 < 0x40) {
      local_809 = 0x1f - (char)lVar12;
      lVar12 = local_818;
    }
    local_818 = lVar12;
    uVar6 = FUN_140068700(local_7b8,&local_828,10);
    uVar6 = FUN_14001aaa0(local_6f0,uVar6,&local_7c8);
    uVar6 = FUN_14001aaa0(local_718,uVar6,&local_7d8);
    uVar6 = FUN_14001ad10(local_740,uVar6,puVar1);
    uVar6 = FUN_140068700(local_768,uVar6,10);
    FUN_1400545d0(param_5,uVar6);
    if ((local_749 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(local_768[0],local_748,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    if ((local_721 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(local_740[0],local_720,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    if ((local_6f9 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(local_718[0],local_6f8,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    if ((local_6d1 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(local_6f0[0],local_6d0,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    if ((local_799 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(local_7b8[0],local_798,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    if ((local_809 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(uStack_827,local_828),local_808,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    if ((local_771 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(local_790[0],local_770,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    uVar6 = 0;
  }
  else {
    lVar12 = 1;
    pbVar8 = local_2e1;
    do {
      if (*pbVar8 < 0x40) {
        lVar5 = 0x1f - (longlong)(char)*pbVar8;
      }
      else {
        lVar5 = *(longlong *)(pbVar8 + -0xf);
      }
      if (lVar5 != 0) {
        local_808 = 0x4b;
        local_828 = 0;
        local_809 = 0x1f;
        pcVar7 = (char *)FUN_140056c90(&local_828,0x42);
        builtin_strncpy(pcVar7,"CGPROGRAM cannot contain #pragma surface as well as other programs",
                        0x43);
        if (local_809 < 0x40) {
          local_809 = 0xdd;
        }
        else {
          local_818 = 0x42;
        }
        FUN_140089820(&local_838,&local_828,param_3,0,CONCAT44(uVar14,0x1c));
        if ((local_809 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(CONCAT71(uStack_827,local_828),local_808,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
        }
        break;
      }
      lVar12 = lVar12 + 1;
      pbVar8 = pbVar8 + 0x28;
    } while (lVar12 < 5);
    local_7e0 = 0x4b;
    local_800 = 0;
    local_7e1 = 0x1f;
    FUN_140015ef0(local_6c8);
    FUN_1400afd40(local_560);
    local_3d8 = 0x4b;
    local_3f8[0]._0_1_ = 0;
    local_3d9 = 0x1f;
    local_3d0 = 0;
    local_3c8 = 0;
    lStack_3c0 = 0;
    local_3b8 = 0x4d;
    local_3b0 = 0;
    local_3a8 = 1;
    local_3a0 = &DAT_14058aa4c;
    local_398 = 0;
    local_390 = 0;
    local_38a = 0x4e;
    local_388 = 0;
    local_380 = 0x21;
    local_378 = (undefined8 *)0x0;
    local_370 = 0x19;
    local_368 = 0;
    uStack_360 = 1;
    local_358 = 0;
    local_350 = 0;
    local_348 = 0;
    local_340 = 0;
    local_338 = 0;
    lVar12 = local_3e8;
    if (local_3f8 != param_2) {
      if (*(byte *)((longlong)param_2 + 0x1f) < 0x40) {
        lVar12 = 0x1f - (longlong)*(char *)((longlong)param_2 + 0x1f);
      }
      else {
        lVar12 = param_2[2];
        param_2 = (undefined8 *)*param_2;
      }
      local_3f8[0]._0_1_ = 0;
      local_3d9 = 0x1f;
      lVar5 = FUN_140056c90(local_3f8,lVar12);
      FUN_140558820(lVar5,param_2,lVar12);
      *(undefined1 *)(lVar5 + lVar12) = 0;
      if (local_3d9 < 0x40) {
        local_3d9 = 0x1f - (char)lVar12;
        lVar12 = local_3e8;
      }
    }
    local_3e8 = lVar12;
    PrepareCompileRequestSource(local_6c8,local_328);
    FUN_1400b0a50(local_560,local_1c0);
    lVar12 = local_50;
    local_380 = local_58;
    lVar5 = local_40 * 0x30;
    if (local_368 != 0) {
      puVar10 = local_378 + 4;
      uVar11 = local_368;
      do {
        if ((*(byte *)((longlong)puVar10 + -1) & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(puVar10[-4],*(undefined2 *)puVar10,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
        }
        puVar10 = puVar10 + 6;
        uVar11 = uVar11 + -1;
      } while (uVar11 != 0);
    }
    lVar5 = lVar5 / 6 + (lVar5 >> 0x3f);
    uVar11 = (lVar5 >> 3) - (lVar5 >> 0x3f);
    uVar3 = uVar11;
    puVar10 = local_378;
    if (uStack_360 >> 1 < uVar11) {
      FUN_1400c9df0(&local_378,uVar11,1);
      puVar10 = local_378;
    }
    for (; local_368 = uVar3, uVar11 != 0; uVar11 = uVar11 - 1) {
      local_7d8 = puVar10;
      local_7c8 = puVar10;
      if (puVar10 != (undefined8 *)0x0) {
        FUN_1400149f0(puVar10,lVar12);
        puVar10[5] = *(undefined8 *)(lVar12 + 0x28);
      }
      lVar12 = lVar12 + 0x30;
      uVar3 = local_368;
      puVar10 = puVar10 + 6;
    }
    local_388 = local_30;
    local_358 = param_3;
    if ((longlong *)(param_1 + 0x28) != &lStack_3c0) {
      lVar12 = *(longlong *)(param_1 + 0x28);
      FUN_140054d80(&lStack_3c0,lVar12,lVar12 + *(longlong *)(param_1 + 0x38) * 0x28);
    }
    FUN_140019e80(&local_3a0,param_1 + 0x48);
    GenerateSurfaceLightingModel(local_6c8,&local_800,&local_838,param_6[1]);
    cVar4 = FUN_14008ee50(&local_838);
    if (cVar4 == '\0') {
      if (param_5 != &local_800) {
        if (local_7e1 < 0x40) {
          local_7f0 = 0x1f - (longlong)(char)local_7e1;
        }
        puVar9 = &local_800;
        if (0x3f < local_7e1) {
          puVar9 = (undefined1 *)CONCAT71(uStack_7ff,local_800);
        }
        FUN_140054780(param_5,puVar9,local_7f0);
      }
    }
    else {
      uVar6 = FUN_14001b190(local_7b8,"// surface shader with errors was here\nPass { }\n/*",
                            &local_800);
      uVar6 = FUN_14001ad10(local_790,uVar6,&DAT_140588764);
      FUN_1400545d0(param_5,uVar6);
      if ((local_771 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(local_790[0],local_770,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      if ((local_799 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(local_7b8[0],local_798,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
    }
    FUN_1400895c0(*param_6,&local_838);
    uVar6 = 1;
    FUN_140017d70(&local_378);
    FUN_140055550(&local_3a0);
    FUN_140018ba0(&lStack_3c0);
    if ((local_3d9 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(local_3f8[0]._1_7_,(undefined1)local_3f8[0]),local_3d8,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    FUN_1400aff80(local_560);
    if ((local_579 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(local_598,local_578,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    _eh_vector_destructor_iterator_(local_6c8,0x28,7,FUN_140017380);
    if ((local_7e1 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(uStack_7ff,local_800),local_7e0,
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
  FUN_14000b880(&local_838,&local_838,*(undefined8 *)(local_838 + 8));
  thunk_FUN_1403f2404(local_838,0x80);
  return uVar6;
}
```

## `GenerateSurfaceLightingModel` — `0x140084d60`

lighting-model dispatch

```c
/* Surface generator, lighting-model layer. Owns the "Standard" / "StandardSpecular" model names and
   dispatches to one of five per-model pass emitters (FUN_140079e30, FUN_14007b3c0, FUN_14007c5c0,
   FUN_14007e320, FUN_140080890), each of which calls GenerateSurfacePassHeader and
   GenerateV2fStruct. */

void GenerateSurfaceLightingModel
               (longlong param_1,char *param_2,undefined8 param_3,undefined8 param_4)

{
  byte bVar1;
  longlong *plVar2;
  char cVar3;
  char *pcVar4;
  undefined8 *puVar5;
  undefined8 uVar6;
  char *pcVar7;
  char *pcVar8;
  longlong lVar9;
  ulonglong uVar10;
  longlong lVar11;
  byte *pbVar12;
  undefined8 *puVar13;
  longlong lVar14;
  longlong *plVar15;
  undefined1 *puVar16;
  longlong *plVar17;
  int iVar18;
  byte *pbVar19;
  longlong *plVar20;
  ulonglong uVar21;
  ulonglong uVar22;
  undefined4 uVar23;
  longlong local_6b8 [2];
  undefined1 local_6a8;
  undefined7 uStack_6a7;
  longlong local_698;
  byte local_689;
  undefined2 local_688;
  longlong local_680 [5];
  undefined1 local_658;
  undefined7 uStack_657;
  longlong local_648;
  byte local_639;
  undefined2 local_638;
  longlong *local_630;
  longlong lStack_628;
  undefined8 local_620 [3];
  byte local_601;
  undefined2 local_600;
  undefined8 local_5f8 [3];
  byte local_5d9;
  undefined2 local_5d8;
  undefined8 local_5d0 [3];
  byte local_5b1;
  undefined2 local_5b0;
  undefined1 local_5a8 [224];
  undefined1 local_4c8 [224];
  undefined1 local_3e8 [224];
  undefined8 local_308;
  undefined2 local_300;
  undefined8 local_2f8;
  undefined8 local_2f0;
  undefined8 local_2e8;
  undefined2 local_2e0;
  undefined8 local_2d8;
  undefined8 local_2d0;
  undefined8 local_2c8;
  undefined2 local_2c0;
  undefined8 local_2b8;
  undefined8 local_2b0;
  undefined1 local_2a8 [224];
  undefined1 local_1c8 [32];
  undefined1 local_1a8 [32];
  undefined1 local_188 [48];
  undefined8 local_158;
  undefined2 local_150;
  undefined8 local_148;
  undefined8 uStack_140;
  undefined1 local_138 [256];
  
  bVar1 = (byte)param_2[0x1f] >> 6;
  if (bVar1 == 0) {
LAB_140084dac:
    *param_2 = '\0';
    param_2[0x1f] = '\x1f';
  }
  else if (bVar1 == 1) {
    **(undefined1 **)param_2 = 0;
    param_2[0x10] = '\0';
    param_2[0x11] = '\0';
    param_2[0x12] = '\0';
    param_2[0x13] = '\0';
    param_2[0x14] = '\0';
    param_2[0x15] = '\0';
    param_2[0x16] = '\0';
    param_2[0x17] = '\0';
  }
  else if (bVar1 == 2) goto LAB_140084dac;
  local_6b8[0] = 0;
  local_6b8[1] = 0;
  local_6b8[0] = FUN_1400e40a0(0x80);
  *(longlong *)local_6b8[0] = local_6b8[0];
  *(longlong *)(local_6b8[0] + 8) = local_6b8[0];
  *(longlong *)(local_6b8[0] + 0x10) = local_6b8[0];
  *(undefined2 *)(local_6b8[0] + 0x18) = 0x101;
  FUN_1400845d0(param_1);
  _eh_vector_constructor_iterator_
            (local_5a8,0x20,7,(_func_void_void_ptr *)&LAB_140015060,FUN_140067a20);
  _eh_vector_constructor_iterator_
            (local_4c8,0x20,7,(_func_void_void_ptr *)&LAB_140015060,FUN_140067a20);
  _eh_vector_constructor_iterator_
            (local_3e8,0x20,7,(_func_void_void_ptr *)&LAB_140015060,FUN_140067a20);
  local_308 = 0;
  local_300 = 0x19;
  local_2f8 = 0;
  local_2f0 = 1;
  local_2e8 = 0;
  local_2e0 = 0x19;
  local_2d8 = 0;
  local_2d0 = 1;
  local_2c8 = 0;
  local_2c0 = 0x19;
  local_2b8 = 0;
  local_2b0 = 1;
  _eh_vector_constructor_iterator_
            (local_2a8,0x20,7,(_func_void_void_ptr *)&LAB_140015060,FUN_140018ba0);
  FUN_1400e7310(local_1c8);
  local_158 = 0;
  local_150 = 0x4d;
  local_148 = 0;
  uStack_140 = 1;
  _eh_vector_constructor_iterator_
            (local_138,0x20,8,(_func_void_void_ptr *)&LAB_140015060,FUN_140017b90);
  if (*(byte *)(param_1 + 0x14f) < 0x40) {
    lVar9 = 0x1f - (longlong)*(char *)(param_1 + 0x14f);
  }
  else {
    lVar9 = *(longlong *)(param_1 + 0x140);
  }
  FUN_14008e820(local_5a8,param_1 + 0x168,lVar9 != 0,1,param_1 + 0x308,local_6b8);
  cVar3 = FUN_14008ee50(local_6b8);
  if (cVar3 != '\0') {
    FUN_1400895c0(param_3,local_6b8);
    if ((byte)param_2[0x1f] < 0x40) {
      lVar9 = 0x1f - (longlong)param_2[0x1f];
      uVar10 = 0x1f;
    }
    else {
      lVar9 = *(longlong *)(param_2 + 0x10);
      uVar10 = *(ulonglong *)(param_2 + 8);
    }
    uVar22 = lVar9 + 0x49;
    if (uVar10 < uVar22) {
      uVar21 = uVar10 * 2;
      if (uVar10 * 2 <= uVar22) {
        uVar21 = uVar22;
      }
      pcVar4 = param_2;
      if (0x3f < (byte)param_2[0x1f]) {
        pcVar4 = *(char **)param_2;
      }
      if (pcVar4 < "/ invalid multi_compile or shader_feature directives for surface shader\n") {
        if ((byte)param_2[0x1f] < 0x40) {
          lVar11 = 0x1f - (longlong)param_2[0x1f];
        }
        else {
          lVar11 = *(longlong *)(param_2 + 0x10);
        }
        if ("// invalid multi_compile or shader_feature directives for surface shader\n" <
            pcVar4 + lVar11) {
          pcVar4 = param_2;
          if (0x3f < (byte)param_2[0x1f]) {
            pcVar4 = *(char **)param_2;
          }
          lVar11 = -(longlong)pcVar4;
          pcVar4 = (char *)FUN_140056c90(param_2,uVar21);
          uVar6 = *(undefined8 *)
                   (pcVar4 + (longlong)
                             "// invalid multi_compile or shader_feature directives for surface shader\n"
                             + lVar11 + 8);
          *(undefined8 *)(pcVar4 + lVar9) =
               *(undefined8 *)
                (pcVar4 + (longlong)
                          "// invalid multi_compile or shader_feature directives for surface shader\n"
                          + lVar11);
          *(undefined8 *)(pcVar4 + lVar9 + 8) = uVar6;
          uVar6 = *(undefined8 *)
                   ("// invalid multi_compile or shader_feature directives for surface shader\n" +
                    lVar11 + 0x10 + (longlong)pcVar4 + 8);
          *(undefined8 *)(pcVar4 + lVar9 + 0x10) =
               *(undefined8 *)
                ("// invalid multi_compile or shader_feature directives for surface shader\n" +
                 lVar11 + 0x10 + (longlong)pcVar4);
          *(undefined8 *)(pcVar4 + lVar9 + 0x10 + 8) = uVar6;
          uVar6 = *(undefined8 *)
                   ("// invalid multi_compile or shader_feature directives for surface shader\n" +
                    lVar11 + 0x20 + (longlong)pcVar4 + 8);
          *(undefined8 *)(pcVar4 + lVar9 + 0x20) =
               *(undefined8 *)
                ("// invalid multi_compile or shader_feature directives for surface shader\n" +
                 lVar11 + 0x20 + (longlong)pcVar4);
          *(undefined8 *)(pcVar4 + lVar9 + 0x20 + 8) = uVar6;
          uVar6 = *(undefined8 *)
                   ("// invalid multi_compile or shader_feature directives for surface shader\n" +
                    lVar11 + 0x30 + (longlong)pcVar4 + 8);
          *(undefined8 *)(pcVar4 + lVar9 + 0x30) =
               *(undefined8 *)
                ("// invalid multi_compile or shader_feature directives for surface shader\n" +
                 lVar11 + 0x30 + (longlong)pcVar4);
          *(undefined8 *)(pcVar4 + lVar9 + 0x30 + 8) = uVar6;
          *(undefined8 *)(pcVar4 + lVar9 + 0x40) =
               *(undefined8 *)
                ("// invalid multi_compile or shader_feature directives for surface shader\n" +
                 lVar11 + 0x40 + (longlong)pcVar4);
          pcVar4[lVar9 + 0x48] =
               ("// invalid multi_compile or shader_feature directives for surface shader\n" +
               lVar11 + 0x48)[(longlong)pcVar4];
          goto LAB_140085166;
        }
      }
      pcVar4 = (char *)FUN_140056c90(param_2,uVar21);
      builtin_strncpy(pcVar4 + lVar9,
                      "// invalid multi_compile or shader_feature directives for surface shader\n",
                      0x49);
    }
    else {
      pcVar4 = param_2;
      if (0x3f < (byte)param_2[0x1f]) {
        pcVar4 = *(char **)param_2;
      }
      builtin_strncpy(pcVar4 + lVar9,
                      "// invalid multi_compile or shader_feature directives for surface shader\n",
                      0x49);
    }
LAB_140085166:
    pcVar4[uVar22] = '\0';
    if ((byte)param_2[0x1f] < 0x40) {
      param_2[0x1f] = '\x1f' - (char)uVar22;
    }
    else {
      *(ulonglong *)(param_2 + 0x10) = uVar22;
    }
    goto LAB_140085cbf;
  }
  pbVar12 = (byte *)(param_1 + 400);
  if (*(byte *)(param_1 + 0x1af) < 0x40) {
    lVar9 = 0x1f - (longlong)*(char *)(param_1 + 0x1af);
  }
  else {
    lVar9 = *(longlong *)(param_1 + 0x1a0);
    pbVar12 = *(byte **)pbVar12;
  }
  pcVar4 = "Standard";
  pbVar19 = pbVar12 + lVar9;
  for (; pbVar12 < pbVar19; pbVar12 = pbVar12 + 1) {
    if (*pbVar12 != *pcVar4) {
      iVar18 = (uint)*pbVar12 - (uint)(byte)*pcVar4;
      goto LAB_1400851d2;
    }
    if (*pcVar4 == 0) goto LAB_1400851d7;
    pcVar4 = pcVar4 + 1;
  }
  iVar18 = -(uint)(byte)*pcVar4;
LAB_1400851d2:
  if (iVar18 == 0) {
LAB_140085236:
    lVar9 = FUN_140056850(param_1 + 0x2d0,"#include \"UnityPBSLighting.cginc\"",0,0x21);
    if (lVar9 == -1) {
      *(undefined1 *)(param_1 + 0x2c9) = 1;
    }
  }
  else {
LAB_1400851d7:
    pbVar12 = (byte *)(param_1 + 400);
    if (*(byte *)(param_1 + 0x1af) < 0x40) {
      lVar9 = 0x1f - (longlong)*(char *)(param_1 + 0x1af);
    }
    else {
      lVar9 = *(longlong *)(param_1 + 0x1a0);
      pbVar12 = *(byte **)pbVar12;
    }
    pcVar4 = "StandardSpecular";
    pbVar19 = pbVar12 + lVar9;
    for (; pbVar12 < pbVar19; pbVar12 = pbVar12 + 1) {
      if (*pbVar12 != *pcVar4) {
        iVar18 = (uint)*pbVar12 - (uint)(byte)*pcVar4;
        goto LAB_140085232;
      }
      if (*pcVar4 == 0) goto LAB_140085260;
      pcVar4 = pcVar4 + 1;
    }
    iVar18 = -(uint)(byte)*pcVar4;
LAB_140085232:
    if (iVar18 == 0) goto LAB_140085236;
  }
LAB_140085260:
  lVar9 = FUN_140056850(param_1 + 0x2d0,"#include \"Lighting.cginc\"",0,0x19);
  *(bool *)(param_1 + 0x2ca) = lVar9 == -1;
  local_680[0] = 0;
  local_680[1] = 0;
  local_680[2] = 0;
  local_680[3] = 0;
  local_680[4] = 0;
  local_680[3] = FUN_1400e40a0(0x48);
  *(longlong *)local_680[3] = local_680[3];
  *(longlong *)(local_680[3] + 8) = local_680[3];
  *(longlong *)(local_680[3] + 0x10) = local_680[3];
  *(undefined2 *)(local_680[3] + 0x18) = 0x101;
  local_688 = 0x4b;
  local_6a8 = 0;
  local_689 = 0x1f;
  puVar5 = (undefined8 *)FUN_1400e40a0();
  puVar13 = (undefined8 *)0x0;
  if (puVar5 != (undefined8 *)0x0) {
    *puVar5 = &DAT_14058aa4c;
    puVar5[1] = 0;
    *(undefined4 *)(puVar5 + 2) = 0;
    *(undefined2 *)((longlong)puVar5 + 0x16) = 0x4e;
    plVar20 = puVar5 + 3;
    *plVar20 = 0;
    puVar5[4] = 0;
    local_630 = plVar20;
    lVar9 = FUN_1400e40a0(0x1f8);
    *(longlong *)lVar9 = lVar9;
    *(longlong *)(lVar9 + 8) = lVar9;
    *(longlong *)(lVar9 + 0x10) = lVar9;
    *(undefined2 *)(lVar9 + 0x18) = 0x101;
    *plVar20 = lVar9;
    FUN_140089460(puVar5 + 5,param_1 + 0x308);
    puVar5[0x1d] = 0;
    puVar5[0x1e] = 0;
    puVar5[0x1f] = 0;
    puVar5[0x20] = 0;
    *(undefined4 *)(puVar5 + 0x21) = 0;
    puVar5[0x29] = 0;
    *(undefined4 *)(puVar5 + 0x2a) = 0;
    *(undefined4 *)(puVar5 + 0x2b) = 0;
    puVar5[0x33] = 0;
    *(undefined4 *)(puVar5 + 0x34) = 0;
    puVar13 = puVar5;
  }
  if (*(byte *)(param_1 + 0x2ef) < 0x40) {
    lVar9 = 0x1f - (longlong)*(char *)(param_1 + 0x2ef);
  }
  else {
    lVar9 = *(longlong *)(param_1 + 0x2e0);
  }
  lVar11 = FUN_14008f7e0(local_5a8,param_1 + 0x2d0,3);
  if (lVar11 != 0) {
    puVar5 = (undefined8 *)(param_1 + 0x2d0);
    if (*(byte *)(param_1 + 0x2ef) < 0x40) {
      lVar11 = 0x1f - (longlong)*(char *)(param_1 + 0x2ef);
    }
    else {
      lVar11 = *(longlong *)(param_1 + 0x2e0);
    }
    if (*(byte *)(param_1 + 0x2ef) < 0x40) {
      lStack_628 = 0x1f - (longlong)*(char *)(param_1 + 0x2ef);
    }
    else {
      lStack_628 = *(longlong *)(param_1 + 0x2e0);
      puVar5 = (undefined8 *)*puVar5;
    }
    lStack_628 = lStack_628 - (lVar11 - lVar9);
    local_630 = (longlong *)((longlong)puVar5 + (lVar11 - lVar9));
    *(longlong **)(param_1 + 0x2f8) = local_630;
    *(longlong *)(param_1 + 0x300) = lStack_628;
  }
  plVar20 = local_6b8;
  FUN_14006c180(local_5a8,param_1,&local_6a8,local_680,plVar20,puVar13);
  FUN_1400895c0(param_3,local_6b8);
  cVar3 = FUN_14008ee50(local_6b8);
  lVar9 = local_680[0];
  if (cVar3 == '\0') {
    lVar11 = FUN_140065a80(local_680[0] + 0x168,param_1 + 400);
    uVar23 = (undefined4)((ulonglong)plVar20 >> 0x20);
    if (lVar11 != *(longlong *)(lVar9 + 0x168)) {
      lVar9 = lVar11 + 0x48;
      FUN_1400543f0(param_2,"\n\t// ------------------------------------------------------------\n",
                    0x42);
      FUN_1400543f0(param_2,"\t// Surface shader code generated out of a CGPROGRAM block:\n",0x3c);
      if (*(int *)(param_1 + 0x1b8) == 1) {
        FUN_1400543f0(param_2,"\tZWrite Off",0xb);
        if (*(char *)(param_1 + 0x2cc) == '\0') {
          uVar6 = 0xf;
          pcVar4 = " ColorMask RGB\n";
        }
        else {
          uVar6 = 1;
          pcVar4 = "\n";
        }
        FUN_1400543f0(param_2,pcVar4,uVar6);
      }
      FUN_1400543f0(param_2,&DAT_1405833c8,2);
      if ((*(uint *)(param_1 + 0x2b0) & *(uint *)(lVar11 + 0xa4) & 1) != 0) {
        if (*(char *)(param_1 + 0x2bf) == '\0') {
          FUN_14006afb0(param_1,0,local_680,&local_6a8,lVar9,local_6b8,puVar13);
        }
        if (*(char *)(param_1 + 0x2c0) == '\0') {
          FUN_14006afb0(param_1,1,local_680,&local_6a8,lVar9,local_6b8,puVar13);
        }
        cVar3 = FUN_14008ee50(local_6b8);
        if (cVar3 != '\0') {
          FUN_1400895c0(param_3,local_6b8);
          goto LAB_14008547a;
        }
        lVar14 = local_698;
        if (local_689 < 0x40) {
          lVar14 = 0x1f - (longlong)(char)local_689;
        }
        puVar16 = &local_6a8;
        if (0x3f < local_689) {
          puVar16 = (undefined1 *)CONCAT71(uStack_6a7,local_6a8);
        }
        FUN_1400543f0(param_2,puVar16,lVar14);
        cVar3 = FUN_14008ee50(local_6b8);
        if ((cVar3 == '\0') && (*(char *)(param_1 + 0x2bf) == '\0')) {
          FUN_14007c100(param_2,param_1,local_680,local_6b8);
        }
        cVar3 = FUN_14008ee50(local_6b8);
        if ((cVar3 == '\0') && (*(char *)(param_1 + 0x2c0) == '\0')) {
          GenerateForwardAddPasses(param_2,param_1,local_680,local_6b8);
        }
      }
      if ((*(uint *)(param_1 + 0x2b0) & *(uint *)(lVar11 + 0xa4) & 2) != 0) {
        FUN_14006afb0(param_1,2,local_680,&local_6a8,lVar9,local_6b8,puVar13);
        cVar3 = FUN_14008ee50(local_6b8);
        if (cVar3 != '\0') {
          FUN_1400895c0(param_3,local_6b8);
          goto LAB_14008547a;
        }
        lVar11 = local_698;
        if (local_689 < 0x40) {
          lVar11 = 0x1f - (longlong)(char)local_689;
        }
        puVar16 = &local_6a8;
        if (0x3f < local_689) {
          puVar16 = (undefined1 *)CONCAT71(uStack_6a7,local_6a8);
        }
        FUN_1400543f0(param_2,puVar16,lVar11);
        cVar3 = FUN_14008ee50(local_6b8);
        if (cVar3 == '\0') {
          GeneratePrepassFinalPasses(param_2,param_1,local_680,local_6b8);
        }
      }
      if (*(char *)(param_1 + 0x2b4) != '\0') {
        FUN_14006afb0(param_1,3,local_680,&local_6a8,lVar9,local_6b8,puVar13);
        cVar3 = FUN_14008ee50(local_6b8);
        if (cVar3 != '\0') {
          FUN_1400895c0(param_3,local_6b8);
          goto LAB_14008547a;
        }
        lVar11 = local_698;
        if (local_689 < 0x40) {
          lVar11 = 0x1f - (longlong)(char)local_689;
        }
        puVar16 = &local_6a8;
        if (0x3f < local_689) {
          puVar16 = (undefined1 *)CONCAT71(uStack_6a7,local_6a8);
        }
        FUN_1400543f0(param_2,puVar16,lVar11);
        cVar3 = FUN_14008ee50(local_6b8);
        if (cVar3 == '\0') {
          FUN_140080410(param_2,param_1,local_680,local_6b8);
        }
      }
      if ((*(char *)(param_1 + 0x2c1) == '\0') && (*(char *)(param_1 + 0x2b9) == '\0')) {
        FUN_14006afb0(param_1,4,local_680,&local_6a8,lVar9,local_6b8,puVar13);
        cVar3 = FUN_14008ee50(local_6b8);
        if (cVar3 != '\0') {
          FUN_1400895c0(param_3,local_6b8);
          goto LAB_14008547a;
        }
        if (local_689 < 0x40) {
          local_698 = 0x1f - (longlong)(char)local_689;
        }
        puVar16 = &local_6a8;
        if (0x3f < local_689) {
          puVar16 = (undefined1 *)CONCAT71(uStack_6a7,local_6a8);
        }
        FUN_1400543f0(param_2,puVar16,local_698);
        cVar3 = FUN_14008ee50(local_6b8);
        if (cVar3 == '\0') {
          GenerateSurfaceAdditionalPass(param_2,param_1,local_680,local_6b8);
        }
      }
      FUN_1400543f0(param_2,"\n\t// ---- end of surface shader generated code\n",0x2f);
      FUN_1400895c0(param_3,local_6b8);
      *(undefined8 *)(param_1 + 0x378) = puVar13[0x1d];
      *(undefined8 *)(param_1 + 0x388) = puVar13[0x1e];
      *(undefined8 *)(param_1 + 0x380) = puVar13[0x1f];
      *(undefined8 *)(param_1 + 0x390) = puVar13[0x20];
      goto LAB_140085c60;
    }
    local_638 = 0x4b;
    local_658 = 0;
    local_639 = 0x1f;
    plVar17 = (longlong *)**(longlong **)(lVar9 + 0x168);
    if (plVar17 == *(longlong **)(lVar9 + 0x168)) {
LAB_1400855c1:
      puVar16 = &local_658;
    }
    else {
      do {
        lVar9 = local_648;
        if (local_639 < 0x40) {
          lVar9 = 0x1f - (longlong)(char)local_639;
        }
        if (lVar9 != 0) {
          FUN_1400543f0(&local_658,&DAT_1405802e8,2);
        }
        plVar15 = plVar17 + 4;
        if (*(byte *)((longlong)plVar17 + 0x3f) < 0x40) {
          lVar9 = 0x1f - (longlong)*(char *)((longlong)plVar17 + 0x3f);
        }
        else {
          lVar9 = plVar17[6];
          plVar15 = (longlong *)*plVar15;
        }
        FUN_1400543f0(&local_658,plVar15,lVar9);
        uVar23 = (undefined4)((ulonglong)plVar20 >> 0x20);
        plVar15 = (longlong *)plVar17[2];
        if (*(char *)((longlong)plVar15 + 0x19) == '\0') {
          cVar3 = *(char *)(*plVar15 + 0x19);
          plVar17 = plVar15;
          plVar15 = (longlong *)*plVar15;
          while (cVar3 == '\0') {
            cVar3 = *(char *)(*plVar15 + 0x19);
            plVar17 = plVar15;
            plVar15 = (longlong *)*plVar15;
          }
        }
        else {
          cVar3 = *(char *)(plVar17[1] + 0x19);
          plVar2 = (longlong *)plVar17[1];
          plVar15 = plVar17;
          while ((plVar17 = plVar2, cVar3 == '\0' && (plVar15 == (longlong *)plVar17[2]))) {
            cVar3 = *(char *)(plVar17[1] + 0x19);
            plVar2 = (longlong *)plVar17[1];
            plVar15 = plVar17;
          }
        }
      } while (plVar17 != *(longlong **)(local_680[0] + 0x168));
      puVar16 = (undefined1 *)CONCAT71(uStack_657,local_658);
      if (local_639 < 0x40) goto LAB_1400855c1;
    }
    plVar20 = (longlong *)(param_1 + 400);
    if (0x3f < *(byte *)(param_1 + 0x1af)) {
      plVar20 = (longlong *)*plVar20;
    }
    FUN_1400e0f60(local_620,"Surface lighting model \'%s\' not found. Available models: %s",plVar20,
                  puVar16);
    FUN_140089820(param_3,local_620,*(undefined4 *)(param_1 + 0x370),0,CONCAT44(uVar23,0x1c));
    uVar6 = FUN_14001b190(local_5d0,&DAT_14058331c,local_620);
    pcVar4 = (char *)FUN_14001ad10(local_5f8,uVar6,&DAT_140579664);
    if ((byte)pcVar4[0x1f] < 0x40) {
      lVar9 = 0x1f - (longlong)pcVar4[0x1f];
    }
    else {
      lVar9 = *(longlong *)(pcVar4 + 0x10);
      pcVar4 = *(char **)pcVar4;
    }
    if (lVar9 != 0) {
      if ((byte)param_2[0x1f] < 0x40) {
        lVar11 = 0x1f - (longlong)param_2[0x1f];
        uVar10 = 0x1f;
      }
      else {
        lVar11 = *(longlong *)(param_2 + 0x10);
        uVar10 = *(ulonglong *)(param_2 + 8);
      }
      uVar22 = lVar9 + lVar11;
      bVar1 = param_2[0x1f];
      if (uVar10 < uVar22) {
        uVar21 = uVar10 * 2;
        if (uVar10 * 2 <= uVar22) {
          uVar21 = uVar22;
        }
        pcVar8 = param_2;
        if (0x3f < bVar1) {
          pcVar8 = *(char **)param_2;
        }
        if (pcVar8 <= pcVar4) {
          if (bVar1 < 0x40) {
            lVar14 = 0x1f - (longlong)param_2[0x1f];
          }
          else {
            lVar14 = *(longlong *)(param_2 + 0x10);
          }
          if (pcVar4 < pcVar8 + lVar14) {
            pcVar7 = param_2;
            if (0x3f < bVar1) {
              pcVar7 = *(char **)param_2;
            }
            pcVar8 = (char *)FUN_140056c90(param_2,uVar21);
            pcVar4 = pcVar8 + ((longlong)pcVar4 - (longlong)pcVar7);
            goto LAB_140085733;
          }
        }
        pcVar8 = (char *)FUN_140056c90(param_2,uVar21);
      }
      else {
        pcVar8 = param_2;
        if (0x3f < bVar1) {
          pcVar8 = *(char **)param_2;
        }
      }
LAB_140085733:
      FUN_140558820(pcVar8 + lVar11,pcVar4,lVar9);
      pcVar8[uVar22] = '\0';
      if ((byte)param_2[0x1f] < 0x40) {
        param_2[0x1f] = '\x1f' - (char)uVar22;
      }
      else {
        *(ulonglong *)(param_2 + 0x10) = uVar22;
      }
    }
    if ((local_5d9 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(local_5f8[0],local_5d8,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    if ((local_5b1 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(local_5d0[0],local_5b0,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    if (puVar13 != (undefined8 *)0x0) {
      FUN_140067de0(puVar13 + 5);
      FUN_140065930(puVar13 + 3,puVar13 + 3,*(undefined8 *)(puVar13[3] + 8));
      thunk_FUN_1403f2404(puVar13[3],0x1f8);
      FUN_140067720(puVar13);
      thunk_FUN_1403f2404(puVar13,0x1a8);
    }
    if ((local_601 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(local_620[0],local_600,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    if ((local_639 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(uStack_657,local_658),local_638,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
  }
  else {
LAB_14008547a:
    if (local_689 < 0x40) {
      local_698 = 0x1f - (longlong)(char)local_689;
    }
    puVar16 = &local_6a8;
    if (0x3f < local_689) {
      puVar16 = (undefined1 *)CONCAT71(uStack_6a7,local_6a8);
    }
    FUN_1400543f0(param_2,puVar16,local_698);
    FUN_140086d80(param_4,puVar13);
LAB_140085c60:
    FUN_14006e6c0(puVar13);
  }
  if ((local_689 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_6a7,local_6a8),local_688,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  FUN_14000bd60(local_680 + 3,local_680 + 3,*(undefined8 *)(local_680[3] + 8));
  thunk_FUN_1403f2404(local_680[3],0x48);
  FUN_140067aa0(local_680);
LAB_140085cbf:
  _eh_vector_destructor_iterator_(local_138,0x20,8,FUN_140017b90);
  FUN_140018ba0(&local_158);
  FUN_140018ba0(local_188);
  FUN_140017b90(local_1a8);
  FUN_140017b90(local_1c8);
  FUN_140067fd0(local_5a8);
  FUN_14000b880(local_6b8,local_6b8,*(undefined8 *)(local_6b8[0] + 8));
  thunk_FUN_1403f2404(local_6b8[0],0x80);
  return;
}
```

## `FUN_140079e30` — `0x140079e30`

per-model pass emitter

```c
void FUN_140079e30(undefined8 param_1,longlong param_2,longlong param_3,longlong param_4)

{
  char cVar1;
  char cVar2;
  uint uVar3;
  int iVar4;
  longlong lVar5;
  undefined8 *puVar6;
  undefined1 *puVar7;
  undefined4 *puVar8;
  uint uVar9;
  char cVar10;
  undefined8 uVar11;
  char *pcVar12;
  int iVar13;
  longlong lVar14;
  undefined8 in_stack_fffffffffffffeb8;
  undefined4 uVar16;
  ulonglong uVar15;
  undefined1 local_138;
  undefined7 uStack_137;
  undefined8 local_128;
  byte local_119;
  undefined2 local_118;
  undefined1 local_110;
  undefined7 uStack_10f;
  longlong local_100;
  byte local_f1;
  undefined2 local_f0;
  undefined8 local_e8 [3];
  byte local_c9;
  undefined2 local_c8;
  undefined1 local_c0;
  undefined7 uStack_bf;
  longlong local_b0;
  byte local_a1;
  undefined2 local_a0;
  undefined8 local_98 [3];
  byte local_79;
  undefined2 local_78;
  undefined1 *local_70;
  longlong local_68;
  undefined8 local_60 [3];
  byte local_41;
  undefined2 local_40;
  
  uVar16 = (undefined4)((ulonglong)in_stack_fffffffffffffeb8 >> 0x20);
  GenerateSurfacePassHeader();
  cVar1 = FUN_140082570(param_2,param_3);
  cVar2 = FUN_140082620(param_2,param_3);
  if (((((*(char *)(param_4 + 0xc0) == '\0') || (*(char *)(param_4 + 0xcc) == '\0')) &&
       (*(char *)(param_4 + 0xc6) == '\0')) &&
      ((*(char *)(param_4 + 0xc3) == '\0' &&
       ((*(char *)(param_4 + 0xc0) == '\0' || (*(char *)(param_4 + 0xcc) == '\0')))))) &&
     (*(char *)(param_4 + 0xc5) == '\0')) {
    cVar10 = *(char *)(param_4 + 0xc4);
  }
  else {
    cVar10 = '\x01';
  }
  uVar9 = 0x29c;
  if (cVar10 == '\0') {
    uVar9 = 0x21c;
  }
  uVar3 = uVar9 | 0x100;
  if (*(char *)(param_4 + 0xcc) == '\0') {
    uVar3 = uVar9;
  }
  if (((*(char *)(param_4 + 200) != '\0') || (*(char *)(param_4 + 0xc3) != '\0')) || (cVar2 != '\0')
     ) {
    uVar3 = uVar3 | 0x20;
  }
  uVar9 = uVar3 | 0x400;
  if (cVar2 == '\0') {
    uVar9 = uVar3;
  }
  uVar15 = CONCAT44(uVar16,uVar9 >> 8) & 0xffffffff00000001;
  FUN_140074640(param_1,param_2,0,cVar2,uVar15,1);
  uVar16 = (undefined4)(uVar15 >> 0x20);
  FUN_140075dc0(param_1,param_2,param_3);
  cVar2 = FUN_140081f50(param_3 + 0x110);
  pcVar12 = "half2(0.0, 0.0)";
  if (cVar2 != '\0') {
    pcVar12 = "v.texcoord1.xy";
  }
  local_a0 = 0x4b;
  lVar14 = -1;
  do {
    lVar14 = lVar14 + 1;
  } while (pcVar12[lVar14] != '\0');
  local_c0 = 0;
  local_a1 = 0x1f;
  lVar5 = FUN_140056c90(&local_c0,lVar14);
  FUN_140558820(lVar5,pcVar12,lVar14);
  *(undefined1 *)(lVar5 + lVar14) = 0;
  if (local_a1 < 0x40) {
    local_a1 = 0x1f - (char)lVar14;
    lVar14 = local_b0;
  }
  local_b0 = lVar14;
  FUN_1400543f0(param_1,"\n// vertex-to-fragment interpolation data\n",0x2a);
  uVar3 = 0;
  uVar11 = CONCAT44(uVar16,uVar9);
  iVar4 = GenerateV2fStruct(param_1,param_2,param_3,param_4,uVar11,0);
  uVar16 = (undefined4)((ulonglong)uVar11 >> 0x20);
  iVar13 = iVar4 + 1;
  puVar6 = (undefined8 *)FUN_1400e0f60(&local_138,"  float4 lmap : TEXCOORD%i;\n",iVar4);
  if (*(byte *)((longlong)puVar6 + 0x1f) < 0x40) {
    lVar14 = 0x1f - (longlong)*(char *)((longlong)puVar6 + 0x1f);
  }
  else {
    lVar14 = puVar6[2];
    puVar6 = (undefined8 *)*puVar6;
  }
  FUN_1400543f0(param_1,puVar6,lVar14);
  if ((local_119 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_137,local_138),local_118,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  FUN_1400543f0(param_1,"#ifndef LIGHTMAP_ON\n",0x14);
  if (cVar1 == '\0') {
    if ((*(char *)(param_2 + 0x2bd) == '\0') && (*(char *)(param_2 + 0x2be) == '\0')) {
      uVar11 = FUN_1400e0f60(&local_138,"  float3 vlight : TEXCOORD%i; // ambient/SH\n",iVar13);
      FUN_14001b640(param_1,uVar11);
      if ((local_119 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(CONCAT71(uStack_137,local_138),local_118,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
    }
  }
  else {
    FUN_1400543f0(param_1,"  #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL\n",0x40);
    puVar6 = (undefined8 *)FUN_1400e0f60(&local_138,"    half3 sh : TEXCOORD%i; // SH\n",iVar13);
    if (*(byte *)((longlong)puVar6 + 0x1f) < 0x40) {
      lVar14 = 0x1f - (longlong)*(char *)((longlong)puVar6 + 0x1f);
    }
    else {
      lVar14 = puVar6[2];
      puVar6 = (undefined8 *)*puVar6;
    }
    FUN_1400543f0(param_1,puVar6,lVar14);
    if ((local_119 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(uStack_137,local_138),local_118,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    FUN_1400543f0(param_1,"  #endif\n",9);
  }
  FUN_1400543f0(param_1,"#else\n",6);
  FUN_1400543f0(param_1,"  #ifdef DIRLIGHTMAP_OFF\n",0x19);
  puVar6 = (undefined8 *)FUN_1400e0f60(&local_138,"    float4 lmapFadePos : TEXCOORD%i;\n",iVar13);
  if (*(byte *)((longlong)puVar6 + 0x1f) < 0x40) {
    lVar14 = 0x1f - (longlong)*(char *)((longlong)puVar6 + 0x1f);
  }
  else {
    lVar14 = puVar6[2];
    puVar6 = (undefined8 *)*puVar6;
  }
  FUN_1400543f0(param_1,puVar6,lVar14);
  if ((local_119 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_137,local_138),local_118,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  FUN_1400543f0(param_1,"  #endif\n",9);
  FUN_1400543f0(param_1,&DAT_14057b9a8,7);
  FUN_1400543f0(param_1,"  UNITY_VERTEX_INPUT_INSTANCE_ID\n",0x21);
  FUN_1400543f0(param_1,"  UNITY_VERTEX_OUTPUT_STEREO\n",0x1d);
  FUN_1400543f0(param_1,&DAT_140580da8,3);
  uVar11 = CONCAT44(uVar16,uVar9);
  FUN_140076c10(param_1,param_2,param_3,param_4,uVar11);
  uVar16 = (undefined4)((ulonglong)uVar11 >> 0x20);
  if (*(char *)(param_2 + 699) == '\0') {
    FUN_1400543f0(param_1,"#ifdef DYNAMICLIGHTMAP_ON\n",0x1a);
    FUN_1400543f0(param_1,
                  "  o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;\n"
                  ,0x58);
    FUN_1400543f0(param_1,"#else\n",6);
    FUN_1400543f0(param_1,"  o.lmap.zw = 0;\n",0x11);
    pcVar12 = "#endif\n";
    uVar11 = 7;
  }
  else {
    pcVar12 = "  o.lmap.zw = 0;\n";
    uVar11 = 0x11;
  }
  FUN_1400543f0(param_1,pcVar12,uVar11);
  FUN_1400543f0(param_1,"#ifdef LIGHTMAP_ON\n",0x13);
  puVar7 = &local_c0;
  if (0x3f < local_a1) {
    puVar7 = (undefined1 *)CONCAT71(uStack_bf,local_c0);
  }
  puVar6 = (undefined8 *)
           FUN_1400e0f60(&local_138,
                         "  o.lmap.xy = %s * unity_LightmapST.xy + unity_LightmapST.zw;\n",puVar7);
  if (*(byte *)((longlong)puVar6 + 0x1f) < 0x40) {
    lVar14 = 0x1f - (longlong)*(char *)((longlong)puVar6 + 0x1f);
  }
  else {
    lVar14 = puVar6[2];
    puVar6 = (undefined8 *)*puVar6;
  }
  FUN_1400543f0(param_1,puVar6,lVar14);
  if ((local_119 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_137,local_138),local_118,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  FUN_1400543f0(param_1,"  #ifdef DIRLIGHTMAP_OFF\n",0x19);
  FUN_1400543f0(param_1,
                "    o.lmapFadePos.xyz = (mul(unity_ObjectToWorld, v.vertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w;\n"
                ,0x88);
  FUN_1400543f0(param_1,
                "    o.lmapFadePos.w = (-UnityObjectToViewPos(v.vertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w);\n"
                ,0x65);
  FUN_1400543f0(param_1,"  #endif\n",9);
  FUN_1400543f0(param_1,"#else\n",6);
  FUN_1400543f0(param_1,"  o.lmap.xy = 0;\n",0x11);
  if (cVar1 == '\0') {
    if ((*(char *)(param_2 + 0x2bd) != '\0') || (*(char *)(param_2 + 0x2be) != '\0'))
    goto LAB_14007a4b1;
    if ((*(char *)(param_4 + 0xc1) == '\0') || ((uVar9 >> 8 & 1) != 0)) {
      FUN_1400543f0(param_1,"  fixed3 worldN = UnityObjectToWorldNormal(v.normal);\n",0x36);
      uVar11 = 0x2c;
      pcVar12 = "  o.vlight = ShadeSH9 (float4(worldN,1.0));\n";
    }
    else {
      uVar11 = 0x31;
      pcVar12 = "  o.vlight = ShadeSH9 (float4(worldNormal,1.0));\n";
    }
  }
  else {
    FUN_1400543f0(param_1,"    #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL\n",0x42
                 );
    FUN_1400543f0(param_1,"      o.sh = 0;\n",0x10);
    FUN_1400543f0(param_1,"      o.sh = ShadeSHPerVertex (worldNormal, o.sh);\n",0x33);
    uVar11 = 0xb;
    pcVar12 = "    #endif\n";
  }
  FUN_1400543f0(param_1,pcVar12,uVar11);
LAB_14007a4b1:
  FUN_1400543f0(param_1,&DAT_14057b9a8,7);
  FUN_1400543f0(param_1,"  return o;\n",0xc);
  FUN_1400543f0(param_1,&DAT_14057f1b0,2);
  FUN_140075430(param_1,param_2,param_3);
  FUN_1400543f0(param_1,"#ifdef LIGHTMAP_ON\n",0x13);
  FUN_1400543f0(param_1,"float4 unity_LightmapFade;\n",0x1b);
  FUN_1400543f0(param_1,&DAT_14057b9a8,7);
  FUN_1400543f0(param_1,"fixed4 unity_Ambient;\n",0x16);
  FUN_140071fe0(param_1,param_2,param_3,param_4,CONCAT44(uVar16,uVar9));
  FUN_1400543f0(param_1,"fixed3 originalNormal = o.Normal;\n",0x22);
  FUN_140074920(param_1,param_4);
  if (cVar1 != '\0') {
    FUN_1400543f0(param_1,"  half atten = 1;\n",0x12);
    FUN_14006f4b0(param_1,param_2,2,*(undefined1 *)(param_4 + 199));
  }
  FUN_1400543f0(param_1,"\n  // call lighting function to output g-buffer\n",0x30);
  local_f0 = 0x4b;
  local_110 = 0;
  local_f1 = 0x1f;
  puVar7 = (undefined1 *)FUN_140056c90(&local_110,0);
  *puVar7 = 0;
  if (local_f1 < 0x40) {
    local_f1 = 0x1f;
  }
  else {
    local_100 = 0;
  }
  if (cVar1 != '\0') {
    if (*(char *)(param_4 + 199) != '\0') {
      FUN_1400543f0(&local_110,", worldViewDir",0xe);
    }
    FUN_1400543f0(&local_110,&DAT_1405829ec,4);
  }
  local_68 = local_100;
  if (local_f1 < 0x40) {
    local_68 = 0x1f - (longlong)(char)local_f1;
  }
  local_70 = &local_110;
  if (0x3f < local_f1) {
    local_70 = (undefined1 *)CONCAT71(uStack_10f,local_110);
  }
  uVar11 = FUN_14001b190(local_e8,"  outEmission = Lighting",param_2 + 400);
  uVar11 = FUN_14001ad10(local_98,uVar11,"_Deferred (o");
  uVar11 = FUN_14001aaa0(local_60,uVar11,&local_70);
  puVar6 = (undefined8 *)
           FUN_14001ad10(&local_138,uVar11,", outGBuffer0, outGBuffer1, outGBuffer2);\n");
  if (*(byte *)((longlong)puVar6 + 0x1f) < 0x40) {
    lVar14 = 0x1f - (longlong)*(char *)((longlong)puVar6 + 0x1f);
  }
  else {
    lVar14 = puVar6[2];
    puVar6 = (undefined8 *)*puVar6;
  }
  FUN_1400543f0(param_1,puVar6,lVar14);
  if ((local_119 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_137,local_138),local_118,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  if ((local_41 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(local_60[0],local_40,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  if ((local_79 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(local_98[0],local_78,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  if ((local_c9 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(local_e8[0],local_c8,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  FUN_1400543f0(param_1,"  #if defined(SHADOWS_SHADOWMASK) && (UNITY_ALLOWED_MRT_COUNT > 4)\n",0x43)
  ;
  if (*(int *)(param_2 + 0x1b8) == 3) {
    pcVar12 = "    outShadowMask = 0;\n";
    uVar11 = 0x17;
  }
  else if ((char)uVar9 < '\0') {
    pcVar12 = "    outShadowMask = UnityGetRawBakedOcclusions (IN.lmap.xy, worldPos);\n";
    uVar11 = 0x47;
  }
  else {
    pcVar12 = "    outShadowMask = UnityGetRawBakedOcclusions (IN.lmap.xy, float3(0, 0, 0));\n";
    uVar11 = 0x4e;
  }
  FUN_1400543f0(param_1,pcVar12,uVar11);
  FUN_1400543f0(param_1,"  #endif\n",9);
  if (cVar1 == '\0') {
    FUN_1400543f0(param_1,"\n  // add lighting from lightmaps / vertex / ambient:\n",0x36);
    FUN_1400543f0(param_1,"  o.Normal = originalNormal;\n",0x1d);
    FUN_1400543f0(param_1,"  half3 light = 0;\n",0x13);
    FUN_1400543f0(param_1,"  #ifdef LIGHTMAP_ON\n",0x15);
    FUN_1400543f0(param_1,"    #ifdef DIRLIGHTMAP_OFF\n",0x1b);
    local_118 = 0x4b;
    local_138 = 0;
    local_119 = 0x1f;
    puVar8 = (undefined4 *)FUN_140056c90(&local_138,5);
    *puVar8 = 0x6867696c;
    *(undefined1 *)(puVar8 + 1) = 0x74;
    *(undefined1 *)((longlong)puVar8 + 5) = 0;
    if (local_119 < 0x40) {
      local_119 = 0x1a;
    }
    else {
      local_128 = 5;
    }
    puVar6 = (undefined8 *)
             FUN_140070470(local_e8,param_2,param_3,param_4,&local_138,uVar3 & 0xffffff00);
    if (*(byte *)((longlong)puVar6 + 0x1f) < 0x40) {
      lVar14 = 0x1f - (longlong)*(char *)((longlong)puVar6 + 0x1f);
    }
    else {
      lVar14 = puVar6[2];
      puVar6 = (undefined8 *)*puVar6;
    }
    FUN_1400543f0(param_1,puVar6,lVar14);
    if ((local_c9 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(local_e8[0],local_c8,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    FUN_1400543f0(param_1,"    #else\n",10);
    local_118 = 0x4b;
    local_138 = 0;
    local_119 = 0x1f;
    puVar8 = (undefined4 *)FUN_140056c90(&local_138,5);
    *puVar8 = 0x6867696c;
    *(undefined1 *)(puVar8 + 1) = 0x74;
    *(undefined1 *)((longlong)puVar8 + 5) = 0;
    if (local_119 < 0x40) {
      local_119 = 0x1a;
    }
    else {
      local_128 = 5;
    }
    puVar6 = (undefined8 *)FUN_14006f9e0(local_e8,param_2,param_3,param_4,&local_138,1);
    if (*(byte *)((longlong)puVar6 + 0x1f) < 0x40) {
      lVar14 = 0x1f - (longlong)*(char *)((longlong)puVar6 + 0x1f);
    }
    else {
      lVar14 = puVar6[2];
      puVar6 = (undefined8 *)*puVar6;
    }
    FUN_1400543f0(param_1,puVar6,lVar14);
    if ((local_c9 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(local_e8[0],local_c8,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    FUN_1400543f0(param_1,"    #endif\n",0xb);
    FUN_1400543f0(param_1,"  #else\n",8);
    if (*(char *)(param_2 + 0x2bd) == '\0') {
      if (*(char *)(param_2 + 0x2be) == '\0') {
        uVar11 = 0x1c;
        pcVar12 = "    light.rgb += IN.vlight;\n";
      }
      else {
        uVar11 = 0x24;
        pcVar12 = "    light.rgb += unity_Ambient.rgb;\n";
      }
      FUN_1400543f0(param_1,pcVar12,uVar11);
    }
    FUN_1400543f0(param_1,"  #endif\n\n",10);
    if (*(char *)(param_2 + 699) == '\0') {
      FUN_1400543f0(param_1,"  #ifdef DYNAMICLIGHTMAP_ON\n",0x1c);
      FUN_1400543f0(param_1,
                    "  fixed4 dynlmtex = UNITY_SAMPLE_TEX2D(unity_DynamicLightmap, IN.lmap.zw);\n",
                    0x4b);
      FUN_1400543f0(param_1,"  light.rgb += DecodeRealtimeLightmap (dynlmtex);\n",0x32);
      FUN_1400543f0(param_1,"  #endif\n\n",10);
    }
    FUN_1400543f0(param_1,"  outEmission.rgb += light * o.Albedo;\n",0x27);
  }
  FUN_1400543f0(param_1,"  #ifndef UNITY_HDR_ON\n",0x17);
  FUN_1400543f0(param_1,"  outEmission.rgb = exp2(-outEmission.rgb);\n",0x2c);
  FUN_1400543f0(param_1,"  #endif\n",9);
  if ((((((uVar9 >> 9 & 1) == 0) && (*(int *)(param_2 + 0x1b8) != 1)) &&
       (*(int *)(param_2 + 0x1b8) != 2)) &&
      ((*(int *)(param_2 + 0x1b8) != 4 && (*(char *)(param_2 + 0x2b8) == '\0')))) &&
     (*(char *)(param_3 + 0x17b) == '\0')) {
    FUN_1400543f0(param_1,"  UNITY_OPAQUE_ALPHA(outGBuffer0.a);\n",0x25);
  }
  if (*(byte *)(param_2 + 599) < 0x40) {
    lVar14 = 0x1f - (longlong)*(char *)(param_2 + 599);
  }
  else {
    lVar14 = *(longlong *)(param_2 + 0x248);
  }
  if (lVar14 != 0) {
    uVar11 = FUN_14001b190(local_98,&DAT_14057eed8,param_2 + 0x238);
    puVar6 = (undefined8 *)
             FUN_14001ad10(local_e8,uVar11,
                           " (surfIN, o, outGBuffer0, outGBuffer1, outGBuffer2, outEmission);\n");
    if (*(byte *)((longlong)puVar6 + 0x1f) < 0x40) {
      lVar14 = 0x1f - (longlong)*(char *)((longlong)puVar6 + 0x1f);
    }
    else {
      lVar14 = puVar6[2];
      puVar6 = (undefined8 *)*puVar6;
    }
    FUN_1400543f0(param_1,puVar6,lVar14);
    if ((local_c9 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(local_e8[0],local_c8,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    if ((local_79 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(local_98[0],local_78,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
  }
  FUN_1400543f0(param_1,&DAT_14057f1b0,2);
  if ((local_f1 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_10f,local_110),local_f0,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  if ((local_a1 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_bf,local_c0),local_a0,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  return;
}
```

## `FUN_14007b3c0` — `0x14007b3c0`

per-model pass emitter

```c
void FUN_14007b3c0(undefined8 param_1,longlong param_2,longlong param_3,longlong param_4)

{
  uint uVar1;
  undefined1 uVar2;
  char cVar3;
  char cVar4;
  int iVar5;
  longlong lVar6;
  undefined8 *puVar7;
  undefined2 *puVar8;
  undefined4 *puVar9;
  uint uVar10;
  undefined1 *puVar11;
  uint uVar12;
  longlong lVar13;
  char *pcVar14;
  undefined8 in_stack_ffffffffffffff18;
  undefined4 uVar17;
  undefined8 uVar15;
  ulonglong uVar16;
  undefined1 local_d8;
  undefined7 uStack_d7;
  undefined8 local_c8;
  byte local_b9;
  undefined2 local_b8;
  undefined1 local_b0;
  undefined7 uStack_af;
  longlong local_a0;
  byte local_91;
  undefined2 local_90;
  undefined1 local_88;
  undefined7 uStack_87;
  undefined8 local_78;
  byte local_69;
  undefined2 local_68;
  undefined1 local_60;
  undefined7 uStack_5f;
  longlong local_50;
  byte local_41;
  undefined2 local_40;
  
  uVar17 = (undefined4)((ulonglong)in_stack_ffffffffffffff18 >> 0x20);
  GenerateSurfacePassHeader();
  if ((*(char *)(param_2 + 0x2c8) == '\0') ||
     ((((*(char *)(param_4 + 0xc0) == '\0' || (*(char *)(param_4 + 0xcc) == '\0')) &&
       (*(char *)(param_4 + 199) == '\0')) && (*(char *)(param_4 + 0xc5) == '\0')))) {
    uVar12 = 0x94;
  }
  else {
    uVar12 = 0xd4;
  }
  uVar1 = uVar12 | 0x100;
  if (*(char *)(param_4 + 0xcc) == '\0') {
    uVar1 = uVar12;
  }
  uVar2 = FUN_140082620(param_2,param_3);
  cVar3 = FUN_140082570(param_2,param_3);
  uVar15 = CONCAT44(uVar17,uVar1 >> 8);
  FUN_140074640(param_1,param_2,1,uVar2,uVar15,1);
  uVar17 = (undefined4)((ulonglong)uVar15 >> 0x20);
  FUN_140075dc0(param_1,param_2,param_3);
  cVar4 = FUN_140081f50(param_3 + 0x110);
  pcVar14 = "half2(0.0, 0.0)";
  if (cVar4 != '\0') {
    pcVar14 = "v.texcoord1.xy";
  }
  local_90 = 0x4b;
  lVar13 = -1;
  do {
    lVar13 = lVar13 + 1;
  } while (pcVar14[lVar13] != '\0');
  local_b0 = 0;
  local_91 = 0x1f;
  lVar6 = FUN_140056c90(&local_b0,lVar13);
  FUN_140558820(lVar6,pcVar14,lVar13);
  *(undefined1 *)(lVar6 + lVar13) = 0;
  if (local_91 < 0x40) {
    local_91 = 0x1f - (char)lVar13;
    lVar13 = local_a0;
  }
  local_a0 = lVar13;
  FUN_1400543f0(param_1,"\n// vertex-to-fragment interpolation data\n",0x2a);
  local_40 = 0x4b;
  local_60 = 0;
  local_41 = 0x1f;
  uVar15 = CONCAT44(uVar17,uVar1);
  iVar5 = FUN_14007b990(&local_60,param_2,param_3,param_4,uVar15);
  uVar17 = (undefined4)((ulonglong)uVar15 >> 0x20);
  uVar12 = uVar1;
  if (uVar1 >> 8 != 0) {
    uVar16 = *(ulonglong *)(param_2 + 0x348);
    if (((byte)uVar16 >> 2 & 1) == 0) {
      if (((uint)uVar16 & 0x1feb) == 0x1feb) {
        uVar10 = 0x20;
      }
      else if ((uVar16 >> 9 & 1) == 0) {
        uVar10 = (uint)uVar16 & 2 | 8;
      }
      else {
        uVar10 = 0xf;
      }
    }
    else {
      uVar10 = 0x20;
    }
    if (iVar5 < (int)uVar10) {
      uVar12 = uVar1 | 0x800;
      uVar16 = CONCAT44(uVar17,uVar1) | 0x800;
      FUN_14007b990(&local_60,param_2,param_3,param_4,uVar16);
      uVar17 = (undefined4)(uVar16 >> 0x20);
    }
  }
  if (local_41 < 0x40) {
    local_50 = 0x1f - (longlong)(char)local_41;
  }
  puVar11 = &local_60;
  if (0x3f < local_41) {
    puVar11 = (undefined1 *)CONCAT71(uStack_5f,local_60);
  }
  FUN_1400543f0(param_1,puVar11,local_50);
  FUN_1400543f0(param_1,&DAT_140580da8,3);
  uVar15 = CONCAT44(uVar17,uVar12);
  FUN_140076c10(param_1,param_2,param_3,param_4,uVar15);
  uVar17 = (undefined4)((ulonglong)uVar15 >> 0x20);
  FUN_1400543f0(param_1,&DAT_140579664,1);
  if (*(char *)(param_2 + 0x2b5) == '\0') {
    puVar11 = &local_b0;
    if (0x3f < local_91) {
      puVar11 = (undefined1 *)CONCAT71(uStack_af,local_b0);
    }
    puVar7 = (undefined8 *)
             FUN_1400e0f60(&local_88,
                           "  UNITY_TRANSFER_LIGHTING(o,%s); // pass shadow and, possibly, light cookie coordinates to pixel shader\n"
                           ,puVar11);
    if (*(byte *)((longlong)puVar7 + 0x1f) < 0x40) {
      lVar13 = 0x1f - (longlong)*(char *)((longlong)puVar7 + 0x1f);
    }
    else {
      lVar13 = puVar7[2];
      puVar7 = (undefined8 *)*puVar7;
    }
    FUN_1400543f0(param_1,puVar7,lVar13);
    if ((local_69 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(uStack_87,local_88),local_68,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
  }
  else {
    FUN_1400543f0(param_1,
                  "  COMPUTE_LIGHT_COORDS(o); // pass light cookie coordinates to pixel shader\n",
                  0x4c);
  }
  if (*(char *)(param_2 + 0x2b6) == '\0') {
    if (*(byte *)(param_2 + 0x207) < 0x40) {
      lVar13 = 0x1f - (longlong)*(char *)(param_2 + 0x207);
    }
    else {
      lVar13 = *(longlong *)(param_2 + 0x1f8);
    }
    if (lVar13 == 0) {
      FUN_1400543f0(param_1,
                    "  UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader\n",0x47)
      ;
    }
  }
  FUN_1400543f0(param_1,"  return o;\n",0xc);
  FUN_1400543f0(param_1,&DAT_14057f1b0,2);
  FUN_140075430(param_1,param_2,param_3);
  FUN_140071fe0(param_1,param_2,param_3,param_4,CONCAT44(uVar17,uVar12));
  FUN_1400543f0(param_1,"  UNITY_LIGHT_ATTENUATION(atten, IN, worldPos)\n",0x2f);
  FUN_1400543f0(param_1,"  fixed4 c = 0;\n",0x10);
  FUN_140074920(param_1,param_4);
  if (cVar3 == '\0') {
    local_b8 = 0x4b;
    local_d8 = 0;
    local_b9 = 0x1f;
    puVar9 = (undefined4 *)FUN_140056c90(&local_d8,5);
    *puVar9 = 0x65747461;
    *(undefined1 *)(puVar9 + 1) = 0x6e;
    *(undefined1 *)((longlong)puVar9 + 5) = 0;
    if (local_b9 < 0x40) {
      local_b9 = 0x1a;
    }
    else {
      local_c8 = 5;
    }
    local_68 = 0x4b;
    local_69 = 0x1f;
    local_88 = 0;
    puVar8 = (undefined2 *)FUN_140056c90(&local_88,1);
    *puVar8 = 99;
    if (local_69 < 0x40) {
      local_69 = 0x1e;
    }
    else {
      local_78 = 1;
    }
    FUN_1400717c0(param_1,param_2,param_4,&local_88,&local_d8);
  }
  else {
    FUN_14006f4b0(param_1,param_2,1,*(undefined1 *)(param_4 + 199));
    FUN_1400543f0(param_1,"  gi.light.color *= atten;\n",0x1b);
    local_b8 = 0x4b;
    local_d8 = 0;
    local_b9 = 0x1f;
    puVar8 = (undefined2 *)FUN_140056c90(&local_d8,1);
    *puVar8 = 99;
    if (local_b9 < 0x40) {
      local_b9 = 0x1e;
    }
    else {
      local_c8 = 1;
    }
    FUN_140071c50(param_1,param_2,param_4,&local_d8);
    if ((local_b9 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(uStack_d7,local_d8),local_b8,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
  }
  if (((*(int *)(param_2 + 0x1b8) != 1) && (*(int *)(param_2 + 0x1b8) != 2)) &&
     ((*(int *)(param_2 + 0x1b8) != 4 && (*(char *)(param_2 + 0x2b8) == '\0')))) {
    FUN_1400543f0(param_1,"  c.a = 0.0;\n",0xd);
  }
  FUN_140071600(param_1,param_2);
  if ((local_41 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_5f,local_60),local_40,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  if ((local_91 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_af,local_b0),local_90,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  return;
}
```

## `FUN_14007c5c0` — `0x14007c5c0`

per-model pass emitter

```c
/* WARNING: Type propagation algorithm not settling */

undefined8
FUN_14007c5c0(undefined8 param_1,longlong param_2,longlong param_3,longlong param_4,
             longlong *param_5,undefined8 param_6)

{
  bool bVar1;
  char cVar2;
  undefined1 uVar3;
  char cVar4;
  int iVar5;
  undefined8 *puVar6;
  undefined2 *puVar7;
  undefined8 *puVar8;
  undefined1 *puVar9;
  char *pcVar10;
  ulonglong uVar11;
  int iVar12;
  int iVar13;
  int iVar14;
  uint uVar15;
  longlong lVar16;
  undefined8 uVar17;
  ulonglong uVar18;
  ulonglong uVar19;
  uint uVar20;
  ulonglong uVar21;
  ulonglong local_res18;
  undefined8 in_stack_fffffffffffffea8;
  undefined4 uVar22;
  undefined1 local_140;
  undefined7 uStack_13f;
  byte local_121;
  undefined2 local_120;
  uint local_118;
  int local_114;
  uint local_110;
  int local_10c;
  ulonglong local_108;
  undefined1 local_100;
  undefined7 uStack_ff;
  longlong local_f0;
  byte local_e1;
  undefined2 local_e0;
  undefined8 local_d8;
  ulonglong local_d0;
  ulonglong local_c8;
  byte local_b9;
  undefined2 local_b8;
  int local_b0;
  undefined1 local_a8;
  undefined7 uStack_a7;
  undefined8 local_98;
  byte local_89;
  undefined2 local_88;
  uint local_80;
  int local_7c;
  undefined1 local_78;
  undefined7 uStack_77;
  byte local_59;
  undefined2 local_58;
  
  local_118 = 0;
  GenerateSurfacePassHeader();
  local_e0 = 0x4b;
  local_100 = 0;
  local_e1 = 0x1f;
  if ((*(char *)(param_2 + 0x2c8) == '\0') ||
     ((((*(char *)(param_4 + 0xc0) == '\0' || (*(char *)(param_4 + 0xcc) == '\0')) &&
       (*(char *)(param_4 + 199) == '\0')) && (*(char *)(param_4 + 0xc5) == '\0')))) {
    uVar15 = 0x9e;
  }
  else {
    uVar15 = 0xde;
  }
  uVar20 = uVar15 | 0x100;
  if (*(char *)(param_4 + 0xcc) == '\0') {
    uVar20 = uVar15;
  }
  local_118 = uVar20;
  cVar2 = FUN_140082570(param_2,param_3);
  uVar3 = FUN_140082620(param_2,param_3);
  cVar4 = FUN_140081f50(param_3 + 0x110);
  pcVar10 = "half2(0.0, 0.0)";
  if (cVar4 != '\0') {
    pcVar10 = "v.texcoord1.xy";
  }
  local_58 = 0x4b;
  local_78 = 0;
  local_59 = 0x1f;
  lVar16 = -1;
  do {
    lVar16 = lVar16 + 1;
  } while (pcVar10[lVar16] != '\0');
  FUN_140054780(&local_78);
  local_114 = 0;
  do {
    iVar13 = local_114;
    iVar14 = 0;
    pcVar10 = "// no lightmaps:\n#ifndef LIGHTMAP_ON\n";
    if (local_114 != 0) {
      pcVar10 = "// with lightmaps:\n#ifdef LIGHTMAP_ON\n";
    }
    FUN_1400543f0(&local_100,pcVar10,(local_114 != 0) + '%');
    local_108 = local_108 & 0xffffffff00000000;
    do {
      uVar22 = (undefined4)((ulonglong)in_stack_fffffffffffffea8 >> 0x20);
      pcVar10 = 
      "// half-precision fragment shader registers:\n#ifdef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS\n"
      ;
      if (iVar14 != 0) {
        pcVar10 = 
        "// high-precision fragment shader registers:\n#ifndef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS\n"
        ;
      }
      FUN_1400543f0(&local_100,pcVar10,(iVar14 != 0) + 'c');
      bVar1 = false;
      if ((iVar14 == 0) && (*(char *)(param_2 + 0x2b6) == '\0')) {
        if (*(byte *)(param_2 + 0x207) < 0x40) {
          lVar16 = 0x1f - (longlong)*(char *)(param_2 + 0x207);
        }
        else {
          lVar16 = *(longlong *)(param_2 + 0x1f8);
        }
        if (lVar16 == 0) {
          bVar1 = true;
          if (*(char *)(param_4 + 0xcc) == '\0') {
            uVar20 = uVar20 | 0x4000;
          }
          else {
            uVar20 = uVar20 | 0x2000;
          }
        }
      }
      in_stack_fffffffffffffea8 = CONCAT44(uVar22,uVar20);
      iVar5 = GenerateV2fStruct(&local_100,param_2,param_3,param_4,in_stack_fffffffffffffea8,0);
      if (iVar13 == 0) {
        if (cVar2 == '\0') {
          iVar13 = iVar5;
          if (*(char *)(param_2 + 0x2be) == '\0') {
            iVar13 = iVar5 + 1;
            puVar6 = (undefined8 *)
                     FUN_1400e0f60(&local_140,
                                   "  fixed3 vlight : TEXCOORD%i; // ambient/SH/vertexlights\n",
                                   iVar5);
            if (*(byte *)((longlong)puVar6 + 0x1f) < 0x40) {
              lVar16 = 0x1f - (longlong)*(char *)((longlong)puVar6 + 0x1f);
            }
            else {
              lVar16 = puVar6[2];
              puVar6 = (undefined8 *)*puVar6;
            }
            FUN_1400543f0(&local_100,puVar6,lVar16);
            if ((local_121 & 0xc0) == 0x40) {
              thunk_FUN_1403f2404(CONCAT71(uStack_13f,local_140),local_120,
                                  "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                  ,0x218);
            }
          }
        }
        else {
          FUN_1400543f0(&local_100,"  #if UNITY_SHOULD_SAMPLE_SH\n",0x1d);
          puVar6 = (undefined8 *)FUN_1400e0f60(&local_140,"  half3 sh : TEXCOORD%i; // SH\n",iVar5);
          if (*(byte *)((longlong)puVar6 + 0x1f) < 0x40) {
            lVar16 = 0x1f - (longlong)*(char *)((longlong)puVar6 + 0x1f);
          }
          else {
            lVar16 = puVar6[2];
            puVar6 = (undefined8 *)*puVar6;
          }
          FUN_1400543f0(&local_100,puVar6,lVar16);
          if ((local_121 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_13f,local_140),local_120,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          FUN_1400543f0(&local_100,"  #endif\n",9);
          iVar13 = iVar5 + 1;
        }
      }
      else {
        iVar12 = iVar5;
        if (*(char *)(param_2 + 0x2c6) != '\0') {
          iVar12 = iVar5 + 1;
          puVar6 = (undefined8 *)
                   FUN_1400e0f60(&local_140,"  float4 lmapFadePos : TEXCOORD%i;\n",iVar5);
          if (*(byte *)((longlong)puVar6 + 0x1f) < 0x40) {
            lVar16 = 0x1f - (longlong)*(char *)((longlong)puVar6 + 0x1f);
          }
          else {
            lVar16 = puVar6[2];
            puVar6 = (undefined8 *)*puVar6;
          }
          FUN_1400543f0(&local_100,puVar6,lVar16);
          if ((local_121 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_13f,local_140),local_120,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
        }
        iVar13 = iVar12 + 1;
        puVar6 = (undefined8 *)FUN_1400e0f60(&local_140,"  float4 lmap : TEXCOORD%i;\n",iVar12);
        if (*(byte *)((longlong)puVar6 + 0x1f) < 0x40) {
          lVar16 = 0x1f - (longlong)*(char *)((longlong)puVar6 + 0x1f);
        }
        else {
          lVar16 = puVar6[2];
          puVar6 = (undefined8 *)*puVar6;
        }
        FUN_1400543f0(&local_100,puVar6,lVar16);
        if ((local_121 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(CONCAT71(uStack_13f,local_140),local_120,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
        }
      }
      iVar5 = iVar13;
      if (*(char *)(param_2 + 0x2b6) == '\0') {
        if (*(byte *)(param_2 + 0x207) < 0x40) {
          lVar16 = 0x1f - (longlong)*(char *)(param_2 + 0x207);
        }
        else {
          lVar16 = *(longlong *)(param_2 + 0x1f8);
        }
        if ((lVar16 == 0) && (!bVar1)) {
          iVar5 = iVar13 + 1;
          puVar6 = (undefined8 *)FUN_1400e0f60(&local_140,"  UNITY_FOG_COORDS(%i)\n",iVar13);
          if (*(byte *)((longlong)puVar6 + 0x1f) < 0x40) {
            lVar16 = 0x1f - (longlong)*(char *)((longlong)puVar6 + 0x1f);
          }
          else {
            lVar16 = puVar6[2];
            puVar6 = (undefined8 *)*puVar6;
          }
          FUN_1400543f0(&local_100,puVar6,lVar16);
          if ((local_121 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_13f,local_140),local_120,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
        }
      }
      iVar13 = iVar5 + 1;
      local_10c = iVar13;
      if (*(char *)(param_2 + 0x2b5) == '\0') {
        if (iVar14 == 0) {
          iVar14 = iVar5 + 2;
          local_10c = iVar14;
          puVar6 = (undefined8 *)
                   FUN_1400e0f60(&local_140,"  UNITY_LIGHTING_COORDS(%i,%i)\n",iVar5,iVar13);
          if (*(byte *)((longlong)puVar6 + 0x1f) < 0x40) {
            lVar16 = 0x1f - (longlong)*(char *)((longlong)puVar6 + 0x1f);
          }
          else {
            lVar16 = puVar6[2];
            puVar6 = (undefined8 *)*puVar6;
          }
          FUN_1400543f0(&local_100,puVar6,lVar16);
          iVar13 = iVar14;
          if ((local_121 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_13f,local_140),local_120,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
        }
        else {
          puVar6 = (undefined8 *)FUN_1400e0f60(&local_140,"  UNITY_SHADOW_COORDS(%i)\n",iVar5);
          if (*(byte *)((longlong)puVar6 + 0x1f) < 0x40) {
            lVar16 = 0x1f - (longlong)*(char *)((longlong)puVar6 + 0x1f);
          }
          else {
            lVar16 = puVar6[2];
            puVar6 = (undefined8 *)*puVar6;
          }
          FUN_1400543f0(&local_100,puVar6,lVar16);
          if ((local_121 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_13f,local_140),local_120,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
        }
      }
      else {
        puVar6 = (undefined8 *)FUN_1400e0f60(&local_140,"  DECLARE_LIGHT_COORDS(%i)\n",iVar5);
        if (*(byte *)((longlong)puVar6 + 0x1f) < 0x40) {
          lVar16 = 0x1f - (longlong)*(char *)((longlong)puVar6 + 0x1f);
        }
        else {
          lVar16 = puVar6[2];
          puVar6 = (undefined8 *)*puVar6;
        }
        FUN_1400543f0(&local_100,puVar6,lVar16);
        if ((local_121 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(CONCAT71(uStack_13f,local_140),local_120,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
        }
      }
      iVar14 = local_114;
      if ((local_114 == 0) && (*(char *)(param_2 + 699) == '\0')) {
        puVar6 = (undefined8 *)
                 FUN_1400e0f60(&local_140,
                               "  #if SHADER_TARGET >= 30\n  float4 lmap : TEXCOORD%i;\n  #endif\n",
                               iVar13);
        if (*(byte *)((longlong)puVar6 + 0x1f) < 0x40) {
          lVar16 = 0x1f - (longlong)*(char *)((longlong)puVar6 + 0x1f);
        }
        else {
          lVar16 = puVar6[2];
          puVar6 = (undefined8 *)*puVar6;
        }
        FUN_1400543f0(&local_100,puVar6,lVar16);
        if ((local_121 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(CONCAT71(uStack_13f,local_140),local_120,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
        }
        if ((*(byte *)(param_2 + 0x348) >> 1 & 1) != 0) {
          iVar13 = iVar13 + 1;
          local_10c = iVar13;
        }
      }
      iVar5 = 0;
      local_b0 = 0;
      if (((((int)local_108 != 0) && (iVar14 != 0)) && (*(char *)(param_2 + 0x2b9) == '\0')) &&
         ((*(char *)(param_2 + 0x2ba) == '\0' && ((uVar20 >> 8 & 1) == 0)))) {
        puVar6 = (undefined8 *)FUN_1400e0f60(&local_140,"  #ifdef DIRLIGHTMAP_COMBINED\n");
        if (*(byte *)((longlong)puVar6 + 0x1f) < 0x40) {
          lVar16 = 0x1f - (longlong)*(char *)((longlong)puVar6 + 0x1f);
        }
        else {
          lVar16 = puVar6[2];
          puVar6 = (undefined8 *)*puVar6;
        }
        FUN_1400543f0(&local_100,puVar6,lVar16);
        if ((local_121 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(CONCAT71(uStack_13f,local_140),local_120,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
        }
        iVar5 = FUN_1400752a0(&local_100,iVar13,0,0);
        iVar5 = iVar5 - iVar13;
        local_b0 = iVar5;
        puVar6 = (undefined8 *)FUN_1400e0f60(&local_140,"  #endif\n");
        if (*(byte *)((longlong)puVar6 + 0x1f) < 0x40) {
          lVar16 = 0x1f - (longlong)*(char *)((longlong)puVar6 + 0x1f);
        }
        else {
          lVar16 = puVar6[2];
          puVar6 = (undefined8 *)*puVar6;
        }
        FUN_1400543f0(&local_100,puVar6,lVar16);
        if ((local_121 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(CONCAT71(uStack_13f,local_140),local_120,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
        }
      }
      FUN_1400543f0(&local_100,"  UNITY_VERTEX_INPUT_INSTANCE_ID\n",0x21);
      FUN_1400543f0(&local_100,"  UNITY_VERTEX_OUTPUT_STEREO\n",0x1d);
      FUN_1400543f0(&local_100,&DAT_140580da8,3);
      uVar21 = *(ulonglong *)(param_2 + 0x348);
      if (((byte)uVar21 >> 2 & 1) == 0) {
        if (((uint)uVar21 & 0x1feb) == 0x1feb) {
          uVar15 = 0x20;
        }
        else if ((uVar21 >> 9 & 1) == 0) {
          uVar15 = (uint)uVar21 & 2 | 8;
        }
        else {
          uVar15 = 0xf;
        }
      }
      else {
        uVar15 = 0x20;
      }
      uVar20 = 10;
      if (10 < uVar15) {
        uVar20 = uVar15;
      }
      iVar14 = iVar5 + iVar13;
      local_110 = uVar15;
      local_80 = uVar20;
      local_7c = iVar14;
      if (((int)uVar15 < iVar13) || ((int)uVar20 < iVar14)) {
        FUN_140054780(param_1,
                      "// Too many texture interpolators would be used for ForwardBase pass:\n",0x46
                     );
        if (param_5[2] == 0) goto LAB_14007dd67;
        FUN_1400543f0(param_1,"// For a keyword variant:",0x19);
        local_res18 = 0;
        if (param_5[2] == 0) goto LAB_14007dd4a;
        local_108 = 0;
        goto LAB_14007dae0;
      }
      FUN_1400543f0(&local_100,&DAT_14057b9a8,7);
      iVar13 = local_114;
      uVar20 = local_118;
      iVar14 = (int)local_108 + 1;
      local_108 = CONCAT44(local_108._4_4_,iVar14);
    } while (iVar14 < 2);
    FUN_1400543f0(&local_100,&DAT_14057b9a8,7);
    local_114 = iVar13 + 1;
  } while (local_114 < 2);
  uVar17 = CONCAT44((int)((ulonglong)in_stack_fffffffffffffea8 >> 0x20),uVar20 >> 8);
  FUN_140074640(param_1,param_2,1,uVar3,uVar17,1);
  uVar22 = (undefined4)((ulonglong)uVar17 >> 0x20);
  FUN_140075dc0(param_1,param_2,param_3);
  FUN_1400543f0(param_1,"\n// vertex-to-fragment interpolation data\n",0x2a);
  if (local_e1 < 0x40) {
    local_f0 = 0x1f - (longlong)(char)local_e1;
  }
  puVar9 = &local_100;
  if (0x3f < local_e1) {
    puVar9 = (undefined1 *)CONCAT71(uStack_ff,local_100);
  }
  FUN_1400543f0(param_1,puVar9,local_f0);
  uVar17 = CONCAT44(uVar22,uVar20);
  FUN_140076c10(param_1,param_2,param_3,param_4,uVar17);
  uVar22 = (undefined4)((ulonglong)uVar17 >> 0x20);
  if (*(char *)(param_2 + 699) == '\0') {
    FUN_1400543f0(param_1,"  #ifdef DYNAMICLIGHTMAP_ON\n",0x1c);
    FUN_1400543f0(param_1,
                  "  o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;\n"
                  ,0x58);
    FUN_1400543f0(param_1,"  #endif\n",9);
  }
  FUN_1400543f0(param_1,"  #ifdef LIGHTMAP_ON\n",0x15);
  puVar9 = &local_78;
  if (0x3f < local_59) {
    puVar9 = (undefined1 *)CONCAT71(uStack_77,local_78);
  }
  puVar6 = (undefined8 *)
           FUN_1400e0f60(&local_140,
                         "  o.lmap.xy = %s * unity_LightmapST.xy + unity_LightmapST.zw;\n",puVar9);
  if (*(byte *)((longlong)puVar6 + 0x1f) < 0x40) {
    lVar16 = 0x1f - (longlong)*(char *)((longlong)puVar6 + 0x1f);
  }
  else {
    lVar16 = puVar6[2];
    puVar6 = (undefined8 *)*puVar6;
  }
  FUN_1400543f0(param_1,puVar6,lVar16);
  if ((local_121 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_13f,local_140),local_120,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  if (*(char *)(param_2 + 0x2c6) != '\0') {
    FUN_1400543f0(param_1,
                  "  o.lmapFadePos.xyz = (mul(unity_ObjectToWorld, v.vertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w;\n"
                  ,0x86);
    FUN_1400543f0(param_1,
                  "  o.lmapFadePos.w = (-UnityObjectToViewPos(v.vertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w);\n"
                  ,99);
  }
  FUN_1400543f0(param_1,"  #endif\n",9);
  FUN_1400543f0(param_1,"\n  // SH/ambient and vertex lights\n",0x23);
  FUN_1400543f0(param_1,"  #ifndef LIGHTMAP_ON\n",0x16);
  if (cVar2 == '\0') {
    if (*(char *)(param_2 + 0x2be) == '\0') {
      if (*(char *)(param_2 + 0x2bd) == '\0') {
        FUN_1400543f0(param_1,"  #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL\n",
                      0x40);
        FUN_1400543f0(param_1,"  float3 shlight = ShadeSH9 (float4(worldNormal,1.0));\n",0x37);
        FUN_1400543f0(param_1,"  o.vlight = shlight;\n",0x16);
        FUN_1400543f0(param_1,"  #else\n",8);
        FUN_1400543f0(param_1,"  o.vlight = 0.0;\n",0x12);
        pcVar10 = "  #endif\n";
        uVar17 = 9;
      }
      else {
        pcVar10 = "  o.vlight = 0.0;\n";
        uVar17 = 0x12;
      }
      FUN_1400543f0(param_1,pcVar10,uVar17);
      FUN_1400543f0(param_1,"  #ifdef VERTEXLIGHT_ON\n",0x18);
      FUN_1400543f0(param_1,"  o.vlight += Shade4PointLights (\n",0x22);
      FUN_1400543f0(param_1,"    unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,\n",0x3d);
      FUN_1400543f0(param_1,
                    "    unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,\n"
                    ,0x68);
      FUN_1400543f0(param_1,"    unity_4LightAtten0, worldPos, worldNormal );\n",0x31);
      uVar17 = 0x1b;
      pcVar10 = "  #endif // VERTEXLIGHT_ON\n";
      goto LAB_14007d269;
    }
  }
  else {
    FUN_1400543f0(param_1,"    #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL\n",0x42
                 );
    FUN_1400543f0(param_1,"      o.sh = 0;\n",0x10);
    FUN_1400543f0(param_1,"      // Approximated illumination from non-important point lights\n",
                  0x43);
    FUN_1400543f0(param_1,"      #ifdef VERTEXLIGHT_ON\n",0x1c);
    FUN_1400543f0(param_1,"        o.sh += Shade4PointLights (\n",0x24);
    FUN_1400543f0(param_1,"          unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,\n",
                  0x43);
    FUN_1400543f0(param_1,
                  "          unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,\n"
                  ,0x6e);
    FUN_1400543f0(param_1,"          unity_4LightAtten0, worldPos, worldNormal);\n",0x36);
    FUN_1400543f0(param_1,"      #endif\n",0xd);
    FUN_1400543f0(param_1,"      o.sh = ShadeSHPerVertex (worldNormal, o.sh);\n",0x33);
    uVar17 = 0xb;
    pcVar10 = "    #endif\n";
LAB_14007d269:
    FUN_1400543f0(param_1,pcVar10,uVar17);
  }
  FUN_1400543f0(param_1,"  #endif // !LIGHTMAP_ON\n\n",0x1a);
  if (*(char *)(param_2 + 0x2b5) == '\0') {
    puVar9 = &local_78;
    if (0x3f < local_59) {
      puVar9 = (undefined1 *)CONCAT71(uStack_77,local_78);
    }
    puVar6 = (undefined8 *)
             FUN_1400e0f60(&local_140,
                           "  UNITY_TRANSFER_LIGHTING(o,%s); // pass shadow and, possibly, light cookie coordinates to pixel shader\n"
                           ,puVar9);
    if (*(byte *)((longlong)puVar6 + 0x1f) < 0x40) {
      lVar16 = 0x1f - (longlong)*(char *)((longlong)puVar6 + 0x1f);
    }
    else {
      lVar16 = puVar6[2];
      puVar6 = (undefined8 *)*puVar6;
    }
    FUN_1400543f0(param_1,puVar6,lVar16);
    if ((local_121 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(uStack_13f,local_140),local_120,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
  }
  else {
    FUN_1400543f0(param_1,
                  "  COMPUTE_LIGHT_COORDS(o); // pass light cookie coordinates to pixel shader\n",
                  0x4c);
  }
  if (*(char *)(param_2 + 0x2b6) == '\0') {
    if (*(byte *)(param_2 + 0x207) < 0x40) {
      lVar16 = 0x1f - (longlong)*(char *)(param_2 + 0x207);
    }
    else {
      lVar16 = *(longlong *)(param_2 + 0x1f8);
    }
    if (lVar16 == 0) {
      FUN_1400543f0(param_1,"  #ifdef FOG_COMBINED_WITH_TSPACE\n",0x22);
      FUN_1400543f0(param_1,
                    "    UNITY_TRANSFER_FOG_COMBINED_WITH_TSPACE(o,o.pos); // pass fog coordinates to pixel shader\n"
                    ,0x5e);
      FUN_1400543f0(param_1,"  #elif defined FOG_COMBINED_WITH_WORLD_POS\n",0x2c);
      FUN_1400543f0(param_1,
                    "    UNITY_TRANSFER_FOG_COMBINED_WITH_WORLD_POS(o,o.pos); // pass fog coordinates to pixel shader\n"
                    ,0x61);
      FUN_1400543f0(param_1,"  #else\n",8);
      FUN_1400543f0(param_1,
                    "    UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader\n",
                    0x49);
      FUN_1400543f0(param_1,"  #endif\n",9);
    }
  }
  FUN_1400543f0(param_1,"  return o;\n",0xc);
  FUN_1400543f0(param_1,&DAT_14057f1b0,2);
  FUN_140075430(param_1,param_2,param_3);
  if (*(char *)(param_2 + 0x2c6) != '\0') {
    FUN_1400543f0(param_1,"#ifdef LIGHTMAP_ON\n",0x13);
    FUN_1400543f0(param_1,"float4 unity_LightmapFade;\n",0x1b);
    FUN_1400543f0(param_1,&DAT_14057b9a8,7);
  }
  FUN_140071fe0(param_1,param_2,param_3,param_4,CONCAT44(uVar22,uVar20));
  FUN_1400543f0(param_1,"\n  // compute lighting & shadowing factor\n",0x2a);
  FUN_1400543f0(param_1,"  UNITY_LIGHT_ATTENUATION(atten, IN, worldPos)\n",0x2f);
  FUN_1400543f0(param_1,"  fixed4 c = 0;\n",0x10);
  FUN_140074920(param_1,param_4);
  if (cVar2 == '\0') {
    if (*(char *)(param_2 + 0x2be) == '\0') {
      FUN_1400543f0(param_1,"  #ifndef LIGHTMAP_ON\n",0x16);
      FUN_1400543f0(param_1,"  c.rgb += o.Albedo * IN.vlight;\n",0x21);
      FUN_1400543f0(param_1,"  #endif // !LIGHTMAP_ON\n",0x19);
    }
    FUN_1400543f0(param_1,"\n  // lightmaps\n",0x10);
    FUN_1400543f0(param_1,"  #ifdef LIGHTMAP_ON\n",0x15);
    FUN_1400543f0(param_1,"    #if DIRLIGHTMAP_COMBINED\n",0x1d);
    local_88 = 0x4b;
    local_a8 = 0;
    local_89 = 0x1f;
    FUN_140054780(&local_a8,&DAT_140582060,1);
    uVar17 = FUN_14006f9e0(&local_140,param_2,param_3,param_4,&local_a8,0);
    FUN_14001b640(param_1,uVar17);
    if ((local_121 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(uStack_13f,local_140),local_120,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    FUN_1400543f0(param_1,"    #else\n",10);
    local_88 = 0x4b;
    local_a8 = 0;
    local_89 = 0x1f;
    FUN_140054780(&local_a8,&DAT_140582060,1);
    uVar17 = FUN_1400735b0(&local_140,param_2,param_3,param_4,&local_a8,1);
    FUN_14001b640(param_1,uVar17);
    if ((local_121 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(uStack_13f,local_140),local_120,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    FUN_1400543f0(param_1,"    #endif\n\n",0xc);
    FUN_1400543f0(param_1,"  #endif // LIGHTMAP_ON\n\n",0x19);
  }
  else {
    FUN_14006f4b0(param_1,param_2,0,*(undefined1 *)(param_4 + 199));
  }
  FUN_1400543f0(param_1,"\n  // realtime lighting: call lighting function\n",0x30);
  if (cVar2 == '\0') {
    if (*(char *)(param_2 + 0x2c6) == '\0') {
      uVar17 = 0x16;
      pcVar10 = "  #ifndef LIGHTMAP_ON\n";
    }
    else {
      uVar17 = 0x19;
      pcVar10 = "  #ifdef DIRLIGHTMAP_OFF\n";
    }
    FUN_1400543f0(param_1,pcVar10,uVar17);
    local_120 = 0x4b;
    local_140 = 0;
    local_121 = 0x1f;
    FUN_140054780(&local_140,"atten",5);
    local_88 = 0x4b;
    local_89 = 0x1f;
    local_a8 = 0;
    puVar7 = (undefined2 *)FUN_140056c90(&local_a8,1);
    *puVar7 = 99;
    if (local_89 < 0x40) {
      local_89 = 0x1e;
    }
    else {
      local_98 = 1;
    }
    FUN_1400717c0(param_1,param_2,param_4,&local_a8,&local_140);
    FUN_1400543f0(param_1,"  #else\n",8);
    FUN_1400543f0(param_1,"    c.a = o.Alpha;\n",0x13);
    FUN_1400543f0(param_1,"  #endif\n\n",10);
    FUN_1400543f0(param_1,"  #ifdef LIGHTMAP_ON\n",0x15);
    if (*(char *)(param_2 + 0x2c6) != '\0') {
      FUN_1400543f0(param_1,"    #ifndef DIRLIGHTMAP_OFF\n",0x1c);
    }
    if (*(char *)(param_2 + 0x2b9) == '\0') {
      FUN_1400543f0(param_1,"    // combine lightmaps with realtime shadows\n",0x2f);
      FUN_1400543f0(param_1,"    #ifdef SHADOWS_SCREEN\n",0x1a);
      FUN_1400543f0(param_1,"      #if defined(UNITY_LIGHTMAP_DLDR_ENCODING)\n",0x30);
      FUN_1400543f0(param_1,"      c.rgb += o.Albedo * min(lm, atten*2);\n",0x2c);
      FUN_1400543f0(param_1,"      #else\n",0xc);
      FUN_1400543f0(param_1,
                    "      c.rgb += o.Albedo * max(min(lm,(atten*2)*lmtex.rgb), lm*atten);\n",0x46);
      FUN_1400543f0(param_1,"      #endif\n",0xd);
      FUN_1400543f0(param_1,"    #else // SHADOWS_SCREEN\n",0x1c);
      FUN_1400543f0(param_1,"      c.rgb += o.Albedo * lm;\n",0x1e);
      FUN_1400543f0(param_1,"    #endif // SHADOWS_SCREEN\n",0x1d);
    }
    if (*(char *)(param_2 + 0x2c6) != '\0') {
      FUN_1400543f0(param_1,"  #else // !DIRLIGHTMAP_OFF\n",0x1c);
      FUN_1400543f0(param_1,
                    "  half lmFade2 = length (IN.lmapFadePos) * unity_LightmapFade.z + unity_LightmapFade.w;\n"
                    ,0x58);
      FUN_1400543f0(param_1,"  c.rgb *= saturate(1.0 - lmFade2);\n",0x24);
      FUN_1400543f0(param_1,"  c.rgb += o.Albedo * lm;\n",0x1a);
      FUN_1400543f0(param_1,"  #endif // !DIRLIGHTMAP_OFF\n",0x1d);
    }
    FUN_1400543f0(param_1,"  #endif // LIGHTMAP_ON\n\n",0x19);
    if (*(char *)(param_2 + 699) == '\0') {
      FUN_1400543f0(param_1,"  #ifdef DYNAMICLIGHTMAP_ON\n",0x1c);
      FUN_1400543f0(param_1,
                    "  fixed4 dynlmtex = UNITY_SAMPLE_TEX2D(unity_DynamicLightmap, IN.lmap.zw);\n",
                    0x4b);
      FUN_1400543f0(param_1,"  c.rgb += o.Albedo * DecodeRealtimeLightmap (dynlmtex);\n",0x39);
      FUN_1400543f0(param_1,"  #endif\n\n",10);
    }
  }
  else {
    local_88 = 0x4b;
    local_a8 = 0;
    local_89 = 0x1f;
    FUN_140054780(&local_a8,&DAT_140582060,1);
    FUN_140071c50(param_1,param_2,param_4,&local_a8);
    if ((local_89 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(uStack_a7,local_a8),local_88,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
  }
  if (*(char *)(param_3 + 0x179) != '\0') {
    FUN_1400543f0(param_1,"  c.rgb += o.Emission;\n",0x17);
  }
  FUN_140071600(param_1,param_2);
  uVar17 = 1;
LAB_14007de3e:
  if ((local_59 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_77,local_78),local_58,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  if ((local_e1 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_ff,local_100),local_e0,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  return uVar17;
  while( true ) {
    local_c8 = uVar18;
    uVar18 = local_c8;
    if (local_b9 < 0x40) {
      uVar18 = 0x1f - (longlong)(char)local_b9;
    }
    puVar9 = (undefined1 *)&local_d8;
    if (0x3f < local_b9) {
      puVar9 = (undefined1 *)CONCAT71(local_d8._1_7_,(undefined1)local_d8);
    }
    FUN_1400543f0(param_1,puVar9,uVar18);
    if ((local_b9 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(local_d8._1_7_,(undefined1)local_d8),local_b8,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    local_res18 = local_res18 + 1;
    local_108 = uVar21 + 0x28;
    iVar13 = local_10c;
    uVar15 = local_110;
    uVar20 = local_80;
    iVar14 = local_7c;
    if ((ulonglong)param_5[2] <= local_res18) break;
LAB_14007dae0:
    uVar21 = local_108;
    puVar6 = (undefined8 *)(*param_5 + local_108);
    local_b8 = *(undefined2 *)(puVar6 + 4);
    local_d8._0_1_ = 0;
    local_b9 = 0x1f;
    local_118 = 1;
    if (*(byte *)((longlong)puVar6 + 0x1f) < 0x40) {
      lVar16 = 0x1f - (longlong)*(char *)((longlong)puVar6 + 0x1f);
    }
    else {
      lVar16 = puVar6[2];
    }
    if (((0x1e < lVar16 + 1U) && (FUN_140056c90(&local_d8), 0x3f < local_b9)) && (local_d0 == 0)) {
      FUN_140056c90(&local_d8,1);
    }
    if (local_b9 < 0x40) {
      local_b9 = 0x1e;
      puVar9 = (undefined1 *)&local_d8;
    }
    else {
      local_c8 = 1;
      puVar9 = (undefined1 *)CONCAT71(local_d8._1_7_,(undefined1)local_d8);
    }
    puVar9[1] = 0;
    puVar9 = (undefined1 *)&local_d8;
    if (0x3f < local_b9) {
      puVar9 = (undefined1 *)CONCAT71(local_d8._1_7_,(undefined1)local_d8);
    }
    *puVar9 = 0x20;
    if (*(byte *)((longlong)puVar6 + 0x1f) < 0x40) {
      lVar16 = 0x1f - (longlong)*(char *)((longlong)puVar6 + 0x1f);
    }
    else {
      lVar16 = puVar6[2];
      puVar6 = (undefined8 *)*puVar6;
    }
    uVar18 = local_c8;
    if (lVar16 != 0) {
      uVar21 = local_c8;
      if (local_b9 < 0x40) {
        uVar21 = 0x1f - (longlong)(char)local_b9;
      }
      uVar18 = uVar21 + lVar16;
      uVar11 = local_d0;
      if (local_b9 < 0x40) {
        uVar11 = 0x1f;
      }
      if (uVar11 < uVar18) {
        uVar19 = uVar11 * 2;
        if (uVar11 * 2 <= uVar18) {
          uVar19 = uVar18;
        }
        puVar8 = &local_d8;
        if (0x3f < local_b9) {
          puVar8 = (undefined8 *)CONCAT71(local_d8._1_7_,(undefined1)local_d8);
        }
        if (puVar8 <= puVar6) {
          uVar11 = local_c8;
          if (local_b9 < 0x40) {
            uVar11 = 0x1f - (longlong)(char)local_b9;
          }
          if (puVar6 < (undefined8 *)(uVar11 + (longlong)puVar8)) {
            puVar8 = &local_d8;
            if (0x3f < local_b9) {
              puVar8 = (undefined8 *)CONCAT71(local_d8._1_7_,(undefined1)local_d8);
            }
            puVar9 = (undefined1 *)FUN_140056c90(&local_d8,uVar19);
            puVar6 = (undefined8 *)(puVar9 + ((longlong)puVar6 - (longlong)puVar8));
            goto LAB_14007dc61;
          }
        }
        puVar9 = (undefined1 *)FUN_140056c90(&local_d8,uVar19);
      }
      else {
        puVar9 = (undefined1 *)&local_d8;
        if (0x3f < local_b9) {
          puVar9 = (undefined1 *)CONCAT71(local_d8._1_7_,(undefined1)local_d8);
        }
      }
LAB_14007dc61:
      FUN_140558820(puVar9 + uVar21,puVar6,lVar16);
      puVar9[uVar18] = 0;
      uVar21 = local_108;
      if (local_b9 < 0x40) {
        local_b9 = 0x1f - (char)uVar18;
        uVar18 = local_c8;
      }
    }
  }
LAB_14007dd4a:
  FUN_14001b680(param_1,10);
  iVar5 = local_b0;
LAB_14007dd67:
  if (local_e1 < 0x40) {
    local_f0 = 0x1f - (longlong)(char)local_e1;
  }
  puVar9 = &local_100;
  if (0x3f < local_e1) {
    puVar9 = (undefined1 *)CONCAT71(uStack_ff,local_100);
  }
  FUN_1400543f0(param_1,puVar9,local_f0);
  if ((int)uVar20 < iVar14) {
    iVar13 = iVar13 + iVar5;
    uVar15 = uVar20;
  }
  if (((*(byte *)(param_2 + 0x348) >> 1 & 1) == 0) && (iVar14 <= (int)uVar20)) {
    bVar1 = true;
  }
  else {
    bVar1 = false;
  }
  uVar22 = *(undefined4 *)(param_2 + 0x370);
  pcVar10 = "";
  if (bVar1) {
    pcVar10 = ", try adding #pragma target 3.0";
  }
  uVar17 = FUN_1400e0f60(&local_140,
                         "Too many texture interpolators would be used for ForwardBase pass (%d out of max %d)%s"
                         ,iVar13,uVar15,pcVar10);
  FUN_140089820(param_6,uVar17,uVar22,0,0x1c);
  if ((local_121 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_13f,local_140),local_120,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  uVar17 = 0;
  goto LAB_14007de3e;
}
```

## `FUN_14007e320` — `0x14007e320`

per-model pass emitter

```c
void FUN_14007e320(undefined8 param_1,undefined8 param_2,undefined8 param_3,longlong param_4)

{
  byte bVar1;
  uint uVar2;
  undefined8 *puVar3;
  longlong lVar4;
  char cVar5;
  uint uVar6;
  undefined1 local_38;
  undefined7 uStack_37;
  undefined8 local_28;
  byte local_19;
  undefined2 local_18;
  
  GenerateSurfacePassHeader();
  if (((((*(char *)(param_4 + 0xc0) == '\0') || (*(char *)(param_4 + 0xcc) == '\0')) &&
       (*(char *)(param_4 + 0xc6) == '\0')) && (*(char *)(param_4 + 0xc3) == '\0')) &&
     (((*(char *)(param_4 + 0xc0) == '\0' || (*(char *)(param_4 + 0xcc) == '\0')) &&
      (*(char *)(param_4 + 0xc5) == '\0')))) {
    cVar5 = *(char *)(param_4 + 0xc4);
  }
  else {
    cVar5 = '\x01';
  }
  uVar2 = 0x1080;
  if (cVar5 == '\0') {
    uVar2 = 0x1000;
  }
  uVar6 = uVar2 | 0x100;
  if (*(char *)(param_4 + 0xcc) == '\0') {
    uVar6 = uVar2;
  }
  if ((*(char *)(param_4 + 0xcd) != '\0') || (*(char *)(param_4 + 0xc1) != '\0')) {
    uVar6 = uVar6 | 0x10;
  }
  FUN_140074640(param_1,param_2,0,0,uVar6 >> 8 & 1,1);
  FUN_140075dc0(param_1,param_2,param_3);
  FUN_1400543f0(param_1,"#include \"UnityMetaPass.cginc\"\n",0x1f);
  FUN_1400543f0(param_1,"\n// vertex-to-fragment interpolation data\n",0x2a);
  GenerateV2fStruct(param_1,param_2,param_3,param_4,uVar6,0);
  FUN_1400543f0(param_1,"  UNITY_VERTEX_INPUT_INSTANCE_ID\n",0x21);
  FUN_1400543f0(param_1,"  UNITY_VERTEX_OUTPUT_STEREO\n",0x1d);
  FUN_1400543f0(param_1,&DAT_140580da8,3);
  FUN_140076c10(param_1,param_2,param_3,param_4,uVar6);
  FUN_1400543f0(param_1,"  return o;\n",0xc);
  FUN_1400543f0(param_1,&DAT_14057f1b0,2);
  FUN_140075430(param_1,param_2,param_3);
  FUN_140071fe0(param_1,param_2,param_3,param_4,uVar6);
  FUN_1400543f0(param_1,"  UnityMetaInput metaIN;\n",0x19);
  FUN_1400543f0(param_1,"  UNITY_INITIALIZE_OUTPUT(UnityMetaInput, metaIN);\n",0x33);
  FUN_1400543f0(param_1,"  metaIN.Albedo = o.Albedo;\n",0x1c);
  FUN_1400543f0(param_1,"  metaIN.Emission = o.Emission;\n",0x20);
  local_18 = 0x4b;
  local_38 = 0;
  local_19 = 0x1f;
  puVar3 = (undefined8 *)FUN_140056c90(&local_38,8);
  *puVar3 = 0x72616c7563657053;
  *(undefined1 *)(puVar3 + 1) = 0;
  if (local_19 < 0x40) {
    local_19 = 0x17;
  }
  else {
    local_28 = 8;
  }
  bVar1 = local_19;
  lVar4 = FUN_140079140(param_3,&local_38);
  if ((bVar1 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_37,local_38),local_18,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  if (lVar4 != 0) {
    FUN_1400543f0(param_1,"  metaIN.SpecularColor = o.Specular;\n",0x25);
  }
  FUN_1400543f0(param_1,"#ifdef EDITOR_VISUALIZATION\n",0x1c);
  FUN_1400543f0(param_1,"  metaIN.VizUV = IN.vizUV;\n",0x1b);
  FUN_1400543f0(param_1,"  metaIN.LightCoord = IN.lightCoord;\n",0x25);
  FUN_1400543f0(param_1,&DAT_14057b9a8,7);
  FUN_1400543f0(param_1,"  return UnityMetaFragment(metaIN);\n",0x24);
  FUN_1400543f0(param_1,&DAT_14057f1b0,2);
  return;
}
```

## `FUN_140080890` — `0x140080890`

per-model pass emitter

```c
void FUN_140080890(undefined8 param_1,undefined8 param_2,undefined8 param_3,longlong param_4)

{
  char cVar1;
  uint uVar2;
  
  GenerateSurfacePassHeader();
  if (((((*(char *)(param_4 + 0xc0) == '\0') || (*(char *)(param_4 + 0xcc) == '\0')) &&
       (*(char *)(param_4 + 0xc6) == '\0')) && (*(char *)(param_4 + 0xc3) == '\0')) &&
     (((*(char *)(param_4 + 0xc0) == '\0' || (*(char *)(param_4 + 0xcc) == '\0')) &&
      (*(char *)(param_4 + 0xc5) == '\0')))) {
    cVar1 = *(char *)(param_4 + 0xc4);
  }
  else {
    cVar1 = '\x01';
  }
  uVar2 = 0x81;
  if (cVar1 == '\0') {
    uVar2 = 1;
  }
  if ((*(char *)(param_4 + 0xcd) != '\0') || (*(char *)(param_4 + 0xc1) != '\0')) {
    uVar2 = uVar2 | 0x10;
  }
  FUN_140074640(param_1,param_2,0,0,0,1);
  FUN_140075dc0(param_1,param_2,param_3);
  FUN_1400543f0(param_1,"\n// vertex-to-fragment interpolation data\n",0x2a);
  GenerateV2fStruct(param_1,param_2,param_3,param_4,uVar2,1);
  FUN_1400543f0(param_1,"  UNITY_VERTEX_INPUT_INSTANCE_ID\n",0x21);
  FUN_1400543f0(param_1,"  UNITY_VERTEX_OUTPUT_STEREO\n",0x1d);
  FUN_1400543f0(param_1,&DAT_140580da8,3);
  FUN_140076c10(param_1,param_2,param_3,param_4,uVar2);
  FUN_1400543f0(param_1,"  TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)\n",0x29);
  FUN_1400543f0(param_1,"  return o;\n",0xc);
  FUN_1400543f0(param_1,&DAT_14057f1b0,2);
  FUN_140075430(param_1,param_2,param_3);
  FUN_140071fe0(param_1,param_2,param_3,param_4,uVar2);
  FUN_1400543f0(param_1,"  SHADOW_CASTER_FRAGMENT(IN)\n",0x1d);
  FUN_1400543f0(param_1,&DAT_14057f1b0,2);
  return;
}
```

## `GenerateSurfacePassHeader` — `0x140082760`

pass header plus vertex/fragment markers

```c
void GenerateSurfacePassHeader(longlong param_1,longlong param_2,longlong param_3,longlong *param_4)

{
  undefined8 uVar1;
  undefined8 *puVar2;
  longlong lVar3;
  ulonglong uVar4;
  ulonglong uVar5;
  longlong *plVar6;
  undefined8 local_58 [3];
  byte local_39;
  undefined2 local_38;
  undefined8 local_30 [3];
  byte local_11;
  undefined2 local_10;
  
  if ((*(byte *)(param_1 + 0x1f) < 0x40) || (*(ulonglong *)(param_1 + 8) < 0xc9)) {
    FUN_140056c90(param_1,200);
  }
  FUN_1400543f0(param_1,"// Surface shader code generated based on:\n",0x2b);
  if (*(byte *)(param_2 + 0x1f) < 0x40) {
    lVar3 = 0x1f - (longlong)*(char *)(param_2 + 0x1f);
  }
  else {
    lVar3 = *(longlong *)(param_2 + 0x10);
  }
  if (lVar3 != 0) {
    uVar1 = FUN_14001b190(local_30,"// vertex modifier: \'",param_2);
    puVar2 = (undefined8 *)FUN_14001ad10(local_58,uVar1,&DAT_14057f2f4);
    if (*(byte *)((longlong)puVar2 + 0x1f) < 0x40) {
      lVar3 = 0x1f - (longlong)*(char *)((longlong)puVar2 + 0x1f);
    }
    else {
      lVar3 = puVar2[2];
      puVar2 = (undefined8 *)*puVar2;
    }
    FUN_1400543f0(param_1,puVar2,lVar3);
    if ((local_39 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(local_58[0],local_38,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    if ((local_11 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(local_30[0],local_10,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
  }
  FUN_1400826d0(param_1,"writes to per-pixel normal",*(undefined1 *)(param_3 + 0x178));
  FUN_1400826d0(param_1,"writes to emission",*(undefined1 *)(param_3 + 0x179));
  FUN_1400826d0(param_1,"writes to occlusion",*(undefined1 *)(param_3 + 0x17b));
  FUN_1400826d0(param_1,"needs world space reflection vector",(char)param_4[0x18]);
  FUN_1400826d0(param_1,"needs world space normal vector",*(undefined1 *)((longlong)param_4 + 0xc1))
  ;
  FUN_1400826d0(param_1,"needs screen space position",*(undefined1 *)((longlong)param_4 + 0xc2));
  FUN_1400826d0(param_1,"needs world space position",*(undefined1 *)((longlong)param_4 + 0xc4));
  FUN_1400826d0(param_1,"needs view direction",*(undefined1 *)((longlong)param_4 + 0xc3));
  FUN_1400826d0(param_1,"needs world space view direction",*(undefined1 *)((longlong)param_4 + 0xc5)
               );
  FUN_1400826d0(param_1,"needs world space position for lighting",
                *(undefined1 *)((longlong)param_4 + 0xc6));
  FUN_1400826d0(param_1,"needs world space view direction for lighting",
                *(undefined1 *)((longlong)param_4 + 199));
  FUN_1400826d0(param_1,"needs world space view direction for lightmaps",(char)param_4[0x19]);
  FUN_1400826d0(param_1,"needs vertex color",*(undefined1 *)((longlong)param_4 + 0xc9));
  FUN_1400826d0(param_1,"needs VFACE",*(undefined1 *)((longlong)param_4 + 0xca));
  FUN_1400826d0(param_1,"needs SV_IsFrontFace",*(undefined1 *)((longlong)param_4 + 0xcb));
  FUN_1400826d0(param_1,"passes tangent-to-world matrix to pixel shader",
                *(undefined1 *)((longlong)param_4 + 0xcc));
  FUN_1400826d0(param_1,"reads from normal",*(undefined1 *)((longlong)param_4 + 0xcd));
  puVar2 = (undefined8 *)
           FUN_1400e0f60(local_30,"// %i texcoords actually used\n",(param_4[1] - *param_4) / 0x88);
  if (*(byte *)((longlong)puVar2 + 0x1f) < 0x40) {
    lVar3 = 0x1f - (longlong)*(char *)((longlong)puVar2 + 0x1f);
  }
  else {
    lVar3 = puVar2[2];
    puVar2 = (undefined8 *)*puVar2;
  }
  FUN_1400543f0(param_1,puVar2,lVar3);
  if ((local_11 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(local_30[0],local_10,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  uVar4 = 0;
  lVar3 = param_4[1] - *param_4 >> 0x3f;
  uVar5 = uVar4;
  if ((param_4[1] - *param_4) / 0x88 + lVar3 != lVar3) {
    do {
      puVar2 = (undefined8 *)(*param_4 + uVar4);
      plVar6 = puVar2 + 5;
      if (0x3f < *(byte *)((longlong)puVar2 + 0x47)) {
        plVar6 = (longlong *)*plVar6;
      }
      if (0x3f < *(byte *)((longlong)puVar2 + 0x1f)) {
        puVar2 = (undefined8 *)*puVar2;
      }
      puVar2 = (undefined8 *)FUN_1400e0f60(local_30,"//   %s %s\n",puVar2,plVar6);
      if (*(byte *)((longlong)puVar2 + 0x1f) < 0x40) {
        lVar3 = 0x1f - (longlong)*(char *)((longlong)puVar2 + 0x1f);
      }
      else {
        lVar3 = puVar2[2];
        puVar2 = (undefined8 *)*puVar2;
      }
      FUN_1400543f0(param_1,puVar2,lVar3);
      if ((local_11 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(local_30[0],local_10,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      uVar5 = uVar5 + 1;
      uVar4 = uVar4 + 0x88;
    } while (uVar5 < (ulonglong)((param_4[1] - *param_4) / 0x88));
  }
  return;
}
```

## `GenerateV2fStruct` — `0x1400749c0`

`struct v2f_` emission

```c
int GenerateV2fStruct(undefined8 param_1,longlong param_2,longlong param_3,longlong param_4,
                     uint param_5,int param_6)

{
  int iVar1;
  undefined8 *puVar2;
  char *pcVar3;
  undefined8 uVar4;
  longlong lVar5;
  longlong lVar6;
  int iVar7;
  ulonglong uVar8;
  char cVar9;
  uint uVar10;
  longlong lVar11;
  ulonglong uVar12;
  undefined8 local_a8 [3];
  byte local_89;
  undefined2 local_88;
  uint local_80;
  uint local_7c;
  uint local_78;
  uint local_74;
  undefined8 local_70 [3];
  byte local_51;
  undefined2 local_50;
  
  uVar10 = param_5 >> 7 & 0xffffff01;
  local_78 = param_5 >> 8 & 0xffffff01;
  local_80 = param_5 >> 0xd & 0xffffff01;
  local_74 = param_5 >> 0xe & 0xffffff01;
  local_7c = uVar10;
  if (((char)local_78 == '\0') || ((char)local_80 == '\0')) {
    if (((char)uVar10 != '\0') && ((char)local_74 != '\0')) {
      uVar4 = 0x24;
      pcVar3 = "#define FOG_COMBINED_WITH_WORLD_POS\n";
      goto LAB_140074a5e;
    }
  }
  else {
    uVar4 = 0x21;
    pcVar3 = "#define FOG_COMBINED_WITH_TSPACE\n";
LAB_140074a5e:
    FUN_1400543f0(param_1,pcVar3,uVar4);
  }
  uVar4 = FUN_14001b190(local_a8,"struct v2f_",param_2 + 200);
  puVar2 = (undefined8 *)FUN_14001ad10(local_70,uVar4,&DAT_14057e1f8);
  if (*(byte *)((longlong)puVar2 + 0x1f) < 0x40) {
    lVar5 = 0x1f - (longlong)*(char *)((longlong)puVar2 + 0x1f);
  }
  else {
    lVar5 = puVar2[2];
    puVar2 = (undefined8 *)*puVar2;
  }
  FUN_1400543f0(param_1,puVar2,lVar5);
  if ((local_51 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(local_70[0],local_50,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  if ((local_89 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(local_a8[0],local_88,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  pcVar3 = "  V2F_SHADOW_CASTER;\n";
  if ((param_5 & 1) == 0) {
    pcVar3 = "  UNITY_POSITION(pos);\n";
  }
  FUN_1400543f0(param_1,pcVar3,(param_5 & 1 ^ 1) * 2 + 0x15);
  iVar1 = (int)((*(longlong *)(param_4 + 0x38) - *(longlong *)(param_4 + 0x30)) / 0x30);
  iVar7 = 0;
  lVar5 = (longlong)iVar1;
  if (0 < iVar1) {
    lVar11 = 0;
    iVar1 = param_6;
    do {
      lVar6 = *(longlong *)(param_4 + 0x30);
      puVar2 = (undefined8 *)(lVar6 + 8 + lVar11);
      if (0x3f < *(byte *)((longlong)puVar2 + 0x1f)) {
        puVar2 = (undefined8 *)*puVar2;
      }
      param_6 = iVar1 + 1;
      puVar2 = (undefined8 *)
               FUN_1400e0f60(local_a8,"  %s pack%i : TEXCOORD%i; // %s\n",
                             (&PTR_DAT_1407266a0)
                             [(longlong)*(int *)(lVar6 + 4 + lVar11) * 5 +
                              (longlong)*(int *)(lVar6 + lVar11)],iVar7,iVar1,puVar2);
      if (*(byte *)((longlong)puVar2 + 0x1f) < 0x40) {
        lVar6 = 0x1f - (longlong)*(char *)((longlong)puVar2 + 0x1f);
      }
      else {
        lVar6 = puVar2[2];
        puVar2 = (undefined8 *)*puVar2;
      }
      FUN_1400543f0(param_1,puVar2,lVar6);
      if ((local_89 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(local_a8[0],local_88,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      iVar7 = iVar7 + 1;
      lVar11 = lVar11 + 0x30;
      lVar5 = lVar5 + -1;
      iVar1 = param_6;
      uVar10 = local_7c;
    } while (lVar5 != 0);
  }
  uVar8 = 0;
  cVar9 = (char)uVar10;
  if ((char)local_78 == '\0') {
    iVar1 = param_6;
    if (*(char *)(param_4 + 0xc0) != '\0') {
      iVar1 = param_6 + 1;
      puVar2 = (undefined8 *)FUN_1400e0f60(local_a8,"  half3 worldRefl : TEXCOORD%i;\n",param_6);
      if (*(byte *)((longlong)puVar2 + 0x1f) < 0x40) {
        lVar5 = 0x1f - (longlong)*(char *)((longlong)puVar2 + 0x1f);
      }
      else {
        lVar5 = puVar2[2];
        puVar2 = (undefined8 *)*puVar2;
      }
      FUN_1400543f0(param_1,puVar2,lVar5);
      if ((local_89 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(local_a8[0],local_88,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
    }
    iVar7 = iVar1;
    if ((param_5 & 0x10) != 0) {
      iVar7 = iVar1 + 1;
      puVar2 = (undefined8 *)FUN_1400e0f60(local_a8,"  float3 worldNormal : TEXCOORD%i;\n",iVar1);
      if (*(byte *)((longlong)puVar2 + 0x1f) < 0x40) {
        lVar5 = 0x1f - (longlong)*(char *)((longlong)puVar2 + 0x1f);
      }
      else {
        lVar5 = puVar2[2];
        puVar2 = (undefined8 *)*puVar2;
      }
      FUN_1400543f0(param_1,puVar2,lVar5);
      if ((local_89 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(local_a8[0],local_88,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
    }
    if (cVar9 != '\0') {
      iVar1 = iVar7 + 1;
      if ((char)local_74 == '\0') {
        puVar2 = (undefined8 *)FUN_1400e0f60(local_a8,"  float3 worldPos : TEXCOORD%i;\n",iVar7);
        if (*(byte *)((longlong)puVar2 + 0x1f) < 0x40) {
          lVar5 = 0x1f - (longlong)*(char *)((longlong)puVar2 + 0x1f);
        }
        else {
          lVar5 = puVar2[2];
          puVar2 = (undefined8 *)*puVar2;
        }
        FUN_1400543f0(param_1,puVar2,lVar5);
        iVar7 = iVar1;
        if ((local_89 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(local_a8[0],local_88,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
        }
      }
      else {
        puVar2 = (undefined8 *)FUN_1400e0f60(local_a8,"  float4 worldPos : TEXCOORD%i;\n",iVar7);
        if (*(byte *)((longlong)puVar2 + 0x1f) < 0x40) {
          lVar5 = 0x1f - (longlong)*(char *)((longlong)puVar2 + 0x1f);
        }
        else {
          lVar5 = puVar2[2];
          puVar2 = (undefined8 *)*puVar2;
        }
        FUN_1400543f0(param_1,puVar2,lVar5);
        iVar7 = iVar1;
        if ((local_89 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(local_a8[0],local_88,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
        }
      }
    }
  }
  else {
    if ((cVar9 == '\0') || ((param_5 >> 0xb & 1) != 0)) {
      iVar7 = FUN_1400752a0(param_1,param_6,0,(undefined1)local_80);
      iVar1 = iVar7;
      if (cVar9 == '\0') goto LAB_140074ce4;
    }
    else {
      iVar1 = FUN_1400752a0(param_1,param_6,1,(undefined1)local_80);
    }
    iVar7 = iVar1;
    if ((param_5 >> 0xb & 1) != 0) {
      iVar7 = iVar1 + 1;
      puVar2 = (undefined8 *)FUN_1400e0f60(local_a8,"  float3 worldPos : TEXCOORD%i;\n",iVar1);
      if (*(byte *)((longlong)puVar2 + 0x1f) < 0x40) {
        lVar5 = 0x1f - (longlong)*(char *)((longlong)puVar2 + 0x1f);
      }
      else {
        lVar5 = puVar2[2];
        puVar2 = (undefined8 *)*puVar2;
      }
      FUN_1400543f0(param_1,puVar2,lVar5);
      if ((local_89 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(local_a8[0],local_88,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
    }
  }
LAB_140074ce4:
  iVar1 = iVar7;
  if (*(char *)(param_4 + 0xc2) != '\0') {
    iVar1 = iVar7 + 1;
    puVar2 = (undefined8 *)FUN_1400e0f60(local_a8,"  float4 screenPos : TEXCOORD%i;\n",iVar7);
    if (*(byte *)((longlong)puVar2 + 0x1f) < 0x40) {
      lVar5 = 0x1f - (longlong)*(char *)((longlong)puVar2 + 0x1f);
    }
    else {
      lVar5 = puVar2[2];
      puVar2 = (undefined8 *)*puVar2;
    }
    FUN_1400543f0(param_1,puVar2,lVar5);
    if ((local_89 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(local_a8[0],local_88,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
  }
  if (*(char *)(param_4 + 0xc9) != '\0') {
    FUN_1400543f0(param_1,"  fixed4 color : COLOR0;\n",0x19);
  }
  if (*(byte *)(param_2 + 0x1f) < 0x40) {
    lVar5 = 0x1f - (longlong)*(char *)(param_2 + 0x1f);
  }
  else {
    lVar5 = *(longlong *)(param_2 + 0x10);
  }
  if (((lVar5 != 0) && (*(char *)(param_3 + 0x160) != '\0')) &&
     (lVar11 = *(longlong *)(param_3 + 0x150) - *(longlong *)(param_3 + 0x148),
     lVar5 = lVar11 >> 0x3f, uVar12 = uVar8, iVar7 = iVar1, lVar11 / 0x30 + lVar5 != lVar5)) {
    do {
      lVar5 = *(longlong *)(param_3 + 0x148);
      puVar2 = (undefined8 *)(lVar5 + 8 + uVar12);
      if (0x3f < *(byte *)((longlong)puVar2 + 0x1f)) {
        puVar2 = (undefined8 *)*puVar2;
      }
      iVar1 = iVar7 + 1;
      puVar2 = (undefined8 *)
               FUN_1400e0f60(local_a8,"  %s custompack%i : TEXCOORD%i; // %s\n",
                             (&PTR_DAT_1407266a0)
                             [(longlong)*(int *)(lVar5 + 4 + uVar12) * 5 +
                              (longlong)*(int *)(lVar5 + uVar12)],uVar8,iVar7,puVar2);
      if (*(byte *)((longlong)puVar2 + 0x1f) < 0x40) {
        lVar5 = 0x1f - (longlong)*(char *)((longlong)puVar2 + 0x1f);
      }
      else {
        lVar5 = puVar2[2];
        puVar2 = (undefined8 *)*puVar2;
      }
      FUN_1400543f0(param_1,puVar2,lVar5);
      if ((local_89 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(local_a8[0],local_88,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      uVar8 = uVar8 + 1;
      uVar12 = uVar12 + 0x30;
      iVar7 = iVar1;
    } while (uVar8 < (ulonglong)
                     ((*(longlong *)(param_3 + 0x150) - *(longlong *)(param_3 + 0x148)) / 0x30));
  }
  iVar7 = iVar1;
  if ((param_5 & 0x20) != 0) {
    if (*(char *)(param_4 + 0xc3) == '\0') {
      FUN_1400543f0(param_1,"#ifndef DIRLIGHTMAP_OFF\n",0x18);
    }
    iVar7 = iVar1 + 1;
    puVar2 = (undefined8 *)FUN_1400e0f60(local_a8,"  float3 viewDir : TEXCOORD%i;\n",iVar1);
    if (*(byte *)((longlong)puVar2 + 0x1f) < 0x40) {
      lVar5 = 0x1f - (longlong)*(char *)((longlong)puVar2 + 0x1f);
    }
    else {
      lVar5 = puVar2[2];
      puVar2 = (undefined8 *)*puVar2;
    }
    FUN_1400543f0(param_1,puVar2,lVar5);
    if ((local_89 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(local_a8[0],local_88,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    if (*(char *)(param_4 + 0xc3) == '\0') {
      FUN_1400543f0(param_1,&DAT_14057b9a8,7);
    }
  }
  iVar1 = iVar7;
  if ((param_5 & 0x40) != 0) {
    iVar1 = iVar7 + 1;
    puVar2 = (undefined8 *)FUN_1400e0f60(local_a8,"  float3 worldViewDir : TEXCOORD%i;\n",iVar7);
    if (*(byte *)((longlong)puVar2 + 0x1f) < 0x40) {
      lVar5 = 0x1f - (longlong)*(char *)((longlong)puVar2 + 0x1f);
    }
    else {
      lVar5 = puVar2[2];
      puVar2 = (undefined8 *)*puVar2;
    }
    FUN_1400543f0(param_1,puVar2,lVar5);
    if ((local_89 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(local_a8[0],local_88,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
  }
  if ((param_5 >> 0xc & 1) != 0) {
    FUN_1400543f0(param_1,"#ifdef EDITOR_VISUALIZATION\n",0x1c);
    puVar2 = (undefined8 *)FUN_1400e0f60(local_a8,"  float2 vizUV : TEXCOORD%i;\n",iVar1);
    if (*(byte *)((longlong)puVar2 + 0x1f) < 0x40) {
      lVar5 = 0x1f - (longlong)*(char *)((longlong)puVar2 + 0x1f);
    }
    else {
      lVar5 = puVar2[2];
      puVar2 = (undefined8 *)*puVar2;
    }
    FUN_1400543f0(param_1,puVar2,lVar5);
    if ((local_89 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(local_a8[0],local_88,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    puVar2 = (undefined8 *)FUN_1400e0f60(local_a8,"  float4 lightCoord : TEXCOORD%i;\n",iVar1 + 1);
    if (*(byte *)((longlong)puVar2 + 0x1f) < 0x40) {
      lVar5 = 0x1f - (longlong)*(char *)((longlong)puVar2 + 0x1f);
    }
    else {
      lVar5 = puVar2[2];
      puVar2 = (undefined8 *)*puVar2;
    }
    FUN_1400543f0(param_1,puVar2,lVar5);
    if ((local_89 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(local_a8[0],local_88,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    FUN_1400543f0(param_1,&DAT_14057b9a8,7);
    iVar1 = iVar1 + 2;
  }
  return iVar1;
}
```

## `GenerateForwardAddPasses` — `0x14007acc0`

ForwardAdd pragmas

```c
void GenerateForwardAddPasses
               (undefined8 param_1,longlong param_2,longlong *param_3,undefined8 param_4)

{
  char *pcVar1;
  undefined4 uVar2;
  undefined4 uVar3;
  undefined4 uVar4;
  undefined8 uVar5;
  undefined1 uVar6;
  undefined8 *puVar7;
  longlong lVar8;
  undefined4 *puVar9;
  undefined8 ****ppppuVar10;
  undefined8 ****ppppuVar11;
  byte bVar12;
  undefined1 *puVar13;
  longlong lVar14;
  longlong lVar15;
  ulonglong uVar16;
  char *pcVar17;
  ulonglong uVar18;
  ulonglong uVar19;
  ulonglong uVar20;
  longlong local_res10;
  undefined8 in_stack_ffffffffffffff18;
  undefined4 uVar21;
  undefined8 ***local_d8;
  ulonglong uStack_d0;
  ulonglong local_c8;
  undefined2 local_c0;
  undefined1 local_be;
  byte local_b9;
  undefined2 local_b8;
  undefined1 local_b0;
  undefined7 uStack_af;
  undefined8 local_a0;
  byte local_91;
  undefined2 local_90;
  undefined1 local_88;
  undefined7 uStack_87;
  longlong local_78;
  byte local_69;
  undefined2 local_68;
  undefined1 local_60;
  undefined7 uStack_5f;
  byte local_41;
  undefined2 local_40;
  
  uVar21 = (undefined4)((ulonglong)in_stack_ffffffffffffff18 >> 0x20);
  local_40 = 0x4b;
  local_60 = 0;
  local_41 = 0x1f;
  uVar20 = 0;
  lVar14 = param_3[1] - *param_3 >> 0x3f;
  if ((param_3[1] - *param_3) / 0x5b0 + lVar14 != lVar14) {
    local_res10 = 0;
    do {
      if ((*(char *)(param_2 + 0x2c2) == '\0') && (*(char *)(param_2 + 0x2cb) == '\0')) {
        local_90 = 0x4b;
        local_b0 = 0;
        local_91 = 0x1f;
        puVar7 = (undefined8 *)FUN_140056c90(&local_b0,0xd);
        *puVar7 = 0x49434e4154534e49;
        *(undefined4 *)(puVar7 + 1) = 0x4f5f474e;
        *(undefined1 *)((longlong)puVar7 + 0xc) = 0x4e;
        *(undefined1 *)((longlong)puVar7 + 0xd) = 0;
        if (local_91 < 0x40) {
          local_91 = 0x12;
        }
        else {
          local_a0 = 0xd;
        }
        bVar12 = local_91;
        lVar15 = local_res10 + *param_3;
        lVar8 = FUN_140010c40(*(longlong *)(lVar15 + 0x590),
                              *(longlong *)(lVar15 + 0x590) + *(longlong *)(lVar15 + 0x5a0) * 0x28,
                              &local_b0);
        lVar14 = *(longlong *)(lVar15 + 0x5a0);
        lVar15 = *(longlong *)(lVar15 + 0x590);
        if ((bVar12 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(CONCAT71(uStack_af,local_b0),local_90,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
        }
        if (lVar8 == lVar15 + lVar14 * 0x28) goto LAB_14007ae31;
      }
      else {
LAB_14007ae31:
        FUN_14006f140(param_3,uVar20,&local_60);
        local_68 = 0x4b;
        local_88 = 0;
        local_69 = 0x1f;
        in_stack_ffffffffffffff18 = param_4;
        FUN_14007b3c0(&local_88,param_2,local_res10 + *param_3,*param_3 + 0x250 + local_res10,
                      param_4);
        lVar14 = local_78;
        if (local_69 < 0x40) {
          lVar14 = 0x1f - (longlong)(char)local_69;
        }
        puVar13 = &local_88;
        if (0x3f < local_69) {
          puVar13 = (undefined1 *)CONCAT71(uStack_87,local_88);
        }
        FUN_1400543f0(&local_60,puVar13,lVar14);
        if (1 < (ulonglong)((param_3[1] - *param_3) / 0x5b0)) {
          FUN_1400543f0(&local_60,"\n\n#endif\n\n",10);
        }
        if ((local_69 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(CONCAT71(uStack_87,local_88),local_68,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
        }
      }
      uVar21 = (undefined4)((ulonglong)in_stack_ffffffffffffff18 >> 0x20);
      uVar20 = uVar20 + 1;
      local_res10 = local_res10 + 0x5b0;
    } while (uVar20 < (ulonglong)((param_3[1] - *param_3) / 0x5b0));
  }
  uVar6 = FUN_140082620(param_2,*param_3);
  FUN_1400543f0(param_1,"\n\t// ---- forward rendering additive lights pass:\n",0x32);
  local_90 = 0x4b;
  local_b0 = 0;
  local_91 = 0x1f;
  puVar7 = (undefined8 *)FUN_140056c90(&local_b0,10);
  *puVar7 = 0x4164726177726f46;
  *(undefined2 *)(puVar7 + 1) = 0x6464;
  *(undefined1 *)((longlong)puVar7 + 10) = 0;
  if (local_91 < 0x40) {
    local_91 = 0x15;
  }
  else {
    local_a0 = 10;
  }
  local_68 = 0x4b;
  local_88 = 0;
  local_69 = 0x1f;
  puVar9 = (undefined4 *)FUN_140056c90(&local_88,7);
  *puVar9 = 0x57524f46;
  *(undefined2 *)(puVar9 + 1) = 0x5241;
  *(undefined1 *)((longlong)puVar9 + 6) = 0x44;
  *(undefined1 *)((longlong)puVar9 + 7) = 0;
  if (local_69 < 0x40) {
    local_69 = 0x18;
  }
  else {
    local_78 = 7;
  }
  FUN_140074460(param_1,param_2,&local_88,&local_b0);
  if ((local_69 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_87,local_88),local_68,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  if ((local_91 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_af,local_b0),local_90,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  FUN_1400742e0(param_1,param_2,1,uVar6);
  local_b8 = 0x4b;
  local_d8 = (undefined8 ***)((ulonglong)local_d8 & 0xffffffffffffff00);
  bVar12 = 0x1f;
  local_b9 = 0x1f;
  if (*(char *)(param_2 + 0x2b6) == '\0') {
    if (*(byte *)(param_2 + 0x207) < 0x40) {
      lVar14 = 0x1f - (longlong)*(char *)(param_2 + 0x207);
    }
    else {
      lVar14 = *(longlong *)(param_2 + 0x1f8);
    }
    if (lVar14 == 0) {
      local_d8 = (undefined8 ***)0x20616d6761727023;
      uStack_d0._0_1_ = 'm';
      uStack_d0._1_1_ = 'u';
      uStack_d0._2_1_ = 'l';
      uStack_d0._3_1_ = 't';
      uStack_d0._4_1_ = 'i';
      uStack_d0._5_1_ = '_';
      uStack_d0._6_1_ = 'c';
      uStack_d0._7_1_ = 'o';
      local_c8 = 0x6f665f656c69706d;
      local_c0 = 0xa67;
      local_be = 0;
      bVar12 = 5;
      local_b9 = 5;
    }
  }
  uVar20 = local_c8;
  if (*(char *)(param_2 + 0x2cb) == '\0') {
    uVar16 = local_c8;
    if (bVar12 < 0x40) {
      uVar16 = 0x1f - (longlong)(char)bVar12;
    }
    uVar20 = uVar16 + 0x24;
    uVar18 = uStack_d0;
    if (bVar12 < 0x40) {
      uVar18 = 0x1f;
    }
    if (uVar18 < uVar20) {
      uVar19 = uVar18 * 2;
      if (uVar18 * 2 <= uVar20) {
        uVar19 = uVar20;
      }
      ppppuVar11 = &local_d8;
      if (0x3f < bVar12) {
        ppppuVar11 = (undefined8 ****)local_d8;
      }
      if (ppppuVar11 < (undefined8 ****)0x140582661) {
        uVar18 = local_c8;
        if (bVar12 < 0x40) {
          uVar18 = 0x1f - (longlong)(char)bVar12;
        }
        if ("#pragma skip_variants INSTANCING_ON\n" < (char *)(uVar18 + (longlong)ppppuVar11)) {
          ppppuVar11 = &local_d8;
          if (0x3f < bVar12) {
            ppppuVar11 = (undefined8 ****)local_d8;
          }
          lVar14 = -(longlong)ppppuVar11;
          ppppuVar11 = (undefined8 ****)FUN_140056c90(&local_d8,uVar19);
          pcVar17 = (char *)((longlong)"#pragma skip_variants INSTANCING_ON\n" + lVar14 +
                            (longlong)ppppuVar11);
          uVar2 = *(undefined4 *)(pcVar17 + 4);
          uVar3 = *(undefined4 *)(pcVar17 + 8);
          uVar4 = *(undefined4 *)(pcVar17 + 0xc);
          pcVar1 = (char *)(uVar16 + (longlong)ppppuVar11);
          *(undefined4 *)pcVar1 = *(undefined4 *)pcVar17;
          *(undefined4 *)(pcVar1 + 4) = uVar2;
          *(undefined4 *)(pcVar1 + 8) = uVar3;
          *(undefined4 *)(pcVar1 + 0xc) = uVar4;
          uVar5 = *(undefined8 *)
                   ("#pragma skip_variants INSTANCING_ON\n" + lVar14 + 0x10 + (longlong)ppppuVar11 +
                   8);
          pcVar17 = (char *)(uVar16 + 0x10 + (longlong)ppppuVar11);
          *(undefined8 *)pcVar17 =
               *(undefined8 *)
                ("#pragma skip_variants INSTANCING_ON\n" + lVar14 + 0x10 + (longlong)ppppuVar11);
          *(undefined8 *)(pcVar17 + 8) = uVar5;
          *(undefined4 *)(uVar16 + 0x20 + (longlong)ppppuVar11) =
               *(undefined4 *)
                ("#pragma skip_variants INSTANCING_ON\n" + lVar14 + 0x20 + (longlong)ppppuVar11);
          goto LAB_14007b1fd;
        }
      }
      ppppuVar11 = (undefined8 ****)FUN_140056c90(&local_d8,uVar19);
      builtin_strncpy((char *)(uVar16 + (longlong)ppppuVar11),"#pragma skip_var",0x10);
      builtin_strncpy((char *)(uVar16 + 0x10 + (longlong)ppppuVar11),"iants INSTANCING",0x10);
      builtin_strncpy((char *)(uVar16 + 0x20 + (longlong)ppppuVar11),"_ON\n",4);
    }
    else {
      ppppuVar11 = &local_d8;
      if (0x3f < bVar12) {
        ppppuVar11 = (undefined8 ****)local_d8;
      }
      builtin_strncpy((char *)((longlong)ppppuVar11 + uVar16),"#pragma skip_var",0x10);
      builtin_strncpy((char *)((longlong)ppppuVar11 + uVar16 + 0x10),"iants INSTANCING",0x10);
      builtin_strncpy((char *)((longlong)ppppuVar11 + uVar16 + 0x20),"_ON\n",4);
    }
LAB_14007b1fd:
    *(char *)((longlong)ppppuVar11 + uVar20) = '\0';
    bVar12 = local_b9;
    if (local_b9 < 0x40) {
      local_b9 = 0x1f - (char)uVar20;
      bVar12 = local_b9;
      uVar20 = local_c8;
    }
  }
  local_c8 = uVar20;
  pcVar17 = "#pragma multi_compile_fwdadd";
  if (*(char *)(param_2 + 0x2c5) != '\0') {
    pcVar17 = "#pragma multi_compile_fwdadd_fullshadows";
  }
  lVar14 = -1;
  do {
    lVar14 = lVar14 + 1;
  } while (*(char *)((longlong)pcVar17 + lVar14) != '\0');
  uVar20 = local_c8;
  if (lVar14 == 0) goto LAB_14007b324;
  uVar16 = local_c8;
  if (bVar12 < 0x40) {
    uVar16 = 0x1f - (longlong)(char)bVar12;
  }
  uVar20 = uVar16 + lVar14;
  uVar18 = uStack_d0;
  if (bVar12 < 0x40) {
    uVar18 = 0x1f;
  }
  if (uVar18 < uVar20) {
    uVar19 = uVar18 * 2;
    if (uVar18 * 2 <= uVar20) {
      uVar19 = uVar20;
    }
    ppppuVar11 = &local_d8;
    if (0x3f < bVar12) {
      ppppuVar11 = (undefined8 ****)local_d8;
    }
    if (ppppuVar11 <= pcVar17) {
      uVar18 = local_c8;
      if (bVar12 < 0x40) {
        uVar18 = 0x1f - (longlong)(char)bVar12;
      }
      if (pcVar17 < (undefined8 ****)(uVar18 + (longlong)ppppuVar11)) {
        ppppuVar10 = &local_d8;
        if (0x3f < bVar12) {
          ppppuVar10 = (undefined8 ****)local_d8;
        }
        ppppuVar11 = (undefined8 ****)FUN_140056c90(&local_d8,uVar19);
        pcVar17 = (char *)(((longlong)pcVar17 - (longlong)ppppuVar10) + (longlong)ppppuVar11);
        goto LAB_14007b304;
      }
    }
    ppppuVar11 = (undefined8 ****)FUN_140056c90(&local_d8,uVar19);
  }
  else {
    ppppuVar11 = &local_d8;
    if (0x3f < bVar12) {
      ppppuVar11 = (undefined8 ****)local_d8;
    }
  }
LAB_14007b304:
  FUN_140558820((char *)((longlong)ppppuVar11 + uVar16),pcVar17,lVar14);
  *(char *)((longlong)ppppuVar11 + uVar20) = '\0';
  if (local_b9 < 0x40) {
    local_b9 = 0x1f - (char)uVar20;
    uVar20 = local_c8;
  }
LAB_14007b324:
  local_c8 = uVar20;
  FUN_140082b80(&local_d8,param_1,&local_60,param_2,
                CONCAT44(uVar21,*(undefined4 *)(param_2 + 0x340)),param_4);
  if ((local_b9 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(local_d8,local_b8,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  if ((local_41 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_5f,local_60),local_40,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  return;
}
```

## `GeneratePrepassFinalPasses` — `0x140079820`

prepass-final pragmas

```c
void GeneratePrepassFinalPasses
               (undefined8 param_1,longlong param_2,longlong *param_3,undefined8 param_4)

{
  char *pcVar1;
  undefined4 uVar2;
  undefined4 uVar3;
  undefined4 uVar4;
  undefined8 uVar5;
  undefined8 *puVar6;
  char *pcVar7;
  char *pcVar8;
  longlong lVar9;
  ulonglong uVar10;
  ulonglong uVar11;
  ulonglong uVar12;
  ulonglong uVar13;
  undefined8 in_stack_ffffffffffffff18;
  undefined8 uVar14;
  undefined4 uVar15;
  char local_d8;
  undefined7 uStack_d7;
  ulonglong local_d0;
  ulonglong local_c8;
  byte local_b9;
  undefined2 local_b8;
  undefined1 local_b0;
  undefined7 uStack_af;
  undefined8 local_a0;
  byte local_91;
  undefined2 local_90;
  undefined1 local_88;
  undefined7 uStack_87;
  undefined8 local_78;
  byte local_69;
  undefined2 local_68;
  undefined1 local_60;
  undefined7 uStack_5f;
  byte local_41;
  undefined2 local_40;
  
  uVar15 = (undefined4)((ulonglong)in_stack_ffffffffffffff18 >> 0x20);
  if (*(int *)(param_2 + 0x1b8) == 1) {
    return;
  }
  if (*(int *)(param_2 + 0x1b8) == 4) {
    return;
  }
  if (*(int *)(param_2 + 0x1b8) == 3) {
    if (*(byte *)(param_2 + 599) < 0x40) {
      lVar9 = 0x1f - (longlong)*(char *)(param_2 + 599);
    }
    else {
      lVar9 = *(longlong *)(param_2 + 0x248);
    }
    if (lVar9 == 0) {
      return;
    }
  }
  local_40 = 0x4b;
  local_60 = 0;
  local_41 = 0x1f;
  uVar11 = 0;
  lVar9 = param_3[1] - *param_3 >> 0x3f;
  uVar12 = uVar11;
  if ((param_3[1] - *param_3) / 0x5b0 + lVar9 != lVar9) {
    do {
      FUN_14006f140(param_3,uVar11,&local_60);
      uVar14 = param_4;
      FUN_140079e30(&local_60,param_2,uVar12 + *param_3,*param_3 + 800 + uVar12,param_4);
      uVar15 = (undefined4)((ulonglong)uVar14 >> 0x20);
      if (1 < (ulonglong)((param_3[1] - *param_3) / 0x5b0)) {
        FUN_1400543f0(&local_60,"\n\n#endif\n\n",10);
      }
      uVar11 = uVar11 + 1;
      uVar12 = uVar12 + 0x5b0;
    } while (uVar11 < (ulonglong)((param_3[1] - *param_3) / 0x5b0));
  }
  FUN_1400543f0(param_1,"\n\t// ---- deferred shading pass:\n",0x21);
  local_68 = 0x4b;
  local_88 = 0;
  local_69 = 0x1f;
  puVar6 = (undefined8 *)FUN_140056c90(&local_88,8);
  *puVar6 = 0x6465727265666544;
  *(undefined1 *)(puVar6 + 1) = 0;
  if (local_69 < 0x40) {
    local_69 = 0x17;
  }
  else {
    local_78 = 8;
  }
  local_90 = 0x4b;
  local_b0 = 0;
  local_91 = 0x1f;
  puVar6 = (undefined8 *)FUN_140056c90(&local_b0,8);
  *puVar6 = 0x4445525245464544;
  *(undefined1 *)(puVar6 + 1) = 0;
  if (local_91 < 0x40) {
    local_91 = 0x17;
  }
  else {
    local_a0 = 8;
  }
  FUN_140074460(param_1,param_2,&local_b0,&local_88);
  if ((local_91 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_af,local_b0),local_90,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  if ((local_69 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_87,local_88),local_68,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  if (*(int *)(param_2 + 0x1b8) == 3) {
    FUN_1400543f0(param_1,"\t\tZWrite Off\n\t\tBlend One One\n",0x1d);
  }
  local_b8 = 0x4b;
  local_d8 = '\0';
  local_b9 = 0x1f;
  pcVar7 = (char *)FUN_140056c90(&local_d8,0x20);
  builtin_strncpy(pcVar7,"#pragma exclude_renderers nomrt\n",0x21);
  if (local_b9 < 0x40) {
    local_b9 = 0xff;
  }
  else {
    local_c8 = 0x20;
  }
  uVar14 = *(undefined8 *)(param_2 + 0x348);
  *(ulonglong *)(param_2 + 0x348) = *(ulonglong *)(param_2 + 0x348) | 8;
  uVar12 = local_c8;
  if (local_b9 < 0x40) {
    uVar12 = 0x1f - (longlong)(char)local_b9;
  }
  uVar11 = uVar12 + 0x32;
  uVar10 = local_d0;
  if (local_b9 < 0x40) {
    uVar10 = 0x1f;
  }
  if (uVar10 < uVar11) {
    uVar13 = uVar10 * 2;
    if (uVar10 * 2 <= uVar11) {
      uVar13 = uVar11;
    }
    pcVar7 = &local_d8;
    if (0x3f < local_b9) {
      pcVar7 = (char *)CONCAT71(uStack_d7,local_d8);
    }
    if (pcVar7 < "pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2\n") {
      uVar10 = local_c8;
      if (local_b9 < 0x40) {
        uVar10 = 0x1f - (longlong)(char)local_b9;
      }
      if ("#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2\n" < pcVar7 + uVar10) {
        pcVar7 = &local_d8;
        if (0x3f < local_b9) {
          pcVar7 = (char *)CONCAT71(uStack_d7,local_d8);
        }
        lVar9 = -(longlong)pcVar7;
        pcVar8 = (char *)FUN_140056c90(&local_d8,uVar13);
        uVar5 = *(undefined8 *)
                 (pcVar8 + (longlong)"#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2\n" + lVar9 +
                 8);
        *(undefined8 *)(pcVar8 + uVar12) =
             *(undefined8 *)
              (pcVar8 + (longlong)"#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2\n" + lVar9);
        *(undefined8 *)(pcVar8 + uVar12 + 8) = uVar5;
        pcVar7 = pcVar8 + (longlong)
                          ("#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2\n" + lVar9 + 0x10);
        uVar2 = *(undefined4 *)(pcVar7 + 4);
        uVar3 = *(undefined4 *)(pcVar7 + 8);
        uVar4 = *(undefined4 *)(pcVar7 + 0xc);
        pcVar1 = pcVar8 + uVar12 + 0x10;
        *(undefined4 *)pcVar1 = *(undefined4 *)pcVar7;
        *(undefined4 *)(pcVar1 + 4) = uVar2;
        *(undefined4 *)(pcVar1 + 8) = uVar3;
        *(undefined4 *)(pcVar1 + 0xc) = uVar4;
        pcVar7 = pcVar8 + (longlong)
                          ("#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2\n" + lVar9 + 0x20);
        uVar2 = *(undefined4 *)(pcVar7 + 4);
        uVar3 = *(undefined4 *)(pcVar7 + 8);
        uVar4 = *(undefined4 *)(pcVar7 + 0xc);
        pcVar1 = pcVar8 + uVar12 + 0x20;
        *(undefined4 *)pcVar1 = *(undefined4 *)pcVar7;
        *(undefined4 *)(pcVar1 + 4) = uVar2;
        *(undefined4 *)(pcVar1 + 8) = uVar3;
        *(undefined4 *)(pcVar1 + 0xc) = uVar4;
        *(undefined2 *)(pcVar8 + uVar12 + 0x30) =
             *(undefined2 *)
              (pcVar8 + (longlong)
                        ("#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2\n" + lVar9 + 0x30));
        goto LAB_140079c51;
      }
    }
    pcVar8 = (char *)FUN_140056c90(&local_d8,uVar13);
    builtin_strncpy(pcVar8 + uVar12,"#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2\n",0x32);
  }
  else {
    pcVar8 = &local_d8;
    if (0x3f < local_b9) {
      pcVar8 = (char *)CONCAT71(uStack_d7,local_d8);
    }
    builtin_strncpy(pcVar8 + uVar12,"#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2\n",0x32);
  }
LAB_140079c51:
  pcVar8[uVar11] = '\0';
  if (local_b9 < 0x40) {
    local_b9 = 0x1f - (char)uVar11;
    uVar11 = local_c8;
  }
  local_c8 = uVar11;
  uVar12 = local_c8;
  if (local_b9 < 0x40) {
    uVar12 = 0x1f - (longlong)(char)local_b9;
  }
  uVar11 = uVar12 + 0x22;
  if (local_b9 < 0x40) {
    local_d0 = 0x1f;
  }
  if (local_d0 < uVar11) {
    uVar10 = local_d0 * 2;
    if (local_d0 * 2 <= uVar11) {
      uVar10 = uVar11;
    }
    pcVar7 = &local_d8;
    if (0x3f < local_b9) {
      pcVar7 = (char *)CONCAT71(uStack_d7,local_d8);
    }
    if (pcVar7 < "pragma multi_compile_prepassfinal") {
      uVar13 = local_c8;
      if (local_b9 < 0x40) {
        uVar13 = 0x1f - (longlong)(char)local_b9;
      }
      if ("#pragma multi_compile_prepassfinal" < pcVar7 + uVar13) {
        pcVar7 = &local_d8;
        if (0x3f < local_b9) {
          pcVar7 = (char *)CONCAT71(uStack_d7,local_d8);
        }
        lVar9 = -(longlong)pcVar7;
        pcVar8 = (char *)FUN_140056c90(&local_d8,uVar10);
        pcVar7 = pcVar8 + (longlong)"#pragma multi_compile_prepassfinal" + lVar9;
        uVar2 = *(undefined4 *)(pcVar7 + 4);
        uVar3 = *(undefined4 *)(pcVar7 + 8);
        uVar4 = *(undefined4 *)(pcVar7 + 0xc);
        pcVar1 = pcVar8 + uVar12;
        *(undefined4 *)pcVar1 = *(undefined4 *)pcVar7;
        *(undefined4 *)(pcVar1 + 4) = uVar2;
        *(undefined4 *)(pcVar1 + 8) = uVar3;
        *(undefined4 *)(pcVar1 + 0xc) = uVar4;
        pcVar7 = pcVar8 + (longlong)("#pragma multi_compile_prepassfinal" + lVar9 + 0x10);
        uVar2 = *(undefined4 *)(pcVar7 + 4);
        uVar3 = *(undefined4 *)(pcVar7 + 8);
        uVar4 = *(undefined4 *)(pcVar7 + 0xc);
        pcVar1 = pcVar8 + uVar12 + 0x10;
        *(undefined4 *)pcVar1 = *(undefined4 *)pcVar7;
        *(undefined4 *)(pcVar1 + 4) = uVar2;
        *(undefined4 *)(pcVar1 + 8) = uVar3;
        *(undefined4 *)(pcVar1 + 0xc) = uVar4;
        *(undefined2 *)(pcVar8 + uVar12 + 0x20) =
             *(undefined2 *)
              (pcVar8 + (longlong)("#pragma multi_compile_prepassfinal" + lVar9 + 0x20));
        goto LAB_140079d7f;
      }
    }
    pcVar8 = (char *)FUN_140056c90(&local_d8,uVar10);
    builtin_strncpy(pcVar8 + uVar12,"#pragma multi_compile_prepassfinal",0x22);
  }
  else {
    pcVar8 = &local_d8;
    if (0x3f < local_b9) {
      pcVar8 = (char *)CONCAT71(uStack_d7,local_d8);
    }
    builtin_strncpy(pcVar8 + uVar12,"#pragma multi_compile_prepassfinal",0x22);
  }
LAB_140079d7f:
  pcVar8[uVar11] = '\0';
  if (local_b9 < 0x40) {
    local_b9 = 0x1f - (char)uVar11;
    uVar11 = local_c8;
  }
  local_c8 = uVar11;
  FUN_140082b80(&local_d8,param_1,&local_60,param_2,
                CONCAT44(uVar15,*(undefined4 *)(param_2 + 0x340)),param_4);
  *(undefined8 *)(param_2 + 0x348) = uVar14;
  if ((local_b9 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_d7,local_d8),local_b8,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  if ((local_41 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_5f,local_60),local_40,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  return;
}
```

## `GenerateSurfaceAdditionalPass` — `0x14007deb0`

additional pass emitter

```c
void GenerateSurfaceAdditionalPass
               (undefined8 param_1,longlong param_2,longlong *param_3,undefined8 param_4)

{
  char *pcVar1;
  char *pcVar2;
  longlong lVar3;
  undefined4 uVar4;
  undefined4 uVar5;
  undefined4 uVar6;
  undefined4 *puVar7;
  char *pcVar8;
  ulonglong uVar9;
  ulonglong uVar10;
  ulonglong uVar11;
  ulonglong uVar12;
  undefined8 in_stack_ffffffffffffff28;
  undefined8 uVar13;
  undefined4 uVar14;
  char local_c8;
  undefined7 uStack_c7;
  ulonglong local_c0;
  ulonglong local_b8;
  byte local_a9;
  undefined2 local_a8;
  undefined1 local_a0;
  undefined7 uStack_9f;
  undefined8 local_90;
  byte local_81;
  undefined2 local_80;
  undefined1 local_78;
  undefined7 uStack_77;
  undefined8 local_68;
  byte local_59;
  undefined2 local_58;
  undefined1 local_50;
  undefined7 uStack_4f;
  byte local_31;
  undefined2 local_30;
  
  uVar14 = (undefined4)((ulonglong)in_stack_ffffffffffffff28 >> 0x20);
  local_30 = 0x4b;
  local_50 = 0;
  local_31 = 0x1f;
  uVar10 = 0;
  lVar3 = param_3[1] - *param_3 >> 0x3f;
  uVar11 = uVar10;
  if ((param_3[1] - *param_3) / 0x5b0 + lVar3 != lVar3) {
    do {
      FUN_14006f140(param_3,uVar11,&local_50);
      uVar13 = param_4;
      FUN_14007e320(&local_50,param_2,uVar10 + *param_3,*param_3 + 0x4c0 + uVar10,param_4);
      uVar14 = (undefined4)((ulonglong)uVar13 >> 0x20);
      if (1 < (ulonglong)((param_3[1] - *param_3) / 0x5b0)) {
        FUN_1400543f0(&local_50,"\n\n#endif\n\n",10);
      }
      uVar11 = uVar11 + 1;
      uVar10 = uVar10 + 0x5b0;
    } while (uVar11 < (ulonglong)((param_3[1] - *param_3) / 0x5b0));
  }
  FUN_1400543f0(param_1,"\n\t// ---- meta information extraction pass:\n",0x2c);
  local_58 = 0x4b;
  local_78 = 0;
  local_59 = 0x1f;
  puVar7 = (undefined4 *)FUN_140056c90(&local_78,4);
  *puVar7 = 0x6174654d;
  *(undefined1 *)(puVar7 + 1) = 0;
  if (local_59 < 0x40) {
    local_59 = 0x1b;
  }
  else {
    local_68 = 4;
  }
  local_80 = 0x4b;
  local_a0 = 0;
  local_81 = 0x1f;
  puVar7 = (undefined4 *)FUN_140056c90(&local_a0,4);
  *puVar7 = 0x6174654d;
  *(undefined1 *)(puVar7 + 1) = 0;
  if (local_81 < 0x40) {
    local_81 = 0x1b;
  }
  else {
    local_90 = 4;
  }
  FUN_140074460(param_1,param_2,&local_a0,&local_78);
  if ((local_81 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_9f,local_a0),local_80,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  if ((local_59 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_77,local_78),local_58,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  FUN_1400543f0(param_1,"\t\tCull Off\n",0xb);
  local_a8 = 0x4b;
  local_c8 = '\0';
  local_a9 = 0x1f;
  pcVar8 = (char *)FUN_140056c90(&local_c8,0x32);
  builtin_strncpy(pcVar8,"#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2\n",0x33);
  if (local_a9 < 0x40) {
    local_a9 = 0xed;
  }
  else {
    local_b8 = 0x32;
  }
  uVar11 = local_b8;
  if (local_a9 < 0x40) {
    uVar11 = 0x1f - (longlong)(char)local_a9;
  }
  uVar10 = uVar11 + 0x2c;
  if (local_a9 < 0x40) {
    local_c0 = 0x1f;
  }
  if (local_c0 < uVar10) {
    uVar12 = local_c0 * 2;
    if (local_c0 * 2 <= uVar10) {
      uVar12 = uVar10;
    }
    pcVar8 = &local_c8;
    if (0x3f < local_a9) {
      pcVar8 = (char *)CONCAT71(uStack_c7,local_c8);
    }
    if (pcVar8 <= "#pragma shader_feature EDITOR_VISUALIZATION\n") {
      uVar9 = local_b8;
      if (local_a9 < 0x40) {
        uVar9 = 0x1f - (longlong)(char)local_a9;
      }
      if ("pragma shader_feature EDITOR_VISUALIZATION\n" <= pcVar8 + uVar9) {
        pcVar8 = &local_c8;
        if (0x3f < local_a9) {
          pcVar8 = (char *)CONCAT71(uStack_c7,local_c8);
        }
        lVar3 = -(longlong)pcVar8;
        pcVar8 = (char *)FUN_140056c90(&local_c8,uVar12);
        uVar13 = *(undefined8 *)
                  (pcVar8 + (longlong)"#pragma shader_feature EDITOR_VISUALIZATION\n" + lVar3 + 8);
        *(undefined8 *)(pcVar8 + uVar11) =
             *(undefined8 *)
              (pcVar8 + (longlong)"#pragma shader_feature EDITOR_VISUALIZATION\n" + lVar3);
        *(undefined8 *)(pcVar8 + uVar11 + 8) = uVar13;
        pcVar1 = pcVar8 + (longlong)("#pragma shader_feature EDITOR_VISUALIZATION\n" + lVar3 + 0x10)
        ;
        uVar4 = *(undefined4 *)(pcVar1 + 4);
        uVar5 = *(undefined4 *)(pcVar1 + 8);
        uVar6 = *(undefined4 *)(pcVar1 + 0xc);
        pcVar2 = pcVar8 + uVar11 + 0x10;
        *(undefined4 *)pcVar2 = *(undefined4 *)pcVar1;
        *(undefined4 *)(pcVar2 + 4) = uVar4;
        *(undefined4 *)(pcVar2 + 8) = uVar5;
        *(undefined4 *)(pcVar2 + 0xc) = uVar6;
        *(undefined8 *)(pcVar8 + uVar11 + 0x20) =
             *(undefined8 *)
              (pcVar8 + (longlong)("#pragma shader_feature EDITOR_VISUALIZATION\n" + lVar3 + 0x20));
        *(undefined4 *)(pcVar8 + uVar11 + 0x28) =
             *(undefined4 *)
              (pcVar8 + (longlong)("#pragma shader_feature EDITOR_VISUALIZATION\n" + lVar3 + 0x28));
        goto LAB_14007e26f;
      }
    }
    pcVar8 = (char *)FUN_140056c90(&local_c8,uVar12);
    builtin_strncpy(pcVar8 + uVar11,"#pragma shader_feature EDITOR_VISUALIZATION\n",0x2c);
  }
  else {
    pcVar8 = &local_c8;
    if (0x3f < local_a9) {
      pcVar8 = (char *)CONCAT71(uStack_c7,local_c8);
    }
    builtin_strncpy(pcVar8 + uVar11,"#pragma shader_feature EDITOR_VISUALIZATION\n",0x2c);
  }
LAB_14007e26f:
  pcVar8[uVar10] = '\0';
  if (local_a9 < 0x40) {
    local_a9 = 0x1f - (char)uVar10;
    uVar10 = local_b8;
  }
  local_b8 = uVar10;
  FUN_140082b80(&local_c8,param_1,&local_50,param_2,
                CONCAT44(uVar14,*(undefined4 *)(param_2 + 0x340)),param_4);
  if ((local_a9 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_c7,local_c8),local_a8,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  if ((local_31 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_4f,local_50),local_30,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  return;
}
```

## `GenerateSurfaceStructWrapper` — `0x140085d60`

reflected `surfInput`/`surfOutput` to HLSL wrapper

```c
/* Rewrites a reflected surface struct into HLSL for the generated wrapper (surfInput / surfOutput,
   "_hlslin_.%s", "_Semantic_"). */

void GenerateSurfaceStructWrapper
               (undefined8 param_1,undefined8 param_2,undefined8 param_3,undefined4 param_4,
               longlong param_5,undefined8 param_6)

{
  char cVar1;
  char cVar2;
  int iVar3;
  longlong *plVar4;
  char *pcVar5;
  longlong *plVar6;
  undefined8 *puVar7;
  char *pcVar8;
  ulonglong uVar9;
  undefined8 uVar10;
  undefined1 *puVar11;
  longlong lVar12;
  ulonglong uVar13;
  byte bVar14;
  undefined4 uVar15;
  longlong lVar16;
  char *pcVar17;
  uint uVar18;
  char local_308;
  uint7 uStack_307;
  longlong local_2f8;
  byte local_2e9;
  undefined2 local_2e8;
  undefined1 local_2e0;
  undefined7 uStack_2df;
  ulonglong local_2d0;
  byte local_2c1;
  undefined2 local_2c0;
  longlong *local_2b0;
  undefined1 local_2a8;
  undefined7 uStack_2a7;
  longlong local_298;
  byte local_289;
  undefined2 local_288;
  undefined1 *local_280;
  longlong local_278;
  undefined1 *local_270;
  ulonglong local_268;
  char *local_260;
  longlong local_258;
  undefined1 *local_250;
  longlong local_248;
  undefined1 *local_240;
  ulonglong local_238;
  char *local_230;
  longlong local_228;
  uint local_220;
  int local_21c;
  int local_218;
  int local_214;
  char *local_200;
  undefined1 *local_1f8;
  longlong local_1f0;
  undefined1 local_1e8 [8];
  int local_1e0;
  uint local_1dc;
  longlong local_1d0 [2];
  byte local_1c0;
  undefined8 local_1a0 [3];
  byte local_181;
  undefined2 local_180;
  undefined8 local_178 [3];
  byte local_159;
  undefined2 local_158;
  undefined1 local_150 [136];
  undefined1 local_c8 [160];
  
  local_2b0 = (longlong *)0x0;
  plVar4 = (longlong *)(**(code **)*DAT_14074ece0)();
  iVar3 = (**(code **)(*plVar4 + 0x38))(plVar4,param_1,param_2,&local_2b0);
  if (iVar3 < 0) {
    local_2c0 = 0x4b;
    local_2e0 = 0;
    local_2c1 = 0x1f;
    pcVar5 = (char *)FUN_140056c90(&local_2e0,0x27);
    builtin_strncpy(pcVar5,"Failed to get HLSL Reflection interface",0x28);
    if (local_2c1 < 0x40) {
      local_2c1 = 0xf8;
    }
    else {
      local_2d0 = 0x27;
    }
    FUN_140089820(param_6,&local_2e0,param_4,0,4);
    if ((local_2c1 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(uStack_2df,local_2e0),local_2c0,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
  }
  else {
    (**(code **)(*local_2b0 + 0x18))(local_2b0,local_c8);
    plVar4 = (longlong *)(**(code **)(*local_2b0 + 0x28))(local_2b0,"SurfShaderGlobals");
    if ((((plVar4 != (longlong *)0x0) &&
         (iVar3 = (**(code **)*plVar4)(plVar4,local_1e8), -1 < iVar3)) && (local_1e0 == 0)) &&
       (uVar18 = 0, local_1dc != 0)) {
      do {
        uVar15 = 0;
        plVar6 = (longlong *)(**(code **)(*plVar4 + 8))(plVar4,uVar18);
        (**(code **)*plVar6)(plVar6,local_1d0);
        if ((local_1c0 & 2) != 0) {
          puVar7 = (undefined8 *)(**(code **)(*plVar6 + 8))(plVar6);
          (**(code **)*puVar7)(puVar7,&local_220);
          local_2e8 = 0x4b;
          local_308 = '\0';
          local_2e9 = 0x1f;
          if (((local_21c == 3) && (local_220 < 2)) && (local_218 == 1)) {
            if ((local_200 == (char *)0x0) ||
               (cVar1 = FUN_1400e02f0(local_200,&DAT_140577ef0), cVar1 == '\0')) {
              if (local_214 != 1) {
                if (local_214 != 2) {
                  if (local_214 != 3) {
                    if (local_214 != 4) goto LAB_14008635a;
                    if ((local_2e9 & 0xc0) == 0x80) {
                      local_308 = '\0';
                      local_2e9 = 0x1f;
                    }
                    pcVar5 = (char *)CONCAT71(uStack_307,local_308);
                    pcVar8 = &local_308;
                    if (0x3f < local_2e9) {
                      pcVar8 = pcVar5;
                    }
                    if ("float4" < pcVar8) {
LAB_1400866f9:
                      bVar14 = local_2e9 >> 6;
                      if (bVar14 == 0) {
LAB_14008670d:
                        local_308 = '\0';
                        local_2e9 = 0x1f;
                      }
                      else if (bVar14 == 1) {
                        *pcVar5 = '\0';
                        local_2f8 = 0;
                      }
                      else if (bVar14 == 2) goto LAB_14008670d;
                      pcVar8 = (char *)FUN_140056c90(&local_308,6);
                      builtin_strncpy(pcVar8,"float4",6);
                    }
                    else {
                      lVar16 = local_2f8;
                      if (local_2e9 < 0x40) {
                        lVar16 = 0x1f - (longlong)(char)local_2e9;
                      }
                      if (pcVar8 + lVar16 < "loat4") goto LAB_1400866f9;
                      pcVar8 = &local_308;
                      if (0x3f < local_2e9) {
                        pcVar8 = pcVar5;
                      }
                      FUN_140558820(pcVar8,&DAT_14057d888,6);
                    }
                    pcVar8[6] = '\0';
                    if (local_2e9 < 0x40) {
                      local_2e9 = 0x19;
                      uVar15 = 3;
                    }
                    else {
                      local_2f8 = 6;
                      uVar15 = 3;
                    }
                    goto LAB_140086838;
                  }
                  if ((local_2e9 & 0xc0) == 0x80) {
                    local_308 = '\0';
                    local_2e9 = 0x1f;
                  }
                  pcVar5 = (char *)CONCAT71(uStack_307,local_308);
                  pcVar8 = &local_308;
                  if (0x3f < local_2e9) {
                    pcVar8 = pcVar5;
                  }
                  if ("float3" < pcVar8) {
LAB_140086604:
                    bVar14 = local_2e9 >> 6;
                    if (bVar14 == 0) {
LAB_140086618:
                      local_308 = '\0';
                      local_2e9 = 0x1f;
                    }
                    else if (bVar14 == 1) {
                      *pcVar5 = '\0';
                      local_2f8 = 0;
                    }
                    else if (bVar14 == 2) goto LAB_140086618;
                    pcVar8 = (char *)FUN_140056c90(&local_308,6);
                    builtin_strncpy(pcVar8,"float3",6);
                  }
                  else {
                    lVar16 = local_2f8;
                    if (local_2e9 < 0x40) {
                      lVar16 = 0x1f - (longlong)(char)local_2e9;
                    }
                    if (pcVar8 + lVar16 < "loat3") goto LAB_140086604;
                    pcVar8 = &local_308;
                    if (0x3f < local_2e9) {
                      pcVar8 = pcVar5;
                    }
                    FUN_140558820(pcVar8,&DAT_14057d880,6);
                  }
                  pcVar8[6] = '\0';
                  if (local_2e9 < 0x40) {
                    local_2e9 = 0x19;
                    uVar15 = 2;
                  }
                  else {
                    local_2f8 = 6;
                    uVar15 = 2;
                  }
                  goto LAB_140086838;
                }
                if ((local_2e9 & 0xc0) == 0x80) {
                  local_308 = '\0';
                  local_2e9 = 0x1f;
                }
                pcVar5 = (char *)CONCAT71(uStack_307,local_308);
                pcVar8 = &local_308;
                if (0x3f < local_2e9) {
                  pcVar8 = pcVar5;
                }
                if ("float2" < pcVar8) {
LAB_14008650f:
                  bVar14 = local_2e9 >> 6;
                  if (bVar14 == 0) {
LAB_140086523:
                    local_308 = '\0';
                    local_2e9 = 0x1f;
                  }
                  else if (bVar14 == 1) {
                    *pcVar5 = '\0';
                    local_2f8 = 0;
                  }
                  else if (bVar14 == 2) goto LAB_140086523;
                  pcVar8 = (char *)FUN_140056c90(&local_308,6);
                  builtin_strncpy(pcVar8,"float2",6);
                }
                else {
                  lVar16 = local_2f8;
                  if (local_2e9 < 0x40) {
                    lVar16 = 0x1f - (longlong)(char)local_2e9;
                  }
                  if (pcVar8 + lVar16 < "loat2") goto LAB_14008650f;
                  pcVar8 = &local_308;
                  if (0x3f < local_2e9) {
                    pcVar8 = pcVar5;
                  }
                  FUN_140558820(pcVar8,&DAT_14057d878,6);
                }
                pcVar8[6] = '\0';
                if (local_2e9 < 0x40) {
                  local_2e9 = 0x19;
                  uVar15 = 1;
                }
                else {
                  local_2f8 = 6;
                  uVar15 = 1;
                }
                goto LAB_140086838;
              }
              if ((local_2e9 & 0xc0) == 0x80) {
                local_308 = '\0';
                local_2e9 = 0x1f;
              }
              pcVar5 = (char *)CONCAT71(uStack_307,local_308);
              pcVar8 = &local_308;
              if (0x3f < local_2e9) {
                pcVar8 = pcVar5;
              }
              if ("float" < pcVar8) {
LAB_140086425:
                bVar14 = local_2e9 >> 6;
                if (bVar14 == 0) {
LAB_140086439:
                  local_308 = '\0';
                  local_2e9 = 0x1f;
                }
                else if (bVar14 == 1) {
                  *pcVar5 = '\0';
                  local_2f8 = 0;
                }
                else if (bVar14 == 2) goto LAB_140086439;
                pcVar8 = (char *)FUN_140056c90(&local_308,5);
                builtin_strncpy(pcVar8,"float",5);
              }
              else {
                lVar16 = local_2f8;
                if (local_2e9 < 0x40) {
                  lVar16 = 0x1f - (longlong)(char)local_2e9;
                }
                if (pcVar8 + lVar16 < "loat") goto LAB_140086425;
                pcVar8 = &local_308;
                if (0x3f < local_2e9) {
                  pcVar8 = pcVar5;
                }
                FUN_140558820(pcVar8,"float",5);
              }
              pcVar8[5] = '\0';
              if (local_2e9 < 0x40) {
                local_2e9 = 0x1a;
              }
              else {
                local_2f8 = 5;
              }
            }
            else if (local_214 == 1) {
              if ((local_2e9 & 0xc0) == 0x80) {
                local_308 = '\0';
                local_2e9 = 0x1f;
              }
              pcVar5 = (char *)CONCAT71(uStack_307,local_308);
              pcVar8 = &local_308;
              if (0x3f < local_2e9) {
                pcVar8 = pcVar5;
              }
              if ("half" < pcVar8) {
LAB_140085fff:
                bVar14 = local_2e9 >> 6;
                if (bVar14 == 0) {
LAB_140086013:
                  local_308 = '\0';
                  local_2e9 = 0x1f;
                }
                else if (bVar14 == 1) {
                  *pcVar5 = '\0';
                  local_2f8 = 0;
                }
                else if (bVar14 == 2) goto LAB_140086013;
                pcVar8 = (char *)FUN_140056c90(&local_308,4);
              }
              else {
                lVar16 = local_2f8;
                if (local_2e9 < 0x40) {
                  lVar16 = 0x1f - (longlong)(char)local_2e9;
                }
                if (pcVar8 + lVar16 < "alf") goto LAB_140085fff;
                pcVar8 = &local_308;
                if (0x3f < local_2e9) {
                  pcVar8 = pcVar5;
                }
              }
              builtin_strncpy(pcVar8,"half",5);
              if (local_2e9 < 0x40) {
                local_2e9 = 0x1b;
                uVar15 = 4;
              }
              else {
                local_2f8 = 4;
                uVar15 = 4;
              }
            }
            else {
              if (local_214 != 2) {
                if (local_214 != 3) {
                  if (local_214 != 4) goto LAB_14008635a;
                  if ((local_2e9 & 0xc0) == 0x80) {
                    local_308 = '\0';
                    local_2e9 = 0x1f;
                  }
                  pcVar5 = (char *)CONCAT71(uStack_307,local_308);
                  pcVar8 = &local_308;
                  if (0x3f < local_2e9) {
                    pcVar8 = pcVar5;
                  }
                  if ("half4" < pcVar8) {
LAB_1400862db:
                    bVar14 = local_2e9 >> 6;
                    if (bVar14 == 0) {
LAB_1400862ef:
                      local_308 = '\0';
                      local_2e9 = 0x1f;
                    }
                    else if (bVar14 == 1) {
                      *pcVar5 = '\0';
                      local_2f8 = 0;
                    }
                    else if (bVar14 == 2) goto LAB_1400862ef;
                    pcVar8 = (char *)FUN_140056c90(&local_308,5);
                    builtin_strncpy(pcVar8,"half4",5);
                  }
                  else {
                    lVar16 = local_2f8;
                    if (local_2e9 < 0x40) {
                      lVar16 = 0x1f - (longlong)(char)local_2e9;
                    }
                    if (pcVar8 + lVar16 < "alf4") goto LAB_1400862db;
                    pcVar8 = &local_308;
                    if (0x3f < local_2e9) {
                      pcVar8 = pcVar5;
                    }
                    FUN_140558820(pcVar8,&DAT_14057d8b8,5);
                  }
                  pcVar8[5] = '\0';
                  if (local_2e9 < 0x40) {
                    local_2e9 = 0x1a;
                    uVar15 = 7;
                  }
                  else {
                    local_2f8 = 5;
                    uVar15 = 7;
                  }
                  goto LAB_140086838;
                }
                if ((local_2e9 & 0xc0) == 0x80) {
                  local_308 = '\0';
                  local_2e9 = 0x1f;
                }
                pcVar5 = (char *)CONCAT71(uStack_307,local_308);
                pcVar8 = &local_308;
                if (0x3f < local_2e9) {
                  pcVar8 = pcVar5;
                }
                if ("half3" < pcVar8) {
LAB_1400861e2:
                  bVar14 = local_2e9 >> 6;
                  if (bVar14 == 0) {
LAB_1400861f6:
                    local_308 = '\0';
                    local_2e9 = 0x1f;
                  }
                  else if (bVar14 == 1) {
                    *pcVar5 = '\0';
                    local_2f8 = 0;
                  }
                  else if (bVar14 == 2) goto LAB_1400861f6;
                  pcVar8 = (char *)FUN_140056c90(&local_308,5);
                  builtin_strncpy(pcVar8,"half3",5);
                }
                else {
                  lVar16 = local_2f8;
                  if (local_2e9 < 0x40) {
                    lVar16 = 0x1f - (longlong)(char)local_2e9;
                  }
                  if (pcVar8 + lVar16 < (char *)((longlong)&DAT_14057d8a0 + 1)) goto LAB_1400861e2;
                  pcVar8 = &local_308;
                  if (0x3f < local_2e9) {
                    pcVar8 = pcVar5;
                  }
                  FUN_140558820(pcVar8,&DAT_14057d8a0,5);
                }
                pcVar8[5] = '\0';
                if (local_2e9 < 0x40) {
                  local_2e9 = 0x1a;
                  uVar15 = 6;
                }
                else {
                  local_2f8 = 5;
                  uVar15 = 6;
                }
                goto LAB_140086838;
              }
              if ((local_2e9 & 0xc0) == 0x80) {
                local_308 = '\0';
                local_2e9 = 0x1f;
              }
              pcVar5 = (char *)CONCAT71(uStack_307,local_308);
              pcVar8 = &local_308;
              if (0x3f < local_2e9) {
                pcVar8 = pcVar5;
              }
              if ("half2" < pcVar8) {
LAB_1400860e9:
                bVar14 = local_2e9 >> 6;
                if (bVar14 == 0) {
LAB_1400860fd:
                  local_308 = '\0';
                  local_2e9 = 0x1f;
                }
                else if (bVar14 == 1) {
                  *pcVar5 = '\0';
                  local_2f8 = 0;
                }
                else if (bVar14 == 2) goto LAB_1400860fd;
                pcVar8 = (char *)FUN_140056c90(&local_308,5);
                builtin_strncpy(pcVar8,"half2",5);
              }
              else {
                lVar16 = local_2f8;
                if (local_2e9 < 0x40) {
                  lVar16 = 0x1f - (longlong)(char)local_2e9;
                }
                if (pcVar8 + lVar16 < "alf2") goto LAB_1400860e9;
                pcVar8 = &local_308;
                if (0x3f < local_2e9) {
                  pcVar8 = pcVar5;
                }
                FUN_140558820(pcVar8,&DAT_14057d890,5);
              }
              pcVar8[5] = '\0';
              if (local_2e9 < 0x40) {
                local_2e9 = 0x1a;
                uVar15 = 5;
              }
              else {
                local_2f8 = 5;
                uVar15 = 5;
              }
            }
          }
          else {
LAB_14008635a:
            pcVar5 = "<other>";
            if (local_200 != (char *)0x0) {
              pcVar5 = local_200;
            }
            lVar16 = -1;
            do {
              lVar16 = lVar16 + 1;
            } while (pcVar5[lVar16] != '\0');
            if ((local_2e9 & 0xc0) == 0x80) {
              local_308 = '\0';
              local_2e9 = 0x1f;
              pcVar8 = &local_308;
              pcVar17 = (char *)((ulonglong)uStack_307 << 8);
            }
            else if (local_2e9 < 0x40) {
              pcVar8 = &local_308;
              pcVar17 = (char *)CONCAT71(uStack_307,local_308);
            }
            else {
              pcVar8 = (char *)CONCAT71(uStack_307,local_308);
              pcVar17 = pcVar8;
            }
            if (pcVar5 < pcVar8) {
LAB_1400867cf:
              bVar14 = local_2e9 >> 6;
              if (bVar14 == 0) {
LAB_1400867e3:
                local_308 = '\0';
                local_2e9 = 0x1f;
              }
              else if (bVar14 == 1) {
                *pcVar17 = '\0';
                local_2f8 = 0;
              }
              else if (bVar14 == 2) goto LAB_1400867e3;
              pcVar8 = (char *)FUN_140056c90(&local_308,lVar16);
              FUN_140558820(pcVar8,pcVar5,lVar16);
            }
            else {
              lVar12 = local_2f8;
              if (local_2e9 < 0x40) {
                lVar12 = 0x1f - (longlong)(char)local_2e9;
              }
              if (pcVar8 + lVar12 <= pcVar5) goto LAB_1400867cf;
              pcVar8 = &local_308;
              if (0x3f < local_2e9) {
                pcVar8 = pcVar17;
              }
              FUN_140558820(pcVar8,pcVar5,lVar16);
            }
            pcVar8[lVar16] = '\0';
            if (local_2e9 < 0x40) {
              local_2e9 = 0x1f - (char)lVar16;
              lVar16 = local_2f8;
            }
            local_2f8 = lVar16;
            uVar15 = 0xd;
          }
LAB_140086838:
          cVar1 = FUN_1400e02f0(local_1d0[0],"surfInput");
          cVar2 = FUN_1400e02f0(local_1d0[0],"surfInputOut");
          if ((cVar1 != '\0') || (cVar2 != '\0')) {
            lVar16 = 9;
            if (cVar2 != '\0') {
              lVar16 = 0xc;
            }
            FUN_1400e0f60(&local_2e0,"_hlslin_.%s",lVar16 + local_1d0[0]);
            local_288 = 0x4b;
            local_2a8 = 0;
            local_289 = 0x1f;
            uVar9 = FUN_140056850(&local_2e0,"_Semantic_",0,10);
            bVar14 = 0x1f;
            if (uVar9 != 0xffffffffffffffff) {
              uVar13 = local_2d0;
              if (local_2c1 < 0x40) {
                uVar13 = 0x1f - (longlong)(char)local_2c1;
              }
              local_1f8 = &local_2e0;
              if (0x3f < local_2c1) {
                local_1f8 = (undefined1 *)CONCAT71(uStack_2df,local_2e0);
              }
              local_1f0 = uVar13 - (uVar9 + 10);
              local_1f8 = local_1f8 + uVar9 + 10;
              FUN_140014b30(local_1a0,&local_1f8,0x4b);
              uVar10 = FUN_140082020(local_178,local_1a0);
              FUN_1400545d0(&local_2a8,uVar10);
              if ((local_159 & 0xc0) == 0x40) {
                thunk_FUN_1403f2404(local_178[0],local_158,
                                    "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                    ,0x218);
              }
              if ((local_181 & 0xc0) == 0x40) {
                thunk_FUN_1403f2404(local_1a0[0],local_180,
                                    "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                    ,0x218);
              }
              uVar13 = local_2d0;
              if (local_2c1 < 0x40) {
                uVar13 = 0x1f - (longlong)(char)local_2c1;
              }
              puVar11 = &local_2e0;
              if (0x3f < local_2c1) {
                puVar11 = (undefined1 *)CONCAT71(uStack_2df,local_2e0);
              }
              if (uVar9 < uVar13) {
                uVar13 = uVar9;
              }
              FUN_140054780(&local_2e0,puVar11,uVar13);
              bVar14 = local_289;
            }
            local_278 = local_298;
            if (bVar14 < 0x40) {
              local_278 = 0x1f - (longlong)(char)bVar14;
            }
            local_280 = &local_2a8;
            if (0x3f < bVar14) {
              local_280 = (undefined1 *)CONCAT71(uStack_2a7,local_2a8);
            }
            local_268 = local_2d0;
            if (local_2c1 < 0x40) {
              local_268 = 0x1f - (longlong)(char)local_2c1;
            }
            local_270 = &local_2e0;
            if (0x3f < local_2c1) {
              local_270 = (undefined1 *)CONCAT71(uStack_2df,local_2e0);
            }
            local_258 = local_2f8;
            if (local_2e9 < 0x40) {
              local_258 = 0x1f - (longlong)(char)local_2e9;
            }
            local_260 = &local_308;
            if (0x3f < local_2e9) {
              local_260 = (char *)CONCAT71(uStack_307,local_308);
            }
            uVar10 = FUN_140066aa0(local_150,&local_260,&local_270,&local_280,uVar15,0,9);
            if (*(longlong *)(param_5 + 8) == *(longlong *)(param_5 + 0x10)) {
              FUN_140065740(param_5,*(longlong *)(param_5 + 8),uVar10);
            }
            else {
              FUN_140066420();
              *(longlong *)(param_5 + 8) = *(longlong *)(param_5 + 8) + 0x88;
            }
            FUN_1400194f0(local_150);
            if ((local_289 & 0xc0) == 0x40) {
              thunk_FUN_1403f2404(CONCAT71(uStack_2a7,local_2a8),local_288,
                                  "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                  ,0x218);
            }
            if ((local_2c1 & 0xc0) == 0x40) {
              thunk_FUN_1403f2404(CONCAT71(uStack_2df,local_2e0),local_2c0,
                                  "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                  ,0x218);
            }
          }
          cVar1 = FUN_1400e02f0(local_1d0[0],"surfOutput");
          if (cVar1 != '\0') {
            FUN_1400e0f60(&local_2e0,"_hlslout_.%s",local_1d0[0] + 10);
            local_288 = 0x4b;
            local_2a8 = 0;
            local_289 = 0x1f;
            uVar9 = FUN_140056850(&local_2e0,"_Semantic_",0,10);
            bVar14 = 0x1f;
            if (uVar9 != 0xffffffffffffffff) {
              uVar13 = local_2d0;
              if (local_2c1 < 0x40) {
                uVar13 = 0x1f - (longlong)(char)local_2c1;
              }
              puVar11 = &local_2e0;
              if (0x3f < local_2c1) {
                puVar11 = (undefined1 *)CONCAT71(uStack_2df,local_2e0);
              }
              FUN_140054780(&local_2a8,puVar11 + uVar9 + 10,uVar13 - (uVar9 + 10));
              uVar13 = local_2d0;
              if (local_2c1 < 0x40) {
                uVar13 = 0x1f - (longlong)(char)local_2c1;
              }
              puVar11 = &local_2e0;
              if (0x3f < local_2c1) {
                puVar11 = (undefined1 *)CONCAT71(uStack_2df,local_2e0);
              }
              if (uVar9 < uVar13) {
                uVar13 = uVar9;
              }
              FUN_140054780(&local_2e0,puVar11,uVar13);
              bVar14 = local_289;
            }
            local_248 = local_298;
            if (bVar14 < 0x40) {
              local_248 = 0x1f - (longlong)(char)bVar14;
            }
            local_250 = &local_2a8;
            if (0x3f < bVar14) {
              local_250 = (undefined1 *)CONCAT71(uStack_2a7,local_2a8);
            }
            local_238 = local_2d0;
            if (local_2c1 < 0x40) {
              local_238 = 0x1f - (longlong)(char)local_2c1;
            }
            local_240 = &local_2e0;
            if (0x3f < local_2c1) {
              local_240 = (undefined1 *)CONCAT71(uStack_2df,local_2e0);
            }
            local_228 = local_2f8;
            if (local_2e9 < 0x40) {
              local_228 = 0x1f - (longlong)(char)local_2e9;
            }
            local_230 = &local_308;
            if (0x3f < local_2e9) {
              local_230 = (char *)CONCAT71(uStack_307,local_308);
            }
            uVar10 = FUN_140066aa0(local_150,&local_230,&local_240,&local_250,uVar15,0,9);
            if (*(longlong *)(param_5 + 0x20) == *(longlong *)(param_5 + 0x28)) {
              FUN_140065740(param_5 + 0x18,*(longlong *)(param_5 + 0x20),uVar10);
            }
            else {
              FUN_140066420();
              *(longlong *)(param_5 + 0x20) = *(longlong *)(param_5 + 0x20) + 0x88;
            }
            FUN_1400194f0(local_150);
            if ((local_289 & 0xc0) == 0x40) {
              thunk_FUN_1403f2404(CONCAT71(uStack_2a7,local_2a8),local_288,
                                  "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                  ,0x218);
            }
            if ((local_2c1 & 0xc0) == 0x40) {
              thunk_FUN_1403f2404(CONCAT71(uStack_2df,local_2e0),local_2c0,
                                  "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                  ,0x218);
            }
          }
          if ((local_2e9 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_307,local_308),local_2e8,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
        }
        uVar18 = uVar18 + 1;
      } while (uVar18 < local_1dc);
    }
    (**(code **)(*local_2b0 + 0x10))();
  }
  return;
}
```
