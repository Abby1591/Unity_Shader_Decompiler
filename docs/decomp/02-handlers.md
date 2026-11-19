# Command handlers

Ghidra decompilation of `UnityShaderCompiler.exe` (image base `0x140000000`).
Function names and leading comments are the annotations recorded in the Ghidra
database; the bodies are otherwise unedited decompiler output. See
[`shader_compiler_analysis.md`](../shader_compiler_analysis.md) for the prose
description of the same pipeline.

## `HandlePreprocessCommand` — `0x1400b7db0`

`Cmd: preprocess`

```c
byte HandlePreprocessCommand
               (undefined8 *param_1,undefined8 *param_2,undefined8 *param_3,longlong *param_4,
               longlong param_5,char param_6,undefined1 *param_7,undefined1 *param_8)

{
  char cVar1;
  undefined1 uVar2;
  byte bVar3;
  DWORD DVar4;
  DWORD DVar5;
  undefined8 *puVar6;
  undefined8 *puVar7;
  longlong lVar8;
  undefined8 *****pppppuVar9;
  longlong lVar10;
  code *pcVar11;
  undefined8 in_stack_ffffffffffffff38;
  undefined4 uVar12;
  longlong *local_b8;
  longlong *local_b0;
  undefined8 *local_a8;
  undefined4 local_a0;
  undefined1 local_9c;
  undefined1 local_98;
  undefined7 uStack_97;
  longlong local_88;
  byte local_79;
  undefined2 local_78;
  longlong local_70 [3];
  undefined8 local_58;
  undefined8 ****local_50 [3];
  byte local_31;
  undefined2 local_30;
  
  uVar12 = (undefined4)((ulonglong)in_stack_ffffffffffffff38 >> 0x20);
  bVar3 = *(byte *)((longlong)param_3 + 0x1f) >> 6;
  puVar7 = (undefined8 *)0x0;
  if (bVar3 == 0) {
LAB_1400b7dfd:
    *(undefined1 *)param_3 = 0;
    *(undefined1 *)((longlong)param_3 + 0x1f) = 0x1f;
  }
  else if (bVar3 == 1) {
    *(undefined1 *)*param_3 = 0;
    param_3[2] = 0;
  }
  else if (bVar3 == 2) goto LAB_1400b7dfd;
  *param_7 = 0;
  if ((undefined8 *)(param_5 + 0x28) != &DAT_140728518) {
    FUN_140054d80((undefined8 *)(param_5 + 0x28),DAT_140728518,DAT_140728518 + DAT_140728528 * 0x28)
    ;
  }
  FUN_140019e80(param_5 + 0x48,&PTR_DAT_140728538);
  local_a0 = 0;
  local_9c = 0;
  puVar6 = (undefined8 *)
           FUN_1400e40b0(0x30,1,8,
                         "C:\\build\\output\\unity\\unity\\Tools\\UnityShaderCompiler\\CgBatch.cpp",
                         CONCAT44(uVar12,0x69e));
  if (puVar6 != (undefined8 *)0x0) {
    *puVar6 = &DAT_14058aa4c;
    puVar6[1] = 0;
    *(undefined4 *)(puVar6 + 2) = 0;
    *(undefined2 *)((longlong)puVar6 + 0x16) = 1;
    puVar6[3] = &DAT_14058aa4c;
    puVar6[4] = 0;
    *(undefined4 *)(puVar6 + 5) = 0;
    *(undefined2 *)((longlong)puVar6 + 0x2e) = 1;
    puVar7 = puVar6;
  }
  local_70[0] = 0;
  local_70[1] = 0;
  local_a8 = puVar7;
  local_70[0] = FUN_1400e40a0(0x80);
  *(longlong *)local_70[0] = local_70[0];
  *(longlong *)(local_70[0] + 8) = local_70[0];
  *(longlong *)(local_70[0] + 0x10) = local_70[0];
  *(undefined2 *)(local_70[0] + 0x18) = 0x101;
  local_b8 = local_70;
  local_70[2] = *param_2;
  local_58 = param_2[1];
  local_b0 = param_4;
  FUN_1400c0f50(param_5 + 0x28,local_70 + 2);
  if (*(byte *)((longlong)param_1 + 0x1f) < 0x40) {
    lVar10 = 0x1f - (longlong)*(char *)((longlong)param_1 + 0x1f);
    puVar7 = param_1;
    lVar8 = 0x1f - (longlong)*(char *)((longlong)param_1 + 0x1f);
  }
  else {
    puVar7 = (undefined8 *)*param_1;
    lVar10 = param_1[2];
    lVar8 = lVar10;
  }
  cVar1 = FUN_1400e4970(puVar7,lVar10);
  puVar6 = (undefined8 *)((longlong)puVar7 + 3);
  lVar10 = lVar8 + -3;
  if (cVar1 == '\0') {
    puVar6 = puVar7;
    lVar10 = lVar8;
  }
  local_78 = 0x4b;
  local_98 = 0;
  local_79 = 0x1f;
  lVar8 = FUN_140056c90(&local_98,lVar10);
  FUN_140558820(lVar8,puVar6,lVar10);
  *(undefined1 *)(lVar10 + lVar8) = 0;
  if (local_79 < 0x40) {
    local_79 = 0x1f - (char)lVar10;
    lVar10 = local_88;
  }
  local_88 = lVar10;
  DVar4 = GetTickCount();
  pcVar11 = ProcessSurfaceShaderBlock;
  if (param_6 != '\0') {
    pcVar11 = GenerateSurfaceShaderPasses;
  }
  uVar2 = FUN_1400c63d0(param_5,&local_98,0,pcVar11,&local_b8);
  *param_7 = uVar2;
  if (param_6 == '\0') {
    FUN_1400c63d0(param_5,&local_98,1,ProcessSurfaceShaderBlock,&local_b8);
    FUN_1400c63d0(param_5,&local_98,2,ProcessSurfaceShaderBlock,&local_b8);
    FUN_1400c63d0(param_5,&local_98,3,ProcessSurfaceShaderBlock,&local_b8);
    FUN_1400c63d0(param_5,&local_98,0,FUN_1400bb0e0,&local_b8);
    FUN_1400c63d0(param_5,&local_98,1,FUN_1400bb0e0,&local_b8);
    FUN_1400c63d0(param_5,&local_98,2,FUN_1400bb0e0,&local_b8);
    FUN_1400c63d0(param_5,&local_98,3,FUN_1400bb0e0,&local_b8);
  }
  if (local_b0 != (longlong *)0x0) {
    (**(code **)(*local_b0 + 0x18))(local_b0,local_a8);
    (**(code **)(*local_b0 + 0x20))(local_b0,local_a8 + 3);
  }
  puVar7 = local_a8;
  if (local_a8 != (undefined8 *)0x0) {
    FUN_1400171d0(local_a8 + 3);
    FUN_1400171d0(puVar7);
    thunk_FUN_1403f2404(puVar7,1,
                        "C:\\build\\output\\unity\\unity\\Tools\\UnityShaderCompiler\\CgBatch.cpp",
                        0x6c5);
  }
  local_a8 = (undefined8 *)0x0;
  DVar5 = GetTickCount();
  FUN_1400e0f60(local_50,"preprocessed shader in %.2fs",(double)((float)(DVar5 - DVar4) * 0.001));
  if (param_4 != (longlong *)0x0) {
    pppppuVar9 = local_50;
    if (0x3f < local_31) {
      pppppuVar9 = (undefined8 *****)local_50[0];
    }
    (**(code **)(*param_4 + 8))(param_4,0,0xffffffff,0,&DAT_140578094,pppppuVar9);
  }
  if (param_3 == (undefined8 *)&local_98) goto LAB_1400b82a0;
  lVar10 = local_88;
  if (local_79 < 0x40) {
    lVar10 = 0x1f - (longlong)(char)local_79;
  }
  puVar7 = (undefined8 *)&local_98;
  if (0x3f < local_79) {
    puVar7 = (undefined8 *)CONCAT71(uStack_97,local_98);
  }
  if ((*(byte *)((longlong)param_3 + 0x1f) & 0xc0) == 0x80) {
    *(undefined1 *)param_3 = 0;
    *(undefined1 *)((longlong)param_3 + 0x1f) = 0x1f;
  }
  puVar6 = param_3;
  if (0x3f < *(byte *)((longlong)param_3 + 0x1f)) {
    puVar6 = (undefined8 *)*param_3;
  }
  if (puVar7 < puVar6) {
LAB_1400b8244:
    bVar3 = *(byte *)((longlong)param_3 + 0x1f) >> 6;
    if (bVar3 == 0) {
LAB_1400b8259:
      *(undefined1 *)param_3 = 0;
      *(undefined1 *)((longlong)param_3 + 0x1f) = 0x1f;
    }
    else if (bVar3 == 1) {
      *(undefined1 *)*param_3 = 0;
      param_3[2] = 0;
    }
    else if (bVar3 == 2) goto LAB_1400b8259;
    puVar6 = (undefined8 *)FUN_140056c90(param_3,lVar10);
    FUN_140558820(puVar6,puVar7,lVar10);
  }
  else {
    if (*(byte *)((longlong)param_3 + 0x1f) < 0x40) {
      lVar8 = 0x1f - (longlong)*(char *)((longlong)param_3 + 0x1f);
    }
    else {
      lVar8 = param_3[2];
    }
    if ((undefined8 *)(lVar8 + (longlong)puVar6) <= puVar7) goto LAB_1400b8244;
    puVar6 = param_3;
    if (0x3f < *(byte *)((longlong)param_3 + 0x1f)) {
      puVar6 = (undefined8 *)*param_3;
    }
    FUN_140558820(puVar6,puVar7,lVar10);
  }
  *(undefined1 *)((longlong)puVar6 + lVar10) = 0;
  if (*(byte *)((longlong)param_3 + 0x1f) < 0x40) {
    *(char *)((longlong)param_3 + 0x1f) = '\x1f' - (char)lVar10;
  }
  else {
    param_3[2] = lVar10;
  }
LAB_1400b82a0:
  *param_8 = local_9c;
  FUN_14008fd50(local_b8,param_4);
  bVar3 = FUN_14008ee50(local_b8);
  if ((local_31 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(local_50[0],local_30,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  if ((local_79 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_97,local_98),local_78,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  FUN_14000b880(local_70,local_70,*(undefined8 *)(local_70[0] + 8));
  thunk_FUN_1403f2404(local_70[0],0x80);
  return bVar3 ^ 1;
}
```

## `HandleDisassembleShaderCommand` — `0x1400b5680`

`Cmd: disassembleShader`

