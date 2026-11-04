# Standalone Parser / Decompiler Spec — Unity D3D11 Shader Blob (FINAL)

Implementation-grade specification for a standalone parser/decompiler that
reconstructs reflection metadata from shader blobs produced by
`UnityShaderCompiler.exe` (Unity 2022.3 LTS, D3D11). It consumes the `+0x40`
payload of the `compileSnippet` / `computeData` IPC responses, and optionally
raw wire frames.

All facts are labeled with one of exactly four confidence states:

| Label | Definition |
|---|---|
| **PROVEN** | Directly demonstrated by Ghidra disassembly/data flow, exact constants, or an actual captured byte stream. |
| **STRONGLY INFERRED** | Supported by multiple independent observations and public format definitions, but still missing a direct capture or equivalent proof. |
| **POSSIBLE** | Plausible interpretation that must NOT be relied upon by the parser as fact. |
| **UNKNOWN** | Cannot be established from the available evidence. |

A claim is never promoted to PROVEN merely because it is likely. Every
uncertain claim states the evidence that would prove it.

---

## 1. Scope and artifacts

Four distinct data states must never be conflated:

- **A. UnityShaderCompiler internal state** (in-memory ShaderInfoStruct /
  ShaderInfoContainer, `FUN_1400b5760` / `FUN_1400b5e10`).
- **B. Compiler → Editor IPC** (`+0x40` blob, `+0x90` serialized metadata,
  wire frames under magic `0x0C0BD1E4`).
- **C. Editor / imported ShaderData** (not visible from this binary).
- **D. Final player / build asset** (not visible from this binary).

Only **A** and **B** are directly visible from the current binary analysis.
No claim about **C** or **D** is made anywhere in this document; each is
flagged UNKNOWN unless separately proven.

Artifacts the parser consumes:

1. **Non-compute D3D11 blob** — `+0x40` payload of a `compileSnippet`
   response: `[0x26-byte header][stripped DXBC]`.
2. **Compute serialized blob** — `+0x40` payload of a `computeData`
   response: the `FUN_1400b5e10` serialization (section 6) with embedded
   stripped DXBC.
3. **Wire frame** (optional) — `[u32 magic=0x0C0BD1E4][u64 size][payload]`
   (PROVEN framing, `FUN_1400b8a50`). Strip framing, classify the payload by
   command label ("shader: ", "computeData: ", "rayTracingData: "), then parse
   as 1 or 2.

Out of scope: DXIL / ray-tracing paths (`FUN_1400f2e30`), editor-side
(`C`) and player-side (`D`) serialization.

---

## 2. In-memory structures vs. serialized output (mandatory distinction)

The compiler's **ShaderInfoStruct** is an IN-MEMORY structure. Its proven
fields include `+0xc8` = DXBC pointer, `+0xd8` = DXBC size, `+0xe8/+0xec/+0xf0`
= tgX/tgY/tgZ, plus four List64 vectors at `+0x28/+0x48/+0x88/+0xa8`, a uint
pair vector at `+0x68` (count `+0x78`), and a name string at `+0x00`.

`FUN_1400b5760` serializes that structure into a **variable-length stream**.
The in-memory offsets and the serialized positions are NOT the same thing.

**The serialized parser MUST NOT read `dxbcSize` at `serialized_offset + 0xd8`
nor `tgX` at `serialized_offset + 0xe8`.** It must parse sequentially, in the
order the serializer emits (section 6.4):

```
string name
listA
listB
listC
listD
u64 uintPairCount
u32 pairs × uintPairCount
u64 dxbcSize
u8[dxbcSize] dxbc
u32 tgX
u32 tgY
u32 tgZ
```

In particular the **uint pair list serializes AFTER all four List64s**, even
though its in-memory storage (`+0x68`) sits before two of them (`+0x88`,
`+0xa8`). This is the single most common place a parser will go wrong.

---

## 3. Non-compute header semantics

The `+0x40` non-compute blob is:

```
u8 0x02
u8 texExt          max(bindpoint+1) over type-class {2,5,7}
u8 cbExt           max(bindpoint+1) over type-class {0}
u8 sampExt         max(bindpoint+1) over type-class {3}
u8 uavExt          max(bindpoint+1) over type-class {4,6,8,9,10,0xb}
u8 flag
u8[0x20] reserved/zero
<DXBC container>
```

Header is 0x26 bytes. Class sets and `max(bindpoint+1)` are PROVEN
(`FUN_140022fb0` reads each 0x28-byte record's `Type@+0x08` and the
single-byte `BindPoint@+0x0c`, accumulating per class).

### Extents, not counts

The four resource bytes are **extents**: each is **one greater than the
highest bindpoint observed by Unity for that resource class**. They are NOT
literal resource counts. The parser must NEVER synthesize resources or
bindpoints `b0..bN-1` from an extent.

Examples:
- only `b3` exists → `cbExt = 4`
- `b0` and `b3` exist → `cbExt = 4`
- only `b7` exists → `cbExt = 8`
- no CBs observed → `cbExt = 0`

A bindpoint of 0 with no other bindings still yields `1`, so an extent of 1
does not imply a bound resource. Only `0` means the class is empty.

### The flag byte

`FUN_140019550` writes `*param_9 = local_80` when the platform argument == 4
(D3D11), else 0. `local_80` is the value of the reflection `GetDesc` output at
offset `+0x78`. Per the public `D3D11_SHADER_DESC` layout that offset is
`cNumTotalThreads` (STRONGLY INFERRED); because non-compute shaders have
`cNumTotalThreads == 0`, the emitted flag is `0` for every non-compute D3D11
shader. The purpose Unity attaches to this byte is **UNKNOWN**. What would
prove it: a non-compute capture with a nonzero flag byte, or a
multi-platform capture (flag = 0 for platform != 4 is PROVEN by the `else 0`).

