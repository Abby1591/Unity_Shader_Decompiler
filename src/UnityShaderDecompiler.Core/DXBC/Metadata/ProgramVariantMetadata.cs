namespace UnityShaderDecompiler.Core.DXBC.Metadata;

// Covers program variant metadata.
public sealed record ProgramVariantMetadata(int BlobIndex, string Stage, string[] Keywords, string[] KeywordMask);
