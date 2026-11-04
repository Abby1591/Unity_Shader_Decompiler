# Pair shader variants using serialized program references

Grouping programs by blob order can pair unrelated variants. Use serialized program indices and pair stage variants when their enabled keywords agree on the intersection of their keyword masks. Stage-only keywords remain independent: a vertex variant can therefore pair with multiple fragment-only variants. Reject missing programs and incompatible interfaces.

Preserve constant-buffer sizes in the extracted metadata, including the existing zero sentinel for a binding with no serialized extent. A Python serialization test covers both paths. Runtime keyword selection remains unimplemented: compatible combinations are still emitted as separate passes.

Validation: 54 C# tests, two Python tests and all four PicaVoxel end-to-end cases pass. The isolated C# suite uses en-US; upstream's fr-FR golden-output failure is addressed separately in #5. Regenerate shared golden references after combining emitter changes.
