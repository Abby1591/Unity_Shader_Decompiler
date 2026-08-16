# UnityShaderCompiler.exe — RDEF Information Extraction & Recoverability Analysis

Target: `UnityShaderCompiler.exe` (image base `0x140000000`, program `/UnityShaderCompiler.exe`)
Ghidra project: `C:\Users\Abby\Software\Ghidra Projects\UnityShaderCompiler\Unityshadercompiler`
Date: 2026-08-13

## 0. Executive summary

Unity compiles HLSL via `D3DCompile`, extracts shader metadata via `D3DReflect`
BEFORE stripping, then runs `D3DStripShader(flags=7)` to remove the RDEF/debug
chunks from the DXBC that is sent to the editor and shipped in players.

The strip is PROVEN on both code paths:

- **D3D11 non-compute** (`FUN_140022fb0`): D3DStripShader via wrapper vtable
  slot 0x40 with flags `(local_res10^1)+6` (== 6 or 7). The final payload is
  `[0x02][4 binding-count bytes][flag byte][0x20 zeros][STRIPPED DXBC]` placed at
  `ShaderCompileOutputData+0x40`.
- **Compute** (`FUN_1400b77f0`): reflection first, then
  `(**(code**)(*param_1 + 0x40))(param_1, blob, size, 7, &out)` — D3DStripShader
  flags=7 — then the STRIPPED blob is copied into the output. Serialized via
  `FUN_1400b5e10` into `+0x40`.

Both paths therefore ship DXBC with the RDEF chunk removed. Any metadata Unity
wants to keep must be (a) re-derived from the stripped DXBC (signatures live in
the ISGN/OSGN chunks and survive stripping), (b) encoded into the small
non-compute header (4 per-class binding counts + 1 flag byte), or (c) serialized
verbatim into the compute reflection blob.

## 1. Wire protocol (PROVEN)

Every packet over the named-pipe IPC is:

```
[4-byte magic 0x0C0BD1E4 (LE bytes e4 d1 0b 0c)]  @ DAT_1402f46c4
[u64 LE size]
[payload of `size` bytes]
```

