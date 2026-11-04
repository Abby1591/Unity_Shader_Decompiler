# Read SFI0 as a 64-bit feature mask

The SFI0 reader previously treated the payload as a statistics block. Read exactly eight bytes, reject invalid lengths, and verify the feature mask against native compiler output. The existing synthetic test is corrected because its old payload represented the wrong chunk format.

Validation: 53 C# tests and all four existing PicaVoxel extraction/decompilation tests pass. C# tests use an en-US default culture; the upstream fr-FR golden-output failure is addressed independently by the numeric-formatting PR.

This branch is based directly on upstream `1850608`; it does not include the other review branches. No proprietary fixtures or machine-specific paths are added.
