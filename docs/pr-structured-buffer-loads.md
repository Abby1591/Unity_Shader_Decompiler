# Preserve register bits and structured-buffer loads

Float temporary storage can corrupt integer moves and structured-buffer results. With `--no-fuse-temps`, preserve raw uint storage, typed reads and outputs, full-bit comparison masks and integer source modifiers. Keep arithmetic rewrites from removing the addition before fractional-part evaluation.

Structured loads preserve element stride, byte offset and resource swizzle independently. These changes belong together because correct addressing alone still loses integer output bits without raw register transport. Structured loads require `--no-fuse-temps`; fused mode, dynamic offsets and unaligned or out-of-range accesses fail explicitly. This PR includes the former #7; no separate dependency remains.

Saturated moves clamp the floating-point value before storing its bits. Integer reads bypass float round trips that fxc can fold to zero for known subnormals; this preserves low-bit branch conditions.

Native round trips cover signed/unsigned moves, saturation and low-bit selection, plus float/uint/int structured loads with stride, offset and swizzle. A restricted bytecode evaluator checks exact output words, including NaN payloads, subnormals and signed zero, and rejects unexpected operations. The saturation regression fails with the former implementation and passes with the fix. These are compiler/bytecode checks, not GPU execution tests.

Validation: 67 C# tests and all four PicaVoxel end-to-end cases pass on Windows. The isolated suite uses en-US because upstream's fr-FR golden-output failure is addressed separately in #5. The README documents both raw register preservation and the structured-load restriction.