- Sender chain: `FUN_1400b5b10` (blob `{ptr,size}`) / `FUN_1400b4fb0` (raw
  blob) / `FUN_1400b5dc0` (SSO string) -> `FUN_1400b4fe0` ->
  `FUN_1400b5160` (writes magic; "Protocol error - failed to send magic
  number") + `FUN_1400b4d70` -> `FUN_1400e36f0` (WriteFile).
- `FUN_1400b5f50` = send UInt32: magic + 4-byte LE value ("Failed to write
  UInt32").
- Receiver: `FUN_1400b42f0` (read + verify 4-byte magic == 0x0C0BD1E4;
  "Protocol error - failed to read/magic number match") + `FUN_1400b3f50`
  (receive packet: read 8-byte size then payload; "Failed to receive packet
  size"/"Failed to receive packet") via `FUN_1400b3cf0` (pipe read; IPC ctx
  param_1+0x08 read handle, +0x10 write handle, +0x18 timeout ms; "IPC not
  initialized").

### String encoding (`FUN_1400b5cf0`)
`[i32 LE length][length raw bytes]`; SSO flag byte @+0x1c == 1 means the
string is stored inline: length = `0x18 - byte@+0x18`, data at object base.
Else length = `u32@+0x10`, data ptr @+0x00.

### Master serializer (`FUN_1400b5e10`) output layout
```
u64 0xFFFFFFFFFFFFFFFF          (sentinel)
u64 1                           (version)
FUN_1400b5220 block             (CB/resource list; see below)
FUN_1400b53d0 block             (param list)
FUN_1400b5760 block             (ShaderInfoStruct array; embeds DXBC)
u8  param_1[0xd]                (trailing flag bytes)
```
Callers: `FUN_140006710` (compute), `FUN_1400f2e30` (DXIL), `FUN_140026c40`,
`FUN_140027890`.

#### CB/resource list block (`FUN_1400b5220`)
```
u64 count
per entry (9 qwords = 0x48 bytes):
    string        (name)
    u64 innerCount
    per inner (10 qwords = 0x50 bytes):
        string
        string
trailing qword (param_1 + 0x60)
```

#### Param list block (`FUN_1400b53d0`)
```
u64 count            (param_1[2])
per entry (4 qwords):
    u64 count
    per inner (10 qwords):
        string
        u32
        u64
        per sub (8 qwords):
            string
            u32 x5
```

#### ShaderInfoStruct array block (`FUN_1400b5760`) — 0xf8-byte entries
```
u64 count                     (param_1 + 0x30)
per entry (0xf8 bytes / 0x1f qwords):
    string name               @ +0x00
    list @ +0x28              (u64 count + per 0x60-byte entry {string,string,u32,u32,u32})
    list @ +0x48
    uint-pair list @ +0x68    (count @ +0x78)
    list @ +0x88
    list @ +0xa8
    DXBC data                 @ +0xc8
    u64 DXBC size             @ +0xd8
    u32 thread group size     @ +0xe8
    u32                       @ +0xec
    u32                       @ +0xf0
```
The 0x60-byte list entries are emitted by `FUN_1400b5b40`; 0x58-byte entries
by `FUN_14007b2e0`/`FUN_1400882e0` (used on the non-compute serialization
path).

## 2. ShaderCompileOutputData (`FUN_14000f170` ctor; 0xa0-byte object)

```
+0x00  ShaderCompileOutputData::vftable
+0x08  shader type
+0x10  platform
+0x40  output blob        (header+STRIPPED DXBC for non-compute; serialized
                           shader-info with embedded DXBC for compute)
+0x90  serialized shader-info / error string slot
```

## 3. D3D11 non-compute path (PROVEN)

Dispatch: `FUN_140006600` (fp-table entry 6 @ `1402e64e0`) selects DXIL
(`FUN_1400f9320`) when type==4 + flags, else `FUN_140022fb0` (its ONLY
function-level caller).

`FUN_140022fb0` flow:
1. Create `ShaderCompileOutputData`.
2. "D3D shader compiler could not be loaded" check.
3. `D3DCompile` (wrapper vtable slot 0x18, `FUN_14007c730`).
4. On success: `FUN_140019550(blob, size, name, type, param_1[1],
   param_1[2], +0x90, &local_198, &local_220)` — reflection (section 5).
5. Optional `D3DStripShader` (vtable slot 0x40, flags `(local_res10^1)+6`).
6. Build output at `+0x40`:
   ```
   u8   0x02
   u8   texture count   = max(bindpoint+1) over type-class {2,5,7}
   u8   cb count        = max(bindpoint+1) over type-class {0}
   u8   sampler count   = max(bindpoint+1) over type-class {3}
   u8   uav count       = max(bindpoint+1) over type-class {4,6,8,9,10,0xb}
   u8   flag            = from param_1[7] bit 26 (local_220)
   u8[0x20] zeros
   <STRIPPED DXBC>
   ```
   Total header = 0x26 bytes (0x02 + 4 counts + 1 flag + 0x20 zeros).

## 4. Compute path (PROVEN)

Dispatch: `FUN_140006710` (fp-table entry 8).
1. Create `ShaderCompileOutputData`.
2. `FUN_1400b77f0(plVar3, param_2, &local_78, &local_58, +0x90)` — compile +
   reflect.
3. `FUN_1400b5e10(&local_78, +0x40)` — serialize into the output blob slot.

`FUN_1400b77f0`:
- Reads CB/resource counts through the reflection vtable
  (`*param_2` slots +0x50/+0x30/+0x28/+0x08/+0x00/+0x68/+0x58/+0x78/+0x90/
  +0x80).
- Calls `FUN_1400be960` (compute reflection, section 5).
- Strips: `(**(code**)(*param_1 + 0x40))(param_1, blob, size, 7, &out)`.
- Copies STRIPPED blob into output at `+0xc8`/`+0xd8` (size).
- D3DStripShader is skipped when `(param_2[7] & 0x1004) != 0`.

## 5. Reflection extraction (pre-strip)

Reflection interface is `ID3D11ShaderReflection` — IID PROVEN:
`DAT_1403aa6c8` = `{8D536CA1-0CCA-4956-A837-786963755584}` (IID_ID3D11ShaderReflection),
`DAT_1402fb898` = older-SDK `{8BA5FB08-5195-40E2-AC58-0D989C3A0102}` (DXIL
path only). vtable slots: 0x18 GetDesc, 0x20 GetConstantBufferByIndex, 0x28
GetConstantBufferByName, 0x30 GetResourceBindingDesc, 0x38
GetInputParameterDesc (D3D11_SIGNATURE_PARAMETER_DESC), 0x40
GetOutputParameterDesc, 0x48 GetPatchConstantParameterDesc, 0x50
GetVariableByName, 0x58 GetResourceBindingDescByName, 0xA0 GetThreadGroupSize.
D3DReflect entry: `FUN_14007cb80` (delayed load); wrapper global `1403acff0`,
vtable `1402f5c60`, D3DCompiler global `DAT_1403b82c0`.

### 5a. Non-compute (`FUN_140019550`)
- Vertex semantics (param_4 == 0): POSITION->0, NORMAL->1, TANGENT->2,
  COLOR->3, TEXCOORDn->4+n (n<8), BLENDWEIGHTS->0xc, BLENDINDICES->0xd,
  SV_POSITION->warn. Written via param_5+8(channel,value).
- Constant buffers: name, type 0/3 allowed, size < 0x10000, variable loop
  filtering `(uFlags & 2) == D3D_SVF_USED`; type class 5 (STRUCT) + name
  "UnityInstancing" -> instancing path via param_5+0x18 + `FUN_140037600`.
- Resources: loop mask 0xa4, types {2,5,7} into 0x40-byte entries (local_218);
  **param_8 = verbatim full 0x28-byte `D3D11_SHADER_INPUT_BIND_DESC` for ALL
  BoundResources** — the highest-fidelity capture in the binary.
- Samplers: Type==3.
- Dispatch cases 0/2-0xb route to param_5+0x20 (name,bindpoint,bindcount) /
  +0x28 (map {4,6}->2, {5,7}->5, 8->3, 9->4, 10->6) / +0x30 sampler /
  +0x38 texture binding; +0x48 stats.
- param_9 = GetDesc.cNumTotalThreads (desc+0x78) when param_4==4.
- Param_5 builder vtable methods: +8 semantic, +0x10 CB name, +0x18
  instancing, +0x20 CB binding, +0x28 UAV binding, +0x30 sampler, +0x38
  texture binding, +0x48 stats.

### 5b. Compute (`FUN_1400be960`)
- `GetThreadGroupSize` -> 3 uints at ShaderInfoStruct+0xe8.
- CB count = desc+0x14, resource count = desc+0x18.
- Variable loop filters D3D_SVF_USED; D3D_SVT->Unity type map
  1->2, 2->1, 3->0, 0x13->5, 0x36->0.
- 0x40-byte variable entries -> local_208; CB records appended to param_6 as
  0x50-byte entries via `FUN_14000e640`; `FUN_1400b7620` links vars to CBs.
- Resource cases: 0->param_5+0x28, 2->+0x88/+0x48, {4,6,8,9,10,0xb}->+0xa8
  (0x60-byte entries), {5,7}->+0x88.
- Samplers: Type==3 -> bindpoint@+0x54 or +0x68 via `FUN_1400af960`/
  `FUN_140042370`.

## 6. Dispatcher message inventory (`FUN_1400b8a50`; PROVEN)

19 `FUN_1400b5b10` (string/blob) sends + 4 `FUN_1400b4fb0` (raw blob) sends.

Raw-blob sends (what carries compiled shader bytes to the editor):
1. **compileSnippet** (stmt #601-#602): `"shader: %c"` label
   (`1402f6cf8`) -> UInt32 (`FUN_1400b5f50`, local_6a0) -> raw blob
   `FUN_1400b4fb0(param_1, local_788, uStack_780-local_788)` = the
   `+0x40` output blob.
2. **compute** (stmt #1102): `"computeData: "` label (`1402f6e24`-area,
   stmt #1096) -> raw blob (serialized shader-info).
3. **ray tracing** (stmt #1204): `"rayTracingData: "` label -> raw blob.
4. **echo** (stmt #1283): receive packet then send it back (handshake).

Label strings (PROVEN at addresses): `1402f6bf4` " ok=", `1402f6c00`
"shader: %c %c %c", `1402f6c18` " outsizE=", `1402f6c68` "disasm: %c",
`1402f6cf8` "shader: %c", `1402f6d38` "computeKeywordsUserGlobal: %i",
`1402f6d58` "computeKeywordsUserLocal: %i", `1402f6d78`
"computeKeywordsDynamic:", `1402f6d90` "kernel: %s %i", `1402f6da0`
"requirements:", `1402f6db0` "endKernels: %llu %i %i %i %i %i",
`1402f6ea8` "params: %i %i %i %i %i %i %i"; plus "Cmd: disassembleShader",
"Cmd: compileSnippet", "Cmd: initializeCompiler", "Cmd:
preprocessCompute...", "Cmd: compileComputeKernel", "name=", "platform=",
"insizE=", "pass=", " ok=true", "Unknown command", "Cannot dispatch invalid
command", "Couldn't create IPC stream\n".

Commands: compileSnippet -> `FUN_1400a14a0` (dispatch table `local_38[4]` =
{FUN_1400a51e0, FUN_1400a41e0, FUN_1400a5ed0, FUN_1400a51e0} indexed by
param_17); compute kernels -> `FUN_1400a0a90` (routes via
`DAT_1403ace50[platform*8]` and `FUN_14009db30` which injects
"SHADER_AVAILABLE_"/"SHADER_TARGET_AVAILABLE" defines); disassemble ->
`FUN_1400a8c10`.

## 7. Information-map table

Legend: **P** = PROVEN, **SI** = STRONGLY INFERRED, **PO** = POSSIBLE,
**U** = UNKNOWN.
Columns: Info / Source API / Unity fn / Struct / Offset / Serialized? / Sent? /
Player data? / Recoverable from shipped? / Confidence.

| Info | Source API | Unity fn | Struct | Offset | Serialized | Sent | Player | Recoverable | Conf |
|---|---|---|---|---|---|---|---|---|---|
| Input semantics (name+index) | GetInputParameterDesc (0x38) | 140019550 | param_5 semantic list | +8 | yes (0x60-entry lists) | yes (non-compute header only via counts; full in compute blob) | ISGN survives strip | YES (ISGN chunk) | P |
| Vertex channel mapping | Unity semantic->channel table `1402f4650` ("Normal","Color","TexCoord"...), POSITION/NORMAL/TANGENT/COLOR/TEXCOORDn/BLENDWEIGHTS/BLENDINDICES | 140019550 | builder +8 | n/a | n/a | no | no | REDERIVABLE (semantics->channels is deterministic) | P |
| CB names | GetConstantBufferByIndex + CB vtable[0] GetName | 140019550/1400be960 | ShaderInfoStruct lists | +0x28.. | yes | compute: yes; non-compute: via serialized +0x90? | RDEF stripped | NO from DXBC (RDEF gone); YES from compute blob | P |
| CB type (cbuffer/tbuffer) | D3D11_SHADER_BUFFER_DESC.Type | 140019550 | (filter only: 0/3 allowed) | n/a | no | no | no | NO | P |
| CB size | D3D11_SHADER_BUFFER_DESC.Size | 140019550 | (filter: <0x10000) | n/a | no | no | no | NO | P |
| CB variable names | GetVariableByName / variable desc | 1400be960/140019550 | 0x50-byte CB records; 0x40-byte var entries | +0x28 | yes | compute: yes | RDEF stripped | NO from DXBC; YES from compute blob | P |
| Variable start offset/size/uFlags | D3D11_SHADER_VARIABLE_DESC | 1400be960 | 0x40-byte entries | n/a | yes | compute: yes | RDEF stripped | NO from DXBC; YES from compute blob | P |
| Variable type (class/type/rows/cols/elements) | D3D11_SHADER_TYPE_DESC | 1400be960 | type map 1->2,2->1,3->0,0x13->5,0x36->0 | n/a | yes (mapped enum) | compute: yes | RDEF stripped | NO from DXBC; mapped enum in compute blob | P |
| UnityInstancing CB | CB name + class STRUCT + "UnityInstancing" | 140019550 | builder +0x18 | +0x18 | yes (implied) | compute: yes | RDEF stripped | RE-DERIVABLE (heuristic on CB name/struct) | P |
| Resource bind desc (FULL 0x28 bytes, all) | GetResourceBindingDesc (0x30) | 140019550 | param_8 list | verbatim | yes | compute: yes; non-compute: only counts | RDEF stripped | NO from DXBC; YES from compute blob | P |
| Per-class bind counts | max bindpoint+1 {2,5,7}/{0}/{3}/{4,6,8,9,10,0xb} | 140022fb0 | output header | +1..+4 | yes | YES (all paths) | YES (header survives) | YES — the 4 count bytes ARE the recoverable summary | P |
| Flag byte | param_1[7] bit 26 | 140022fb0 | output header | +5 | yes | YES | YES | YES | P |
| Thread group size | GetThreadGroupSize (0xA0) | 1400be960 | ShaderInfoStruct | +0xe8 | yes | compute: yes | RDEF stripped | REDERIVABLE from stripped DXBC (SHDR contains thread-group metadata for cs_5_0) | P |
| GS output counts/primitive | GetDesc | 140019550 (+0x48 stats) | builder +0x48 | +0x48 | yes | compute: yes | RDEF stripped | NO (GS stat not in ISGN) | SI |
| cNumTotalThreads | GetDesc.cNumTotalThreads (desc+0x78) | 140019550 (type==4) | *param_9 | n/a | no | no | RDEF stripped | NO | P |
| Instancing flag / `#pragma instancing_options` | param_5+0x18 path | 140019550 | builder +0x18 | +0x18 | yes | compute: yes | RDEF stripped | NO from DXBC (Unity-side compile flag) | P |

## 8. RDEF field-by-field comparison (shipped vs. extracted)

What the shipped player shader contains (all PROVEN):
- Non-compute D3D11: `[0x02][4 counts][flag][0x20 zeros]` + **stripped DXBC**.
- Compute: `FUN_1400b5e10` serialized blob = sentinel + version + CB/resource
  list + param list + ShaderInfoStruct array (embedded **stripped** DXBC) + flags.

DXBC chunks that survive `D3DStripShader(flags=7)` (0x1 RDEF, 0x2 DEBUG, 0x4
TEST_BLOBS):
- ISGN / OSGN / PCON (input/output/patch-constant signatures) — these carry
  semantic names, indices, registers, masks, streams.
- SHDR/SHEX (shader bytecode).
- STAT / SFI0 (statistics / shader info: instruction counts, thread-group
  sizes for compute).
- PRIV, RTSI as applicable.

DXBC chunks REMOVED (RDEF, the reflection data):
- Constant buffer definitions (names, sizes, variables, types, offsets).
- Resource binding names/types/bindpoints/spaces/flags.
- All `D3D11_SHADER_DESC` fields derived solely from RDEF.

Mapping of every `D3D11_SHADER_DESC` field to shipped fate:
| D3D11_SHADER_DESC field | offset | Unity reads? | Survives ship? |
|---|---|---|---|
| Version | 0x00 | (implicitly via blob) | YES (DXBC header) |
| Creator | 0x08 | no | YES (DXBC creator string) |
| Flags | 0x10 | no | NO (RDEF) |
| ConstantBuffers (count) | 0x14 | yes (loops) | NO (count re-derived at runtime) |
| BoundResources (count) | 0x18 | yes | NO |
| InputParameters (count) | 0x1c | yes | YES (ISGN count) |
| OutputParameters | 0x20 | no | YES (OSGN) |
| PatchConstantParameters | 0x24 | no | YES (PCON) |
| GSOutputs | 0x28 | yes (stats) | NO |
| GSOutputPrimitive | 0x2c | yes (stats) | NO |
| GSInputPrimitive | 0x30 | no | NO |
| PatchConstantPrimitive | 0x34 | no | NO |
| cGSOutputs | 0x38 | no | NO |
| cTemps | 0x3c | no | YES (STAT) |
| cIndexRange | 0x40 | no | NO |
| cGSMaxOutputVertexCount | 0x44 | yes (stats) | NO |
| NumInterfaceSlots | 0x48 | no | NO |
| cMaxMSPatches | 0x4c | no | NO |
| cMinSpawnCount | 0x50 | no | NO |
| cNumThreads[3] | 0x54 | yes (compute, via GetThreadGroupSize) | SI: YES (SFI0/SHDR) |
| cXUVInfo[4] | 0x60 | no | NO |
| cTGSM | 0x70 | no | NO |
| cNumBarriers | 0x74 | no | NO |
| cNumTotalThreads | 0x78 | yes (type==4) | SI: YES (derivable) |
| cFeatureInfo | 0x7c | no | NO |

## 9. Info NOT in RDEF (catalog)

These are Unity-side derived facts that never existed in the DXBC:
1. Vertex channel mapping (semantic name -> Unity channel enum).
2. Instancing detection (CB named "UnityInstancing" + STRUCT class).
3. Per-class max-bindpoint+1 counts and the flag byte in the non-compute
   header (a lossy summary of RDEF resource bindings).
4. "computeKeywords*" / "kernel"/"requirements"/"params" label metadata sent
   ahead of compute/raytracing blobs.
5. Thread-group size (compute) — from GetThreadGroupSize, not RDEF.
6. The 0x0C0BD1E4 framing + command/label protocol itself.

## 10. Recoverability assessment

- **DXBC bytecode + signatures**: fully recoverable from the shipped blob
  (DXBC survives stripping; ISGN/OSGN/PCON remain). Signatures give semantic
  names, indices, register allocation, masks — the same data GetInputParameterDesc
  returns, so the input-signature half of RDEF-reflection is recoverable.
- **Constant buffers, resource bindings, variable layout, spaces**: NOT in the
  shipped DXBC (RDEF stripped). The only surviving trace for D3D11 non-compute
  is the 4 per-class counts + flag byte. Full fidelity survives ONLY in the
  compute serialized blob (FUN_1400b5e10 output) IF the editor persists that
  blob into the player.
- **Compute reflection blob**: if a shipped compute shader contains the
  serialized shader-info (sentinel+version+lists+embedded DXBC), a standalone
  parser can reconstruct nearly the full original RDEF (CB names/sizes/
  variables/types/offsets, resource bind descs, thread-group size).
- **Non-compute**: reconstructable info = the 0x26-byte header (4 counts +
  flag) + stripped DXBC + signatures. Original RDEF CB/binding metadata is
  NOT reconstructable without external knowledge (heuristics on
  UnityInstancing naming, standard cbuffer naming conventions).

## 11. Key addresses

`FUN_140019550` (non-compute reflect), `FUN_1400be960` (compute reflect),
`FUN_140022fb0` (D3D11 non-compute), `FUN_140006600` (non-compute fp entry),
`FUN_140006710` (compute fp entry), `FUN_1400b77f0` (compute compile+reflect
+strip), `FUN_1400a14a0`/`FUN_1400a0a90` (command dispatchers), `FUN_14000f170`
(ShaderCompileOutputData ctor), `FUN_14007cb80` (D3DReflect), serializers
`1400b5cf0`/`1400b5b40`/`1400b5220`/`1400b53d0`/`1400b5760`/`1400b5e10`/
`1400b5b10`/`1400882e0`/`14007b2e0`, wire `1400b8a50`/`1400b4fb0`/`1400b4fe0`/
`1400b5160`/`1400b5dc0`/`1400b5f50`/`1400b42f0`/`1400b3f50`/`1400b3cf0`/
`1400b4d70`/`1400e35b0`/`1400e36f0`, IIDs `DAT_1403aa6c8`+`DAT_1402fb898`,
magic `DAT_1402f46c4`, wrapper `1403acff0`/vtable `1402f5c60`/`DAT_1403b82c0`,
fp table `1402e64e0` (registered into `DAT_1403b82d0+`; accessor family
`FUN_14009bcf0`..`FUN_14009bfd0`; interface getters `FUN_14001fe60`/
`FUN_14001fe80`/`FUN_14001fe30`; registration `FUN_1400ac980`), semantic table
`1402f4650`, error string `1402e74b0`, `FUN_140037600`, `FUN_1400b7620`,
`FUN_14000e640`, `FUN_1400af960`, `FUN_140042370`, dispatcher labels
`1402f6bf4`/`1402f6c00`/`1402f6c18`/`1402f6c68`/`1402f6cf8`/`1402f6d38`/
`1402f6d58`/`1402f6d78`/`1402f6d90`/`1402f6da0`/`1402f6db0`/`1402f6ea8`/
`1402f6ef0`, computeData label `1402f6e24`, rayTracing label (near
`1402f6e24`), `DAT_1403ace50` (per-platform capability bitmask table),
`FUN_14009db30`/`FUN_14009e280` (SHADER_AVAILABLE_/SHADER_TARGET_AVAILABLE
define injection).