namespace UnityShaderDecompiler.Core;

// Describes an independent Unity keyword set and its scope.
internal sealed record RuntimeKeywordGroup(string[] Keywords, bool AllowsDisabled, bool Local);
