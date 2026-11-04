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

public sealed class StructuredBufferLoadsTests
{
    [Theory]
    [InlineData("float")]
    [InlineData("uint")]
    [InlineData("int")]
    [Trait("Category", "D3D")]
    public void StructuredLoadPreservesWordsThroughNativeRoundTrip(string type)
    {
        if (!OperatingSystem.IsWindows()) return;

        string source = $"struct Element {{ uint4 padding; {type}4 value; }}; " +
            $"StructuredBuffer<Element> data : register(t7); " +
            $"{type}4 main(nointerpolation uint index : TEXCOORD0) : SV_Target " +
            "{ return data[index].value.zxyw; }";
        Parser.DXBC.DxbcFile original = RegisterRoundTrip.Compile(source);
        Assert.Contains(original.Shader!.Instructions, instruction => instruction.Opcode == Opcode.LdStructured);
        Parser.DXBC.DxbcFile rebuilt = RegisterRoundTrip.Recompile(original);
        Assert.Equal(original.OutputSignature!.Elements[0].ComponentType,
            rebuilt.OutputSignature!.Elements[0].ComponentType);
        uint[] words = {
            11, 12, 13, 14, 0xffffffffu, 0x7fc12345u, 1, 0x80000000u,
            21, 22, 23, 24, 0x01000001u, 0xffc54321u, 0x7fffffffu, 0x80000001u,
        };
        for (uint index = 0; index < 2; index++)
        {
            uint[] input = { index, 0, 0, 0 };
            int offset = checked((int)index * 8 + 4);
            uint[] expected = { words[offset + 2], words[offset], words[offset + 1], words[offset + 3] };
            Assert.Equal(expected, RegisterRoundTrip.Evaluate(original, input, words));
            Assert.Equal(expected, RegisterRoundTrip.Evaluate(rebuilt, input, words));
        }
    }

    [Theory]
    [InlineData(4u, 32u, true)]
    [InlineData(2u, 32u, false)]
    [InlineData(32u, 32u, false)]
    public void StructuredLoadUsesByteOffsetAndResourceSwizzle(uint offset, uint stride, bool valid)
    {
        IRRegister resource = new()
        {
            RegisterType = RegisterType.Resource, Index = 7,
            ComponentMode = Operand.OperandComponentMode.Swizzle,
            Swizzle = 2 | (0 << 2) | (1 << 4) | (3 << 6),
        };
        HlslFunctionNode function = new() { Name = "frag", Stage = HlslShaderStage.Fragment };
        function.Statements.Statements.Add(new HlslAssignmentStatement
        {
            Destination = Temp(0, 3),
            Expression = new IRExpression.TextureOperationExpression
            {
                Operation = IRExpression.TextureOperation.LoadStructured,
                Resource = resource, StructuredStride = stride, DestinationMask = 3,
                Coordinates = new IRExpression.ConstantExpression
                {
                    Kind = IRExpression.ConstantExpression.ConstantKind.UInt, RawValues = new uint[] { 5 },
                },
                Offset = new IRExpression.ConstantExpression
                {
                    Kind = IRExpression.ConstantExpression.ConstantKind.UInt, RawValues = new uint[] { offset },
                },
            },
        });
        if (valid)
        {
            string source = Print(function);
            Assert.Contains("t7[5].value[3], t7[5].value[1]", source);
        }
        else
        {
            Assert.Throws<System.IO.InvalidDataException>(() => Print(function));
        }
    }

    [Fact]
    public void StructuredBufferDeclarationUsesItsActualStride()
    {
        HlslShaderNode shader = new HlslShaderNode { Name = "Test/Structured" };
        HlslSubShaderNode subShader = new HlslSubShaderNode();
        HlslPassNode pass = new HlslPassNode();
        pass.Resources.Add(new HlslResourceNode
        {
            Name = "t7", Kind = HlslResourceKind.Texture, Slot = 7,
            TypeHint = "StructuredBuffer", StructureStride = 32,
        });
        subShader.Passes.Add(pass);
        shader.SubShaders.Add(subShader);

        string source = HlslPrettyPrinter.Print(shader, fuseTemps: false);
        Assert.Contains("uint value[8];", source);
        Assert.Contains("StructuredBuffer<t7_element> t7", source);
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