---

## 4. Resource binding record (0x28 bytes)

Unity reflects one `D3D11_SHADER_INPUT_BIND_DESC`-shaped record per bound
resource via `GetResourceBindingDesc` (reflection slot 0x30) and copies it
**verbatim** into a 0x28-byte buffer (`param_8` in `FUN_140019550`). The raw
layout, PROVEN by the field-by-field copy in `FUN_140019550`:

```
0x00  8 bytes  Name        (LPCSTR, serialized separately as a string)
0x08  u32      Type        (D3D_SHADER_INPUT_TYPE)
0x0c  u32      BindPoint
0x10  u32      BindCount
0x14  u32      uFlags
0x18  u32      ReturnType
0x1c  u32      Dimension
0x20  u32      NumSamples
0x24  u32      (unknown)
```

Offsets and semantics of Name through NumSamples match the public
`D3D11_SHADER_INPUT_BIND_DESC` layout and the PROVEN reads in
`FUN_140019550` / `FUN_140022fb0` (`Type@+0x08`, `BindPoint@+0x0c`,
`BindCount@+0x10`, `uFlags@+0x14`, `ReturnType@+0x18`, `Dimension@+0x1c`,
`NumSamples@+0x20`). The field at `0x24` is **UNKNOWN**: it is not part of the
classic 0x24-byte `D3D11_SHADER_INPUT_BIND_DESC`, and Unity always copies a
full 0x28 bytes. It is POSSIBLE this is the `Space` field from the
`D3D12_SHADER_INPUT_BIND_DESC` layout, but that is not proven — do not label
it. Evidence that would prove it: a live capture compared against
`D3DReflect` output for a shader with non-zero `Space`/`uID`, or proof of
which SDK header Unity builds against.

### Unity's interpretation vs. serialized representation

- **Raw reflected record** (`param_8`): the full 0x28-byte
  `D3D11_SHADER_INPUT_BIND_DESC` copy above.
- **Unity's interpretation** (`FUN_140022fb0`): per-class `max(bindpoint+1)`
  over `Type@+0x08`, with `BindPoint@+0x0c` read as a single byte.
- **Serialized representation**: only the four header extents. **The records
  are consumed to generate the extents and are then freed — they are never
  serialized into the normal `+0x40` shipped non-compute blob** (PROVEN: in
  `FUN_140022fb0` the `local_198` record array is freed after the extent loop;
  the blob contains only the header + stripped DXBC).

On the compute path the same reflection data is *transformed* into the
List64/uint-pair lists (section 7); a full `D3D11_SHADER_INPUT_BIND_DESC` is
not preserved there either.

---

## 5. DXBC chunk handling

The parser MUST NOT hardcode a list of surviving chunks. Required algorithm:

1. Validate DXBC header (`"DXBC"`, version `0xFEFF2001`).
2. Read container size and chunk count.
3. Read all chunk offsets.
4. Validate every offset and chunk length (bounds-check, alignment).
5. Enumerate every FourCC.
6. Parse known chunk types when present.
7. Preserve unknown chunks verbatim (FourCC + size + payload).

Known chunk parsers MAY be provided for `ISGN`, `OSGN`, `PCON`, `STAT`,
`SFI0`, `SHDR`, `SHEX`, and `RDEF`. Their **presence is NOT guaranteed**;
each parser must be invoked only if the FourCC is actually found. Do not claim
that any chunk necessarily survives `D3DStripShader(flags=7)` — that is
UNKNOWN until a before/after capture proves it (section 11, item 1).

**RDEF** is normally stripped: both compile paths call `D3DStripShader` with
flags = 7 (PROVEN: non-compute flags = `(local_res10 ^ 1) + 6`, with
`local_res10 == 0` for D3D11; compute flags = 7 in `FUN_1400b77f0`). Known
compute bypass (PROVEN): the strip is skipped when `(param_2[7] & 0x1004) !=
0`. The parser must still be capable of parsing RDEF when present (non-stripped
captures, bypass case, or `+0x90` forensic data).

The RDEF layout itself is the standard `D3D11_SHADER_DESC` + constant-buffer
tables + `D3D11_SHADER_INPUT_BIND_DESC` records from `d3d11shader.h` /
`d3dcompiler.h` (STRONGLY INFERRED; Unity reads it through the same
structures, see section 4).

---

## 6. Compute serialized format

### 6.1 Top-level (`FUN_1400b5e10`, PROVEN)

```
u64 sentinel      = 0xffffffffffffffff
u64 version       = 1
CB block          (FUN_1400b5220)
Param block       (FUN_1400b53d0)
Shader array      (FUN_1400b5760)
u8  trailingFlags (byte at container + 0x68)
```

The trailing value is ONE byte (a full-width/16/13-byte reading is wrong).

### 6.2 CB block (`FUN_1400b5220`, PROVEN)

Input: container CB-list at `+0x40` (0x48-byte entries, size at `+0x50`).

```
u64 cbCount
repeat cbCount:
    string name          (entry + 0x00)
    u64 varCount         (entry + 0x38)
    repeat varCount:     (records at entry + 0x28, 0x50-byte stride)
        string varName   (record + 0x00)
        string varType   (record + 0x28)
u64 trailingQword        (container + 0x60)
```

On the compute path the CB-list is never populated (no write to
`container+0x40` anywhere in `FUN_140006710` / `FUN_1400b77f0` /
`FUN_1400be960`), so in practice `cbCount = 0` and the block is
`u64 0` + `u64 0`. Parse it generically anyway; its producer is a different
(non-compute-container) path.

