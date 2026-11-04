# Preserve resource bindings and raw constant-buffer layout

Keep resources with different slots distinct even when their recovered names coincide. When a buffer needs raw fallback storage, emit one array starting at byte zero while retaining its name, binding and declared size. Native reflection tests verify the physical buffer layout.

Validation: 57 C# tests and all four existing PicaVoxel extraction/decompilation tests pass. C# tests use an en-US default culture; the upstream fr-FR golden-output failure is addressed independently by the numeric-formatting PR.

This branch is based directly on upstream `1850608`; it does not include the other review branches. No proprietary fixtures or machine-specific paths are added.