```c
ulonglong HandleDisassembleShaderCommand
                    (undefined4 param_1,undefined4 param_2,undefined4 param_3,longlong *param_4,
                    undefined8 param_5,longlong param_6,undefined8 param_7)

{
  byte bVar1;
  ulonglong in_RAX;
  longlong *plVar2;
  longlong lVar3;
  ulonglong uVar4;
  longlong lVar5;
  longlong local_308 [2];
  undefined1 local_2f8 [24];
  undefined4 local_2e0;
  undefined4 local_2dc;
  undefined4 local_2d8;
  undefined4 local_2c8;
  longlong local_a0 [2];
  ulonglong local_90;
  ulonglong local_88;
  
  if (param_4[2] == 0) {
    uVar4 = in_RAX & 0xffffffffffffff00;
  }
  else {
    FUN_140015c70(local_2f8);
    if (param_4 != local_a0) {
      lVar3 = *param_4;
      uVar4 = (param_4[2] + *param_4) - lVar3;
      if (local_88 >> 1 < uVar4) {
        FUN_140059820(local_a0,uVar4,1);
      }
      local_90 = uVar4;
      FUN_140558820(local_a0[0],lVar3,uVar4);
    }
    local_2c8 = 0;
    local_2e0 = param_3;
    local_2dc = param_2;
    local_2d8 = param_1;
    plVar2 = (longlong *)(**(code **)(*DAT_14074ece0 + 0x20))(DAT_14074ece0,local_2f8);
    local_308[0] = 0;
    local_308[1] = 0;
    local_308[0] = FUN_1400e40a0(0x80);
    *(longlong *)local_308[0] = local_308[0];
    *(longlong *)(local_308[0] + 8) = local_308[0];
    *(longlong *)(local_308[0] + 0x10) = local_308[0];
    *(undefined2 *)(local_308[0] + 0x18) = 0x101;
    CollectCompiledPrograms(local_308,local_2f8,plVar2);
    if (param_6 != 0) {
      FUN_14008fc70(local_308,param_6,param_7);
    }
    lVar3 = (**(code **)(*plVar2 + 0x18))(plVar2);
    lVar5 = -1;
    do {
      lVar5 = lVar5 + 1;
    } while (*(char *)(lVar3 + lVar5) != '\0');
    FUN_140054780(param_5,lVar3);
    (**(code **)(*DAT_14074ece0 + 0x38))(DAT_14074ece0,plVar2);
    bVar1 = FUN_14008ee50(local_308);
    FUN_14000b880(local_308,local_308,*(undefined8 *)(local_308[0] + 8));
    thunk_FUN_1403f2404(local_308[0],0x80);
    FUN_140019570(local_2f8);
    uVar4 = (ulonglong)(bVar1 ^ 1);
  }
  return uVar4;
}
```

## `HandleCompileSnippetCommand` — `0x1400b4e40`

`Cmd: compileSnippet`

```c
/* Handler for "Cmd: compileSnippet". Selects the frontend by language index from a 4-entry table
   {GenerateD3dHlslStageSource, GenerateGlslStageSource, GenerateMetalShaderStageSource,
   GenerateD3dHlslStageSource}: 0/3 = D3D/HLSL, 1 = GLSL, 2 = Metal. */

byte HandleCompileSnippetCommand
               (undefined8 param_1,undefined4 param_2,undefined8 param_3,undefined8 param_4,
               undefined8 param_5,undefined8 param_6,undefined8 param_7,undefined8 param_8,
               undefined8 param_9,undefined4 param_10,undefined8 param_11,undefined1 param_12,
               undefined1 param_13,undefined8 param_14,longlong *param_15,undefined4 *param_16,
               int param_17,undefined4 param_18,undefined4 param_19,undefined4 param_20,
               undefined8 param_21,undefined8 param_22,longlong param_23,undefined8 param_24)

{
  byte bVar1;
  longlong local_48 [2];
  code *local_38 [4];
  
  local_38[0] = GenerateD3dHlslStageSource;
  local_38[1] = GenerateGlslStageSource;
  local_38[2] = GenerateMetalShaderStageSource;
  local_38[3] = GenerateD3dHlslStageSource;
  if (*param_15 != param_15[1]) {
    param_15[1] = *param_15;
  }
  *param_16 = 0;
  local_48[0] = 0;
  local_48[1] = 0;
  local_48[0] = FUN_1400e40a0(0x80);
  *(longlong *)local_48[0] = local_48[0];
  *(longlong *)(local_48[0] + 8) = local_48[0];
  *(longlong *)(local_48[0] + 0x10) = local_48[0];
  *(undefined2 *)(local_48[0] + 0x18) = 0x101;
  (*local_38[param_17])
            (param_1,param_2,param_3,param_4,param_5,param_6,param_7,param_8,param_9,param_10,
             param_11,param_12,param_13,param_14,param_17,param_18,param_19,param_20,param_21,
             param_22,param_15,param_16,local_48);
  FUN_14008fe30(local_48);
  if (param_23 != 0) {
    FUN_14008fc70(local_48,param_23,param_24);
  }
  bVar1 = FUN_14008ee50(local_48);
  FUN_14000b880(local_48,local_48,*(undefined8 *)(local_48[0] + 8));
  thunk_FUN_1403f2404(local_48[0],0x80);
  return bVar1 ^ 1;
}
```

## `HandleInitializeCompilerCommand` — `0x1400b5080`

`Cmd: initializeCompiler`