### 6.3 Param block (`FUN_1400b53d0`, PROVEN)

Input: container param-list at `+0x00` (outer entries 0x20 bytes; size at
`+0x10`).

```
u64 paramCount
repeat paramCount:                       (outer entry, 0x20 stride)
    u64 cbCount                          (outer + 0x10)
    repeat cbCount:                      (records at outer + 0x00, 0x50 stride)
        string cbName                    (record + 0x00)
        u32  cbSize                      (record + 0x28)
        u64  varCount                    (record + 0x40)
        repeat varCount:                 (records at record + 0x30, 0x40 stride)
            string varName               (record + 0x00)
            u32  a1                      (record + 0x28)
            u32  a2                      (record + 0x2c)
            u32  a3                      (record + 0x30)
            u32  a4                      (record + 0x34)
            u32  a5                      (record + 0x38)
```

On the compute path `paramCount` is normally 1 (the kernel entry appended by
`FUN_1400b77f0`).

### 6.4 Shader array (`FUN_1400b5760`, PROVEN)

Input: container shader-info array at `+0x20` (0xf8-byte entries, size at
`+0x30`).

```
u64 shaderCount
repeat shaderCount:
    string name                      from entry + 0x00
    List64 listA                     from entry + 0x28
    List64 listB                     from entry + 0x48
    List64 listC                     from entry + 0x88
    List64 listD                     from entry + 0xa8
    u64  uintPairCount               from entry + 0x78
    repeat uintPairCount:
        u32  pairLo; u32  pairHi     from entry + 0x68
    u64  dxbcSize                    from entry + 0xd8
    u8[dxbcSize] dxbc                from entry + 0xc8 (inline copy)
    u32  tgX                         from entry + 0xe8
    u32  tgY                         from entry + 0xec
    u32  tgZ                         from entry + 0xf0
```

**This is the authoritative sequential order.** Read it in exactly this order
— never via fixed serialized offsets. The dxbc bytes are a raw inline copy of
the STRIPPED DXBC (PROVEN: `FUN_1400b77f0` stores the `D3DStripShader`
output into `entry+0xc8/+0xd8`).

### 6.5 List64 (`FUN_1400b5b40`, PROVEN)

```
u64 count
repeat count:                          (0x60-byte entries)
    string name                       (entry + 0x00)
    string type                       (entry + 0x28)
    u32  v0                           (entry + 0x50)
    u32  v1                           (entry + 0x54)
    u32  v2                           (entry + 0x58)
```

### 6.6 String encoding (PROVEN)

`[i32 LE len][len raw bytes]`. SSO strings are resolved on the sender side;
the wire never carries SSO objects.

### 6.7 Per-field source/confidence table

| Serialized field | Order | Encoded size | Type | In-memory source | Confidence |
|---|---|---|---|---|---|
| sentinel | 1 | 8 | u64 | constant | PROVEN |
| version | 2 | 8 | u64 | constant 1 | PROVEN |
| CB block count | 3 | 8 | u64 | container CB-list size (+0x50) | PROVEN |
| per CB: name | 3 | var | string | CB entry +0x00 | PROVEN |
| per CB: varCount | 3 | 8 | u64 | CB entry +0x38 | PROVEN |
| per CB var: name/type | 3 | var | string×2 | 0x50-records +0x00/+0x28 | PROVEN |
| CB block trailing qword | 3 | 8 | u64 | container +0x60 | PROVEN |
| paramCount | 4 | 8 | u64 | container param-list size (+0x10) | PROVEN |
| per outer: cbCount | 4 | 8 | u64 | outer entry +0x10 | PROVEN |
| per CB: cbName | 4 | var | string | 0x50-record +0x00 | PROVEN |
| per CB: cbSize | 4 | 4 | u32 | `D3D11_SHADER_BUFFER_DESC.Size` | PROVEN |
| per CB: varCount | 4 | 8 | u64 | 0x50-record +0x40 | PROVEN |
| per var: varName | 4 | var | string | 0x40-record +0x00 | PROVEN |
| per var: a1 | 4 | 4 | u32 | Unity-mapped type | PROVEN (mapping), see 7.1 |
| per var: a2 | 4 | 4 | u32 | var `StartOffset` | PROVEN |
| per var: a3 | 4 | 4 | u32 | type `Elements` | PROVEN |
| per var: a4 | 4 | 4 | u32 | type `Rows` | PROVEN |
| per var: a5 | 4 | 4 | u32 | type `Columns` | PROVEN |
| shaderCount | 5 | 8 | u64 | container shader-info size (+0x30) | PROVEN |
| per entry: name | 5 | var | string | entry +0x00 | PROVEN serialized; source of name value STRONGLY INFERRED (compute shader name) |
| per entry: listA/B/C/D | 5 | var | List64 | entry +0x28/+0x48/+0x88/+0xa8 | PROVEN |
| per entry: uintPairCount | 5 | 8 | u64 | entry +0x78 | PROVEN |
| per entry: pairLo/pairHi | 5 | 4+4 | u32×2 | entry +0x68 | PROVEN layout; semantics 7.3 |
| per entry: dxbcSize | 5 | 8 | u64 | entry +0xd8 | PROVEN |
| per entry: dxbc | 5 | var | bytes | entry +0xc8 inline | PROVEN |
| per entry: tgX/tgY/tgZ | 5 | 4×3 | u32×3 | entry +0xe8/+0xec/+0xf0 | PROVEN |
| trailingFlags | 6 | 1 | u8 | container +0x68 | PROVEN |

