# Propagate DirectX subprogram decompilation failures

A corrupt DirectX subprogram is logged and omitted by default. Opt in with `--fail-on-error` (API: `DecompileOptions.FailOnError = true`) to abort with the subprogram index and original exception, before writing the final shader. Existing commands and API calls retain their default behavior.

Validation: 55 C# tests cover both failure policies; all four existing PicaVoxel extraction/decompilation tests pass. Isolated C# tests use en-US; the upstream fr-FR golden-output failure is addressed separately in #5.
