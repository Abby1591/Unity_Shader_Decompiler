using System;
using System.Linq;
using Parser.Core.Hlsl;
using Parser.Core.Hlsl.Ast;
using Parser.Core.Analysis;
using Parser.Core.Optimizations;
using Parser.DXBC.Instructions;
using Parser.DXBC.IR;
using Xunit;

namespace UnityShaderDecompiler.Tests;

public sealed class ResourceBindingLayoutsTests
{
    [Fact]
    public void PartialCbufferMetadataKeepsRawRegisterOffsets()
    {
        HlslShaderNode shader = new HlslShaderNode { Name = "Test/CbufferLayout" };
        HlslSubShaderNode subShader = new HlslSubShaderNode();
        HlslPassNode pass = new HlslPassNode();
        HlslResourceNode resource = new HlslResourceNode
        {
            Name = "NamedBuffer", Kind = HlslResourceKind.ConstantBuffer, Slot = 1,
        };
        resource.Variables.Add(new HlslCBufferVariable
        {
            Name = "NamedValue", TypeName = "float4", Offset = 0, Size = 16,
        });
        resource.Variables.Add(new HlslCBufferVariable
        {
            Name = "cb1_values", TypeName = "float4", Offset = 0, Size = 32, ArraySize = 2,
        });
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

        string source = HlslPrettyPrinter.Print(shader, fuseTemps: false);
        Assert.Contains("cbuffer NamedBuffer : register(b1) { float4 cb1_values[2]; };", source);
        Assert.Contains("cb1_values[0]", source);
        Assert.DoesNotContain("NamedValue", source);
    }

    private static string Print(HlslFunctionNode function)
    {
        HlslShaderNode shader = new HlslShaderNode { Name = "Test/Scope" };
        HlslSubShaderNode subShader = new HlslSubShaderNode();
        subShader.Passes.Add(new HlslPassNode { FragmentFunction = function });
        shader.SubShaders.Add(subShader);
        return HlslPrettyPrinter.Print(shader, fuseTemps: false);
    }

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
            if ((mask & (1 << component)) != 0)
                register.SsaVersion[component] = 1;
        return register;
    }

    private static IRExpression.ConstantExpression Float(float value) => new()
    {
        RawValues = new[] { unchecked((uint)BitConverter.SingleToInt32Bits(value)) },
    };
}