```c
void HandleInitializeCompilerCommand(undefined8 *param_1)

{
  undefined8 uVar1;
  undefined8 **ppuVar2;
  undefined8 **ppuVar3;
  char cVar4;
  undefined8 *puVar5;
  undefined8 ***pppuVar6;
  int *piVar7;
  int *piVar8;
  longlong lVar9;
  undefined8 ***pppuVar10;
  byte *pbVar11;
  byte *pbVar12;
  byte bVar13;
  undefined8 ***pppuVar14;
  undefined8 ***pppuVar15;
  longlong lVar16;
  undefined8 **ppuVar17;
  int iVar18;
  undefined8 **ppuVar19;
  undefined4 *puVar20;
  undefined8 **local_378;
  longlong local_370;
  byte local_368;
  undefined7 uStack_367;
  undefined8 uStack_360;
  undefined8 local_358;
  undefined4 uStack_350;
  undefined4 uStack_34c;
  undefined2 local_348;
  undefined8 **local_340;
  uint uStack_338;
  undefined4 uStack_334;
  longlong local_330;
  byte local_321;
  undefined2 local_320;
  undefined8 ***local_318;
  undefined8 uStack_310;
  undefined1 local_308 [208];
  int local_238 [132];
  
  local_378 = (undefined8 **)0x0;
  local_370 = 0;
  local_378 = (undefined8 **)FUN_1400e40a0(0x50);
  *local_378 = local_378;
  local_378[1] = local_378;
  local_378[2] = local_378;
  *(undefined2 *)(local_378 + 3) = 0x101;
  local_348 = 0x4b;
  local_368 = 0;
  uStack_34c = CONCAT13(0x1f,(int3)uStack_34c);
  puVar5 = (undefined8 *)FUN_140056c90(&local_368,0xc);
  ppuVar3 = local_378;
  *puVar5 = 0x6e656c61626f6c67;
  *(undefined4 *)(puVar5 + 1) = 0x72617676;
  *(undefined1 *)((longlong)puVar5 + 0xc) = 0;
  if (uStack_34c._3_1_ < 0x40) {
    uStack_34c = CONCAT13(0x13,(undefined3)uStack_34c);
    bVar13 = 0x13;
  }
  else {
    local_358 = (undefined8 **)0xc;
    bVar13 = uStack_34c._3_1_;
  }
  local_340 = (undefined8 **)local_378[1];
  uStack_338 = 0;
  pbVar12 = (byte *)CONCAT71(uStack_367,local_368);
  cVar4 = *(char *)((longlong)local_340 + 0x19);
  pppuVar10 = (undefined8 ***)local_340;
  pppuVar6 = (undefined8 ***)local_378;
  while (pppuVar14 = pppuVar10, cVar4 == '\0') {
    local_340 = pppuVar14;
    pppuVar10 = pppuVar14 + 4;
    pbVar11 = pbVar12;
    ppuVar17 = local_358;
    if (bVar13 < 0x40) {
      pbVar11 = &local_368;
      ppuVar17 = (undefined8 **)(0x1f - (longlong)(char)bVar13);
    }
    if (*(byte *)((longlong)pppuVar14 + 0x3f) < 0x40) {
      ppuVar19 = (undefined8 **)(0x1f - (longlong)*(char *)((longlong)pppuVar14 + 0x3f));
    }
    else {
      ppuVar19 = pppuVar14[6];
      pppuVar10 = (undefined8 ***)*pppuVar10;
    }
    ppuVar2 = ppuVar19;
    if (ppuVar17 < ppuVar19) {
      ppuVar2 = ppuVar17;
    }
    for (; ppuVar2 != (undefined8 **)0x0; ppuVar2 = (undefined8 **)((longlong)ppuVar2 - 1)) {
      if (*(byte *)pppuVar10 != *pbVar11) {
        iVar18 = (uint)*(byte *)pppuVar10 - (uint)*pbVar11;
        goto LAB_1400b51de;
      }
      pppuVar10 = (undefined8 ***)((longlong)pppuVar10 + 1);
      pbVar11 = pbVar11 + 1;
    }
    iVar18 = (int)ppuVar19 - (int)ppuVar17;
LAB_1400b51de:
    if (-1 < iVar18) {
      uStack_338 = 1;
      pppuVar10 = (undefined8 ***)*pppuVar14;
    }
    else {
      uStack_338 = 0;
      pppuVar10 = (undefined8 ***)pppuVar14[2];
      pppuVar14 = pppuVar6;
    }
    uStack_338 = (uint)(-1 < iVar18);
    cVar4 = *(char *)((longlong)pppuVar10 + 0x19);
    pppuVar6 = pppuVar14;
  }
  if (*(char *)((longlong)pppuVar6 + 0x19) == '\0') {
    pppuVar10 = pppuVar6 + 4;
    if (*(byte *)((longlong)pppuVar6 + 0x3f) < 0x40) {
      ppuVar17 = (undefined8 **)(0x1f - (longlong)*(char *)((longlong)pppuVar6 + 0x3f));
    }
    else {
      ppuVar17 = pppuVar6[6];
      pppuVar10 = (undefined8 ***)*pppuVar10;
    }
    ppuVar19 = local_358;
    if (bVar13 < 0x40) {
      pbVar12 = &local_368;
      ppuVar19 = (undefined8 **)(0x1f - (longlong)(char)bVar13);
    }
    ppuVar2 = ppuVar19;
    if (ppuVar17 < ppuVar19) {
      ppuVar2 = ppuVar17;
    }
    for (; ppuVar2 != (undefined8 **)0x0; ppuVar2 = (undefined8 **)((longlong)ppuVar2 - 1)) {
      if (*pbVar12 != *(byte *)pppuVar10) {
        iVar18 = (uint)*pbVar12 - (uint)*(byte *)pppuVar10;
        goto LAB_1400b527c;
      }
      pbVar12 = pbVar12 + 1;
      pppuVar10 = (undefined8 ***)((longlong)pppuVar10 + 1);
    }
    iVar18 = (int)ppuVar19 - (int)ppuVar17;
LAB_1400b527c:
    if (-1 < iVar18) goto LAB_1400b5335;
  }
  if (local_370 == 0x333333333333333) {
                    /* WARNING: Subroutine does not return */
    FUN_140053d50();
  }
  local_318 = &local_378;
  uStack_310 = 0;
  puVar5 = (undefined8 *)FUN_1400e40a0(0x50);
  *(undefined2 *)(puVar5 + 8) = local_348;
  puVar5[4] = CONCAT71(uStack_367,local_368);
  puVar5[5] = uStack_360;
  if (uStack_34c._3_1_ >> 6 == 0) {
    *(undefined4 *)(puVar5 + 6) = (undefined4)local_358;
    *(undefined4 *)((longlong)puVar5 + 0x34) = local_358._4_4_;
    *(undefined4 *)(puVar5 + 7) = uStack_350;
    *(undefined4 *)((longlong)puVar5 + 0x3c) = uStack_34c;
  }
  else {
    puVar5[6] = local_358;
  }
  *(byte *)((longlong)puVar5 + 0x3f) = *(byte *)((longlong)puVar5 + 0x3f) & 0x3f;
  *(byte *)((longlong)puVar5 + 0x3f) = *(byte *)((longlong)puVar5 + 0x3f) | uStack_34c._3_1_ & 0xc0;
  local_368 = 0;
  uStack_34c = CONCAT13(0x1f,(undefined3)uStack_34c);
  puVar5[9] = 0;
  *puVar5 = ppuVar3;
  puVar5[1] = ppuVar3;
  puVar5[2] = ppuVar3;
  *(undefined2 *)(puVar5 + 3) = 0;
  local_318 = (undefined8 ***)local_340;
  uStack_310 = CONCAT44(uStack_334,uStack_338);
  pppuVar6 = (undefined8 ***)FUN_140053080(&local_378,&local_318,puVar5);
LAB_1400b5335:
  pppuVar6[9] = (undefined8 **)FUN_1400c0970;
  if ((uStack_34c._3_1_ & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_367,local_368),local_348,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  FUN_1400fba70(local_238);
  if (*(byte *)((longlong)param_1 + 0x1f) < 0x40) {
    lVar16 = 0x1f - (longlong)*(char *)((longlong)param_1 + 0x1f);
    puVar5 = param_1;
  }
  else {
    lVar16 = param_1[2];
    puVar5 = (undefined8 *)*param_1;
  }
  FUN_140106bf0(local_238,puVar5,lVar16);
  FUN_1400fbeb0(local_238,local_308);
  if (local_238[0] == 0) {
    FUN_1400f97a0(local_238);
    piVar7 = (int *)FUN_1400f9580(local_308);
    pppuVar10 = (undefined8 ***)local_378;
    if (((piVar7 != (int *)0x0) && (*piVar7 == 3)) &&
       (puVar20 = *(undefined4 **)(piVar7 + 4), puVar20 < *(undefined4 **)(piVar7 + 8))) {
      do {
        piVar8 = (int *)FUN_1400f9540(local_308,*puVar20);
        pppuVar10 = (undefined8 ***)local_378;
        if ((piVar8 != (int *)0x0) && (*piVar8 == 1)) {
          lVar16 = *(longlong *)(piVar8 + 6);
          uVar1 = *(undefined8 *)(piVar8 + 4);
          local_320 = 0x4b;
          local_340 = (undefined8 **)((ulonglong)local_340 & 0xffffffffffffff00);
          local_321 = 0x1f;
          lVar9 = FUN_140056c90(&local_340,lVar16);
          FUN_140558820(lVar9,uVar1,lVar16);
          pppuVar10 = (undefined8 ***)local_378;
          *(undefined1 *)(lVar9 + lVar16) = 0;
          if (local_321 < 0x40) {
            local_321 = 0x1f - (char)lVar16;
            lVar16 = local_330;
          }
          local_330 = lVar16;
          bVar13 = local_321;
          cVar4 = *(char *)((longlong)local_378[1] + 0x19);
          pppuVar6 = (undefined8 ***)local_378[1];
          pppuVar14 = (undefined8 ***)local_378;
          while (pppuVar15 = pppuVar6, cVar4 == '\0') {
            cVar4 = FUN_14001b410(pppuVar15 + 4,&local_340);
            if (cVar4 == '\0') {
              pppuVar6 = (undefined8 ***)*pppuVar15;
            }
            else {
              pppuVar6 = (undefined8 ***)pppuVar15[2];
              pppuVar15 = pppuVar14;
            }
            cVar4 = *(char *)((longlong)pppuVar6 + 0x19);
            pppuVar14 = pppuVar15;
          }
          if ((*(char *)((longlong)pppuVar14 + 0x19) != '\0') ||
             (cVar4 = FUN_14001b410(&local_340,pppuVar14 + 4), cVar4 != '\0')) {
            pppuVar14 = pppuVar10;
          }
          if ((bVar13 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(local_340,local_320,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
            pppuVar10 = (undefined8 ***)local_378;
          }
          if (pppuVar14 != pppuVar10) {
            (*(code *)pppuVar14[9])(local_308,puVar20);
            pppuVar10 = (undefined8 ***)local_378;
          }
        }
        puVar20 = puVar20 + 2;
      } while (puVar20 < *(undefined4 **)(piVar7 + 8));
    }
    cVar4 = *(char *)((longlong)pppuVar10[1] + 0x19);
    ppuVar3 = pppuVar10[1];
    while (cVar4 == '\0') {
      FUN_1400af620(&local_378,&local_378,ppuVar3[2]);
      ppuVar17 = (undefined8 **)*ppuVar3;
      if ((*(byte *)((longlong)ppuVar3 + 0x3f) & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(ppuVar3[4],*(undefined2 *)(ppuVar3 + 8),
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      thunk_FUN_1403f2404(ppuVar3,0x50);
      ppuVar3 = ppuVar17;
      pppuVar10 = (undefined8 ***)local_378;
      cVar4 = *(char *)((longlong)ppuVar17 + 0x19);
    }
    thunk_FUN_1403f2404(pppuVar10,0x50);
  }
  else {
    FUN_1400f97a0(local_238);
    cVar4 = *(char *)((longlong)local_378[1] + 0x19);
    ppuVar3 = (undefined8 **)local_378[1];
    while (cVar4 == '\0') {
      FUN_1400af620(&local_378,&local_378,ppuVar3[2]);
      ppuVar17 = (undefined8 **)*ppuVar3;
      if ((*(byte *)((longlong)ppuVar3 + 0x3f) & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(ppuVar3[4],*(undefined2 *)(ppuVar3 + 8),
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      thunk_FUN_1403f2404(ppuVar3,0x50);
      ppuVar3 = ppuVar17;
      cVar4 = *(char *)((longlong)ppuVar17 + 0x19);
    }
    thunk_FUN_1403f2404(local_378,0x50);
  }
  if ((*(byte *)((longlong)param_1 + 0x1f) & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(*param_1,*(undefined2 *)(param_1 + 4),
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  return;
}
```

## `HandleComputeKernelPreprocessRequest` — `0x1400b6370`

`Cmd: preprocessCompute`

