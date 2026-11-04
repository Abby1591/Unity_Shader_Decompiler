# Read SFI0 as a 64-bit feature mask

`SFI0` is an eight-byte feature mask, not a statistics structure. Read its 64 bits and reject invalid chunk lengths. Legacy public uint fields remain for source/binary compatibility, but are not populated by SFI0: `HasLegacyStatistics` explicitly returns false. Their default values must not be interpreted as recovered statistics; consumers should use `FeatureFlags` for this chunk.

Validation: 54 C# tests, including the native feature mask and the 35 retained public fields, and all four PicaVoxel cases pass. Isolated C# tests use en-US; the upstream fr-FR golden-output failure is addressed separately in #5.
