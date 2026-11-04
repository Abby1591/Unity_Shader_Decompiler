# Preserve structured resource strides and load offsets

Represent structured resources with their declared stride and lower structured loads using the element index, byte offset and resource swizzle. Reject invalid strides and offsets instead of guessing a layout.

Validation: 55 C# tests and all four existing PicaVoxel extraction/decompilation tests pass. C# tests use an en-US default culture; the upstream fr-FR golden-output failure is addressed independently by the numeric-formatting PR.

This branch is based directly on upstream `1850608`; it does not include the other review branches. No proprietary fixtures or machine-specific paths are added.
