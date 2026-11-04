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

public sealed class VectorExpressionWidthsTests
{
    [Fact]
    public void NormalizeSimplificationKeepsTheDotProductLanes()
    {
        string body = "float lengthSquared = dot(cb1_values[5].xyz, cb1_values[5].xyz);\n"
            + "float inverseLength = rsqrt(lengthSquared);\n"
            + "float3 result = ((inverseLength.xxxx * cb1_values[5].xyzx)).xyz;\n";

        string simplified = HlslMathSimplify.Simplify(body);
        Assert.Matches(@"normalize\(cb1_values\s*\[5\]\.xyz\)", simplified);
        Assert.DoesNotMatch(@"normalize\(cb1_values\s*\[5\]\)", simplified);
    }

    [Fact]
    public void ThreeComponentDotDoesNotReadTheFourthLane()
    {
        HlslFunctionNode function = new HlslFunctionNode { Name = "frag", Stage = HlslShaderStage.Fragment };
        function.Statements.Statements.Add(new HlslAssignmentStatement
        {
            Destination = Temp(2),
            Expression = new IRExpression.DotProductExpression
            {
                Components = 3,
                Left = new IRExpression.RegisterExpression { Register = Temp(0, 15) },
                Right = new IRExpression.RegisterExpression { Register = Temp(1, 15) },
            },
        });

        string source = Print(function);
        Assert.Matches(@"dot\(\(.+\)\.xyz, \(.+\)\.xyz\)", source);
    }

    [Fact]
    public void VectorCastPreservesWidthForComponentAccess()
    {
        // A scalar cast followed by vector component access causes HLSL
        // X3018 (invalid subscript).
        IRRegister sourceRegister = Temp(0, 15);
        IRExpression.IntrinsicExpression cast = new IRExpression.IntrinsicExpression
        {
            Intrinsic = IRExpression.IRIntrinsic.CastFloat,
        };
        cast.Arguments.Add(new IRExpression.RegisterExpression { Register = sourceRegister });
        HlslFunctionNode function = new HlslFunctionNode { Name = "frag", Stage = HlslShaderStage.Fragment };
        function.Statements.Statements.Add(new HlslAssignmentStatement
        {
            Destination = Temp(1, 15),
            Expression = cast,
        });

        string source = Print(function);
        Assert.Contains("(float4)", source);
        Assert.DoesNotContain("(float)r0_xyzw_1", source);
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
