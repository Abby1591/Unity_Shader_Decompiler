# Compiler backends

Ghidra decompilation of `UnityShaderCompiler.exe` (image base `0x140000000`).
Function names and leading comments are the annotations recorded in the Ghidra
database; the bodies are otherwise unedited decompiler output. See
[`shader_compiler_analysis.md`](../shader_compiler_analysis.md) for the prose
description of the same pipeline.

## `InvokeGraphicsFxcCompilePlugin` — `0x140006e80`

plugin slot `+0x28`: FXC graphics compile

```c
/* Compiler-plugin slot +0x28 (graphics compile, FXC). Loads the compiler library and forwards to
   ProcessGraphicsFxcCompile. */

void InvokeGraphicsFxcCompilePlugin(undefined8 param_1,undefined8 param_2)

{
  char cVar1;
  
  cVar1 = CheckForceDxcOnSwitch(4,param_2,0);
  if (cVar1 != '\0') {
    FUN_140110570(param_2,0);
    return;
  }
  ProcessGraphicsFxcCompile(param_2);
  return;
}
```

## `InvokeComputeFxcCompilePlugin` — `0x140006f90`

plugin slot `+0x38`: FXC compute compile

```c
/* Compiler-plugin slot +0x38 (compute compile, FXC). Forwards to ProcessComputeFxcCompile. */

longlong InvokeComputeFxcCompilePlugin(undefined8 param_1,longlong param_2)

{
  char cVar1;
  longlong lVar2;
  longlong lVar3;
  undefined8 uVar4;
  undefined8 local_98;
  undefined2 local_90;
  undefined8 local_88;
  undefined8 local_80;
  undefined8 local_78;
  undefined2 local_70;
  undefined8 local_68;
  undefined8 uStack_60;
  undefined8 local_58;
  undefined2 local_50;
  undefined8 local_48;
  undefined8 uStack_40;
  undefined8 local_38;
  undefined2 local_30;
  undefined8 local_28;
  undefined8 uStack_20;
  undefined8 local_18;
  undefined1 local_10;
  
  cVar1 = CheckForceDxcOnSwitch(4,param_2,0);
  if (cVar1 == '\0') {
    lVar3 = FUN_1400e40a0(0xa0);
    lVar2 = 0;
    if (lVar3 != 0) {
      lVar2 = FUN_140015e50(lVar3,*(undefined4 *)(param_2 + 0x20),1);
    }
    local_78 = 0;
    local_70 = 0x4d;
    local_68 = 0;
    uStack_60 = 1;
    local_58 = 0;
    local_50 = 0x4d;
    local_48 = 0;
    uStack_40 = 1;
    local_38 = 0;
    local_30 = 0x4d;
    local_28 = 0;
    uStack_20 = 1;
    local_18 = 0;
    local_10 = 1;
    local_98 = 0;
    local_90 = 0x4d;
    local_88 = 0;
    local_80 = 1;
    uVar4 = (**(code **)*DAT_14074ece0)();
    ProcessComputeFxcCompile(uVar4,param_2,&local_78,&local_58,lVar2 + 0x90);
    FUN_1400c9550(&local_78,lVar2 + 0x40);
    FUN_140017b90(&local_98);
    FUN_140018440(&local_38);
    FUN_1400180d0(&local_58);
    FUN_140017e00(&local_78);
  }
  else {
    lVar2 = FUN_140110570(param_2,1);
  }
  return lVar2;
}
```

## `InvokeBytecodeDisassemblePlugin` — `0x140006ec0`

plugin slot `+0x30`: bytecode disassemble

```c
/* Compiler-plugin slot +0x30 (disassemble). Forwards to ProcessDxbcDisassemble. */

void InvokeBytecodeDisassemblePlugin(undefined8 param_1,longlong *param_2)

{
  int *piVar1;
  char cVar2;
  char *pcVar3;
  ulonglong uVar4;
  uint *puVar5;
  uint uVar6;
  ulonglong uVar7;
  ulonglong uVar8;
  
  pcVar3 = (char *)(**(code **)(*param_2 + 0x40))(param_2);
  uVar4 = (**(code **)(*param_2 + 0x48))(param_2);
  if ((pcVar3 != (char *)0x0) && (uVar4 != 0)) {
    cVar2 = *pcVar3;
    uVar7 = 0;
    if (cVar2 == '\0') {
      uVar8 = 1;
    }
    else if (cVar2 == '\x01') {
      uVar8 = 6;
    }
    else {
      uVar8 = uVar7;
      if (cVar2 == '\x02') {
        uVar8 = 0x26;
      }
    }
    piVar1 = (int *)(pcVar3 + uVar8);
    if ((uVar8 + 4 < uVar4) && (*piVar1 == 0x43425844)) {
      if (piVar1[7] != 0) {
        puVar5 = (uint *)(piVar1 + 8);
        do {
          if (uVar4 - uVar8 <= (ulonglong)*puVar5) break;
          if (*(int *)((ulonglong)*puVar5 + (longlong)piVar1) == 0x4c495844) {
            FUN_14010f9f0(param_2);
            return;
          }
          uVar6 = (int)uVar7 + 1;
          uVar7 = (ulonglong)uVar6;
          puVar5 = puVar5 + 1;
        } while (uVar6 < (uint)piVar1[7]);
      }
    }
  }
  ProcessDxbcDisassemble(param_2);
  return;
}
```

## `InvokeGraphicsDxcCompilePlugin` — `0x1400070f0`

plugin slot `+0x40`: DXC graphics compile

```c
/* Compiler-plugin slot +0x40 (graphics compile, DXC). Forwards to ProcessGraphicsDxcCompile. */

void InvokeGraphicsDxcCompilePlugin(undefined8 param_1,undefined8 param_2)

{
  FUN_140039430(param_2);
  return;
}
```

## `FUN_140039430` — `0x140039430`

DXC compile thunk

```c
longlong FUN_140039430(longlong param_1)

{
  longlong lVar1;
  longlong lVar2;
  undefined8 uVar3;
  code *pcVar4;
  ulonglong uVar5;
  undefined8 in_stack_fffffffffffffdc0;
  undefined4 uVar6;
  undefined8 local_228;
  undefined2 local_220;
  undefined8 local_218;
  undefined8 local_210;
  undefined1 local_208 [384];
  undefined1 local_88;
  undefined8 local_80;
  undefined2 local_78;
  undefined8 local_70;
  undefined8 local_68;
  undefined8 local_60;
  undefined8 local_58;
  undefined2 local_50;
  undefined8 local_48;
  undefined8 local_40;
  undefined4 local_38;
  undefined8 local_30;
  undefined4 local_28;
  undefined1 local_24;
  
  uVar6 = (undefined4)((ulonglong)in_stack_fffffffffffffdc0 >> 0x20);
  lVar1 = FUN_1400e40a0(0xa0);
  lVar2 = 0;
  if (lVar1 != 0) {
    lVar2 = FUN_140015e50(lVar1,*(undefined4 *)(param_1 + 0x20),1);
  }
  local_228 = 0;
  local_220 = 0x19;
  local_218 = 0;
  local_210 = 1;
  pcVar4 = FUN_1400194a0;
  _eh_vector_constructor_iterator_
            (local_208,0xc0,2,(_func_void_void_ptr *)&LAB_140015b80,FUN_1400194a0);
  local_88 = 0;
  local_80 = 0;
  local_78 = 0x19;
  local_70 = 0;
  local_68 = 1;
  local_60 = 0;
  local_58 = 0;
  local_50 = 0x19;
  local_48 = 0;
  local_40 = 1;
  local_38 = 0;
  local_30 = 0;
  local_28 = 1;
  local_24 = 1;
  uVar5 = CONCAT71((int7)((ulonglong)pcVar4 >> 8),
                   (char)((uint)*(undefined4 *)(param_1 + 0x38) >> 0x18)) & 0xffffffffffffff01;
  ProcessGraphicsDxcCompile(param_1,&local_228,lVar2 + 0x90,1,uVar5);
  *(undefined4 *)(lVar2 + 0x60) = 0x1f;
  if ((*(ulonglong *)(lVar2 + 0x58) & 0xfffffffffffffffe) < 0x1000) {
    if ((~*(byte *)(lVar2 + 0x58) & 1) == 0) {
      uVar3 = FUN_1400e4280(0x800,1,*(undefined2 *)(lVar2 + 0x48),0,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\Allocators.h"
                            ,CONCAT44(uVar6,0x9c));
      FUN_140558820(uVar3,*(undefined8 *)(lVar2 + 0x40),*(undefined8 *)(lVar2 + 0x50));
      *(undefined8 *)(lVar2 + 0x58) = 0x1000;
      *(undefined8 *)(lVar2 + 0x40) = uVar3;
    }
    else {
      *(undefined8 *)(lVar2 + 0x58) = 0x1000;
      uVar3 = FUN_1400e42a0(*(undefined8 *)(lVar2 + 0x40),0x800,1,*(undefined2 *)(lVar2 + 0x48),
                            uVar5 & 0xffffffff00000000,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\Allocators.h"
                            ,0xa3);
      *(undefined8 *)(lVar2 + 0x40) = uVar3;
    }
  }
  FUN_1400ed400(&local_228,lVar2 + 0x40);
  FUN_140017b90(&local_58);
  FUN_140017b90(&local_80);
  _eh_vector_destructor_iterator_(local_208,0xc0,2,FUN_1400194a0);
  FUN_1400186e0(&local_228);
  return lVar2;
}
```

## `ProcessGraphicsFxcCompile` — `0x1400317e0`

FXC graphics: compile, reflect, strip

