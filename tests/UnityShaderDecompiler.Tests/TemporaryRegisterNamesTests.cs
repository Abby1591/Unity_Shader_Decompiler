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

// Covers temporary register names tests.
public sealed class TemporaryRegisterNamesTests
{
    // Verifies that semantic names do not merge different temporary registers.
    [Fact]
    public void SemanticNamesDoNotMergeDifferentTemporaryRegisters()
    {
        IRRegister first = Temp(1);
        IRRegister second = Temp(4);
        first.SymbolicName = "InputValue";
        second.SymbolicName = "InputValue";
        HlslFunctionNode function = new HlslFunctionNode { Name = "frag", Stage = HlslShaderStage.Fragment };
        function.Statements.Statements.Add(new HlslAssignmentStatement
        {
            Destination = first,
            Expression = Float(2),
        });
        function.Statements.Statements.Add(new HlslAssignmentStatement
        {
            Destination = second,
            Expression = Float(3),
        });
        function.Statements.Statements.Add(new HlslAssignmentStatement
        {
            Destination = Temp(5),
            Expression = new IRExpression.RegisterExpression { Register = first },
        });

        string source = Print(function);
        Assert.Contains("float InputValue_r1_x_1 = 2", source);
        Assert.Contains("float InputValue_r4_x_1 = 3", source);
        Assert.Contains("= InputValue_r1_x_1;", source);
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
