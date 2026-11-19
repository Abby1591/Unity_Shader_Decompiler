# IPC transport and worker loop

Ghidra decompilation of `UnityShaderCompiler.exe` (image base `0x140000000`).
Function names and leading comments are the annotations recorded in the Ghidra
database; the bodies are otherwise unedited decompiler output. See
[`shader_compiler_analysis.md`](../shader_compiler_analysis.md) for the prose
description of the same pipeline.

## `RunShaderCompilerWorkerLoop` — `0x1400d0770`

worker main loop: connects the loopback IPC stream and dispatches one command per iteration

```c
/* WARNING: Removing unreachable block (ram,0x0001400d0d1a) */
/* WARNING: Type propagation algorithm not settling */
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* Worker main loop. Connects the loopback IPC stream ("127.0.0.1"; "Couldn't create/connect IPC
   stream"), reads one text command per iteration and hands it to CmdDispatcher_Dispatch. EOF is
   fatal ("IPC connection closed"). */

longlong *
RunShaderCompilerWorkerLoop
          (undefined8 *param_1,ulonglong param_2,undefined1 param_3,char param_4,undefined8 *param_5
          ,undefined8 *param_6)

{
  undefined8 uVar1;
  undefined8 *puVar2;
  char cVar3;
  int iVar4;
  longlong *plVar5;
  longlong lVar6;
  longlong *plVar7;
  undefined8 uVar8;
  longlong lVar9;
  char *pcVar10;
  undefined8 *puVar11;
  undefined *puVar12;
  undefined8 *******pppppppuVar13;
  int local_168 [2];
  undefined1 local_160 [8];
  undefined8 *******local_158;
  longlong local_150;
  longlong local_148;
  undefined8 *******local_140 [2];
  longlong local_130;
  byte local_121;
  undefined2 local_120;
  undefined1 local_118;
  undefined7 uStack_117;
  longlong local_108;
  byte local_f9;
  undefined2 local_f8;
  undefined1 *local_f0;
  longlong *local_e8;
  undefined8 local_d8;
  undefined8 uStack_d0;
  longlong *local_c8;
  undefined4 local_c0;
  undefined8 local_bc;
  undefined4 local_b0;
  undefined8 local_70;
  undefined4 local_68;
  
  puVar2 = param_6;
  local_d8 = 0;
  uStack_d0 = 0;
  plVar5 = (longlong *)0x0;
  local_c8 = (longlong *)0x0;
  local_bc = 0;
  local_b0 = 0;
  local_70 = 0;
  local_68 = 0;
  local_c0 = 0;
  if (*(byte *)((longlong)param_6 + 0x1f) < 0x40) {
    lVar9 = 0x1f - (longlong)*(char *)((longlong)param_6 + 0x1f);
  }
  else {
    lVar9 = param_6[2];
  }
  if (lVar9 == 0) {
    iVar4 = FUN_1400e4de0("127.0.0.1",param_2,1000,0,1);
    plVar7 = plVar5;
    while (iVar4 == -1) {
      if (0xe < (int)plVar7) {
        plVar5 = (longlong *)FUN_14005f9f0(DAT_140750378);
        if ((char)plVar5[1] != '\0') {
          FUN_140007bf0(*plVar5 + 8,"Couldn\'t connect to port ");
        }
        if (((char)plVar5[1] == '\0') ||
           (FUN_1400caa00(*plVar5 + 8,param_2 & 0xffffffff), (char)plVar5[1] == '\0'))
        goto LAB_1400d083f;
        lVar9 = *plVar5;
        pcVar10 = "\n";
        goto LAB_1400d0836;
      }
      iVar4 = FUN_1400e4de0("127.0.0.1",param_2 & 0xffff,1000,0,1);
      plVar7 = (longlong *)(ulonglong)((int)plVar7 + 1);
    }
    local_148 = FUN_1400e40a0(0x20);
    plVar7 = plVar5;
    if (local_148 != 0) {
      plVar7 = (longlong *)FUN_1400e4a30(local_148,iVar4,1);
    }
    local_c8 = plVar7;
    cVar3 = (**(code **)(*plVar7 + 0x20))();
    if (cVar3 == '\0') {
      plVar5 = (longlong *)FUN_14005f9f0(DAT_140750378);
      if ((char)plVar5[1] != '\0') {
        FUN_140007bf0(*plVar5 + 8,"Couldn\'t create connection on ");
      }
      if (((char)plVar5[1] != '\0') &&
         (FUN_1400caa00(*plVar5 + 8,param_2 & 0xffffffff), (char)plVar5[1] != '\0')) {
        FUN_140007bf0(*plVar5 + 8,&DAT_140579664);
      }
      FUN_14005fa10(DAT_140750378);
      if (local_c8 == (longlong *)0x0) {
        return (longlong *)0x1;
      }
      (**(code **)*local_c8)(local_c8,1);
      return (longlong *)0x1;
    }
  }
  else {
    local_168[0] = 0;
    uStack_d0 = FUN_1400f8bf0(local_168);
    if (local_168[0] != 0) {
      plVar5 = (longlong *)FUN_14005f9f0(DAT_140750378);
      if ((char)plVar5[1] != '\0') {
        lVar9 = *plVar5;
        pcVar10 = "Couldn\'t create IPC stream\n";
LAB_1400d0836:
        FUN_140007bf0(lVar9 + 8,pcVar10);
      }
LAB_1400d083f:
      FUN_14005fa10(DAT_140750378);
      return (longlong *)0x1;
    }
    lVar9 = FUN_140128b30();
    while( true ) {
      lVar6 = FUN_140128b30();
      if (15.0 <= ((double)(ulonglong)(lVar6 - lVar9) * _DAT_1407515e0) / 1000000000.0) {
        plVar5 = (longlong *)FUN_14005f9f0(DAT_140750378);
        if ((char)plVar5[1] != '\0') {
          FUN_140007bf0(*plVar5 + 8,"Couldn\'t connect IPC stream\n");
        }
        FUN_14005fa10(DAT_140750378);
        FUN_1400f8ca0(uStack_d0,local_168);
        return (longlong *)0x1;
      }
      puVar11 = puVar2;
      if (0x3f < *(byte *)((longlong)puVar2 + 0x1f)) {
        puVar11 = (undefined8 *)*puVar2;
      }
      FUN_1400f8bb0(uStack_d0,puVar11,local_168);
      if ((local_168[0] == 0) || (local_168[0] == -0x7ffffffb)) break;
      FUN_1400dcdf0();
    }
  }
  uVar1 = DAT_140750378;
  local_148 = DAT_140750378;
  local_168[0] = 1;
  plVar7 = (longlong *)FUN_14005fa30(DAT_140750378);
  if ((char)plVar7[1] != '\0') {
    FUN_140007bf0(*plVar7 + 8,"Base path: \'");
  }
  if ((char)plVar7[1] != '\0') {
    if (*(byte *)((longlong)param_1 + 0x1f) < 0x40) {
      lVar9 = 0x1f - (longlong)*(char *)((longlong)param_1 + 0x1f);
      puVar11 = param_1;
    }
    else {
      lVar9 = param_1[2];
      puVar11 = (undefined8 *)*param_1;
    }
    FUN_1400d4880(*plVar7 + 8,puVar11,lVar9);
    if (((char)plVar7[1] != '\0') &&
       (FUN_140007bf0(*plVar7 + 8,"\', plugins path \'"), (char)plVar7[1] != '\0')) {
      if (*(byte *)((longlong)param_5 + 0x1f) < 0x40) {
        lVar9 = 0x1f - (longlong)*(char *)((longlong)param_5 + 0x1f);
        puVar11 = param_5;
      }
      else {
        lVar9 = param_5[2];
        puVar11 = (undefined8 *)*param_5;
      }
      FUN_1400d4880(*plVar7 + 8,puVar11,lVar9);
    }
  }
  if (((char)plVar7[1] != '\0') &&
     (FUN_140007bf0(*plVar7 + 8,&DAT_14057df28), (char)plVar7[1] != '\0')) {
    FUN_140007bf0(*plVar7 + 8,", jobs: ");
  }
  puVar12 = &DAT_14058a580;
  if (param_4 != '\0') {
    puVar12 = &DAT_14057d8c8;
  }
  if ((char)plVar7[1] != '\0') {
    FUN_140007bf0(*plVar7 + 8,puVar12);
  }
  FUN_14005f880(plVar7,FUN_14005f9b0);
  FUN_1400b5840(local_140,param_1,param_3,param_4,param_5);
  lVar9 = local_130;
  if (local_121 < 0x40) {
    lVar9 = 0x1f - (longlong)(char)local_121;
  }
  if (lVar9 == 0) {
    local_f8 = 0x4b;
    local_118 = 0;
    local_f9 = 0x1f;
    local_150 = 0;
    local_158 = (undefined8 *******)&DAT_140578094;
    FUN_1400c9340(&local_d8,&local_158);
    local_e8 = plVar5;
LAB_1400d0d53:
    if ((char)local_e8[0x280b14bb] != '\0') goto code_r0x0001400d0d59;
    goto LAB_1400d0d67;
  }
  plVar5 = (longlong *)FUN_14005f9f0(uVar1);
  if ((char)plVar5[1] != '\0') {
    FUN_140007bf0(*plVar5 + 8,"Initialization error: ");
  }
  if ((char)plVar5[1] != '\0') {
    pppppppuVar13 = local_140[0];
    lVar9 = local_130;
    if (local_121 < 0x40) {
      pppppppuVar13 = local_140;
      lVar9 = 0x1f - (longlong)(char)local_121;
    }
    FUN_1400d4880(*plVar5 + 8,pppppppuVar13,lVar9);
  }
  FUN_14005f880(plVar5,FUN_14005f9b0);
  local_158 = local_140[0];
  local_150 = local_130;
  if (local_121 < 0x40) {
    local_150 = 0x1f - (longlong)(char)local_121;
    local_158 = local_140;
  }
  FUN_1400c9340(&local_d8,&local_158);
  plVar5 = (longlong *)0x1;
  local_168[0] = 1;
LAB_1400d0eaf:
  if ((local_121 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(local_140[0],local_120,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  if (*(byte *)((longlong)puVar2 + 0x1f) < 0x40) {
    lVar9 = 0x1f - (longlong)*(char *)((longlong)puVar2 + 0x1f);
  }
  else {
    lVar9 = puVar2[2];
  }
  if (lVar9 == 0) {
    (**(code **)(*local_c8 + 0x40))();
    if (local_c8 != (longlong *)0x0) {
      (**(code **)*local_c8)(local_c8,1);
    }
  }
  else {
    param_6._0_4_ = 0;
    FUN_1400f8d30(uStack_d0,&param_6);
    FUN_1400f8ca0(uStack_d0,&param_6);
  }
  return plVar5;
code_r0x0001400d0d59:
  local_e8 = (longlong *)((longlong)local_e8 + 1);
  if (local_e8 < (longlong *)0x5) goto LAB_1400d0d53;
  local_e8 = (longlong *)0x5;
LAB_1400d0d67:
  local_f0 = &DAT_14058a5d8;
  FUN_1400afbc0(local_160,&local_f0);
  cVar3 = FUN_1400c7b10(&local_d8,&local_118);
  if (cVar3 == '\0') {
    plVar5 = (longlong *)FUN_14005f9f0(uVar1);
    if ((char)plVar5[1] != '\0') {
      FUN_140007bf0(*plVar5 + 8,"Error reading command");
    }
    FUN_14005f880(plVar5,FUN_14005f9b0);
    plVar5 = (longlong *)0x1;
    local_168[0] = 1;
    _guard_check_icall(local_160);
    goto LAB_1400d0e7e;
  }
  lVar9 = local_108;
  if (local_f9 < 0x40) {
    lVar9 = 0x1f - (longlong)(char)local_f9;
  }
  if (lVar9 == 0) {
    plVar7 = (longlong *)FUN_14005fa30(uVar1);
    if ((char)plVar7[1] != '\0') {
      FUN_140007bf0(*plVar7 + 8,"IPC connection closed");
    }
    FUN_14005f880(plVar7,FUN_14005f9b0);
    local_168[0] = 0;
    _guard_check_icall(local_160);
    goto LAB_1400d0e7e;
  }
  _guard_check_icall(local_160);
  cVar3 = CmdDispatcher_Dispatch(&local_d8,&local_118);
  if (cVar3 != '\0') {
    uVar8 = FUN_14005fa30(uVar1);
    FUN_14005f880(uVar8,FUN_14005f9b0);
    local_e8 = plVar5;
    goto LAB_1400d0d53;
  }
  plVar5 = (longlong *)0x0;
  local_168[0] = 0;
LAB_1400d0e7e:
  if ((local_f9 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_117,local_118),local_f8,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  goto LAB_1400d0eaf;
}
```

## `CmdDispatcher_Dispatch` — `0x1400cc6d0`

command dispatcher: string chain over `Cmd: ...`

