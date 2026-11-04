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

public sealed class ConditionalValueScopeTests
{
    [Fact]
    public void PhiCopyAfterNestedConditionalRunsAfterBothBranches()
    {
        IRBlock left = new IRBlock { Id = 0 };
        IRBlock right = new IRBlock { Id = 1 };
        IRBlock join = new IRBlock { Id = 2 };
        join.Statements.Add(new IRStatement.IREndIf());
        join.Predecessors.AddRange(new[] { left, right });
        IRBlock next = new IRBlock { Id = 3 };
        next.Predecessors.Add(join);
        IRStatement.IRPhi phi = new IRStatement.IRPhi { Destination = Temp(2) };
        phi.Operands.Add(Temp(1));
        next.Statements.Add(phi);

        IRLeaveSsa.Run(new() { left, right, join, next });

        Assert.Empty(left.Statements);
        Assert.Empty(right.Statements);
        Assert.IsType<IRStatement.IREndIf>(join.Statements[0]);
        Assert.IsType<IRStatement.IRAssignment>(join.Statements[1]);
    }

    [Fact]
    public void ValueWrittenInOnlyOneBranchIsDeclaredOutsideTheIf()
    {
        // A value written in one branch and read after the if must be
        // declared outside the branch to avoid HLSL X3004.
        IRRegister value = Temp(0);
        IRRegister merged = Temp(1);
        HlslIfStatement branch = new HlslIfStatement
        {
            Condition = Float(1),
            Then = new HlslBlockStatement(),
            Else = new HlslBlockStatement(),
        };
        branch.Then.Statements.Add(new HlslAssignmentStatement
        {
            Destination = merged,
            Expression = Float(2),
        });
        branch.Else.Statements.Add(new HlslAssignmentStatement
        {
            Destination = value,
            Expression = Float(3),
        });
        branch.Else.Statements.Add(new HlslAssignmentStatement
        {
            Destination = merged,
            Expression = new IRExpression.RegisterExpression { Register = value },
        });

        HlslFunctionNode function = new HlslFunctionNode { Name = "frag", Stage = HlslShaderStage.Fragment };
        function.Statements.Statements.Add(branch);
        function.Statements.Statements.Add(new HlslAssignmentStatement
        {
            Destination = Temp(2),
            Expression = new IRExpression.RegisterExpression { Register = value },
        });

        string source = Print(function);
        int declaration = source.IndexOf("float r0_x_1;", StringComparison.Ordinal);
        int ifStart = source.IndexOf("if (", StringComparison.Ordinal);
        Assert.True(declaration >= 0 && declaration < ifStart, source);
        Assert.Contains("r0_x_1 = 3", source);
        Assert.DoesNotContain("float r0_x_1 = 3", source);
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
