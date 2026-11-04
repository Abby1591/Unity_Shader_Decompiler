# Restore runtime keyword selection from serialized variants

- **Bug fix:** Match serialized stage references and keyword states, retain all graphics stages in expanded mode, and preserve constant-buffer sizes.
- **Improvement:** Add opt-in runtime keyword selection with local/global scope and an exhaustive compilation manifest.

Use serialized program references and stage keyword masks to pair vertex/fragment programs. Preserve stage-only keywords and reject missing programs, unmatched states and incompatible interfaces. Keep constant-buffer sizes in extracted metadata.

Compatibility: default expanded passes also retain Geometry, Hull and Domain programs, matching their shared keyword states across the complete graphics pipeline. Default expanded mode also preserves log-and-continue after a recorded subprogram error; runtime reconstruction remains strict. Only the opt-in runtime reconstruction is restricted to vertex/fragment stages. A native geometry fixture reproduces the previous default-mode rejection and now passes; unit tests cover tessellation/geometry combinations and unmatched intermediate stages.

`--restore-keyword-variants` retains the original passes and emits keyword-controlled program branches, including local/global scope. Reconstruct only exact, complete combinations of independent or exclusive keyword sets; missing scope flags, ambiguous mappings and unsupported correlations fail explicitly. The default expanded-pass mode remains available. A hash-bound manifest lets native compilation check every recovered combination.

Validation: 78 C# tests, six Python tests and all four PicaVoxel cases pass in isolation. The prior runtime validation under Unity CLI with Editor 6000.0.75f1 and D3D11 passed nine GPU readbacks; the compatibility changes leave that opt-in path unchanged. These tests do not establish full application rendering or resource-binding equivalence. Isolated C# tests use en-US; the existing fr-FR golden issue is addressed separately in #5.