```c
/* FXC graphics compile. D3DCompile through the wrapper vtable (+0x18); when reflection was
   requested ProcessFxcReflectionAndValidate extracts signatures/cbuffers/resources; then
   D3DStripShader (+0x40) runs with flags (skipReflection ? 6 : 7). 7 = strip RDEF/DEBUG/TESTBLOBS,
   6 = keep RDEF. */

longlong ProcessGraphicsFxcCompile(longlong *param_1)

{
  undefined2 uVar1;
  bool bVar2;
  byte bVar3;
  undefined8 *puVar4;
  undefined1 uVar5;
  char cVar6;
  byte bVar7;
  undefined4 uVar8;
  uint uVar9;
  int iVar10;
  longlong lVar11;
  longlong *plVar12;
  undefined8 *puVar13;
  ulonglong uVar14;
  longlong lVar15;
  char *pcVar16;
  undefined8 uVar17;
  undefined8 uVar18;
  longlong lVar19;
  code *pcVar20;
  longlong lVar21;
  ulonglong uVar22;
  undefined1 *puVar23;
  undefined8 *******pppppppuVar24;
  uint uVar25;
  longlong lVar26;
  undefined1 *puVar27;
  longlong lVar28;
  longlong lVar29;
  byte bVar30;
  ulonglong uVar31;
  byte bVar32;
  byte bVar33;
  byte local_res18;
  ulonglong in_stack_fffffffffffffca8;
  undefined8 *puVar34;
  undefined8 in_stack_fffffffffffffcb0;
  undefined8 in_stack_fffffffffffffcb8;
  undefined4 uVar35;
  undefined8 in_stack_fffffffffffffcc0;
  undefined1 local_2f0;
  undefined7 uStack_2ef;
  longlong local_2e0;
  byte local_2d1;
  undefined2 local_2d0;
  undefined1 local_2c8;
  undefined7 uStack_2c7;
  longlong local_2b8;
  byte local_2a9;
  undefined2 local_2a8;
  undefined8 *local_2a0;
  char *local_298;
  ulonglong local_290;
  longlong *local_288;
  code *local_280;
  undefined1 local_278;
  undefined7 uStack_277;
  byte local_259;
  undefined2 local_258;
  longlong *local_250;
  longlong local_248;
  longlong local_240;
  longlong local_238;
  undefined2 local_230;
  ulonglong local_228;
  ulonglong local_220;
  longlong local_218;
  undefined2 local_210;
  ulonglong local_208;
  ulonglong local_200;
  longlong *local_1f8;
  undefined8 *local_1f0;
  undefined8 *local_1e8;
  undefined1 *local_1e0;
  ulonglong local_1d8;
  undefined1 local_1d0;
  undefined7 uStack_1cf;
  ulonglong local_1c0;
  byte local_1b1;
  undefined2 local_1b0;
  longlong local_1a8;
  longlong lStack_1a0;
  longlong local_198;
  undefined8 ******local_190 [2];
  longlong local_180;
  byte local_171;
  undefined2 uStack_170;
  undefined1 local_168;
  undefined7 uStack_167;
  longlong local_158;
  byte local_149;
  undefined2 local_148;
  longlong local_140;
  undefined2 local_138;
  ulonglong local_130;
  undefined8 local_128;
  undefined1 local_120;
  undefined7 uStack_11f;
  byte local_101;
  undefined2 local_100;
  undefined4 *local_f8;
  undefined8 local_f0;
  undefined4 local_e8;
  undefined2 local_e2;
  undefined4 *local_e0;
  undefined8 local_d8;
  undefined4 local_d0;
  undefined2 local_ca;
  undefined8 local_c8;
  undefined2 local_c0;
  longlong local_b8;
  undefined8 local_b0;
  undefined8 local_a8;
  undefined2 local_a0;
  undefined8 local_98;
  undefined8 local_90;
  undefined8 local_88;
  undefined2 local_80;
  undefined8 local_78;
  undefined8 local_70;
  undefined8 local_68;
  undefined2 local_60;
  undefined8 local_58;
  undefined8 local_50;
  undefined1 local_48 [16];
  
  lVar11 = FUN_14003a000();
  plVar12 = (longlong *)(**(code **)*DAT_14074ece0)();
  uVar5 = (**(code **)(*plVar12 + 0x10))(plVar12);
  puVar13 = (undefined8 *)(**(code **)*DAT_14074ece0)();
  cVar6 = (**(code **)*puVar13)(puVar13);
  uVar8 = (undefined4)(in_stack_fffffffffffffca8 >> 0x20);
  if (cVar6 == '\0') {
    lVar26 = param_1[4];
    lVar15 = param_1[2];
    local_258 = 0x4b;
    local_278 = 0;
    local_259 = 0x1f;
    FUN_140054780(&local_278,"D3D shader compiler could not be loaded",0x27);
    FUN_140089820(lVar11 + 0x90,&local_278,(int)lVar15,0,CONCAT44(uVar8,(int)lVar26));
    if ((local_259 & 0xc0) != 0x40) {
      return lVar11;
    }
    uVar17 = CONCAT71(uStack_277,local_278);
    uVar1 = local_258;
    goto LAB_140033247;
  }
  uVar14 = (**(code **)(*param_1 + 0x50))(param_1);
  uVar31 = 0;
  local_250 = (longlong *)0x0;
  local_288 = (longlong *)0x0;
  local_1f8 = (longlong *)0x0;
  if (((((int)param_1[4] == 9) || ((int)param_1[4] == 0xf)) || ((int)param_1[4] == 0xe)) ||
     (((int)param_1[4] == 0x12 || (bVar3 = 0, (int)param_1[4] == 0x1a)))) {
    bVar3 = 1;
  }
  bVar7 = *(byte *)(param_1 + 7) >> 2 & 1;
  local_280 = (code *)((ulonglong)(byte)((uint)(int)param_1[7] >> 0x1a) & 0xffffffffffffff01);
  local_100 = 0x4b;
  local_120 = 0;
  local_101 = 0x1f;
  lVar15 = (longlong)*(int *)((longlong)param_1 + 0x14);
  lVar26 = -1;
  lVar28 = -1;
  if ((param_1[5] & 0xffffffffffffe000U) == 0) {
    do {
      lVar28 = lVar28 + 1;
    } while ((&PTR_s_vs_4_0_1407260f0)[lVar15][lVar28] != '\0');
    FUN_140054780(&local_120);
    uVar22 = 0x1fff;
    uVar8 = *(undefined4 *)(&DAT_140726128 + lVar15 * 4);
  }
  else {
    do {
      lVar28 = lVar28 + 1;
    } while ((&PTR_s_vs_5_0_140726148)[lVar15][lVar28] != '\0');
    FUN_140054780(&local_120);
    uVar22 = 0x13ffff;
    uVar8 = *(undefined4 *)(&DAT_140726180 + lVar15 * 4);
  }
  *(undefined4 *)(lVar11 + 0x60) = uVar8;
  local_140 = 0;
  local_138 = 0x4d;
  local_130 = 0;
  local_128 = 1;
  if ((*(uint *)(param_1 + 7) >> 0xf & 1) == 0) {
    SetCompilerAvailabilityMacros(uVar22 | param_1[5],&local_140);
  }
  local_1b0 = 1;
  local_1d0 = 0;
  local_1b1 = 0x1f;
  uVar22 = (ulonglong)_tls_index;
  if ((*(int *)(*(longlong *)((longlong)ThreadLocalStoragePointer + uVar22 * 8) + 0x1c) <
       DAT_14074aa60) && (FUN_1403d6258(&DAT_14074aa60), DAT_14074aa60 == -1)) {
    atexit(FUN_140574a20);
    _Init_thread_footer(&DAT_14074aa60);
  }
  if ((*(int *)(*(longlong *)((longlong)ThreadLocalStoragePointer + uVar22 * 8) + 0x1c) <
       DAT_14074aa64) && (FUN_1403d6258(&DAT_14074aa64), uVar22 = uVar31, DAT_14074aa64 == -1)) {
    do {
      if ((&DAT_140578fc4)[uVar22] == '\0') goto LAB_1400332e8;
      uVar22 = uVar22 + 1;
    } while (uVar22 < 2);
    uVar22 = 2;
LAB_1400332e8:
    DAT_1407261e8 = uVar22;
    atexit((_func_5014 *)&DAT_140574ad0);
    _Init_thread_footer(&DAT_14074aa64);
  }
  local_68 = 0;
  local_60 = 0x4d;
  local_58 = 0;
  local_50 = 1;
  local_f8 = &DAT_14058aa4c;
  local_f0 = 0;
  local_e8 = 0;
  local_e2 = 1;
  local_e0 = &DAT_14058aa4c;
  local_d8 = 0;
  local_d0 = 0;
  local_ca = 1;
  local_c8 = 0;
  local_c0 = 0x4d;
  local_b8 = 0;
  local_b0 = 1;
  local_a8 = 0;
  local_a0 = 0x4d;
  local_98 = 0;
  local_90 = 1;
  local_218 = 0;
  local_210 = 0x4d;
  local_208 = 0;
  local_200 = 1;
  local_238 = 0;
  local_230 = 0x4d;
  local_228 = 0;
  local_220 = 1;
  if (local_130 + uVar14 != 0) {
    FUN_140058450(&local_238);
  }
  if (uVar14 != 0) {
    do {
      lVar15 = (**(code **)(*param_1 + 0x68))(param_1,uVar31);
      pcVar16 = (char *)(**(code **)(*param_1 + 0x58))(param_1,uVar31);
      uVar22 = local_228 + 1;
      if (local_220 >> 1 < uVar22) {
        FUN_140057330(&local_238);
      }
      local_2a0 = (undefined8 *)(uVar22 * 0x50 + local_238 + -0x50);
      local_228 = uVar22;
      local_1e8 = local_2a0;
      if (local_2a0 != (undefined8 *)0x0) {
        local_240 = -1;
        do {
          local_240 = local_240 + 1;
        } while (*(char *)(lVar15 + local_240) != '\0');
        local_290 = 0xffffffffffffffff;
        do {
          local_290 = local_290 + 1;
        } while (pcVar16[local_290] != '\0');
        local_298 = pcVar16;
        local_248 = lVar15;
        FUN_140015c20(local_2a0,&local_298,&local_248);
      }
      uVar31 = uVar31 + 1;
    } while (uVar31 < uVar14);
  }
  uVar8 = (undefined4)((ulonglong)in_stack_fffffffffffffcb0 >> 0x20);
  uVar35 = (undefined4)((ulonglong)in_stack_fffffffffffffcb8 >> 0x20);
  uVar31 = 0;
  uVar14 = uVar31;
  if (local_130 != 0) {
    do {
      lVar15 = local_140 + uVar14;
      uVar22 = local_228 + 1;
      if (local_220 >> 1 < uVar22) {
        FUN_140057330(&local_238);
      }
      puVar13 = (undefined8 *)(local_238 + -0x50 + uVar22 * 0x50);
      local_228 = uVar22;
      local_1f0 = puVar13;
      local_1e8 = puVar13;
      if (puVar13 != (undefined8 *)0x0) {
        FUN_1400149f0(puVar13,lVar15);
        FUN_1400149f0(puVar13 + 5,lVar15 + 0x28);
      }
      uVar8 = (undefined4)((ulonglong)in_stack_fffffffffffffcb0 >> 0x20);
      uVar35 = (undefined4)((ulonglong)in_stack_fffffffffffffcb8 >> 0x20);
      uVar31 = uVar31 + 1;
      uVar14 = uVar14 + 0x50;
    } while (uVar31 < local_130);
  }
  uVar31 = 0;
  uVar14 = (**(code **)(*param_1 + 0x78))(param_1);
  if (local_200 >> 1 < uVar14) {
    if ((~(byte)local_200 & 1) == 0) {
      if (uVar14 == 0) {
        lVar15 = 0;
      }
      else {
        lVar15 = FUN_1400e4280(uVar14 * 0x50,8,local_210,0,
                               "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\Allocators.h"
                               ,CONCAT44(uVar8,0x9c));
      }
      FUN_140558820(lVar15,local_218,local_208 * 0x50);
      local_200 = uVar14 * 2;
      local_218 = lVar15;
    }
    else {
      local_200 = uVar14 * 2;
      local_218 = FUN_1400e42a0(local_218,uVar14 * 0x50,8,local_210,
                                in_stack_fffffffffffffca8 & 0xffffffff00000000,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\Allocators.h"
                                ,CONCAT44(uVar35,0xa3));
    }
  }
  uVar8 = (undefined4)((ulonglong)in_stack_fffffffffffffcc0 >> 0x20);
  if (uVar14 != 0) {
    do {
      lVar15 = (**(code **)(*param_1 + 0x90))(param_1,uVar31);
      pcVar16 = (char *)(**(code **)(*param_1 + 0x80))(param_1,uVar31);
      uVar22 = local_208 + 1;
      if (local_200 >> 1 < uVar22) {
        FUN_140057330(&local_218);
      }
      puVar13 = (undefined8 *)(local_218 + -0x50 + uVar22 * 0x50);
      local_208 = uVar22;
      local_1f0 = puVar13;
      local_1e8 = puVar13;
      if (puVar13 != (undefined8 *)0x0) {
        local_240 = -1;
        do {
          local_240 = local_240 + 1;
        } while (*(char *)(lVar15 + local_240) != '\0');
        local_290 = 0xffffffffffffffff;
        do {
          local_290 = local_290 + 1;
        } while (pcVar16[local_290] != '\0');
        local_298 = pcVar16;
        local_248 = lVar15;
        FUN_140014b30(puVar13,&local_298,0x4b);
        FUN_140014b30(puVar13 + 5,&local_248,0x4b);
      }
      uVar8 = (undefined4)((ulonglong)in_stack_fffffffffffffcc0 >> 0x20);
      uVar31 = uVar31 + 1;
    } while (uVar31 < uVar14);
  }
  uVar14 = 0;
  local_88 = 0;
  local_80 = 0x4d;
  local_78 = 0;
  local_70 = 1;
  uVar9 = ((char)param_1[0xb] != '\0') + 0x30;
  uVar25 = uVar9 | 0x80;
  if (*(char *)((longlong)param_1 + 0x59) == '\0') {
    uVar25 = uVar9;
  }
  local_2a0 = (undefined8 *)CONCAT44(local_2a0._4_4_,uVar25);
  plVar12 = (longlong *)FUN_1400bf630(&local_1a8,(int)param_1[4]);
  uVar31 = local_228 + 1;
  if (local_220 >> 1 < uVar31) {
    FUN_140057330(&local_238);
  }
  puVar13 = (undefined8 *)(local_238 + -0x50 + uVar31 * 0x50);
  local_228 = uVar31;
  local_1f0 = puVar13;
  local_1e8 = puVar13;
  if (puVar13 != (undefined8 *)0x0) {
    local_1e0 = PTR_DAT_1407261e0;
    local_1d8 = DAT_1407261e8;
    local_298 = (char *)*plVar12;
    local_290 = plVar12[1];
    FUN_140014b30(puVar13,&local_298,0x4b);
    FUN_140014b30(puVar13 + 5,&local_1e0,0x4b);
  }
  lVar15 = (**(code **)(*param_1 + 8))(param_1);
  uVar17 = (**(code **)*param_1)(param_1);
  local_148 = 0x4b;
  local_168 = 0;
  local_149 = 0x1f;
  lVar28 = FUN_140056c90(&local_168,lVar15);
  FUN_140558820(lVar28,uVar17,lVar15);
  *(undefined1 *)(lVar28 + lVar15) = 0;
  if (local_149 < 0x40) {
    local_149 = 0x1f - (char)lVar15;
    lVar15 = local_158;
  }
  local_158 = lVar15;
  uVar17 = (**(code **)(*param_1 + 0x38))(param_1);
  puVar13 = &local_68;
  puVar27 = &local_1d0;
  ProcessShaderPreprocessor
            (&local_168,param_1[10],uVar17,&local_218,&local_238,&local_88,&DAT_1407261b8,
             CONCAT44(uVar8,local_2a0._0_4_),puVar27,puVar13,&local_f8,&local_c8,&local_a8,local_48,
             0);
  uVar8 = (undefined4)((ulonglong)puVar27 >> 0x20);
  ProcessPreprocessorPragmaState(&local_c8,&local_a8,lVar11 + 0x90);
  if ((char)param_1[0xb] == '\0') {
    if (local_b8 == 0) {
      local_2a0 = (undefined8 *)FUN_1400e40a0(0x10);
      *local_2a0 = 0;
      local_2a0[1] = 0;
      uVar25 = 0x5004;
      if ((char)local_280 == '\0') {
        uVar25 = 0x1000;
      }
      if (bVar7 != 0) {
        plVar12 = (longlong *)(**(code **)*DAT_14074ece0)();
        (**(code **)(*plVar12 + 8))(plVar12,1);
        uVar25 = uVar25 | 5;
        local_1d8 = uVar14;
        do {
          if ((&DAT_140579a98)[local_1d8] == '\0') goto LAB_14003216a;
          local_1d8 = local_1d8 + 1;
        } while (local_1d8 < 8);
        local_1d8 = 8;
LAB_14003216a:
        local_1e0 = &DAT_140579a98;
        local_290 = uVar14;
        do {
          if ("#line"[local_290] == '\0') goto LAB_140032196;
          local_290 = local_290 + 1;
        } while (local_290 < 6);
        local_290 = 6;
LAB_140032196:
        local_298 = "#line";
        FUN_1400e22b0(&local_1d0,&local_298,&local_1e0,0);
      }
      plVar12 = (longlong *)(**(code **)*DAT_14074ece0)();
      local_280 = *(code **)(*plVar12 + 0x18);
      puVar27 = &local_120;
      if (0x3f < local_101) {
        puVar27 = (undefined1 *)CONCAT71(uStack_11f,local_120);
      }
      uVar17 = (**(code **)(*param_1 + 0x20))(param_1);
      puVar4 = local_2a0;
      if (local_1b1 < 0x40) {
        local_1c0 = 0x1f - (longlong)(char)local_1b1;
      }
      puVar23 = &local_1d0;
      if (0x3f < local_1b1) {
        puVar23 = (undefined1 *)CONCAT71(uStack_1cf,local_1d0);
      }
      uVar35 = 0;
      puVar34 = local_2a0;
      iVar10 = (*local_280)(plVar12,puVar23,local_1c0,&DAT_140578094,local_2a0,0,uVar17,puVar27,
                            CONCAT44(uVar8,uVar25),(ulonglong)puVar13 & 0xffffffff00000000,
                            &local_250,&local_288);
      uVar8 = (undefined4)((ulonglong)puVar34 >> 0x20);
      thunk_FUN_1403f2404(puVar4);
      local_1a8 = 0;
      lStack_1a0 = 0;
      local_198 = 0;
      local_2a0 = (undefined8 *)((ulonglong)local_2a0 & 0xffffffff00000000);
      if ((iVar10 < 0) || (local_250 == (longlong *)0x0)) {
        local_258 = 0x4b;
        local_278 = 0;
        local_259 = 0x1f;
        if (local_288 == (longlong *)0x0) {
          bVar2 = true;
        }
        else {
          uVar17 = (**(code **)(*local_288 + 0x20))();
          uVar18 = (**(code **)(*local_288 + 0x18))();
          FUN_140014bc0(local_190,uVar18,uVar17,0x4b);
          lVar15 = param_1[4];
          lVar28 = param_1[2];
          lVar19 = (**(code **)(*param_1 + 0x20))(param_1);
          local_2d0 = 0x4b;
          local_2f0 = 0;
          local_2d1 = 0x1f;
          lVar29 = -1;
          do {
            lVar29 = lVar29 + 1;
          } while (*(char *)(lVar19 + lVar29) != '\0');
          FUN_140054780(&local_2f0,lVar19);
          local_2a8 = 0x4b;
          local_2c8 = 0;
          local_2a9 = 0x1f;
          puVar13 = (undefined8 *)FUN_140056c90(&local_2c8,0xf);
          *puVar13 = 0x6c61746166203a29;
          *(undefined4 *)(puVar13 + 1) = 0x72726520;
          *(undefined2 *)((longlong)puVar13 + 0xc) = 0x726f;
          *(undefined1 *)((longlong)puVar13 + 0xe) = 0x20;
          *(undefined1 *)((longlong)puVar13 + 0xf) = 0;
          if (local_2a9 < 0x40) {
            local_2a9 = 0x10;
          }
          else {
            local_2b8 = 0xf;
          }
          uVar18 = CONCAT44(uVar35,(int)lVar15);
          uVar17 = CONCAT44(uVar8,(int)lVar28);
          FUN_1400c1f10(local_190,0,&local_2c8,&local_2f0,uVar17,uVar18,lVar11 + 0x90);
          uVar8 = (undefined4)((ulonglong)uVar17 >> 0x20);
          uVar35 = (undefined4)((ulonglong)uVar18 >> 0x20);
          if ((local_2a9 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_2c7,local_2c8),local_2a8,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          if ((local_2d1 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_2ef,local_2f0),local_2d0,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          lVar15 = param_1[4];
          lVar28 = param_1[2];
          lVar29 = (**(code **)(*param_1 + 0x20))(param_1);
          local_2d0 = 0x4b;
          lVar19 = -1;
          do {
            lVar19 = lVar19 + 1;
          } while (*(char *)(lVar29 + lVar19) != '\0');
          local_2f0 = 0;
          local_2d1 = 0x1f;
          lVar21 = FUN_140056c90(&local_2f0,lVar19);
          FUN_140558820(lVar21,lVar29,lVar19);
          *(undefined1 *)(lVar21 + lVar19) = 0;
          if (local_2d1 < 0x40) {
            local_2d1 = 0x1f - (char)lVar19;
            lVar19 = local_2e0;
          }
          local_2e0 = lVar19;
          local_2a8 = 0x4b;
          local_2c8 = 0;
          local_2a9 = 0x1f;
          puVar13 = (undefined8 *)FUN_140056c90(&local_2c8,9);
          *puVar13 = 0x726f727265203a29;
          *(undefined1 *)(puVar13 + 1) = 0x20;
          *(undefined1 *)((longlong)puVar13 + 9) = 0;
          if (local_2a9 < 0x40) {
            local_2a9 = 0x16;
          }
          else {
            local_2b8 = 9;
          }
          uVar18 = CONCAT44(uVar35,(int)lVar15);
          uVar17 = CONCAT44(uVar8,(int)lVar28);
          FUN_1400c1f10(local_190,0,&local_2c8,&local_2f0,uVar17,uVar18,lVar11 + 0x90);
          uVar8 = (undefined4)((ulonglong)uVar17 >> 0x20);
          uVar35 = (undefined4)((ulonglong)uVar18 >> 0x20);
          if ((local_2a9 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_2c7,local_2c8),local_2a8,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          if ((local_2d1 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_2ef,local_2f0),local_2d0,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          lVar15 = param_1[4];
          lVar28 = param_1[2];
          lVar29 = (**(code **)(*param_1 + 0x20))(param_1);
          local_2a8 = 0x4b;
          lVar19 = -1;
          do {
            lVar19 = lVar19 + 1;
          } while (*(char *)(lVar29 + lVar19) != '\0');
          local_2c8 = 0;
          local_2a9 = 0x1f;
          lVar21 = FUN_140056c90(&local_2c8,lVar19);
          FUN_140558820(lVar21,lVar29,lVar19);
          *(undefined1 *)(lVar21 + lVar19) = 0;
          if (local_2a9 < 0x40) {
            local_2a9 = 0x1f - (char)lVar19;
            lVar19 = local_2b8;
          }
          local_2b8 = lVar19;
          local_2d0 = 0x4b;
          local_2f0 = 0;
          local_2d1 = 0x1f;
          puVar13 = (undefined8 *)FUN_140056c90(&local_2f0,10);
          *puVar13 = 0x726f727265203a29;
          *(undefined2 *)(puVar13 + 1) = 0x203a;
          *(undefined1 *)((longlong)puVar13 + 10) = 0;
          if (local_2d1 < 0x40) {
            local_2d1 = 0x15;
          }
          else {
            local_2e0 = 10;
          }
          uVar18 = CONCAT44(uVar35,(int)lVar15);
          uVar17 = CONCAT44(uVar8,(int)lVar28);
          FUN_1400c1f10(local_190,0,&local_2f0,&local_2c8,uVar17,uVar18,lVar11 + 0x90);
          uVar8 = (undefined4)((ulonglong)uVar17 >> 0x20);
          uVar35 = (undefined4)((ulonglong)uVar18 >> 0x20);
          if ((local_2d1 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_2ef,local_2f0),local_2d0,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          if ((local_2a9 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_2c7,local_2c8),local_2a8,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          lVar15 = param_1[4];
          lVar28 = param_1[2];
          lVar19 = (**(code **)(*param_1 + 0x20))(param_1);
          local_2a8 = 0x4b;
          local_2c8 = 0;
          local_2a9 = 0x1f;
          lVar29 = -1;
          do {
            lVar29 = lVar29 + 1;
          } while (*(char *)(lVar19 + lVar29) != '\0');
          FUN_140054780(&local_2c8,lVar19);
          local_2d0 = 0x4b;
          local_2f0 = 0;
          local_2d1 = 0x1f;
          FUN_140054780(&local_2f0,"): warning ",0xb);
          uVar17 = CONCAT44(uVar8,(int)lVar28);
          FUN_1400c1f10(local_190,1,&local_2f0,&local_2c8,uVar17,CONCAT44(uVar35,(int)lVar15),
                        lVar11 + 0x90);
          uVar8 = (undefined4)((ulonglong)uVar17 >> 0x20);
          if ((local_2d1 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_2ef,local_2f0),local_2d0,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          if ((local_2a9 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_2c7,local_2c8),local_2a8,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          lVar15 = param_1[4];
          lVar28 = param_1[2];
          lVar19 = (**(code **)(*param_1 + 0x20))(param_1);
          local_2a8 = 0x4b;
          local_2c8 = 0;
          local_2a9 = 0x1f;
          lVar29 = -1;
          do {
            lVar29 = lVar29 + 1;
          } while (*(char *)(lVar19 + lVar29) != '\0');
          FUN_140054780(&local_2c8,lVar19);
          local_2d0 = 0x4b;
          local_2f0 = 0;
          local_2d1 = 0x1f;
          FUN_140054780(&local_2f0,"error ",6);
          uVar17 = CONCAT44(uVar8,(int)lVar15);
          FUN_1400c3490(local_190,&local_2f0,&local_2c8,(int)lVar28,uVar17,lVar11 + 0x90);
          uVar8 = (undefined4)((ulonglong)uVar17 >> 0x20);
          if ((local_2d1 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_2ef,local_2f0),local_2d0,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          if ((local_2a9 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_2c7,local_2c8),local_2a8,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          pppppppuVar24 = (undefined8 *******)local_190[0];
          if (local_171 < 0x40) {
            local_180 = 0x1f - (longlong)(char)local_171;
            pppppppuVar24 = local_190;
          }
          FUN_140054780(&local_278,pppppppuVar24,local_180);
          lVar15 = param_1[4];
          lVar28 = param_1[2];
          lVar29 = (**(code **)(*param_1 + 0x20))(param_1);
          local_2a8 = 0x4b;
          lVar19 = -1;
          do {
            lVar19 = lVar19 + 1;
          } while (*(char *)(lVar29 + lVar19) != '\0');
          local_2c8 = 0;
          local_2a9 = 0x1f;
          lVar21 = FUN_140056c90(&local_2c8,lVar19);
          FUN_140558820(lVar21,lVar29,lVar19);
          *(undefined1 *)(lVar21 + lVar19) = 0;
          if (local_2a9 < 0x40) {
            local_2a9 = 0x1f - (char)lVar19;
            lVar19 = local_2b8;
          }
          local_2b8 = lVar19;
          local_2d0 = 0x4b;
          local_2f0 = 0;
          local_2d1 = 0x1f;
          puVar13 = (undefined8 *)FUN_140056c90(&local_2f0,0xf);
          *puVar13 = 0x6c616e7265746e69;
          *(undefined4 *)(puVar13 + 1) = 0x72726520;
          *(undefined2 *)((longlong)puVar13 + 0xc) = 0x726f;
          *(undefined1 *)((longlong)puVar13 + 0xe) = 0x3a;
          *(undefined1 *)((longlong)puVar13 + 0xf) = 0;
          if (local_2d1 < 0x40) {
            local_2d1 = 0x10;
          }
          else {
            local_2e0 = 0xf;
          }
          uVar17 = CONCAT44(uVar8,(int)lVar15);
          FUN_1400c3490(local_190,&local_2f0,&local_2c8,(int)lVar28,uVar17,lVar11 + 0x90);
          uVar8 = (undefined4)((ulonglong)uVar17 >> 0x20);
          if ((local_2d1 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_2ef,local_2f0),local_2d0,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          if ((local_2a9 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_2c7,local_2c8),local_2a8,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          if ((local_171 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(local_190[0],uStack_170,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          bVar2 = false;
        }
        if ((*(longlong *)(lVar11 + 0x98) == 0) || (bVar2)) {
          lVar15 = param_1[4];
          lVar28 = param_1[2];
          puVar27 = &local_278;
          if (0x3f < local_259) {
            puVar27 = (undefined1 *)CONCAT71(uStack_277,local_278);
          }
          puVar13 = (undefined8 *)
                    FUN_1400e0f60(&local_2c8,"Compilation failed (other error) \'%s\'",puVar27);
          if (0x3f < *(byte *)((longlong)puVar13 + 0x1f)) {
            puVar13 = (undefined8 *)*puVar13;
          }
          local_2d0 = 0x4b;
          do {
            lVar26 = lVar26 + 1;
          } while (*(char *)((longlong)puVar13 + lVar26) != '\0');
          local_2f0 = 0;
          local_2d1 = 0x1f;
          lVar19 = FUN_140056c90(&local_2f0,lVar26);
          FUN_140558820(lVar19,puVar13,lVar26);
          *(undefined1 *)(lVar19 + lVar26) = 0;
          if (local_2d1 < 0x40) {
            local_2d1 = 0x1f - (char)lVar26;
            lVar26 = local_2e0;
          }
          local_2e0 = lVar26;
          FUN_140089820(lVar11 + 0x90,&local_2f0,(int)lVar28,0,CONCAT44(uVar8,(int)lVar15));
          if ((local_2d1 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_2ef,local_2f0),local_2d0,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          if ((local_2a9 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_2c7,local_2c8),local_2a8,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
        }
        lVar26 = local_1a8;
        if ((local_259 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(CONCAT71(uStack_277,local_278),local_258,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
          lVar26 = local_1a8;
        }
      }
      else {
        if (local_288 != (longlong *)0x0) {
          uVar17 = (**(code **)(*local_288 + 0x20))(local_288);
          uVar18 = (**(code **)(*local_288 + 0x18))();
          FUN_140014bc0(&local_2c8,uVar18,uVar17,0x4b);
          lVar15 = param_1[4];
          lVar28 = param_1[2];
          lVar19 = (**(code **)(*param_1 + 0x20))(param_1);
          local_2d0 = 0x4b;
          local_2f0 = 0;
          local_2d1 = 0x1f;
          lVar29 = -1;
          do {
            lVar29 = lVar29 + 1;
          } while (*(char *)(lVar19 + lVar29) != '\0');
          FUN_140054780(&local_2f0,lVar19);
          local_258 = 0x4b;
          local_278 = 0;
          local_259 = 0x1f;
          FUN_140054780(&local_278,"): warning ",0xb);
          uVar17 = CONCAT44(uVar35,(int)lVar15);
          FUN_1400c1f10(&local_2c8,1,&local_278,&local_2f0,CONCAT44(uVar8,(int)lVar28),uVar17,
                        lVar11 + 0x90);
          uVar35 = (undefined4)((ulonglong)uVar17 >> 0x20);
          if ((local_259 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_277,local_278),local_258,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          if ((local_2d1 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_2ef,local_2f0),local_2d0,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          if ((local_2a9 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_2c7,local_2c8),local_2a8,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
        }
        pcVar20 = (code *)(**(code **)(*local_250 + 0x18))();
        local_280 = pcVar20;
        uVar25 = (**(code **)(*local_250 + 0x20))();
        if (bVar3 == 0) {
          lVar28 = param_1[2];
          lVar15 = param_1[1];
          uVar8 = *(undefined4 *)((longlong)param_1 + 0x14);
          lVar19 = (**(code **)(*param_1 + 0x20))(param_1);
          local_258 = 0x4b;
          local_278 = 0;
          local_259 = 0x1f;
          do {
            lVar26 = lVar26 + 1;
          } while (*(char *)(lVar19 + lVar26) != '\0');
          FUN_140054780(&local_278,lVar19,lVar26);
          ProcessFxcReflectionAndValidate
                    (pcVar20,uVar25,&local_278,uVar8,lVar15,CONCAT44(uVar35,(int)lVar28),
                     lVar11 + 0x90,&local_1a8,&local_2a0);
          if ((local_259 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_277,local_278),local_258,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          cVar6 = FUN_14008ee50(lVar11 + 0x90);
          lVar26 = local_1a8;
          if (cVar6 != '\0') goto LAB_1400330ae;
          uVar14 = (ulonglong)local_2a0 & 0xffffffff;
        }
        if (bVar7 == 0) {
          plVar12 = (longlong *)(**(code **)*DAT_14074ece0)();
          iVar10 = (**(code **)(*plVar12 + 0x40))(plVar12,pcVar20,uVar25,(bVar3 ^ 1) + 6,&local_1f8)
          ;
          if (-1 < iVar10) {
            pcVar20 = (code *)(**(code **)(*local_1f8 + 0x18))();
            local_280 = pcVar20;
            uVar25 = (**(code **)(*local_1f8 + 0x20))();
          }
        }
        uVar31 = *(ulonglong *)(lVar11 + 0x58) >> 1;
        if (bVar3 == 0) {
          uVar22 = *(longlong *)(lVar11 + 0x50) + 1;
          if (uVar31 < uVar22) {
            FUN_140056f10(lVar11 + 0x40);
          }
          lVar26 = local_1a8;
          *(ulonglong *)(lVar11 + 0x50) = uVar22;
          *(undefined1 *)(*(longlong *)(lVar11 + 0x40) + -1 + uVar22) = 2;
          bVar33 = 0;
          bVar32 = 0;
          bVar7 = 0;
          bVar30 = 0;
          local_res18 = 0;
          bVar3 = 0;
          if ((lStack_1a0 - local_1a8) / 0x28 != 0) {
            pcVar16 = (char *)(local_1a8 + 0xc);
            lVar15 = (lStack_1a0 - local_1a8) / 0x28;
            do {
              switch(*(undefined4 *)(pcVar16 + -4)) {
              case 0:
                if (bVar32 < (byte)(*pcVar16 + 1U)) {
                  bVar32 = *pcVar16 + 1U;
                }
                break;
              case 2:
              case 5:
              case 7:
                if (bVar33 < (byte)(*pcVar16 + 1U)) {
                  bVar33 = *pcVar16 + 1U;
                }
                break;
              case 3:
                if (bVar7 < (byte)(*pcVar16 + 1U)) {
                  bVar7 = *pcVar16 + 1U;
                }
                break;
              case 4:
              case 6:
              case 8:
              case 9:
              case 10:
              case 0xb:
                if (bVar30 < (byte)(*pcVar16 + 1U)) {
                  bVar30 = *pcVar16 + 1U;
                }
              }
              pcVar16 = pcVar16 + 0x28;
              lVar15 = lVar15 + -1;
              local_res18 = bVar30;
              bVar3 = bVar7;
            } while (lVar15 != 0);
          }
          lVar15 = *(longlong *)(lVar11 + 0x50);
          uVar31 = lVar15 + 1;
          if (*(ulonglong *)(lVar11 + 0x58) >> 1 < uVar31) {
            FUN_140056f10((longlong *)(lVar11 + 0x40));
          }
          *(ulonglong *)(lVar11 + 0x50) = uVar31;
          *(byte *)(lVar15 + *(longlong *)(lVar11 + 0x40)) = bVar33;
          uVar31 = *(longlong *)(lVar11 + 0x50) + 1;
          if (*(ulonglong *)(lVar11 + 0x58) >> 1 < uVar31) {
            FUN_140056f10(lVar11 + 0x40);
          }
          *(ulonglong *)(lVar11 + 0x50) = uVar31;
          *(byte *)(*(longlong *)(lVar11 + 0x40) + -1 + uVar31) = bVar32;
          lVar15 = *(longlong *)(lVar11 + 0x50);
          uVar31 = lVar15 + 1;
          if (*(ulonglong *)(lVar11 + 0x58) >> 1 < uVar31) {
            FUN_140056f10(lVar11 + 0x40);
          }
          *(ulonglong *)(lVar11 + 0x50) = uVar31;
          *(byte *)(lVar15 + *(longlong *)(lVar11 + 0x40)) = bVar3;
          uVar31 = *(longlong *)(lVar11 + 0x50) + 1;
          if (*(ulonglong *)(lVar11 + 0x58) >> 1 < uVar31) {
            FUN_140056f10(lVar11 + 0x40);
          }
          *(ulonglong *)(lVar11 + 0x50) = uVar31;
          *(byte *)(*(longlong *)(lVar11 + 0x40) + -1 + uVar31) = local_res18;
          uVar31 = *(longlong *)(lVar11 + 0x50) + 1;
          if (*(ulonglong *)(lVar11 + 0x58) >> 1 < uVar31) {
            FUN_140056f10(lVar11 + 0x40);
          }
          *(ulonglong *)(lVar11 + 0x50) = uVar31;
          *(char *)(*(longlong *)(lVar11 + 0x40) + -1 + uVar31) = (char)uVar14;
          lVar15 = *(longlong *)(lVar11 + 0x50);
          uVar14 = lVar15 + 0x20;
          if (*(ulonglong *)(lVar11 + 0x58) >> 1 < uVar14) {
            FUN_140059820(lVar11 + 0x40,uVar14,1);
          }
          *(ulonglong *)(lVar11 + 0x50) = uVar14;
          lVar28 = *(longlong *)(lVar11 + 0x40);
          puVar13 = (undefined8 *)(lVar15 + lVar28);
          *puVar13 = 0;
          puVar13[1] = 0;
          puVar13 = (undefined8 *)(lVar15 + 0x10 + lVar28);
          *puVar13 = 0;
          puVar13[1] = 0;
          lVar15 = *(longlong *)(lVar11 + 0x50);
          uVar14 = (ulonglong)uVar25 + lVar15;
          if (*(ulonglong *)(lVar11 + 0x58) >> 1 < uVar14) {
            FUN_140059820(lVar11 + 0x40,uVar14,1);
          }
          *(ulonglong *)(lVar11 + 0x50) = uVar14;
          FUN_140558820(*(longlong *)(lVar11 + 0x40) + lVar15,local_280,uVar25);
        }
        else {
          uVar14 = (ulonglong)(uVar25 + 1);
          if (uVar31 < uVar14) {
            FUN_140059820(lVar11 + 0x40,uVar14,1);
          }
          *(ulonglong *)(lVar11 + 0x50) = uVar14;
          **(undefined1 **)(lVar11 + 0x40) = 0;
          FUN_140558820(*(longlong *)(lVar11 + 0x40) + 1,pcVar20,uVar25);
          lVar26 = local_1a8;
        }
      }
LAB_1400330ae:
      plVar12 = (longlong *)(**(code **)*DAT_14074ece0)();
      (**(code **)(*plVar12 + 8))(plVar12,uVar5);
      if (local_1f8 != (longlong *)0x0) {
        (**(code **)(*local_1f8 + 0x10))();
      }
      if (local_250 != (longlong *)0x0) {
        (**(code **)(*local_250 + 0x10))();
      }
      if (local_288 != (longlong *)0x0) {
        (**(code **)(*local_288 + 0x10))();
      }
      if (lVar26 != 0) {
        uVar14 = ((local_198 - lVar26) / 0x28) * 0x28;
        lVar15 = lVar26;
        if (0xfff < uVar14) {
          lVar15 = *(longlong *)(lVar26 + -8);
          if (0x1f < (lVar26 - lVar15) - 8U) {
                    /* WARNING: Subroutine does not return */
            FUN_1403de184(lVar15,uVar14 + 0x27);
          }
        }
        thunk_FUN_1403f2404(lVar15);
      }
    }
  }
  else {
    uVar14 = local_1c0;
    if (local_1b1 < 0x40) {
      uVar14 = 0x1f - (longlong)(char)local_1b1;
    }
    if (*(ulonglong *)(lVar11 + 0x58) >> 1 < uVar14) {
      FUN_140059820(lVar11 + 0x40,uVar14,1);
    }
    *(ulonglong *)(lVar11 + 0x50) = uVar14;
    if (local_1b1 < 0x40) {
      FUN_140558820(*(undefined8 *)(lVar11 + 0x40),&local_1d0,0x1f - (longlong)(char)local_1b1);
    }
    else {
      FUN_140558820(*(undefined8 *)(lVar11 + 0x40),CONCAT71(uStack_1cf,local_1d0),local_1c0);
    }
  }
  if ((local_149 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_167,local_168),local_148,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  FUN_140018ba0(&local_88);
  FUN_140017ca0(&local_238);
  FUN_140017ca0(&local_218);
  FUN_140018570(&local_a8);
  FUN_140018570(&local_c8);
  FUN_1400171d0(&local_e0);
  FUN_1400171d0(&local_f8);
  FUN_140017d70(&local_68);
  if ((local_1b1 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_1cf,local_1d0),local_1b0,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  FUN_140017ca0(&local_140);
  if ((local_101 & 0xc0) != 0x40) {
    return lVar11;
  }
  uVar17 = CONCAT71(uStack_11f,local_120);
  uVar1 = local_100;
LAB_140033247:
  thunk_FUN_1403f2404(uVar17,uVar1,
                      "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                      ,0x218);
  return lVar11;
}
```

## `ProcessComputeFxcCompile` — `0x1400cb330`

FXC compute: kernel lookup, `cs_5_0`, strip

