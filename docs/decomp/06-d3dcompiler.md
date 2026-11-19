# D3DCompiler_47 wrapper

Ghidra decompilation of `UnityShaderCompiler.exe` (image base `0x140000000`).
Function names and leading comments are the annotations recorded in the Ghidra
database; the bodies are otherwise unedited decompiler output. See
[`shader_compiler_analysis.md`](../shader_compiler_analysis.md) for the prose
description of the same pipeline.

## `InitializeD3dCompilerLibrary` — `0x14008f070`

load `D3DCompiler_47.dll` and resolve its seven entry points

```c
/* Loads D3DCompiler_47.dll and resolves D3DCompile, D3DDisassemble, D3DAssemble, D3DPreprocess,
   D3DReflect, D3DStripShader, D3DGetBlobPart into both the object (+0x50..) and the wrapper vtable
   at 0x1405891b0. */

char * InitializeD3dCompilerLibrary(longlong param_1,longlong param_2,uint param_3)

{
  DWORD DVar1;
  longlong lVar2;
  char *pcVar3;
  undefined8 uVar4;
  HMODULE hModule;
  FARPROC pFVar5;
  LPCWSTR lpLibFileName;
  undefined4 local_res8 [2];
  char *local_res20;
  longlong local_68;
  longlong local_60;
  WCHAR local_58;
  undefined6 uStack_56;
  undefined4 local_3a;
  undefined8 local_28;
  
  *(undefined1 *)(param_1 + 0x88) = 0;
  local_28 = 0;
  *(undefined8 *)(param_1 + 0x10) = 0;
  *(undefined8 *)(param_1 + 0x18) = 0;
  *(undefined8 *)(param_1 + 0x20) = 0;
  *(undefined8 *)(param_1 + 0x28) = 0;
  *(undefined8 *)(param_1 + 0x30) = 0;
  *(undefined8 *)(param_1 + 0x38) = 0;
  *(undefined8 *)(param_1 + 0x40) = 0;
  lVar2 = FUN_140094c90(param_2,local_res8);
  if (lVar2 == 0) {
    pcVar3 = "Failed to read D3DCompiler DLL file";
  }
  else {
    pcVar3 = (char *)FUN_140006e60();
    if (pcVar3 == (char *)0x0) {
      local_res20 = pcVar3;
      FUN_1400ad1a0();
      uVar4 = FUN_1400ad320(lVar2,local_res8[0],&PTR_s_GetSystemTimeAsFileTime_140727340,
                            DAT_140728010,_guard_check_icall,&local_res20);
      *(undefined8 *)(param_1 + 8) = uVar4;
      FUN_1403de8b8(lVar2);
      if (*(longlong *)(param_1 + 8) != 0) {
        uVar4 = FUN_1400ad270(*(undefined8 *)(param_1 + 8),"D3DCompile");
        *(undefined8 *)(param_1 + 0x10) = uVar4;
        uVar4 = FUN_1400ad270(*(undefined8 *)(param_1 + 8),"D3DDisassemble");
        *(undefined8 *)(param_1 + 0x18) = uVar4;
        uVar4 = FUN_1400ad270(*(undefined8 *)(param_1 + 8),"D3DAssemble");
        *(undefined8 *)(param_1 + 0x20) = uVar4;
        uVar4 = FUN_1400ad270(*(undefined8 *)(param_1 + 8),"D3DPreprocess");
        *(undefined8 *)(param_1 + 0x28) = uVar4;
        uVar4 = FUN_1400ad270(*(undefined8 *)(param_1 + 8),"D3DReflect");
        *(undefined8 *)(param_1 + 0x30) = uVar4;
        uVar4 = FUN_1400ad270(*(undefined8 *)(param_1 + 8),"D3DStripShader");
        *(undefined8 *)(param_1 + 0x38) = uVar4;
        uVar4 = FUN_1400ad270(*(undefined8 *)(param_1 + 8),"D3DGetBlobPart");
        *(undefined8 *)(param_1 + 0x40) = uVar4;
      }
      local_3a = 0x4b000f;
      local_58 = L'\0';
      local_60 = -1;
      do {
        local_60 = local_60 + 1;
      } while (*(char *)(param_2 + local_60) != '\0');
      local_68 = param_2;
      FUN_1400881d0(&local_68,&local_58);
      lpLibFileName = &local_58;
      if (0x3f < local_3a._1_1_) {
        lpLibFileName = (LPCWSTR)CONCAT62(uStack_56,local_58);
      }
      hModule = LoadLibraryExW(lpLibFileName,(HANDLE)0x0,(param_3 & 0xff) << 8);
      *(HMODULE *)(param_1 + 0x48) = hModule;
      if (hModule == (HMODULE)0x0) {
        DVar1 = GetLastError();
        FUN_140096a20("Failed loading dll [%s], code [0x%x]\n",param_2,DVar1);
      }
      else {
        pFVar5 = GetProcAddress(hModule,"D3DCompile");
        *(FARPROC *)(param_1 + 0x50) = pFVar5;
        pFVar5 = GetProcAddress(hModule,"D3DDisassemble");
        *(FARPROC *)(param_1 + 0x58) = pFVar5;
        pFVar5 = GetProcAddress(hModule,"D3DAssemble");
        *(FARPROC *)(param_1 + 0x60) = pFVar5;
        pFVar5 = GetProcAddress(hModule,"D3DPreprocess");
        *(FARPROC *)(param_1 + 0x68) = pFVar5;
        pFVar5 = GetProcAddress(hModule,"D3DReflect");
        *(FARPROC *)(param_1 + 0x70) = pFVar5;
        pFVar5 = GetProcAddress(hModule,"D3DStripShader");
        *(FARPROC *)(param_1 + 0x78) = pFVar5;
        pFVar5 = GetProcAddress(hModule,"D3DGetBlobPart");
        *(FARPROC *)(param_1 + 0x80) = pFVar5;
      }
      pcVar3 = local_res20;
      if ((local_3a._1_1_ & 0xc0) == 0x40) {
        thunk_FUN_1403f2404(CONCAT62(uStack_56,local_58),local_3a._2_2_,
                            "C:\\build\\output\\unity\\unity\\Modules\\NativeKernel\\Include\\NativeKernel\\Core\\Containers\\StringStorageDefault.h"
                            ,0x218);
      }
    }
  }
  return pcVar3;
}
```

