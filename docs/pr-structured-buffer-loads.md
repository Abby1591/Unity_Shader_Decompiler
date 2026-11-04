# Preserve structured resource strides and load offsets

Structured loads previously combined the element index with a byte offset and assumed a fixed element layout. Preserve the declared stride, the byte offset and the resource swizzle independently; reject unaligned or out-of-range accesses.

Depends on #7 (`fix/raw-register-semantics`), now included in this branch. Native tests exposed numeric float-to-integer conversions in the standalone version: raw register transport is required to preserve integer output bits. Review the structured-load changes against that branch, and merge #7 first.

Three native round trips cover float, uint and int outputs, a 32-byte stride, a nonzero member offset, swizzling and two elements. A restricted bytecode evaluator checks exact words, including NaN payloads, subnormals and signed zero; unexpected conversions fail. The integer cases fail without #7 and pass with it. These checks use `fuseTemps: false`; they do not establish fused-mode or GPU execution equivalence.

Validation: 65 C# tests and all four PicaVoxel end-to-end cases pass on Windows. The isolated suite uses en-US because upstream's fr-FR golden-output failure is addressed separately in #5.
