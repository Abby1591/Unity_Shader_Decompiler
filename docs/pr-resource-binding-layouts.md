# Preserve resource bindings and raw constant-buffer layout

Resources with the same recovered name could collapse despite occupying different slots. Keep bindings distinct. For partially known constant buffers, emit raw storage from byte zero while preserving the serialized extent, name and binding; native reflection tests verify that layout. The variant-metadata PR must retain the `size` field consumed here.

Validation: 57 C# tests and all four existing PicaVoxel extraction/decompilation tests pass. C# tests use an en-US default culture; the upstream fr-FR golden-output failure is addressed independently by the numeric-formatting PR.
