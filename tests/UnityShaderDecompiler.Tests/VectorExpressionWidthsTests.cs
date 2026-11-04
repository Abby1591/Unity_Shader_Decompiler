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

// Covers vector expression widths tests.
public sealed class VectorExpressionWidthsTests
{
    // Verifies that normalize simplification keeps the dot product lanes.
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

    // Verifies that three component dot does not read the fourth lane.
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

    // Verifies that vector cast preserves width for component access.
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
}