---

## 7. Compute metadata semantics

### 7.1 Variable metadata (`FUN_1400be960`)

For each CB, `GetVariableByIndex` (slot 8) → `GetDesc` (slot 0) →
`GetType` (slot 8) → `GetDesc` (slot 0). A variable is serialized only if
`(varDesc.uFlags & D3D_SVF_USED(2)) != 0` (PROVEN) AND the type passes the
class guard `(Class & 0xfffffffc) == 0 && Class != 2` — i.e. Class ∈ {0, 1, 3}
(PROVEN). Matrices (Class 2) and structs (Class ≥ 4) are **dropped** with a
warning appended to `+0x90`; they do not appear in the serialized param block.

Field meanings, all PROVEN by tracing the record build in `FUN_1400be960`:

- `a1` = **Unity-mapped type value**. Mapping PROVEN (compared against the
  type-desc `Type` field):
    - `1` (BOOL) → `2`
    - `2` (INT) → `1`
    - `3` (FLOAT) → `0`
    - `19` (UINT) → `5`
    - `54` (INT64) → `0`
    - any other Type → variable dropped (warning to `+0x90`); the five-type set
      is also confirmed by the bitmap in `FUN_140037600`.
      The D3D_SVT names (BOOL/INT/FLOAT/UINT/INT64) are STRONGLY INFERRED from the
      public `d3dcommon.h` enum. **"a1 mapping values are proven; their complete
      Unity semantic meaning is not yet proven."** Because `FLOAT(3)` and
      `INT64(54)` both map to `0`, and `FLOAT16(53)` is not mapped, the original
      `D3D_SVT` is NOT recoverable where values collapse.
- `a2` = variable **StartOffset** (copied from
  `D3D11_SHADER_VARIABLE_DESC.StartOffset`, PROVEN). Variable `Size` (desc
  +0x0c) is never read → not serialized; it is DERIVABLE only where offsets
  and type shape allow.
- `a3` = type **Elements** (PROVEN).
- `a4` = type **Rows** (PROVEN).
- `a5` = type **Columns** (PROVEN).
- `cbSize` (`u32` in the CB record) = **CB size** (copied from
  `D3D11_SHADER_BUFFER_DESC.Size`, PROVEN).

Unity reads but does NOT serialize: variable Size, variable uFlags (used only
as the USED filter), type Class (used only as the guard), type Members /
member names, CB type (only the `== CBUFFER` check), CB uFlags.

### 7.2 Resource metadata

Trace per resource, all PROVEN at each hop:

1. **D3DReflect** (`GetResourceBindingDesc`, slot 0x30) → full
   `D3D11_SHADER_INPUT_BIND_DESC` (`Type@+0x08`, `BindPoint@+0x0c`,
   `Dimension@+0x1c`, ...).
2. **Unity classification** (`FUN_1400be960`, `switch(Type)`):
    - `0` CBUFFER → listA (`+0x28`) — CB names.
    - `2` TEXTURE → if `Dimension == BUFFER(1)`: listC (`+0x88`); else listB
      (`+0x48`) and a 0x28-record used for sampler matching.
    - `3` SAMPLER → no list; handled by the sampler-match pass.
    - `4,6,8,9,10,0xb` UAV → 0x60-record into listD (`+0xa8`).
    - `5,7` STRUCTURED / RWSTRUCTURED → listC (`+0x88`).
3. **Serialized** via `FUN_1400b5760` as List64s (section 6.5).

List64 field semantics:

- **listA** (CB names): `v0/v1/v2` set by the generic append
  `FUN_140007370`; semantics UNKNOWN (not traced). The name is the CB resource
  name (PROVEN).
- **listB** (textures): each entry `+0x54` is patched with the `BindPoint` of
  the sampler whose name equals the texture name (PROVEN); `v0/v2`
  (`+0x50/+0x58`) semantics UNKNOWN (generic append).
- **listC** (buffers/structured): as listA.
- **listD** (UAVs): PROVEN record = `{name string @+0x00, empty type string
  @+0x28, v0 = BindPoint, v1 = 0xffffffff, v2 = mapped Dimension}`. `v2`
  mapping PROVEN: `Dimension {4,6}→2, {5,7}→5, {8}→3, {9}→4, {10}→6`, else
  `0xffffffff` (e.g. `Dimension == BUFFER`). Unity meaning of the map values
  POSSIBLE.
- The `type` string of listB/listC/listD entries is emitted as an empty SSO
  string (fields initialized, no content copied) — STRONGLY INFERRED.

Per-resource property classification (compute serialized output):

| Property | Status |
|---|---|
| name | FULLY PRESERVED (list membership) |
| type | TRANSFORMED — original `D3D_SHADER_INPUT_TYPE` recovered only as list-class (A/B/C/D); the value itself is LOST |
| bind point | PARTIALLY PRESERVED — listD `v0`; listB `+0x54` (sampler pair); elsewhere LOST |
| bind count | LOST |
| uFlags | LOST (only used as a USED filter for variables, not resources) |
| return type | LOST |
| dimension | TRANSFORMED — listD `v2` mapped; original `D3D_SRV_DIMENSION` LOST |
| sample count | LOST |
| final 0x24 field | LOST |

### 7.3 uint-pair list (sampler state)

The uint-pair list (`entry+0x68`, count `+0x78`) receives one qword per
**sampler resource whose name matches no texture resource name** (name match
is exact, `FUN_1400a4030`, PROVEN). Each qword:

- low u32 = packed sampler state parsed from the sampler NAME by
  `FUN_1400af960` (filter point/linear/trilinear/anisoN, wrap
  mirror/clamp/repeat, compare, aniso power as log2 in bits 9–11; bit layout
  POSSIBLE).