## `FUN_14008aec0` — `0x14008aec0`

`D3DCompile` stub

```c
undefined4
FUN_14008aec0(longlong param_1,undefined8 param_2,undefined4 param_3,undefined8 param_4,
             undefined8 param_5,undefined8 param_6,undefined8 param_7,undefined8 param_8,
             undefined4 param_9,undefined4 param_10,undefined8 param_11,undefined8 param_12)

{
  undefined4 uVar1;
  longlong lVar2;
  longlong *plVar3;
  undefined1 local_res8 [8];
  char *local_18;
  ulonglong local_10;
  
  lVar2 = 0x50;
  if (*(char *)(param_1 + 0x88) == '\0') {
    lVar2 = 0x10;
  }
  plVar3 = (longlong *)(lVar2 + param_1);
  if ((((*plVar3 == 0) || (plVar3[1] == 0)) || (plVar3[2] == 0)) ||
     (((plVar3[3] == 0 || (plVar3[4] == 0)) || (plVar3[5] == 0)))) {
    uVar1 = 0xffffffff;
  }
  else {
    FUN_140006e60();
    local_10 = 0;
    do {
      if ("D3DCompile"[local_10] == '\0') goto LAB_14008af57;
      local_10 = local_10 + 1;
    } while (local_10 < 0xb);
    local_10 = 0xb;
LAB_14008af57:
    local_18 = "D3DCompile";
    FUN_1400afbc0(local_res8,&local_18);
    uVar1 = (*(code *)*plVar3)(param_2,param_3,param_4,param_5,param_6,param_7,param_8,param_9,
                               param_10,param_11,param_12);
    _guard_check_icall(local_res8);
  }
  return uVar1;
}
```

## `FUN_14008ada0` — `0x14008ada0`

`D3DDisassemble` stub

