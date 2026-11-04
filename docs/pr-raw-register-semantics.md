# Preserve register bits and arithmetic in no-fuse mode

Keep temporary registers as raw uint bits with explicit typed reads, full-bit comparison masks and integer source modifiers applied after interpretation. Disable arithmetic pattern rewrites in no-fuse mode and preserve the addition before fractional-part evaluation under native recompilation.

Validation: 54 C# tests and all four existing PicaVoxel extraction/decompilation tests pass. C# tests use an en-US default culture; the upstream fr-FR golden-output failure is addressed independently by the numeric-formatting PR.

This branch is based directly on upstream `1850608`; it does not include the other review branches. No proprietary fixtures or machine-specific paths are added.