- high u32 = sampler `BindPoint` (PROVEN).

On parse failure (`*result >= 0x1000`, e.g. `0xffffffff`) a warning is
appended to `+0x90` and no pair is emitted. A sampler that DOES match a
texture name is represented only by the texture's `+0x54` patch — it has no
entry of its own.

---

## 8. Compute variable metadata — PROVEN vs POSSIBLE summary

PROVEN (this revision upgrades these from POSSIBLE):

- Variable records serialize `{name, a1, a2, a3, a4, a5}` in that order.
- `a1` = Unity-mapped type value; mapping table in section 7.1.
- `a2` = `StartOffset`; `a3` = `Elements`; `a4` = `Rows`; `a5` = `Columns`.
- Only `D3D_SVF_USED` variables with Class ∈ {0,1,3} and Type ∈
  {1,2,3,19,54} are serialized; all others are dropped with `+0x90` warnings.
- CB `u32 cbSize` = CB size.

POSSIBLE / not relied upon:

- The Unity semantic meaning of the mapped type values `0/1/2/5`.
- Whether `Class 3` here is "matrix" or something else (the guard only proves
  which class values pass, not their names).
- Recovery of the original `D3D_SVT` for any variable (blocked by mapping
  collisions).

---

## 9. The `+0x90` metadata stream

- It is **compiler/editor IPC metadata**, separate from the shipped `+0x40`
  artifact.
- This binary PROVES it is generated: pre-compile lists via `FUN_140088390`
    + `FUN_1400882e0`; post-compile error/warning strings via `FUN_14007b380`
      (both compile paths).
- This binary does NOT prove it reaches player data (UNKNOWN).
- The parser MUST NOT depend on `+0x90` for shipped-player parsing. It MAY
  expose an optional forensic parser for it. Entry shape built by
  `FUN_14000f2a0`: `{string A, string B, u32 value, u8 type(0|1), u32
  tag(0x1a)}` (PROVEN build); the exact on-wire framing by `FUN_14000cbf0` is
  POSSIBLE.

---

## 10. Recoverability statuses

Use these four statuses, never blurred:

| Status | Meaning |
|---|---|
| recoverable from compiler output | present in the compiler's serialized output (`+0x40`) |
| recoverable from IPC capture | present in the `+0x90` metadata or wire framing |
| recoverable from final player artifact | independently proven present in player data |
| unknown | not established |

No field is marked "recoverable from final player artifact" anywhere in this
document (no player-side evidence exists).

---

## 11. RDEF recoverability matrix

Columns: Original source / Unity reads it? / Unity transforms it? / Unity
serializes it? / Compiler IPC contains it? / Final player proven? /
Recoverability / Confidence / Evidence.

Shaded rows reference the shipped artifacts: **NC** = non-compute `+0x40`,
**C** = compute `+0x40`, **IPC** = `+0x90`.

| Field | Original source | Unity reads? | Transforms? | Serializes? | IPC? | Player proven? | Recoverability | Confidence |
|---|---|---|---|---|---|---|---|---|
| shader version | `D3D11_SHADER_DESC.Version` | yes | no | no | no | UNKNOWN | NC: no; C: no; from DXBC SHDR/SHEX version header | STRONGLY INFERRED |
| creator | desc.Creator | no | — | no | no | UNKNOWN | LOST | PROVEN (never read) |
| flags | desc.Flags | no | — | no | no | UNKNOWN | LOST | PROVEN |
| cb count | desc.ConstantBuffers | yes | implicit | NC: no; C: param block counts | yes (partial) | UNKNOWN | C: recoverable from param block; NC: no | PROVEN |
| bound-resource count | desc.BoundResources | yes | implicit | C: lists+uint-pairs | yes | UNKNOWN | C: partial (per-list counts) | PROVEN |
| input param count | desc.InputParameters | yes (channel map) | yes | no | partial | UNKNOWN | NC: from ISGN if it survives (STRONGLY INFERRED); C: same | see §5 |
| output param count | desc.OutputParameters | yes | no | no | no | UNKNOWN | NC: from OSGN if it survives | see §5 |
| patch param count | desc.PatchConstantParameters | no | — | no | no | UNKNOWN | LOST | PROVEN |
| GS metadata | desc (GS fields) | no | — | no | no | UNKNOWN | LOST | PROVEN |
| thread-group metadata | `GetThreadGroupSize` slot 0xa0 | yes | no | C: tgX/tgY/tgZ | no | UNKNOWN | C: FULLY PRESERVED; NC: n/a (flag byte only, =0) | PROVEN |
| cb name | CB `GetDesc` | yes | no | C: param block / CB block | yes | UNKNOWN | C: recoverable | PROVEN |
| cb type | CB desc.Type | yes (must==CBUFFER) | filter | no | no | UNKNOWN | LOST (only CBs survive) | PROVEN |
| cb size | CB desc.Size | yes | no | C: cbSize u32 | yes | UNKNOWN | C: recoverable | PROVEN |
| cb flags | CB desc.uFlags | no | — | no | no | UNKNOWN | LOST | PROVEN |
| var name | var `GetDesc` | yes | no | C: param block | yes | UNKNOWN | C: recoverable | PROVEN |
| var offset | var desc.StartOffset | yes | no | C: a2 | yes | UNKNOWN | C: recoverable | PROVEN |
| var size | var desc.Size | no | — | no | no | UNKNOWN | not serialized; DERIVABLE only from offsets/shape | PROVEN (not read) |
| var flags | var desc.uFlags | yes | USED filter | no | no | UNKNOWN | value LOST (used as filter) | PROVEN |
| var default value | var desc.DefaultValue | no | — | no | no | UNKNOWN | LOST | PROVEN |
| var class | type desc.Class | yes | guard filter | no | no | UNKNOWN | value LOST (guard only) | PROVEN |
| var type | type desc.Type | yes | map a1 | C: a1 | yes | UNKNOWN | PARTIAL: only mapped value; original `D3D_SVT` not recoverable (collisions) | PROVEN map, POSSIBLE semantics |
| rows | type desc.Rows | yes | no | C: a4 | yes | UNKNOWN | C: recoverable | PROVEN |
| columns | type desc.Columns | yes | no | C: a5 | yes | UNKNOWN | C: recoverable | PROVEN |
| elements | type desc.Elements | yes | no | C: a3 | yes | UNKNOWN | C: recoverable | PROVEN |
| members / member names | type desc.Members | no | — | no | no | UNKNOWN | LOST (structs dropped) | PROVEN |
| resource name | `GetResourceBindingDesc` | yes | no | C: listA/B/C/D | yes | UNKNOWN | C: FULLY PRESERVED (list membership); NC: LOST | PROVEN |
| resource type | binding desc.Type | yes | list-class + dim map | C: implicit | yes | UNKNOWN | PARTIAL: list membership only; value LOST | PROVEN |
| bind point | binding desc.BindPoint | yes | extents (NC) / v0 (C) | NC: extent only; C: partial | yes | UNKNOWN | NC: extent (max+1); C: listD v0, listB +0x54 | PROVEN |
| bind count | binding desc.BindCount | yes | no | no | yes | UNKNOWN | LOST (extent only) | PROVEN |
| resource flags | binding desc.uFlags | no | — | no | yes | UNKNOWN | LOST | PROVEN |
| return type | binding desc.ReturnType | no | — | no | yes | UNKNOWN | LOST | PROVEN |
| dimension | binding desc.Dimension | yes | map v2 | C: listD v2 | yes | UNKNOWN | PARTIAL: listD v2 mapped only | PROVEN map |
| sample count | binding desc.NumSamples | no | — | no | yes | UNKNOWN | LOST | PROVEN |
| space | binding desc 0x24 | no | — | no | no | UNKNOWN | LOST | UNKNOWN (see §4) |
| uID | n/a | no | — | no | no | UNKNOWN | LOST | UNKNOWN |

