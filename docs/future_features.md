# Future features

Design notes for work that is deliberately deferred. Each item describes the
problem, the intended approach, and what would have to be true before it can be
considered done. Nothing here is scheduled.

## Full surface-shader dataflow reconstruction

### Why

`HlslSurfaceShaderRecognizer` currently rebuilds a `#pragma surface` shader
from features that survive compilation: properties, texture declarations, UV
transforms in the vertex pass, and the surface outputs visible in the deferred
G-buffer. The `surf()` body is emitted from a small set of known templates, so
it is readable but approximate. It cannot recover:

- a `surf()` line whose result is optimized away (dead stores, `* 0.0` terms),
- an expression whose operands are re-associated or folded into constants,
- original variable names, comments and statement order,
- vertex modifiers, `finalcolor`, tessellation, and custom lighting functions,
- the original `#pragma surface` options (grouping, `exclude_path`, `noforwardadd`).

The goal of full reconstruction is to derive `surf()` from the pass dataflow
instead of from templates, so the emitted source is the same program the
compiled passes implement (up to naming), not merely a plausible one.

### Approach

1. **Build a per-pass expression graph.** The decompiler already parses each
   DXBC program into `IRBlock`/`IRStatement` SSA form. Run a symbolic
   interpretation over the fragment and vertex programs that produces an
   expression DAG: leaves are cbuffer reads, texture samples, interpolator
   reads, constants and literals; nodes are the arithmetic/opcode operations.

2. **Map interpolators to surface inputs.** The vertex program writes each
   interpolator from either `appdata_full` fields or a texture's `_ST`
   transform. Follow that assignment back to `position0`/`normal0`/`tangent0`/
   `color0`/`texcoordN` and emit the corresponding `Input` field:
   `uv_MainTex`, `uv2_LightMap`, `worldPos`, `viewDir`, and so on. Where the
   compiled code has already folded the transform, recover the property name
   from the `_ST` cbuffer member; when it is absent, fall back to
   `uv_TexName` and record the guess.

3. **Recover surface outputs.** For each MRT target in the deferred pass,
   evaluate the DAG with a symbolic "what is being written" analysis:
   - `sv_Target0.rgb` is `Albedo` (divide out Unity's `(1 - metallic)` bias
     where present), `.w` is `Occlusion` (Unity writes `1` when unused);
   - `sv_Target1.rgb` is `Specular`/`Metallic` depending on the lighting
     model, `.w` is `Smoothness`;
   - `sv_Target2` is the packed world normal, so re-express it as
     `UnpackNormal(tex2D(_BumpMap, ...))` and drop the octahedral encoding;
   - `sv_Target3.rgb` is `Emission`.
   For forward-only shaders, recover the same facts from the lit fragment:
   invert the lighting model where the BRDF is invertible, otherwise match the
   dataflow against known lighting templates and extract the arguments
   (`albedo`, `normal`, `specular`, `gloss`) from the matched subgraph.

4. **Recover the rest of the surface program.** The same DAG walk over the
   other passes gives:
   - `vert`: writes to `SV_Position`/interpolators that are not pure texture
     transforms (displacement, UV scroll, colour forwarding);
   - `finalColor`: post-lighting writes to `SV_Target`, grouped by the
     interpolators they read;
   - `tessellate` + `tessphong` + the displacement vertex function: recover
     the factor expression and the vertex-position expression;
   - custom `Lighting<Name>`: reconstruct the lighting expression from the
     forward-add pass's `_LightColor0` chain and recover the function name from
     the `#pragma surface` line only if the blob ever carries it (it does not,
     so synthesise a stable name and document the change).

5. **Emit, then verify by re-expansion.** Reconstruct `#pragma surface`,
   `Input`, `surf`, `vert`, `finalColor` and `Lighting<Name>` from the graphs.
   To validate, expand the reconstructed surface source the way Unity does
   (the expansion is deterministic and documented in `UnityCG.cginc` /
   `Lighting.cginc`) and compare the resulting fragment/vertex expressions
   against the original pass DAGs, normalised for commutativity and constant
   folding. Mismatches indicate a wrong extraction, not an unrecoverable
   source line, and should fail the fidelity test instead of silently emitting
   a different program.

### Validation

- **Structural equivalence:** every surface output expression emitted must be
  present in the corresponding pass DAG (same operands, same operations). 
- **Re-expansion:** regenerate Unity's pass set from the reconstructed surface
  source with a small in-repo expander, then compare the expanded HLSL
  signatures and dataflow with the shipped passes.
- **Round-trip compile:** compile the reconstructed `CGPROGRAM` with Unity's
  shader compiler in a CI job that has an Editor installed, or compile the
  expanded pass set with `d3dcompiler_47` (already available in the D3D test
  tier).
- **Names are not part of the contract:** tests compare expressions and
  signatures, not identifiers or comments.

### Known limits

- Dead stores and constants folded out of the pass cannot be recovered; a
  reconstructed `surf` is semantically equivalent but not line-identical.
- Original names, comments, blank lines and statement order are lost. The
  emitter will use canonical names (`surf`, `Input`, `_MainTex`) and a stable
  naming scheme for recovered locals.
- UV set recovery depends on the vertex pass retaining the `_ST` transform.
  Shaders that sample with a literal UV or a procedural coordinate fall back
  to `uv_<Tex>` and must be flagged in the output.
- Custom lighting functions, tessellation and `finalcolor` are only recovered
  when their pass dataflow is distinguishable from the base lighting model;
  otherwise the recognizer should stop emitting the reconstructed surface form
  and leave the compiled passes in place rather than guess.
- The `#pragma surface` option list is not serialized. `exclude_path:deferred`
  and `addshadow` can be inferred from the pass set; `noforwardadd` and the
  original `#pragma` grouping cannot.

### Prerequisites

- A symbolic evaluator over `IRBlock` that can build and simplify expression
  DAGs without losing texture/sampler identity.
- A model of Unity's surface expansion (the templates in `Lighting.cginc`)
  used only for validation, not for emission.
- A golden corpus with expected reconstructed sources, so a dataflow change
  that alters output is visible as a diff rather than only as a compile pass.
