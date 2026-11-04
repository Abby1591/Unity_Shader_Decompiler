using System.Linq;
using Parser;
using Parser.Core.Hlsl.Ast;

namespace UnityShaderDecompiler.Tests;

public class SamplerBindingTests
{
    [Fact]
    public void SameRecoveredNameDoesNotMergeDifferentSamplerSlots()
    {
        DecompilationResult result = FixtureCache.Decompile("HOLO_Holo");
        HlslPassNode pass = Assert.Single(result.Passes, p =>
            p.Resources.Any(r => r.Kind == HlslResourceKind.Sampler && r.Slot == 2));
        HlslResourceNode first = Assert.Single(pass.Resources,
            r => r.Kind == HlslResourceKind.Sampler && r.Slot == 0);
        HlslResourceNode second = Assert.Single(pass.Resources,
            r => r.Kind == HlslResourceKind.Sampler && r.Slot == 2);
        Assert.NotEqual(first.Name, second.Name);
        Assert.Contains("SamplerState " + second.Name, result.ShaderText);
    }
}