```c
/* FXC compute compile. Per kernel: preprocess, FindComputeKernelEntryPoint, D3DCompile with cs_5_0,
   then D3DStripShader(flags=7) unless flags[7] keeps reflection (bits 2 and 12). Errors:
   "Compilation failed for kernel '%s'". */

void ProcessComputeFxcCompile
               (longlong *param_1,longlong *param_2,longlong *param_3,undefined8 param_4,
               longlong param_5)

{
  char cVar1;
  byte bVar2;
  undefined1 uVar3;
  int iVar4;
  uint uVar5;
  int iVar6;
  ulonglong uVar7;
  undefined8 uVar8;
  undefined8 uVar9;
  undefined1 *puVar10;
  char *pcVar11;
  undefined8 *puVar12;
  undefined8 ****ppppuVar13;
  undefined8 *puVar14;
  longlong lVar15;
  undefined4 *puVar16;
  undefined8 ****ppppuVar17;
  undefined8 ****ppppuVar18;
  undefined8 ***pppuVar19;
  longlong lVar20;
  byte bVar21;
  uint uVar22;
  ulonglong uVar23;
  ulonglong uVar24;
  longlong lVar25;
  ulonglong in_stack_fffffffffffffcd8;
  undefined8 in_stack_fffffffffffffce0;
  undefined8 in_stack_fffffffffffffce8;
  undefined4 uVar26;
  undefined8 in_stack_fffffffffffffcf0;
  undefined4 uVar27;
  undefined1 local_2c8;
  undefined7 uStack_2c7;
  undefined8 local_2b8;
  byte local_2a9;
  undefined2 local_2a8;
  longlong *local_2a0;
  undefined1 *local_298;
  ulonglong local_290;
  char *local_288;
  ulonglong local_280;
  longlong *local_278;
  longlong *local_270;
  ulonglong local_268;
  undefined2 local_260;
  ulonglong local_258;
  ulonglong local_250;
  undefined8 ***local_248 [2];
  longlong local_238;
  byte local_229;
  undefined2 uStack_228;
  longlong local_220;
  undefined8 ***local_218;
  longlong local_210;
  longlong local_208;
  undefined2 local_200;
  ulonglong local_1f8;
  ulonglong local_1f0;
  undefined1 local_1e8;
  undefined7 uStack_1e7;
  longlong local_1d8;
  byte local_1c9;
  undefined2 local_1c8;
  undefined8 ***local_1c0 [2];
  undefined8 **local_1b0;
  byte local_1a1;
  undefined2 uStack_1a0;
  undefined8 ***local_198 [3];
  byte local_179;
  undefined2 local_178;
  undefined4 *local_170;
  undefined8 local_168;
  undefined4 local_160;
  undefined2 local_15a;
  undefined4 *local_158;
  undefined8 local_150;
  undefined4 local_148;
  undefined2 local_142;
  undefined8 local_140;
  undefined2 local_138;
  longlong local_130;
  undefined8 local_128;
  undefined8 local_120;
  undefined2 local_118;
  undefined8 local_110;
  undefined8 local_108;
  undefined8 ***local_100 [3];
  byte local_e1;
  undefined2 local_e0;
  undefined8 ***local_d8 [2];
  longlong local_c8;
  byte local_b9;
  undefined2 local_b8;
  undefined8 local_b0;
  undefined2 local_a8;
  undefined8 local_a0;
  undefined8 local_98;
  undefined8 local_90;
  undefined2 local_88;
  undefined8 local_80;
  undefined8 local_78;
  undefined1 local_70 [16];
  undefined1 local_60 [32];
  
  uVar7 = (**(code **)(*param_2 + 0x50))(param_2);
  uVar8 = (**(code **)(*param_2 + 0x30))(param_2,0);
  uVar9 = (**(code **)(*param_2 + 0x28))(param_2,0);
  FUN_140014bc0(local_248,uVar9,uVar8,1);
  uVar8 = (**(code **)(*param_2 + 8))(param_2);
  uVar9 = (**(code **)*param_2)(param_2);
  FUN_140014bc0(local_d8,uVar9,uVar8,0x4b);
  local_218 = local_d8[0];
  local_210 = local_c8;
  if (local_b9 < 0x40) {
    local_210 = 0x1f - (longlong)(char)local_b9;
    local_218 = local_d8;
  }
  uVar8 = FUN_1400e1010(&local_298,&local_218);
  FUN_140014b30(local_100,uVar8,0x4b);
  FUN_1400149f0(local_1c0,param_2[10]);
  if ((*(int *)(*(longlong *)((longlong)ThreadLocalStoragePointer + (ulonglong)_tls_index * 8) +
               0x1c) < DAT_140750470) && (FUN_1403d6258(&DAT_140750470), DAT_140750470 == -1)) {
    atexit(FUN_140575c90);
    _Init_thread_footer(&DAT_140750470);
  }
  uVar23 = 0;
  local_268 = 0;
  local_260 = 0x4d;
  local_258 = 0;
  local_250 = 1;
  local_208 = 0;
  local_200 = 0x4d;
  local_1f8 = 0;
  local_1f0 = 1;
  local_90 = 0;
  local_88 = 0x4d;
  local_80 = 0;
  local_78 = 1;
  local_170 = &DAT_14058aa4c;
  local_168 = 0;
  local_160 = 0;
  local_15a = 1;
  local_158 = &DAT_14058aa4c;
  local_150 = 0;
  local_148 = 0;
  local_142 = 1;
  local_140 = 0;
  local_138 = 0x4d;
  local_130 = 0;
  local_128 = 1;
  local_120 = 0;
  local_118 = 0x4d;
  local_110 = 0;
  local_108 = 1;
  local_b0 = 0;
  local_a8 = 0x4d;
  local_a0 = 0;
  local_98 = 1;
  if (uVar7 != 0xffffffffffffffff) {
    FUN_140058450(&local_208);
  }
  uVar27 = (undefined4)((ulonglong)in_stack_fffffffffffffce0 >> 0x20);
  uVar26 = (undefined4)((ulonglong)in_stack_fffffffffffffce8 >> 0x20);
  lVar20 = -1;
  if (uVar7 != 0) {
    do {
      puVar10 = (undefined1 *)(**(code **)(*param_2 + 0x68))(param_2,uVar23);
      pcVar11 = (char *)(**(code **)(*param_2 + 0x58))(param_2,uVar23);
      uVar24 = local_1f8 + 1;
      if (local_1f0 >> 1 < uVar24) {
        FUN_140057330(&local_208);
      }
      lVar25 = local_208 + -0x50 + uVar24 * 0x50;
      local_220 = lVar25;
      local_1f8 = uVar24;
      if (lVar25 != 0) {
        local_290 = 0xffffffffffffffff;
        do {
          local_290 = local_290 + 1;
        } while (puVar10[local_290] != '\0');
        local_280 = 0xffffffffffffffff;
        do {
          local_280 = local_280 + 1;
        } while (pcVar11[local_280] != '\0');
        local_298 = puVar10;
        local_288 = pcVar11;
        FUN_140014b30(lVar25,&local_288,0x4b);
        FUN_140014b30(lVar25 + 0x28,&local_298,0x4b);
      }
      uVar27 = (undefined4)((ulonglong)in_stack_fffffffffffffce0 >> 0x20);
      uVar26 = (undefined4)((ulonglong)in_stack_fffffffffffffce8 >> 0x20);
      uVar23 = uVar23 + 1;
    } while (uVar23 < uVar7);
  }
  uVar23 = 0;
  puVar12 = (undefined8 *)FUN_1400bf630(local_70,(int)param_2[4]);
  uVar7 = local_1f8 + 1;
  if (local_1f0 >> 1 < uVar7) {
    FUN_140057330(&local_208);
  }
  pppuVar19 = (undefined8 ***)(local_208 + -0x50 + uVar7 * 0x50);
  uVar24 = uVar23;
  local_218 = pppuVar19;
  local_1f8 = uVar7;
  if (pppuVar19 != (undefined8 ***)0x0) {
    do {
      if ((&DAT_140578fc4)[uVar24] == '\0') goto LAB_1400cb69c;
      uVar24 = uVar24 + 1;
    } while (uVar24 < 2);
    uVar24 = 2;
LAB_1400cb69c:
    local_288 = "1";
    local_298 = (undefined1 *)*puVar12;
    local_290 = puVar12[1];
    local_280 = uVar24;
    FUN_140014b30(pppuVar19,&local_298,0x4b);
    FUN_140014b30(pppuVar19 + 5,&local_288,0x4b);
  }
  uVar7 = (**(code **)(*param_2 + 0x78))(param_2);
  if (local_250 >> 1 < uVar7) {
    if ((~(byte)local_250 & 1) == 0) {
      uVar24 = uVar23;
      if (uVar7 != 0) {
        uVar24 = FUN_1400e4280(uVar7 * 0x50,8,local_260,0,
                               "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\Allocators.h"
                               ,CONCAT44(uVar27,0x9c));
      }
      FUN_140558820(uVar24,local_268,local_258 * 0x50);
      local_250 = uVar7 * 2;
      local_268 = uVar24;
    }
    else {
      local_250 = uVar7 * 2;
      local_268 = FUN_1400e42a0(local_268,uVar7 * 0x50,8,local_260,
                                in_stack_fffffffffffffcd8 & 0xffffffff00000000,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\Allocators.h"
                                ,CONCAT44(uVar26,0xa3));
    }
  }
  uVar27 = (undefined4)((ulonglong)in_stack_fffffffffffffcf0 >> 0x20);
  if (uVar7 != 0) {
    do {
      pcVar11 = (char *)(**(code **)(*param_2 + 0x90))(param_2,uVar23);
      puVar10 = (undefined1 *)(**(code **)(*param_2 + 0x80))(param_2,uVar23);
      uVar24 = local_258 + 1;
      if (local_250 >> 1 < uVar24) {
        FUN_140057330(&local_268);
      }
      pppuVar19 = (undefined8 ***)((local_268 - 0x50) + uVar24 * 0x50);
      local_258 = uVar24;
      local_218 = pppuVar19;
      if (pppuVar19 != (undefined8 ***)0x0) {
        local_280 = 0xffffffffffffffff;
        do {
          local_280 = local_280 + 1;
        } while (pcVar11[local_280] != '\0');
        local_290 = 0xffffffffffffffff;
        do {
          local_290 = local_290 + 1;
        } while (puVar10[local_290] != '\0');
        local_298 = puVar10;
        local_288 = pcVar11;
        FUN_140014b30(pppuVar19,&local_298,0x4b);
        FUN_140014b30(pppuVar19 + 5,&local_288,0x4b);
      }
      uVar27 = (undefined4)((ulonglong)in_stack_fffffffffffffcf0 >> 0x20);
      uVar23 = uVar23 + 1;
    } while (uVar23 < uVar7);
  }
  uVar22 = ((char)param_2[0xb] != '\0') + 0x30;
  cVar1 = *(char *)((longlong)param_2 + 0x59);
  uVar8 = (**(code **)(*param_2 + 0x38))(param_2);
  uVar5 = uVar22 | 0x80;
  if (cVar1 == '\0') {
    uVar5 = uVar22;
  }
  puVar12 = &local_90;
  ppppuVar13 = local_1c0;
  ProcessShaderPreprocessor
            (local_100,local_1c0,uVar8,&local_268,&local_208,&local_b0,&DAT_140728dd0,
             CONCAT44(uVar27,uVar5),ppppuVar13,puVar12,&local_170,&local_140,&local_120,local_60,0);
  uVar27 = (undefined4)((ulonglong)ppppuVar13 >> 0x20);
  ProcessPreprocessorPragmaState(&local_140,&local_120,param_5);
  if (local_130 != 0) goto LAB_1400cc43f;
  if ((char)param_2[0xb] != '\0') {
    ppppuVar13 = (undefined8 ****)FUN_1400565a0(param_4);
    if (ppppuVar13 != local_248) {
      ppppuVar18 = (undefined8 ****)local_248[0];
      if (local_229 < 0x40) {
        local_238 = 0x1f - (longlong)(char)local_229;
        ppppuVar18 = local_248;
      }
      FUN_140054780(ppppuVar13,ppppuVar18,local_238);
    }
    pppuVar19 = (undefined8 ***)local_1b0;
    ppppuVar18 = (undefined8 ****)local_1c0[0];
    if (local_1a1 < 0x40) {
      pppuVar19 = (undefined8 ***)(0x1f - (longlong)(char)local_1a1);
      ppppuVar18 = local_1c0;
    }
    if ((undefined8 ***)((ulonglong)ppppuVar13[0x1c] >> 1) < pppuVar19) {
      FUN_140059820(ppppuVar13 + 0x19,pppuVar19,1);
    }
    ppppuVar13[0x1b] = pppuVar19;
    FUN_140558820(ppppuVar13[0x19],ppppuVar18,pppuVar19);
    goto LAB_1400cc43f;
  }
  local_2a0 = (longlong *)0x0;
  local_278 = (longlong *)0x0;
  local_270 = (longlong *)0x0;
  iVar6 = (int)param_2[4];
  puVar14 = (undefined8 *)FUN_1400e40a0(0x10);
  *puVar14 = 0;
  puVar14[1] = 0;
  bVar2 = *(byte *)(param_2 + 7);
  bVar21 = (byte)((uint)(int)param_2[7] >> 0x1a) & 1;
  uVar3 = (**(code **)(*param_1 + 0x10))();
  if ((bVar2 >> 2 & 1) == 0) {
    iVar4 = 0x5004;
    if ((bVar21 == 0) &&
       ((((iVar6 - 0xeU & 0xfffffff3) == 0 && (iVar6 != 0x16)) || (iVar4 = 0x1000, iVar6 == 0xf))))
    {
      iVar4 = 0x9400;
    }
  }
  else {
    (**(code **)(*param_1 + 8))(param_1,1);
    local_290 = 0;
    do {
      if ((&DAT_140579a98)[local_290] == '\0') goto LAB_1400cbad4;
      local_290 = local_290 + 1;
    } while (local_290 < 8);
    local_290 = 8;
LAB_1400cbad4:
    local_298 = &DAT_140579a98;
    local_280 = 0;
    do {
      if ("#line"[local_280] == '\0') goto LAB_1400cbaf9;
      local_280 = local_280 + 1;
    } while (local_280 < 6);
    local_280 = 6;
LAB_1400cbaf9:
    local_288 = "#line";
    FUN_1400e22b0(local_1c0,&local_288,&local_298,0);
    iVar4 = (uint)bVar21 * 0x4000 + 0x1005;
  }
  ppppuVar13 = local_248;
  if (0x3f < local_229) {
    ppppuVar13 = (undefined8 ****)local_248[0];
  }
  ppppuVar18 = local_100;
  if (0x3f < local_e1) {
    ppppuVar18 = (undefined8 ****)local_100[0];
  }
  ppppuVar17 = (undefined8 ****)local_1c0[0];
  if (local_1a1 < 0x40) {
    local_1b0 = (undefined8 **)(0x1f - (longlong)(char)local_1a1);
    ppppuVar17 = local_1c0;
  }
  uVar26 = 0;
  iVar4 = (**(code **)(*param_1 + 0x18))
                    (param_1,ppppuVar17,local_1b0,ppppuVar18,puVar14,0,ppppuVar13,"cs_5_0",
                     CONCAT44(uVar27,iVar4),(ulonglong)puVar12 & 0xffffffff00000000,&local_2a0,
                     &local_278);
  uVar27 = (undefined4)((ulonglong)puVar14 >> 0x20);
  if (local_278 == (longlong *)0x0) {
    if (iVar4 < 0) {
      pcVar11 = "unknown error";
      if (iVar4 == -0x7fffbffb) {
        pcVar11 = 
        "Attempted to create a device with the debug layer enabled and the layer is not installed.";
      }
      else if (iVar4 == -0x7ff8fff2) {
        pcVar11 = "Could not allocate sufficient memory to complete the compilation.";
      }
      else if (iVar4 == -0x7ff8ffa9) {
        pcVar11 = "An invalid parameter was passed to the compiler";
      }
      if (local_2a0 != (longlong *)0x0) {
        (**(code **)(*local_2a0 + 0x10))();
        local_2a0 = (longlong *)0x0;
      }
      FUN_1400e0f60(local_198,"Compilation failed [0x%08x - %s]",iVar4,pcVar11);
      ppppuVar13 = local_198;
      if (0x3f < local_179) {
        ppppuVar13 = (undefined8 ****)local_198[0];
      }
      local_2a8 = 0x4b;
      local_2c8 = 0;
      local_2a9 = 0x1f;
      do {
        lVar20 = lVar20 + 1;
      } while (*(char *)((longlong)ppppuVar13 + lVar20) != '\0');
      FUN_140054780(&local_2c8,ppppuVar13,lVar20);
      FUN_140089820(param_5,&local_2c8,0,0,CONCAT44(uVar27,0x1c));
      if ((local_2a9 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(CONCAT71(uStack_2c7,local_2c8),local_2a8,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      if ((local_179 & 0xc0) == 0x40) goto LAB_1400cc241;
    }
  }
  else {
    lVar25 = (**(code **)(*local_278 + 0x20))(local_278);
    uVar8 = (**(code **)(*local_278 + 0x18))();
    local_1c8 = 0x4b;
    local_1e8 = 0;
    local_1c9 = 0x1f;
    lVar15 = FUN_140056c90(&local_1e8,lVar25);
    FUN_140558820(lVar15,uVar8,lVar25);
    *(undefined1 *)(lVar15 + lVar25) = 0;
    if (local_1c9 < 0x40) {
      local_1c9 = 0x1f - (char)lVar25;
      lVar25 = local_1d8;
    }
    local_1d8 = lVar25;
    local_2a8 = 0x4b;
    local_2c8 = 0;
    local_2a9 = 0x1f;
    pcVar11 = (char *)FUN_140056c90(&local_2c8,0xf);
    builtin_strncpy(pcVar11,"): fatal error ",0x10);
    if (local_2a9 < 0x40) {
      local_2a9 = 0x10;
    }
    else {
      local_2b8 = 0xf;
    }
    uVar8 = CONCAT44(uVar26,iVar6);
    uVar7 = (ulonglong)puVar14 & 0xffffffff00000000;
    FUN_1400c1f10(&local_1e8,0,&local_2c8,local_248,uVar7,uVar8,param_5);
    uVar27 = (undefined4)((ulonglong)uVar8 >> 0x20);
    if ((local_2a9 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(uStack_2c7,local_2c8),local_2a8,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    local_2a8 = 0x4b;
    local_2c8 = 0;
    local_2a9 = 0x1f;
    pcVar11 = (char *)FUN_140056c90(&local_2c8,9);
    builtin_strncpy(pcVar11,"): error ",10);
    if (local_2a9 < 0x40) {
      local_2a9 = 0x16;
    }
    else {
      local_2b8 = 9;
    }
    uVar8 = CONCAT44(uVar27,iVar6);
    uVar7 = uVar7 & 0xffffffff00000000;
    FUN_1400c1f10(&local_1e8,0,&local_2c8,local_248,uVar7,uVar8,param_5);
    uVar27 = (undefined4)((ulonglong)uVar8 >> 0x20);
    if ((local_2a9 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(uStack_2c7,local_2c8),local_2a8,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    local_2a8 = 0x4b;
    local_2c8 = 0;
    local_2a9 = 0x1f;
    pcVar11 = (char *)FUN_140056c90(&local_2c8,10);
    builtin_strncpy(pcVar11,"): error: ",0xb);
    if (local_2a9 < 0x40) {
      local_2a9 = 0x15;
    }
    else {
      local_2b8 = 10;
    }
    uVar8 = CONCAT44(uVar27,iVar6);
    uVar7 = uVar7 & 0xffffffff00000000;
    FUN_1400c1f10(&local_1e8,0,&local_2c8,local_248,uVar7,uVar8,param_5);
    uVar27 = (undefined4)((ulonglong)uVar8 >> 0x20);
    if ((local_2a9 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(uStack_2c7,local_2c8),local_2a8,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    local_2a8 = 0x4b;
    local_2c8 = 0;
    local_2a9 = 0x1f;
    pcVar11 = (char *)FUN_140056c90(&local_2c8,0xb);
    builtin_strncpy(pcVar11,"): warning ",0xc);
    if (local_2a9 < 0x40) {
      local_2a9 = 0x14;
    }
    else {
      local_2b8 = 0xb;
    }
    uVar8 = CONCAT44(uVar27,iVar6);
    uVar7 = uVar7 & 0xffffffff00000000;
    FUN_1400c1f10(&local_1e8,1,&local_2c8,local_248,uVar7,uVar8,param_5);
    uVar27 = (undefined4)((ulonglong)uVar8 >> 0x20);
    if ((local_2a9 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(uStack_2c7,local_2c8),local_2a8,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    local_2a8 = 0x4b;
    local_2c8 = 0;
    local_2a9 = 0x1f;
    puVar12 = (undefined8 *)FUN_140056c90(&local_2c8,8);
    *puVar12 = 0x20676e696e726177;
    *(undefined1 *)(puVar12 + 1) = 0;
    if (local_2a9 < 0x40) {
      local_2a9 = 0x17;
    }
    else {
      local_2b8 = 8;
    }
    uVar7 = uVar7 & 0xffffffff00000000;
    FindComputeKernelEntryPoint
              (&local_1e8,1,&local_2c8,local_248,uVar7,CONCAT44(uVar27,iVar6),param_5);
    uVar27 = (undefined4)(uVar7 >> 0x20);
    if ((local_2a9 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(uStack_2c7,local_2c8),local_2a8,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    local_2a8 = 0x4b;
    local_2c8 = 0;
    local_2a9 = 0x1f;
    puVar16 = (undefined4 *)FUN_140056c90(&local_2c8,6);
    *puVar16 = 0x6f727265;
    *(undefined2 *)(puVar16 + 1) = 0x2072;
    *(undefined1 *)((longlong)puVar16 + 6) = 0;
    if (local_2a9 < 0x40) {
      local_2a9 = 0x19;
    }
    else {
      local_2b8 = 6;
    }
    FUN_1400c3490(&local_1e8,&local_2c8,local_248,0,CONCAT44(uVar27,iVar6),param_5);
    if ((local_2a9 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(uStack_2c7,local_2c8),local_2a8,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    if (*(longlong *)(param_5 + 8) == 0) {
      puVar10 = &local_1e8;
      if (0x3f < local_1c9) {
        puVar10 = (undefined1 *)CONCAT71(uStack_1e7,local_1e8);
      }
      ppppuVar13 = local_248;
      if (0x3f < local_229) {
        ppppuVar13 = (undefined8 ****)local_248[0];
      }
      FUN_1400e0f60(local_198,"Compilation failed for kernel \'%s\' [0x%08x - unknown error] \'%s\'"
                    ,ppppuVar13,iVar4,puVar10);
      uVar27 = (undefined4)((ulonglong)puVar10 >> 0x20);
      ppppuVar13 = local_198;
      if (0x3f < local_179) {
        ppppuVar13 = (undefined8 ****)local_198[0];
      }
      local_2a8 = 0x4b;
      local_2c8 = 0;
      local_2a9 = 0x1f;
      do {
        lVar20 = lVar20 + 1;
      } while (*(char *)((longlong)ppppuVar13 + lVar20) != '\0');
      FUN_140054780(&local_2c8,ppppuVar13,lVar20);
      FUN_140089820(param_5,&local_2c8,0,0,CONCAT44(uVar27,0x1c));
      if ((local_2a9 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(CONCAT71(uStack_2c7,local_2c8),local_2a8,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      if ((local_179 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(local_198[0],local_178,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
    }
    if ((local_1c9 & 0xc0) == 0x40) {
      local_198[0] = (undefined8 ***)CONCAT71(uStack_1e7,local_1e8);
      local_178 = local_1c8;
LAB_1400cc241:
      thunk_FUN_1403f2404(local_198[0],local_178,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
  }
  if (local_2a0 != (longlong *)0x0) {
    uVar8 = (**(code **)(*local_2a0 + 0x18))();
    uVar5 = (**(code **)(*local_2a0 + 0x20))();
    ppppuVar13 = (undefined8 ****)FUN_1400565a0(param_4);
    if (ppppuVar13 != local_248) {
      ppppuVar18 = (undefined8 ****)local_248[0];
      if (local_229 < 0x40) {
        local_238 = 0x1f - (longlong)(char)local_229;
        ppppuVar18 = local_248;
      }
      FUN_140054780(ppppuVar13,ppppuVar18,local_238);
    }
    uVar7 = param_3[2] + 1;
    if ((ulonglong)param_3[3] >> 1 < uVar7) {
      FUN_1400572f0(param_3);
    }
    param_3[2] = uVar7;
    lVar20 = param_3[1];
    puVar12 = (undefined8 *)(*param_3 + -0x20 + uVar7 * 0x20);
    if (puVar12 != (undefined8 *)0x0) {
      *puVar12 = 0;
      *(short *)(puVar12 + 1) = (short)lVar20;
      puVar12[2] = 0;
      puVar12[3] = 1;
    }
    FUN_1400d2ac0(param_1,iVar6,uVar8,uVar5,ppppuVar13,puVar12,param_5);
    if ((((*(uint *)(param_2 + 7) >> 0xc & 1) == 0) && ((*(byte *)(param_2 + 7) >> 2 & 1) == 0)) &&
       (iVar6 = (**(code **)(*param_1 + 0x40))(param_1,uVar8,uVar5,7,&local_270), -1 < iVar6)) {
      uVar8 = (**(code **)(*local_270 + 0x18))();
      uVar5 = (**(code **)(*local_270 + 0x20))();
    }
    pppuVar19 = (undefined8 ***)(ulonglong)uVar5;
    if ((undefined8 ***)((ulonglong)ppppuVar13[0x1c] >> 1) < pppuVar19) {
      FUN_140059820(ppppuVar13 + 0x19,pppuVar19,1);
    }
    ppppuVar13[0x1b] = pppuVar19;
    FUN_140558820(ppppuVar13[0x19],uVar8,pppuVar19);
  }
  if (local_278 != (longlong *)0x0) {
    (**(code **)(*local_278 + 0x10))(local_278);
    local_278 = (longlong *)0x0;
  }
  if (local_2a0 != (longlong *)0x0) {
    (**(code **)(*local_2a0 + 0x10))();
    local_2a0 = (longlong *)0x0;
  }
  if (local_270 != (longlong *)0x0) {
    (**(code **)(*local_270 + 0x10))();
    local_270 = (longlong *)0x0;
  }
  (**(code **)(*param_1 + 8))(param_1,uVar3);
LAB_1400cc43f:
  FUN_140018ba0(&local_b0);
  FUN_140018570(&local_120);
  FUN_140018570(&local_140);
  FUN_1400171d0(&local_158);
  FUN_1400171d0(&local_170);
  FUN_140017d70(&local_90);
  FUN_140017ca0(&local_208);
  FUN_140017ca0(&local_268);
  if ((local_1a1 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(local_1c0[0],uStack_1a0,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  if ((local_e1 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(local_100[0],local_e0,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  if ((local_b9 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(local_d8[0],local_b8,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  if ((local_229 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(local_248[0],uStack_228,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  return;
}
```

## `FindComputeKernelEntryPoint` — `0x1400c34c0`

kernel entry-point lookup

```c
/* Finds the entry point of a #pragma kernel inside compute source. Failure is reported as "Did not
   find shader kernel '<name>'". */

void FindComputeKernelEntryPoint
               (undefined8 *param_1,undefined1 param_2,undefined8 *param_3,char *param_4,
               undefined4 param_5,undefined4 param_6,undefined8 param_7)

{
  char cVar1;
  byte bVar2;
  undefined8 *puVar3;
  undefined8 uVar4;
  char *pcVar5;
  char *pcVar6;
  char *pcVar7;
  ulonglong uVar8;
  ulonglong uVar9;
  ulonglong uVar10;
  ulonglong uVar11;
  longlong lVar12;
  char local_140;
  undefined7 uStack_13f;
  ulonglong local_138;
  ulonglong local_130;
  byte local_121;
  undefined2 local_120;
  char local_118;
  uint7 uStack_117;
  ulonglong local_110;
  ulonglong local_108;
  byte local_f9;
  undefined2 local_f8;
  undefined1 local_f0;
  undefined7 uStack_ef;
  longlong local_e0;
  byte local_d1;
  undefined2 local_d0;
  longlong local_c8;
  undefined8 local_c0 [3];
  byte local_a1;
  undefined2 local_a0;
  undefined1 *local_98;
  longlong local_90;
  undefined8 local_88 [3];
  byte local_69;
  undefined2 local_68;
  undefined8 local_60 [3];
  byte local_41;
  undefined2 local_40;
  
  if (*(byte *)((longlong)param_3 + 0x1f) < 0x40) {
    lVar12 = 0x1f - (longlong)*(char *)((longlong)param_3 + 0x1f);
    puVar3 = param_3;
  }
  else {
    lVar12 = param_3[2];
    puVar3 = (undefined8 *)*param_3;
  }
  local_c8 = FUN_140056850(param_1,puVar3,0,lVar12);
  if (local_c8 != -1) {
    local_d0 = 0x4b;
    local_f0 = 0;
    local_d1 = 0x1f;
    do {
      if (local_c8 == 0) {
LAB_1400c3579:
        uVar4 = FUN_1400e86c0(local_c0,param_1,local_c8,0);
        FUN_1400545d0(&local_f0,uVar4);
        if ((local_a1 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(local_c0[0],local_a0,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
        }
        lVar12 = FUN_140056850(&local_f0,"entrypoint not found",0,0x14);
        if ((lVar12 == -1) &&
           (lVar12 = FUN_140056850(&local_f0,"missing entry point",0,0x13), lVar12 == -1)) {
          local_90 = local_e0;
          if (local_d1 < 0x40) {
            local_90 = 0x1f - (longlong)(char)local_d1;
          }
          local_98 = &local_f0;
          if (0x3f < local_d1) {
            local_98 = (undefined1 *)CONCAT71(uStack_ef,local_f0);
          }
          uVar4 = FUN_14001b190(local_60,"Program \'",param_4);
          uVar4 = FUN_14001ad10(local_88,uVar4,&DAT_140588ef8);
          uVar4 = FUN_14001aaa0(local_c0,uVar4,&local_98);
          FUN_1400545d0(&local_f0,uVar4);
          if ((local_a1 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(local_c0[0],local_a0,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          if ((local_69 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(local_88[0],local_68,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          if ((local_41 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(local_60[0],local_40,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
        }
        else {
          local_120 = *(undefined2 *)(param_4 + 0x20);
          local_140 = '\0';
          local_121 = 0x1f;
          if ((byte)param_4[0x1f] < 0x40) {
            lVar12 = 0x1f - (longlong)param_4[0x1f];
          }
          else {
            lVar12 = *(longlong *)(param_4 + 0x10);
          }
          if (0x1e < lVar12 + 0x1cU) {
            FUN_140056c90(&local_140);
          }
          if ((local_121 & 0xc0) == 0x80) {
            local_140 = '\0';
            local_121 = 0x1f;
          }
          pcVar6 = (char *)CONCAT71(uStack_13f,local_140);
          pcVar7 = &local_140;
          if (0x3f < local_121) {
            pcVar7 = pcVar6;
          }
          if ("Did not find shader kernel \'" < pcVar7) {
LAB_1400c379c:
            bVar2 = local_121 >> 6;
            if (bVar2 == 0) {
LAB_1400c37b0:
              local_140 = '\0';
              local_121 = 0x1f;
            }
            else if (bVar2 == 1) {
              *pcVar6 = '\0';
              local_130 = 0;
            }
            else if (bVar2 == 2) goto LAB_1400c37b0;
            pcVar7 = (char *)FUN_140056c90(&local_140,0x1c);
            builtin_strncpy(pcVar7,"Did not find shader kernel \'",0x1c);
          }
          else {
            uVar10 = local_130;
            if (local_121 < 0x40) {
              uVar10 = 0x1f - (longlong)(char)local_121;
            }
            if (pcVar7 + uVar10 < "id not find shader kernel \'") goto LAB_1400c379c;
            pcVar7 = &local_140;
            if (0x3f < local_121) {
              pcVar7 = pcVar6;
            }
            FUN_140558820(pcVar7,"Did not find shader kernel \'",0x1c);
          }
          pcVar7[0x1c] = '\0';
          if (local_121 < 0x40) {
            local_121 = 3;
          }
          else {
            local_130 = 0x1c;
          }
          if ((byte)param_4[0x1f] < 0x40) {
            lVar12 = 0x1f - (longlong)param_4[0x1f];
            pcVar6 = param_4;
          }
          else {
            lVar12 = *(longlong *)(param_4 + 0x10);
            pcVar6 = *(char **)param_4;
          }
          uVar10 = local_130;
          if (lVar12 != 0) {
            uVar8 = local_130;
            if (local_121 < 0x40) {
              uVar8 = 0x1f - (longlong)(char)local_121;
            }
            uVar10 = uVar8 + lVar12;
            uVar9 = local_138;
            if (local_121 < 0x40) {
              uVar9 = 0x1f;
            }
            if (uVar9 < uVar10) {
              uVar11 = uVar9 * 2;
              if (uVar9 * 2 <= uVar10) {
                uVar11 = uVar10;
              }
              pcVar7 = &local_140;
              if (0x3f < local_121) {
                pcVar7 = (char *)CONCAT71(uStack_13f,local_140);
              }
              if (pcVar7 <= pcVar6) {
                uVar9 = local_130;
                if (local_121 < 0x40) {
                  uVar9 = 0x1f - (longlong)(char)local_121;
                }
                if (pcVar6 < pcVar7 + uVar9) {
                  pcVar5 = &local_140;
                  if (0x3f < local_121) {
                    pcVar5 = (char *)CONCAT71(uStack_13f,local_140);
                  }
                  pcVar7 = (char *)FUN_140056c90(&local_140,uVar11);
                  pcVar6 = pcVar7 + ((longlong)pcVar6 - (longlong)pcVar5);
                  goto LAB_1400c3901;
                }
              }
              pcVar7 = (char *)FUN_140056c90(&local_140,uVar11);
            }
            else {
              pcVar7 = &local_140;
              if (0x3f < local_121) {
                pcVar7 = (char *)CONCAT71(uStack_13f,local_140);
              }
            }
LAB_1400c3901:
            FUN_140558820(pcVar7 + uVar8,pcVar6,lVar12);
            pcVar7[uVar10] = '\0';
            if (local_121 < 0x40) {
              local_121 = 0x1f - (char)uVar10;
              uVar10 = local_130;
            }
          }
          local_130 = uVar10;
          local_f8 = local_120;
          local_118 = '\0';
          local_f9 = 0x1f;
          if (local_121 < 0x40) {
            uVar10 = 0x2b - (longlong)(char)local_121;
          }
          else {
            uVar10 = local_130 + 0xc;
          }
          if (0x1e < uVar10) {
            FUN_140056c90(&local_118);
          }
          uVar10 = local_130;
          if (local_121 < 0x40) {
            uVar10 = 0x1f - (longlong)(char)local_121;
          }
          pcVar6 = &local_140;
          if (0x3f < local_121) {
            pcVar6 = (char *)CONCAT71(uStack_13f,local_140);
          }
          if ((local_f9 & 0xc0) == 0x80) {
            local_118 = '\0';
            local_f9 = 0x1f;
            pcVar7 = (char *)((ulonglong)uStack_117 << 8);
            pcVar5 = &local_118;
          }
          else if (local_f9 < 0x40) {
            pcVar7 = (char *)CONCAT71(uStack_117,local_118);
            pcVar5 = &local_118;
          }
          else {
            pcVar7 = (char *)CONCAT71(uStack_117,local_118);
            pcVar5 = pcVar7;
          }
          if (pcVar6 < pcVar5) {
LAB_1400c3a3f:
            bVar2 = local_f9 >> 6;
            if (bVar2 == 0) {
LAB_1400c3a54:
              local_118 = '\0';
              local_f9 = 0x1f;
            }
            else if (bVar2 == 1) {
              *pcVar7 = '\0';
              local_108 = 0;
            }
            else if (bVar2 == 2) goto LAB_1400c3a54;
            pcVar5 = (char *)FUN_140056c90(&local_118,uVar10);
            FUN_140558820(pcVar5,pcVar6,uVar10);
          }
          else {
            uVar8 = local_108;
            if (local_f9 < 0x40) {
              uVar8 = 0x1f - (longlong)(char)local_f9;
            }
            if (pcVar5 + uVar8 <= pcVar6) goto LAB_1400c3a3f;
            pcVar5 = &local_118;
            if (0x3f < local_f9) {
              pcVar5 = pcVar7;
            }
            FUN_140558820(pcVar5,pcVar6,uVar10);
          }
          pcVar5[uVar10] = '\0';
          if (local_f9 < 0x40) {
            local_f9 = 0x1f - (char)uVar10;
            uVar10 = local_108;
          }
          local_108 = uVar10;
          uVar10 = local_108;
          if (local_f9 < 0x40) {
            uVar10 = 0x1f - (longlong)(char)local_f9;
          }
          uVar8 = uVar10 + 0xc;
          uVar9 = local_110;
          if (local_f9 < 0x40) {
            uVar9 = 0x1f;
          }
          if (uVar9 < uVar8) {
            uVar11 = uVar9 * 2;
            if (uVar9 * 2 <= uVar8) {
              uVar11 = uVar8;
            }
            pcVar6 = &local_118;
            if (0x3f < local_f9) {
              pcVar6 = (char *)CONCAT71(uStack_117,local_118);
            }
            if (pcVar6 < " to compile") {
              uVar9 = local_108;
              if (local_f9 < 0x40) {
                uVar9 = 0x1f - (longlong)(char)local_f9;
              }
              if ("\' to compile" < pcVar6 + uVar9) {
                pcVar6 = &local_118;
                if (0x3f < local_f9) {
                  pcVar6 = (char *)CONCAT71(uStack_117,local_118);
                }
                pcVar7 = (char *)FUN_140056c90(&local_118,uVar11);
                *(undefined8 *)(pcVar7 + uVar10) =
                     *(undefined8 *)(pcVar7 + (longlong)"\' to compile" + -(longlong)pcVar6);
                *(undefined4 *)(pcVar7 + uVar10 + 8) =
                     *(undefined4 *)(pcVar7 + (longlong)("\' to compile" + -(longlong)pcVar6 + 8));
                goto LAB_1400c3ba1;
              }
            }
            pcVar7 = (char *)FUN_140056c90(&local_118,uVar11);
            builtin_strncpy(pcVar7 + uVar10,"\' to compile",0xc);
          }
          else {
            pcVar7 = &local_118;
            if (0x3f < local_f9) {
              pcVar7 = (char *)CONCAT71(uStack_117,local_118);
            }
            builtin_strncpy(pcVar7 + uVar10,"\' to compile",0xc);
          }
LAB_1400c3ba1:
          pcVar7[uVar8] = '\0';
          if (local_f9 < 0x40) {
            local_f9 = 0x1f - (char)uVar8;
            uVar8 = local_108;
          }
          local_108 = uVar8;
          FUN_1400545d0(&local_f0,&local_118);
          if ((local_f9 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_117,local_118),local_f8,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          if ((local_121 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(uStack_13f,local_140),local_120,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
        }
        FUN_140089820(param_7,&local_f0,param_5,param_2,param_6);
      }
      else {
        puVar3 = param_1;
        if (0x3f < *(byte *)((longlong)param_1 + 0x1f)) {
          puVar3 = (undefined8 *)*param_1;
        }
        cVar1 = *(char *)((longlong)puVar3 + local_c8 + -1);
        if ((cVar1 == '\n') || (cVar1 == '\r')) goto LAB_1400c3579;
      }
      if (*(byte *)((longlong)param_3 + 0x1f) < 0x40) {
        lVar12 = 0x1f - (longlong)*(char *)((longlong)param_3 + 0x1f);
        puVar3 = param_3;
      }
      else {
        lVar12 = param_3[2];
        puVar3 = (undefined8 *)*param_3;
      }
      local_c8 = FUN_140056850(param_1,puVar3,local_c8 + lVar12);
    } while (local_c8 != -1);
    if ((local_d1 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(uStack_ef,local_f0),local_d0,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
  }
  return;
}
```

