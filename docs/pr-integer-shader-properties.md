# Preserve serialized integer shader properties

Property type 5 stores an integer payload in a serialized float slot. Emit ShaderLab `Integer` and recover the original bits instead of treating that slot as a numeric float. Missing or non-finite JSON payloads fail explicitly because they cannot recover the original value reliably.

Validation: 59 C# tests and all four PicaVoxel end-to-end cases pass, including positive values, negative zero bits, large integers and invalid payloads. The isolated suite uses en-US because upstream's fr-FR golden-output failure is addressed separately in #5. No game-specific fixtures or paths are included.