```c
/* WARNING: Type propagation algorithm not settling */
/* Command dispatcher. Compares the incoming text command against "Cmd: preprocess", "Cmd:
   disassembleShader", "Cmd: compileSnippet", "Cmd: initializeCompiler", "Cmd: preprocessCompute",
   "Cmd: compileComputeKernel", "Cmd: compileRayTracingShader", "Cmd: preprocessRayTracingShader",
   "Cmd: shutdown" and calls the matching handler. */

undefined8 CmdDispatcher_Dispatch(undefined *param_1,byte *param_2)

{
  uint *puVar1;
  uint *puVar2;
  undefined1 uVar3;
  byte bVar4;
  char cVar5;
  undefined4 uVar6;
  uint uVar7;
  undefined4 uVar8;
  undefined4 uVar9;
  undefined4 uVar10;
  undefined4 uVar11;
  longlong *plVar12;
  undefined8 uVar13;
  undefined **ppuVar14;
  undefined8 uVar15;
  uint *******pppppppuVar16;
  undefined8 uVar17;
  undefined8 *******pppppppuVar18;
  undefined8 uVar19;
  byte *pbVar20;
  uint ******ppppppuVar21;
  int iVar22;
  char *pcVar23;
  undefined8 *******pppppppuVar24;
  undefined1 *puVar25;
  uint *******pppppppuVar26;
  uint uVar27;
  ulonglong uVar28;
  ulonglong uVar29;
  uint *puVar30;
  ulonglong uVar31;
  longlong lVar32;
  byte *pbVar33;
  undefined8 *puVar34;
  uint uVar35;
  uint *******pppppppuVar36;
  bool bVar37;
  undefined8 local_res10;
  uint local_res18 [2];
  undefined8 local_res20;
  undefined8 *******pppppppuVar38;
  undefined8 in_stack_fffffffffffff588;
  undefined8 in_stack_fffffffffffff590;
  undefined8 in_stack_fffffffffffff5a0;
  undefined8 in_stack_fffffffffffff5a8;
  uint **ppuVar39;
  undefined8 in_stack_fffffffffffff5c0;
  undefined8 in_stack_fffffffffffff5c8;
  undefined8 in_stack_fffffffffffff5d8;
  undefined4 uVar40;
  uint *******local_9e8;
  uint *******local_9e0;
  longlong local_9d8;
  byte local_9c9;
  undefined2 local_9c8;
  uint ******local_9c0 [2];
  uint *******local_9b0;
  byte local_9a1;
  undefined2 local_9a0;
  undefined8 *******local_998;
  undefined2 local_990;
  uint *******local_988;
  undefined8 local_980;
  undefined2 local_978;
  undefined1 local_970 [8];
  undefined8 *******local_968;
  uint *******local_960;
  undefined1 local_958;
  undefined7 uStack_957;
  byte local_939;
  undefined2 local_938;
  undefined8 *******local_930;
  undefined2 local_928;
  ulonglong local_920;
  undefined8 local_918;
  undefined2 local_910;
  undefined1 local_908;
  undefined7 uStack_907;
  uint *******local_8f8;
  byte local_8e9;
  undefined2 local_8e8;
  char *local_8e0;
  uint *******local_8d8;
  int local_8d0 [2];
  uint *local_8c8;
  undefined8 local_8c0;
  undefined4 local_8b8;
  undefined2 local_8b2;
  undefined8 local_8b0;
  undefined8 local_8a8;
  undefined4 local_8a0;
  undefined2 local_89a;
  undefined8 local_898 [3];
  byte local_879;
  undefined2 local_878;
  uint ******local_870;
  uint *******pppppppuStack_868;
  longlong local_860;
  byte local_851;
  undefined2 local_850;
  ulonglong local_848;
  undefined8 local_840;
  ulonglong local_838;
  undefined8 local_830;
  undefined4 *puStack_828;
  undefined8 local_820;
  undefined4 local_818;
  undefined2 local_812;
  undefined8 *local_810;
  longlong local_808;
  uint *******local_800;
  undefined8 local_7f8;
  ulonglong local_7f0;
  undefined8 local_7e8;
  undefined8 local_7e0;
  undefined1 local_7d8;
  undefined7 uStack_7d7;
  byte local_7b9;
  undefined2 local_7b8;
  undefined8 *******local_7b0;
  undefined2 local_7a8;
  longlong local_7a0;
  undefined8 local_798;
  undefined2 local_790;
  longlong local_788;
  undefined4 local_780;
  undefined **local_778;
  undefined *local_770;
  undefined1 local_768;
  undefined7 uStack_767;
  longlong local_758;
  byte local_749;
  undefined2 local_748;
  undefined8 *******local_738 [2];
  longlong local_728;
  byte local_719;
  undefined2 local_718;
  undefined1 local_710 [32];
  undefined1 local_6f0 [24];
  undefined4 local_6d8;
  undefined4 local_6d4;
  undefined1 local_6d0 [24];
  ulonglong local_6b8;
  undefined1 local_6b0 [24];
  ulonglong local_698;
  undefined1 local_690 [232];
  undefined1 local_5a8 [16];
  undefined4 local_598;
  undefined1 local_4e8 [16];
  undefined4 local_4d8;
  undefined1 local_4c8 [16];
  undefined4 local_4b8;
  undefined1 local_408 [16];
  undefined4 local_3f8;
  undefined1 local_308 [320];
  undefined1 local_1c8 [32];
  undefined1 local_1a8 [32];
  undefined1 local_188 [48];
  undefined1 local_158 [32];
  undefined1 local_138 [256];
  
  uVar6 = (undefined4)((ulonglong)in_stack_fffffffffffff5a0 >> 0x20);
  uVar40 = (undefined4)((ulonglong)in_stack_fffffffffffff5d8 >> 0x20);
  pppppppuVar18 = &local_968;
  pppppppuVar36 = (uint *******)0x0;
  local_8d8 = pppppppuVar36;
  do {
    if (*(byte *)(local_8d8 + 0x280b140f) == 0) goto LAB_1400cc716;
    local_8d8 = (uint *******)((longlong)local_8d8 + 1);
  } while (local_8d8 < (uint *******)0x10);
  local_8d8 = (uint *******)0x10;
LAB_1400cc716:
  local_8e0 = "DispatchCommand";
  FUN_1400afbc0(local_970,&local_8e0);
  uVar15 = DAT_140750378;
  if (param_2[0x1f] < 0x40) {
    lVar32 = 0x1f - (longlong)(char)param_2[0x1f];
    pbVar20 = param_2;
  }
  else {
    lVar32 = *(longlong *)(param_2 + 0x10);
    pbVar20 = *(byte **)param_2;
  }
  pcVar23 = "shutdown";
  pbVar33 = pbVar20 + lVar32;
  for (; pbVar20 < pbVar33; pbVar20 = pbVar20 + 1) {
    if (*pbVar20 != *pcVar23) {
      iVar22 = (uint)*pbVar20 - (uint)(byte)*pcVar23;
      goto LAB_1400cc78b;
    }
    if (*pcVar23 == 0) goto LAB_1400cc7dd;
    pcVar23 = pcVar23 + 1;
  }
  iVar22 = -(uint)(byte)*pcVar23;
LAB_1400cc78b:
  if (iVar22 == 0) {
    plVar12 = (longlong *)FUN_14005fa30(DAT_140750378);
    if ((char)plVar12[1] != '\0') {
      FUN_140007bf0(*plVar12 + 8,"Cmd: shutdown");
    }
    FUN_14005f880(plVar12,FUN_14005f9b0);
    _guard_check_icall(local_970);
    uVar15 = 0;
  }
  else {
LAB_1400cc7dd:
    if (param_2[0x1f] < 0x40) {
      lVar32 = 0x1f - (longlong)(char)param_2[0x1f];
      pbVar20 = param_2;
    }
    else {
      lVar32 = *(longlong *)(param_2 + 0x10);
      pbVar20 = *(byte **)param_2;
    }
    pcVar23 = "preprocess";
    pbVar33 = pbVar20 + lVar32;
    for (; pbVar20 < pbVar33; pbVar20 = pbVar20 + 1) {
      if (*pbVar20 != *pcVar23) {
        iVar22 = (uint)*pbVar20 - (uint)(byte)*pcVar23;
        goto LAB_1400cc833;
      }
      if (*pcVar23 == 0) goto LAB_1400ccfe7;
      pcVar23 = pcVar23 + 1;
    }
    iVar22 = -(uint)(byte)*pcVar23;
LAB_1400cc833:
    if (iVar22 == 0) {
      plVar12 = (longlong *)FUN_14005fa30(DAT_140750378);
      if ((char)plVar12[1] != '\0') {
        FUN_140007bf0(*plVar12 + 8,"Cmd: preprocess");
      }
      FUN_14005f880(plVar12,FUN_14005f9b0);
      FUN_1400ca3b0(local_738);
      local_850 = 1;
      local_870 = (uint ******)((ulonglong)local_870 & 0xffffffffffffff00);
      local_851 = 0x1f;
      FUN_1400c8030(param_1,&local_870);
      plVar12 = (longlong *)FUN_14005fa30(uVar15);
      if ((char)plVar12[1] != '\0') {
        FUN_140007bf0(*plVar12 + 8," insize=");
      }
      lVar32 = local_860;
      if (local_851 < 0x40) {
        lVar32 = 0x1f - (longlong)(char)local_851;
      }
      if ((char)plVar12[1] != '\0') {
        FUN_1400cac20(*plVar12 + 8,lVar32);
      }
      local_9a0 = 1;
      local_9c0[0]._0_1_ = 0;
      local_9a1 = 0x1f;
      FUN_1400c8030(param_1,local_9c0);
      local_9c8 = 1;
      local_9e8 = (uint *******)((ulonglong)local_9e8 & 0xffffffffffffff00);
      local_9c9 = 0x1f;
      FUN_1400c8030(param_1,&local_9e8);
      pppppppuVar36 = local_9b0;
      if (local_9a1 < 0x40) {
        pppppppuVar36 = (uint *******)(0x1f - (longlong)(char)local_9a1);
      }
      puVar25 = (undefined1 *)local_9c0;
      if (0x3f < local_9a1) {
        puVar25 = (undefined1 *)CONCAT71(local_9c0[0]._1_7_,local_9c0[0]._0_1_);
      }
      FUN_140054780(local_738,puVar25,pppppppuVar36);
      local_res20 = (longlong *)CONCAT71(local_res20._1_7_,0x2f);
      FUN_1400543f0(local_738,&local_res20,1);
      pppppppuVar36 = local_9e8;
      if (local_9c9 < 0x40) {
        local_9d8 = 0x1f - (longlong)(char)local_9c9;
        pppppppuVar36 = (uint *******)&local_9e8;
      }
      FUN_1400543f0(local_738,pppppppuVar36,local_9d8);
      plVar12 = (longlong *)FUN_14005fa30(uVar15);
      if ((char)plVar12[1] != '\0') {
        FUN_140007bf0(*plVar12 + 8," file=");
      }
      if ((char)plVar12[1] != '\0') {
        pppppppuVar24 = local_738[0];
        if (local_719 < 0x40) {
          local_728 = 0x1f - (longlong)(char)local_719;
          pppppppuVar24 = local_738;
        }
        FUN_1400d4880(*plVar12 + 8,pppppppuVar24,local_728);
      }
      uVar3 = FUN_1400c7930(param_1);
      plVar12 = (longlong *)FUN_14005fa30(uVar15);
      if ((char)plVar12[1] != '\0') {
        FUN_140007bf0(*plVar12 + 8," surfaceOnly=");
      }
      if ((char)plVar12[1] != '\0') {
        FUN_1400cae40(*plVar12 + 8,uVar3);
      }
      local_6d8 = FUN_1400c8260(param_1);
      plVar12 = (longlong *)FUN_14005fa30(uVar15);
      if ((char)plVar12[1] != '\0') {
        FUN_140007bf0(*plVar12 + 8," buildPlatform=");
      }
      if ((char)plVar12[1] != '\0') {
        FUN_1400caa00(*plVar12 + 8,local_6d8);
      }
      local_6d4 = FUN_1400c8260(param_1);
      plVar12 = (longlong *)FUN_14005fa30(uVar15);
      if ((char)plVar12[1] != '\0') {
        FUN_140007bf0(*plVar12 + 8," validAPIs=");
      }
      if ((char)plVar12[1] != '\0') {
        FUN_14001a380(*plVar12 + 8,local_6d4);
      }
      local_790 = 1;
      local_7b0 = (undefined8 *******)((ulonglong)local_7b0 & 0xffffffffffffff00);
      local_798 = CONCAT17(0x1f,(undefined7)local_798);
      iVar22 = thunk_FUN_1400c8260(param_1);
      if (local_6b8 >> 1 < (ulonglong)(longlong)iVar22) {
        FUN_140058a60(local_6d0,(longlong)iVar22);
      }
      FUN_1400d0610(param_1,local_6d0,&local_7b0,iVar22);
      plVar12 = (longlong *)FUN_14005fa30(uVar15);
      if ((char)plVar12[1] != '\0') {
        FUN_140007bf0(*plVar12 + 8," pKW=");
      }
      if ((char)plVar12[1] != '\0') {
        pppppppuVar24 = local_7b0;
        lVar32 = local_7a0;
        if (local_798._7_1_ < 0x40) {
          pppppppuVar24 = &local_7b0;
          lVar32 = 0x1f - (longlong)(char)local_798._7_1_;
        }
        FUN_1400d4880(*plVar12 + 8,pppppppuVar24,lVar32);
      }
      local_910 = 1;
      local_930 = (undefined8 *******)((ulonglong)local_930 & 0xffffffffffffff00);
      local_918 = CONCAT17(0x1f,(undefined7)local_918);
      iVar22 = thunk_FUN_1400c8260(param_1);
      if (local_698 >> 1 < (ulonglong)(longlong)iVar22) {
        FUN_140058a60(local_6b0,(longlong)iVar22);
      }
      FUN_1400d0610(param_1,local_6b0,&local_930,iVar22);
      plVar12 = (longlong *)FUN_14005fa30(uVar15);
      if ((char)plVar12[1] != '\0') {
        FUN_140007bf0(*plVar12 + 8," dKW=");
      }
      if ((char)plVar12[1] != '\0') {
        pppppppuVar24 = local_930;
        uVar29 = local_920;
        if (local_918._7_1_ < 0x40) {
          pppppppuVar24 = &local_930;
          uVar29 = 0x1f - (longlong)(char)local_918._7_1_;
        }
        FUN_1400d4880(*plVar12 + 8,pppppppuVar24,uVar29);
      }
      local_978 = 1;
      local_998 = (undefined8 *******)((ulonglong)local_998 & 0xffffffffffffff00);
      local_980 = CONCAT17(0x1f,(undefined7)local_980);
      local_7e8 = ShaderCompilerPreprocessCallbacksSend::vftable;
      local_res18[0] = local_res18[0] & 0xffffff00;
      local_res10 = (undefined1 *)((ulonglong)local_res10 & 0xffffffffffffff00);
      if (local_9a1 < 0x40) {
        local_9b0 = (uint *******)(0x1f - (longlong)(char)local_9a1);
      }
      local_968 = (undefined8 *******)local_9c0;
      if (0x3f < local_9a1) {
        local_968 = (undefined8 *******)CONCAT71(local_9c0[0]._1_7_,local_9c0[0]._0_1_);
      }
      pppppppuVar24 = local_738;
      local_960 = local_9b0;
      local_7e0 = param_1;
      bVar4 = HandlePreprocessCommand
                        (&local_870,pppppppuVar18,&local_998,&local_7e8,pppppppuVar24,uVar3,
                         local_res18,&local_res10);
      uVar6 = (undefined4)((ulonglong)pppppppuVar24 >> 0x20);
      plVar12 = (longlong *)FUN_14005fa30(uVar15);
      if ((char)plVar12[1] != '\0') {
        FUN_140007bf0(*plVar12 + 8,&DAT_14058a0fc);
      }
      if ((char)plVar12[1] != '\0') {
        FUN_1400cae40(*plVar12 + 8,bVar4);
      }
      local_968 = (undefined8 *******)
                  FUN_1400e0f60(&local_958,"shader: %c %c %c",bVar4 + 0x30,
                                ((char)local_res18[0] != '\0') + '0',
                                CONCAT44(uVar6,((byte)local_res10 != '\0') + 0x30));
      if (*(byte *)((longlong)local_968 + 0x1f) < 0x40) {
        local_960 = (uint *******)(0x1f - (longlong)*(char *)((longlong)local_968 + 0x1f));
      }
      else {
        local_960 = (uint *******)local_968[2];
        local_968 = (undefined8 *******)*local_968;
      }
      FUN_1400c9340(param_1,pppppppuVar18);
      if ((local_939 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(CONCAT71(uStack_957,local_958),local_938,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      local_968 = local_998;
      local_960 = local_988;
      if (local_980._7_1_ < 0x40) {
        local_960 = (uint *******)(0x1f - (longlong)(char)local_980._7_1_);
        local_968 = &local_998;
      }
      FUN_1400c9340(param_1,pppppppuVar18);
      plVar12 = (longlong *)FUN_14005fa30(uVar15);
      if ((char)plVar12[1] != '\0') {
        FUN_140007bf0(*plVar12 + 8," outsize=");
      }
      pppppppuVar36 = local_988;
      if (local_980._7_1_ < 0x40) {
        pppppppuVar36 = (uint *******)(0x1f - (longlong)(char)local_980._7_1_);
      }
      if ((char)plVar12[1] != '\0') {
        FUN_1400cac20(*plVar12 + 8,pppppppuVar36);
      }
      FUN_14005f880(plVar12,FUN_14005f9b0);
      local_7e8 = ShaderCompilerPreprocessCallbacks::vftable;
      if ((local_980._7_1_ & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(local_998,local_978,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      if ((local_918._7_1_ & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(local_930,local_910,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      if ((local_798._7_1_ & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(local_7b0,local_790,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      if ((local_9c9 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(local_9e8,local_9c8,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      if ((local_9a1 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(CONCAT71(local_9c0[0]._1_7_,local_9c0[0]._0_1_),local_9a0,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      if ((local_851 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(local_870,local_850,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      _eh_vector_destructor_iterator_(local_690,0x20,7,FUN_140018ba0);
      FUN_140018ba0(local_6b0);
      FUN_140018ba0(local_6d0);
      FUN_140055550(local_6f0);
      FUN_140018ba0(local_710);
      if ((local_719 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(local_738[0],local_718,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
    }
    else {
LAB_1400ccfe7:
      if (param_2[0x1f] < 0x40) {
        lVar32 = 0x1f - (longlong)(char)param_2[0x1f];
        pbVar20 = param_2;
      }
      else {
        lVar32 = *(longlong *)(param_2 + 0x10);
        pbVar20 = *(byte **)param_2;
      }
      pcVar23 = "disassembleShader";
      pbVar33 = pbVar20 + lVar32;
      for (; pbVar20 < pbVar33; pbVar20 = pbVar20 + 1) {
        if (*pbVar20 != *pcVar23) {
          iVar22 = (uint)*pbVar20 - (uint)(byte)*pcVar23;
          goto LAB_1400cd036;
        }
        if (*pcVar23 == 0) goto LAB_1400cd406;
        pcVar23 = pcVar23 + 1;
      }
      iVar22 = -(uint)(byte)*pcVar23;
LAB_1400cd036:
      if (iVar22 == 0) {
        plVar12 = (longlong *)FUN_14005fa30(DAT_140750378);
        if ((char)plVar12[1] != '\0') {
          FUN_140007bf0(*plVar12 + 8,"Cmd: disassembleShader");
        }
        FUN_14005f880(plVar12,FUN_14005f9b0);
        local_978 = 1;
        local_998 = (undefined8 *******)((ulonglong)local_998 & 0xffffffffffffff00);
        local_980 = CONCAT17(0x1f,(undefined7)local_980);
        FUN_1400c8030(param_1,&local_998);
        plVar12 = (longlong *)FUN_14005fa30(uVar15);
        if ((char)plVar12[1] != '\0') {
          FUN_140007bf0(*plVar12 + 8," name=");
        }
        if ((char)plVar12[1] != '\0') {
          pppppppuVar24 = local_998;
          pppppppuVar36 = local_988;
          if (local_980._7_1_ < 0x40) {
            pppppppuVar24 = &local_998;
            pppppppuVar36 = (uint *******)(0x1f - (longlong)(char)local_980._7_1_);
          }
          FUN_1400d4880(*plVar12 + 8,pppppppuVar24,pppppppuVar36);
        }
        uVar6 = thunk_FUN_1400c8260(param_1);
        local_res20 = (longlong *)CONCAT44(local_res20._4_4_,uVar6);
        plVar12 = (longlong *)FUN_14005fa30(uVar15);
        if ((char)plVar12[1] != '\0') {
          FUN_140007bf0(*plVar12 + 8," platform=");
        }
        uVar13 = FUN_14008ec70(&local_958,uVar6);
        FUN_1400ca360(plVar12,uVar13);
        if ((local_939 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(CONCAT71(uStack_957,local_958),local_938,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
        }
        uVar7 = thunk_FUN_1400c8260(param_1);
        local_res18[0] = uVar7;
        plVar12 = (longlong *)FUN_14005fa30(uVar15);
        if ((char)plVar12[1] != '\0') {
          FUN_140007bf0(*plVar12 + 8," type=");
        }
        if ((char)plVar12[1] != '\0') {
          FUN_1400caa00(*plVar12 + 8,uVar7);
        }
        uVar6 = thunk_FUN_1400c8260(param_1);
        local_res10 = (undefined1 *)CONCAT44(local_res10._4_4_,uVar6);
        plVar12 = (longlong *)FUN_14005fa30(uVar15);
        if ((char)plVar12[1] != '\0') {
          FUN_140007bf0(*plVar12 + 8," mask=");
        }
        if ((char)plVar12[1] != '\0') {
          FUN_14001a380(*plVar12 + 8,uVar6);
        }
        local_930 = (undefined8 *******)0x0;
        local_928 = 0x4d;
        local_920 = 0;
        local_918 = 1;
        FUN_1400c7950(param_1,&local_930);
        plVar12 = (longlong *)FUN_14005fa30(uVar15);
        if ((char)plVar12[1] != '\0') {
          FUN_140007bf0(*plVar12 + 8," insize=");
        }
        if ((char)plVar12[1] != '\0') {
          FUN_1400cac20(*plVar12 + 8,local_920);
        }
        local_9a0 = 0x4b;
        local_9c0[0]._0_1_ = 0;
        local_9a1 = 0x1f;
        bVar4 = HandleDisassembleShaderCommand
                          ((ulonglong)local_res20 & 0xffffffff,local_res18[0],
                           (ulonglong)local_res10 & 0xffffffff,&local_930,local_9c0,FUN_1400d3ec0,
                           param_1);
        uVar13 = FUN_1400e0f60(&local_958,"disasm: %c",bVar4 + 0x30);
        uVar13 = FUN_14001aa00(uVar13,&local_9e8);
        FUN_1400c9340(param_1,uVar13);
        if ((local_939 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(CONCAT71(uStack_957,local_958),local_938,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
        }
        local_960 = local_9b0;
        if (local_9a1 < 0x40) {
          local_960 = (uint *******)(0x1f - (longlong)(char)local_9a1);
        }
        local_968 = (undefined8 *******)local_9c0;
        if (0x3f < local_9a1) {
          local_968 = (undefined8 *******)CONCAT71(local_9c0[0]._1_7_,local_9c0[0]._0_1_);
        }
        FUN_1400c9340(param_1,pppppppuVar18);
        plVar12 = (longlong *)FUN_14005fa30(uVar15);
        if ((char)plVar12[1] != '\0') {
          FUN_140007bf0(*plVar12 + 8," outsize=");
        }
        if (local_9a1 < 0x40) {
          local_9b0 = (uint *******)(0x1f - (longlong)(char)local_9a1);
        }
        if ((((char)plVar12[1] != '\0') &&
            (FUN_1400cac20(*plVar12 + 8,local_9b0), (char)plVar12[1] != '\0')) &&
           (FUN_140007bf0(*plVar12 + 8,&DAT_14058a0fc), (char)plVar12[1] != '\0')) {
          FUN_1400cae40(*plVar12 + 8,bVar4);
        }
        FUN_14005f880(plVar12,FUN_14005f9b0);
        if ((local_9a1 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(CONCAT71(local_9c0[0]._1_7_,local_9c0[0]._0_1_),local_9a0,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
        }
        FUN_140017b90(&local_930);
        if ((local_980._7_1_ & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(local_998,local_978,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
        }
      }
      else {
LAB_1400cd406:
        cVar5 = FUN_14001a650(param_2,"compileSnippet");
        if (cVar5 == '\0') {
          cVar5 = FUN_14001a650(param_2,"initializeCompiler");
          if (cVar5 == '\0') {
            cVar5 = FUN_14001a650(param_2,"preprocessCompute");
            if (cVar5 == '\0') {
              cVar5 = FUN_14001a650(param_2,"compileComputeKernel");
              if (cVar5 == '\0') {
                cVar5 = FUN_14001a650(param_2,"clearIncludesCache");
                if (cVar5 == '\0') {
                  cVar5 = FUN_14001a650(param_2,"compileRayTracingShader");
                  if (cVar5 == '\0') {
                    cVar5 = FUN_14001a650(param_2,"preprocessRayTracingShader");
                    if (cVar5 == '\0') {
                      cVar5 = FUN_14001a650(param_2,&DAT_14058960c);
                      if (cVar5 == '\0') {
                        uVar15 = FUN_14005f9f0(uVar15);
                        uVar15 = FUN_1400ca000(uVar15,"Unknown command: ");
                        uVar15 = FUN_1400ca360(uVar15,param_2);
                        FUN_14005f880(uVar15,FUN_14005f9b0);
                        FUN_1400ca4f0(&local_9e8,"Cannot dispatch invalid command");
                    /* WARNING: Subroutine does not return */
                        FUN_1403d92fc(&local_9e8,&DAT_140723108);
                      }
                      local_930 = (undefined8 *******)0x0;
                      local_928 = 1;
                      local_920 = 0;
                      local_918 = 1;
                      FUN_1400c7950(param_1,&local_930);
                      FUN_1400c8a70(param_1,local_930,local_920);
                      FUN_140017b90(&local_930);
                    }
                    else {
                      plVar12 = (longlong *)FUN_14005fa30(uVar15);
                      if ((char)plVar12[1] != '\0') {
                        FUN_140007bf0(*plVar12 + 8,"Cmd: preprocessRayTracingShader");
                      }
                      FUN_14005f880(plVar12,FUN_14005f9b0);
                      local_9a0 = 1;
                      local_9c0[0]._0_1_ = 0;
                      local_9a1 = 0x1f;
                      local_8e8 = 1;
                      local_908 = 0;
                      local_8e9 = 0x1f;
                      FUN_1400c8030(param_1,local_9c0);
                      uVar13 = FUN_14005fa30(uVar15);
                      plVar12 = (longlong *)FUN_1400ca000(uVar13," insize=");
                      pppppppuVar16 = local_9b0;
                      if (local_9a1 < 0x40) {
                        pppppppuVar16 = (uint *******)(0x1f - (longlong)(char)local_9a1);
                      }
                      if ((char)plVar12[1] != '\0') {
                        FUN_1400cac20(*plVar12 + 8,pppppppuVar16);
                      }
                      FUN_1400c8030(param_1,&local_908);
                      uVar13 = FUN_14005fa30(uVar15);
                      uVar13 = FUN_1400ca000(uVar13," path=");
                      FUN_1400ca360(uVar13,&local_908);
                      FUN_1400ca3b0(local_738);
                      local_6d8 = FUN_1400c8260(param_1);
                      uVar13 = FUN_14005fa30(uVar15);
                      plVar12 = (longlong *)FUN_1400ca000(uVar13," buildPlatform=");
                      if ((char)plVar12[1] != '\0') {
                        FUN_1400caa00(*plVar12 + 8,local_6d8);
                      }
                      local_6d4 = FUN_1400c8260(param_1);
                      uVar13 = FUN_14005fa30(uVar15);
                      plVar12 = (longlong *)FUN_1400ca000(uVar13," validAPIs=");
                      if ((char)plVar12[1] != '\0') {
                        FUN_14001a380(*plVar12 + 8,local_6d4);
                      }
                      local_7b8 = 1;
                      local_7d8 = 0;
                      local_7b9 = 0x1f;
                      FUN_1400d26b0(param_1,local_6d0,&local_7d8);
                      uVar13 = FUN_14005fa30(uVar15);
                      uVar13 = FUN_1400ca000(uVar13," pKW=");
                      FUN_1400ca360(uVar13,&local_7d8);
                      local_938 = 1;
                      local_958 = 0;
                      local_939 = 0x1f;
                      FUN_1400d26b0(param_1,local_6b0,&local_958);
                      uVar13 = FUN_14005fa30(uVar15);
                      uVar13 = FUN_1400ca000(uVar13," dKW=");
                      FUN_1400ca360(uVar13,&local_958);
                      FUN_140066c70(local_5a8);
                      local_998 = (undefined8 *******)0x0;
                      local_990 = 1;
                      local_988 = (uint *******)0x0;
                      local_980 = 1;
                      local_8c8 = &DAT_14058aa4c;
                      local_8c0 = 0;
                      local_8b8 = 0;
                      local_8b2 = 1;
                      local_8b0 = &DAT_14058aa4c;
                      local_8a8 = 0;
                      local_8a0 = 0;
                      local_89a = 1;
                      local_res18[0] = 0;
                      local_res20 = (longlong *)((ulonglong)local_res20._4_4_ << 0x20);
                      local_res10 = (undefined1 *)CONCAT71(local_res10._1_7_,1);
                      local_848 = 0x21;
                      local_840 = 0;
                      local_838 = CONCAT62(local_838._2_6_,0x19);
                      local_830 = 0;
                      puStack_828 = (undefined4 *)0x1;
                      ppuVar39 = &local_8c8;
                      pppppppuVar24 = &local_998;
                      puVar25 = local_5a8;
                      puVar34 = &local_res10;
                      uVar3 = HandleRayTracingPreprocessRequest
                                        (local_9c0,&local_908,local_738,&local_res20,puVar34,
                                         pppppppuVar18,puVar25,pppppppuVar24,local_res18,&local_7e8,
                                         ppuVar39,&local_848,FUN_1400d3ec0,param_1);
                      uVar6 = (undefined4)((ulonglong)puVar34 >> 0x20);
                      uVar40 = (undefined4)((ulonglong)pppppppuVar18 >> 0x20);
                      uVar8 = (undefined4)((ulonglong)puVar25 >> 0x20);
                      uVar9 = (undefined4)((ulonglong)pppppppuVar24 >> 0x20);
                      uVar10 = (undefined4)((ulonglong)ppuVar39 >> 0x20);
                      uVar13 = FUN_14005fa30(uVar15);
                      plVar12 = (longlong *)FUN_1400ca000(uVar13,&DAT_14058a0fc);
                      if ((char)plVar12[1] != '\0') {
                        FUN_1400cae40(*plVar12 + 8,uVar3);
                      }
                      FUN_14005f880(plVar12,FUN_14005f9b0);
                      uVar13 = FUN_1400e0f60(local_898,"raytraceKeywordsUserGlobal: %i",local_4d8);
                      uVar13 = FUN_14001aa00(uVar13,&local_9e8);
                      FUN_1400c9340(param_1,uVar13);
                      FUN_140017380(local_898);
                      FUN_1400d4110(param_1,local_4e8);
                      uVar13 = FUN_1400e0f60(local_898,"raytraceKeywordsUserLocal: %i",local_3f8);
                      uVar13 = FUN_14001aa00(uVar13,&local_9e8);
                      FUN_1400c9340(param_1,uVar13);
                      FUN_140017380(local_898);
                      FUN_1400d4110(param_1,local_408);
                      uVar13 = FUN_1400e0f60(local_898,"raytraceKeywordsDynamic:");
                      uVar13 = FUN_14001aa00(uVar13,&local_9e8);
                      FUN_1400c9340(param_1,uVar13);
                      FUN_140017380(local_898);
                      FUN_1400d43e0(param_1,local_308);
                      uVar13 = FUN_1400e0f60(local_898,"raytraceKeywordsNotSuitedForDynamic:");
                      uVar13 = FUN_14001aa00(uVar13,&local_9e8);
                      FUN_1400c9340(param_1,uVar13);
                      FUN_140017380(local_898);
                      FUN_1400d43e0(param_1,&local_998);
                      local_9e0 = pppppppuVar36;
                      do {
                        if (*(byte *)(local_9e0 + 0x280b145a) == 0) goto LAB_1400d01b9;
                        local_9e0 = (uint *******)((longlong)local_9e0 + 1);
                      } while (local_9e0 < (uint *******)0xe);
                      local_9e0 = (uint *******)0xe;
LAB_1400d01b9:
                      local_9e8 = (uint *******)0x14058a2d0;
                      FUN_1400c9340(param_1,&local_9e8);
                      FUN_1400d47f0(param_1,&local_848);
                      local_9e0 = pppppppuVar36;
                      do {
                        if (*(byte *)(local_9e0 + 0x280b148e) == 0) goto LAB_1400d01fa;
                        local_9e0 = (uint *******)((longlong)local_9e0 + 1);
                      } while (local_9e0 < (uint *******)0xf);
                      local_9e0 = (uint *******)0xf;
LAB_1400d01fa:
                      local_9e8 = (uint *******)0x14058a470;
                      FUN_1400c9340(param_1,&local_9e8);
                      FUN_1400c95d0(param_1,local_res18[0]);
                      do {
                        if (*(byte *)(pppppppuVar36 + 0x280b1490) == 0) goto LAB_1400d0239;
                        pppppppuVar36 = (uint *******)((longlong)pppppppuVar36 + 1);
                      } while (pppppppuVar36 < (uint *******)0xc);
                      pppppppuVar36 = (uint *******)0xc;
LAB_1400d0239:
                      local_9e8 = (uint *******)0x14058a480;
                      local_9e0 = pppppppuVar36;
                      FUN_1400c9340(param_1,&local_9e8);
                      uVar13 = FUN_14001aa00(local_9c0,&local_9e8);
                      FUN_1400c9340(param_1,uVar13);
                      uVar13 = FUN_1400e0f60(local_898,"params: %i %i %i %i %i %i %i %i %i",
                                             (ulonglong)local_res20 & 0xffffffff,
                                             (uint)((ulonglong)local_968 >> 0x18) & 1,
                                             CONCAT44(uVar6,(undefined4)local_7e8),
                                             CONCAT44(uVar40,local_7e8._4_4_),
                                             CONCAT44(uVar8,(undefined4)local_7e0),
                                             CONCAT44(uVar9,local_7e0._4_4_),local_8c0 >> 0x20,
                                             local_8a8 >> 0x20,
                                             CONCAT44(uVar10,(uint)(byte)local_res10));
                      uVar13 = FUN_14001aa00(uVar13,&local_9e8);
                      FUN_1400c9340(param_1,uVar13);
                      FUN_140017380(local_898);
                      if (local_8c0._4_4_ != 0) {
                        puVar1 = (uint *)((longlong)local_8c8 +
                                         ((local_8c0 & 0xffffffff) + 0x10) * 3);
                        for (puVar30 = local_8c8; (puVar30 < puVar1 && (0xfffffffd < *puVar30));
                            puVar30 = puVar30 + 0xc) {
                        }
                        puVar2 = (uint *)((longlong)local_8c8 +
                                         ((local_8c0 & 0xffffffff) + 0x10) * 3);
joined_r0x0001400d0342:
                        if (puVar2 != puVar30) {
                          uVar13 = FUN_14001aa00(puVar30 + 2,&local_9e8);
                          FUN_1400c9340(param_1,uVar13);
                          do {
                            puVar30 = puVar30 + 0xc;
                            if (puVar1 <= puVar30) break;
                          } while (0xfffffffd < *puVar30);
                          goto joined_r0x0001400d0342;
                        }
                      }
                      FUN_1400ab710(&local_8b0,&local_9e8);
                      pppppppuVar26 = local_9e0;
                      pppppppuVar36 =
                           (uint *******)
                           ((longlong)local_8b0 + ((local_8a8 & 0xffffffff) + 0x10) * 3);
                      pppppppuVar16 = local_9e8;
joined_r0x0001400d03b4:
                      if (pppppppuVar36 != pppppppuVar16) {
                        local_9e8 = pppppppuVar16 + 1;
                        if (*(byte *)((longlong)pppppppuVar16 + 0x27) < 0x40) {
                          local_9e0 = (uint *******)
                                      (0x1f - (longlong)
                                              (char)*(byte *)((longlong)pppppppuVar16 + 0x27));
                        }
                        else {
                          local_9e0 = (uint *******)pppppppuVar16[3];
                          local_9e8 = (uint *******)*local_9e8;
                        }
                        FUN_1400c9340(param_1,&local_9e8);
                        do {
                          pppppppuVar16 = pppppppuVar16 + 6;
                          if (pppppppuVar26 <= pppppppuVar16) break;
                        } while (0xfffffffd < *(uint *)pppppppuVar16);
                        goto joined_r0x0001400d03b4;
                      }
                      uVar15 = FUN_14005fa30(uVar15);
                      plVar12 = (longlong *)FUN_1400ca000(uVar15," outsize=");
                      if (local_9a1 < 0x40) {
                        local_9b0 = (uint *******)(0x1f - (longlong)(char)local_9a1);
                      }
                      if ((char)plVar12[1] != '\0') {
                        FUN_1400cac20(*plVar12 + 8,local_9b0);
                      }
                      FUN_14005f880(plVar12,FUN_14005f9b0);
                      FUN_140017d70(&local_840);
                      FUN_1400171d0(&local_8b0);
                      FUN_1400171d0(&local_8c8);
                      FUN_140018ba0(&local_998);
                      FUN_140067f40(local_5a8);
                      if ((local_939 & 0xc0) == 0x40) {
                        thunk_FUN_1403f2404(CONCAT71(uStack_957,local_958),local_938,
                                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                            ,0x218);
                      }
                      if ((local_7b9 & 0xc0) == 0x40) {
                        thunk_FUN_1403f2404(CONCAT71(uStack_7d7,local_7d8),local_7b8,
                                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                            ,0x218);
                      }
                      FUN_1400ca5c0(local_738);
                      if ((local_8e9 & 0xc0) == 0x40) {
                        thunk_FUN_1403f2404(CONCAT71(uStack_907,local_908),local_8e8,
                                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                            ,0x218);
                      }
                      if ((local_9a1 & 0xc0) == 0x40) {
                        thunk_FUN_1403f2404(CONCAT71(local_9c0[0]._1_7_,local_9c0[0]._0_1_),
                                            local_9a0,
                                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                            ,0x218);
                      }
                    }
                  }
                  else {
                    uVar13 = FUN_14005fa30(uVar15);
                    uVar13 = FUN_1400ca000(uVar13,"Cmd: compileRayTracingShader");
                    FUN_14005f880(uVar13,FUN_14005f9b0);
                    local_8e8 = 1;
                    local_908 = 0;
                    local_8e9 = 0x1f;
                    FUN_1400c8030(param_1,&local_908);
                    uVar13 = FUN_14005fa30(uVar15);
                    plVar12 = (longlong *)FUN_1400ca000(uVar13," insize=");
                    pppppppuVar16 = local_8f8;
                    if (local_8e9 < 0x40) {
                      pppppppuVar16 = (uint *******)(0x1f - (longlong)(char)local_8e9);
                    }
                    if ((char)plVar12[1] != '\0') {
                      FUN_1400cac20(*plVar12 + 8,pppppppuVar16);
                    }
                    puStack_828 = (undefined4 *)CONCAT62(puStack_828._2_6_,1);
                    local_848 = local_848 & 0xffffffffffffff00;
                    local_830 = CONCAT17(0x1f,(undefined7)local_830);
                    FUN_1400c8030(param_1,&local_848);
                    uVar13 = FUN_14005fa30(uVar15);
                    uVar13 = FUN_1400ca000(uVar13," path=");
                    FUN_1400ca360(uVar13,&local_848);
                    uVar6 = FUN_1400c8260(param_1);
                    local_res10 = (undefined1 *)CONCAT44(local_res10._4_4_,uVar6);
                    uVar13 = FUN_14005fa30(uVar15);
                    plVar12 = (longlong *)FUN_1400ca000(uVar13," buildPlatform=");
                    if ((char)plVar12[1] != '\0') {
                      FUN_1400caa00(*plVar12 + 8,uVar6);
                    }
                    local_810 = (undefined8 *)0x0;
                    local_808 = CONCAT62(local_808._2_6_,1);
                    local_800 = (uint *******)0x0;
                    local_7f8 = 1;
                    FUN_1400d25f0(param_1,&local_810);
                    uVar13 = FUN_14005fa30(uVar15);
                    FUN_1400ca000(uVar13," macro=");
                    uVar6 = (undefined4)((ulonglong)in_stack_fffffffffffff590 >> 0x20);
                    uVar40 = (undefined4)((ulonglong)in_stack_fffffffffffff5a8 >> 0x20);
                    pppppppuVar16 = pppppppuVar36;
                    if (local_800 != (uint *******)0x0) {
                      do {
                        if ((pppppppuVar36 != (uint *******)0x0) &&
                           (plVar12 = (longlong *)FUN_14005fa30(uVar15), (char)plVar12[1] != '\0'))
                        {
                          FUN_1400ca060(*plVar12 + 8,0x2c);
                        }
                        plVar12 = (longlong *)FUN_14005fa30(uVar15);
                        if ((char)plVar12[1] != '\0') {
                          FUN_1400ca060(*plVar12 + 8,0x3c);
                        }
                        plVar12 = (longlong *)
                                  FUN_1400ca360(plVar12,(byte *)((longlong)local_810 +
                                                                (longlong)pppppppuVar16));
                        if ((char)plVar12[1] != '\0') {
                          FUN_1400ca060(*plVar12 + 8,0x3d);
                        }
                        plVar12 = (longlong *)
                                  FUN_1400ca360(plVar12,(byte *)((longlong)(local_810 + 5) +
                                                                (longlong)pppppppuVar16));
                        if ((char)plVar12[1] != '\0') {
                          FUN_1400ca060(*plVar12 + 8,0x3e);
                        }
                        uVar6 = (undefined4)((ulonglong)in_stack_fffffffffffff590 >> 0x20);
                        uVar40 = (undefined4)((ulonglong)in_stack_fffffffffffff5a8 >> 0x20);
                        pppppppuVar36 = (uint *******)((longlong)pppppppuVar36 + 1);
                        pppppppuVar16 = pppppppuVar16 + 10;
                      } while (pppppppuVar36 < local_800);
                    }
                    local_930 = (undefined8 *******)0x0;
                    local_928 = 1;
                    local_920 = 0;
                    local_918 = 1;
                    local_8a8 = CONCAT62(local_8a8._2_6_,1);
                    local_8c8 = (uint *)((ulonglong)local_8c8 & 0xffffffffffffff00);
                    local_8b0 = (uint *)CONCAT17(0x1f,(undefined7)local_8b0);
                    FUN_1400d26b0(param_1,&local_930,&local_8c8);
                    uVar13 = FUN_14005fa30(uVar15);
                    uVar13 = FUN_1400ca000(uVar13," pKW=");
                    FUN_1400ca360(uVar13,&local_8c8);
                    local_998 = (undefined8 *******)0x0;
                    local_990 = 1;
                    local_988 = (uint *******)0x0;
                    local_980 = 1;
                    local_7b8 = 1;
                    local_7d8 = 0;
                    local_7b9 = 0x1f;
                    FUN_1400d26b0(param_1,&local_998,&local_7d8);
                    uVar13 = FUN_14005fa30(uVar15);
                    uVar13 = FUN_1400ca000(uVar13," uKW=");
                    FUN_1400ca360(uVar13,&local_7d8);
                    uVar8 = thunk_FUN_1400c8260(param_1);
                    uVar13 = FUN_14005fa30(uVar15);
                    uVar13 = FUN_1400ca000(uVar13," platform=");
                    uVar17 = FUN_14008ec70(local_898,uVar8);
                    FUN_1400ca360(uVar13,uVar17);
                    FUN_140017380(local_898);
                    uVar13 = FUN_1400c8350(param_1);
                    uVar17 = FUN_14005fa30(uVar15);
                    plVar12 = (longlong *)FUN_1400ca000(uVar17," flags=");
                    if ((char)plVar12[1] != '\0') {
                      FUN_1400cac20(*plVar12 + 8,uVar13);
                    }
                    uVar9 = FUN_1400c8260(param_1);
                    uVar17 = FUN_14005fa30(uVar15);
                    plVar12 = (longlong *)FUN_1400ca000(uVar17," max depth ");
                    if ((char)plVar12[1] != '\0') {
                      FUN_14001a380(*plVar12 + 8,uVar9);
                    }
                    uVar17 = FUN_1400c8350(param_1);
                    uVar19 = FUN_14005fa30(uVar15);
                    plVar12 = (longlong *)FUN_1400ca000(uVar19," reqs=");
                    if ((char)plVar12[1] != '\0') {
                      FUN_1400cac20(*plVar12 + 8,uVar17);
                    }
                    local_870 = (uint ******)0x0;
                    pppppppuStack_868 = (uint *******)0x0;
                    local_860 = 0;
                    cVar5 = HandleCompileRayTracingShaderCommand
                                      (&local_908,&local_848,(ulonglong)local_res10 & 0xffffffff,
                                       &local_810,&local_930,&local_998,&local_870,
                                       CONCAT44(uVar6,uVar8),uVar13,uVar17,CONCAT44(uVar40,uVar9),
                                       FUN_1400d3ec0,param_1);
                    uVar13 = FUN_14005fa30(uVar15);
                    plVar12 = (longlong *)FUN_1400ca000(uVar13,&DAT_14058a0fc);
                    if ((char)plVar12[1] != '\0') {
                      FUN_1400cae40(*plVar12 + 8,cVar5);
                    }
                    puVar25 = &DAT_14058a35c;
                    if (cVar5 != '\0') {
                      puVar25 = &DAT_140578fc4;
                    }
                    local_938 = 0x4b;
                    local_958 = 0;
                    local_939 = 0x1f;
                    FUN_140054780(&local_958,"rayTracingData: ",0x10);
                    uVar13 = FUN_14001ad10(local_898,&local_958,puVar25);
                    uVar13 = FUN_14001aa00(uVar13,&local_9e8);
                    FUN_1400c9340(param_1,uVar13);
                    FUN_140017380(local_898);
                    if ((local_939 & 0xc0) == 0x40) {
                      thunk_FUN_1403f2404(CONCAT71(uStack_957,local_958),local_938,
                                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                          ,0x218);
                    }
                    FUN_1400c8a70(param_1,local_870,
                                  (longlong)pppppppuStack_868 - (longlong)local_870);
                    uVar15 = FUN_14005fa30(uVar15);
                    plVar12 = (longlong *)FUN_1400ca000(uVar15," outsize=");
                    if ((char)plVar12[1] != '\0') {
                      FUN_1400cac20(*plVar12 + 8,(longlong)pppppppuStack_868 - (longlong)local_870);
                    }
                    FUN_14005f880(plVar12,FUN_14005f9b0);
                    if (local_870 != (uint ******)0x0) {
                      ppppppuVar21 = local_870;
                      if (0xfff < (ulonglong)(local_860 - (longlong)local_870)) {
                        ppppppuVar21 = (uint ******)local_870[-1];
                        if (0x1f < ((longlong)local_870 - (longlong)ppppppuVar21) - 8U) {
                    /* WARNING: Subroutine does not return */
                          FUN_1403de184((longlong)local_870 - (longlong)ppppppuVar21,
                                        (local_860 - (longlong)local_870) + 0x27);
                        }
                      }
                      thunk_FUN_1403f2404(ppppppuVar21);
                      local_870 = (uint ******)0x0;
                      pppppppuStack_868 = (uint *******)0x0;
                      local_860 = 0;
                    }
                    if ((local_7b9 & 0xc0) == 0x40) {
                      thunk_FUN_1403f2404(CONCAT71(uStack_7d7,local_7d8),local_7b8,
                                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                          ,0x218);
                    }
                    FUN_140018ba0(&local_998);
                    FUN_140017380(&local_8c8);
                    FUN_140018ba0(&local_930);
                    FUN_140017ca0(&local_810);
                    FUN_140017380(&local_848);
                    FUN_140017380(&local_908);
                  }
                }
                else {
                  FUN_1400b40e0();
                }
              }
              else {
                uVar13 = FUN_14005fa30(uVar15);
                uVar13 = FUN_1400ca000(uVar13,"Cmd: compileComputeKernel");
                FUN_14005f880(uVar13,FUN_14005f9b0);
                local_748 = 1;
                local_768 = 0;
                local_749 = 0x1f;
                FUN_1400c8030(param_1,&local_768);
                uVar13 = FUN_14005fa30(uVar15);
                plVar12 = (longlong *)FUN_1400ca000(uVar13,"  insize=");
                if (local_749 < 0x40) {
                  local_758 = 0x1f - (longlong)(char)local_749;
                }
                if ((char)plVar12[1] != '\0') {
                  FUN_1400cac20(*plVar12 + 8,local_758);
                }
                puStack_828 = (undefined4 *)CONCAT62(puStack_828._2_6_,1);
                local_848 = local_848 & 0xffffffffffffff00;
                local_830 = CONCAT17(0x1f,(undefined7)local_830);
                FUN_1400c8030(param_1,&local_848);
                uVar13 = FUN_14005fa30(uVar15);
                uVar13 = FUN_1400ca000(uVar13," file=");
                FUN_1400ca360(uVar13,&local_848);
                local_8e8 = 1;
                local_908 = 0;
                local_8e9 = 0x1f;
                FUN_1400c8030(param_1,&local_908);
                uVar13 = FUN_14005fa30(uVar15);
                uVar13 = FUN_1400ca000(uVar13," kernel=");
                FUN_1400ca360(uVar13,&local_908);
                uVar3 = FUN_1400c7930(param_1);
                local_res18[0] = CONCAT31(local_res18[0]._1_3_,uVar3);
                uVar13 = FUN_14005fa30(uVar15);
                plVar12 = (longlong *)FUN_1400ca000(uVar13," ppOnly=");
                if ((char)plVar12[1] != '\0') {
                  FUN_1400cae40(*plVar12 + 8,uVar3);
                }
                uVar3 = FUN_1400c7930(param_1);
                local_res10 = (undefined1 *)CONCAT71(local_res10._1_7_,uVar3);
                uVar13 = FUN_14005fa30(uVar15);
                plVar12 = (longlong *)FUN_1400ca000(uVar13," stripLineD=");
                if ((char)plVar12[1] != '\0') {
                  FUN_1400cae40(*plVar12 + 8,uVar3);
                }
                uVar6 = FUN_1400c8260(param_1);
                local_7f0 = CONCAT44(local_7f0._4_4_,uVar6);
                uVar13 = FUN_14005fa30(uVar15);
                plVar12 = (longlong *)FUN_1400ca000(uVar13," buildPlatform=");
                if ((char)plVar12[1] != '\0') {
                  FUN_1400caa00(*plVar12 + 8,uVar6);
                }
                local_810 = (undefined8 *)0x0;
                local_808 = CONCAT62(local_808._2_6_,1);
                local_800 = (uint *******)0x0;
                local_7f8 = 1;
                FUN_1400d25f0(param_1,&local_810);
                uVar13 = FUN_14005fa30(uVar15);
                FUN_1400ca000(uVar13,&DAT_14058a334);
                uVar6 = (undefined4)((ulonglong)in_stack_fffffffffffff588 >> 0x20);
                uVar40 = (undefined4)((ulonglong)in_stack_fffffffffffff5a8 >> 0x20);
                uVar8 = (undefined4)((ulonglong)in_stack_fffffffffffff5c0 >> 0x20);
                uVar9 = (undefined4)((ulonglong)in_stack_fffffffffffff5c8 >> 0x20);
                pppppppuVar16 = pppppppuVar36;
                if (local_800 != (uint *******)0x0) {
                  do {
                    if ((pppppppuVar36 != (uint *******)0x0) &&
                       (plVar12 = (longlong *)FUN_14005fa30(uVar15), (char)plVar12[1] != '\0')) {
                      FUN_1400ca060(*plVar12 + 8,0x2c);
                    }
                    local_res20 = (longlong *)FUN_14005fa30(uVar15);
                    if ((char)local_res20[1] != '\0') {
                      FUN_1400ca060(*local_res20 + 8,0x3c);
                    }
                    local_res20 = (longlong *)
                                  FUN_1400ca360(local_res20,
                                                (byte *)((longlong)local_810 +
                                                        (longlong)pppppppuVar16));
                    if ((char)local_res20[1] != '\0') {
                      FUN_1400ca060(*local_res20 + 8,0x3d);
                    }
                    plVar12 = (longlong *)
                              FUN_1400ca360(local_res20,
                                            (byte *)((longlong)(local_810 + 5) +
                                                    (longlong)pppppppuVar16));
                    if ((char)plVar12[1] != '\0') {
                      FUN_1400ca060(*plVar12 + 8,0x3e);
                    }
                    uVar6 = (undefined4)((ulonglong)in_stack_fffffffffffff588 >> 0x20);
                    uVar40 = (undefined4)((ulonglong)in_stack_fffffffffffff5a8 >> 0x20);
                    uVar8 = (undefined4)((ulonglong)in_stack_fffffffffffff5c0 >> 0x20);
                    uVar9 = (undefined4)((ulonglong)in_stack_fffffffffffff5c8 >> 0x20);
                    pppppppuVar36 = (uint *******)((longlong)pppppppuVar36 + 1);
                    pppppppuVar16 = pppppppuVar16 + 10;
                  } while (pppppppuVar36 < local_800);
                }
                local_930 = (undefined8 *******)0x0;
                local_928 = 1;
                local_920 = 0;
                local_918 = 1;
                local_790 = 1;
                local_7b0 = (undefined8 *******)((ulonglong)local_7b0 & 0xffffffffffffff00);
                local_798 = CONCAT17(0x1f,(undefined7)local_798);
                FUN_1400d26b0(param_1,&local_930,&local_7b0);
                plVar12 = (longlong *)FUN_14005fa30(uVar15);
                if ((char)plVar12[1] != '\0') {
                  FUN_140007bf0(*plVar12 + 8," pKW=");
                }
                if ((char)plVar12[1] != '\0') {
                  pppppppuVar18 = local_7b0;
                  lVar32 = local_7a0;
                  if (local_798._7_1_ < 0x40) {
                    pppppppuVar18 = &local_7b0;
                    lVar32 = 0x1f - (longlong)(char)local_798._7_1_;
                  }
                  FUN_1400d4880(*plVar12 + 8,pppppppuVar18,lVar32);
                }
                local_998 = (undefined8 *******)0x0;
                local_990 = 1;
                local_988 = (uint *******)0x0;
                local_980 = 1;
                local_9a0 = 1;
                local_9c0[0]._0_1_ = 0;
                local_9a1 = 0x1f;
                FUN_1400d26b0(param_1,&local_998,local_9c0);
                uVar13 = FUN_14005fa30(uVar15);
                plVar12 = (longlong *)FUN_1400ca000(uVar13," uKW=");
                if ((char)plVar12[1] != '\0') {
                  if (local_9a1 < 0x40) {
                    local_9b0 = (uint *******)(0x1f - (longlong)(char)local_9a1);
                  }
                  puVar25 = (undefined1 *)local_9c0;
                  if (0x3f < local_9a1) {
                    puVar25 = (undefined1 *)CONCAT71(local_9c0[0]._1_7_,local_9c0[0]._0_1_);
                  }
                  FUN_1400d4880(*plVar12 + 8,puVar25,local_9b0);
                }
                uVar10 = thunk_FUN_1400c8260(param_1);
                local_res20 = (longlong *)CONCAT44(local_res20._4_4_,uVar10);
                uVar13 = FUN_14005fa30(uVar15);
                uVar13 = FUN_1400ca000(uVar13," platform=");
                uVar17 = FUN_14008ec70(local_898,uVar10);
                FUN_1400ca360(uVar13,uVar17);
                if ((local_879 & 0xc0) == 0x40) {
                  thunk_FUN_1403f2404(local_898[0],local_878,
                                      "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                      ,0x218);
                }
                pppppppuVar18 = (undefined8 *******)FUN_1400c8350(param_1);
                local_968 = pppppppuVar18;
                uVar13 = FUN_14005fa30(uVar15);
                plVar12 = (longlong *)FUN_1400ca000(uVar13," flags=");
                if ((char)plVar12[1] != '\0') {
                  FUN_1400cac20(*plVar12 + 8,pppppppuVar18);
                }
                uVar13 = FUN_1400c8350(param_1);
                uVar17 = FUN_14005fa30(uVar15);
                plVar12 = (longlong *)FUN_1400ca000(uVar17," reqs=");
                if ((char)plVar12[1] != '\0') {
                  FUN_1400cac20(*plVar12 + 8,uVar13);
                }
                uVar10 = FUN_1400c8260(param_1);
                uVar17 = FUN_14005fa30(uVar15);
                plVar12 = (longlong *)FUN_1400ca000(uVar17," forceDXC=");
                if ((char)plVar12[1] != '\0') {
                  FUN_14001a380(*plVar12 + 8,uVar10);
                }
                uVar11 = FUN_1400c8260(param_1);
                plVar12 = (longlong *)FUN_14005fa30(uVar15);
                if ((char)plVar12[1] != '\0') {
                  FUN_140007bf0(*plVar12 + 8," forceFXC=");
                }
                if ((char)plVar12[1] != '\0') {
                  FUN_14001a380(*plVar12 + 8,uVar11);
                }
                local_870 = (uint ******)0x0;
                pppppppuStack_868 = (uint *******)0x0;
                local_860 = 0;
                cVar5 = HandleCompileComputeKernelCommand
                                  (&local_768,&local_848,&local_908,&local_810,&local_930,&local_998
                                   ,CONCAT44(uVar6,(undefined4)local_7f0),(char)local_res18[0],
                                   (ulonglong)local_res10 & 0xff,&local_870,
                                   CONCAT44(uVar40,(undefined4)local_res20),local_968,uVar13,
                                   CONCAT44(uVar8,uVar10),CONCAT44(uVar9,uVar11),FUN_1400d3ec0,
                                   param_1);
                plVar12 = (longlong *)FUN_14005fa30(uVar15);
                if ((char)plVar12[1] != '\0') {
                  FUN_140007bf0(*plVar12 + 8,&DAT_14058a0fc);
                }
                if ((char)plVar12[1] != '\0') {
                  FUN_1400cae40(*plVar12 + 8,cVar5);
                }
                puVar25 = &DAT_14058a35c;
                if (cVar5 != '\0') {
                  puVar25 = &DAT_140578fc4;
                }
                local_938 = 0x4b;
                local_958 = 0;
                local_939 = 0x1f;
                FUN_140054780(&local_958,"computeData: ",0xd);
                uVar13 = FUN_14001ad10(local_898,&local_958,puVar25);
                uVar13 = FUN_14001aa00(uVar13,&local_9e8);
                FUN_1400c9340(param_1,uVar13);
                if ((local_879 & 0xc0) == 0x40) {
                  thunk_FUN_1403f2404(local_898[0],local_878,
                                      "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                      ,0x218);
                }
                if ((local_939 & 0xc0) == 0x40) {
                  thunk_FUN_1403f2404(CONCAT71(uStack_957,local_958),local_938,
                                      "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                      ,0x218);
                }
                FUN_1400c8a70(param_1,local_870,(longlong)pppppppuStack_868 - (longlong)local_870);
                plVar12 = (longlong *)FUN_14005fa30(uVar15);
                if ((char)plVar12[1] != '\0') {
                  FUN_140007bf0(*plVar12 + 8," outsize=");
                }
                if ((char)plVar12[1] != '\0') {
                  FUN_1400cac20(*plVar12 + 8,(longlong)pppppppuStack_868 - (longlong)local_870);
                }
                FUN_14005f880(plVar12,FUN_14005f9b0);
                if (local_870 != (uint ******)0x0) {
                  ppppppuVar21 = local_870;
                  if (0xfff < (ulonglong)(local_860 - (longlong)local_870)) {
                    ppppppuVar21 = (uint ******)local_870[-1];
                    if (0x1f < ((longlong)local_870 - (longlong)ppppppuVar21) - 8U) {
                    /* WARNING: Subroutine does not return */
                      FUN_1403de184((longlong)local_870 - (longlong)ppppppuVar21,
                                    (local_860 - (longlong)local_870) + 0x27);
                    }
                  }
                  thunk_FUN_1403f2404(ppppppuVar21);
                  local_870 = (uint ******)0x0;
                  pppppppuStack_868 = (uint *******)0x0;
                  local_860 = 0;
                }
                if ((local_9a1 & 0xc0) == 0x40) {
                  thunk_FUN_1403f2404(CONCAT71(local_9c0[0]._1_7_,local_9c0[0]._0_1_),local_9a0,
                                      "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                      ,0x218);
                }
                FUN_140018ba0(&local_998);
                if ((local_798._7_1_ & 0xc0) == 0x40) {
                  thunk_FUN_1403f2404(local_7b0,local_790,
                                      "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                      ,0x218);
                }
                FUN_140018ba0(&local_930);
                FUN_140017ca0(&local_810);
                if ((local_8e9 & 0xc0) == 0x40) {
                  thunk_FUN_1403f2404(CONCAT71(uStack_907,local_908),local_8e8,
                                      "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                      ,0x218);
                }
                if ((local_830._7_1_ & 0xc0) == 0x40) {
                  thunk_FUN_1403f2404(local_848,(ulonglong)puStack_828 & 0xffff,
                                      "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                      ,0x218);
                }
                if ((local_749 & 0xc0) == 0x40) {
                  thunk_FUN_1403f2404(CONCAT71(uStack_767,local_768),local_748,
                                      "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                      ,0x218);
                }
              }
            }
            else {
              uVar13 = FUN_14005fa30(uVar15);
              uVar13 = FUN_1400ca000(uVar13,"Cmd: preprocessCompute");
              FUN_14005f880(uVar13,FUN_14005f9b0);
              FUN_1400ca3b0(local_738);
              local_9a0 = 1;
              local_9c0[0]._0_1_ = 0;
              local_9a1 = 0x1f;
              FUN_1400c8030(param_1,local_9c0);
              uVar13 = FUN_14005fa30(uVar15);
              plVar12 = (longlong *)FUN_1400ca000(uVar13,"  insize=");
              pppppppuVar16 = local_9b0;
              if (local_9a1 < 0x40) {
                pppppppuVar16 = (uint *******)(0x1f - (longlong)(char)local_9a1);
              }
              if ((char)plVar12[1] != '\0') {
                FUN_1400cac20(*plVar12 + 8,pppppppuVar16);
              }
              local_8e8 = 1;
              local_908 = 0;
              local_8e9 = 0x1f;
              FUN_1400c8030(param_1,&local_908);
              uVar13 = FUN_14005fa30(uVar15);
              uVar13 = FUN_1400ca000(uVar13," file=");
              FUN_1400ca360(uVar13,&local_908);
              local_6d8 = FUN_1400c8260(param_1);
              uVar13 = FUN_14005fa30(uVar15);
              plVar12 = (longlong *)FUN_1400ca000(uVar13," buildPlatform=");
              if ((char)plVar12[1] != '\0') {
                FUN_1400caa00(*plVar12 + 8,local_6d8);
              }
              local_6d4 = FUN_1400c8260(param_1);
              uVar13 = FUN_14005fa30(uVar15);
              plVar12 = (longlong *)FUN_1400ca000(uVar13," validAPIs=");
              if ((char)plVar12[1] != '\0') {
                FUN_14001a380(*plVar12 + 8,local_6d4);
              }
              local_7b8 = 1;
              local_7d8 = 0;
              local_7b9 = 0x1f;
              FUN_1400d26b0(param_1,local_6d0,&local_7d8);
              uVar13 = FUN_14005fa30(uVar15);
              uVar13 = FUN_1400ca000(uVar13," pKW=");
              FUN_1400ca360(uVar13,&local_7d8);
              local_938 = 1;
              local_958 = 0;
              local_939 = 0x1f;
              FUN_1400d26b0(param_1,local_6b0,&local_958);
              uVar13 = FUN_14005fa30(uVar15);
              uVar13 = FUN_1400ca000(uVar13," dKW=");
              FUN_1400ca360(uVar13,&local_958);
              local_930 = (undefined8 *******)0x0;
              local_928 = 1;
              local_920 = 0;
              local_918 = 1;
              local_7b0 = (undefined8 *******)0x0;
              local_7a8 = 1;
              local_7a0 = 0;
              local_798 = 1;
              local_998 = (undefined8 *******)0x0;
              local_990 = 1;
              local_988 = (uint *******)0x0;
              local_980 = 1;
              FUN_140066c70(local_5a8);
              local_848 = 0x21;
              local_840 = 0;
              local_838 = CONCAT62(local_838._2_6_,0x19);
              local_830 = 0;
              puStack_828 = (undefined4 *)0x1;
              local_8c8 = &DAT_14058aa4c;
              local_8c0 = 0;
              local_8b8 = 0;
              local_8b2 = 1;
              local_8b0 = &DAT_14058aa4c;
              local_8a8 = 0;
              local_8a0 = 0;
              local_89a = 1;
              local_res18[0] = 0;
              local_res20 = (longlong *)((ulonglong)local_res20._4_4_ << 0x20);
              local_8d0[0] = 0;
              pppppppuVar24 = &local_998;
              pppppppuVar38 = &local_7b0;
              uVar3 = HandleComputeKernelPreprocessRequest
                                (local_9c0,&local_908,local_738,&local_930,pppppppuVar38,
                                 pppppppuVar24,pppppppuVar18,local_5a8,&local_848,local_res18,
                                 &local_res20,local_8d0,&local_7e8,&local_8c8,FUN_1400d3ec0,param_1)
              ;
              uVar13 = FUN_14005fa30(uVar15);
              plVar12 = (longlong *)FUN_1400ca000(uVar13,&DAT_14058a0fc);
              if ((char)plVar12[1] != '\0') {
                FUN_1400cae40(*plVar12 + 8,uVar3);
              }
              uVar13 = FUN_1400e0f60(local_898,"computeKeywordsUserGlobal: %i",local_598);
              uVar13 = FUN_14001aa00(uVar13,&local_9e8);
              FUN_1400c9340(param_1,uVar13);
              FUN_140017380(local_898);
              FUN_1400d4110(param_1,local_5a8);
              uVar13 = FUN_1400e0f60(local_898,"computeKeywordsUserLocal: %i",local_4b8);
              uVar13 = FUN_14001aa00(uVar13,&local_9e8);
              FUN_1400c9340(param_1,uVar13);
              FUN_140017380(local_898);
              FUN_1400d4110(param_1,local_4c8);
              uVar13 = FUN_1400e0f60(local_898,"computeKeywordsDynamic:");
              uVar13 = FUN_14001aa00(uVar13,&local_9e8);
              FUN_1400c9340(param_1,uVar13);
              FUN_140017380(local_898);
              FUN_1400d43e0(param_1,local_308);
              uVar13 = FUN_1400e0f60(local_898,"computeKeywordsNotSuitedForDynamic:");
              uVar13 = FUN_14001aa00(uVar13,&local_9e8);
              FUN_1400c9340(param_1,uVar13);
              FUN_140017380(local_898);
              FUN_1400d43e0(param_1,&local_998);
              uVar6 = (undefined4)((ulonglong)pppppppuVar38 >> 0x20);
              uVar40 = (undefined4)((ulonglong)pppppppuVar24 >> 0x20);
              uVar8 = (undefined4)((ulonglong)pppppppuVar18 >> 0x20);
              local_res10 = (undefined1 *)((ulonglong)local_res10._4_4_ << 0x20);
              if (local_920 != 0) {
                local_7f0 = 0;
                local_788 = 0;
                do {
                  puVar34 = (undefined8 *)((longlong)local_930 + local_788);
                  if (0x3f < *(byte *)((longlong)puVar34 + 0x1f)) {
                    puVar34 = (undefined8 *)*puVar34;
                  }
                  local_778 = (undefined **)
                              FUN_1400e0f60(local_898,"kernel: %s %i",puVar34,
                                            *(undefined8 *)(local_7f0 + 0x10 + (longlong)local_7b0))
                  ;
                  if (*(byte *)((longlong)local_778 + 0x1f) < 0x40) {
                    local_770 = (undefined *)
                                (0x1f - (longlong)*(char *)((longlong)local_778 + 0x1f));
                  }
                  else {
                    local_770 = local_778[2];
                    local_778 = (undefined **)*local_778;
                  }
                  FUN_1400c9340(param_1,&local_778);
                  if ((local_879 & 0xc0) == 0x40) {
                    thunk_FUN_1403f2404(local_898[0],local_878,
                                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                        ,0x218);
                  }
                  puVar34 = *(undefined8 **)(local_7f0 + (longlong)local_7b0);
                  if (puVar34 !=
                      puVar34 + *(longlong *)(local_7f0 + 0x10 + (longlong)local_7b0) * 10) {
                    pbVar20 = (byte *)((longlong)puVar34 + 0x47);
                    do {
                      if (pbVar20[-0x28] < 0x40) {
                        local_808 = 0x1f - (longlong)(char)pbVar20[-0x28];
                        local_810 = puVar34;
                      }
                      else {
                        local_808 = *(longlong *)(pbVar20 + -0x37);
                        local_810 = (undefined8 *)*puVar34;
                      }
                      FUN_1400c9340(param_1,&local_810);
                      if (*pbVar20 < 0x40) {
                        lVar32 = 0x1f - (longlong)(char)*pbVar20;
                      }
                      else {
                        lVar32 = *(longlong *)(pbVar20 + -0xf);
                      }
                      pppppppuVar16 = pppppppuVar36;
                      if (lVar32 == 0) {
                        do {
                          if (*(byte *)((longlong)pppppppuVar16 + 0x140578fc4) == 0)
                          goto LAB_1400ce8ac;
                          pppppppuVar16 = (uint *******)((longlong)pppppppuVar16 + 1);
                        } while (pppppppuVar16 < (uint *******)0x2);
                        pppppppuVar16 = (uint *******)0x2;
LAB_1400ce8ac:
                        local_870 = (uint ******)&DAT_140578fc4;
                        pppppppuVar26 = &local_870;
                        pppppppuStack_868 = pppppppuVar16;
                      }
                      else {
                        if (*pbVar20 < 0x40) {
                          local_9e0 = (uint *******)(0x1f - (longlong)(char)*pbVar20);
                          local_9e8 = (uint *******)(pbVar20 + -0x1f);
                        }
                        else {
                          local_9e0 = *(uint ********)(pbVar20 + -0xf);
                          local_9e8 = *(uint ********)(pbVar20 + -0x1f);
                        }
                        pppppppuVar26 = (uint *******)&local_9e8;
                      }
                      FUN_1400c9340(param_1,pppppppuVar26);
                      puVar34 = puVar34 + 10;
                      pbVar20 = pbVar20 + 0x50;
                    } while (puVar34 !=
                             (undefined8 *)
                             (*(longlong *)(local_7f0 + 0x10 + (longlong)local_7b0) * 0x50 +
                             *(longlong *)(local_7f0 + (longlong)local_7b0)));
                  }
                  uVar6 = (undefined4)((ulonglong)pppppppuVar38 >> 0x20);
                  uVar40 = (undefined4)((ulonglong)pppppppuVar24 >> 0x20);
                  uVar8 = (undefined4)((ulonglong)pppppppuVar18 >> 0x20);
                  iVar22 = (int)local_res10 + 1;
                  local_res10 = (undefined1 *)CONCAT44(local_res10._4_4_,iVar22);
                  local_788 = local_788 + 0x28;
                  local_7f0 = local_7f0 + 0x20;
                } while ((ulonglong)(longlong)iVar22 < local_920);
              }
              do {
                if (*(byte *)(pppppppuVar36 + 0x280b145a) == 0) goto LAB_1400ce980;
                pppppppuVar36 = (uint *******)((longlong)pppppppuVar36 + 1);
              } while (pppppppuVar36 < (uint *******)0xe);
              pppppppuVar36 = (uint *******)0xe;
LAB_1400ce980:
              local_9e8 = (uint *******)0x14058a2d0;
              local_9e0 = pppppppuVar36;
              FUN_1400c9340(param_1,&local_9e8);
              FUN_1400d47f0(param_1,&local_848);
              uVar13 = FUN_1400e0f60(local_898,"endKernels: %llu %i %i %i %i %i %i",local_968,
                                     (ulonglong)local_7e8 & 0xffffffff,
                                     CONCAT44(uVar6,local_7e8._4_4_),
                                     CONCAT44(uVar40,(undefined4)local_7e0),
                                     CONCAT44(uVar8,local_7e0._4_4_),local_8c0 >> 0x20,
                                     local_8a8 >> 0x20);
              uVar13 = FUN_14001aa00(uVar13,&local_9e8);
              FUN_1400c9340(param_1,uVar13);
              if ((local_879 & 0xc0) == 0x40) {
                thunk_FUN_1403f2404(local_898[0],local_878,
                                    "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                    ,0x218);
              }
              FUN_1400ab710(&local_8c8,&local_9e8);
              pppppppuVar26 = local_9e0;
              pppppppuVar36 =
                   (uint *******)((longlong)local_8c8 + ((local_8c0 & 0xffffffff) + 0x10) * 3);
              pppppppuVar16 = local_9e8;
              uVar29 = local_8a8;
joined_r0x0001400cea6c:
              local_8a8 = uVar29;
              if (pppppppuVar36 != pppppppuVar16) {
                local_9e8 = pppppppuVar16 + 1;
                if (*(byte *)((longlong)pppppppuVar16 + 0x27) < 0x40) {
                  local_9e0 = (uint *******)
                              (0x1f - (longlong)(char)*(byte *)((longlong)pppppppuVar16 + 0x27));
                }
                else {
                  local_9e0 = (uint *******)pppppppuVar16[3];
                  local_9e8 = (uint *******)*local_9e8;
                }
                FUN_1400c9340(param_1,&local_9e8);
                do {
                  pppppppuVar16 = pppppppuVar16 + 6;
                  uVar29 = local_8a8;
                  if (pppppppuVar26 <= pppppppuVar16) break;
                } while (0xfffffffd < *(uint *)pppppppuVar16);
                goto joined_r0x0001400cea6c;
              }
              local_8a8._4_4_ = (int)(uVar29 >> 0x20);
              bVar37 = local_8a8._4_4_ != 0;
              if (bVar37) {
                puVar1 = (uint *)((longlong)local_8b0 + ((uVar29 & 0xffffffff) + 0x10) * 3);
                for (puVar30 = local_8b0; (puVar30 < puVar1 && (0xfffffffd < *puVar30));
                    puVar30 = puVar30 + 0xc) {
                }
                puVar2 = (uint *)((longlong)local_8b0 + ((uVar29 & 0xffffffff) + 0x10) * 3);
joined_r0x0001400ceb0c:
                if (puVar2 != puVar30) {
                  local_9e8 = (uint *******)(puVar30 + 2);
                  if (*(byte *)((longlong)puVar30 + 0x27) < 0x40) {
                    local_9e0 = (uint *******)(0x1f - (longlong)*(char *)((longlong)puVar30 + 0x27))
                    ;
                  }
                  else {
                    local_9e0 = *(uint ********)(puVar30 + 6);
                    local_9e8 = (uint *******)*local_9e8;
                  }
                  FUN_1400c9340(param_1,&local_9e8);
                  do {
                    puVar30 = puVar30 + 0xc;
                    if (puVar1 <= puVar30) break;
                  } while (0xfffffffd < *puVar30);
                  goto joined_r0x0001400ceb0c;
                }
              }
              local_9e0 = local_9b0;
              if (local_9a1 < 0x40) {
                local_9e0 = (uint *******)(0x1f - (longlong)(char)local_9a1);
              }
              local_9e8 = local_9c0;
              if (0x3f < local_9a1) {
                local_9e8 = (uint *******)CONCAT71(local_9c0[0]._1_7_,local_9c0[0]._0_1_);
              }
              FUN_1400c9340(param_1,&local_9e8);
              thunk_FUN_1400c95d0(param_1,local_res18[0]);
              FUN_1400c95d0(param_1,(ulonglong)local_res20 & 0xffffffff);
              FUN_1400c95d0(param_1,local_8d0[0]);
              plVar12 = (longlong *)FUN_14005fa30(uVar15);
              if ((char)plVar12[1] != '\0') {
                FUN_140007bf0(*plVar12 + 8," outsize=");
              }
              if (local_9a1 < 0x40) {
                local_9b0 = (uint *******)(0x1f - (longlong)(char)local_9a1);
              }
              if ((char)plVar12[1] != '\0') {
                FUN_1400cac20(*plVar12 + 8,local_9b0);
              }
              FUN_14005f880(plVar12,FUN_14005f9b0);
              FUN_1400171d0(&local_8b0);
              FUN_1400171d0(&local_8c8);
              FUN_140017d70(&local_840);
              _eh_vector_destructor_iterator_(local_138,0x20,8,FUN_140017b90);
              FUN_140018ba0(local_158);
              FUN_140018ba0(local_188);
              FUN_140017b90(local_1a8);
              FUN_140017b90(local_1c8);
              FUN_140067fd0(local_5a8);
              FUN_140018ba0(&local_998);
              FUN_1400ca540(&local_7b0);
              FUN_140018ba0(&local_930);
              if ((local_939 & 0xc0) == 0x40) {
                thunk_FUN_1403f2404(CONCAT71(uStack_957,local_958),local_938,
                                    "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                    ,0x218);
              }
              if ((local_7b9 & 0xc0) == 0x40) {
                thunk_FUN_1403f2404(CONCAT71(uStack_7d7,local_7d8),local_7b8,
                                    "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                    ,0x218);
              }
              if ((local_8e9 & 0xc0) == 0x40) {
                thunk_FUN_1403f2404(CONCAT71(uStack_907,local_908),local_8e8,
                                    "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                    ,0x218);
              }
              if ((local_9a1 & 0xc0) == 0x40) {
                thunk_FUN_1403f2404(CONCAT71(local_9c0[0]._1_7_,local_9c0[0]._0_1_),local_9a0,
                                    "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                    ,0x218);
              }
              _eh_vector_destructor_iterator_(local_690,0x20,7,FUN_140018ba0);
              FUN_140018ba0(local_6b0);
              FUN_140018ba0(local_6d0);
              FUN_140055550(local_6f0);
              FUN_140018ba0(local_710);
              if ((local_719 & 0xc0) == 0x40) {
                thunk_FUN_1403f2404(local_738[0],local_718,
                                    "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                    ,0x218);
              }
            }
          }
          else {
            plVar12 = (longlong *)FUN_14005fa30(uVar15);
            if ((char)plVar12[1] != '\0') {
              FUN_140007bf0(*plVar12 + 8,"Cmd: initializeCompiler");
            }
            FUN_14005f880(plVar12,FUN_14005f9b0);
            local_848 = 0;
            local_840 = CONCAT62(local_840._2_6_,0x4d);
            local_838 = 0;
            uVar35 = 1;
            local_830 = 1;
            puStack_828 = &DAT_14058aa4c;
            local_820 = 0;
            local_818 = 0;
            local_812 = 0x4e;
            uVar7 = thunk_FUN_1400c8260(param_1);
            uVar29 = local_838;
            uVar31 = (ulonglong)uVar7;
            uVar28 = (ulonglong)(int)uVar7;
            if (local_830 >> 1 < uVar28) {
              FUN_140059900(&local_848,uVar28,1);
            }
            local_838 = uVar28;
            if (uVar29 < uVar28) {
              puVar25 = (undefined1 *)(local_848 + uVar29 * 0x28);
              for (lVar32 = uVar28 - uVar29; lVar32 != 0; lVar32 = lVar32 + -1) {
                if (puVar25 != (undefined1 *)0x0) {
                  *(undefined2 *)(puVar25 + 0x20) = (undefined2)local_840;
                  *puVar25 = 0;
                  puVar25[0x1f] = 0x1f;
                }
                puVar25 = puVar25 + 0x28;
              }
            }
            else if (uVar28 < uVar29) {
              FUN_140010020(local_848 + uVar28 * 0x28,uVar29 - uVar28);
            }
            pppppppuVar16 = pppppppuVar36;
            if (0 < (int)uVar7) {
              do {
                uVar15 = FUN_1400c81e0(local_898,param_1);
                FUN_1400545d0((byte *)(local_848 + (longlong)pppppppuVar16),uVar15);
                if ((local_879 & 0xc0) == 0x40) {
                  thunk_FUN_1403f2404(local_898[0],local_878,
                                      "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                      ,0x218);
                }
                uVar31 = uVar31 - 1;
                pppppppuVar16 = pppppppuVar16 + 5;
              } while (uVar31 != 0);
            }
            uVar7 = thunk_FUN_1400c8260(param_1);
            local_7b8 = 0x4b;
            local_7d8 = 0;
            local_7b9 = 0x1f;
            local_938 = 0x4b;
            local_958 = 0;
            local_939 = 0x1f;
            if (0 < (int)uVar7) {
              uVar29 = (ulonglong)uVar7;
              do {
                FUN_1400c8030(param_1,&local_7d8);
                FUN_1400c8030(param_1,&local_958);
                FUN_140088af0(&puStack_828,&local_9e8,&local_7d8,&local_958);
                uVar29 = uVar29 - 1;
              } while (uVar29 != 0);
            }
            local_9a0 = 0x4b;
            local_9c0[0]._0_1_ = 0;
            local_9a1 = 0x1f;
            FUN_1400c8030(param_1,local_9c0);
            local_res10 = &local_908;
            local_8e8 = local_9a0;
            local_908 = 0;
            local_8e9 = 0x1f;
            if (local_9a1 < 0x40) {
              local_9b0 = (uint *******)(0x1f - (longlong)(char)local_9a1);
            }
            puVar25 = (undefined1 *)local_9c0;
            if (0x3f < local_9a1) {
              puVar25 = (undefined1 *)CONCAT71(local_9c0[0]._1_7_,local_9c0[0]._0_1_);
            }
            lVar32 = FUN_140056c90(&local_908,local_9b0);
            FUN_140558820(lVar32,puVar25,local_9b0);
            *(byte *)(lVar32 + (longlong)local_9b0) = 0;
            if (local_8e9 < 0x40) {
              local_8e9 = 0x1f - (char)local_9b0;
              local_9b0 = local_8f8;
            }
            local_8f8 = local_9b0;
            HandleInitializeCompilerCommand(&local_908);
            FUN_1400b8360(&local_848);
            uVar7 = 0xffffffff;
            pppppppuVar16 = pppppppuVar36;
            do {
              cVar5 = (**(code **)(*DAT_14074ece0 + 8))(DAT_14074ece0,pppppppuVar16);
              if (cVar5 == '\0') {
                uVar7 = uVar7 & ~uVar35;
              }
              else {
                (**(code **)(*DAT_14074ece0 + 0x50))(DAT_14074ece0,pppppppuVar16);
              }
              uVar27 = (int)pppppppuVar16 + 1;
              pppppppuVar16 = (uint *******)(ulonglong)uVar27;
              uVar35 = uVar35 << 1 | (uint)((int)uVar35 < 0);
            } while ((int)uVar27 < 0x1c);
            thunk_FUN_1400c95d0(param_1,uVar7);
            do {
              uVar15 = FUN_1400bf620(pppppppuVar36);
              FUN_1400c96c0(param_1,uVar15);
              uVar6 = (**(code **)(*DAT_14074ece0 + 0x58))(DAT_14074ece0,pppppppuVar36);
              thunk_FUN_1400c95d0(param_1,uVar6);
              uVar7 = (int)pppppppuVar36 + 1;
              pppppppuVar36 = (uint *******)(ulonglong)uVar7;
            } while ((int)uVar7 < 0x1c);
            if ((local_9a1 & 0xc0) == 0x40) {
              thunk_FUN_1403f2404(CONCAT71(local_9c0[0]._1_7_,local_9c0[0]._0_1_),local_9a0,
                                  "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                  ,0x218);
            }
            if ((local_939 & 0xc0) == 0x40) {
              thunk_FUN_1403f2404(CONCAT71(uStack_957,local_958),local_938,
                                  "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                  ,0x218);
            }
            if ((local_7b9 & 0xc0) == 0x40) {
              thunk_FUN_1403f2404(CONCAT71(uStack_7d7,local_7d8),local_7b8,
                                  "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                  ,0x218);
            }
            FUN_140055550(&puStack_828);
            FUN_140018ba0(&local_848);
          }
        }
        else {
          plVar12 = (longlong *)FUN_14005fa30(uVar15);
          if ((char)plVar12[1] != '\0') {
            FUN_140007bf0(*plVar12 + 8,"Cmd: compileSnippet");
          }
          FUN_14005f880(plVar12,FUN_14005f9b0);
          local_748 = 1;
          local_768 = 0;
          local_749 = 0x1f;
          FUN_1400c8030(param_1,&local_768);
          plVar12 = (longlong *)FUN_14005fa30(uVar15);
          if ((char)plVar12[1] != '\0') {
            FUN_140007bf0(*plVar12 + 8,"  insize=");
          }
          if (local_749 < 0x40) {
            local_758 = 0x1f - (longlong)(char)local_749;
          }
          if ((char)plVar12[1] != '\0') {
            FUN_1400cac20(*plVar12 + 8,local_758);
          }
          local_8e8 = 1;
          local_908 = 0;
          local_8e9 = 0x1f;
          FUN_1400c8030(param_1,&local_908);
          puStack_828 = (undefined4 *)CONCAT62(puStack_828._2_6_,1);
          local_848 = local_848 & 0xffffffffffffff00;
          local_830 = CONCAT17(0x1f,(undefined7)local_830);
          FUN_1400c8030(param_1,&local_848);
          plVar12 = (longlong *)FUN_14005fa30(uVar15);
          if ((char)plVar12[1] != '\0') {
            FUN_140007bf0(*plVar12 + 8," file=");
          }
          plVar12 = (longlong *)FUN_1400ca360(plVar12,&local_908);
          if ((char)plVar12[1] != '\0') {
            FUN_1400ca060(*plVar12 + 8,0x2f);
          }
          FUN_1400ca360(plVar12,&local_848);
          local_8a8 = CONCAT62(local_8a8._2_6_,1);
          local_8c8 = (uint *)((ulonglong)local_8c8 & 0xffffffffffffff00);
          local_8b0 = (uint *)CONCAT17(0x1f,(undefined7)local_8b0);
          FUN_1400c8030(param_1,&local_8c8);
          plVar12 = (longlong *)FUN_14005fa30(uVar15);
          if ((char)plVar12[1] != '\0') {
            FUN_140007bf0(*plVar12 + 8," name=");
          }
          FUN_1400ca360(plVar12,&local_8c8);
          local_938 = 1;
          local_958 = 0;
          local_939 = 0x1f;
          FUN_1400c8030(param_1,&local_958);
          plVar12 = (longlong *)FUN_14005fa30(uVar15);
          if ((char)plVar12[1] != '\0') {
            FUN_140007bf0(*plVar12 + 8," pass=");
          }
          FUN_1400ca360(plVar12,&local_958);
          uVar3 = FUN_1400c7930(param_1);
          local_res18[0] = CONCAT31(local_res18[0]._1_3_,uVar3);
          plVar12 = (longlong *)FUN_14005fa30(uVar15);
          if ((char)plVar12[1] != '\0') {
            FUN_140007bf0(*plVar12 + 8," ppOnly=");
          }
          if ((char)plVar12[1] != '\0') {
            FUN_1400cae40(*plVar12 + 8,uVar3);
          }
          uVar3 = FUN_1400c7930(param_1);
          local_res10 = (undefined1 *)CONCAT71(local_res10._1_7_,uVar3);
          plVar12 = (longlong *)FUN_14005fa30(uVar15);
          if ((char)plVar12[1] != '\0') {
            FUN_140007bf0(*plVar12 + 8," stripLineD=");
          }
          if ((char)plVar12[1] != '\0') {
            FUN_1400cae40(*plVar12 + 8,uVar3);
          }
          uVar8 = FUN_1400c8260(param_1);
          local_788 = CONCAT44(local_788._4_4_,uVar8);
          plVar12 = (longlong *)FUN_14005fa30(uVar15);
          if ((char)plVar12[1] != '\0') {
            FUN_140007bf0(*plVar12 + 8," buildPlatform=");
          }
          if ((char)plVar12[1] != '\0') {
            FUN_1400caa00(*plVar12 + 8,uVar8);
          }
          iVar22 = thunk_FUN_1400c8260(param_1);
          local_8e0 = (char *)(longlong)iVar22;
          plVar12 = (longlong *)FUN_14005fa30(uVar15);
          if ((char)plVar12[1] != '\0') {
            FUN_140007bf0(*plVar12 + 8," rsLen=");
          }
          if ((char)plVar12[1] != '\0') {
            FUN_1400cac20(*plVar12 + 8,(char *)(longlong)iVar22);
          }
          local_810 = (undefined8 *)0x0;
          local_808 = CONCAT62(local_808._2_6_,1);
          local_800 = (uint *******)0x0;
          local_7f8 = 1;
          local_7b8 = 1;
          local_7d8 = 0;
          local_7b9 = 0x1f;
          FUN_1400d26b0(param_1,&local_810,&local_7d8);
          plVar12 = (longlong *)FUN_14005fa30(uVar15);
          if ((char)plVar12[1] != '\0') {
            FUN_140007bf0(*plVar12 + 8," pKW=");
          }
          FUN_1400ca360(plVar12,&local_7d8);
          local_7b0 = (undefined8 *******)0x0;
          local_7a8 = 1;
          local_7a0 = 0;
          local_798 = 1;
          local_978 = 1;
          local_998 = (undefined8 *******)((ulonglong)local_998 & 0xffffffffffffff00);
          local_980 = CONCAT17(0x1f,(undefined7)local_980);
          FUN_1400d26b0(param_1,&local_7b0,&local_998);
          plVar12 = (longlong *)FUN_14005fa30(uVar15);
          if ((char)plVar12[1] != '\0') {
            FUN_140007bf0(*plVar12 + 8," uKW=");
          }
          if ((char)plVar12[1] != '\0') {
            pppppppuVar18 = local_998;
            pppppppuVar36 = local_988;
            if (local_980._7_1_ < 0x40) {
              pppppppuVar18 = &local_998;
              pppppppuVar36 = (uint *******)(0x1f - (longlong)(char)local_980._7_1_);
            }
            FUN_1400d4880(*plVar12 + 8,pppppppuVar18,pppppppuVar36);
          }
          local_930 = (undefined8 *******)0x0;
          local_928 = 1;
          local_920 = 0;
          local_918 = 1;
          local_9a0 = 1;
          local_9c0[0]._0_1_ = 0;
          local_9a1 = 0x1f;
          FUN_1400d26b0(param_1,&local_930,local_9c0);
          plVar12 = (longlong *)FUN_14005fa30(uVar15);
          if ((char)plVar12[1] != '\0') {
            FUN_140007bf0(*plVar12 + 8," dKW=");
          }
          if ((char)plVar12[1] != '\0') {
            if (local_9a1 < 0x40) {
              local_9b0 = (uint *******)(0x1f - (longlong)(char)local_9a1);
            }
            puVar25 = (undefined1 *)local_9c0;
            if (0x3f < local_9a1) {
              puVar25 = (undefined1 *)CONCAT71(local_9c0[0]._1_7_,local_9c0[0]._0_1_);
            }
            FUN_1400d4880(*plVar12 + 8,puVar25,local_9b0);
          }
          uVar7 = FUN_1400c8260(param_1);
          local_968 = (undefined8 *******)(ulonglong)uVar7;
          ppuVar14 = (undefined **)FUN_1400c8350(param_1);
          local_7e8 = ppuVar14;
          plVar12 = (longlong *)FUN_14005fa30(uVar15);
          if ((char)plVar12[1] != '\0') {
            FUN_140007bf0(*plVar12 + 8," flags=");
          }
          if ((char)plVar12[1] != '\0') {
            FUN_1400cac20(*plVar12 + 8,ppuVar14);
          }
          uVar8 = thunk_FUN_1400c8260(param_1);
          local_780 = uVar8;
          plVar12 = (longlong *)FUN_14005fa30(uVar15);
          if ((char)plVar12[1] != '\0') {
            FUN_140007bf0(*plVar12 + 8," lang=");
          }
          if ((char)plVar12[1] != '\0') {
            FUN_1400caa00(*plVar12 + 8,uVar8);
          }
          local_8d0[0] = thunk_FUN_1400c8260(param_1);
          lVar32 = (longlong)local_8d0[0];
          plVar12 = (longlong *)FUN_14005fa30(uVar15);
          if ((char)plVar12[1] != '\0') {
            FUN_140007bf0(*plVar12 + 8," type=");
          }
          FUN_1400ca030(plVar12,&PTR_s_Vertex_140728028 + lVar32);
          uVar8 = thunk_FUN_1400c8260(param_1);
          local_res20 = (longlong *)CONCAT44(local_res20._4_4_,uVar8);
          plVar12 = (longlong *)FUN_14005fa30(uVar15);
          if ((char)plVar12[1] != '\0') {
            FUN_140007bf0(*plVar12 + 8," platform=");
          }
          uVar13 = FUN_14008ec70(&local_9e8,uVar8);
          FUN_1400ca360(plVar12,uVar13);
          if ((local_9c9 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(local_9e8,local_9c8,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          uVar13 = FUN_1400c8350(param_1);
          plVar12 = (longlong *)FUN_14005fa30(uVar15);
          if ((char)plVar12[1] != '\0') {
            FUN_140007bf0(*plVar12 + 8," reqs=");
          }
          if ((char)plVar12[1] != '\0') {
            FUN_1400cac20(*plVar12 + 8,uVar13);
          }
          uVar8 = thunk_FUN_1400c8260(param_1);
          plVar12 = (longlong *)FUN_14005fa30(uVar15);
          if ((char)plVar12[1] != '\0') {
            FUN_140007bf0(*plVar12 + 8," mask=");
          }
          if ((char)plVar12[1] != '\0') {
            FUN_14001a380(*plVar12 + 8,uVar8);
          }
          uVar9 = thunk_FUN_1400c8260(param_1);
          plVar12 = (longlong *)FUN_14005fa30(uVar15);
          if ((char)plVar12[1] != '\0') {
            FUN_140007bf0(*plVar12 + 8," start=");
          }
          if ((char)plVar12[1] != '\0') {
            FUN_1400caa00(*plVar12 + 8,uVar9);
          }
          local_870 = (uint ******)0x0;
          pppppppuStack_868 = (uint *******)0x0;
          local_860 = 0;
          local_778 = ShaderCompilerReflectionReportSend::vftable;
          local_770 = param_1;
          bVar4 = HandleCompileSnippetCommand
                            (&local_768,uVar9,&local_908,&local_848,&local_8c8,&local_810,&local_7b0
                             ,&local_930,local_968,CONCAT44(uVar6,(undefined4)local_788),local_8e0,
                             (char)local_res18[0],(ulonglong)local_res10 & 0xff,local_7e8,&local_870
                             ,&local_7f0,CONCAT44(uVar40,local_780),local_8d0[0],uVar8,
                             (undefined4)local_res20,uVar13,&local_778,FUN_1400d3ec0,param_1);
          plVar12 = (longlong *)FUN_14005fa30(uVar15);
          if ((char)plVar12[1] != '\0') {
            FUN_140007bf0(*plVar12 + 8,&DAT_14058a0fc);
          }
          if ((char)plVar12[1] != '\0') {
            FUN_1400cae40(*plVar12 + 8,bVar4);
          }
          uVar13 = FUN_1400e0f60(local_898,"shader: %c",bVar4 + 0x30);
          uVar13 = FUN_14001aa00(uVar13,&local_9e8);
          FUN_1400c9340(param_1,uVar13);
          if ((local_879 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(local_898[0],local_878,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          thunk_FUN_1400c95d0(param_1,local_7f0 & 0xffffffff);
          FUN_1400c8a70(param_1,local_870,(longlong)pppppppuStack_868 - (longlong)local_870);
          plVar12 = (longlong *)FUN_14005fa30(uVar15);
          if ((char)plVar12[1] != '\0') {
            FUN_140007bf0(*plVar12 + 8," outsize=");
          }
          if ((char)plVar12[1] != '\0') {
            FUN_1400cac20(*plVar12 + 8,(longlong)pppppppuStack_868 - (longlong)local_870);
          }
          FUN_14005f880(plVar12,FUN_14005f9b0);
          local_778 = ShaderCompilerReflectionReport::vftable;
          FUN_140017bd0(&local_870);
          if ((local_9a1 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(local_9c0[0]._1_7_,local_9c0[0]._0_1_),local_9a0,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          FUN_140018ba0(&local_930);
          if ((local_980._7_1_ & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(local_998,local_978,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          FUN_140018ba0(&local_7b0);
          if ((local_7b9 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_7d7,local_7d8),local_7b8,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          FUN_140018ba0(&local_810);
          if ((local_939 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_957,local_958),local_938,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          if ((local_8b0._7_1_ & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(local_8c8,local_8a8 & 0xffff,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          if ((local_830._7_1_ & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(local_848,(ulonglong)puStack_828 & 0xffff,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          if ((local_8e9 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_907,local_908),local_8e8,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          if ((local_749 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_767,local_768),local_748,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
        }
      }
    }
    _guard_check_icall(local_970);
    uVar15 = 1;
  }
  return uVar15;
}
```

