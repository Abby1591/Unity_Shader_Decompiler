# Corpus decompile failure audit

Measured on `master` (`cd703e5`) against the 48 Unity 6 corpus shaders in
`samples/`. Stage 0 extracted with `Extract.py`, Stage 1 decompiled with the
CLI, every `HLSLPROGRAM` block recompiled with `d3dcompiler`.

PR #2 (`bae3869`) does not change the decompiler pipeline, so these findings
apply to both trees. The CLI/chunk-reader problems from the PR #2 review are a
separate concern and are not repeated here.

## Summary

| Metric | Value |
|---|---|
| Shaders | 48 |
| HLSL blocks | 449 |
| Blocks that compile | 434 (96.7%) |
| Compile failures | 12 in 11 shaders |
| Shaders with unhandled IR | 4 |
| Unmatched metadata passes | 14 (all emitted as stubs) |
| `_StubCB` stub passes | 24 in 9 shaders |
| Defective shaders (union) | 21 |
| Clean shaders | 27 |

Defective (21): `02, 03, 10, 14, 15, 16 UsePass Consumer, 18, 19, 20, 22, 23,
24, 25, 28, 29, 33, 36, 37, 41, 44, 45`.

Clean (27): `01, 04, 05, 06, 07, 08, 09, 11, 12, 13, 16 Base, 17, 21, 26, 27,
30, 31, 32, 34, 35, 38, 39, 40, 42, 43, 46, 47`.

Most defects are small, independent emitter gaps. Nothing here points at the
parser or the optimizer pipeline as a whole: all 21 shaders are produced from
valid DXBC, and every failure is in IR-to-HLSL lowering or in pass grouping.
Several (classes 1, 2, 10, 12) are one-to-five-line dispatch/mapping omissions.

## Failure classes

### 1. Coarse/fine derivatives silently dropped (Corpus_22)

Evidence: `Corpus_22` line 119 emits
`_Tex2DArray.SampleGrad(..., float4(r0_x, r0_y, r0_x, r0_x), float4(r0_z, r0_w, ...))`
but no statement ever declares `r0_x/y/z/w`.

Cause: `IRBuilderComparison.cs:93-96` implements `BuildDerivRtxCoarse`,
`BuildDerivRtxFine`, `BuildDerivRtyCoarse`, `BuildDerivRtyFine`, but the
dispatch in `IRBuilder.cs:297-298` only routes `DerivRtx`/`DerivRty`. The
coarse/fine variants fall through to `default:` at `IRBuilder.cs:469-470`,
which prints `IR: Unsupported opcode ...` and drops the write. The gradient
registers are therefore read before ever being written (`IRSsaRenaming` leaves
their versions null) and render as bare `r0_x`.

Fix: add the four cases to the dispatch (they already exist and are correct).
This is the cheapest fix in the list.

### 2. `udiv` remainder destination dropped (Corpus_23)

Evidence: `Corpus_23:94,101-102` read `r3_x`, which is never declared.

Cause: DXBC `udiv` is a four-operand, two-destination instruction
(`udiv quotient, remainder, src0, src1`). `IRBuilderArithmetic.cs:88` routes
`Opcode.UDiv` to the single-output `BuildTypedBinary`, which treats operand 1
as a source. `BuildUDivExtended` (`:96-110`) implements the correct form but
its own comment says it is "not wired into ConvertInstruction yet". The
remainder destination is never emitted.

Fix: wire `BuildUDivExtended` (and add the opcode-table operand count so the
operand order is confirmed), then let const/copy propagation handle the rest.

### 3. Read-before-write temps render as undeclared identifiers

Evidence:
- `Corpus_22:119` (consequence of class 1)
- `Corpus_23:94,101-102` (consequence of class 2)
- `Corpus_29:76` `float r0_y_3 = mad(i.texcoord0.y, r0_y_2, ...)` where
  `r0_y_2` is never declared anywhere in the function.

Cause: `IRSsaRenaming.cs:98-104` leaves the version null for a component that
is read before any write on that path. `ScalarIdentifier`
(`HlslPrettyPrinter.Registers.cs:332-341`) then emits `r0_x` (no version), and
`RenderTempRead` has no declaration to resolve. The only null-version fallback
is `RenderAssignmentLines` (`:654-684`), and it fires only when the whole RHS
is a bare `RegisterExpression`; a null-version read nested in a texture op,
binary expression, or intrinsic call is emitted as an undeclared name. In
`Corpus_29` the read even carries version 2, so the defining statement was
lost after SSA renaming (so this is not only a null-version issue).