## `ProcessFxcReflectionAndValidate` — `0x1400218e0`

FXC reflection and validation

```c
/* WARNING: Type propagation algorithm not settling */
/* FXC reflection + validation. D3DReflect (+0x38), then walks input parameters with the fixed
   semantic table (POSITION/NORMAL/TANGENT/COLOR/TEXCOORD/BLENDWEIGHTS/BLENDINDICES), constant
   buffers (0x10000-byte limit, duplicate-name check, UnityInstancing detection, D3D_SVF_USED
   filter) and bound resources (verbatim 0x28-byte binding descs). */

void ProcessFxcReflectionAndValidate
               (undefined8 param_1,undefined8 param_2,undefined8 *param_3,int param_4,
               longlong *param_5,undefined4 param_6,undefined8 param_7,longlong *param_8,
               undefined4 *param_9)

{
  undefined4 *puVar1;
  ulonglong uVar2;
  char cVar3;
  int iVar4;
  uint uVar5;
  longlong *plVar6;
  char *pcVar7;
  byte *pbVar8;
  undefined8 uVar9;
  longlong *plVar10;
  undefined1 *puVar11;
  undefined4 uVar12;
  ulonglong uVar13;
  uint *puVar14;
  undefined1 *puVar15;
  undefined4 *puVar16;
  longlong lVar17;
  longlong lVar18;
  undefined4 *puVar19;
  uint uVar20;
  ulonglong uVar21;
  byte *pbVar22;
  byte *pbVar23;
  undefined8 *puVar24;
  undefined8 *puVar25;
  bool bVar26;
  ulonglong in_stack_fffffffffffffd18;
  undefined8 uVar27;
  uint local_2c8 [2];
  longlong *local_2c0;
  undefined1 local_2b8;
  undefined7 uStack_2b7;
  uint local_2b0;
  undefined8 *local_2a8;
  undefined1 local_2a0;
  char cStack_29f;
  undefined5 uStack_29e;
  byte bStack_299;
  undefined2 local_298;
  undefined4 *local_290;
  undefined4 *puStack_288;
  undefined4 *local_280;
  ulonglong local_278;
  undefined8 local_270 [3];
  byte local_251;
  undefined2 local_250;
  uint local_248;
  uint uStack_244;
  uint uStack_240;
  uint uStack_23c;
  undefined4 local_238;
  undefined4 uStack_234;
  undefined4 uStack_230;
  undefined4 uStack_22c;
  undefined2 local_228;
  undefined6 uStack_226;
  byte local_220;
  undefined7 uStack_21f;
  ulonglong local_210;
  byte local_201;
  undefined2 local_200;
  int local_1f8;
  undefined4 uStack_1f4;
  uint local_1f0;
  undefined4 local_1ec;
  uint local_1e8;
  uint local_1e4;
  undefined4 local_1dc;
  int local_1d8;
  ulonglong local_1d0;
  undefined8 *local_1c8;
  undefined4 local_1b8 [2];
  undefined8 local_1b0 [2];
  longlong local_1a0;
  byte local_191;
  undefined2 local_190;
  undefined4 local_188;
  undefined4 local_184;
  undefined1 local_180;
  byte *local_178;
  int local_170;
  uint local_16c;
  uint local_168;
  longlong *local_160;
  undefined1 local_158 [16];
  longlong local_148;
  byte local_139;
  undefined2 local_138;
  undefined8 local_130;
  undefined4 local_128;
  uint local_124;
  byte local_120;
  undefined1 local_f8 [20];
  uint local_e4;
  uint local_e0;
  uint local_dc;
  undefined4 local_d0;
  undefined4 local_c0;
  int local_ac;
  int local_a8;
  int local_a4;
  int local_a0;
  int local_9c;
  undefined4 local_80;
  undefined1 local_58 [24];
  undefined4 local_40;
  
  local_2c0 = (longlong *)0x0;
  plVar6 = (longlong *)(**(code **)*DAT_14074ece0)();
  iVar4 = (**(code **)(*plVar6 + 0x38))(plVar6,param_1,param_2,&local_2c0);
  if (iVar4 < 0) {
    local_298 = 0x4b;
    local_2b8 = 0;
    bStack_299 = 0x1f;
    pcVar7 = (char *)FUN_140056c90(&local_2b8,0x27);
    builtin_strncpy(pcVar7,"Failed to get HLSL Reflection interface",0x28);
    if (bStack_299 < 0x40) {
      bStack_299 = 0xf8;
    }
    else {
      local_2a8 = (undefined8 *)&DAT_00000027;
    }
    FUN_140089820(param_7,&local_2b8,param_6,0,4);
    if ((bStack_299 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(uStack_2b7,local_2b8),local_298,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
  }
  else {
    (**(code **)(*local_2c0 + 0x18))(local_2c0,local_f8);
    uVar12 = 0;
    if (param_4 == 4) {
      uVar12 = local_80;
    }
    *param_9 = uVar12;
    if ((param_4 == 0) && (uVar20 = 0, local_dc != 0)) {
      do {
        (**(code **)(*local_2c0 + 0x38))(local_2c0,uVar20,&local_2b8);
        bVar26 = cStack_29f != '\0';
        if (local_2b0 == 0) {
          iVar4 = _stricmp((char *)CONCAT71(uStack_2b7,local_2b8),"POSITION");
          if (iVar4 == 0) {
            (**(code **)(*param_5 + 8))(param_5,0,bVar26 - 1);
          }
          else {
            if (local_2b0 != 0) goto LAB_140021b94;
            iVar4 = _stricmp((char *)CONCAT71(uStack_2b7,local_2b8),"NORMAL");
            if (iVar4 == 0) {
              (**(code **)(*param_5 + 8))(param_5,1,(uint)bVar26 * 2 + -1);
            }
            else {
              if (local_2b0 != 0) goto LAB_140021b94;
              iVar4 = _stricmp((char *)CONCAT71(uStack_2b7,local_2b8),"TANGENT");
              if (iVar4 == 0) {
                uVar9 = 0xffffffff;
                if (bVar26) {
                  uVar9 = 2;
                }
                (**(code **)(*param_5 + 8))(param_5,2,uVar9);
              }
              else {
                if ((local_2b0 != 0) ||
                   (iVar4 = _stricmp((char *)CONCAT71(uStack_2b7,local_2b8),"COLOR"), iVar4 != 0))
                goto LAB_140021b94;
                (**(code **)(*param_5 + 8))(param_5,3,(uint)bVar26 * 4 + -1);
              }
            }
          }
        }
        else {
LAB_140021b94:
          if ((local_2b0 < 8) &&
             (iVar4 = _stricmp((char *)CONCAT71(uStack_2b7,local_2b8),"TEXCOORD"), iVar4 == 0)) {
            iVar4 = local_2b0 + 5;
            if (!bVar26) {
              iVar4 = -1;
            }
            (**(code **)(*param_5 + 8))(param_5,local_2b0 + 4,iVar4);
          }
          else if (local_2b0 == 0) {
            iVar4 = _stricmp((char *)CONCAT71(uStack_2b7,local_2b8),"BLENDWEIGHTS");
            if (iVar4 == 0) {
              uVar9 = 0xffffffff;
              if (bVar26) {
                uVar9 = 0x1d;
              }
              (**(code **)(*param_5 + 8))(param_5,0xc,uVar9);
            }
            else {
              if ((local_2b0 != 0) ||
                 (iVar4 = _stricmp((char *)CONCAT71(uStack_2b7,local_2b8),"BLENDINDICES"),
                 iVar4 != 0)) goto LAB_140021c50;
              uVar9 = 0xffffffff;
              if (bVar26) {
                uVar9 = 0x1e;
              }
              (**(code **)(*param_5 + 8))(param_5,0xd,uVar9);
            }
          }
          else {
LAB_140021c50:
            iVar4 = strncmp((char *)CONCAT71(uStack_2b7,local_2b8),"SV_",3);
            if (iVar4 == 0) {
              iVar4 = _stricmp((char *)CONCAT71(uStack_2b7,local_2b8),"SV_POSITION");
              uVar12 = (undefined4)(in_stack_fffffffffffffd18 >> 0x20);
              if (iVar4 == 0) {
                puVar25 = param_3;
                if (0x3f < *(byte *)((longlong)param_3 + 0x1f)) {
                  puVar25 = (undefined8 *)*param_3;
                }
                FUN_1400e0f60(&local_1f8,
                              "Vertex program \'%s\': input semantic SV_POSITION is used; you probably want POSITION instead"
                              ,puVar25);
                in_stack_fffffffffffffd18 = CONCAT44(uVar12,4);
                FUN_140089820(param_7,&local_1f8,param_6,1,in_stack_fffffffffffffd18);
                if ((local_1dc._3_1_ & 0xc0) == 0x40) {
                  thunk_FUN_1403f2404(CONCAT44(uStack_1f4,local_1f8),(undefined2)local_1d8,
                                      "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                      ,0x218);
                }
              }
            }
            else if ((local_2b0 != 1) ||
                    (iVar4 = _stricmp((char *)CONCAT71(uStack_2b7,local_2b8),"POSITION"), iVar4 != 0
                    )) {
              puVar25 = param_3;
              if (0x3f < *(byte *)((longlong)param_3 + 0x1f)) {
                puVar25 = (undefined8 *)*param_3;
              }
              uVar9 = CONCAT71(uStack_2b7,local_2b8);
              FUN_1400e0f60(&local_1f8,"%s program \'%s\': unknown input semantics %s/%i\n",
                            PTR_s_Vertex_140728028,puVar25,uVar9,local_2b0);
              in_stack_fffffffffffffd18 = CONCAT44((int)((ulonglong)uVar9 >> 0x20),4);
              FUN_140089820(param_7,&local_1f8,param_6,0,in_stack_fffffffffffffd18);
              if ((local_1dc._3_1_ & 0xc0) == 0x40) {
                thunk_FUN_1403f2404(CONCAT44(uStack_1f4,local_1f8),(undefined2)local_1d8,
                                    "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                    ,0x218);
              }
            }
          }
        }
        uVar20 = uVar20 + 1;
      } while (uVar20 < local_dc);
    }
    local_278 = CONCAT62(local_278._2_6_,1);
    FUN_140015080(&local_2b8,local_e4,&local_278);
    local_2c8[0] = 0;
    puVar25 = local_2a8;
    if (local_e4 != 0) {
      do {
        local_160 = (longlong *)(**(code **)(*local_2c0 + 0x20))();
        (**(code **)*local_160)(local_160,&local_178);
        pbVar23 = local_178;
        local_200 = 0x4b;
        local_220 = 0;
        local_201 = 0x1f;
        uVar21 = 0xffffffffffffffff;
        do {
          uVar21 = uVar21 + 1;
        } while (local_178[uVar21] != 0);
        if ((local_178 < &local_220) || (&local_220 <= local_178)) {
          local_220 = 0;
          local_201 = 0x1f;
          pbVar22 = (byte *)FUN_140056c90(&local_220,uVar21);
          FUN_140558820(pbVar22,pbVar23,uVar21);
        }
        else {
          pbVar22 = &local_220;
          FUN_140558820(&local_220,local_178,uVar21);
        }
        uVar12 = (undefined4)(in_stack_fffffffffffffd18 >> 0x20);
        pbVar22[uVar21] = 0;
        if (local_201 < 0x40) {
          local_201 = 0x1f - (char)uVar21;
        }
        else {
          local_210 = uVar21;
        }
        puVar24 = (undefined8 *)0x0;
        if (puVar25 != (undefined8 *)0x0) {
          pbVar23 = (byte *)(CONCAT71(uStack_2b7,local_2b8) + 0x1f);
          do {
            uVar21 = local_210;
            if (local_201 < 0x40) {
              uVar21 = 0x1f - (longlong)(char)local_201;
            }
            if (*pbVar23 < 0x40) {
              uVar13 = 0x1f - (longlong)(char)*pbVar23;
            }
            else {
              uVar13 = *(ulonglong *)(pbVar23 + -0xf);
            }
            if (uVar21 == uVar13) {
              if (*pbVar23 < 0x40) {
                uVar21 = 0x1f - (longlong)(char)*pbVar23;
                pbVar22 = pbVar23 + -0x1f;
              }
              else {
                uVar21 = *(ulonglong *)(pbVar23 + -0xf);
                pbVar22 = *(byte **)(pbVar23 + -0x1f);
              }
              uVar13 = local_210;
              if (local_201 < 0x40) {
                uVar13 = 0x1f - (longlong)(char)local_201;
              }
              pbVar8 = &local_220;
              if (0x3f < local_201) {
                pbVar8 = (byte *)CONCAT71(uStack_21f,local_220);
              }
              uVar2 = uVar13;
              if (uVar21 < uVar13) {
                uVar2 = uVar21;
              }
              for (; uVar2 != 0; uVar2 = uVar2 - 1) {
                if (*pbVar8 != *pbVar22) {
                  iVar4 = (uint)*pbVar8 - (uint)*pbVar22;
                  goto LAB_140021f3b;
                }
                pbVar8 = pbVar8 + 1;
                pbVar22 = pbVar22 + 1;
              }
              iVar4 = (int)uVar13 - (int)uVar21;
LAB_140021f3b:
              if (iVar4 == 0) {
                pbVar23 = &local_220;
                if (0x3f < local_201) {
                  pbVar23 = (byte *)CONCAT71(uStack_21f,local_220);
                }
                uVar9 = FUN_1400e0f60(local_270,"Duplicate constant buffer declaration: %s",pbVar23)
                ;
                in_stack_fffffffffffffd18 = CONCAT44(uVar12,0x1c);
                FUN_140089820(param_7,uVar9,0,0,in_stack_fffffffffffffd18);
                if ((local_251 & 0xc0) == 0x40) {
                  thunk_FUN_1403f2404(local_270[0],local_250,
                                      "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                      ,0x218);
                }
                goto LAB_140022475;
              }
            }
            puVar24 = (undefined8 *)((longlong)puVar24 + 1);
            pbVar23 = pbVar23 + 0x28;
          } while (puVar24 < puVar25);
        }
        puVar25 = (undefined8 *)((longlong)puVar25 + 1);
        local_1c8 = puVar25;
        if ((undefined8 *)
            (CONCAT17(bStack_299,CONCAT52(uStack_29e,CONCAT11(cStack_29f,local_2a0))) >> 1) <
            puVar25) {
          FUN_1400575b0(&local_2b8);
        }
        local_278 = (CONCAT71(uStack_2b7,local_2b8) + (longlong)puVar25 * 0x28) - 0x28;
        local_2a8 = puVar25;
        local_1d0 = local_278;
        if (local_278 != 0) {
          FUN_140014a90(local_278,&local_220,(undefined2)local_2b0);
        }
        uVar12 = (undefined4)(in_stack_fffffffffffffd18 >> 0x20);
        if (local_170 == 0) {
          if (local_168 < 0x10001) {
            (**(code **)(*param_5 + 0x10))(param_5,local_178,local_168,local_16c);
            local_278 = local_278 & 0xffffffff00000000;
            uVar20 = 0;
            local_1d0 = local_1d0 & 0xffffffff00000000;
            plVar6 = local_160;
            if (local_16c != 0) {
              do {
                plVar10 = (longlong *)(**(code **)(*plVar6 + 8))(plVar6,uVar20);
                (**(code **)*plVar10)(plVar10,&local_130);
                uVar12 = (undefined4)(in_stack_fffffffffffffd18 >> 0x20);
                if ((local_120 & 2) != 0) {
                  puVar25 = (undefined8 *)(**(code **)(*plVar10 + 8))(plVar10);
                  (**(code **)*puVar25)(puVar25,&local_1f8);
                  if (local_1f8 == 5) {
                    iVar4 = strncmp((char *)local_178,"UnityInstancing",0xf);
                    if (iVar4 == 0) {
                      uVar5 = local_124;
                      if (1 < local_1e8) {
                        uVar5 = (local_124 + 0xf & 0xfffffff0) / local_1e8;
                      }
                      in_stack_fffffffffffffd18 = CONCAT44(uVar12,2);
                      (**(code **)(*param_5 + 0x18))
                                (param_5,local_130,local_128,0,in_stack_fffffffffffffd18,uVar5,1,
                                 local_1e8);
                      uVar5 = 0;
                      if (local_1e4 != 0) {
                        do {
                          plVar6 = (longlong *)(**(code **)(*plVar10 + 8))(plVar10);
                          puVar25 = (undefined8 *)(**(code **)(*plVar6 + 8))(plVar6,uVar5);
                          (**(code **)*puVar25)(puVar25,local_58);
                          plVar6 = (longlong *)(**(code **)(*plVar10 + 8))(plVar10);
                          uVar9 = (**(code **)(*plVar6 + 0x18))(plVar6,uVar5);
                          FUN_1400e0f60(&local_248,"%s.%s",local_130,uVar9);
                          puVar14 = &local_248;
                          if (0x3f < uStack_22c._3_1_) {
                            puVar14 = (uint *)CONCAT44(uStack_244,local_248);
                          }
                          in_stack_fffffffffffffd18 = in_stack_fffffffffffffd18 & 0xffffffff00000000
                          ;
                          cVar3 = FUN_14004adf0(param_5,local_58,puVar14,local_40,
                                                in_stack_fffffffffffffd18,&local_278);
                          if (cVar3 == '\0') {
                            puVar14 = &local_248;
                            if (0x3f < uStack_22c._3_1_) {
                              puVar14 = (uint *)CONCAT44(uStack_244,local_248);
                            }
                            puVar25 = param_3;
                            if (0x3f < *(byte *)((longlong)param_3 + 0x1f)) {
                              puVar25 = (undefined8 *)*param_3;
                            }
                            FUN_1400e0f60(local_270,
                                          "%s program \'%s\': Ignore instancing property \'%s\' because the data type is not supported.\n"
                                          ,(&PTR_s_Vertex_140728028)[param_4],puVar25,puVar14);
                            in_stack_fffffffffffffd18 =
                                 CONCAT44((int)((ulonglong)puVar14 >> 0x20),4);
                            FUN_140089820(param_7,local_270,param_6,1,in_stack_fffffffffffffd18);
                            if ((local_251 & 0xc0) == 0x40) {
                              thunk_FUN_1403f2404(local_270[0],local_250,
                                                  "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                                 );
                            }
                          }
                          if ((uStack_22c._3_1_ & 0xc0) == 0x40) {
                            thunk_FUN_1403f2404(CONCAT44(uStack_244,local_248),local_228,
                                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                               );
                          }
                          uVar5 = uVar5 + 1;
                        } while (uVar5 < local_1e4);
                        plVar6 = local_160;
                        uVar20 = (uint)local_1d0;
                      }
                    }
                    else {
                      puVar25 = param_3;
                      if (0x3f < *(byte *)((longlong)param_3 + 0x1f)) {
                        puVar25 = (undefined8 *)*param_3;
                      }
                      uVar9 = local_130;
                      FUN_1400e0f60(&local_248,
                                    "%s program \'%s\': Struct variable \'%s\' is ignored. Only instancing constant buffers can have struct variables\n"
                                    ,(&PTR_s_Vertex_140728028)[param_4],puVar25,local_130);
                      in_stack_fffffffffffffd18 = CONCAT44((int)((ulonglong)uVar9 >> 0x20),4);
                      FUN_140089820(param_7,&local_248,param_6,0,in_stack_fffffffffffffd18);
                      if ((uStack_22c._3_1_ & 0xc0) == 0x40) {
                        thunk_FUN_1403f2404(CONCAT44(uStack_244,local_248),local_228,
                                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                           );
                      }
                    }
                  }
                  else {
                    in_stack_fffffffffffffd18 = CONCAT44(uVar12,local_124);
                    FUN_14004adf0(param_5,&local_1f8,local_130,local_128,in_stack_fffffffffffffd18,
                                  &local_278);
                  }
                }
                uVar20 = uVar20 + 1;
                local_1d0 = CONCAT44(local_1d0._4_4_,uVar20);
                puVar25 = local_1c8;
              } while (uVar20 < local_16c);
            }
          }
          else {
            uVar27 = CONCAT44(uVar12,local_168);
            uVar9 = FUN_1400e0f60(local_270,
                                  "Compilation failed: The maximum size for Constant Buffers is %d bytes. Constant Buffer \"%s\" (%d bytes) exceeded the maximum size."
                                  ,0x10000,local_178,uVar27);
            in_stack_fffffffffffffd18 = CONCAT44((int)((ulonglong)uVar27 >> 0x20),0x1c);
            FUN_140089820(param_7,uVar9,0,0,in_stack_fffffffffffffd18);
            if ((local_251 & 0xc0) == 0x40) {
              thunk_FUN_1403f2404(local_270[0],local_250,
                                  "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                  ,0x218);
            }
          }
        }
        else if (local_170 != 3) {
          puVar24 = param_3;
          if (0x3f < *(byte *)((longlong)param_3 + 0x1f)) {
            puVar24 = (undefined8 *)*param_3;
          }
          FUN_1400e0f60(local_270,
                        "%s program \'%s\': only scalar constant buffers supported right now\n",
                        (&PTR_s_Vertex_140728028)[param_4],puVar24);
          in_stack_fffffffffffffd18 = CONCAT44(uVar12,4);
          FUN_140089820(param_7,local_270,param_6,0,in_stack_fffffffffffffd18);
          if ((local_251 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(local_270[0],local_250,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
        }
LAB_140022475:
        if ((local_201 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(CONCAT71(uStack_21f,local_220),local_200,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
        }
        local_2c8[0] = local_2c8[0] + 1;
      } while (local_2c8[0] < local_e4);
    }
    local_290 = (undefined4 *)0x0;
    puStack_288 = (undefined4 *)0x0;
    local_280 = (undefined4 *)0x0;
    uVar20 = 0;
    if (local_e0 != 0) {
      do {
        (**(code **)(*local_2c0 + 0x30))(local_2c0,uVar20,&local_1f8);
        if ((local_1f0 < 8) && ((0xa4U >> (local_1f0 & 0x1f) & 1) != 0)) {
          local_190 = 0x4b;
          local_1b0[0]._0_1_ = 0;
          local_191 = 0x1f;
          local_1b8[0] = local_1ec;
          puVar15 = (undefined1 *)CONCAT44(uStack_1f4,local_1f8);
          lVar17 = -1;
          do {
            lVar17 = lVar17 + 1;
          } while (puVar15[lVar17] != '\0');
          if ((puVar15 < local_1b0) || (local_1b0 <= puVar15)) {
            local_1b0[0]._0_1_ = 0;
            local_191 = 0x1f;
            puVar11 = (undefined1 *)FUN_140056c90(local_1b0,lVar17);
            FUN_140558820(puVar11,puVar15,lVar17);
          }
          else {
            puVar11 = (undefined1 *)local_1b0;
            FUN_140558820(local_1b0,puVar15,lVar17);
          }
          puVar16 = puStack_288;
          puVar11[lVar17] = 0;
          if (local_191 < 0x40) {
            local_191 = 0x1f - (char)lVar17;
            lVar17 = local_1a0;
          }
          local_1a0 = lVar17;
          local_188 = local_1dc;
          local_184 = 0xffffffff;
          local_180 = local_1d8 != -1;
          if (puStack_288 == local_280) {
            FUN_14000aad0(&local_290,puStack_288,local_1b8);
          }
          else {
            *puStack_288 = local_1b8[0];
            local_1c8 = (undefined8 *)(puStack_288 + 2);
            *(undefined2 *)(puStack_288 + 10) = local_190;
            *(undefined1 *)local_1c8 = 0;
            *(undefined1 *)((longlong)puStack_288 + 0x27) = 0x1f;
            if (local_1c8 != local_1b0) {
              lVar17 = local_1a0;
              if (local_191 < 0x40) {
                lVar17 = 0x1f - (longlong)(char)local_191;
              }
              puVar15 = (undefined1 *)local_1b0;
              if (0x3f < local_191) {
                puVar15 = (undefined1 *)CONCAT71(local_1b0[0]._1_7_,(undefined1)local_1b0[0]);
              }
              FUN_140054780(local_1c8,puVar15,lVar17);
            }
            puVar16[0xc] = local_188;
            puVar16[0xd] = local_184;
            *(undefined1 *)(puVar16 + 0xe) = local_180;
            puStack_288 = puStack_288 + 0x10;
          }
          if ((local_191 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT71(local_1b0[0]._1_7_,(undefined1)local_1b0[0]),local_190,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
        }
        uVar20 = uVar20 + 1;
      } while (uVar20 < local_e0);
    }
    uVar20 = 0;
    if (local_e0 != 0) {
      do {
        (**(code **)(*local_2c0 + 0x30))(local_2c0,uVar20,&local_1f8);
        if (local_1f0 == 3) {
          bVar26 = false;
          uVar21 = 0;
          if ((longlong)puStack_288 - (longlong)local_290 >> 6 != 0) {
            lVar17 = 0;
            do {
              puVar25 = (undefined8 *)((longlong)local_290 + lVar17 + 8);
              if (0x3f < *(byte *)((longlong)puVar25 + 0x1f)) {
                puVar25 = (undefined8 *)*puVar25;
              }
              cVar3 = FUN_1400b8430(puVar25,CONCAT44(uStack_1f4,local_1f8));
              if (cVar3 != '\0') {
                *(undefined4 *)(lVar17 + 0x34 + (longlong)local_290) = local_1ec;
                bVar26 = true;
              }
              uVar21 = uVar21 + 1;
              lVar17 = lVar17 + 0x40;
            } while (uVar21 < (ulonglong)((longlong)puStack_288 - (longlong)local_290 >> 6));
            if (bVar26) goto LAB_1400228c2;
          }
          local_228 = 0x4b;
          local_248 = local_248 & 0xffffff00;
          uStack_22c = CONCAT13(0x1f,(undefined3)uStack_22c);
          local_1c8 = (undefined8 *)local_158;
          puVar25 = (undefined8 *)CONCAT44(uStack_1f4,local_1f8);
          local_138 = 0x4b;
          local_158[0] = 0;
          local_139 = 0x1f;
          lVar17 = -1;
          do {
            lVar17 = lVar17 + 1;
          } while (*(char *)((longlong)puVar25 + lVar17) != '\0');
          if ((puVar25 < local_158) || (local_158 <= puVar25)) {
            puVar24 = (undefined8 *)FUN_140056c90(local_158,lVar17);
            FUN_140558820(puVar24,puVar25,lVar17);
          }
          else {
            puVar24 = (undefined8 *)local_158;
            FUN_140558820(local_158,puVar25,lVar17);
          }
          *(undefined1 *)((longlong)puVar24 + lVar17) = 0;
          if (local_139 < 0x40) {
            local_139 = 0x1f - (char)lVar17;
            lVar17 = local_148;
          }
          local_148 = lVar17;
          FUN_1400c3cf0(local_2c8,local_158,&local_248);
          if (local_2c8[0] < 0x1000) {
            (**(code **)(*param_5 + 0x30))(param_5,local_2c8[0],local_1ec);
          }
          else {
            puVar14 = &local_248;
            if (0x3f < uStack_22c._3_1_) {
              puVar14 = (uint *)CONCAT44(uStack_244,local_248);
            }
            puVar25 = param_3;
            if (0x3f < *(byte *)((longlong)param_3 + 0x1f)) {
              puVar25 = (undefined8 *)*param_3;
            }
            FUN_1400e0f60(local_270,"%s program \'%s\': %s.\n",(&PTR_s_Vertex_140728028)[param_4],
                          puVar25,puVar14);
            FUN_140089820(param_7,local_270,param_6,0,4);
            if ((local_251 & 0xc0) == 0x40) {
              thunk_FUN_1403f2404(local_270[0],local_250,
                                  "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                  ,0x218);
            }
          }
          if ((uStack_22c._3_1_ & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(CONCAT44(uStack_244,local_248),local_228,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
        }
LAB_1400228c2:
        uVar20 = uVar20 + 1;
      } while (uVar20 < local_e0);
    }
    uVar13 = (ulonglong)local_e0;
    uVar21 = (param_8[1] - *param_8) / 0x28;
    if (uVar13 < uVar21) {
      param_8[1] = *param_8 + uVar13 * 0x28;
    }
    else if (uVar21 < uVar13) {
      if ((ulonglong)((param_8[2] - *param_8) / 0x28) < uVar13) {
        FUN_14000f070(param_8,uVar13,&local_278);
      }
      else {
        lVar17 = param_8[1];
        if (uVar13 - uVar21 != 0) {
          lVar18 = (uVar13 - uVar21) * 0x28;
          FUN_140558460(lVar17,0,lVar18);
          lVar17 = lVar17 + lVar18;
        }
        param_8[1] = lVar17;
      }
    }
    uVar21 = 0;
    if (local_e0 != 0) {
      do {
        (**(code **)(*local_2c0 + 0x30))(local_2c0,uVar21,&local_248);
        lVar17 = *param_8;
        puVar14 = (uint *)(lVar17 + uVar21 * 0x28);
        *puVar14 = local_248;
        puVar14[1] = uStack_244;
        puVar14[2] = uStack_240;
        puVar14[3] = uStack_23c;
        puVar16 = (undefined4 *)(lVar17 + 0x10 + uVar21 * 0x28);
        *puVar16 = local_238;
        puVar16[1] = uStack_234;
        puVar16[2] = uStack_230;
        puVar16[3] = uStack_22c;
        *(ulonglong *)(lVar17 + 0x20 + uVar21 * 0x28) = CONCAT62(uStack_226,local_228);
        switch(uStack_240) {
        case 0:
          (**(code **)(*param_5 + 0x20))(param_5,CONCAT44(uStack_244,local_248),uStack_23c);
          break;
        default:
          puVar25 = param_3;
          if (0x3f < *(byte *)((longlong)param_3 + 0x1f)) {
            puVar25 = (undefined8 *)*param_3;
          }
          FUN_1400e0f60(local_270,"%s program \'%s\': unrecognized resource binding %i\n",
                        (&PTR_s_Vertex_140728028)[param_4],puVar25,uStack_240);
          FUN_140089820(param_7,local_270,param_6,0,4);
          if ((local_251 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(local_270[0],local_250,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          break;
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        case 10:
        case 0xb:
          break;
        }
        uVar20 = (int)uVar21 + 1;
        uVar21 = (ulonglong)uVar20;
      } while (uVar20 < local_e0);
    }
    uVar21 = 0;
    if ((longlong)puStack_288 - (longlong)local_290 >> 6 != 0) {
      lVar17 = 0;
      do {
        puVar16 = (undefined4 *)((longlong)local_290 + lVar17);
        if (puVar16[0xc] == 1) {
          puVar25 = (undefined8 *)(puVar16 + 2);
          if (0x3f < *(byte *)((longlong)puVar16 + 0x27)) {
            puVar25 = (undefined8 *)*puVar25;
          }
          (**(code **)(*param_5 + 0x38))(param_5,puVar25,*puVar16,1);
        }
        else {
          switch(puVar16[0xc]) {
          case 4:
          case 6:
            uVar12 = 2;
            break;
          case 5:
          case 7:
            uVar12 = 5;
            break;
          case 8:
            uVar12 = 3;
            break;
          case 9:
            uVar12 = 4;
            break;
          case 10:
            uVar12 = 6;
            break;
          default:
            plVar6 = (longlong *)(puVar16 + 2);
            if (0x3f < *(byte *)((longlong)puVar16 + 0x27)) {
              plVar6 = (longlong *)*plVar6;
            }
            puVar25 = param_3;
            if (0x3f < *(byte *)((longlong)param_3 + 0x1f)) {
              puVar25 = (undefined8 *)*param_3;
            }
            FUN_1400e0f60(local_270,"%s program \'%s\': unrecognized sampler dimension (%i) in %s",
                          (&PTR_s_Vertex_140728028)[param_4],puVar25,puVar16[0xc],plVar6);
            FUN_140089820(param_7,local_270,param_6,0,4);
            if ((local_251 & 0xc0) == 0x40) {
              thunk_FUN_1403f2404(local_270[0],local_250,
                                  "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                  ,0x218);
            }
            goto LAB_140022bcd;
          }
          puVar25 = (undefined8 *)(puVar16 + 2);
          if (0x3f < *(byte *)((longlong)puVar16 + 0x27)) {
            puVar25 = (undefined8 *)*puVar25;
          }
          (**(code **)(*param_5 + 0x28))
                    (param_5,puVar25,*puVar16,puVar16[0xd],*(undefined1 *)(puVar16 + 0xe),uVar12);
        }
LAB_140022bcd:
        uVar21 = uVar21 + 1;
        lVar17 = lVar17 + 0x40;
      } while (uVar21 < (ulonglong)((longlong)puStack_288 - (longlong)local_290 >> 6));
    }
    (**(code **)(*param_5 + 0x48))
              (param_5,local_a8 + local_a4 + local_ac,local_c0,local_a0 + local_9c + -1,local_d0);
    (**(code **)(*local_2c0 + 0x10))();
    puVar16 = puStack_288;
    if (local_290 != (undefined4 *)0x0) {
      if (local_290 != puStack_288) {
        puVar19 = local_290 + 10;
        do {
          if ((*(byte *)((longlong)puVar19 + -1) & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(*(undefined8 *)(puVar19 + -8),*(undefined2 *)puVar19,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                ,0x218);
          }
          puVar1 = puVar19 + 6;
          puVar19 = puVar19 + 0x10;
        } while (puVar1 != puVar16);
      }
      uVar21 = (longlong)local_280 - (longlong)local_290 & 0xffffffffffffffc0;
      puVar16 = local_290;
      if (0xfff < uVar21) {
        puVar16 = *(undefined4 **)(local_290 + -2);
        if (0x1f < ((longlong)local_290 - (longlong)puVar16) - 8U) {
                    /* WARNING: Subroutine does not return */
          FUN_1403de184((longlong)local_290 - (longlong)puVar16,uVar21 + 0x27);
        }
      }
      thunk_FUN_1403f2404(puVar16);
      local_290 = (undefined4 *)0x0;
      puStack_288 = (undefined4 *)0x0;
      local_280 = (undefined4 *)0x0;
    }
    FUN_140018ba0(&local_2b8);
  }
  return;
}
```

