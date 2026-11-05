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
    // Rejects overlapping raw storage instead of discarding the named member.
    [Theory]
    [InlineData("MaterialParameters")]
    [InlineData("_Globals")]
    public void PartialLayoutCannotReplaceKnownMembers(string name)
    {
        HlslShaderNode shader = CreatePartialShader(name);
        InvalidDataException error = Assert.Throws<InvalidDataException>(() =>
            HlslPrettyPrinter.Print(shader, fuseTemps: false));
        Assert.Contains("Conflicting member layouts", error.Message);
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