```c
undefined8
HandleComputeKernelPreprocessRequest
          (undefined8 *****param_1,undefined8 *param_2,longlong param_3,longlong *param_4,
          longlong *param_5,undefined8 param_6,undefined8 *param_7,undefined8 param_8,
          undefined8 param_9,uint *param_10,undefined8 param_11,undefined8 param_12,
          undefined8 param_13,longlong param_14,longlong param_15,undefined8 param_16)

{
  uint uVar1;
  uint uVar2;
  bool bVar3;
  bool bVar4;
  undefined2 uVar5;
  char cVar6;
  undefined8 uVar7;
  undefined1 *puVar8;
  undefined8 ****ppppuVar9;
  undefined8 *****pppppuVar10;
  undefined8 *****pppppuVar11;
  undefined8 ****ppppuVar12;
  undefined8 *puVar13;
  byte *pbVar14;
  uint uVar15;
  ulonglong uVar16;
  longlong lVar17;
  longlong lVar18;
  longlong lVar19;
  undefined8 *puVar20;
  longlong *plVar21;
  longlong lVar22;
  ulonglong uVar23;
  ulonglong in_stack_fffffffffffff7d8;
  undefined8 in_stack_fffffffffffff7e0;
  undefined8 in_stack_fffffffffffff7e8;
  undefined4 uVar24;
  undefined8 in_stack_fffffffffffff7f0;
  undefined4 uVar25;
  ulonglong local_7c0;
  longlong local_7b0;
  undefined2 local_7a8;
  ulonglong local_7a0;
  ulonglong local_798;
  byte *local_790;
  longlong local_788;
  undefined8 *local_780;
  longlong local_778;
  longlong local_770;
  undefined2 local_768;
  ulonglong local_760;
  ulonglong local_758;
  longlong local_750;
  undefined8 local_748;
  undefined8 *local_740;
  longlong local_738;
  longlong local_730 [3];
  undefined2 local_718;
  ulonglong local_710;
  ulonglong local_708;
  longlong local_700;
  undefined2 local_6f8;
  ulonglong local_6f0;
  undefined8 local_6e8;
  undefined8 local_6e0;
  undefined8 local_6d8;
  undefined2 local_6d0;
  longlong local_6c8;
  undefined8 local_6c0;
  undefined8 local_6b8;
  undefined2 local_6b0;
  longlong local_6a8;
  undefined8 local_6a0;
  undefined1 local_698;
  undefined7 uStack_697;
  undefined8 local_688;
  byte local_679;
  undefined2 local_678;
  undefined8 local_670;
  undefined2 local_668;
  undefined8 local_660;
  undefined8 local_658;
  undefined8 ****local_650 [2];
  longlong local_640;
  byte local_631;
  undefined2 uStack_630;
  undefined1 local_628;
  undefined7 uStack_627;
  byte local_609;
  undefined2 local_608;
  undefined4 local_600;
  undefined4 uStack_5fc;
  byte local_5e1;
  undefined2 local_5e0;
  undefined8 local_5d8;
  undefined2 local_5d0;
  undefined8 local_5c8;
  undefined8 uStack_5c0;
  undefined8 local_5b8;
  undefined1 local_5a8 [704];
  longlong local_2e8;
  longlong local_2d8;
  longlong local_2c8;
  longlong local_2b8;
  undefined1 local_1c8 [32];
  undefined1 local_1a8 [32];
  undefined1 local_188 [48];
  undefined1 local_158 [32];
  undefined1 local_138 [256];
  
  local_750 = 0;
  local_748 = 0;
  local_750 = FUN_1400e40a0(0x80);
  *(longlong *)local_750 = local_750;
  *(longlong *)(local_750 + 8) = local_750;
  *(longlong *)(local_750 + 0x10) = local_750;
  *(undefined2 *)(local_750 + 0x18) = 0x101;
  if ((undefined8 *)(param_3 + 0x28) != &DAT_140728518) {
    FUN_140054d80((undefined8 *)(param_3 + 0x28),DAT_140728518,DAT_140728518 + DAT_140728528 * 0x28)
    ;
  }
  FUN_140019e80(param_3 + 0x48,&PTR_DAT_140728538);
  if (*(byte *)((longlong)param_2 + 0x1f) < 0x40) {
    local_778 = 0x1f - (longlong)*(char *)((longlong)param_2 + 0x1f);
  }
  else {
    local_778 = param_2[2];
    param_2 = (undefined8 *)*param_2;
  }
  local_780 = param_2;
  uVar7 = FUN_1400e0430(&local_790,&local_780);
  FUN_1400c0f50(param_3 + 0x28,uVar7);
  if (*(byte *)((longlong)param_1 + 0x1f) < 0x40) {
    ppppuVar9 = (undefined8 ****)(0x1f - (longlong)*(char *)((longlong)param_1 + 0x1f));
    ppppuVar12 = (undefined8 ****)(0x1f - (longlong)*(char *)((longlong)param_1 + 0x1f));
    pppppuVar11 = param_1;
  }
  else {
    pppppuVar11 = (undefined8 *****)*param_1;
    ppppuVar9 = param_1[2];
    ppppuVar12 = ppppuVar9;
  }
  cVar6 = FUN_1400e4970(pppppuVar11,ppppuVar9);
  pppppuVar10 = (undefined8 *****)((longlong)pppppuVar11 + 3);
  ppppuVar9 = (undefined8 ****)((longlong)ppppuVar12 + -3);
  if (cVar6 == '\0') {
    pppppuVar10 = pppppuVar11;
    ppppuVar9 = ppppuVar12;
  }
  FUN_140014bc0(local_650,pppppuVar10,ppppuVar9);
  PrepareBackendSourceBuffer(local_650);
  uVar25 = (undefined4)((ulonglong)in_stack_fffffffffffff7e0 >> 0x20);
  uVar24 = (undefined4)((ulonglong)in_stack_fffffffffffff7e8 >> 0x20);
  local_700 = 0;
  local_6f8 = 0x4d;
  local_6f0 = 0;
  local_6e8 = 1;
  local_6e0 = 0;
  local_730[2] = 0;
  local_718 = 1;
  local_710 = 0;
  local_708 = 1;
  local_7b0 = 0;
  local_7a8 = 1;
  local_7a0 = 0;
  local_798 = 1;
  local_770 = 0;
  local_768 = *(undefined2 *)(param_3 + 0x90);
  local_760 = 0;
  local_758 = 1;
  lVar22 = *(longlong *)(param_3 + 0x88);
  uVar16 = (*(longlong *)(param_3 + 0x98) * 0x28) / 0x28;
  uVar23 = uVar16;
  if (uVar16 != 0) {
    FUN_140059900(&local_770,uVar16,1);
    uVar5 = local_768;
    lVar18 = local_770;
    local_760 = uVar16;
    do {
      if (lVar18 != 0) {
        FUN_140014a90(lVar18,lVar22,uVar5);
      }
      uVar25 = (undefined4)((ulonglong)in_stack_fffffffffffff7e0 >> 0x20);
      uVar24 = (undefined4)((ulonglong)in_stack_fffffffffffff7e8 >> 0x20);
      lVar18 = lVar18 + 0x28;
      lVar22 = lVar22 + 0x28;
      uVar16 = uVar16 - 1;
      uVar23 = local_760;
    } while (uVar16 != 0);
  }
  local_760 = uVar23;
  lVar22 = 0;
  local_678 = 1;
  local_698 = 0;
  local_679 = 0x1f;
  local_670 = 0;
  local_668 = 1;
  local_660 = 0;
  local_658 = 1;
  local_6b8 = 0;
  local_6b0 = 1;
  local_6a8 = 0;
  local_6a0 = 1;
  local_6d8 = 0;
  local_6d0 = 1;
  local_6c8 = 0;
  local_6c0 = 1;
  uVar16 = *(ulonglong *)(param_3 + 0x78);
  if (local_798 >> 1 < uVar16) {
    if ((~(byte)local_798 & 1) == 0) {
      if (uVar16 != 0) {
        lVar22 = FUN_1400e4280(uVar16 * 0x50,8,local_7a8,0,
                               "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\Allocators.h"
                               ,CONCAT44(uVar25,0x9c));
      }
      FUN_140558820(lVar22,local_7b0,local_7a0 * 0x50);
      local_798 = uVar16 * 2;
      local_7b0 = lVar22;
    }
    else {
      local_798 = uVar16 * 2;
      local_7b0 = FUN_1400e42a0(local_7b0,uVar16 * 0x50,8,local_7a8,
                                in_stack_fffffffffffff7d8 & 0xffffffff00000000,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\Allocators.h"
                                ,CONCAT44(uVar24,0xa3));
    }
  }
  uVar25 = (undefined4)((ulonglong)in_stack_fffffffffffff7f0 >> 0x20);
  lVar18 = 0;
  for (lVar22 = *(longlong *)(param_3 + 0x78); lVar22 != 0; lVar22 = lVar22 + -1) {
    puVar13 = (undefined8 *)(*(longlong *)(param_3 + 0x68) + lVar18);
    uVar16 = local_7a0 + 1;
    if (local_798 >> 1 < uVar16) {
      FUN_140057330(&local_7b0);
    }
    lVar19 = local_7b0 + -0x50 + uVar16 * 0x50;
    local_7a0 = uVar16;
    if (lVar19 != 0) {
      local_790 = PTR_DAT_1407285a0;
      local_788 = DAT_1407285a8;
      if (*(byte *)((longlong)puVar13 + 0x1f) < 0x40) {
        local_738 = 0x1f - (longlong)*(char *)((longlong)puVar13 + 0x1f);
      }
      else {
        local_738 = puVar13[2];
        puVar13 = (undefined8 *)*puVar13;
      }
      local_740 = puVar13;
      FUN_140014b30(lVar19,&local_740,0x4b);
      FUN_140014b30(lVar19 + 0x28,&local_790,0x4b);
    }
    uVar25 = (undefined4)((ulonglong)in_stack_fffffffffffff7f0 >> 0x20);
    lVar18 = lVar18 + 0x28;
  }
  puVar13 = (undefined8 *)FUN_1400e16b0(&local_628,0x393fc3d);
  uVar16 = local_7a0 + 1;
  if (local_798 >> 1 < uVar16) {
    FUN_140057330(&local_7b0);
  }
  puVar20 = (undefined8 *)(local_7b0 + -0x50 + uVar16 * 0x50);
  local_7a0 = uVar16;
  local_780 = puVar20;
  if (puVar20 != (undefined8 *)0x0) {
    if (*(byte *)((longlong)puVar13 + 0x1f) < 0x40) {
      local_738 = 0x1f - (longlong)*(char *)((longlong)puVar13 + 0x1f);
    }
    else {
      local_738 = puVar13[2];
      puVar13 = (undefined8 *)*puVar13;
    }
    local_790 = PTR_s_UNITY_VERSION_140728550;
    local_788 = DAT_140728558;
    local_740 = puVar13;
    FUN_140014b30(puVar20,&local_790,0x4b);
    FUN_140014b30(puVar20 + 5,&local_740,0x4b);
  }
  if ((local_609 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_627,local_628),local_608,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  lVar22 = (longlong)*(int *)(param_3 + 0x60);
  if (-1 < *(int *)(param_3 + 0x60)) {
    if ((byte)(&DAT_14074ed3f)[lVar22 * 0x50] < 0x40) {
      lVar18 = 0x1f - (longlong)(char)(&DAT_14074ed3f)[lVar22 * 0x50];
    }
    else {
      lVar18 = *(longlong *)(&DAT_14074ed30 + lVar22 * 0x50);
    }
    if (lVar18 != 0) {
      uVar16 = local_710 + 1;
      if (local_708 >> 1 < uVar16) {
        FUN_140057330(local_730 + 2);
      }
      puVar13 = (undefined8 *)(local_730[2] + -0x50 + uVar16 * 0x50);
      local_780 = puVar13;
      local_710 = uVar16;
      if (puVar13 != (undefined8 *)0x0) {
        FUN_1400149f0(puVar13,&DAT_14074ed20 + lVar22 * 0x50);
        FUN_1400149f0(puVar13 + 5,&DAT_14074ed48 + lVar22 * 0x50);
      }
    }
  }
  PrepareStageSourceSegment(*(undefined4 *)(param_3 + 0x60),&local_770);
  ProcessShaderPreprocessor
            (param_3,local_650,param_3 + 0x28,local_730 + 2,&local_7b0,&local_770,&DAT_1407284f0,
             CONCAT44(uVar25,0x10e),&local_698,&local_670,param_14,&local_6b8,&local_6d8,param_13,0)
  ;
  local_5d8 = 0;
  local_5d0 = 0x4d;
  local_5c8 = 0;
  uStack_5c0 = 1;
  local_5b8 = 0;
  local_730[0] = 0;
  local_730[1] = 0;
  local_730[0] = FUN_1400e40a0(0x80);
  *(longlong *)local_730[0] = local_730[0];
  *(longlong *)(local_730[0] + 8) = local_730[0];
  *(longlong *)(local_730[0] + 0x10) = local_730[0];
  *(undefined2 *)(local_730[0] + 0x18) = 0x101;
  FUN_140066c70(local_5a8);
  uVar7 = param_9;
  FUN_140091030(&local_670,local_5a8,&local_5d8,param_10,param_11,param_12,param_9,local_730);
  FUN_140096660(&local_770,local_770 + local_760 * 0x28,local_2e8,local_2e8 + local_2d8 * 0x28);
  FUN_140096660(&local_770,local_770 + local_760 * 0x28,local_2c8,local_2c8 + local_2b8 * 0x28);
  bVar3 = false;
  bVar4 = false;
  uVar1 = *(uint *)(param_3 + 100);
  uVar2 = *param_10;
  lVar18 = 0;
  uVar15 = 1;
  pbVar14 = &DAT_1407280af;
  lVar22 = 0x1c;
  do {
    uVar16 = local_760;
    if ((uVar1 & uVar2 & uVar15 & 0xdfdde30) != 0) {
      if (bVar3) {
        if ((&DAT_1405887d0)[lVar18] == '\0') {
          uVar23 = local_760 + 1;
          if (local_758 >> 1 < uVar23) {
            FUN_1400575b0(&local_770);
          }
          local_780 = (undefined8 *)(local_770 + uVar16 * 0x28);
          local_760 = uVar23;
          bVar3 = bVar4;
          if (local_780 != (undefined8 *)0x0) {
            FUN_140014a90(local_780,pbVar14 + -0x1f,local_768);
          }
        }
      }
      else {
        bVar3 = true;
        uVar16 = local_7a0 + 1;
        if (local_798 >> 1 < uVar16) {
          FUN_140057330(&local_7b0);
        }
        puVar13 = (undefined8 *)(local_7b0 + -0x50 + uVar16 * 0x50);
        local_7a0 = uVar16;
        local_780 = puVar13;
        bVar4 = bVar3;
        if (puVar13 != (undefined8 *)0x0) {
          local_740 = (undefined8 *)PTR_DAT_1407285a0;
          local_738 = DAT_1407285a8;
          if (*pbVar14 < 0x40) {
            local_788 = 0x1f - (longlong)(char)*pbVar14;
            local_790 = pbVar14 + -0x1f;
          }
          else {
            local_788 = *(longlong *)(pbVar14 + -0xf);
            local_790 = *(byte **)(pbVar14 + -0x1f);
          }
          FUN_140014b30(puVar13,&local_790,0x4b);
          FUN_140014b30(puVar13 + 5,&local_740,0x4b);
        }
      }
    }
    uVar25 = (undefined4)((ulonglong)uVar7 >> 0x20);
    lVar18 = lVar18 + 1;
    pbVar14 = pbVar14 + 0x28;
    uVar15 = uVar15 << 1 | (uint)((int)uVar15 < 0);
    lVar22 = lVar22 + -1;
  } while (lVar22 != 0);
  PrepareComputeStageSource(local_158,&local_7b0);
  local_608 = 0x4b;
  local_628 = 0;
  local_609 = 0x1f;
  lVar22 = 0;
  local_600 = 0;
  FUN_1400c9f10(&local_670,0,&local_628,1);
  if ((local_609 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_627,local_628),local_608,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  FUN_1400c9ae0(param_14);
  FUN_1400c9ae0(param_14 + 0x18);
  lVar18 = local_6a8;
  local_6a8 = 0;
  if (lVar18 != 0) {
    FUN_14000fef0(local_6b8);
  }
  lVar18 = local_6c8;
  local_6c8 = 0;
  if (lVar18 != 0) {
    FUN_14000fef0(local_6d8);
  }
  if (local_679 < 0x40) {
    local_679 = 0x1f;
    puVar8 = &local_698;
  }
  else {
    local_688 = 0;
    puVar8 = (undefined1 *)CONCAT71(uStack_697,local_698);
  }
  *puVar8 = 0;
  ProcessPreprocessorIncludeStack
            (param_3,param_3 + 0x28,local_730 + 2,&local_7b0,&local_770,&DAT_1407284f0,
             CONCAT44(uVar25,0x306),param_6,&local_698,&local_670,param_14,&local_6b8,&local_6d8,
             param_13);
  ProcessPreprocessorPragmaState(&local_6b8,&local_6d8,&local_750);
  cVar6 = FUN_140091030(&local_670,param_8,&local_700,param_10,param_11,param_12,param_9,&local_750)
  ;
  if (param_1 != local_650) {
    pppppuVar11 = (undefined8 *****)local_650[0];
    if (local_631 < 0x40) {
      local_640 = 0x1f - (longlong)(char)local_631;
      pppppuVar11 = local_650;
    }
    FUN_140054780(param_1,pppppuVar11,local_640);
  }
  FUN_1400955e0(param_8,param_6);
  local_7c0 = 0;
  if (local_6f0 != 0) {
    do {
      uVar23 = 0;
      lVar19 = local_700 + lVar22;
      lVar18 = param_4[2];
      uVar16 = lVar18 + 1;
      if ((ulonglong)param_4[3] >> 1 < uVar16) {
        FUN_1400575b0(param_4);
      }
      param_4[2] = uVar16;
      local_780 = (undefined8 *)(*param_4 + lVar18 * 0x28);
      if (local_780 != (undefined8 *)0x0) {
        FUN_140014a90(local_780,lVar19,(short)param_4[1]);
      }
      uVar16 = param_5[2] + 1;
      if ((ulonglong)param_5[3] >> 1 < uVar16) {
        FUN_1400ab760(param_5);
      }
      param_5[2] = uVar16;
      lVar18 = param_5[1];
      plVar21 = (longlong *)(*param_5 + -0x20 + uVar16 * 0x20);
      if (plVar21 != (longlong *)0x0) {
        *plVar21 = 0;
        *(short *)(plVar21 + 1) = (short)lVar18;
        plVar21[2] = 0;
        plVar21[3] = 1;
      }
      if (*(longlong *)(lVar22 + 0x38 + local_700) != 0) {
        lVar18 = 0;
        do {
          lVar19 = plVar21[1];
          lVar17 = *(longlong *)(lVar22 + 0x28 + local_700) + lVar18;
          FUN_140014a90(&local_628,lVar17,(short)lVar19);
          FUN_140014a90(&local_600,lVar17 + 0x28,(short)lVar19);
          uVar16 = plVar21[2] + 1;
          if ((ulonglong)plVar21[3] >> 1 < uVar16) {
            FUN_140057110(plVar21);
          }
          plVar21[2] = uVar16;
          puVar13 = (undefined8 *)(*plVar21 + -0x50 + uVar16 * 0x50);
          lVar19 = plVar21[1];
          local_780 = puVar13;
          if (puVar13 != (undefined8 *)0x0) {
            FUN_140014a90(puVar13,&local_628,(short)lVar19);
            FUN_140014a90(puVar13 + 5,&local_600,(short)lVar19);
          }
          if ((local_5e1 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT44(uStack_5fc,local_600),local_5e0,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          if ((local_609 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_627,local_628),local_608,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          uVar23 = uVar23 + 1;
          lVar18 = lVar18 + 0x50;
        } while (uVar23 < *(ulonglong *)(lVar22 + 0x38 + local_700));
      }
      local_7c0 = local_7c0 + 1;
      lVar22 = lVar22 + 0x48;
    } while (local_7c0 < local_6f0);
  }
  *param_7 = local_6e0;
  if (param_15 != 0) {
    FUN_14008fc70(&local_750,param_15,param_16);
  }
  if ((cVar6 == '\0') || (cVar6 = FUN_14008ee50(&local_750), cVar6 != '\0')) {
    uVar7 = 0;
  }
  else {
    uVar7 = 1;
  }
  _eh_vector_destructor_iterator_(local_138,0x20,8,FUN_140017b90);
  FUN_140018ba0(local_158);
  FUN_140018ba0(local_188);
  FUN_140017b90(local_1a8);
  FUN_140017b90(local_1c8);
  FUN_140067fd0(local_5a8);
  FUN_14000b880(local_730,local_730,*(undefined8 *)(local_730[0] + 8));
  thunk_FUN_1403f2404(local_730[0],0x80);
  FUN_140018440(&local_5d8);
  FUN_140018570(&local_6d8);
  FUN_140018570(&local_6b8);
  FUN_140017d70(&local_670);
  if ((local_679 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_697,local_698),local_678,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  FUN_140018ba0(&local_770);
  FUN_140017ca0(&local_7b0);
  FUN_140017ca0(local_730 + 2);
  FUN_140018440(&local_700);
  if ((local_631 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(local_650[0],uStack_630,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  FUN_14000b880(&local_750,&local_750,*(undefined8 *)(local_750 + 8));
  thunk_FUN_1403f2404(local_750,0x80);
  return uVar7;
}
```

