# Pair shader variants using serialized program references

Use serialized indices and stage keyword masks to pair vertex and fragment programs, including vertex reuse for fragment-only keywords. Reject missing programs and incompatible stage interfaces. This preserves the existing expansion into separate passes; it does not implement runtime keyword selection.

Validation: 54 C# tests and all four existing PicaVoxel extraction/decompilation tests pass. C# tests use an en-US default culture; the upstream fr-FR golden-output failure is addressed independently by the numeric-formatting PR. 1 Python tests also pass.

This branch is based directly on upstream `1850608`; it does not include the other review branches. No proprietary fixtures or machine-specific paths are added.