## `ReceiveIpcFrameMagic` — `0x1400c7ea0`

receive and verify an IPC frame magic number

```c
/* Receives the 4-byte frame magic and compares it against 0x0C0BD1E4. A mismatch aborts the process
   ("Protocol error - failed to match magic number"), so framing errors are not recoverable. */

void ReceiveIpcFrameMagic(undefined8 param_1,undefined8 param_2)

{
  char cVar1;
  char *pcVar2;
  int local_res18 [4];
  undefined1 local_98 [16];
  undefined8 local_88;
  byte local_79;
  undefined2 local_78;
  undefined1 local_68 [96];
  
  local_res18[0] = 0;
  cVar1 = ReadIpcStreamBytes(param_1,local_res18,4,param_2);
  if (cVar1 == '\0') {
    local_78 = 0x4b;
    local_98[0] = 0;
    local_79 = 0x1f;
    pcVar2 = (char *)FUN_140056c90(local_98,0x2c);
    builtin_strncpy(pcVar2,"Protocol error - failed to read magic number",0x2d);
    if (local_79 < 0x40) {
      local_79 = 0xf3;
    }
    else {
      local_88 = 0x2c;
    }
    FUN_1400afc80(local_68,local_98,param_2);
                    /* WARNING: Subroutine does not return */
    FUN_1403d92fc(local_68,&DAT_1407230a8);
  }
  if (local_res18[0] == 0xc0bd1e4) {
    return;
  }
  local_78 = 0x4b;
  local_98[0] = 0;
  local_79 = 0x1f;
  pcVar2 = (char *)FUN_140056c90(local_98,0x2d);
  builtin_strncpy(pcVar2,"Protocol error - failed to match magic number",0x2e);
  if (local_79 < 0x40) {
    local_79 = 0xf2;
  }
  else {
    local_88 = 0x2d;
  }
  FUN_1400afc80(local_68,local_98,param_2);
                    /* WARNING: Subroutine does not return */
  FUN_1403d92fc(local_68,&DAT_1407230a8);
}
```

