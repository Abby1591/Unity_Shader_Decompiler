# Preserve register bits and arithmetic in no-fuse mode

With `--no-fuse-temps`, interpreting temporary registers as numeric floats can corrupt integer moves and comparison masks. Preserve raw uint storage with typed reads and outputs; for example, `0x01000001` must remain that exact integer instead of rounding to `0x01000000`. Integer negation applies after bit interpretation, and arithmetic rewrites must not remove the addition before fractional-part evaluation.

Native round-trip tests cover `mov` and `movc` to signed and unsigned outputs, both conditional outcomes, and bit patterns representing NaNs, subnormals and signed zero. A restricted bytecode evaluator compares exact output words against explicit expectations and rejects unexpected operations. Disabling bit preservation makes all four new cases fail. These are compiler/bytecode checks, not GPU execution tests.

Validation: 58 C# tests and four PicaVoxel end-to-end cases pass on Windows. The isolated suite uses en-US because upstream's fr-FR golden-output failure is fixed separately in #5. Existing upstream assertions are unchanged.
