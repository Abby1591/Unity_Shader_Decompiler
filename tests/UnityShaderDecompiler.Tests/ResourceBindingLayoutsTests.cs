using System;
using System.Linq;
using UnityShaderDecompiler.Core.Hlsl;
using UnityShaderDecompiler.Core.Hlsl.Ast;
using UnityShaderDecompiler.Core.Analysis;
using UnityShaderDecompiler.Core.Optimizations;
using UnityShaderDecompiler.Core.DXBC.Instructions;
using UnityShaderDecompiler.Core.DXBC.IR;
using Xunit;

namespace UnityShaderDecompiler.Tests;

// Covers resource binding layouts tests.
public sealed class ResourceBindingLayoutsTests
{
    // Verifies that partial cbuffer metadata keeps raw register offsets.
    [Fact]
    public void PartialCbufferMetadataKeepsRawRegisterOffsets()
    {
        HlslShaderNode shader = CreatePartialShader();
        string source = HlslPrettyPrinter.Print(shader, fuseTemps: false);
        Assert.Contains("cbuffer NamedBuffer : register(b1) { float4 cb1_values[2]; };", source);
        Assert.Contains("cb1_values[0]", source);
        Assert.DoesNotContain("NamedValue", source);
    }

    // Wraps the fixture function in a shader and emits its HLSL.
    private static string Print(HlslFunctionNode function)
    {
        HlslShaderNode shader = new HlslShaderNode { Name = "Test/Scope" };
        HlslSubShaderNode subShader = new HlslSubShaderNode();
        subShader.Passes.Add(new HlslPassNode { FragmentFunction = function });
        shader.SubShaders.Add(subShader);
        return HlslPrettyPrinter.Print(shader, fuseTemps: false);
    }

    // Creates a temporary register with the requested index and lane mask.
    private static IRRegister Temp(uint index, byte mask = 1)
    {
        IRRegister register = new IRRegister
        {
            RegisterType = RegisterType.Temp,
            Index = index,
            Type = IRValueType.Float,
            Mask = mask,
            ComponentMode = Operand.OperandComponentMode.Mask,
        };
        for (int component = 0; component < 4; component++)
        {
            if ((mask & (1 << component)) != 0)
            {
                register.SsaVersion[component] = 1;
            }
        }
        return register;
    }

    // Creates a scalar floating-point constant for the fixture.
    private static IRExpression.ConstantExpression Float(float value) => new()
    {
        RawValues = new[] { unchecked((uint)BitConverter.SingleToInt32Bits(value)) },
    };

    // Builds a shader that reads raw storage from a partially described buffer.
    private static HlslShaderNode CreatePartialShader()
    {
        HlslShaderNode shader = new HlslShaderNode { Name = "Test/CbufferLayout" };
        HlslSubShaderNode subShader = new HlslSubShaderNode();
        HlslPassNode pass = new HlslPassNode();
        HlslResourceNode resource = CreatePartialBuffer();
        pass.Resources.Add(resource);
        IRRegister read = new IRRegister
        {
            RegisterType = RegisterType.ConstantBuffer,
            Type = IRValueType.Float,
            Mask = 15,
            ComponentMode = Operand.OperandComponentMode.Mask,
        };
        read.Indices.Add(1);
        read.Indices.Add(0);
        HlslFunctionNode function = new HlslFunctionNode { Name = "frag", Stage = HlslShaderStage.Fragment };
        function.Statements.Statements.Add(new HlslAssignmentStatement
        {
            Destination = Temp(0, 15),
            Expression = new IRExpression.RegisterExpression { Register = read },
        });
        pass.FragmentFunction = function;
        subShader.Passes.Add(pass);
        shader.SubShaders.Add(subShader);
        return shader;
    }

    // Creates overlapping named and raw entries for a partial buffer.
    private static HlslResourceNode CreatePartialBuffer()
    {
        HlslResourceNode resource = new HlslResourceNode
        {
            Name = "NamedBuffer",
            Kind = HlslResourceKind.ConstantBuffer,
            Slot = 1,
        };
        resource.Variables.Add(new HlslCBufferVariable
        {
            Name = "NamedValue",
            TypeName = "float4",
            Offset = 0,
            Size = 16,
        });
        resource.Variables.Add(new HlslCBufferVariable
        {
            Name = "cb1_values",
            TypeName = "float4",
            Offset = 0,
            Size = 32,
            ArraySize = 2,
        });
        return resource;
    }
}