```c
undefined4
FUN_14008ada0(longlong param_1,undefined8 param_2,undefined8 param_3,undefined4 param_4,
             undefined8 param_5,undefined8 param_6)

{
  undefined4 uVar1;
  longlong lVar2;
  longlong *plVar3;
  undefined1 local_res8 [8];
  char *local_18;
  ulonglong local_10;
  
  lVar2 = 0x50;
  if (*(char *)(param_1 + 0x88) == '\0') {
    lVar2 = 0x10;
  }
  plVar3 = (longlong *)(lVar2 + param_1);
  if ((((*plVar3 == 0) || (plVar3[1] == 0)) || (plVar3[2] == 0)) ||
     (((plVar3[3] == 0 || (plVar3[4] == 0)) || (plVar3[5] == 0)))) {
    uVar1 = 0xffffffff;
  }
  else {
    FUN_140006e60();
    local_10 = 0;
    do {
      if ("D3DAssemble"[local_10] == '\0') goto LAB_14008ae37;
      local_10 = local_10 + 1;
    } while (local_10 < 0xc);
    local_10 = 0xc;
LAB_14008ae37:
    local_18 = "D3DAssemble";
    FUN_1400afbc0(local_res8,&local_18);
    uVar1 = (*(code *)plVar3[2])(param_2,param_3,0,0,0,param_4,param_5,param_6);
    _guard_check_icall(local_res8);
  }
  return uVar1;
}
```

## `FUN_14008b010` — `0x14008b010`

`D3DAssemble` stub

```c
undefined4
FUN_14008b010(longlong param_1,undefined8 param_2,undefined8 param_3,undefined4 param_4,
             undefined8 param_5,undefined8 param_6)

{
  undefined4 uVar1;
  longlong lVar2;
  longlong *plVar3;
  undefined1 local_res8 [8];
  char *local_18;
  ulonglong local_10;
  
  lVar2 = 0x50;
  if (*(char *)(param_1 + 0x88) == '\0') {
    lVar2 = 0x10;
  }
  plVar3 = (longlong *)(lVar2 + param_1);
  if ((((*plVar3 == 0) || (plVar3[1] == 0)) || (plVar3[2] == 0)) ||
     (((plVar3[3] == 0 || (plVar3[4] == 0)) || (plVar3[5] == 0)))) {
    uVar1 = 0xffffffff;
  }
  else {
    FUN_140006e60();
    local_10 = 0;
    do {
      if ("D3DDisassemble"[local_10] == '\0') goto LAB_14008b09b;
      local_10 = local_10 + 1;
    } while (local_10 < 0xf);
    local_10 = 0xf;
LAB_14008b09b:
    local_18 = "D3DDisassemble";
    FUN_1400afbc0(local_res8,&local_18);
    uVar1 = (*(code *)plVar3[1])(param_2,param_3,param_4,param_5,param_6);
    _guard_check_icall(local_res8);
  }
  return uVar1;
}
```

## `FUN_14008b1f0` — `0x14008b1f0`

`D3DPreprocess` stub

```c
undefined4
FUN_14008b1f0(longlong param_1,undefined8 param_2,undefined4 param_3,undefined8 param_4,
             undefined8 param_5,undefined8 param_6,undefined8 param_7,undefined8 param_8)

{
  undefined4 uVar1;
  longlong lVar2;
  longlong *plVar3;
  undefined1 local_res8 [8];
  char *local_18;
  ulonglong local_10;
  
  lVar2 = 0x50;
  if (*(char *)(param_1 + 0x88) == '\0') {
    lVar2 = 0x10;
  }
  plVar3 = (longlong *)(lVar2 + param_1);
  if ((((*plVar3 == 0) || (plVar3[1] == 0)) || (plVar3[2] == 0)) ||
     (((plVar3[3] == 0 || (plVar3[4] == 0)) || (plVar3[5] == 0)))) {
    uVar1 = 0xffffffff;
  }
  else {
    FUN_140006e60();
    local_10 = 0;
    do {
      if ("D3DPreprocess"[local_10] == '\0') goto LAB_14008b287;
      local_10 = local_10 + 1;
    } while (local_10 < 0xe);
    local_10 = 0xe;
LAB_14008b287:
    local_18 = "D3DPreprocess";
    FUN_1400afbc0(local_res8,&local_18);
    uVar1 = (*(code *)plVar3[3])(param_2,param_3,param_4,param_5,param_6,param_7,param_8);
    _guard_check_icall(local_res8);
  }
  return uVar1;
}
```

## `FUN_14008b310` — `0x14008b310`

`D3DReflect` stub