Fix: add one function-level self-check in the printer: collect every
`<temp>_<letter>[_<version>]` identifier referenced while printing a function
and emit a `float <name>;` for anything not in `PrintContext.Declared` at the
top of the function. That is semantically safe (undefined value stays
undefined) and makes classes 1-3 produce compilable, if garbage-reading, HLSL
instead of invalid HLSL. Fix classes 1 and 2 for correctness.

### 4. Integer immediates reinterpreted as float produce `NaN` (Corpus_23)

Evidence: `Corpus_23:69`
`float r0_x_6 = ... (r0_y_1 ? NaN : (-r0_x_1 + 31)));`

Cause: `IRExpression.cs:53-91` formats a `ConstantKind.Float` immediate by
reinterpreting the raw 32-bit pattern as `float` and calling
`ToString()`. `0xFFFFFFFF` is `-1` in an integer context but `NaN` as a float,
and `NaN` is not a legal HLSL literal. The constant's kind is chosen from the
operand, and the integer instruction path here used the float builder.

Fix: format constants with `InvariantCulture`, and emit `asfloat(0xFFFFFFFFu)` (or
keep the integer kind) when the raw pattern is NaN/Infinity. Also confirm the
instruction uses `BuildIntExpression`, not `BuildExpression`, when the operand
is declared integer.

### 5. IR expression nodes with no HLSL renderer (Corpus_25, latent)

Evidence: `Corpus_25:53`
`float r0_x_1 = bitfieldinsert(1, 1, SV_VertexID0.x, 0);`
- `bitfieldinsert` and `bitfieldextract` are not HLSL intrinsics.
- `SV_VertexID0` is the raw semantic; the input field is `sv_Vertexid0`.
- `imul_hi`, `umul_hi`, `mul64`, `umul64` would be emitted the same way.

Cause: `HlslPrettyPrinter.Registers.cs:997-1012` falls back to
`expr.ToString()` for `BitFieldInsertExpression`, `BitFieldExtractExpression`,
`MultiplyHighExpression` and `Multiply64Expression`. Their `ToString()`
(`IRExpression.cs:361-425`) emits pseudo-code, not HLSL. The same expression
path also bypasses semantic binding, which is why the `SV_VertexID` name is
not lowered by `HlslAstBuilder.ToFieldName` (`:683-691`).

Fix: add four cases to `RenderExpression`:
- BFI: `((base & ~(mask << offset)) | ((insert << offset) & (mask << offset)))`
  with `mask = ((1u << width) - 1u)`.
- BFE: `((value >> offset) & mask)`, or the signed form with a sign extension.
- `imul_hi`/`umul_hi`/`mul64`: no HLSL builtin; expand to the shift/mask form or
  emit a named helper. This is the most invasive item.
Also route every register read inside these expressions through the normal
`RenderRegisterRead` path so semantic field names are resolved.

### 6. Same cbuffer variable declared in two buffers (Corpus_20, Corpus_28)

Evidence:
- `Corpus_20:20-36`: `_Color` in `_GlobalsCB_b0` and again in `Props : register(b3)`.
- `Corpus_28:35-43`: `unity_ObjectToWorld` and `unity_WorldToObject` in
  `_UnityPerDrawCB_b2` and again in `_UnityPerFrameCB_b3`.

Cause: `Decompiler.AttachPassProgram` (`Decompiler.cs:611-650`) dedupes by
`(Kind, Slot)` and unions variables only *within* one buffer by name. The
metadata exposes the same variable in two buffers, so both are emitted;
HLSL rejects the redefinition.

Fix: after resource merge, dedupe variable names across every `ConstantBuffer`
resource in the pass. Keep the declaration whose slot the stage actually reads
(available from the register reads), otherwise the first. Rename instead of
drop only if the two slots are genuinely both read.

### 7. Non-scalar conditions in `if` / `breakc` (Corpus_24)

Evidence: `Corpus_24:75` `if ((r0_yz_3.y >= unity_ObjectToWorld[2])) break;`
where the right operand is a `float4x4` row, so the comparison is `bool4`.
Every other condition in that shader happens to be scalar.

