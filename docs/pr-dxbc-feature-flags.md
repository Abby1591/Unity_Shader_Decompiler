# Read SFI0 as a 64-bit feature mask

`SFI0` is an eight-byte feature mask, not a statistics structure. Read its 64 bits and reject invalid chunk lengths. The corrected synthetic test and a native compiler fixture verify the actual format.

Validation: 53 C# tests and all four existing PicaVoxel extraction/decompilation tests pass. C# tests use an en-US default culture; the upstream fr-FR golden-output failure is addressed independently by the numeric-formatting PR.