---

## 12. Information loss

Losses are classified into explicit categories:

- **A. Removed by `D3DStripShader`(flags=7)**: RDEF, DEBUG, TEST (per
  documented flags; exact surviving chunk set UNKNOWN until capture). All
  RDEF tables (creator, flags, cb count, full binding records) are gone from
  every shipped `+0x40` blob unless the compute bypass applies.
- **B. Never extracted by Unity**: creator, desc.Flags, CB uFlags, var Size,
  var DefaultValue, resource ReturnType/NumSamples/BindCount/uFlags, member
  names, patch-param details (never read from the interface).
- **C. Extracted but discarded before serialization**: the full 0x28 resource
  records on the non-compute path (used only for extents, then freed); var
  uFlags (used only as the USED filter); type Class (used only as the guard);
  CB type (used only as the CBUFFER check).
- **D. Serialized only to compiler/editor IPC (`+0x90`)**: non-compute CB
  names, variable names/types, resource/sampler details built by
  `FUN_140019550`; error/warning strings from all paths.
- **E. Serialized into `computeData` (`+0x40`)**: CB names, CB sizes,
  variable names + mapped types + offset/rows/cols/elements (guard-filtered),
  resource names by list class, UAV bindpoints/dimensions, sampler-state
  pairs, thread-group sizes, embedded stripped DXBC.
- **F. Demonstrably present in final player**: NONE (no player-side evidence;
  all UNKNOWN).
- **G. Recoverable indirectly from surviving DXBC**: ISGN/OSGN/PCON
  signatures and STAT/SFI0 statistics, but ONLY if those chunks survive the
  strip — currently UNKNOWN; bytecode (SHDR/SHEX) is always recoverable when
  present.

**The single most important loss**: on the non-compute path, everything beyond
the 0x26 header (four extents + a 0 flag byte) is absent from the shipped
artifact. Do not fabricate resources, bindpoints, CB sizes, or variable
layouts from the extents.

---

## 13. Final parser data model

Implementation-safe structures. Optional fields are nullable and never
fabricated.