Cause: the condition is rendered with `RenderExpression` alone
(`HlslPrettyPrinter.Registers.cs:37,85,89,95,99`) with no scalarization. The
metadata cbuffer read path (`RenderCbufferRead`, `:198-228`) resolves the
matrix row to a bare `unity_ObjectToWorld[2]` and does not append the
operand's `Select1` suffix, unlike the symbolic-name path. DXBC conditions are
always one lane.

Fix: (a) append `MaskOrSwizzleSuffix` when the metadata cbuffer resolver
returns a whole row/variable; (b) scalarize any condition whose
`ExpressionWidth` (`:814`) is greater than 1 by appending `.x`. (b) alone
makes the output compile and is cheap.

### 8. Switch-case declarations are not hoisted (Corpus_45)

Evidence: `Corpus_45:128` declares
`float3 COLOR0_xyz_12` inside `case 0:`, and `:131,134,...` assign it from
other cases.

Cause: `HlslPrettyPrinter.Registers.cs:75-81` prints each case in place. The
if and loop paths hoist merge names above their braces (`:30-43`, `:56-70`),
but the switch path has no equivalent. `PrintContext.Declared` is shared for
the whole function, so later cases emit a bare assignment to a name whose
declaration was scoped to `case 0`.

Fix: reuse the if/loop hoisting for switches: collect destination names from
all cases and declare the missing ones above `switch (...)`. A plain
`WrittenDeclNames` union across `sw.Cases` is enough for this corpus.

### 9. Nested cross-branch merge names are not hoisted (Corpus_36)

Evidence: `Corpus_36:2814` (inside one arm) and `:2850` (inside the other arm)
both define `unity_ProbeVolumeParamsSelect_xyz_6`; a read after the merge uses
it outside both arms.

Cause: `CrossBranchMergeNames` (`:904-922`) only considers names in
`WrittenDeclNames` (`:941`) which, by design, looks at *top-level* statements
of each arm ("nested ifs/loops handle their own merges"). When the same SSA
value is written in nested ifs in both arms, neither arm's top level contains
the name, so it is never hoisted, yet the post-merge read needs it.

Fix: make `WrittenDeclNames` recurse through `HlslIfStatement`,
`HlslLoopStatement`, `HlslSwitchStatement` when collecting names for hoisting
(a name declared in a nested arm is still a write the enclosing merge must see).

### 10. Structured/raw resource declarations are dropped (Corpus_41)

Evidence: `Corpus_41:51` declares only `Texture2DArray t1;`, while `:142-143`
call `t2.Load(0)` and `t3.Load(0)`. Disassembly of the same DXBC has
`dcl_resource_structured t2, 16` and `dcl_resource_raw t3`.

Cause: `IRBuilderDeclarations.cs:333-346` emits
`IRResourceRawDeclaration` / `IRResourceStructuredDeclaration`, but
`HlslAstBuilder.BuildResources` (`:236-332`) only handles
`IRResourceDeclaration`. The new declaration types are never turned into HLSL
resources. (`TextureTypeHint` already knows `RawBuffer` and
`StructuredBuffer`.)

Fix: add cases for the two declaration types in `BuildResources` and emit
`ByteAddressBuffer tN` / `StructuredBuffer<T> tN` (choose `T` from
`StructureStride`; `float4` for stride 16, otherwise a typed-`Buffer`/`uint`
fallback with a `shortcut:` note). `TextureTypeHint` must return
`StructuredBuffer<...>` including the template argument, not the bare name.

### 11. Unhandled hull/geometry tokens emitted as comments (Corpus_10, 18, 19)

Evidence:
- `Corpus_10:414,1741` and `Corpus_19:67`: `// TODO: unhandled IR node - hs_fork_phase`
- `Corpus_18:121,129,135,136`: `// TODO: unhandled IR node - emitStream(0)` / `cutStream(0)`

Cause: the raw-statement renderer
(`HlslPrettyPrinter.Registers.cs:108-110`) emits any IR node it does not know
as a comment. `hs_fork_phase` separates the main hull phase from the
patch-constant phase; dropping it merges/invalidates the two phases.
`emitStream`/`cutStream` have no HLSL equivalent (streams are implicit in a
Unity geometry shader), so the comment itself is harmless, but the geometry
shader's structure must be checked independently.