## `HandleCompileComputeKernelCommand` — `0x1400b4100`

`Cmd: compileComputeKernel`

```c
byte HandleCompileComputeKernelCommand
               (undefined8 param_1,longlong *param_2,undefined8 *param_3,longlong *param_4,
               longlong *param_5,longlong *param_6,int param_7,undefined1 param_8,undefined1 param_9
               ,undefined8 param_10,int param_11,ulonglong param_12,ulonglong param_13,
               undefined4 param_14,undefined4 param_15,longlong param_16,undefined8 param_17)

{
  byte bVar1;
  undefined8 uVar2;
  longlong *plVar3;
  undefined8 *puVar4;
  ulonglong uVar5;
  longlong lVar6;
  longlong lVar7;
  ulonglong uVar8;
  longlong *local_338;
  longlong local_330;
  undefined8 *local_328;
  longlong local_320;
  longlong local_318 [2];
  undefined1 local_308 [32];
  int local_2e8;
  ulonglong local_2e0;
  undefined4 local_2d8;
  ulonglong local_2d0;
  undefined8 local_2b8;
  undefined1 local_2b0;
  undefined1 local_2af;
  undefined4 local_2ac;
  undefined4 local_2a8;
  int local_2a4;
  longlong local_2a0 [10];
  undefined8 local_250 [45];
  undefined1 local_e8 [32];
  undefined1 local_c8 [56];
  longlong local_90 [2];
  ulonglong local_80;
  ulonglong local_78;
  
  FUN_140015c70(local_308);
  local_2a4 = param_7;
  local_2b8 = param_1;
  if (local_2a0 != param_2) {
    if (*(byte *)((longlong)param_2 + 0x1f) < 0x40) {
      lVar7 = 0x1f - (longlong)*(char *)((longlong)param_2 + 0x1f);
      plVar3 = param_2;
    }
    else {
      lVar7 = param_2[2];
      plVar3 = (longlong *)*param_2;
    }
    FUN_140054780(local_2a0,plVar3,lVar7);
  }
  FUN_140054d80(local_e8,DAT_140728518,DAT_140728518 + DAT_140728528 * 0x28);
  FUN_140019e80(local_c8,&PTR_DAT_140728538);
  if (*(byte *)((longlong)param_2 + 0x1f) < 0x40) {
    local_330 = 0x1f - (longlong)*(char *)((longlong)param_2 + 0x1f);
  }
  else {
    local_330 = param_2[2];
    param_2 = (longlong *)*param_2;
  }
  local_338 = param_2;
  uVar2 = FUN_1400e0430(&local_328,&local_338);
  FUN_1400c0f50(local_e8,uVar2);
  local_2d8 = FUN_1400c8450(local_2b8,param_11);
  local_2e8 = param_11;
  local_2d0 = param_12;
  local_2b0 = param_8;
  local_2af = param_9;
  local_2ac = param_14;
  local_2a8 = param_15;
  local_2e0 = param_13;
  if (local_250 != param_3) {
    if (*(byte *)((longlong)param_3 + 0x1f) < 0x40) {
      lVar7 = 0x1f - (longlong)*(char *)((longlong)param_3 + 0x1f);
    }
    else {
      lVar7 = param_3[2];
      param_3 = (undefined8 *)*param_3;
    }
    FUN_140054780(local_250,param_3,lVar7);
  }
  uVar8 = 0;
  if (param_4[2] != 0) {
    lVar7 = 0;
    do {
      puVar4 = (undefined8 *)(*param_4 + 0x28 + lVar7);
      plVar3 = (longlong *)(lVar7 + *param_4);
      uVar5 = local_80 + 1;
      if (local_78 >> 1 < uVar5) {
        FUN_140057330(local_90);
      }
      lVar6 = local_90[0] + -0x50 + uVar5 * 0x50;
      local_80 = uVar5;
      if (lVar6 != 0) {
        if (*(byte *)((longlong)puVar4 + 0x1f) < 0x40) {
          local_320 = 0x1f - (longlong)*(char *)((longlong)puVar4 + 0x1f);
        }
        else {
          local_320 = puVar4[2];
          puVar4 = (undefined8 *)*puVar4;
        }
        if (*(byte *)((longlong)plVar3 + 0x1f) < 0x40) {
          local_330 = 0x1f - (longlong)*(char *)((longlong)plVar3 + 0x1f);
        }
        else {
          local_330 = plVar3[2];
          plVar3 = (longlong *)*plVar3;
        }
        local_338 = plVar3;
        local_328 = puVar4;
        FUN_140014b30(lVar6,&local_338,0x4b);
        FUN_140014b30(lVar6 + 0x28,&local_328,0x4b);
      }
      uVar8 = uVar8 + 1;
      lVar7 = lVar7 + 0x50;
    } while (uVar8 < (ulonglong)param_4[2]);
  }
  uVar8 = 0;
  if (param_5[2] != 0) {
    lVar7 = 0;
    do {
      puVar4 = (undefined8 *)(*param_5 + lVar7);
      uVar5 = local_80 + 1;
      if (local_78 >> 1 < uVar5) {
        FUN_140057330(local_90);
      }
      lVar6 = local_90[0] + -0x50 + uVar5 * 0x50;
      local_80 = uVar5;
      if (lVar6 != 0) {
        local_338 = (longlong *)PTR_DAT_1407285a0;
        local_330 = DAT_1407285a8;
        if (*(byte *)((longlong)puVar4 + 0x1f) < 0x40) {
          local_320 = 0x1f - (longlong)*(char *)((longlong)puVar4 + 0x1f);
        }
        else {
          local_320 = puVar4[2];
          puVar4 = (undefined8 *)*puVar4;
        }
        local_328 = puVar4;
        FUN_140014b30(lVar6,&local_328,0x4b);
        FUN_140014b30(lVar6 + 0x28,&local_338,0x4b);
      }
      uVar8 = uVar8 + 1;
      lVar7 = lVar7 + 0x28;
    } while (uVar8 < (ulonglong)param_5[2]);
  }
  uVar8 = 0;
  if (param_6[2] != 0) {
    lVar7 = 0;
    do {
      puVar4 = (undefined8 *)(*param_6 + lVar7);
      uVar5 = local_80 + 1;
      if (local_78 >> 1 < uVar5) {
        FUN_140057330(local_90);
      }
      lVar6 = local_90[0] + -0x50 + uVar5 * 0x50;
      local_80 = uVar5;
      if (lVar6 != 0) {
        local_338 = (longlong *)PTR_DAT_1407285a0;
        local_330 = DAT_1407285a8;
        if (*(byte *)((longlong)puVar4 + 0x1f) < 0x40) {
          local_320 = 0x1f - (longlong)*(char *)((longlong)puVar4 + 0x1f);
        }
        else {
          local_320 = puVar4[2];
          puVar4 = (undefined8 *)*puVar4;
        }
        local_328 = puVar4;
        FUN_140014b30(lVar6,&local_328,0x4b);
        FUN_140014b30(lVar6 + 0x28,&local_338,0x4b);
      }
      uVar8 = uVar8 + 1;
      lVar7 = lVar7 + 0x28;
    } while (uVar8 < (ulonglong)param_6[2]);
  }
  lVar7 = (longlong)param_7;
  if (-1 < param_7) {
    if ((byte)(&DAT_14074ed3f)[lVar7 * 0x50] < 0x40) {
      lVar6 = 0x1f - (longlong)(char)(&DAT_14074ed3f)[lVar7 * 0x50];
    }
    else {
      lVar6 = *(longlong *)(&DAT_14074ed30 + lVar7 * 0x50);
    }
    if (lVar6 != 0) {
      uVar8 = local_80 + 1;
      if (local_78 >> 1 < uVar8) {
        FUN_140057330(local_90);
      }
      lVar6 = local_90[0] + -0x50 + uVar8 * 0x50;
      local_80 = uVar8;
      if (lVar6 != 0) {
        FUN_1400149f0(lVar6,&DAT_14074ed20 + lVar7 * 0x50);
        FUN_1400149f0(lVar6 + 0x28,&DAT_14074ed48 + lVar7 * 0x50);
      }
    }
  }
  SetCompilerAvailabilityMacros
            (local_2e0 | *(ulonglong *)(&DAT_140728a90 + (longlong)local_2e8 * 8),local_90);
  local_2d0 = local_2d0 | 0x8000;
  plVar3 = (longlong *)(**(code **)(*DAT_14074ece0 + 0x28))(DAT_14074ece0,local_308);
  local_318[0] = 0;
  local_318[1] = 0;
  local_318[0] = FUN_1400e40a0(0x80);
  *(longlong *)local_318[0] = local_318[0];
  *(longlong *)(local_318[0] + 8) = local_318[0];
  *(longlong *)(local_318[0] + 0x10) = local_318[0];
  *(undefined2 *)(local_318[0] + 0x18) = 0x101;
  CollectCompiledPrograms(local_318,local_308,plVar3);
  if (param_16 != 0) {
    FUN_14008fc70(local_318,param_16,param_17);
  }
  bVar1 = FUN_14008ee50(local_318);
  if (bVar1 == 0) {
    lVar7 = (**(code **)(*plVar3 + 8))(plVar3);
    if (lVar7 != 0) {
      lVar6 = (**(code **)(*plVar3 + 0x10))(plVar3);
      FUN_1400af770(param_10,lVar7,lVar7 + lVar6);
    }
  }
  (**(code **)(*DAT_14074ece0 + 0x38))(DAT_14074ece0,plVar3);
  FUN_14000b880(local_318,local_318,*(undefined8 *)(local_318[0] + 8));
  thunk_FUN_1403f2404(local_318[0],0x80);
  FUN_140019570(local_308);
  return bVar1 ^ 1;
}
```