## `SendIpcFrameMagic` — `0x1400c8c30`

write an IPC frame magic number

```c
/* Send-side counterpart of ReceiveIpcFrameMagic: writes the 0x0C0BD1E4 frame magic. */

void SendIpcFrameMagic(undefined8 param_1,undefined8 param_2)

{
  char cVar1;
  char *pcVar2;
  undefined1 local_98 [16];
  undefined8 local_88;
  byte local_79;
  undefined2 local_78;
  undefined1 local_68 [96];
  
  cVar1 = WriteIpcStreamBytes(param_1,&DAT_140587c20,4,param_2);
  if (cVar1 != '\0') {
    return;
  }
  local_78 = 0x4b;
  local_98[0] = 0;
  local_79 = 0x1f;
  pcVar2 = (char *)FUN_140056c90(local_98,0x2c);
  builtin_strncpy(pcVar2,"Protocol error - failed to send magic number",0x2d);
  if (local_79 < 0x40) {
    local_79 = 0xf3;
  }
  else {
    local_88 = 0x2c;
  }
  FUN_1400afc80(local_68,local_98,param_2);
                    /* WARNING: Subroutine does not return */
  FUN_1403d92fc(local_68,&DAT_1407230a8);
}
```

## `ReadIpcStreamBytes` — `0x1400c76e0`

