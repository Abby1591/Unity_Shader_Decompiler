using System;
using System.Linq;
using System.Text.RegularExpressions;
using UnityShaderDecompiler.Core;
using UnityShaderDecompiler.Core.Hlsl.Ast;
using UnityShaderDecompiler.Core.DXBC;
using UnityShaderDecompiler.Core.DXBC.Chunks;

namespace UnityShaderDecompiler.Tests;

// Covers cbuffer emission tests.
public class CbufferEmissionTests
{
    // Verifies that partial layout preserves buffer identity and raw byte offsets.
    [Theory]
    [InlineData("MaterialParameters", "MaterialParameters")]
    [InlineData("_Globals", "_GlobalsCB_b1")]
    [Trait("Category", "D3D")]
    public void PartialLayoutPreservesBufferIdentityAndRawByteOffsets(string name, string emittedName)
    {
        if (!OperatingSystem.IsWindows())
        {
            return;
        }

        HlslShaderNode shader = CreatePartialShader(name);
        string text = HlslPrettyPrinter.Print(shader, fuseTemps: false);
        string declaration = Regex.Match(text, @"cbuffer\b.*?};", RegexOptions.Singleline).Value;
        Assert.NotEmpty(declaration);
        string source = declaration + "\nfloat4 main() : SV_Target { return cb1_values[1]; }";
        DxbcFile compiled = new();
        compiled.Load(UnityShaderDecompiler.Core.DXBC.Compilation.DxbcCompiler.Compile(source, "main", "ps_5_0"));

        RdefConstantBuffer reflected = Assert.Single(compiled.ResourceDefinition!.ConstantBuffers);
        Assert.Equal(emittedName, reflected.Name);
        RdefVariable storage = Assert.Single(reflected.Variables);
        Assert.Equal("cb1_values", storage.Name);
        Assert.Equal(0u, storage.Offset);
        Assert.Equal(32u, storage.Size);
        Assert.Equal(32u, reflected.Size);
        Assert.Equal(1u, compiled.ResourceDefinition.ResourceBindings.Single(b => b.Name == emittedName).BindPoint);
    }

    // Builds a shader with overlapping named and raw constant-buffer entries.
    private static HlslShaderNode CreatePartialShader(string name)
    {
        HlslShaderNode shader = new() { Name = "Test/PartialLayout" };
        HlslSubShaderNode subShader = new();
        HlslPassNode pass = new()
        {
            FragmentFunction = new HlslFunctionNode { Name = "frag", Stage = HlslShaderStage.Fragment },
        };
        HlslResourceNode buffer = new()
        {
            Name = name,
            Kind = HlslResourceKind.ConstantBuffer,
            Slot = 1,
        };
        buffer.Variables.Add(new HlslCBufferVariable
        {
            Name = "KnownMember",
            TypeName = "float4",
            Offset = 16,
            Size = 16,
        });
        buffer.Variables.Add(new HlslCBufferVariable
        {
            Name = "cb1_values",
            TypeName = "float4",
            Offset = 0,
            Size = 32,
            ArraySize = 2,
        });
        pass.Resources.Add(buffer);
        subShader.Passes.Add(pass);
        shader.SubShaders.Add(subShader);
        return shader;
    }
}