## `HandleCompileRayTracingShaderCommand` — `0x1400b4760`

`Cmd: compileRayTracingShader`

```c
byte HandleCompileRayTracingShaderCommand
               (undefined8 param_1,undefined8 *param_2,int param_3,longlong *param_4,
               longlong *param_5,longlong *param_6,undefined8 param_7,undefined4 param_8,
               undefined8 param_9,undefined8 param_10,undefined4 param_11,longlong param_12,
               undefined8 param_13)

{
  byte bVar1;
  undefined8 uVar2;
  longlong *plVar3;
  undefined8 *puVar4;
  ulonglong uVar5;
  ulonglong uVar6;
  longlong lVar7;
  longlong lVar8;
  longlong lVar9;
  undefined8 *local_388;
  longlong local_380;
  undefined8 *local_378;
  longlong local_370;
  longlong local_368 [2];
  undefined1 local_358;
  undefined7 uStack_357;
  undefined8 uStack_350;
  undefined8 local_348;
  undefined7 uStack_340;
  byte bStack_339;
  undefined2 local_338;
  uint local_330;
  undefined4 uStack_32c;
  undefined4 uStack_328;
  undefined4 uStack_324;
  undefined8 local_320;
  undefined7 uStack_318;
  byte bStack_311;
  undefined2 local_310;
  undefined1 local_308 [8];
  undefined8 local_300;
  undefined4 local_2e8;
  undefined8 local_2e0;
  undefined4 local_2d8;
  undefined8 local_2d0;
  undefined4 local_2c8;
  undefined8 local_2b8;
  int local_2a4;
  undefined8 local_2a0 [10];
  undefined1 local_250 [360];
  undefined1 local_e8 [32];
  undefined1 local_c8 [56];
  longlong local_90 [2];
  ulonglong local_80;
  ulonglong local_78;
  
  lVar9 = (longlong)param_3;
  FUN_140015c70(local_308);
  local_2b8 = param_1;
  local_2a4 = param_3;
  FUN_14008ac80(param_1);
  if (local_2a0 != param_2) {
    if (*(byte *)((longlong)param_2 + 0x1f) < 0x40) {
      lVar8 = 0x1f - (longlong)*(char *)((longlong)param_2 + 0x1f);
      puVar4 = param_2;
    }
    else {
      lVar8 = param_2[2];
      puVar4 = (undefined8 *)*param_2;
    }
    FUN_140054780(local_2a0,puVar4,lVar8);
  }
  FUN_140054d80(local_e8,DAT_140728518,DAT_140728518 + DAT_140728528 * 0x28);
  FUN_140019e80(local_c8,&PTR_DAT_140728538);
  if (*(byte *)((longlong)param_2 + 0x1f) < 0x40) {
    local_380 = 0x1f - (longlong)*(char *)((longlong)param_2 + 0x1f);
  }
  else {
    local_380 = param_2[2];
    param_2 = (undefined8 *)*param_2;
  }
  local_388 = param_2;
  uVar2 = FUN_1400e0430(&local_378,&local_388);
  FUN_1400c0f50(local_e8,uVar2);
  local_2d8 = FUN_1400c8450(local_2b8,param_8);
  local_2e8 = param_8;
  local_2d0 = param_9;
  local_2c8 = param_11;
  local_300 = 0;
  FUN_140054780(local_250,&DAT_140578094,0);
  local_2e0 = param_10;
  uVar6 = 0;
  if (param_4[2] != 0) {
    lVar8 = 0;
    do {
      local_378 = (undefined8 *)(*param_4 + 0x28 + lVar8);
      if (*(byte *)((longlong)local_378 + 0x1f) < 0x40) {
        local_370 = 0x1f - (longlong)*(char *)((longlong)local_378 + 0x1f);
      }
      else {
        local_370 = local_378[2];
        local_378 = (undefined8 *)*local_378;
      }
      local_388 = (undefined8 *)(*param_4 + lVar8);
      if (*(byte *)((longlong)local_388 + 0x1f) < 0x40) {
        local_380 = 0x1f - (longlong)*(char *)((longlong)local_388 + 0x1f);
      }
      else {
        local_380 = local_388[2];
        local_388 = (undefined8 *)*local_388;
      }
      FUN_140014b30(&local_358,&local_388,0x4b);
      FUN_140014b30(&local_330,&local_378,0x4b);
      uVar5 = local_80 + 1;
      if (local_78 >> 1 < uVar5) {
        FUN_140057330(local_90);
      }
      puVar4 = (undefined8 *)(local_90[0] + -0x50 + uVar5 * 0x50);
      if (puVar4 != (undefined8 *)0x0) {
        *(undefined2 *)(puVar4 + 4) = local_338;
        *puVar4 = CONCAT71(uStack_357,local_358);
        puVar4[1] = uStack_350;
        if (bStack_339 >> 6 == 0) {
          puVar4[2] = local_348;
          puVar4[3] = CONCAT17(bStack_339,uStack_340);
        }
        else {
          puVar4[2] = local_348;
        }
        *(byte *)((longlong)puVar4 + 0x1f) = *(byte *)((longlong)puVar4 + 0x1f) & 0x3f;
        *(byte *)((longlong)puVar4 + 0x1f) = *(byte *)((longlong)puVar4 + 0x1f) | bStack_339 & 0xc0;
        local_358 = 0;
        bStack_339 = 0x1f;
        *(undefined2 *)(puVar4 + 9) = local_310;
        *(uint *)(puVar4 + 5) = local_330;
        *(undefined4 *)((longlong)puVar4 + 0x2c) = uStack_32c;
        *(undefined4 *)(puVar4 + 6) = uStack_328;
        *(undefined4 *)((longlong)puVar4 + 0x34) = uStack_324;
        if (bStack_311 >> 6 == 0) {
          puVar4[7] = local_320;
          puVar4[8] = CONCAT17(bStack_311,uStack_318);
        }
        else {
          puVar4[7] = local_320;
        }
        *(byte *)((longlong)puVar4 + 0x47) = *(byte *)((longlong)puVar4 + 0x47) & 0x3f;
        *(byte *)((longlong)puVar4 + 0x47) = *(byte *)((longlong)puVar4 + 0x47) | bStack_311 & 0xc0;
        local_330 = local_330 & 0xffffff00;
        bStack_311 = 0x1f;
      }
      local_80 = uVar5;
      if ((bStack_311 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(CONCAT44(uStack_32c,local_330),local_310,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      if ((bStack_339 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(CONCAT71(uStack_357,local_358),local_338,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      uVar6 = uVar6 + 1;
      lVar8 = lVar8 + 0x50;
    } while (uVar6 < (ulonglong)param_4[2]);
  }
  uVar6 = 0;
  if (param_5[2] != 0) {
    lVar8 = 0;
    do {
      puVar4 = (undefined8 *)(*param_5 + lVar8);
      uVar5 = local_80 + 1;
      if (local_78 >> 1 < uVar5) {
        FUN_140057330(local_90);
      }
      lVar7 = local_90[0] + -0x50 + uVar5 * 0x50;
      local_80 = uVar5;
      if (lVar7 != 0) {
        local_388 = (undefined8 *)PTR_DAT_1407285a0;
        local_380 = DAT_1407285a8;
        if (*(byte *)((longlong)puVar4 + 0x1f) < 0x40) {
          local_370 = 0x1f - (longlong)*(char *)((longlong)puVar4 + 0x1f);
        }
        else {
          local_370 = puVar4[2];
          puVar4 = (undefined8 *)*puVar4;
        }
        local_378 = puVar4;
        FUN_140014b30(lVar7,&local_378,0x4b);
        FUN_140014b30(lVar7 + 0x28,&local_388,0x4b);
      }
      uVar6 = uVar6 + 1;
      lVar8 = lVar8 + 0x28;
    } while (uVar6 < (ulonglong)param_5[2]);
  }
  uVar6 = 0;
  if (param_6[2] != 0) {
    lVar8 = 0;
    do {
      puVar4 = (undefined8 *)(*param_6 + lVar8);
      uVar5 = local_80 + 1;
      if (local_78 >> 1 < uVar5) {
        FUN_140057330(local_90);
      }
      lVar7 = local_90[0] + -0x50 + uVar5 * 0x50;
      local_80 = uVar5;
      if (lVar7 != 0) {
        local_388 = (undefined8 *)PTR_DAT_1407285a0;
        local_380 = DAT_1407285a8;
        if (*(byte *)((longlong)puVar4 + 0x1f) < 0x40) {
          local_370 = 0x1f - (longlong)*(char *)((longlong)puVar4 + 0x1f);
        }
        else {
          local_370 = puVar4[2];
          puVar4 = (undefined8 *)*puVar4;
        }
        local_378 = puVar4;
        FUN_140014b30(lVar7,&local_378,0x4b);
        FUN_140014b30(lVar7 + 0x28,&local_388,0x4b);
      }
      uVar6 = uVar6 + 1;
      lVar8 = lVar8 + 0x28;
    } while (uVar6 < (ulonglong)param_6[2]);
  }
  if (-1 < param_3) {
    if ((byte)(&DAT_14074ed3f)[lVar9 * 0x50] < 0x40) {
      lVar8 = 0x1f - (longlong)(char)(&DAT_14074ed3f)[lVar9 * 0x50];
    }
    else {
      lVar8 = *(longlong *)(&DAT_14074ed30 + lVar9 * 0x50);
    }
    if (lVar8 != 0) {
      uVar6 = local_80 + 1;
      if (local_78 >> 1 < uVar6) {
        FUN_140057330(local_90);
      }
      lVar8 = local_90[0] + -0x50 + uVar6 * 0x50;
      local_80 = uVar6;
      if (lVar8 != 0) {
        FUN_1400149f0(lVar8,&DAT_14074ed20 + lVar9 * 0x50);
        FUN_1400149f0(lVar8 + 0x28,&DAT_14074ed48 + lVar9 * 0x50);
      }
    }
  }
  plVar3 = (longlong *)(**(code **)(*DAT_14074ece0 + 0x30))(DAT_14074ece0,local_308);
  local_368[0] = 0;
  local_368[1] = 0;
  local_368[0] = FUN_1400e40a0(0x80);
  *(longlong *)local_368[0] = local_368[0];
  *(longlong *)(local_368[0] + 8) = local_368[0];
  *(longlong *)(local_368[0] + 0x10) = local_368[0];
  *(undefined2 *)(local_368[0] + 0x18) = 0x101;
  CollectCompiledPrograms(local_368,local_308,plVar3);
  if (param_12 != 0) {
    FUN_14008fc70(local_368,param_12,param_13);
  }
  bVar1 = FUN_14008ee50(local_368);
  if ((bVar1 == 0) && (lVar9 = (**(code **)(*plVar3 + 8))(plVar3), lVar9 != 0)) {
    lVar8 = (**(code **)(*plVar3 + 0x10))(plVar3);
    FUN_1400af770(param_7,lVar9,lVar9 + lVar8);
  }
  (**(code **)(*DAT_14074ece0 + 0x38))(DAT_14074ece0,plVar3);
  FUN_14000b880(local_368,local_368,*(undefined8 *)(local_368[0] + 8));
  thunk_FUN_1403f2404(local_368[0],0x80);
  FUN_140019570(local_308);
  return bVar1 ^ 1;
}
```