```
UnityShaderBlob {
  kind: NonCompute | Compute | RawVariant
  source: "shipped" | "ipc-capture" | "unknown"
  unityHeader?: UnityNonComputeHeader      // kind == NonCompute
  computeMetadata?: UnityComputeMetadata    // kind == Compute
  dxbc: DXBCContainer
  rawBytes: u8[]                            // original payload
}

UnityNonComputeHeader {
  versionTag: u8                            // 0x02
  texExtent, cbExtent, samplerExtent, uavExtent: u8   // max(bindpoint+1) per class
  flag: u8                                  // 0 on D3D11 non-compute (see §3)
  reserved: u8[0x20]
}

UnityComputeMetadata {
  sentinel: u64                             // 0xffffffffffffffff
  version: u64                              // 1
  cbBlock: CbBlock
  paramBlock: ParamBlock
  shaderEntries: UnityShaderEntry[]
  trailingFlags: u8
}

CbBlock { count: u64; entries: CbEntry[]; trailing: u64 }
CbEntry  { name?: string; varCount: u64; vars: VarPair[] }   // VarPair = {name?, type?}

ParamBlock {
  outerCount: u64
  entries: ParamOuter[]                     // each: cbCount + CbRecords[]
  CbRecord  { name?: string; cbSize?: u32; varCount: u64; variables: Variable[] }
  Variable  {
    name?: string
    unityType?: u8                          // a1 mapped value 0/1/2/5
    startOffset?: u32                       // a2
    elements?, rows?, columns?: u32         // a3/a4/a5
    sourceType?: none                       // NEVER fabricate original D3D_SVT
  }
}

UnityShaderEntry {
  name?: string
  lists: { listA/B/C/D: List64Entry[] }     // List64Entry = {name?, type?, v0?, v1?, v2?}
  uintPairs: { lo: u32; hi: u32 }[]
  dxbc: { size: u64; bytes: u8[] }
  threadGroup: { x, y, z: u32 }
}

DXBCContainer {
  magic: "DXBC"; version: u32; containerSize: u32
  chunks: DXBCChunk[]
}

DXBCChunk { fourCC: string; size: u32; payload: u8[]; parsed?: ParsedChunk }
ParsedChunk = SignatureChunk | StatsChunk | RdefChunk | null

ResourceBinding { rawFields: u32[8]; name?: string }  // raw 0x28 record; semantic fields only where proven
ConstantBuffer  { name?: string; size?: u32; variables: Variable[] }
```

Rules the model enforces:

- Never synthesize resource names, resource occupancy, bindpoints, CB sizes,
  or variable layouts from extents or presence alone.
- `unityType`/`startOffset`/`elements`/`rows`/`columns` only when actually
  parsed from a compute param block.
- Every parse result carries the confidence of each field it set.

---

## 14. Classifier

Candidates are hints only; classify only after validating the entire
structure.

1. **Wire frame**: first u32 == `0x0C0BD1E4` → read u64 size, payload =
   next `size` bytes, recurse on payload.
2. **Compute**: first u64 == `0xffffffffffffffff` AND second u64 == 1 → parse
   as `UnityComputeMetadata` (full sequential parse; fail on any length
   overflow).
3. **Non-compute**: byte0 == 0x02 AND bytes `[0x26,0x2a)` == `"DXBC"` →
   parse header + DXBC at 0x26.
4. **Raw/non-D3D11 variant**: byte0 == 0x00 AND bytes `[0x01,0x05)` ==
   `"DXBC"` → raw blob (strip flags = 6, no header) — PROVEN behavior when
   `local_res10 != 0` in `FUN_140022fb0`.
5. Otherwise: error (unknown format).

A single magic value alone is never enough; each branch re-validates the
DXBC header and chunk table before committing.

---

## 15. Test vectors

For each test: original reflection expectation → compiler output expectation →
parser expectation → what remains unknown.

1. **Sparse CB (`b3` only)**: D3DReflect BindPoint=3, BindCount=1.
   Compiler output: `cbExt=4`. Parser: header `{cbExtent:4}`, NO resource
   list, NO fabricated `b0..b3`. Unknown: none (extent semantics PROVEN).
2. **Sparse texture (`t7` only)**: `texExt=8`.
3. **Sparse sampler (`s5` only)**: `sampExt=6`.
4. **Multiple sparse (`b3,b7,t2,t7,s5`)**: `cbExt=8, texExt=8, sampExt=6,
   uavExt=0`; parser reports only extents.
5. **Multiple CB variables** (float, float4, matrix, array, struct) in a
   compute CB: compiler param block contains float → `{type0, rows1, cols1,
   elements1}`; float4 → `{type0, rows1, cols4}`; array → `elements=N`;
   matrix and struct → DROPPED (absent). Parser must not invent the dropped
   ones. Unknown: matrix/struct drop depends on Unity's class guard being
   hit — PROVEN in the binary; confirm against a real compile.
6. **Compute with multiple CBs, texture, sampler, structured buffer, UAV,
   explicit numthreads**: param block with several CBs; listB texture entry
   (with `+0x54` sampler bindpoint when names match); listC structured; listD
   UAV `{bindpoint, 0xffffffff, dimMap}`; uint-pairs for unmatched samplers;
   tgX/Y/Z == numthreads. Parser expectations per section 6. Unknown: real
   captured byte-stream equivalence (needed to promote STRONGLY INFERRED
   items).
7. **RDEF-present exception**: compute strip bypass `(param_2[7] &
   0x1004) != 0` — reproduce with a compute shader whose compile request sets
   those flags; the blob then retains RDEF and the parser must parse it.
   Unknown: how the editor triggers the bypass (not visible in this binary).
8. **Unknown DXBC chunk**: inject a synthetic chunk (e.g. `"JUNK"`) — parser
   preserves it verbatim, continues.
9. **Malformed length**: truncate a string length / dxbcSize / chunk offset —
   parser rejects safely (no OOB, no partial commit).
10. **Non-contiguous bindings**: header `{cbExt=4}` from `b3` — parser does
    NOT report 4 CBs, only `cbExtent=4`.

---

## 16. Required proofs

Each UNKNOWN/STRONGLY INFERRED item: current evidence → where to look → exact
bytes to inspect → required test → promotion condition.

1. **Exact surviving DXBC chunk set after `D3DStripShader(flags=7)`**.
   Evidence: flags PROVEN in `FUN_140022fb0` / `FUN_1400b77f0`; strip runs in
   external `d3dcompiler_47.dll`. Look: bytecode paths (SHDR/SHEX), DXBC chunk
   table. Inspect: chunk FourCC list of any shipped blob. Test: capture blob
   before and after strip for each shader type. PROVEN when an actual
   before/after capture shows the survivor set (expect RDEF/DEBUG/TEST gone;
   ISGN/OSGN/STAT/SFI0 survival is the question).