## `CheckForceDxcOnSwitch` — `0x140039af0`

`FORCE_DXC_ON_SWITCH*` decision

```c
byte CheckForceDxcOnSwitch(uint param_1,longlong *param_2,undefined8 *param_3)

{
  byte *pbVar1;
  longlong lVar2;
  char cVar3;
  int iVar4;
  char *pcVar5;
  undefined1 *puVar6;
  byte *pbVar7;
  byte *pbVar8;
  byte bVar9;
  byte bVar10;
  byte local_68;
  undefined7 uStack_67;
  longlong local_58;
  byte local_49;
  undefined2 local_48;
  byte local_40;
  undefined7 uStack_3f;
  longlong local_30;
  byte local_21;
  undefined2 local_20;
  
  bVar9 = 0;
  if (*(uint *)(param_2 + 4) != param_1) goto LAB_140039c18;
  (**(code **)(*param_2 + 0x28))(param_2,0);
  (**(code **)(*param_2 + 0x28))(param_2,1);
  pcVar5 = (char *)(**(code **)(*param_2 + 0x28))(param_2,2);
  bVar9 = 4;
  if (*pcVar5 == '\0') {
    bVar9 = 0;
  }
  pcVar5 = (char *)(**(code **)(*param_2 + 0x28))(param_2,3);
  bVar10 = bVar9 | 8;
  if (*pcVar5 == '\0') {
    bVar10 = bVar9;
  }
  pcVar5 = (char *)(**(code **)(*param_2 + 0x28))(param_2,4);
  cVar3 = *pcVar5;
  (**(code **)(*param_2 + 0x28))(param_2,5);
  (**(code **)(*param_2 + 0x28))(param_2,6);
  if ((((param_2[5] & 0xf7fc00000U) != 0) ||
      ((*(uint *)((longlong)param_2 + 0x5c) >> (param_1 & 0x1f) & 1) != 0)) &&
     ((*(uint *)(param_2 + 0xc) >> (param_1 & 0x1f) & 1) == 0)) {
    bVar9 = 1;
    if (param_1 != 9) goto LAB_140039c18;
    if (bVar10 == 0) {
      if (cVar3 == '\0') goto LAB_140039c18;
      if (param_3 != (undefined8 *)0x0) {
        pcVar5 = 
        "DXC: compiling geometry shaders with DXC is unsupported for the GLES3 target. Will fall back to using the FXC compiler for all shader stages."
        ;
        goto LAB_140039c13;
      }
    }
    else if (param_3 != (undefined8 *)0x0) {
      pcVar5 = 
      "DXC: compiling tessellation shaders with DXC is unsupported for the GLES3 target. Will fall back to using the FXC compiler for all shader stages."
      ;
LAB_140039c13:
      *param_3 = pcVar5;
    }
  }
  bVar9 = 0;
LAB_140039c18:
  if (param_1 == 0x13) {
    local_48 = 0x4b;
    local_68 = 0;
    local_49 = 0x1f;
    puVar6 = (undefined1 *)FUN_140056c90(&local_68,0);
    *puVar6 = 0;
    if (local_49 < 0x40) {
      local_49 = 0x1f;
    }
    else {
      local_58 = 0;
    }
    cVar3 = FUN_14008e8b0("FORCE_DXC_ON_SWITCH",&local_68);
    if (cVar3 != '\0') {
      pbVar8 = (byte *)CONCAT71(uStack_67,local_68);
      lVar2 = local_58;
      if (local_49 < 0x40) {
        pbVar8 = &local_68;
        lVar2 = 0x1f - (longlong)(char)local_49;
      }
      pbVar7 = &DAT_140578fc4;
      pbVar1 = pbVar8 + lVar2;
      for (; pbVar8 < pbVar1; pbVar8 = pbVar8 + 1) {
        if (*pbVar8 != *pbVar7) {
          iVar4 = (uint)*pbVar8 - (uint)*pbVar7;
          goto LAB_140039ccc;
        }
        if (*pbVar7 == 0) goto LAB_140039cdc;
        pbVar7 = pbVar7 + 1;
      }
      iVar4 = -(uint)*pbVar7;
LAB_140039ccc:
      if (iVar4 == 0) {
        bVar9 = ~(byte)(*(uint *)(param_2 + 0xc) >> 0x13) & 1;
      }
    }
LAB_140039cdc:
    if ((local_49 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404((byte *)CONCAT71(uStack_67,local_68),local_48,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
  }
  else if (param_1 == 0x1b) {
    local_20 = 0x4b;
    local_40 = 0;
    local_21 = 0x1f;
    puVar6 = (undefined1 *)FUN_140056c90(&local_40,0);
    *puVar6 = 0;
    if (local_21 < 0x40) {
      local_21 = 0x1f;
    }
    else {
      local_30 = 0;
    }
    cVar3 = FUN_14008e8b0("FORCE_DXC_ON_SWITCH2",&local_40);
    if (cVar3 != '\0') {
      pbVar8 = (byte *)CONCAT71(uStack_3f,local_40);
      lVar2 = local_30;
      if (local_21 < 0x40) {
        pbVar8 = &local_40;
        lVar2 = 0x1f - (longlong)(char)local_21;
      }
      pbVar7 = &DAT_140578fc4;
      pbVar1 = pbVar8 + lVar2;
      for (; pbVar8 < pbVar1; pbVar8 = pbVar8 + 1) {
        if (*pbVar8 != *pbVar7) {
          iVar4 = (uint)*pbVar8 - (uint)*pbVar7;
          goto LAB_140039dbc;
        }
        if (*pbVar7 == 0) goto LAB_140039dcc;
        pbVar7 = pbVar7 + 1;
      }
      iVar4 = -(uint)*pbVar7;
LAB_140039dbc:
      if (iVar4 == 0) {
        bVar9 = ~(byte)((uint)(int)param_2[0xc] >> 0x1b) & 1;
      }
    }
LAB_140039dcc:
    if ((local_21 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404((byte *)CONCAT71(uStack_3f,local_40),local_20,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
  }
  return bVar9;
}
```

## `ProcessDxbcDisassemble` — `0x140039190`

DXBC / SPIR-V disassembler

```c
/* DXBC disassembler used by "Cmd: disassembleShader". Emits "// Failed to disassemble shader" / "//
   Invalid bytecode blob found" on bad input. */

longlong ProcessDxbcDisassemble(longlong *param_1)

{
  longlong lVar1;
  char cVar2;
  undefined1 uVar3;
  int iVar4;
  longlong lVar5;
  undefined8 *puVar6;
  char *pcVar7;
  longlong *plVar8;
  char *pcVar9;
  longlong lVar10;
  longlong *local_res10;
  longlong local_res18;
  undefined8 in_stack_ffffffffffffffa8;
  undefined4 uVar11;
  undefined1 local_48;
  undefined7 uStack_47;
  undefined8 local_38;
  byte local_29;
  undefined2 local_28;
  
  uVar11 = (undefined4)((ulonglong)in_stack_ffffffffffffffa8 >> 0x20);
  local_res18 = FUN_1400e40a0(0xa0);
  if (local_res18 == 0) {
    lVar5 = 0;
  }
  else {
    lVar5 = FUN_140015e50(local_res18,(int)param_1[4],1);
  }
  puVar6 = (undefined8 *)(**(code **)*DAT_14074ece0)();
  cVar2 = (**(code **)*puVar6)(puVar6);
  if (cVar2 == '\0') {
    lVar10 = param_1[4];
    lVar1 = param_1[2];
    local_28 = 0x4b;
    local_48 = 0;
    local_29 = 0x1f;
    pcVar7 = (char *)FUN_140056c90(&local_48,0x29);
    builtin_strncpy(pcVar7,"D3D11 shader compiler could not be loaded",0x2a);
    if (local_29 < 0x40) {
      local_29 = 0xf6;
    }
    else {
      local_38 = 0x29;
    }
    FUN_140089820(lVar5 + 0x90,&local_48,(int)lVar1,0,CONCAT44(uVar11,(int)lVar10));
    if ((local_29 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(uStack_47,local_48),local_28,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
  }
  else {
    plVar8 = (longlong *)(**(code **)*DAT_14074ece0)();
    uVar3 = (**(code **)(*plVar8 + 0x10))(plVar8);
    plVar8 = (longlong *)(**(code **)*DAT_14074ece0)();
    (**(code **)(*plVar8 + 8))(plVar8,1);
    local_res10 = (longlong *)0x0;
    pcVar9 = (char *)(**(code **)(*param_1 + 0x40))(param_1);
    lVar10 = (**(code **)(*param_1 + 0x48))(param_1);
    pcVar7 = pcVar9 + lVar10;
    if ((pcVar9 != (char *)0x0) && (pcVar7 != pcVar9)) {
      lVar10 = 0;
      cVar2 = *pcVar9;
      if (cVar2 == '\0') {
        lVar10 = 1;
      }
      else if (cVar2 == '\x01') {
        lVar10 = 6;
      }
      else if (cVar2 == '\x02') {
        lVar10 = 0x26;
      }
      pcVar9 = pcVar9 + lVar10;
      if (pcVar9 < pcVar7) {
        plVar8 = (longlong *)(**(code **)*DAT_14074ece0)();
        iVar4 = (**(code **)(*plVar8 + 0x28))
                          (plVar8,pcVar9,(longlong)pcVar7 - (longlong)pcVar9,4,0,&local_res10);
        if ((iVar4 < 0) || (local_res10 == (longlong *)0x0)) {
          lVar10 = 0x1f;
          pcVar7 = "// Failed to disassemble shader";
        }
        else {
          pcVar7 = (char *)(**(code **)(*local_res10 + 0x18))();
          lVar10 = -1;
          do {
            lVar10 = lVar10 + 1;
          } while (pcVar7[lVar10] != '\0');
        }
        FUN_140054780(lVar5 + 0x68,pcVar7,lVar10);
        if (local_res10 != (longlong *)0x0) {
          (**(code **)(*local_res10 + 0x10))();
        }
        plVar8 = (longlong *)(**(code **)*DAT_14074ece0)();
        (**(code **)(*plVar8 + 8))(plVar8,uVar3);
        return lVar5;
      }
    }
    FUN_140054780(lVar5 + 0x68,"// Invalid bytecode blob found",0x1e);
  }
  return lVar5;
}
```

## `ProcessGraphicsDxcCompile` — `0x14010d2f0`

DXC driver