## `HandleRayTracingPreprocessRequest` — `0x1400b7270`

`Cmd: preprocessRayTracingShader`

```c
undefined8
HandleRayTracingPreprocessRequest
          (undefined8 *param_1,longlong *param_2,longlong param_3,undefined4 *param_4,
          undefined1 *param_5,undefined8 *param_6,undefined8 param_7,undefined8 param_8,
          uint *param_9,undefined8 param_10,longlong param_11,undefined8 param_12,longlong param_13,
          undefined8 param_14)

{
  uint uVar1;
  uint uVar2;
  bool bVar3;
  char cVar4;
  undefined8 uVar5;
  longlong lVar6;
  undefined1 *puVar7;
  longlong lVar8;
  ulonglong uVar9;
  byte *pbVar10;
  uint uVar11;
  longlong lVar12;
  undefined8 *puVar13;
  longlong *plVar14;
  longlong *plVar15;
  ulonglong uVar16;
  undefined8 *puVar17;
  undefined8 in_stack_fffffffffffff840;
  undefined4 uVar18;
  longlong *local_770;
  longlong local_768;
  longlong *local_760;
  longlong local_758;
  undefined8 local_750;
  byte *local_748;
  longlong local_740;
  longlong local_738;
  undefined2 local_730;
  ulonglong local_728;
  ulonglong local_720;
  longlong local_718;
  undefined2 local_710;
  ulonglong local_708;
  ulonglong local_700;
  longlong local_6f8 [2];
  longlong *local_6e8;
  undefined8 local_6e0 [2];
  longlong local_6d0;
  byte local_6c1;
  undefined2 local_6c0;
  undefined8 local_6b8;
  undefined4 local_6b0;
  undefined1 local_6ac;
  undefined *local_6a8;
  longlong local_6a0;
  longlong local_698;
  undefined2 local_690;
  ulonglong local_688;
  ulonglong local_680;
  undefined8 local_678;
  undefined2 local_670;
  longlong local_668;
  undefined8 local_660;
  undefined8 local_658;
  undefined2 local_650;
  longlong local_648;
  undefined8 local_640;
  undefined1 local_638;
  undefined7 uStack_637;
  undefined8 local_628;
  byte local_619;
  undefined2 local_618;
  undefined8 local_610;
  undefined2 local_608;
  undefined8 local_600;
  undefined8 local_5f8;
  undefined8 local_5f0;
  undefined4 local_5e8;
  undefined1 local_5e4;
  undefined1 local_5e0;
  undefined7 uStack_5df;
  byte local_5c1;
  undefined2 local_5c0;
  undefined4 local_5b8;
  undefined1 local_5a8 [704];
  longlong local_2e8;
  longlong local_2d8;
  longlong local_2c8;
  longlong local_2b8;
  undefined1 local_1c8 [32];
  undefined1 local_1a8 [32];
  undefined1 local_188 [48];
  undefined1 local_158 [32];
  undefined1 local_138 [256];
  
  local_758 = 0;
  local_750 = 0;
  local_758 = FUN_1400e40a0(0x80);
  *(longlong *)local_758 = local_758;
  *(longlong *)(local_758 + 8) = local_758;
  *(longlong *)(local_758 + 0x10) = local_758;
  *(undefined2 *)(local_758 + 0x18) = 0x101;
  if ((undefined8 *)(param_3 + 0x28) != &DAT_140728518) {
    FUN_140054d80((undefined8 *)(param_3 + 0x28),DAT_140728518,DAT_140728518 + DAT_140728528 * 0x28)
    ;
  }
  FUN_140019e80(param_3 + 0x48,&PTR_DAT_140728538);
  if (*(byte *)((longlong)param_2 + 0x1f) < 0x40) {
    local_768 = 0x1f - (longlong)*(char *)((longlong)param_2 + 0x1f);
  }
  else {
    local_768 = param_2[2];
    param_2 = (longlong *)*param_2;
  }
  local_770 = param_2;
  uVar5 = FUN_1400e0430(&local_6a8,&local_770);
  FUN_1400c0f50(param_3 + 0x28,uVar5);
  if (*(byte *)((longlong)param_1 + 0x1f) < 0x40) {
    lVar8 = 0x1f - (longlong)*(char *)((longlong)param_1 + 0x1f);
    lVar6 = 0x1f - (longlong)*(char *)((longlong)param_1 + 0x1f);
    puVar17 = param_1;
  }
  else {
    puVar17 = (undefined8 *)*param_1;
    lVar8 = param_1[2];
    lVar6 = lVar8;
  }
  cVar4 = FUN_1400e4970(puVar17,lVar8);
  puVar13 = (undefined8 *)((longlong)puVar17 + 3);
  lVar8 = lVar6 + -3;
  if (cVar4 == '\0') {
    puVar13 = puVar17;
    lVar8 = lVar6;
  }
  local_6c0 = 0x4b;
  local_6e0[0]._0_1_ = 0;
  local_6c1 = 0x1f;
  lVar6 = FUN_140056c90(local_6e0,lVar8);
  FUN_140558820(lVar6,puVar13,lVar8);
  *(undefined1 *)(lVar8 + lVar6) = 0;
  if (local_6c1 < 0x40) {
    local_6c1 = 0x1f - (char)lVar8;
    lVar8 = local_6d0;
  }
  local_6d0 = lVar8;
  PrepareBackendSourceBuffer(local_6e0);
  uVar18 = (undefined4)((ulonglong)in_stack_fffffffffffff840 >> 0x20);
  lVar6 = 0;
  local_698 = 0;
  local_690 = 1;
  local_688 = 0;
  local_680 = 1;
  local_738 = 0;
  local_730 = 1;
  local_728 = 0;
  local_720 = 1;
  local_718 = 0;
  local_710 = 1;
  local_708 = 0;
  local_700 = 1;
  local_618 = 1;
  local_638 = 0;
  local_619 = 0x1f;
  local_610 = 0;
  local_608 = 1;
  local_600 = 0;
  local_5f8 = 1;
  local_658 = 0;
  local_650 = 1;
  local_648 = 0;
  local_640 = 1;
  local_678 = 0;
  local_670 = 1;
  local_668 = 0;
  local_660 = 1;
  for (lVar8 = *(longlong *)(param_3 + 0x78); lVar8 != 0; lVar8 = lVar8 + -1) {
    plVar14 = (longlong *)(*(longlong *)(param_3 + 0x68) + lVar6);
    uVar9 = local_728 + 1;
    if (local_720 >> 1 < uVar9) {
      FUN_140057330(&local_738);
    }
    lVar12 = local_738 + -0x50 + uVar9 * 0x50;
    local_728 = uVar9;
    local_6e8 = (longlong *)lVar12;
    if (lVar12 != 0) {
      local_748 = PTR_DAT_1407285a0;
      local_740 = DAT_1407285a8;
      if (*(byte *)((longlong)plVar14 + 0x1f) < 0x40) {
        local_768 = 0x1f - (longlong)*(char *)((longlong)plVar14 + 0x1f);
      }
      else {
        local_768 = plVar14[2];
        plVar14 = (longlong *)*plVar14;
      }
      local_770 = plVar14;
      FUN_140014b30(lVar12,&local_770,0x4b);
      FUN_140014b30(lVar12 + 0x28,&local_748,0x4b);
    }
    uVar18 = (undefined4)((ulonglong)in_stack_fffffffffffff840 >> 0x20);
    lVar6 = lVar6 + 0x28;
  }
  plVar14 = (longlong *)FUN_1400e16b0(&local_5e0,0x393fc3d);
  uVar9 = local_728 + 1;
  if (local_720 >> 1 < uVar9) {
    FUN_140057330(&local_738);
  }
  plVar15 = (longlong *)(local_738 + -0x50 + uVar9 * 0x50);
  local_760 = plVar15;
  local_728 = uVar9;
  local_6e8 = plVar15;
  if (plVar15 != (longlong *)0x0) {
    if (*(byte *)((longlong)plVar14 + 0x1f) < 0x40) {
      local_768 = 0x1f - (longlong)*(char *)((longlong)plVar14 + 0x1f);
    }
    else {
      local_768 = plVar14[2];
      plVar14 = (longlong *)*plVar14;
    }
    local_748 = PTR_s_UNITY_VERSION_140728550;
    local_740 = DAT_140728558;
    local_770 = plVar14;
    FUN_140014b30(plVar15,&local_748,0x4b);
    FUN_140014b30(plVar15 + 5,&local_770,0x4b);
  }
  if ((local_5c1 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_5df,local_5e0),local_5c0,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  lVar8 = (longlong)*(int *)(param_3 + 0x60);
  if (-1 < *(int *)(param_3 + 0x60)) {
    if ((byte)(&DAT_14074ed3f)[lVar8 * 0x50] < 0x40) {
      lVar6 = 0x1f - (longlong)(char)(&DAT_14074ed3f)[lVar8 * 0x50];
    }
    else {
      lVar6 = *(longlong *)(&DAT_14074ed30 + lVar8 * 0x50);
    }
    if (lVar6 != 0) {
      uVar9 = local_688 + 1;
      if (local_680 >> 1 < uVar9) {
        FUN_140057330(&local_698);
      }
      plVar14 = (longlong *)(local_698 + -0x50 + uVar9 * 0x50);
      local_760 = plVar14;
      local_6e8 = plVar14;
      local_688 = uVar9;
      if (plVar14 != (longlong *)0x0) {
        FUN_1400149f0(plVar14,&DAT_14074ed20 + lVar8 * 0x50);
        FUN_1400149f0(plVar14 + 5,&DAT_14074ed48 + lVar8 * 0x50);
      }
    }
  }
  PrepareStageSourceSegment(*(undefined4 *)(param_3 + 0x60),&local_718);
  puVar17 = &DAT_1407284f0;
  ProcessShaderPreprocessor
            (param_3,local_6e0,param_3 + 0x28,&local_698,&local_738,&local_718,&DAT_1407284f0,
             CONCAT44(uVar18,0x10e),&local_638,&local_610,param_11,&local_658,&local_678,param_10,0)
  ;
  lVar8 = 0;
  local_5f0 = 0;
  local_5e8 = 1;
  local_5e4 = 1;
  local_6f8[0] = 0;
  local_6f8[1] = 0;
  local_6f8[0] = FUN_1400e40a0(0x80);
  *(longlong *)local_6f8[0] = local_6f8[0];
  *(longlong *)(local_6f8[0] + 8) = local_6f8[0];
  *(longlong *)(local_6f8[0] + 0x10) = local_6f8[0];
  *(undefined2 *)(local_6f8[0] + 0x18) = 0x101;
  FUN_140066c70(local_5a8);
  FUN_140092c70(&local_610,local_5a8,&local_5f0,param_9,param_12,local_6f8);
  FUN_140096660(&local_718,local_718 + local_708 * 0x28,local_2e8,local_2e8 + local_2d8 * 0x28);
  FUN_140096660(&local_718,local_718 + local_708 * 0x28,local_2c8,local_2c8 + local_2b8 * 0x28);
  bVar3 = false;
  uVar1 = *(uint *)(param_3 + 100);
  uVar2 = *param_9;
  uVar11 = 1;
  pbVar10 = &DAT_1407280af;
  lVar6 = 0x1c;
  do {
    uVar9 = local_708;
    if ((uVar1 & uVar2 & uVar11 & 0xdfdde30) != 0) {
      if (bVar3) {
        if ((&DAT_1405887d0)[lVar8] == '\0') {
          uVar16 = local_708 + 1;
          if (local_700 >> 1 < uVar16) {
            FUN_1400575b0(&local_718);
          }
          local_770 = (longlong *)(local_718 + uVar9 * 0x28);
          local_760 = local_770;
          local_708 = uVar16;
          if (local_770 != (longlong *)0x0) {
            local_760 = local_770;
            FUN_140014a90(local_770,pbVar10 + -0x1f,local_710);
          }
        }
      }
      else {
        bVar3 = true;
        uVar9 = local_728 + 1;
        if (local_720 >> 1 < uVar9) {
          FUN_140057330(&local_738);
        }
        plVar14 = (longlong *)(local_738 + -0x50 + uVar9 * 0x50);
        local_760 = plVar14;
        local_728 = uVar9;
        local_6e8 = plVar14;
        if (plVar14 != (longlong *)0x0) {
          local_6a8 = PTR_DAT_1407285a0;
          local_6a0 = DAT_1407285a8;
          if (*pbVar10 < 0x40) {
            local_740 = 0x1f - (longlong)(char)*pbVar10;
            local_748 = pbVar10 + -0x1f;
          }
          else {
            local_740 = *(longlong *)(pbVar10 + -0xf);
            local_748 = *(byte **)(pbVar10 + -0x1f);
          }
          FUN_140014b30(plVar14,&local_748,0x4b);
          FUN_140014b30(plVar14 + 5,&local_6a8,0x4b);
        }
      }
    }
    uVar18 = (undefined4)((ulonglong)puVar17 >> 0x20);
    lVar8 = lVar8 + 1;
    pbVar10 = pbVar10 + 0x28;
    uVar11 = uVar11 << 1 | (uint)((int)uVar11 < 0);
    lVar6 = lVar6 + -1;
  } while (lVar6 != 0);
  PrepareComputeStageSource(local_158,&local_738);
  local_5c0 = 0x4b;
  local_5e0 = 0;
  local_5c1 = 0x1f;
  local_5b8 = 0;
  FUN_1400c9f10(&local_610,0,&local_5e0,1);
  if ((local_5c1 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_5df,local_5e0),local_5c0,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  FUN_1400c9ae0(param_11);
  FUN_1400c9ae0(param_11 + 0x18);
  lVar8 = local_648;
  local_648 = 0;
  if (lVar8 != 0) {
    FUN_14000fef0(local_658);
  }
  lVar8 = local_668;
  local_668 = 0;
  if (lVar8 != 0) {
    FUN_14000fef0(local_678);
  }
  if (local_619 < 0x40) {
    local_619 = 0x1f;
    puVar7 = &local_638;
  }
  else {
    local_628 = 0;
    puVar7 = (undefined1 *)CONCAT71(uStack_637,local_638);
  }
  *puVar7 = 0;
  ProcessPreprocessorIncludeStack
            (param_3,param_3 + 0x28,&local_698,&local_738,&local_718,&DAT_1407284f0,
             CONCAT44(uVar18,0x306),param_8,&local_638,&local_610,param_11,&local_658,&local_678,
             param_10);
  ProcessPreprocessorPragmaState(&local_658,&local_678,&local_758);
  local_6b8 = 0;
  local_6b0 = 1;
  local_6ac = 1;
  cVar4 = FUN_140092c70(&local_610,param_7,&local_6b8,param_9,param_12,&local_758);
  if (param_1 != local_6e0) {
    lVar8 = local_6d0;
    if (local_6c1 < 0x40) {
      lVar8 = 0x1f - (longlong)(char)local_6c1;
    }
    puVar17 = local_6e0;
    if (0x3f < local_6c1) {
      puVar17 = (undefined8 *)CONCAT71(local_6e0[0]._1_7_,(undefined1)local_6e0[0]);
    }
    FUN_140054780(param_1,puVar17,lVar8);
  }
  FUN_1400955e0(param_7,param_8);
  *param_6 = local_6b8;
  *param_4 = local_6b0;
  *param_5 = local_6ac;
  if (param_13 != 0) {
    FUN_14008fc70(&local_758,param_13,param_14);
  }
  if ((cVar4 == '\0') || (cVar4 = FUN_14008ee50(&local_758), cVar4 != '\0')) {
    uVar5 = 0;
  }
  else {
    uVar5 = 1;
  }
  _eh_vector_destructor_iterator_(local_138,0x20,8,FUN_140017b90);
  FUN_140018ba0(local_158);
  FUN_140018ba0(local_188);
  FUN_140017b90(local_1a8);
  FUN_140017b90(local_1c8);
  FUN_140067fd0(local_5a8);
  FUN_14000b880(local_6f8,local_6f8,*(undefined8 *)(local_6f8[0] + 8));
  thunk_FUN_1403f2404(local_6f8[0],0x80);
  FUN_140018570(&local_678);
  FUN_140018570(&local_658);
  FUN_140017d70(&local_610);
  if ((local_619 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_637,local_638),local_618,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  FUN_140018ba0(&local_718);
  FUN_140017ca0(&local_738);
  FUN_140017ca0(&local_698);
  if ((local_6c1 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(local_6e0[0]._1_7_,(undefined1)local_6e0[0]),local_6c0,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  FUN_14000b880(&local_758,&local_758,*(undefined8 *)(local_758 + 8));
  thunk_FUN_1403f2404(local_758,0x80);
  return uVar5;
}
```
