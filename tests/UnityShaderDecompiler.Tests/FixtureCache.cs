using System;
using System.Collections.Concurrent;
using System.Threading;
using Parser;

namespace UnityShaderDecompiler.Tests;

/// <summary>
/// Decompiling the larger fixtures takes a moment, so share one result across
/// all read-only assertions. Tests that need a written <c>.shader</c> create
/// their own temp output folder instead.
/// </summary>
internal static class FixtureCache
{
    private static readonly ConcurrentDictionary<string, Lazy<DecompilationResult>> Cache = new();

    public static DecompilationResult Decompile(string fixture) =>
        Cache.GetOrAdd(
            fixture,
            f => new Lazy<DecompilationResult>(
                () => Parser.Decompiler.DecompileFolder(
                    TestPaths.FixtureFolder(f),
                    new DecompileOptions { Verbose = false }),
                LazyThreadSafetyMode.ExecutionAndPublication)).Value;
}
