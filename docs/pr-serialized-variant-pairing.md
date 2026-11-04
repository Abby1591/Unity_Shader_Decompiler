# Restore runtime keyword selection from serialized variants

Use serialized program references and stage keyword masks to pair vertex/fragment programs. Preserve stage-only keywords and reject missing programs, unmatched states and incompatible interfaces. Keep constant-buffer sizes in extracted metadata.

`--restore-keyword-variants` retains the original passes and emits keyword-controlled program branches, including local/global scope. Reconstruct only exact, complete combinations of independent or exclusive keyword sets; missing scope flags, ambiguous mappings and unsupported correlations fail explicitly. The default expanded-pass mode remains available. A hash-bound manifest lets native compilation check every recovered combination.

Validation: 74 C# tests, six Python tests and all four PicaVoxel cases pass in isolation. Unity CLI with Editor 6000.0.75f1 and D3D11 passes nine GPU readbacks covering pass order, material keyword changes and global/local scope. Generic Unity checks also compile every manifest state. These tests do not establish full application rendering or resource-binding equivalence. Isolated C# tests use en-US; the existing fr-FR golden issue is addressed separately in #5.