byte-level stream read

```c
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* Raw stream read used by every IPC receive helper; fails with "IPC not initialized" when the
   stream handle is unbound. */

char ReadIpcStreamBytes(longlong param_1,undefined8 param_2,ulonglong param_3,ulonglong *param_4)

{
  int iVar1;
  char cVar2;
  ulonglong uVar3;
  longlong lVar4;
  longlong lVar5;
  char *pcVar6;
  ulonglong uVar7;
  int local_res8 [2];
  undefined1 local_a8 [16];
  undefined8 local_98;
  byte local_89;
  undefined2 local_88;
  undefined1 local_80 [104];
  
  if (*(longlong *)(param_1 + 8) == 0) {
    if (*(longlong *)(param_1 + 0x10) == 0) {
      local_88 = 0x4b;
      local_a8[0] = 0;
      local_89 = 0x1f;
      pcVar6 = (char *)FUN_140056c90(local_a8,0x13);
      builtin_strncpy(pcVar6,"IPC not initialized",0x14);
      if (local_89 < 0x40) {
        local_89 = 0xc;
      }
      else {
        local_98 = 0x13;
      }
      FUN_1400afc40(local_80,local_a8);
                    /* WARNING: Subroutine does not return */
      FUN_1403d92fc(local_80,&DAT_1407230a8);
    }
    *(undefined1 *)((longlong)param_4 + 0x14) = 0;
    iVar1 = *(int *)(param_1 + 0x18);
    if (iVar1 == 0) {
      lVar4 = 0;
    }
    else {
      lVar4 = FUN_140128b30();
    }
    cVar2 = (**(code **)(**(longlong **)(param_1 + 0x10) + 0x50))
                      (*(undefined8 *)(param_1 + 0x10),param_2,param_3,
                       *(undefined4 *)(param_1 + 0x18));
    if (((cVar2 == '\0') && (iVar1 != 0)) &&
       (lVar5 = FUN_140128b30(),
       (double)*(uint *)(param_1 + 0x18) <=
       ((double)(ulonglong)(lVar5 - lVar4) * _DAT_1407515e0) / 1000000.0)) {
      *(undefined1 *)((longlong)param_4 + 0x14) = 1;
    }
  }
  else {
    *(undefined1 *)((longlong)param_4 + 0x14) = 0;
    uVar3 = 0;
    local_res8[0] = 0;
    uVar7 = param_3;
    if (*(int *)(param_1 + 0x18) == 0) {
      do {
        lVar4 = FUN_1400f8e00(*(undefined8 *)(param_1 + 8),param_2,uVar7,0x45610000,local_res8);
        uVar3 = uVar3 + lVar4;
        uVar7 = uVar7 - lVar4;
        if (param_3 <= uVar3) break;
      } while ((local_res8[0] == 0) || (local_res8[0] == -0x7ffffff8));
    }
    else {
      uVar3 = FUN_1400f8e00(*(undefined8 *)(param_1 + 8),param_2,param_3,
                            (float)*(uint *)(param_1 + 0x18) / 1000.0,local_res8);
    }
    *(bool *)((longlong)param_4 + 0x14) = local_res8[0] == -0x7ffffff8;
    if ((local_res8[0] == 0) && (uVar3 == param_3)) {
      cVar2 = '\x01';
    }
    else {
      cVar2 = '\0';
      *(int *)(param_4 + 2) = local_res8[0];
      *param_4 = uVar3;
      param_4[1] = param_3;
    }
  }
  return cVar2;
}
```