```c
undefined4 FUN_14008b310(longlong param_1,undefined8 param_2,undefined8 param_3,undefined8 param_4)

{
  undefined4 uVar1;
  longlong lVar2;
  longlong *plVar3;
  undefined1 local_res8 [8];
  char *local_18;
  ulonglong local_10;
  
  lVar2 = 0x50;
  if (*(char *)(param_1 + 0x88) == '\0') {
    lVar2 = 0x10;
  }
  plVar3 = (longlong *)(lVar2 + param_1);
  if ((((*plVar3 == 0) || (plVar3[1] == 0)) || (plVar3[2] == 0)) ||
     (((plVar3[3] == 0 || (plVar3[4] == 0)) || (plVar3[5] == 0)))) {
    uVar1 = 0xffffffff;
  }
  else {
    FUN_140006e60();
    local_10 = 0;
    do {
      if ("D3DReflect"[local_10] == '\0') goto LAB_14008b397;
      local_10 = local_10 + 1;
    } while (local_10 < 0xb);
    local_10 = 0xb;
LAB_14008b397:
    local_18 = "D3DReflect";
    FUN_1400afbc0(local_res8,&local_18);
    uVar1 = (*(code *)plVar3[4])(param_2,param_3,&DAT_140726910,param_4);
    _guard_check_icall(local_res8);
  }
  return uVar1;
}
```

## `FUN_14008b400` — `0x14008b400`

`D3DStripShader` stub

```c
undefined4
FUN_14008b400(longlong param_1,undefined8 param_2,undefined8 param_3,undefined4 param_4,
             undefined8 param_5)

{
  undefined4 uVar1;
  longlong lVar2;
  longlong *plVar3;
  undefined1 local_res8 [8];
  char *local_18;
  ulonglong local_10;
  
  lVar2 = 0x50;
  if (*(char *)(param_1 + 0x88) == '\0') {
    lVar2 = 0x10;
  }
  plVar3 = (longlong *)(lVar2 + param_1);
  if ((((*plVar3 == 0) || (plVar3[1] == 0)) || (plVar3[2] == 0)) ||
     (((plVar3[3] == 0 || (plVar3[4] == 0)) || (plVar3[5] == 0)))) {
    uVar1 = 0xffffffff;
  }
  else {
    FUN_140006e60();
    local_10 = 0;
    do {
      if ("D3DStripShader"[local_10] == '\0') goto LAB_14008b487;
      local_10 = local_10 + 1;
    } while (local_10 < 0xf);
    local_10 = 0xf;
LAB_14008b487:
    local_18 = "D3DStripShader";
    FUN_1400afbc0(local_res8,&local_18);
    uVar1 = (*(code *)plVar3[5])(param_2,param_3,param_4,param_5);
    _guard_check_icall(local_res8);
  }
  return uVar1;
}
```

## `FUN_14008b100` — `0x14008b100`

`D3DGetBlobPart` stub

```c
undefined4
FUN_14008b100(longlong param_1,undefined8 param_2,undefined8 param_3,undefined4 param_4,
             undefined4 param_5,undefined8 param_6)

{
  undefined4 uVar1;
  longlong lVar2;
  longlong *plVar3;
  undefined1 local_res8 [8];
  char *local_18;
  ulonglong local_10;
  
  lVar2 = 0x50;
  if (*(char *)(param_1 + 0x88) == '\0') {
    lVar2 = 0x10;
  }
  plVar3 = (longlong *)(lVar2 + param_1);
  if ((((*plVar3 == 0) || (plVar3[1] == 0)) || (plVar3[2] == 0)) ||
     (((plVar3[3] == 0 || (plVar3[4] == 0)) || (plVar3[5] == 0)))) {
    uVar1 = 0xffffffff;
  }
  else {
    FUN_140006e60();
    local_10 = 0;
    do {
      if ("D3DGetBlobPart"[local_10] == '\0') goto LAB_14008b18b;
      local_10 = local_10 + 1;
    } while (local_10 < 0xf);
    local_10 = 0xf;
LAB_14008b18b:
    local_18 = "D3DGetBlobPart";
    FUN_1400afbc0(local_res8,&local_18);
    uVar1 = (*(code *)plVar3[6])(param_2,param_3,param_4,param_5,param_6);
    _guard_check_icall(local_res8);
  }
  return uVar1;
}
```
