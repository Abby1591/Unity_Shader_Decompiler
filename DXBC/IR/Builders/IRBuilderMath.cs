using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public partial class IRBuilder
{
    // ===================== dot products =====================

    private void BuildDp2(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.DotProductExpression
            {
                Left = BuildExpression(instruction.Operands[1]),
                Right = BuildExpression(instruction.Operands[2]),
                Components = 2
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildDp3(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.DotProductExpression
            {
                Left = BuildExpression(instruction.Operands[1]),
                Right = BuildExpression(instruction.Operands[2]),
                Components = 3
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildDp4(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.DotProductExpression
            {
                Left = BuildExpression(instruction.Operands[1]),
                Right = BuildExpression(instruction.Operands[2]),
                Components = 4
            };

        AddAssignment(program, destination, expression);
    }

    // ===================== roots / exponentials =====================

    private void BuildSqrt(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "sqrt",
                Arguments = { BuildExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildRsqrt(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "rsqrt",
                Arguments = { BuildExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildExp(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "exp2",
                Arguments = { BuildExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildLog(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "log2",
                Arguments = { BuildExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildPow(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "pow",
                Arguments =
                {
                    BuildExpression(instruction.Operands[1]),
                    BuildExpression(instruction.Operands[2])
                }
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildFrac(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "frac",
                Arguments = { BuildExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildRcp(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "rcp",
                Arguments = { BuildExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }

    // ===================== rounding =====================

    // round_ne: round to nearest even
    private void BuildRoundNE(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "round",
                Arguments = { BuildExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }

    // round_ni: round toward negative infinity (floor)
    private void BuildRoundNI(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "floor",
                Arguments = { BuildExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }

    // round_pi: round toward positive infinity (ceil)
    private void BuildRoundPI(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "ceil",
                Arguments = { BuildExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }

    // round_z: round toward zero (truncate)
    private void BuildRoundZ(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "trunc",
                Arguments = { BuildExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }

    // ===================== saturate =====================

    private void BuildSaturate(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "saturate",
                Arguments = { BuildExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }

    // ===================== fma =====================

    private void BuildFma(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.Add,

                Left =
                    new IRExpression.BinaryExpression
                    {
                        Operation = IRExpression.BinaryOperation.Multiply,
                        Left = BuildExpression(instruction.Operands[1]),
                        Right = BuildExpression(instruction.Operands[2])
                    },

                Right = BuildExpression(instruction.Operands[3])
            };

        AddAssignment(program, destination, expression);
    }
}