## `WriteIpcStreamBytes` — `0x1400c8820`

byte-level stream write

```c
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */
/* Raw stream write used by every IPC send helper; fails with "IPC not initialized" when the stream
   handle is unbound. */

char WriteIpcStreamBytes(longlong param_1,longlong param_2,ulonglong param_3,ulonglong *param_4)

{
  int iVar1;
  double dVar2;
  char cVar3;
  longlong lVar4;
  longlong lVar5;
  char *pcVar6;
  ulonglong uVar7;
  ulonglong uVar8;
  ulonglong uVar9;
  undefined4 extraout_XMM0_Da;
  undefined4 extraout_XMM0_Db;
  int local_res8 [2];
  undefined1 local_b8 [16];
  undefined8 local_a8;
  byte local_99;
  undefined2 local_98;
  undefined1 local_90 [104];
  
  if (*(longlong *)(param_1 + 8) == 0) {
    if (*(longlong *)(param_1 + 0x10) == 0) {
      local_98 = 0x4b;
      local_b8[0] = 0;
      local_99 = 0x1f;
      pcVar6 = (char *)FUN_140056c90(local_b8,0x13);
      builtin_strncpy(pcVar6,"IPC not initialized",0x14);
      if (local_99 < 0x40) {
        local_99 = 0xc;
      }
      else {
        local_a8 = 0x13;
      }
      FUN_1400afc40(local_90,local_b8);
                    /* WARNING: Subroutine does not return */
      FUN_1403d92fc(local_90,&DAT_1407230a8);
    }
    *(undefined1 *)((longlong)param_4 + 0x14) = 0;
    iVar1 = *(int *)(param_1 + 0x1c);
    if (iVar1 == 0) {
      lVar4 = 0;
    }
    else {
      lVar4 = FUN_140128b30();
    }
    cVar3 = (**(code **)(**(longlong **)(param_1 + 0x10) + 0x48))
                      (*(undefined8 *)(param_1 + 0x10),param_2,param_3,
                       *(undefined4 *)(param_1 + 0x1c));
    if (((cVar3 == '\0') && (iVar1 != 0)) &&
       (lVar5 = FUN_140128b30(),
       (double)*(uint *)(param_1 + 0x1c) <=
       ((double)(ulonglong)(lVar5 - lVar4) * _DAT_1407515e0) / 1000000.0)) {
      *(undefined1 *)((longlong)param_4 + 0x14) = 1;
    }
  }
  else {
    *(undefined1 *)((longlong)param_4 + 0x14) = 0;
    uVar7 = 0;
    local_res8[0] = 0;
    iVar1 = *(int *)(param_1 + 0x1c);
    dVar2 = (double)FUN_1400dcad0();
    dVar2 = dVar2 + (double)((float)*(uint *)(param_1 + 0x1c) / 1000.0);
    uVar8 = param_3;
    if (param_3 != 0) {
      do {
        if ((iVar1 != 0) &&
           (FUN_1400dcad0(),
           dVar2 <= (double)CONCAT44(extraout_XMM0_Db,extraout_XMM0_Da) &&
           (double)CONCAT44(extraout_XMM0_Db,extraout_XMM0_Da) != dVar2)) {
          local_res8[0] = -0x7ffffff8;
          *(undefined1 *)((longlong)param_4 + 0x14) = 1;
          goto LAB_1400c88fa;
        }
        uVar9 = 0x10000;
        if (uVar8 < 0x10000) {
          uVar9 = uVar8;
        }
        lVar4 = FUN_1400f8f40(*(undefined8 *)(param_1 + 8),param_2,uVar9,local_res8);
        if (local_res8[0] != 0) goto LAB_1400c88fa;
        if (lVar4 == 0) {
          FUN_1400dcdf0();
        }
        else {
          param_2 = param_2 + lVar4;
          uVar7 = uVar7 + lVar4;
          uVar8 = uVar8 - lVar4;
        }
      } while (uVar7 < param_3);
    }
    if ((local_res8[0] == 0) && (uVar7 == param_3)) {
      cVar3 = '\x01';
    }
    else {
LAB_1400c88fa:
      cVar3 = '\0';
      *(int *)(param_4 + 2) = local_res8[0];
      *param_4 = uVar7;
      param_4[1] = param_3;
    }
  }
  return cVar3;
}
```