2. **Exact serialized compute ShaderInfoEntry layout**.
   Evidence: PROVEN serializer order (section 6.4) from `FUN_1400b5760`.
   Inspect: bytes between listD and tgZ on a real computeData blob. PROVEN
   when a captured blob round-trips byte-identically through the parser.
3. **Exact meanings of compute variable fields a2..a5**.
   Evidence: PROVEN to be StartOffset/Elements/Rows/Columns (section 7.1).
   Remaining: none for provenance; confirm against a known CB layout. PROVEN
   when a capture with a known `float4`/array CB matches offsets/rows/cols.
4. **Exact semantics of the Unity type enum a1**.
   Evidence: mapping PROVEN; semantic meaning POSSIBLE. Look: downstream
   consumers of the computeData payload (editor-side). Test: compile a known
   CB and read `a1`. PROVEN when the editor's interpretation of each value is
   confirmed (e.g. via a Unity editor round-trip).
5. **Exact semantics of the final 0x28-byte resource-binding field (0x24)**.
   Evidence: copied verbatim; not consumed. Look: SDK headers Unity builds
   against; `FUN_140019550`'s copy. Inspect: bytes 0x24..0x28 of `param_8`
   records. Test: shader with explicit `register(space1, t0)`. PROVEN when
   the field equals `Space`/`uID` from `D3DReflect`.
6. **Whether computeData survives into player data**.
   Evidence: compiler emits it (`FUN_1400b5e10`); player-side UNKNOWN. Look:
   Unity player shader-serialization code (not in this binary). Test: unpack
   a real player asset. PROVEN when a player asset contains the computeData
   `+0x40` payload byte-for-byte.
7. **Whether `+0x90` metadata survives into player data**.
   Same as 6; PROVEN when a player asset contains the `+0x90` stream.
8. **Meaning of the non-compute flag byte**.
   Evidence: byte = desc field +0x78 (= `cNumTotalThreads`, STRONGLY
   INFERRED), 0 for non-compute. Test: any non-compute capture. PROVEN when a
   nonzero flag appears and its cause is identified.
9. **Exact signature-chunk layout in the actual shipped output**.
   Evidence: standard ISGN/OSGN/PCON layout (STRONGLY INFERRED), matches
   `D3D11_SIGNATURE_PARAMETER_DESC` read via slot 0x38. Test: parse a shipped
   blob's ISGN and compare to `D3DReflect` `GetInputParameterDesc`. PROVEN
   when survival + field-by-field equality is captured.
10. **Any exceptional path emitting unstripped RDEF**.
    Evidence: compute bypass `(param_2[7] & 0x1004) != 0` (PROVEN). Test:
    trigger the bypass, confirm RDEF present. PROVEN when reproduced.
11. **Whether any Unity stage modifies the stripped DXBC after
    UnityShaderCompiler**.
    UNKNOWN from this binary. Look: editor import / player build pipeline.
    Test: hash the blob at compiler output vs. player asset. PROVEN when
    byte-identical or when the modification is identified.
12. **Whether all non-compute metadata beyond the 0x26 header is truly absent
    from the final shipped artifact**.
    Evidence: PROVEN absent from the compiler's `+0x40` output. The open
    question is player-side, not compiler-side. Test: unpack a player asset.
    PROVEN when a non-compute player asset is shown to be exactly
    `[0x26-byte header][stripped DXBC]` (or the delta is identified).

---

## 17. Final standard

A developer implementing from this document must be able to build the parser
without:

- inventing resources or bindpoints from extents;
- treating extents as counts;
- confusing in-memory ShaderInfoStruct offsets with serialized positions;
- assuming any DXBC chunk survives stripping;
- assuming compiler IPC metadata (`+0x90`) reaches the player;
- treating Unity-transformed metadata as lossless RDEF;
- fabricating CB sizes, variable layouts, or original `D3D_SVT` values.

## 18. Evidence index (functions/addresses)

- Serializers: `FUN_1400b5e10` (master), `FUN_1400b5220` (CB block),
  `FUN_1400b53d0` (param block), `FUN_1400b5760` (shader array),
  `FUN_1400b5b40` (List64), `FUN_1400b5cf0` (string), `FUN_1400b6ee0`
  (scalar writer).
- Compile paths: `FUN_140022fb0` (non-compute header/extents),
  `FUN_140019550` (non-compute reflection, 0x28 records, channel map),
  `FUN_140006710` (compute dispatcher), `FUN_1400b77f0` (compute
  compile+reflect+strip), `FUN_1400be960` (compute reflection),
  `FUN_140037600` (non-compute variable builder), `FUN_14000e640` (CB entry
  copy), `FUN_1400b7620` (`__` name check → `+0x90`).
- `+0x90`: `FUN_140088390` / `FUN_1400882e0` / `FUN_14000f2a0` /
  `FUN_14007b380` / `FUN_14007b2e0`.
- Sampler state parser: `FUN_1400af960`.
- Reflection interface (ID3D11ShaderReflection): slots 0x18 GetDesc, 0x20
  GetConstantBufferByIndex, 0x30 GetResourceBindingDesc, 0x38
  GetInputParameterDesc, 0xa0 GetThreadGroupSize; sub-object slot 0 =
  GetDesc.
- Wire: `FUN_1400b8a50` (dispatcher), magic `DAT_1402f46c4`.
- Type-map constants: mapping {1→2, 2→1, 3→0, 19→5, 54→0} in
  `FUN_1400be960`; class bitmap `0x4000000008000e` (bits {1,2,3,19,54}) in
  `FUN_140037600`.