Fix: model `hs_fork_phase` as a phase boundary during AST construction (split
the hull function and emit a `[patchconstantfunc]`), not as a raw statement.
For geometry, treat `emitStream`/`cutStream` as no-ops, and add a test that a
geometry shader with a single output stream decompiles cleanly.

### 12. `ResInfo` has no mapping (Corpus_22)

Evidence: `Corpus_22:180`
`float2 r0_xy_12 = /* TODO: no confirmed HLSL mapping for ResInfo */ _Tex2DArray.ResInfo();`

Cause: `HlslPrettyPrinter.Registers.cs:1289` has a TODO fallback for
`TextureOperation.ResInfo`.

Fix: map to `GetDimensions`:
`t.GetDimensions(w, h, layers, mips)` (the 2-component result needs a
`uint2` temp plus a `GetDimensions` statement). The IR already carries the
result width; add a dedicated statement form instead of an expression.

### 13. Stub passes from pass grouping (9 shaders)

Evidence: 24 `_StubCB` passes in
`Corpus_02, 03, 10, 14, 15, 16 UsePass Consumer, 33, 37, 44`.

Cause: `BuildVariantPasses` (`Decompiler.cs:462-590`) groups DXBC candidates
by stage regression and assigns group `gi` to metadata shell pass `gi`. With
1:1 vertex/fragment pairing it folds distinct variants that share
`(hash, hash)` and never reuses a program for a metadata pass that has no
candidate. `Corpus_02` is the extreme case: 8 metadata passes, 5 DX
candidates, 2 groups, 1 emitted pass, 7 stubs.

Fix: build the pass→candidate association from the Unity variant data
(`m_SubPrograms`/keyword variants) rather than by positional group index, and
clone a matching candidate when a shell pass has none. Until then, the stubs
at least keep pass indices stable and compile.

### 14. Interpolator declared narrower than the swizzles read (Corpus_18)

Evidence: `Corpus_18:110`
`float3 r1_xyz_1 = ((-i.sv_Position0.yzxy + i.texcoord1.yzxy)).xyz;`
while `program4Input` (`:63-68`) declares `float2 texcoord1 : TEXCOORD1;`.
`.yzxy` is not a valid swizzle on a `float2`.

Cause: the input struct field width comes from the ISGN declaration, but the
body trusts the DXBC operand swizzle. When the signature splits a semantic
into a narrower element than the shader reads (Unity often declares
`TEXCOORD1` as `float2` and reads all four lanes), the emitted field is too
narrow.

Fix: when building each input/output struct field, widen its declared type to
cover the highest component any operand reads from that register. This is a
per-register max over the IR, not a blind `float4`, so existing output stays
unchanged for well-formed signatures.

## Cross-cutting recommendations

1. **Self-check before writing the file.** Per function, verify every temp
   identifier read is declared (`PrintContext.Declared`) and every semantic
   field name used is in the input/output struct. Emit the missing
   declarations. This would have caught classes 1, 2, 3, 5, 9, 10 immediately
   and is much cheaper than chasing each emitter path.
2. **Compile gate in tests.** `tests/e2e/test_faithfulness.py` already
   recompiles; promote its per-block result into a per-shader pass/fail that
   fails CI on the corpus, so these regressions are visible on every PR.
3. **One-line dispatch audit.** Grep the `Opcode` enum against
   `IRBuilder.ConvertInstruction` and the `IRExpression` subclasses against
   `RenderExpression`; both currently have gaps (classes 1, 2, 5, 10, 11).
   A reflection test asserting every enum value has a case would prevent the
   next one.

## Reproduction

```bash
python Extract.py shaders_json/<name>.json --out-dir Output
dotnet run --project "src/UnityShaderDecompiler.Cli/UnityShaderDecompiler.Cli.csproj" -- "Output/<name>"
```

Recompile a single shader's blocks with
`python tests/e2e/test_faithfulness.py --filter <name>` (Windows +
`d3dcompiler_47.dll`), or dump DXBC with
`Shader Decompiler --disasm "Output/<name>"`.

## Open questions

- `Corpus_29` `r0_y_2` carries version 2 but has no defining statement. The
  printer self-check from recommendation 1 would make it compile, but the
  pass that drops the definition is still unidentified; it is not one of the
  what/where/why caught above. Reproduce with `--no-fuse-temps` first to tell
  `HlslFuseTemps` apart from an IR-level drop.