```c
/* WARNING: Function: __chkstk replaced with injection: alloca_probe */
/* DXC driver. Builds the DXC argument list (/Qembed_debug, /Zpc, /auto-binding-space,
   /enable-16bit-types, target HLSL, lib_6_3 / lib_6_6 for raytracing) and reformats DXC diagnostics
   into Unity's "): error " style. */

void ProcessGraphicsDxcCompile
               (undefined8 *param_1,longlong param_2,longlong param_3,undefined8 param_4,
               char param_5)

{
  longlong *plVar1;
  code *pcVar2;
  char cVar3;
  byte bVar4;
  int iVar5;
  undefined4 uVar6;
  DWORD dwMessageId;
  DWORD DVar7;
  longlong lVar8;
  longlong lVar9;
  char *pcVar10;
  CHAR *pCVar11;
  LPWSTR pWVar12;
  undefined8 uVar13;
  undefined8 uVar14;
  undefined8 *puVar15;
  undefined1 *puVar16;
  short sVar17;
  wchar_t *pwVar18;
  longlong lVar19;
  longlong lVar20;
  ulonglong uVar21;
  ulonglong uVar22;
  CHAR *pCVar23;
  wchar_t *pwVar24;
  CHAR *pCVar25;
  longlong *plVar26;
  LPSTR lpBuffer;
  undefined4 uVar27;
  undefined1 local_1188;
  undefined7 uStack_1187;
  undefined8 local_1178;
  byte local_1169;
  undefined2 local_1168;
  undefined1 local_1160;
  undefined7 uStack_115f;
  undefined8 local_1150;
  byte local_1141;
  undefined2 local_1140;
  longlong *local_1138;
  undefined8 *local_1130;
  undefined2 local_1128;
  ulonglong local_1120;
  ulonglong local_1118;
  CHAR local_1110;
  uint7 uStack_110f;
  longlong local_1100;
  byte local_10f1;
  undefined2 local_10f0;
  longlong *local_10e0;
  WCHAR local_10d8;
  undefined6 uStack_10d6;
  ulonglong local_10d0;
  ulonglong local_10c8;
  undefined4 local_10ba;
  undefined1 local_10b0;
  undefined7 uStack_10af;
  byte local_1091;
  undefined2 local_1090;
  longlong *local_1088;
  int local_1080 [2];
  longlong *local_1078;
  CHAR *local_1070;
  longlong local_1068;
  undefined8 local_1060;
  undefined2 local_1058;
  undefined8 local_1050;
  undefined8 local_1048;
  longlong local_1040;
  longlong local_1038;
  undefined4 local_1030;
  CHAR local_1028 [4088];
  undefined8 uStack_30;
  
  uStack_30 = 0x14010d31f;
  cVar3 = FUN_14010fbe0(param_3);
  if (cVar3 == '\0') {
    return;
  }
  local_10e0 = (longlong *)
               ((ulonglong)(byte)((uint)*(undefined4 *)(param_1 + 7) >> 0x1a) & 0xffffffffffffff01);
  local_10ba = 0x4b000f;
  local_10d8 = L'\0';
  lVar8 = (**(code **)*param_1)(param_1);
  local_10f0 = 0x4b;
  lVar19 = -1;
  lVar20 = -1;
  do {
    lVar20 = lVar20 + 1;
  } while (*(char *)(lVar8 + lVar20) != '\0');
  local_1110 = '\0';
  local_10f1 = 0x1f;
  lVar9 = FUN_140056c90(&local_1110,lVar20);
  FUN_140558820(lVar9,lVar8,lVar20);
  *(undefined1 *)(lVar9 + lVar20) = 0;
  if (local_10f1 < 0x40) {
    local_10f1 = 0x1f - (char)lVar20;
    lVar20 = local_1100;
  }
  local_1100 = lVar20;
  FUN_1400e0320(&local_1110);
  lVar20 = local_1100;
  if (local_10f1 < 0x40) {
    lVar20 = 0x1f - (longlong)(char)local_10f1;
  }
  pCVar23 = (CHAR *)CONCAT71(uStack_110f,local_1110);
  pCVar25 = &local_1110;
  if (0x3f < local_10f1) {
    pCVar25 = pCVar23;
  }
  lVar8 = local_1100;
  if (lVar20 != 0) {
    for (pcVar10 = pCVar25 + lVar20 + -1; pcVar10 != pCVar25 + -1; pcVar10 = pcVar10 + -1) {
      if (*pcVar10 == '\\') {
        if ((longlong)pcVar10 - (longlong)pCVar25 != -1) {
          lVar20 = ((longlong)pcVar10 - (longlong)pCVar25) + 1;
          pCVar25 = pCVar23;
          if (local_10f1 < 0x40) {
            pCVar25 = &local_1110;
            lVar8 = 0x1f - (longlong)(char)local_10f1;
          }
          lVar8 = lVar8 - lVar20;
          pCVar25 = pCVar25 + lVar20;
          if ((local_10f1 & 0xc0) == 0x80) {
            local_1110 = '\0';
            local_10f1 = 0x1f;
            pCVar23 = (CHAR *)((ulonglong)uStack_110f << 8);
            pCVar11 = &local_1110;
          }
          else {
            pCVar11 = pCVar23;
            if (local_10f1 < 0x40) {
              pCVar11 = &local_1110;
            }
          }
          if (pCVar25 < pCVar11) {
LAB_14010d4c6:
            bVar4 = local_10f1 >> 6;
            if (bVar4 == 0) {
LAB_14010d4da:
              local_1110 = '\0';
              local_10f1 = 0x1f;
            }
            else if (bVar4 == 1) {
              *pCVar23 = '\0';
              local_1100 = 0;
            }
            else if (bVar4 == 2) goto LAB_14010d4da;
            pCVar11 = (CHAR *)FUN_140056c90(&local_1110,lVar8);
            FUN_140558820(pCVar11,pCVar25,lVar8);
          }
          else {
            lVar20 = local_1100;
            if (local_10f1 < 0x40) {
              lVar20 = 0x1f - (longlong)(char)local_10f1;
            }
            if (pCVar11 + lVar20 <= pCVar25) goto LAB_14010d4c6;
            pCVar11 = &local_1110;
            if (0x3f < local_10f1) {
              pCVar11 = pCVar23;
            }
            FUN_140558820(pCVar11,pCVar25,lVar8);
          }
          pCVar11[lVar8] = '\0';
          pCVar23 = (CHAR *)CONCAT71(uStack_110f,local_1110);
          if (local_10f1 < 0x40) {
            local_10f1 = 0x1f - (char)lVar8;
            lVar8 = local_1100;
          }
        }
        break;
      }
    }
  }
  local_1100 = lVar8;
  lVar20 = local_1100;
  if (local_10f1 < 0x40) {
    lVar20 = 0x1f - (longlong)(char)local_10f1;
  }
  if (lVar20 == 0) {
    bVar4 = local_10ba._1_1_ >> 6;
    if (bVar4 == 0) {
LAB_14010d565:
      local_10d8 = L'\0';
      local_10ba = CONCAT22(local_10ba._2_2_,0xf);
    }
    else if (bVar4 == 1) {
      *(undefined2 *)CONCAT62(uStack_10d6,local_10d8) = 0;
      local_10c8 = 0;
    }
    else {
joined_r0x00014010d5d2:
      if (bVar4 == 2) goto LAB_14010d565;
    }
  }
  else {
    lVar20 = local_1100;
    if (local_10f1 < 0x40) {
      pCVar23 = &local_1110;
      lVar20 = 0x1f - (longlong)(char)local_10f1;
    }
    iVar5 = MultiByteToWideChar(0xfde9,0,pCVar23,(int)lVar20,(LPWSTR)0x0,0);
    bVar4 = local_10ba._1_1_;
    if (iVar5 < 1) {
      bVar4 = local_10ba._1_1_ >> 6;
      if (bVar4 == 0) goto LAB_14010d565;
      if (bVar4 != 1) goto joined_r0x00014010d5d2;
      *(undefined2 *)CONCAT62(uStack_10d6,local_10d8) = 0;
      local_10c8 = 0;
    }
    else {
      uVar21 = (ulonglong)iVar5;
      if (bVar4 < 0x40) {
        local_10d0 = 0xf;
      }
      sVar17 = (ushort)local_10ba;
      if (local_10d0 < uVar21) {
        FUN_1400964f0(&local_10d8,uVar21);
        sVar17 = (ushort)local_10ba;
      }
      uVar22 = uVar21;
      if (local_10ba._1_1_ < 0x40) {
        sVar17 = 0xf - (short)iVar5;
        local_10ba = CONCAT22(local_10ba._2_2_,sVar17);
        uVar22 = local_10c8;
      }
      local_10c8 = uVar22;
      pWVar12 = &local_10d8;
      if (0x3f < (byte)((ushort)sVar17 >> 8)) {
        pWVar12 = (LPWSTR)CONCAT62(uStack_10d6,local_10d8);
      }
      pWVar12[uVar21] = L'\0';
      if (local_10f1 < 0x40) {
        iVar5 = 0x1f - (char)local_10f1;
      }
      else {
        iVar5 = (int)local_1100;
      }
      pCVar23 = &local_1110;
      if (0x3f < local_10f1) {
        pCVar23 = (LPCSTR)CONCAT71(uStack_110f,local_1110);
      }
      bVar4 = (byte)((uint)local_10ba >> 8);
      uVar21 = local_10c8;
      if (bVar4 < 0x40) {
        uVar21 = 0xf - (ulonglong)(ushort)local_10ba;
      }
      if ((bVar4 & 0xc0) == 0x80) {
        uVar22 = local_10c8;
        if (bVar4 < 0x40) {
          uVar22 = 0xf - (ulonglong)(ushort)local_10ba;
        }
        FUN_1400964f0(&local_10d8,uVar22);
      }
      pWVar12 = &local_10d8;
      if (0x3f < local_10ba._1_1_) {
        pWVar12 = (LPWSTR)CONCAT62(uStack_10d6,local_10d8);
      }
      MultiByteToWideChar(0xfde9,0,pCVar23,iVar5,pWVar12,(int)uVar21);
    }
  }
  lVar20 = 0;
  local_1130 = (undefined8 *)0x0;
  local_1128 = 1;
  local_1120 = 0;
  local_1118 = 1;
  if (param_5 == '\0') {
    if ((char)local_10e0 == '\0') goto LAB_14010d7a4;
  }
  else {
    FUN_140057020(&local_1130);
    local_1120 = 1;
    if (local_1130 != (undefined8 *)0x0) {
      *local_1130 = &DAT_140590788;
    }
    if ((local_1118 & 0xfffffffffffffffe) < 4) {
      FUN_140057020(&local_1130);
    }
    lVar20 = 2;
    local_1120 = 2;
    if (local_1130 + 1 != (undefined8 *)0x0) {
      local_1130[1] = L"/Qembed_debug";
    }
  }
  uVar21 = lVar20 + 1;
  if (local_1118 >> 1 < uVar21) {
    FUN_140057020(&local_1130);
  }
  local_1120 = uVar21;
  if (local_1130 + lVar20 != (undefined8 *)0x0) {
    local_1130[lVar20] = &DAT_1405907b0;
  }
LAB_14010d7a4:
  uVar21 = local_1120;
  uVar22 = local_1120 + 1;
  if (local_1118 >> 1 < uVar22) {
    FUN_140057020(&local_1130);
  }
  if (local_1130 + uVar21 != (undefined8 *)0x0) {
    local_1130[uVar21] = &DAT_1405907b8;
  }
  if (local_1118 >> 1 < uVar21 + 2) {
    local_1120 = uVar22;
    FUN_140057020(&local_1130);
  }
  if (local_1130 + uVar21 + 1 != (undefined8 *)0x0) {
    local_1130[uVar21 + 1] = L"2018";
  }
  if (local_1118 >> 1 < uVar21 + 3) {
    local_1120 = uVar21 + 2;
    FUN_140057020(&local_1130);
  }
  if (local_1130 + uVar21 + 2 != (undefined8 *)0x0) {
    local_1130[uVar21 + 2] = L"/Zpc";
  }
  if (local_1118 >> 1 < uVar21 + 4) {
    local_1120 = uVar21 + 3;
    FUN_140057020(&local_1130);
  }
  if (local_1130 + uVar21 + 3 != (undefined8 *)0x0) {
    local_1130[uVar21 + 3] = L"/auto-binding-space";
  }
  uVar22 = uVar21 + 5;
  if (local_1118 >> 1 < uVar22) {
    local_1120 = uVar21 + 4;
    FUN_140057020(&local_1130);
  }
  if (local_1130 + uVar21 + 4 != (undefined8 *)0x0) {
    local_1130[uVar21 + 4] = &DAT_14059031c;
  }
  local_1120 = uVar22;
  if ((*(uint *)(param_1 + 5) >> 0x1d & 1) != 0) {
    uVar22 = uVar21 + 6;
    if (local_1118 >> 1 < uVar22) {
      FUN_140057020();
    }
    local_1120 = uVar22;
    if (local_1130 + uVar21 + 5 != (undefined8 *)0x0) {
      local_1130[uVar21 + 5] = L"/enable-16bit-types";
    }
  }
  uVar21 = local_1120;
  puVar15 = local_1130;
  plVar1 = (longlong *)param_1[10];
  local_1060 = 0;
  local_1058 = 0x4d;
  local_1050 = 0;
  local_1048 = 1;
  if ((*(uint *)(param_1 + 7) >> 0xf & 1) == 0) {
    SetCompilerAvailabilityMacros(param_1[5] | 0x13ffff,&local_1060);
  }
  plVar26 = plVar1;
  cVar3 = FUN_140113880(param_1,&local_1060,6,0,plVar1,param_3);
  uVar6 = (undefined4)((ulonglong)plVar26 >> 0x20);
  if (cVar3 != '\0') {
    if (*(char *)(param_1 + 0xb) == '\0') {
      local_1078 = (longlong *)0x0;
      if (((ulonglong)param_1[5] >> 0x23 & 1) == 0) {
        pwVar24 = L"lib_6_6";
        if ((param_1[5] & 0x110000000) == 0) {
          pwVar24 = L"lib_6_3";
        }
        bVar4 = local_10ba._1_1_;
        uVar22 = local_10c8;
        if (local_10ba._1_1_ < 0x40) {
          uVar22 = 0xf - (ulonglong)(ushort)local_10ba;
        }
        if (uVar22 == 0) {
          pwVar18 = L"HLSL";
        }
        else {
          pwVar18 = &local_10d8;
          if (0x3f < bVar4) {
            pwVar18 = (LPWSTR)CONCAT62(uStack_10d6,local_10d8);
          }
        }
        (**(code **)(*DAT_140751568 + 0x70))
                  (DAT_140751568,pwVar18,&DAT_1405908d0,pwVar24,puVar15,uVar21,0,0,&local_1078);
        local_1088 = (longlong *)0x0;
        local_1040 = (longlong)plVar1;
        if (0x3f < *(byte *)((longlong)plVar1 + 0x1f)) {
          local_1040 = *plVar1;
        }
        if (*(byte *)((longlong)plVar1 + 0x1f) < 0x40) {
          local_1038 = 0x1f - (longlong)*(char *)((longlong)plVar1 + 0x1f);
        }
        else {
          local_1038 = plVar1[2];
        }
        local_1030 = 0xfde9;
        pcVar2 = *(code **)(*DAT_140751560 + 0x18);
        uVar6 = (**(code **)(*local_1078 + 0x20))();
        uVar13 = (**(code **)(*local_1078 + 0x18))();
        uVar27 = 1;
        uVar21 = 0;
        dwMessageId = (*pcVar2)(DAT_140751560,&local_1040,uVar13,uVar6,0,&DAT_140590068,&local_1088)
        ;
        if (((int)dwMessageId < 0) || (local_1088 == (longlong *)0x0)) {
          FUN_140558460(local_1028,0,0x1000);
          lpBuffer = local_1028;
          DVar7 = FormatMessageA(0x10ff,(LPCVOID)0x0,dwMessageId,0,lpBuffer,0x1000,(va_list *)0x0);
          uVar6 = (undefined4)((ulonglong)lpBuffer >> 0x20);
          if (DVar7 != 0) {
            FUN_1400e0f60(&local_1160,
                          "DirectX Shader Compiler failed to execute Compile command. [0x%08x - %s]"
                          ,dwMessageId,local_1028);
            puVar16 = &local_1160;
            if (0x3f < local_1141) {
              puVar16 = (undefined1 *)CONCAT71(uStack_115f,local_1160);
            }
            local_1090 = 0x4b;
            local_10b0 = 0;
            local_1091 = 0x1f;
            do {
              lVar19 = lVar19 + 1;
            } while (puVar16[lVar19] != '\0');
            FUN_140054780(&local_10b0,puVar16,lVar19);
            FUN_140089820(param_3,&local_10b0,0,0,CONCAT44(uVar6,0x1c));
            if ((local_1091 & 0xc0) == 0x40) {
              thunk_FUN_1403f2404(CONCAT71(uStack_10af,local_10b0),local_1090,
                                  "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                  ,0x218);
            }
            if ((local_1141 & 0xc0) == 0x40) {
              thunk_FUN_1403f2404(CONCAT71(uStack_115f,local_1160),local_1140,
                                  "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                  ,0x218);
            }
          }
        }
        else {
          (**(code **)(*local_1088 + 0x18))(local_1088,local_1080);
          uVar6 = *(undefined4 *)(param_1 + 4);
          local_1138 = (longlong *)0x0;
          (**(code **)(*local_1088 + 0x28))(local_1088,&local_1138);
          if (local_1080[0] < 0) {
            uVar13 = (**(code **)(*local_1138 + 0x20))();
            uVar14 = (**(code **)(*local_1138 + 0x18))();
            FUN_140014bc0(&local_10b0,uVar14,uVar13,0x4b);
            local_1168 = 0x4b;
            local_1188 = 0;
            local_1169 = 0x1f;
            FUN_140054780(&local_1188,&DAT_140578094,0);
            local_1140 = 0x4b;
            local_1160 = 0;
            local_1141 = 0x1f;
            FUN_140054780(&local_1160,": error: ",9);
            uVar13 = CONCAT44(uVar27,uVar6);
            uVar21 = uVar21 & 0xffffffff00000000;
            FUN_1400c1f10(&local_10b0,0,&local_1160,&local_1188,uVar21,uVar13,param_3);
            uVar27 = (undefined4)((ulonglong)uVar13 >> 0x20);
            if ((local_1141 & 0xc0) == 0x40) {
              thunk_FUN_1403f2404(CONCAT71(uStack_115f,local_1160),local_1140,
                                  "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                  ,0x218);
            }
            if ((local_1169 & 0xc0) == 0x40) {
              thunk_FUN_1403f2404(CONCAT71(uStack_1187,local_1188),local_1168,
                                  "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                  ,0x218);
            }
            local_1140 = 0x4b;
            local_1160 = 0;
            local_1141 = 0x1f;
            FUN_140054780(&local_1160,&DAT_140578094,0);
            local_1168 = 0x4b;
            local_1188 = 0;
            local_1169 = 0x1f;
            puVar15 = (undefined8 *)FUN_140056c90(&local_1188,10);
            *puVar15 = 0x6e696e726177203a;
            *(undefined2 *)(puVar15 + 1) = 0x2067;
            *(undefined1 *)((longlong)puVar15 + 10) = 0;
            if (local_1169 < 0x40) {
              local_1169 = 0x15;
            }
            else {
              local_1178 = 10;
            }
            uVar13 = CONCAT44(uVar27,uVar6);
            uVar21 = uVar21 & 0xffffffff00000000;
            FUN_1400c1f10(&local_10b0,1,&local_1188,&local_1160,uVar21,uVar13,param_3);
            uVar27 = (undefined4)((ulonglong)uVar13 >> 0x20);
            if ((local_1169 & 0xc0) == 0x40) {
              thunk_FUN_1403f2404(CONCAT71(uStack_1187,local_1188),local_1168,
                                  "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                  ,0x218);
            }
            if ((local_1141 & 0xc0) == 0x40) {
              thunk_FUN_1403f2404(CONCAT71(uStack_115f,local_1160),local_1140,
                                  "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                  ,0x218);
            }
            local_1140 = 0x4b;
            local_1160 = 0;
            local_1141 = 0x1f;
            puVar16 = (undefined1 *)FUN_140056c90(&local_1160,0);
            *puVar16 = 0;
            if (local_1141 < 0x40) {
              local_1141 = 0x1f;
            }
            else {
              local_1150 = 0;
            }
            local_1168 = 0x4b;
            local_1188 = 0;
            local_1169 = 0x1f;
            puVar15 = (undefined8 *)FUN_140056c90(&local_1188,0xb);
            *puVar15 = 0x6e696e726177203a;
            *(undefined2 *)(puVar15 + 1) = 0x3a67;
            *(undefined1 *)((longlong)puVar15 + 10) = 0x20;
            *(undefined1 *)((longlong)puVar15 + 0xb) = 0;
            if (local_1169 < 0x40) {
              local_1169 = 0x14;
            }
            else {
              local_1178 = 0xb;
            }
            uVar13 = CONCAT44(uVar27,uVar6);
            uVar21 = uVar21 & 0xffffffff00000000;
            FUN_1400c1f10(&local_10b0,1,&local_1188,&local_1160,uVar21,uVar13,param_3);
            uVar27 = (undefined4)((ulonglong)uVar13 >> 0x20);
            if ((local_1169 & 0xc0) == 0x40) {
              thunk_FUN_1403f2404(CONCAT71(uStack_1187,local_1188),local_1168,
                                  "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                  ,0x218);
            }
            if ((local_1141 & 0xc0) == 0x40) {
              thunk_FUN_1403f2404(CONCAT71(uStack_115f,local_1160),local_1140,
                                  "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                  ,0x218);
            }
            local_1168 = 0x4b;
            local_1188 = 0;
            local_1169 = 0x1f;
            FUN_140054780(&local_1188,&DAT_140578094,0);
            local_1140 = 0x4b;
            local_1160 = 0;
            local_1141 = 0x1f;
            FUN_140054780(&local_1160,"warning ",8);
            uVar21 = uVar21 & 0xffffffff00000000;
            FindComputeKernelEntryPoint
                      (&local_10b0,1,&local_1160,&local_1188,uVar21,CONCAT44(uVar27,uVar6),param_3);
            uVar27 = (undefined4)(uVar21 >> 0x20);
            if ((local_1141 & 0xc0) == 0x40) {
              thunk_FUN_1403f2404(CONCAT71(uStack_115f,local_1160),local_1140,
                                  "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                  ,0x218);
            }
            if ((local_1169 & 0xc0) == 0x40) {
              thunk_FUN_1403f2404(CONCAT71(uStack_1187,local_1188),local_1168,
                                  "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                  ,0x218);
            }
            local_1168 = 0x4b;
            local_1188 = 0;
            local_1169 = 0x1f;
            FUN_140054780(&local_1188,&DAT_140578094,0);
            local_1140 = 0x4b;
            local_1160 = 0;
            local_1141 = 0x1f;
            FUN_140054780(&local_1160,"error ",6);
            uVar13 = CONCAT44(uVar27,uVar6);
            FUN_1400c3490(&local_10b0,&local_1160,&local_1188,0,uVar13,param_3);
            uVar6 = (undefined4)((ulonglong)uVar13 >> 0x20);
            if ((local_1141 & 0xc0) == 0x40) {
              thunk_FUN_1403f2404(CONCAT71(uStack_115f,local_1160),local_1140,
                                  "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                  ,0x218);
            }
            if ((local_1169 & 0xc0) == 0x40) {
              thunk_FUN_1403f2404(CONCAT71(uStack_1187,local_1188),local_1168,
                                  "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                  ,0x218);
            }
            FUN_14010ff10(param_3);
            if (*(longlong *)(param_3 + 8) == 0) {
              puVar16 = &local_10b0;
              if (0x3f < local_1091) {
                puVar16 = (undefined1 *)CONCAT71(uStack_10af,local_10b0);
              }
              FUN_1400e0f60(&local_1188,"Compilation failed [0x%08x - Unknown error.] \'%s\'",
                            local_1080[0],puVar16);
              puVar16 = &local_1188;
              if (0x3f < local_1169) {
                puVar16 = (undefined1 *)CONCAT71(uStack_1187,local_1188);
              }
              local_1140 = 0x4b;
              local_1160 = 0;
              local_1141 = 0x1f;
              do {
                lVar19 = lVar19 + 1;
              } while (puVar16[lVar19] != '\0');
              FUN_140054780(&local_1160,puVar16,lVar19);
              FUN_140089820(param_3,&local_1160,0,0,CONCAT44(uVar6,0x1c));
              if ((local_1141 & 0xc0) == 0x40) {
                thunk_FUN_1403f2404(CONCAT71(uStack_115f,local_1160),local_1140,
                                    "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                    ,0x218);
              }
              if ((local_1169 & 0xc0) == 0x40) {
                thunk_FUN_1403f2404(CONCAT71(uStack_1187,local_1188),local_1168,
                                    "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                    ,0x218);
              }
            }
            if ((local_1091 & 0xc0) == 0x40) {
              thunk_FUN_1403f2404(CONCAT71(uStack_10af,local_10b0),local_1090,
                                  "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                  ,0x218);
            }
          }
          else {
            local_10e0 = (longlong *)0x0;
            (**(code **)(*local_1088 + 0x20))(local_1088,&local_10e0);
            lVar8 = (**(code **)(*local_10e0 + 0x18))();
            lVar19 = (**(code **)(*local_10e0 + 0x20))();
            lVar20 = param_3;
            ProcessDxcCompileResult(uVar6,local_10e0,param_2,param_1[1],param_3);
            local_1068 = local_1100;
            if (local_10f1 < 0x40) {
              local_1068 = 0x1f - (longlong)(char)local_10f1;
            }
            local_1070 = &local_1110;
            if (0x3f < local_10f1) {
              local_1070 = (CHAR *)CONCAT71(uStack_110f,local_1110);
            }
            uVar21 = CONCAT44((int)((ulonglong)lVar20 >> 0x20),*(undefined4 *)(param_1 + 4));
            lVar20 = param_3;
            FUN_140113650(param_2,&local_1070,*(undefined4 *)(param_1 + 3),
                          *(undefined4 *)(param_1 + 2),uVar21,param_3);
            uVar27 = (undefined4)((ulonglong)lVar20 >> 0x20);
            FUN_1400549f0(param_2 + 0x1a8,lVar8,lVar19 + lVar8);
            *(undefined8 *)(param_2 + 0x1c8) = param_1[5];
            if (local_1138 != (longlong *)0x0) {
              uVar13 = (**(code **)(*local_1138 + 0x20))();
              uVar14 = (**(code **)(*local_1138 + 0x18))();
              FUN_140014bc0(&local_1188,uVar14,uVar13,0x4b);
              local_1140 = 0x4b;
              local_1160 = 0;
              local_1141 = 0x1f;
              FUN_140054780(&local_1160,&DAT_140578094,0);
              local_1090 = 0x4b;
              local_10b0 = 0;
              local_1091 = 0x1f;
              FUN_140054780(&local_10b0,": warning ",10);
              uVar13 = CONCAT44(uVar27,uVar6);
              uVar21 = uVar21 & 0xffffffff00000000;
              FUN_1400c1f10(&local_1188,1,&local_10b0,&local_1160,uVar21,uVar13,param_3);
              uVar27 = (undefined4)((ulonglong)uVar13 >> 0x20);
              if ((local_1091 & 0xc0) == 0x40) {
                thunk_FUN_1403f2404(CONCAT71(uStack_10af,local_10b0),local_1090,
                                    "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                    ,0x218);
              }
              if ((local_1141 & 0xc0) == 0x40) {
                thunk_FUN_1403f2404(CONCAT71(uStack_115f,local_1160),local_1140,
                                    "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                    ,0x218);
              }
              local_1140 = 0x4b;
              local_1160 = 0;
              local_1141 = 0x1f;
              FUN_140054780(&local_1160,&DAT_140578094,0);
              local_1090 = 0x4b;
              local_10b0 = 0;
              local_1091 = 0x1f;
              FUN_140054780(&local_10b0,": warning: ",0xb);
              FUN_1400c1f10(&local_1188,1,&local_10b0,&local_1160,uVar21 & 0xffffffff00000000,
                            CONCAT44(uVar27,uVar6),param_3);
              if ((local_1091 & 0xc0) == 0x40) {
                thunk_FUN_1403f2404(CONCAT71(uStack_10af,local_10b0),local_1090,
                                    "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                    ,0x218);
              }
              if ((local_1141 & 0xc0) == 0x40) {
                thunk_FUN_1403f2404(CONCAT71(uStack_115f,local_1160),local_1140,
                                    "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                    ,0x218);
              }
              FUN_14010ff10(param_3);
              if ((local_1169 & 0xc0) == 0x40) {
                thunk_FUN_1403f2404(CONCAT71(uStack_1187,local_1188),local_1168,
                                    "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                    ,0x218);
              }
            }
            if (local_10e0 != (longlong *)0x0) {
              (**(code **)(*local_10e0 + 0x10))(local_10e0);
            }
          }
          if (local_1138 != (longlong *)0x0) {
            (**(code **)(*local_1138 + 0x10))();
          }
        }
        if (local_1088 != (longlong *)0x0) {
          (**(code **)(*local_1088 + 0x10))();
          local_1088 = (longlong *)0x0;
        }
      }
      else {
        uVar27 = *(undefined4 *)(param_1 + 4);
        local_1168 = 0x4b;
        local_1188 = 0;
        local_1169 = 0x1f;
        pcVar10 = (char *)FUN_140056c90(&local_1188,0x49);
        builtin_strncpy(pcVar10,
                        "Inline Ray Tracing (Ray Queries) is not supported in Ray Tracing Shaders.",
                        0x4a);
        if (local_1169 < 0x40) {
          local_1169 = 0xd6;
        }
        else {
          local_1178 = 0x49;
        }
        FUN_140089820(param_3,&local_1188,1,0,CONCAT44(uVar6,uVar27));
        if ((local_1169 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(CONCAT71(uStack_1187,local_1188),local_1168,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
        }
      }
      if (local_1078 != (longlong *)0x0) {
        (**(code **)(*local_1078 + 0x10))();
        local_1078 = (longlong *)0x0;
      }
    }
    else {
      uVar27 = *(undefined4 *)(param_1 + 4);
      local_1168 = 0x4b;
      local_1188 = 0;
      local_1169 = 0x1f;
      pcVar10 = (char *)FUN_140056c90(&local_1188,0x39);
      builtin_strncpy(pcVar10,"Preprocess only is not supported for ray tracing shaders.",0x3a);
      if (local_1169 < 0x40) {
        local_1169 = 0xe6;
      }
      else {
        local_1178 = 0x39;
      }
      FUN_140089820(param_3,&local_1188,1,0,CONCAT44(uVar6,uVar27));
      if ((local_1169 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(CONCAT71(uStack_1187,local_1188),local_1168,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
    }
  }
  FUN_140017ca0(&local_1060);
  FUN_140017b90(&local_1130);
  if ((local_10f1 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_110f,local_1110),local_10f0,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  if ((local_10ba._1_1_ & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT62(uStack_10d6,local_10d8),local_10ba._2_2_,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  return;
}
```

## `ProcessDxcCompileResult` — `0x140113330`

DXC compile result handling

```c
/* WARNING: Function: __chkstk replaced with injection: alloca_probe */

void ProcessDxcCompileResult
               (undefined4 param_1,undefined8 param_2,undefined8 param_3,undefined8 param_4,
               undefined8 param_5)

{
  DWORD dwMessageId;
  DWORD DVar1;
  longlong lVar2;
  undefined8 ****ppppuVar3;
  longlong lVar4;
  LPSTR lpBuffer;
  undefined4 uVar5;
  longlong *local_1078;
  undefined1 local_1070;
  undefined7 uStack_106f;
  longlong local_1060;
  byte local_1051;
  undefined2 local_1050;
  undefined8 ***local_1048 [3];
  byte local_1029;
  undefined2 local_1028;
  CHAR local_1018 [4088];
  undefined8 uStack_20;
  
  uStack_20 = 0x140113356;
  local_1078 = (longlong *)0x0;
  if (DAT_140751548 == 0) {
    dwMessageId = 0x80004005;
  }
  else {
    dwMessageId = (*DAT_140751550)(&DAT_14058f758,&DAT_1405908e8,&local_1078);
  }
  if ((int)dwMessageId < 0) {
    FUN_140558460(local_1018,0,0x1000);
    lpBuffer = local_1018;
    DVar1 = FormatMessageA(0x10ff,(LPCVOID)0x0,dwMessageId,0,lpBuffer,0x1000,(va_list *)0x0);
    uVar5 = (undefined4)((ulonglong)lpBuffer >> 0x20);
    if (DVar1 != 0) {
      FUN_1400e0f60(local_1048,
                    "Compilation failed: Couldn\'t initialize DirectX Shader Compiler reflection library. [0x%08x - %s]"
                    ,dwMessageId,local_1018);
      ppppuVar3 = local_1048;
      if (0x3f < local_1029) {
        ppppuVar3 = (undefined8 ****)local_1048[0];
      }
      local_1050 = 0x4b;
      lVar4 = -1;
      do {
        lVar4 = lVar4 + 1;
      } while (*(char *)((longlong)ppppuVar3 + lVar4) != '\0');
      local_1070 = 0;
      local_1051 = 0x1f;
      lVar2 = FUN_140056c90(&local_1070,lVar4);
      FUN_140558820(lVar2,ppppuVar3,lVar4);
      *(undefined1 *)(lVar2 + lVar4) = 0;
      if (local_1051 < 0x40) {
        local_1051 = 0x1f - (char)lVar4;
        lVar4 = local_1060;
      }
      local_1060 = lVar4;
      FUN_140089820(param_5,&local_1070,0,0,CONCAT44(uVar5,0x1c));
      if ((local_1051 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(CONCAT71(uStack_106f,local_1070),local_1050,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      if ((local_1029 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(local_1048[0],local_1028,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      goto LAB_140113514;
    }
  }
  ProcessDxcReflectionResult(local_1078,param_1,param_2,param_3,param_4,param_5);
LAB_140113514:
  if (local_1078 != (longlong *)0x0) {
    (**(code **)(*local_1078 + 0x10))();
  }
  return;
}
```

## `ProcessDxcReflectionResult` — `0x14011a330`

DXC reflection result handling

