# Propagate DirectX subprogram decompilation failures

A corrupt DirectX subprogram was logged and omitted while the export continued. Abort with the subprogram index and original exception, and leave no final shader. This production fix is absent from upstream `1850608`; its presence on a local master branch does not make this PR redundant.

Validation: 53 C# tests and all four existing PicaVoxel extraction/decompilation tests pass. C# tests use an en-US default culture; the upstream fr-FR golden-output failure is addressed independently by the numeric-formatting PR.
