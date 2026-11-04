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

public sealed class ExplicitTextureLodTests
{
    [Fact]
    public void ExplicitZeroLodIsNotReplacedByImplicitDerivatives()
    {
        IRExpression.TextureOperationExpression sample = new IRExpression.TextureOperationExpression
        {
            Operation = IRExpression.TextureOperation.SampleLevel,
            LOD = Float(0), Coordinates = Float(1),
            Resource = new IRRegister { RegisterType = RegisterType.Resource, Index = 0 },
            Sampler = new IRRegister { RegisterType = RegisterType.Sampler, Index = 0 },
        };
        IRBlock block = new IRBlock();
        block.Statements.Add(new IRStatement.IRAssignment { Destination = Temp(0), Expression = sample });

        IRShaderPatternRecognition.Run(new() { block });

        IRStatement.IRAssignment assignment = Assert.IsType<IRStatement.IRAssignment>(block.Statements[0]);
        IRExpression.TextureOperationExpression actual = Assert.IsType<IRExpression.TextureOperationExpression>(assignment.Expression);
        Assert.Equal(IRExpression.TextureOperation.SampleLevel, actual.Operation);
        Assert.Same(sample.LOD, actual.LOD);
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