```c
/* WARNING: Function: __chkstk replaced with injection: alloca_probe */

void ProcessDxcReflectionResult
               (longlong *param_1,undefined8 param_2,undefined8 param_3,longlong *param_4,
               longlong *param_5,undefined8 param_6)

{
  undefined4 *puVar1;
  short sVar2;
  short sVar3;
  code *pcVar4;
  bool bVar5;
  ulonglong uVar6;
  char cVar7;
  DWORD dwMessageId;
  DWORD DVar8;
  int iVar9;
  undefined4 uVar10;
  longlong lVar11;
  longlong *plVar12;
  undefined8 uVar13;
  undefined8 uVar14;
  short *psVar15;
  ulonglong *puVar16;
  undefined8 *puVar17;
  longlong lVar18;
  longlong lVar19;
  longlong *plVar20;
  uint uVar21;
  byte *pbVar22;
  longlong *plVar23;
  undefined2 uVar24;
  uint *puVar25;
  byte *pbVar26;
  undefined1 *puVar27;
  longlong *plVar28;
  undefined8 *puVar29;
  ulonglong uVar30;
  ulonglong uVar31;
  ulonglong uVar32;
  undefined1 *puVar33;
  undefined8 *puVar34;
  uint uVar35;
  int iVar36;
  ulonglong uVar37;
  uint uVar38;
  undefined8 *puVar39;
  undefined8 local_res8;
  code *pcVar40;
  undefined4 uVar41;
  undefined4 uVar42;
  undefined1 local_1558;
  undefined7 uStack_1557;
  byte local_1539;
  undefined2 local_1538;
  uint local_1530;
  undefined8 local_1528;
  undefined1 local_1518;
  undefined7 uStack_1517;
  longlong local_1508;
  byte local_14f9;
  undefined2 local_14f8;
  undefined4 local_14f0;
  undefined4 local_14ec;
  undefined8 local_14e8;
  undefined8 local_14e0;
  undefined1 local_14d8;
  uint local_14c8;
  int iStack_14c4;
  undefined4 uStack_14c0;
  undefined4 uStack_14bc;
  undefined4 local_14b8;
  undefined4 uStack_14b4;
  undefined7 uStack_14b0;
  byte bStack_14a9;
  undefined2 local_14a8;
  undefined6 uStack_14a6;
  undefined8 local_14a0;
  undefined1 local_1498;
  undefined7 uStack_1497;
  int local_1490;
  uint local_148c;
  ulonglong local_1488;
  byte local_1479;
  undefined2 local_1478;
  longlong *local_1470;
  byte local_1468;
  undefined7 uStack_1467;
  ulonglong local_1458;
  byte local_1449;
  undefined2 local_1448;
  longlong *local_1440;
  undefined8 local_1438;
  undefined8 uStack_1430;
  longlong local_1428;
  byte local_1419;
  undefined2 local_1418;
  undefined1 local_1408;
  undefined7 uStack_1407;
  byte local_13e9;
  undefined2 local_13e8;
  undefined8 local_13e0;
  undefined4 local_13d8;
  undefined8 local_13d4;
  undefined2 local_13cc;
  undefined4 local_13c8;
  undefined4 local_13c4;
  undefined1 *local_13c0;
  undefined8 uStack_13b8;
  undefined8 local_13b0;
  undefined8 uStack_13a8;
  undefined1 local_13a0;
  undefined7 uStack_139f;
  longlong local_1390;
  byte local_1381;
  undefined2 local_1380;
  int local_1378;
  undefined4 local_1370;
  uint local_136c;
  undefined1 local_1368;
  undefined7 uStack_1367;
  longlong local_1358;
  byte local_1349;
  undefined2 local_1348;
  undefined8 local_1340;
  longlong local_1338;
  undefined2 local_1330;
  ulonglong local_1328;
  ulonglong local_1320;
  byte local_1318;
  undefined7 uStack_1317;
  ulonglong local_1308;
  byte local_12f9;
  undefined2 local_12f8;
  longlong *local_12f0;
  short local_12e8;
  undefined6 uStack_12e6;
  undefined2 local_12ca;
  undefined2 local_12c8;
  undefined8 local_12c0 [3];
  byte local_12a1;
  undefined2 local_12a0;
  longlong local_1298 [4];
  undefined1 local_1278 [16];
  longlong local_1268;
  byte local_1259;
  undefined2 local_1258;
  undefined1 *local_1250;
  undefined4 uStack_1248;
  undefined4 uStack_1244;
  undefined4 local_1240;
  undefined4 uStack_123c;
  undefined4 uStack_1238;
  int iStack_1234;
  int local_1230;
  uint uStack_122c;
  undefined4 uStack_1228;
  undefined4 uStack_1224;
  longlong local_1220 [2];
  longlong local_1210 [2];
  longlong local_1200 [4];
  longlong *local_11e0;
  undefined1 *local_11d8;
  longlong local_11d0;
  longlong local_11c8 [4];
  longlong local_11a8 [8];
  undefined1 local_1168 [16];
  undefined1 local_1158 [12];
  uint local_114c;
  longlong local_1148 [4];
  longlong local_1128 [4];
  longlong local_1108;
  undefined4 local_1100;
  undefined4 local_10fc;
  byte local_10f8;
  undefined8 local_10d8 [3];
  byte local_10b9;
  undefined2 local_10b8;
  longlong *local_10b0;
  undefined1 local_10a8 [32];
  undefined1 local_1088 [16];
  uint local_1078 [2];
  longlong local_1070;
  undefined1 local_1048 [16];
  uint local_1038 [5];
  uint local_1024;
  uint local_1020;
  undefined8 local_fb8;
  undefined8 uStack_40;
  
  if (param_1 == (longlong *)0x0) {
    return;
  }
  uStack_40 = 0x14011a360;
  plVar20 = (longlong *)0x0;
  local_1528 = local_1528 & 0xffffffff00000000;
  local_res8 = local_res8 & 0xffffffff00000000;
  _eh_vector_constructor_iterator_(local_1128,0x10,2,FUN_1401167a0,FUN_140117060);
  _eh_vector_constructor_iterator_(local_1148,0x10,2,FUN_1401167a0,FUN_140117060);
  _eh_vector_constructor_iterator_(local_11c8,0x10,2,FUN_1401167a0,FUN_140117060);
  _eh_vector_constructor_iterator_(local_11a8,0x10,2,FUN_140116720,FUN_1400afe30);
  _eh_vector_constructor_iterator_(local_1220,0x10,2,FUN_1401167a0,FUN_140117060);
  _eh_vector_constructor_iterator_(local_11a8 + 4,0x10,2,FUN_140116760,FUN_140117030);
  _eh_vector_constructor_iterator_(local_1298,0x10,2,FUN_1401167e0,FUN_140117090);
  _eh_vector_constructor_iterator_(local_1200,0x10,2,FUN_140116720,FUN_1400afe30);
  pcVar40 = FUN_1401170c0;
  _eh_vector_constructor_iterator_(local_10a8,0x10,2,FUN_140116820,FUN_1401170c0);
  dwMessageId = (**(code **)(*param_1 + 0x18))(param_1,param_3);
  if ((int)dwMessageId < 0) {
    FUN_140558460(local_1038,0,0x1000);
    pcVar40 = (code *)local_1038;
    DVar8 = FormatMessageA(0x10ff,(LPCVOID)0x0,dwMessageId,0,(LPSTR)pcVar40,0x1000,(va_list *)0x0);
    uVar10 = (undefined4)((ulonglong)pcVar40 >> 0x20);
    if (DVar8 != 0) {
      FUN_1400e0f60(&local_1558,
                    "Compilation failed: Couldn\'t initialize DirectX Shader Compiler reflection library. [0x%08x - %s]"
                    ,dwMessageId,local_1038);
      puVar33 = &local_1558;
      if (0x3f < local_1539) {
        puVar33 = (undefined1 *)CONCAT71(uStack_1557,local_1558);
      }
      local_14a8 = 0x4b;
      local_14c8 = local_14c8 & 0xffffff00;
      bStack_14a9 = 0x1f;
      lVar11 = -1;
      do {
        lVar11 = lVar11 + 1;
      } while (puVar33[lVar11] != '\0');
      FUN_140054780(&local_14c8,puVar33,lVar11);
      FUN_140089820(param_6,&local_14c8,0,0,CONCAT44(uVar10,0x1c));
      if ((bStack_14a9 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(CONCAT44(iStack_14c4,local_14c8),local_14a8,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      if ((local_1539 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(CONCAT71(uStack_1557,local_1558),local_1538,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      goto LAB_14011c918;
    }
  }
  iVar9 = (**(code **)(*param_1 + 0x38))(param_1,0x4c495844,&local_13c8);
  uVar10 = (undefined4)((ulonglong)pcVar40 >> 0x20);
  if (iVar9 < 0) {
    FUN_1400e0f60(&local_1558,
                  "Compilation failed: Couldn\'t retrieve shader reflection information.");
    puVar33 = &local_1558;
    if (0x3f < local_1539) {
      puVar33 = (undefined1 *)CONCAT71(uStack_1557,local_1558);
    }
    local_1478 = 0x4b;
    local_1498 = 0;
    local_1479 = 0x1f;
    uVar31 = 0xffffffffffffffff;
    do {
      uVar31 = uVar31 + 1;
    } while (puVar33[uVar31] != '\0');
    local_1498 = 0;
    local_1479 = 0x1f;
    lVar11 = FUN_140056c90(&local_1498,uVar31);
    FUN_140558820(lVar11,puVar33,uVar31);
    *(undefined1 *)(lVar11 + uVar31) = 0;
    if (local_1479 < 0x40) {
      local_1479 = 0x1f - (char)uVar31;
      uVar31 = local_1488;
    }
    local_1488 = uVar31;
    FUN_140089820(param_6,&local_1498,0,0,CONCAT44(uVar10,0x1c));
    if ((local_1479 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(uStack_1497,local_1498),local_1478,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    if ((local_1539 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(uStack_1557,local_1558),local_1538,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    goto LAB_14011c918;
  }
  local_1470 = (longlong *)0x0;
  iVar9 = (**(code **)(*param_1 + 0x40))(param_1,local_13c8,&DAT_140590a30);
  uVar10 = (undefined4)((ulonglong)pcVar40 >> 0x20);
  if ((iVar9 < 0) || (local_1470 == (longlong *)0x0)) {
    FUN_1400e0f60(&local_14c8,
                  "Compilation failed: Couldn\'t retrieve shader reflection information.");
    puVar25 = &local_14c8;
    if (0x3f < bStack_14a9) {
      puVar25 = (uint *)CONCAT44(iStack_14c4,local_14c8);
    }
    local_1538 = 0x4b;
    local_1558 = 0;
    local_1539 = 0x1f;
    lVar11 = -1;
    do {
      lVar11 = lVar11 + 1;
    } while (*(char *)((longlong)puVar25 + lVar11) != '\0');
    FUN_140054780(&local_1558,puVar25,lVar11);
    FUN_140089820(param_6,&local_1558,0,0,CONCAT44(uVar10,0x1c));
    if ((local_1539 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT71(uStack_1557,local_1558),local_1538,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
    if ((bStack_14a9 & 0xc0) == 0x40) {
      thunk_FUN_1403f2404(CONCAT44(iStack_14c4,local_14c8),local_14a8,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
  }
  else {
    iVar9 = (**(code **)(*param_1 + 0x38))(param_1,0x54414452,&local_13c4);
    uVar10 = (undefined4)((ulonglong)pcVar40 >> 0x20);
    if (iVar9 < 0) {
      FUN_1400e0f60(&local_1558,
                    "Compilation failed: Couldn\'t retrieve shader reflection information.");
      puVar33 = &local_1558;
      if (0x3f < local_1539) {
        puVar33 = (undefined1 *)CONCAT71(uStack_1557,local_1558);
      }
      local_14a8 = 0x4b;
      local_14c8 = local_14c8 & 0xffffff00;
      bStack_14a9 = 0x1f;
      lVar11 = -1;
      do {
        lVar11 = lVar11 + 1;
      } while (puVar33[lVar11] != '\0');
      FUN_140054780(&local_14c8,puVar33,lVar11);
      FUN_140089820(param_6,&local_14c8,0,0,CONCAT44(uVar10,0x1c));
      if ((bStack_14a9 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(CONCAT44(iStack_14c4,local_14c8),local_14a8,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
      if ((local_1539 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(CONCAT71(uStack_1557,local_1558),local_1538,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
    }
    else {
      local_1440 = (longlong *)0x0;
      (**(code **)(*param_1 + 0x30))(param_1,local_13c4,&local_1440);
      local_res8 = FUN_1400e40a0(0x288);
      plVar12 = plVar20;
      if (local_res8 != 0) {
        plVar12 = (longlong *)FUN_140116860(local_res8);
      }
      uVar10 = (undefined4)((ulonglong)pcVar40 >> 0x20);
      local_12f0 = plVar12;
      local_10b0 = plVar12;
      if (plVar12 == (longlong *)0x0) {
LAB_14011c803:
        FUN_1400e0f60(&local_14c8,
                      "Compilation failed: Couldn\'t retrieve shader reflection information.");
        puVar25 = &local_14c8;
        if (0x3f < bStack_14a9) {
          puVar25 = (uint *)CONCAT44(iStack_14c4,local_14c8);
        }
        local_1538 = 0x4b;
        local_1558 = 0;
        local_1539 = 0x1f;
        lVar11 = -1;
        do {
          lVar11 = lVar11 + 1;
        } while (*(char *)((longlong)puVar25 + lVar11) != '\0');
        FUN_140054780(&local_1558,puVar25,lVar11);
        FUN_140089820(param_6,&local_1558,0,0,CONCAT44(uVar10,0x1c));
        if ((local_1539 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(CONCAT71(uStack_1557,local_1558),local_1538,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
        }
LAB_14011c89f:
        if ((bStack_14a9 & 0xc0) == 0x40) {
          uVar13 = CONCAT44(iStack_14c4,local_14c8);
          uVar24 = local_14a8;
LAB_14011c8b1:
          thunk_FUN_1403f2404(uVar13,uVar24,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
        }
      }
      else {
        pcVar4 = *(code **)(*plVar12 + 8);
        uVar13 = (**(code **)(*local_1440 + 0x20))();
        uVar14 = (**(code **)(*local_1440 + 0x18))();
        cVar7 = (*pcVar4)(plVar12,uVar14,uVar13);
        uVar10 = (undefined4)((ulonglong)pcVar40 >> 0x20);
        if (cVar7 == '\0') goto LAB_14011c803;
        (**(code **)(*plVar12 + 0x10))(plVar12,local_1078);
        (**(code **)(*local_1470 + 0x18))(local_1470,local_1158);
        uVar31 = local_res8;
        uVar38 = 0;
        local_1530 = 0;
        local_14a0 = (ulonglong)local_14a0._4_4_ << 0x20;
        if (local_114c != 0) {
LAB_14011a910:
          plVar12 = (longlong *)(**(code **)(*local_1470 + 0x20))();
          local_11e0 = plVar12;
          if (plVar12 != (longlong *)0x0) {
            (**(code **)*plVar12)(plVar12,local_1038);
            uVar10 = (undefined4)((ulonglong)pcVar40 >> 0x20);
            uVar35 = local_1038[0] >> 0x10;
            uVar21 = 0;
            puVar25 = &DAT_1405909f8;
LAB_14011a950:
            if (uVar35 != *puVar25) goto code_r0x00014011a954;
            iVar9 = *(int *)(&DAT_1405909fc + (ulonglong)uVar21 * 8);
            if (iVar9 != 0) {
              if ((iVar9 == 1) && (uVar38 == 0x40)) {
                FUN_1400e0f60(&local_14c8,
                              "Compilation failed: Too many ray generation shaders in a single raytrace file. The maximum amount of ray generation shaders in a single raytrace file is %d."
                              ,0x40);
                puVar25 = &local_14c8;
                if (0x3f < bStack_14a9) {
                  puVar25 = (uint *)CONCAT44(iStack_14c4,local_14c8);
                }
                local_1538 = 0x4b;
                local_1558 = 0;
                local_1539 = 0x1f;
                lVar11 = -1;
                do {
                  lVar11 = lVar11 + 1;
                } while (*(char *)((longlong)puVar25 + lVar11) != '\0');
                FUN_140054780(&local_1558,puVar25,lVar11);
                FUN_140089820(param_6,&local_1558,0,0,CONCAT44(uVar10,0x1c));
                if ((local_1539 & 0xc0) == 0x40) {
                  thunk_FUN_1403f2404(CONCAT71(uStack_1557,local_1558),local_1538,
                                      "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                      ,0x218);
                }
                goto LAB_14011c89f;
              }
              local_1380 = 0x4b;
              local_13a0 = 0;
              local_1381 = 0x1f;
              local_1378 = 0;
              local_1370 = 4;
              local_136c = 8;
              uVar13 = FUN_1401189c0(&local_1558,local_fb8);
              FUN_1400545d0(&local_13a0,uVar13);
              if ((local_1539 & 0xc0) == 0x40) {
                thunk_FUN_1403f2404(CONCAT71(uStack_1557,local_1558),local_1538,
                                    "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                   );
              }
              local_1378 = iVar9;
              if (2 < uVar35 - 9) {
                local_res8 = CONCAT44(local_res8._4_4_,iVar9);
                if (uVar35 != 0xc) goto LAB_14011ab92;
              }
              local_11d0 = local_1390;
              if (local_1381 < 0x40) {
                local_11d0 = 0x1f - (longlong)(char)local_1381;
              }
              local_11d8 = &local_13a0;
              if (0x3f < local_1381) {
                local_11d8 = (undefined1 *)CONCAT71(uStack_139f,local_13a0);
              }
              local_12c8 = 1;
              local_12e8 = 0;
              local_12ca = 0xf;
              local_res8 = CONCAT44(local_res8._4_4_,(int)plVar20) | 4;
              if (local_11d0 == 0) {
                local_12e8 = 0;
                local_12ca = 0xf;
              }
              else {
                FUN_140087dd0(&local_11d8,&local_12e8,uVar31 & 0xff);
              }
              local_1528 = CONCAT44(local_1528._4_4_,(int)plVar20) & 0xfffffffffffffffb | 2;
              uVar32 = 0;
              if (local_1078[0] == 0) goto LAB_14011ab72;
              local_res8 = CONCAT44(local_res8._4_4_,iVar9);
              goto LAB_14011ab02;
            }
          }
          goto LAB_14011ba4f;
        }
LAB_14011ba65:
        lVar11 = 0;
        local_1528 = 2;
        do {
          uVar31 = local_1528;
          plVar20 = (longlong *)**(longlong **)((longlong)local_1298 + lVar11);
          if ((longlong *)**(longlong **)((longlong)local_1298 + lVar11) !=
              *(longlong **)((longlong)local_1298 + lVar11)) {
            do {
              bVar5 = false;
              plVar12 = (longlong *)**(longlong **)((longlong)local_11c8 + lVar11);
              if (plVar12 == *(longlong **)((longlong)local_11c8 + lVar11)) {
LAB_14011bfe3:
                plVar12 = (longlong *)plVar20[2];
                if (*(char *)((longlong)plVar12 + 0x19) == '\0') {
                  cVar7 = *(char *)(*plVar12 + 0x19);
                  plVar20 = (longlong *)*plVar12;
                  while (cVar7 == '\0') {
                    cVar7 = *(char *)(*plVar20 + 0x19);
                    plVar12 = plVar20;
                    plVar20 = (longlong *)*plVar20;
                  }
                }
                else {
                  cVar7 = *(char *)(plVar20[1] + 0x19);
                  plVar28 = (longlong *)plVar20[1];
                  while ((plVar12 = plVar28, cVar7 == '\0' && (plVar20 == (longlong *)plVar12[2])))
                  {
                    cVar7 = *(char *)(plVar12[1] + 0x19);
                    plVar28 = (longlong *)plVar12[1];
                    plVar20 = plVar12;
                  }
                }
              }
              else {
                do {
                  if ((int)plVar12[0xf] == -1) {
                    plVar28 = plVar20 + 4;
                    plVar23 = plVar12 + 4;
                    if (0x3f < *(byte *)((longlong)plVar20 + 0x3f)) {
                      plVar28 = (longlong *)*plVar28;
                    }
                    if (0x3f < *(byte *)((longlong)plVar12 + 0x3f)) {
                      plVar23 = (longlong *)*plVar23;
                    }
                    cVar7 = FUN_1400b8430(plVar23,plVar28);
                    if (cVar7 != '\0') {
                      *(undefined4 *)(plVar12 + 0xf) = *(undefined4 *)((longlong)plVar20 + 0x54);
                      bVar5 = true;
                    }
                  }
                  plVar28 = (longlong *)plVar12[2];
                  if (*(char *)((longlong)plVar28 + 0x19) == '\0') {
                    cVar7 = *(char *)(*plVar28 + 0x19);
                    plVar12 = plVar28;
                    plVar28 = (longlong *)*plVar28;
                    while (cVar7 == '\0') {
                      cVar7 = *(char *)(*plVar28 + 0x19);
                      plVar12 = plVar28;
                      plVar28 = (longlong *)*plVar28;
                    }
                  }
                  else {
                    cVar7 = *(char *)(plVar12[1] + 0x19);
                    plVar23 = (longlong *)plVar12[1];
                    plVar28 = plVar12;
                    while ((plVar12 = plVar23, cVar7 == '\0' && (plVar28 == (longlong *)plVar12[2]))
                          ) {
                      cVar7 = *(char *)(plVar12[1] + 0x19);
                      plVar23 = (longlong *)plVar12[1];
                      plVar28 = plVar12;
                    }
                  }
                } while (plVar12 != *(longlong **)((longlong)local_11c8 + lVar11));
                if (!bVar5) goto LAB_14011bfe3;
                plVar12 = (longlong *)plVar20[2];
                if (*(char *)((longlong)plVar12 + 0x19) == '\0') {
                  cVar7 = *(char *)(*plVar12 + 0x19);
                  plVar28 = (longlong *)*plVar12;
                  while (cVar7 == '\0') {
                    cVar7 = *(char *)(*plVar28 + 0x19);
                    plVar12 = plVar28;
                    plVar28 = (longlong *)*plVar28;
                  }
                }
                else {
                  cVar7 = *(char *)(plVar20[1] + 0x19);
                  plVar23 = (longlong *)plVar20[1];
                  plVar28 = plVar20;
                  while ((plVar12 = plVar23, cVar7 == '\0' && (plVar28 == (longlong *)plVar12[2])))
                  {
                    cVar7 = *(char *)(plVar12[1] + 0x19);
                    plVar23 = (longlong *)plVar12[1];
                    plVar28 = plVar12;
                  }
                }
                lVar18 = FUN_14011d1a0((longlong)local_1298 + lVar11,plVar20);
                if ((*(byte *)(lVar18 + 0x3f) & 0xc0) == 0x40) {
                  thunk_FUN_1403f2404(*(undefined8 *)(lVar18 + 0x20),*(undefined2 *)(lVar18 + 0x40),
                                      "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                      ,0x218);
                }
                thunk_FUN_1403f2404(lVar18,0x78);
              }
              plVar20 = plVar12;
            } while (plVar12 != *(longlong **)((longlong)local_1298 + lVar11));
          }
          plVar20 = (longlong *)**(longlong **)((longlong)local_1298 + lVar11);
          if (plVar20 != *(longlong **)((longlong)local_1298 + lVar11)) {
            do {
              plVar12 = plVar20 + 4;
              local_1538 = 0x4b;
              local_1558 = 0;
              local_1539 = 0x1f;
              local_13b0 = local_1278;
              local_1258 = (undefined2)plVar20[8];
              local_1278[0] = 0;
              local_1259 = 0x1f;
              lVar18 = local_1268;
              if ((longlong *)local_1278 != plVar12) {
                if (*(byte *)((longlong)plVar20 + 0x3f) < 0x40) {
                  lVar18 = 0x1f - (longlong)*(char *)((longlong)plVar20 + 0x3f);
                  plVar28 = plVar12;
                }
                else {
                  lVar18 = plVar20[6];
                  plVar28 = (longlong *)*plVar12;
                }
                local_1278[0] = 0;
                local_1259 = 0x1f;
                lVar19 = FUN_140056c90(local_1278,lVar18);
                FUN_140558820(lVar19,plVar28,lVar18);
                *(undefined1 *)(lVar19 + lVar18) = 0;
                if (local_1259 < 0x40) {
                  local_1259 = 0x1f - (char)lVar18;
                  lVar18 = local_1268;
                }
              }
              local_1268 = lVar18;
              puVar25 = (uint *)FUN_1400c3cf0(&local_res8,local_1278,&local_1558);
              local_14a0 = CONCAT44(*(undefined4 *)((longlong)plVar20 + 0x54),*puVar25);
              if (*puVar25 < 0x1000) {
                plVar12 = (longlong *)
                          FUN_140115880((longlong)local_11a8 + lVar11,local_1168,plVar12);
                *(ulonglong *)(*plVar12 + 0x48) = local_14a0;
              }
              else {
                FUN_140089820(param_6,&local_1558,0,0,0x1c);
              }
              if ((local_1539 & 0xc0) == 0x40) {
                thunk_FUN_1403f2404(CONCAT71(uStack_1557,local_1558),local_1538,
                                    "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                   );
              }
              plVar12 = (longlong *)plVar20[2];
              if (*(char *)((longlong)plVar12 + 0x19) == '\0') {
                cVar7 = *(char *)(*plVar12 + 0x19);
                plVar20 = plVar12;
                plVar12 = (longlong *)*plVar12;
                while (cVar7 == '\0') {
                  cVar7 = *(char *)(*plVar12 + 0x19);
                  plVar20 = plVar12;
                  plVar12 = (longlong *)*plVar12;
                }
              }
              else {
                cVar7 = *(char *)(plVar20[1] + 0x19);
                plVar28 = (longlong *)plVar20[1];
                plVar12 = plVar20;
                while ((plVar20 = plVar28, cVar7 == '\0' && (plVar12 == (longlong *)plVar20[2]))) {
                  cVar7 = *(char *)(plVar20[1] + 0x19);
                  plVar28 = (longlong *)plVar20[1];
                  plVar12 = plVar20;
                }
              }
              uVar31 = local_1528;
            } while (plVar20 != *(longlong **)((longlong)local_1298 + lVar11));
          }
          lVar11 = lVar11 + 0x10;
          local_1528 = uVar31 - 1;
        } while (uVar31 - 1 != 0);
        puVar16 = (ulonglong *)(param_4 + 0x17);
        lVar11 = 0;
        local_res8 = 2;
        do {
          lVar18 = local_res8;
          FUN_1401149b0(puVar16 + -0xf,(longlong)local_1128 + lVar11);
          FUN_1401149b0(puVar16 + -0xb,(longlong)local_1148 + lVar11);
          FUN_1401149b0(puVar16 + -0x13,(longlong)local_11c8 + lVar11);
          if (puVar16[-4] >> 1 < *(ulonglong *)((longlong)local_11a8 + lVar11 + 8)) {
            FUN_140058610(puVar16 + -7);
          }
          plVar20 = (longlong *)**(longlong **)((longlong)local_11a8 + lVar11);
          if (plVar20 != *(longlong **)((longlong)local_11a8 + lVar11)) {
            do {
              uVar31 = puVar16[-5];
              uVar32 = uVar31 + 1;
              if (puVar16[-4] >> 1 < uVar32) {
                FUN_140057310(puVar16 + -7);
              }
              puVar16[-5] = uVar32;
              plVar12 = (longlong *)(puVar16[-7] + uVar31 * 8);
              if (plVar12 != (longlong *)0x0) {
                *plVar12 = plVar20[9];
              }
              plVar12 = (longlong *)plVar20[2];
              if (*(char *)((longlong)plVar12 + 0x19) == '\0') {
                cVar7 = *(char *)(*plVar12 + 0x19);
                plVar20 = plVar12;
                plVar12 = (longlong *)*plVar12;
                while (cVar7 == '\0') {
                  cVar7 = *(char *)(*plVar12 + 0x19);
                  plVar20 = plVar12;
                  plVar12 = (longlong *)*plVar12;
                }
              }
              else {
                cVar7 = *(char *)(plVar20[1] + 0x19);
                plVar28 = (longlong *)plVar20[1];
                plVar12 = plVar20;
                while ((plVar20 = plVar28, cVar7 == '\0' && (plVar12 == (longlong *)plVar20[2]))) {
                  cVar7 = *(char *)(plVar20[1] + 0x19);
                  plVar28 = (longlong *)plVar20[1];
                  plVar12 = plVar20;
                }
              }
            } while (plVar20 != *(longlong **)((longlong)local_11a8 + lVar11));
          }
          FUN_1401149b0(puVar16 + 1,(longlong)local_1220 + lVar11);
          if (*puVar16 >> 1 < *(ulonglong *)((longlong)local_11a8 + lVar11 + 0x28)) {
            FUN_140058450(puVar16 + -3);
          }
          plVar20 = (longlong *)**(longlong **)((longlong)local_11a8 + lVar11 + 0x20);
          if (plVar20 != *(longlong **)((longlong)local_11a8 + lVar11 + 0x20)) {
            do {
              uVar31 = puVar16[-1] + 1;
              if (*puVar16 >> 1 < uVar31) {
                FUN_140057330(puVar16 + -3);
              }
              puVar16[-1] = uVar31;
              puVar33 = (undefined1 *)((puVar16[-3] - 0x50) + uVar31 * 0x50);
              local_13b0 = puVar33;
              local_13c0 = puVar33;
              if (puVar33 != (undefined1 *)0x0) {
                FUN_1400149f0(puVar33,plVar20 + 9);
                *(int *)(puVar33 + 0x28) = (int)plVar20[0xe];
                *(undefined4 *)(puVar33 + 0x2c) = *(undefined4 *)((longlong)plVar20 + 0x74);
                *(undefined8 *)(puVar33 + 0x30) = 0;
                *(short *)(puVar33 + 0x38) = (short)plVar20[0x10];
                *(undefined8 *)(puVar33 + 0x40) = 0;
                *(undefined8 *)(puVar33 + 0x48) = 1;
                FUN_14011da10(puVar33 + 0x30,plVar20[0xf],plVar20[0x11] * 0x40 + plVar20[0xf]);
              }
              plVar12 = (longlong *)plVar20[2];
              if (*(char *)((longlong)plVar12 + 0x19) == '\0') {
                cVar7 = *(char *)(*plVar12 + 0x19);
                plVar20 = plVar12;
                plVar12 = (longlong *)*plVar12;
                while (cVar7 == '\0') {
                  cVar7 = *(char *)(*plVar12 + 0x19);
                  plVar20 = plVar12;
                  plVar12 = (longlong *)*plVar12;
                }
              }
              else {
                cVar7 = *(char *)(plVar20[1] + 0x19);
                plVar28 = (longlong *)plVar20[1];
                plVar12 = plVar20;
                while ((plVar20 = plVar28, cVar7 == '\0' && (plVar12 == (longlong *)plVar20[2]))) {
                  cVar7 = *(char *)(plVar20[1] + 0x19);
                  plVar28 = (longlong *)plVar20[1];
                  plVar12 = plVar20;
                }
              }
              lVar18 = local_res8;
            } while (plVar20 != *(longlong **)((longlong)local_11a8 + lVar11 + 0x20));
          }
          lVar11 = lVar11 + 0x10;
          puVar16 = puVar16 + 0x18;
          local_res8 = lVar18 + -1;
        } while (local_res8 != 0);
        local_res8 = 0;
        if (param_5 != (longlong *)0x0) {
          local_14a0 = 0;
          local_res8 = 0;
          if (param_4[0x16] != 0) {
            local_1528 = 0;
            local_res8 = 0;
            do {
              lVar11 = 0;
              puVar39 = (undefined8 *)(param_4[0x14] + local_1528);
              puVar17 = puVar39;
              if (0x3f < *(byte *)((longlong)puVar39 + 0x1f)) {
                puVar17 = (undefined8 *)*puVar39;
              }
              (**(code **)(*param_5 + 0x10))
                        (param_5,puVar17,*(undefined4 *)(puVar39 + 5),*(undefined4 *)(puVar39 + 8));
              local_res8 = 0;
              if (puVar39[8] != 0) {
                do {
                  puVar34 = (undefined8 *)(puVar39[6] + lVar11);
                  puVar17 = puVar34;
                  if (0x3f < *(byte *)((longlong)puVar34 + 0x1f)) {
                    puVar17 = (undefined8 *)*puVar34;
                  }
                  local_1478 = 0x4b;
                  uVar31 = 0xffffffffffffffff;
                  do {
                    uVar31 = uVar31 + 1;
                  } while (*(char *)((longlong)puVar17 + uVar31) != '\0');
                  local_1498 = 0;
                  local_1479 = 0x1f;
                  lVar18 = FUN_140056c90(&local_1498,uVar31);
                  FUN_140558820(lVar18,puVar17,uVar31);
                  *(undefined1 *)(lVar18 + uVar31) = 0;
                  if (local_1479 < 0x40) {
                    local_1479 = 0x1f - (char)uVar31;
                    uVar31 = local_1488;
                  }
                  local_1488 = uVar31;
                  plVar20 = (longlong *)FUN_140115dd0(local_10a8,local_1168,&local_1498);
                  lVar18 = *plVar20;
                  if ((local_1479 & 0xc0) == 0x40) {
                    thunk_FUN_1403f2404(CONCAT71(uStack_1497,local_1498),local_1478,
                                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                        ,0x218);
                  }
                  puVar17 = puVar34 + 6;
                  if (0x3f < *(byte *)((longlong)puVar34 + 0x1f)) {
                    puVar34 = (undefined8 *)*puVar34;
                  }
                  if (*(int *)(lVar18 + 0x48) == 3) {
                    if (*(int *)(lVar18 + 0x4c) != 3) goto LAB_14011c63a;
                    if (*(int *)(lVar18 + 0x54) != 4) goto LAB_14011c634;
                    pcVar40 = *(code **)(*param_5 + 0x18);
                    uVar10 = *(undefined4 *)(lVar18 + 0x58);
                    uVar42 = *(undefined4 *)(lVar18 + 0x54);
                    uVar41 = *(undefined4 *)(lVar18 + 0x50);
                    uVar14 = 1;
                    uVar13 = 0;
LAB_14011c6cb:
                    (*pcVar40)(param_5,puVar34,*(undefined4 *)puVar17,uVar13,uVar14,uVar41,uVar42,
                               uVar10);
                  }
                  else {
LAB_14011c634:
                    if (*(int *)(lVar18 + 0x4c) == 3) {
LAB_14011c650:
                      if (*(int *)(lVar18 + 0x50) == 1) {
                        if (*(int *)(lVar18 + 0x4c) == 3) {
                          uVar13 = 0;
                        }
                        else if (*(int *)(lVar18 + 0x4c) == 1) {
                          uVar13 = 2;
                        }
                        else {
                          uVar13 = 1;
                          if (*(int *)(lVar18 + 0x4c) == 0x13) {
                            uVar13 = 5;
                          }
                        }
                        if (*(int *)(lVar18 + 0x48) == 1) {
                          pcVar40 = *(code **)(*param_5 + 0x18);
                          uVar10 = *(undefined4 *)(lVar18 + 0x58);
                          uVar42 = *(undefined4 *)(lVar18 + 0x54);
                        }
                        else {
                          if ((*(int *)(lVar18 + 0x48) != 0) || (*(int *)(lVar18 + 0x54) != 1))
                          goto LAB_14011c6d4;
                          pcVar40 = *(code **)(*param_5 + 0x18);
                          uVar10 = *(undefined4 *)(lVar18 + 0x58);
                          uVar42 = 1;
                        }
                        uVar41 = 1;
                        uVar14 = 0;
                        goto LAB_14011c6cb;
                      }
                    }
                    else {
LAB_14011c63a:
                      if (((*(int *)(lVar18 + 0x4c) == 2) || (*(int *)(lVar18 + 0x4c) == 0x13)) ||
                         (*(int *)(lVar18 + 0x4c) == 1)) goto LAB_14011c650;
                    }
                  }
LAB_14011c6d4:
                  local_res8 = local_res8 + 1;
                  lVar11 = lVar11 + 0x40;
                } while (local_res8 < (ulonglong)puVar39[8]);
              }
              local_14a0 = local_14a0 + 1;
              local_1528 = local_1528 + 0x50;
            } while (local_14a0 < (ulonglong)param_4[0x16]);
          }
          uVar30 = 0;
          uVar31 = uVar30;
          uVar32 = uVar30;
          if (param_4[0x1a] != 0) {
            do {
              puVar39 = (undefined8 *)(param_4[0x18] + uVar31);
              puVar17 = puVar39 + 5;
              if (0x3f < *(byte *)((longlong)puVar39 + 0x1f)) {
                puVar39 = (undefined8 *)*puVar39;
              }
              (**(code **)(*param_5 + 0x20))(param_5,puVar39,*(undefined4 *)puVar17);
              uVar32 = uVar32 + 1;
              uVar31 = uVar31 + 0x48;
            } while (uVar32 < (ulonglong)param_4[0x1a]);
          }
          uVar31 = uVar30;
          uVar32 = uVar30;
          if (param_4[6] != 0) {
            do {
              puVar29 = (undefined8 *)(param_4[4] + uVar31);
              puVar1 = (undefined4 *)((longlong)puVar29 + 0x34);
              puVar17 = puVar29 + 8;
              puVar39 = puVar29 + 6;
              puVar34 = puVar29 + 5;
              if (0x3f < *(byte *)((longlong)puVar29 + 0x1f)) {
                puVar29 = (undefined8 *)*puVar29;
              }
              (**(code **)(*param_5 + 0x28))
                        (param_5,puVar29,*(undefined4 *)puVar34,*(undefined4 *)puVar39,
                         *(undefined1 *)puVar17,*puVar1);
              uVar32 = uVar32 + 1;
              uVar31 = uVar31 + 0x48;
            } while (uVar32 < (ulonglong)param_4[6]);
          }
          uVar31 = uVar30;
          if (param_4[10] != 0) {
            do {
              puVar39 = (undefined8 *)(param_4[8] + uVar30);
              puVar1 = (undefined4 *)((longlong)puVar39 + 0x2c);
              puVar17 = puVar39 + 5;
              if (0x3f < *(byte *)((longlong)puVar39 + 0x1f)) {
                puVar39 = (undefined8 *)*puVar39;
              }
              (**(code **)(*param_5 + 0x38))(param_5,puVar39,*(undefined4 *)puVar17,*puVar1);
              uVar31 = uVar31 + 1;
              uVar30 = uVar30 + 0x48;
            } while (uVar31 < (ulonglong)param_4[10]);
          }
        }
      }
LAB_14011c8c6:
      if (local_12f0 != (longlong *)0x0) {
        (**(code **)*local_12f0)(local_12f0,1);
      }
      if (local_1440 != (longlong *)0x0) {
        (**(code **)(*local_1440 + 0x10))();
        local_1440 = (longlong *)0x0;
      }
    }
  }
  if (local_1470 != (longlong *)0x0) {
    (**(code **)(*local_1470 + 0x10))();
    local_1470 = (longlong *)0x0;
  }
LAB_14011c918:
  _eh_vector_destructor_iterator_(local_10a8,0x10,2,FUN_1401170c0);
  _eh_vector_destructor_iterator_(local_1200,0x10,2,FUN_1400afe30);
  _eh_vector_destructor_iterator_(local_1298,0x10,2,FUN_140117090);
  _eh_vector_destructor_iterator_(local_11a8 + 4,0x10,2,FUN_140117030);
  _eh_vector_destructor_iterator_(local_1220,0x10,2,FUN_140117060);
  _eh_vector_destructor_iterator_(local_11a8,0x10,2,FUN_1400afe30);
  _eh_vector_destructor_iterator_(local_11c8,0x10,2,FUN_140117060);
  _eh_vector_destructor_iterator_(local_1148,0x10,2,FUN_140117060);
  _eh_vector_destructor_iterator_(local_1128,0x10,2,FUN_140117060);
  return;
code_r0x00014011a954:
  uVar21 = uVar21 + 1;
  puVar25 = puVar25 + 2;
  if (5 < uVar21) goto LAB_14011ba4f;
  goto LAB_14011a950;
LAB_14011ab02:
  lVar11 = local_1070 + uVar32 * 0x48;
  psVar15 = &local_12e8;
  if (0x3f < local_12ca._1_1_) {
    psVar15 = (short *)CONCAT62(uStack_12e6,local_12e8);
  }
  lVar18 = *(longlong *)(lVar11 + 8) - (longlong)psVar15;
  do {
    sVar2 = *psVar15;
    sVar3 = *(short *)((longlong)psVar15 + lVar18);
    if (sVar2 != sVar3) break;
    psVar15 = psVar15 + 1;
  } while (sVar3 != 0);
  if (sVar2 != sVar3) goto LAB_14011ab6a;
  uVar38 = *(uint *)(lVar11 + 0x30);
  if (uVar38 < 0x21) {
    local_136c = uVar38;
    local_1370 = *(undefined4 *)(lVar11 + 0x2c);
    goto LAB_14011ab6a;
  }
  puVar33 = &local_13a0;
  if (0x3f < local_1381) {
    puVar33 = (undefined1 *)CONCAT71(uStack_139f,local_13a0);
  }
  uVar13 = CONCAT44((int)((ulonglong)pcVar40 >> 0x20),0x20);
  FUN_1400e0f60(&local_1438,
                "Compilation failed: The attribute size for Ray Tracing Shader function \"%s\" is %d which exceeded the maximum allowed value of %d."
                ,puVar33,uVar38,uVar13);
  uVar10 = (undefined4)((ulonglong)uVar13 >> 0x20);
  puVar17 = &local_1438;
  if (0x3f < local_1419) {
    puVar17 = local_1438;
  }
  local_1538 = 0x4b;
  local_1558 = 0;
  local_1539 = 0x1f;
  lVar11 = -1;
  do {
    lVar11 = lVar11 + 1;
  } while (*(char *)((longlong)puVar17 + lVar11) != '\0');
  FUN_140054780(&local_1558,puVar17,lVar11);
  FUN_140089820(param_6,&local_1558,0,0,CONCAT44(uVar10,0x1c));
  if ((local_1539 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_1557,local_1558),local_1538,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  if ((local_1419 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(local_1438,local_1418,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                        ,0x218);
  }
  if ((local_12ca._1_1_ & 0xc0) == 0x40) {
    uVar13 = CONCAT62(uStack_12e6,local_12e8);
    uVar24 = local_12c8;
    goto LAB_14011bed3;
  }
  goto LAB_14011bee6;
LAB_14011ab6a:
  uVar38 = (int)uVar32 + 1;
  uVar32 = (ulonglong)uVar38;
  if (local_1078[0] <= uVar38) goto LAB_14011ab72;
  goto LAB_14011ab02;
LAB_14011ab72:
  local_res8 = CONCAT44(local_res8._4_4_,iVar9);
  if ((local_12ca._1_1_ & 0xc0) == 0x40) {
    thunk_FUN_1403f2404((short *)CONCAT62(uStack_12e6,local_12e8),local_12c8,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                       );
  }
LAB_14011ab92:
  uVar32 = param_4[2] + 1;
  if ((ulonglong)param_4[3] >> 1 < uVar32) {
    FUN_14011db70(param_4);
  }
  param_4[2] = uVar32;
  puVar33 = (undefined1 *)(*param_4 + -0x38 + uVar32 * 0x38);
  local_13c0 = puVar33;
  local_13b0 = puVar33;
  if (puVar33 != (undefined1 *)0x0) {
    FUN_1400149f0(puVar33,&local_13a0);
    *(int *)(puVar33 + 0x28) = local_1378;
    *(undefined4 *)(puVar33 + 0x30) = local_1370;
    *(uint *)(puVar33 + 0x34) = local_136c;
  }
  uVar38 = 0;
  if (local_1020 != 0) {
    do {
      lVar11 = -1;
      (**(code **)(*plVar12 + 0x18))(plVar12,uVar38,&local_1250);
      local_1448 = 0x4b;
      local_1468 = 0;
      local_1449 = 0x1f;
      lVar18 = -1;
      do {
        lVar18 = lVar18 + 1;
      } while (local_1250[lVar18] != '\0');
      FUN_140054780(&local_1468);
      uVar10 = (undefined4)((ulonglong)pcVar40 >> 0x20);
      if (1 < uStack_122c) {
        FUN_1400e0f60(&local_1438,"Compilation failed: Register space %d not supported.");
        puVar17 = &local_1438;
        if (0x3f < local_1419) {
          puVar17 = local_1438;
        }
        local_1538 = 0x4b;
        local_1558 = 0;
        local_1539 = 0x1f;
        do {
          lVar11 = lVar11 + 1;
        } while (*(char *)((longlong)puVar17 + lVar11) != '\0');
        FUN_140054780(&local_1558,puVar17,lVar11);
        FUN_140089820(param_6,&local_1558,0,0,CONCAT44(uVar10,0x1c));
        if ((local_1539 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(CONCAT71(uStack_1557,local_1558),local_1538,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
        }
        if ((local_1419 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(local_1438,local_1418,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                              ,0x218);
        }
        if ((local_1449 & 0xc0) == 0x40) {
          uVar13 = CONCAT71(uStack_1467,local_1468);
          uVar24 = local_1448;
          goto LAB_14011bed3;
        }
        goto LAB_14011bee6;
      }
      uVar32 = (ulonglong)(uStack_122c != 0);
      if (iVar9 == 1) {
        FUN_1401150c0(local_1200 + uVar32 * 2,&local_1438,&local_1468);
        lVar11 = local_1428;
        if ((*(char *)(local_1428 + 0x19) == '\0') &&
           (cVar7 = FUN_14001b610(local_1200 + uVar32 * 2,&local_1468,local_1428 + 0x20),
           cVar7 == '\0')) {
          plVar20 = local_1200 + uVar32 * 2;
          if (lVar11 == local_1200[uVar32 * 2]) goto LAB_14011ad0e;
          puVar16 = (ulonglong *)FUN_1401173d0(plVar20,&local_1468);
          uVar30 = *puVar16 | 1L << ((ulonglong)local_1530 & 0x3f);
        }
        else {
          plVar20 = local_1200 + uVar32 * 2;
LAB_14011ad0e:
          puVar16 = (ulonglong *)FUN_1401173d0(plVar20,&local_1468);
          uVar30 = 1L << ((byte)local_1530 & 0x3f);
        }
        *puVar16 = uVar30;
      }
      local_14f8 = 0x4b;
      local_1518 = 0;
      local_14f9 = 0x1f;
      local_14f0 = 0xffffffff;
      local_14ec = 1;
      local_14e8 = 0xffffffffffffffff;
      local_14e0 = 0;
      local_14d8 = 0;
      uVar30 = local_1458;
      if (local_1449 < 0x40) {
        uVar30 = 0x1f - (longlong)(char)local_1449;
      }
      pbVar22 = &local_1468;
      if (0x3f < local_1449) {
        pbVar22 = (byte *)CONCAT71(uStack_1467,local_1468);
      }
      FUN_140054780(&local_1518,pbVar22,uVar30);
      local_14f0 = uStack_1244;
      local_14ec = local_1240;
      FUN_1401150c0(local_1200 + uVar32 * 2,&local_1438,&local_1468);
      if (*(char *)(local_1428 + 0x19) == '\0') {
        pbVar22 = (byte *)(local_1428 + 0x20);
        local_res8 = CONCAT44(local_res8._4_4_,iVar9);
        if (*(byte *)(local_1428 + 0x3f) < 0x40) {
          uVar30 = 0x1f - (longlong)*(char *)(local_1428 + 0x3f);
        }
        else {
          uVar30 = *(ulonglong *)(local_1428 + 0x30);
          pbVar22 = *(byte **)pbVar22;
        }
        uVar37 = local_1458;
        if (local_1449 < 0x40) {
          uVar37 = 0x1f - (longlong)(char)local_1449;
        }
        pbVar26 = &local_1468;
        if (0x3f < local_1449) {
          pbVar26 = (byte *)CONCAT71(uStack_1467,local_1468);
        }
        uVar6 = uVar37;
        if (uVar30 < uVar37) {
          uVar6 = uVar30;
        }
        for (; uVar6 != 0; uVar6 = uVar6 - 1) {
          if (*pbVar26 != *pbVar22) {
            iVar36 = (uint)*pbVar26 - (uint)*pbVar22;
            goto LAB_14011ae3a;
          }
          pbVar26 = pbVar26 + 1;
          pbVar22 = pbVar22 + 1;
        }
        iVar36 = (int)uVar37 - (int)uVar30;
LAB_14011ae3a:
        if ((iVar36 < 0) || (local_1428 == local_1200[uVar32 * 2])) goto LAB_14011ae81;
        puVar17 = (undefined8 *)FUN_1401173d0(local_1200 + uVar32 * 2,&local_1468);
        local_14e0 = *puVar17;
      }
      else {
LAB_14011ae81:
        local_14e0 = 0;
      }
      uVar10 = (undefined4)((ulonglong)pcVar40 >> 0x20);
      local_14d8 = local_1230 != -1;
      switch(uStack_1248) {
      case 0:
        plVar20 = local_1220;
        break;
      default:
        FUN_1400e0f60(local_12c0,
                      "Compilation failed: Unrecognized resource binding type (%i) for %s.");
        pcVar40 = (code *)CONCAT44(uVar10,0x1c);
        FUN_140089820(param_6,local_12c0,0,0,pcVar40);
        if ((local_12a1 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(local_12c0[0],local_12a0,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                             );
        }
        if ((local_14f9 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(CONCAT71(uStack_1517,local_1518),local_14f8,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                             );
        }
        if ((local_1449 & 0xc0) == 0x40) {
          thunk_FUN_1403f2404(CONCAT71(uStack_1467,local_1468),local_1448,
                              "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                             );
        }
        goto LAB_14011b220;
      case 2:
        if (iStack_1234 == 1) {
          local_14e8 = local_14e8 & 0xffffffff;
          goto switchD_14011aeb6_caseD_5;
        }
        switch(iStack_1234) {
        case 4:
        case 6:
          local_14e8 = 0x2ffffffff;
          plVar20 = local_11c8;
          break;
        case 5:
        case 7:
          local_14e8 = 0x5ffffffff;
          plVar20 = local_11c8;
          break;
        case 8:
          local_14e8 = 0x3ffffffff;
          plVar20 = local_11c8;
          break;
        case 9:
          local_14e8 = 0x4ffffffff;
          plVar20 = local_11c8;
          break;
        case 10:
          local_14e8 = 0x6ffffffff;
          plVar20 = local_11c8;
          break;
        default:
          FUN_1400e0f60(local_10d8,"Compilation failed: Unrecognized sampler dimension (%i) for %s")
          ;
          pcVar40 = (code *)CONCAT44(uVar10,0x1c);
          FUN_140089820(param_6,local_10d8,0,0,pcVar40);
          if ((local_10b9 & 0xc0) == 0x40) {
            thunk_FUN_1403f2404(local_10d8[0],local_10b8,
                                "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                               );
          }
          local_14e8 = 0xffffffffffffffff;
          plVar20 = local_11c8;
        }
        break;
      case 3:
        uStack_13a8 = CONCAT44(uStack_1244,uStack_1248);
        local_13b0 = local_1250;
        local_13c0 = (undefined1 *)CONCAT44(uStack_123c,local_1240);
        uStack_13b8 = CONCAT44(iStack_1234,uStack_1238);
        local_1438 = (undefined8 *)CONCAT44(uStack_122c,local_1230);
        uStack_1430._0_4_ = uStack_1228;
        uStack_1430._4_4_ = uStack_1224;
        plVar20 = (longlong *)FUN_140115c10(local_1298 + uVar32 * 2,local_1048,&local_1468);
        lVar11 = *plVar20;
        *(undefined1 **)(lVar11 + 0x48) = local_13b0;
        *(undefined8 *)(lVar11 + 0x50) = uStack_13a8;
        *(undefined1 **)(lVar11 + 0x58) = local_13c0;
        *(undefined8 *)(lVar11 + 0x60) = uStack_13b8;
        *(undefined4 *)(lVar11 + 0x68) = (undefined4)local_1438;
        *(undefined4 *)(lVar11 + 0x6c) = local_1438._4_4_;
        *(undefined4 *)(lVar11 + 0x70) = (undefined4)uStack_1430;
        *(undefined4 *)(lVar11 + 0x74) = uStack_1430._4_4_;
        goto LAB_14011b11c;
      case 4:
        if (iStack_1234 == 1) {
          local_14e8 = local_14e8 & 0xffffffff;
        }
        else if (iStack_1234 == 4) {
          local_14e8 = CONCAT44(2,(undefined4)local_14e8);
        }
        else if (iStack_1234 == 5) {
          local_14e8 = CONCAT44(5,(undefined4)local_14e8);
        }
        else if (iStack_1234 == 8) {
          local_14e8 = CONCAT44(3,(undefined4)local_14e8);
        }
        else {
          local_14e8 = CONCAT44(0xffffffff,(undefined4)local_14e8);
        }
        goto LAB_14011b0a4;
      case 5:
      case 7:
      case 0xc:
switchD_14011aeb6_caseD_5:
        plVar20 = local_1128;
        break;
      case 6:
      case 8:
      case 9:
      case 10:
      case 0xb:
        local_14e8 = local_14e8 & 0xffffffff;
LAB_14011b0a4:
        plVar20 = local_1148;
      }
      puVar33 = (undefined1 *)FUN_1401172b0(plVar20 + uVar32 * 2,&local_1468);
      if (puVar33 != &local_1518) {
        lVar11 = local_1508;
        if (local_14f9 < 0x40) {
          lVar11 = 0x1f - (longlong)(char)local_14f9;
        }
        puVar27 = &local_1518;
        if (0x3f < local_14f9) {
          puVar27 = (undefined1 *)CONCAT71(uStack_1517,local_1518);
        }
        FUN_140054780(puVar33,puVar27,lVar11);
      }
      *(undefined4 *)(puVar33 + 0x28) = local_14f0;
      *(undefined4 *)(puVar33 + 0x2c) = local_14ec;
      *(undefined4 *)(puVar33 + 0x30) = (undefined4)local_14e8;
      *(undefined4 *)(puVar33 + 0x34) = local_14e8._4_4_;
      *(undefined8 *)(puVar33 + 0x38) = local_14e0;
      puVar33[0x40] = local_14d8;
LAB_14011b11c:
      if ((local_14f9 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(CONCAT71(uStack_1517,local_1518),local_14f8,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                           );
      }
      if ((local_1449 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(CONCAT71(uStack_1467,local_1468),local_1448,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                           );
      }
LAB_14011b220:
      uVar38 = uVar38 + 1;
    } while (uVar38 < local_1020);
  }
  uVar38 = 0;
  if (local_1024 != 0) {
LAB_14011b257:
    plVar20 = (longlong *)(**(code **)(*local_11e0 + 8))(local_11e0,uVar38);
    if ((plVar20 == (longlong *)0x0) ||
       ((**(code **)*plVar20)(plVar20,&local_1498), local_1490 == 3)) goto LAB_14011b9e9;
    local_12f8 = 0x4b;
    local_1318 = 0;
    local_12f9 = 0x1f;
    lVar11 = -1;
    do {
      lVar11 = lVar11 + 1;
    } while (*(char *)(CONCAT71(uStack_1497,local_1498) + lVar11) != '\0');
    FUN_140054780(&local_1318);
    FUN_1401150c0(local_1220,&local_1438,&local_1318);
    lVar18 = local_1220[0];
    lVar11 = local_1428;
    if ((*(char *)(local_1428 + 0x19) != '\0') ||
       (cVar7 = FUN_14001b610(local_1220,&local_1318,local_1428 + 0x20), cVar7 != '\0')) {
      lVar11 = lVar18;
    }
    if (lVar11 == lVar18) {
      FUN_1401150c0(local_1210,&local_1438,&local_1318);
      if (*(char *)(local_1428 + 0x19) == '\0') {
        pbVar22 = (byte *)(local_1428 + 0x20);
        if (*(byte *)(local_1428 + 0x3f) < 0x40) {
          uVar32 = 0x1f - (longlong)*(char *)(local_1428 + 0x3f);
        }
        else {
          uVar32 = *(ulonglong *)(local_1428 + 0x30);
          pbVar22 = *(byte **)pbVar22;
        }
        uVar30 = local_1308;
        if (local_12f9 < 0x40) {
          uVar30 = 0x1f - (longlong)(char)local_12f9;
        }
        pbVar26 = &local_1318;
        if (0x3f < local_12f9) {
          pbVar26 = (byte *)CONCAT71(uStack_1317,local_1318);
        }
        uVar37 = uVar30;
        if (uVar32 < uVar30) {
          uVar37 = uVar32;
        }
        for (; uVar37 != 0; uVar37 = uVar37 - 1) {
          if (*pbVar26 != *pbVar22) {
            iVar9 = (uint)*pbVar26 - (uint)*pbVar22;
            goto LAB_14011b3d6;
          }
          pbVar26 = pbVar26 + 1;
          pbVar22 = pbVar22 + 1;
        }
        iVar9 = (int)uVar30 - (int)uVar32;
LAB_14011b3d6:
        lVar11 = local_1428;
        if (iVar9 < 0) goto LAB_14011b3db;
      }
      else {
LAB_14011b3db:
        lVar11 = local_1210[0];
      }
      if (lVar11 == local_1210[0]) goto LAB_14011b400;
      uVar21 = 1;
      lVar11 = 1;
    }
    else {
LAB_14011b400:
      lVar11 = 0;
      uVar21 = 0;
    }
    if ((uint)local_1488 < 0x10001) {
      local_1348 = 0x4b;
      local_1368 = 0;
      local_1349 = 0x1f;
      local_1340 = 0;
      local_1338 = 0;
      local_1330 = 0x4d;
      local_1328 = 0;
      local_1320 = 1;
      if (local_148c != 0) {
        FUN_1400586f0(&local_1338);
      }
      local_1340 = CONCAT44(local_1340._4_4_,(uint)local_1488);
      lVar18 = -1;
      do {
        lVar18 = lVar18 + 1;
      } while (*(char *)(CONCAT71(uStack_1497,local_1498) + lVar18) != '\0');
      FUN_140054780(&local_1368);
      uVar35 = 0;
      if (local_148c != 0) {
        do {
          plVar12 = (longlong *)(**(code **)(*plVar20 + 8))(plVar20,uVar35);
          if ((plVar12 != (longlong *)0x0) &&
             (((**(code **)*plVar12)(plVar12,&local_1108), uVar21 != 0 || ((local_10f8 & 2) != 0))))
          {
            puVar17 = (undefined8 *)(**(code **)(*plVar12 + 8))(plVar12);
            (**(code **)*puVar17)(puVar17,&local_14c8);
            local_1438 = (undefined8 *)CONCAT44(iStack_14c4,local_14c8);
            uStack_1430 = CONCAT44(uStack_14bc,uStack_14c0);
            local_13b0 = (undefined1 *)CONCAT44(uStack_14b4,local_14b8);
            uStack_13a8 = CONCAT17(bStack_14a9,uStack_14b0);
            local_13c0 = (undefined1 *)CONCAT62(uStack_14a6,local_14a8);
            local_1538 = 0x4b;
            local_1558 = 0;
            local_1539 = 0x1f;
            lVar18 = -1;
            do {
              lVar18 = lVar18 + 1;
            } while (*(char *)(local_1108 + lVar18) != '\0');
            FUN_140054780(&local_1558);
            plVar12 = (longlong *)
                      FUN_140115dd0(local_10a8 + (ulonglong)uVar21 * 0x10,local_1088,&local_1558);
            lVar18 = *plVar12;
            *(undefined8 **)(lVar18 + 0x48) = local_1438;
            *(undefined8 *)(lVar18 + 0x50) = uStack_1430;
            *(undefined4 *)(lVar18 + 0x58) = (undefined4)local_13b0;
            *(undefined4 *)(lVar18 + 0x5c) = local_13b0._4_4_;
            *(undefined4 *)(lVar18 + 0x60) = (undefined4)uStack_13a8;
            *(undefined4 *)(lVar18 + 100) = uStack_13a8._4_4_;
            *(undefined1 **)(lVar18 + 0x68) = local_13c0;
            if ((local_1539 & 0xc0) == 0x40) {
              thunk_FUN_1403f2404(CONCAT71(uStack_1557,local_1558),local_1538,
                                  "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                 );
            }
            local_13e8 = 0x4b;
            local_1408 = 0;
            local_13e9 = 0x1f;
            local_13e0 = 0;
            local_13d4 = 0;
            local_13cc = 0;
            local_13d8 = local_1100;
            lVar18 = -1;
            do {
              lVar18 = lVar18 + 1;
            } while (*(char *)(local_1108 + lVar18) != '\0');
            FUN_140054780(&local_1408);
            local_13e0 = CONCAT44(local_10fc,(undefined4)local_13e0);
            lVar18 = FUN_140056960(&local_1408,&DAT_14057b9b0,0);
            uVar10 = (undefined4)((ulonglong)pcVar40 >> 0x20);
            if (lVar18 != -1) {
              puVar33 = &local_1408;
              if (0x3f < local_13e9) {
                puVar33 = (undefined1 *)CONCAT71(uStack_1407,local_1408);
              }
              FUN_1400e0f60(&local_1558,
                            "\"%s\" contains consecutive underscores (\"__\"), such names are reserved and might result in undefined behaviour"
                            ,puVar33);
              local_1528 = local_1528 | 1;
              pcVar40 = (code *)CONCAT44(uVar10,0x1c);
              FUN_140089820(param_6,&local_1558,0,1,pcVar40);
              if ((local_1539 & 0xc0) == 0x40) {
                thunk_FUN_1403f2404(CONCAT71(uStack_1557,local_1558),local_1538,
                                    "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                   );
              }
            }
            uVar10 = (undefined4)((ulonglong)pcVar40 >> 0x20);
            if (iStack_14c4 == 1) {
              uVar10 = 2;
LAB_14011b7ae:
              local_13e0 = CONCAT44(local_13e0._4_4_,uVar10);
            }
            else if (iStack_14c4 == 2) {
              uVar10 = 1;
              local_13e0 = CONCAT44(local_13e0._4_4_,1);
            }
            else {
              if (iStack_14c4 != 3) {
                if (iStack_14c4 != 0x13) {
                  uVar13 = FUN_1400e0f60(&local_1558,
                                         "Compilation failed: Unknown parameter type (%d) for %s.");
                  pcVar40 = (code *)CONCAT44(uVar10,0x1c);
                  FUN_140089820(param_6,uVar13,0,0,pcVar40);
                  if ((local_1539 & 0xc0) == 0x40) {
                    thunk_FUN_1403f2404(CONCAT71(uStack_1557,local_1558),local_1538,
                                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                       );
                  }
                  if ((local_13e9 & 0xc0) == 0x40) {
                    thunk_FUN_1403f2404(CONCAT71(uStack_1407,local_1408),local_13e8,
                                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                       );
                  }
                  goto LAB_14011b8b6;
                }
                uVar10 = 5;
                goto LAB_14011b7ae;
              }
              uVar10 = 0;
              local_13e0 = (ulonglong)local_13e0._4_4_ << 0x20;
            }
            if (3 < local_14c8) {
              uVar13 = FUN_1400e0f60(local_12c0,
                                     "Compilation failed: Unknown parameter type class (%d) for %s."
                                     ,local_14c8,CONCAT62(uStack_14a6,local_14a8));
              FUN_140089820(param_6,uVar13,0,0,0x1c);
              if ((local_12a1 & 0xc0) == 0x40) {
                thunk_FUN_1403f2404(local_12c0[0],local_12a0,
                                    "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                    ,0x218);
              }
              if ((local_13e9 & 0xc0) == 0x40) {
                thunk_FUN_1403f2404(CONCAT71(uStack_1407,local_1408),local_13e8,
                                    "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                    ,0x218);
              }
              FUN_140018150(&local_1338);
              if ((local_1349 & 0xc0) != 0x40) goto LAB_14011beb8;
              local_12c0[0] = CONCAT71(uStack_1367,local_1368);
              local_12a0 = local_1348;
              goto LAB_14011bea5;
            }
            local_13d4._4_4_ = local_14b8;
            local_13cc = CONCAT11((char)uStack_14bc,(char)uStack_14c0);
            uVar10 = FUN_1400ec750(uVar10);
            local_13d4 = CONCAT44(local_13d4._4_4_,uVar10);
            uVar32 = local_1328 + 1;
            if (local_1320 >> 1 < uVar32) {
              FUN_140057440(&local_1338);
            }
            puVar33 = (undefined1 *)(uVar32 * 0x40 + local_1338 + -0x40);
            local_13c0 = puVar33;
            local_13b0 = puVar33;
            local_1328 = uVar32;
            if (puVar33 != (undefined1 *)0x0) {
              FUN_1400149f0(puVar33,&local_1408);
              *(undefined4 *)(puVar33 + 0x28) = (undefined4)local_13e0;
              *(uint *)(puVar33 + 0x2c) = local_13e0._4_4_;
              *(undefined4 *)(puVar33 + 0x30) = local_13d8;
              *(undefined4 *)(puVar33 + 0x34) = (undefined4)local_13d4;
              *(undefined4 *)(puVar33 + 0x38) = local_13d4._4_4_;
              puVar33[0x3c] = (undefined1)local_13cc;
              puVar33[0x3d] = local_13cc._1_1_;
            }
            if ((local_13e9 & 0xc0) == 0x40) {
              thunk_FUN_1403f2404(CONCAT71(uStack_1407,local_1408),local_13e8,
                                  "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                                 );
            }
          }
LAB_14011b8b6:
          uVar35 = uVar35 + 1;
        } while (uVar35 < local_148c);
      }
      uVar10 = FUN_1400ec5e0(&local_1368);
      local_1340 = CONCAT44(uVar10,(undefined4)local_1340);
      plVar20 = (longlong *)FUN_140115a30(local_11a8 + lVar11 * 2 + 4,local_1168,&local_1318);
      lVar11 = *plVar20;
      if ((undefined1 *)(lVar11 + 0x48) != &local_1368) {
        lVar18 = local_1358;
        if (local_1349 < 0x40) {
          lVar18 = 0x1f - (longlong)(char)local_1349;
        }
        puVar33 = &local_1368;
        if (0x3f < local_1349) {
          puVar33 = (undefined1 *)CONCAT71(uStack_1367,local_1368);
        }
        FUN_140054780((undefined1 *)(lVar11 + 0x48),puVar33,lVar18);
      }
      *(undefined4 *)(lVar11 + 0x70) = (undefined4)local_1340;
      *(undefined4 *)(lVar11 + 0x74) = local_1340._4_4_;
      if (&local_1338 != (longlong *)(lVar11 + 0x78)) {
        FUN_14011da10((longlong *)(lVar11 + 0x78),local_1338,local_1328 * 0x40 + local_1338);
      }
      FUN_140018150(&local_1338);
      if ((local_1349 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(CONCAT71(uStack_1367,local_1368),local_1348,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                           );
      }
      if ((local_12f9 & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(CONCAT71(uStack_1317,local_1318),local_12f8,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                           );
      }
      goto LAB_14011b9e9;
    }
    uVar13 = FUN_1400e0f60(local_12c0,
                           "Compilation failed: The maximum size for Constant Buffers is %d bytes. Constant Buffer \"%s\" (%d bytes) exceeded the maximum size."
                           ,0x10000,CONCAT71(uStack_1497,local_1498),local_1488 & 0xffffffff);
    FUN_140089820(param_6,uVar13,0,0,0x1c);
    if ((local_12a1 & 0xc0) == 0x40) {
LAB_14011bea5:
      thunk_FUN_1403f2404(local_12c0[0],local_12a0,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
LAB_14011beb8:
    if ((local_12f9 & 0xc0) == 0x40) {
      uVar13 = CONCAT71(uStack_1317,local_1318);
      uVar24 = local_12f8;
LAB_14011bed3:
      thunk_FUN_1403f2404(uVar13,uVar24,
                          "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                          ,0x218);
    }
LAB_14011bee6:
    if ((local_1381 & 0xc0) == 0x40) {
      uVar13 = CONCAT71(uStack_139f,local_13a0);
      uVar24 = local_1380;
      goto LAB_14011c8b1;
    }
    goto LAB_14011c8c6;
  }
LAB_14011b9f9:
  if ((int)local_res8 == 1) {
    local_1530 = local_1530 + 1;
  }
  uVar38 = local_1530;
  if ((local_1381 & 0xc0) == 0x40) {
    thunk_FUN_1403f2404(CONCAT71(uStack_139f,local_13a0),local_1380,
                        "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                       );
  }
  plVar20 = (longlong *)(local_1528 & 0xffffffff);
LAB_14011ba4f:
  uVar21 = (int)local_14a0 + 1;
  local_14a0 = CONCAT44(local_14a0._4_4_,uVar21);
  if (local_114c <= uVar21) goto LAB_14011ba65;
  goto LAB_14011a910;
LAB_14011b9e9:
  uVar38 = uVar38 + 1;
  if (local_1024 <= uVar38) goto LAB_14011b9f9;
  goto LAB_14011b257;
}
```
