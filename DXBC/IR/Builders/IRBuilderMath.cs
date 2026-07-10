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

    // ===================== trig =====================
    // Not raw DXBC opcodes — SM4/5 has no native sin/cos/tan/etc, they're
    // synthesized from sincos/exp/log sequences by the compiler. Included
    // for use once a pattern-matcher recognizes the underlying sequence and
    // wants to emit the higher-level intrinsic instead.

    private void BuildCos(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "cos");
    private void BuildSin(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "sin");
    private void BuildTan(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "tan");
    private void BuildAsin(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "asin");
    private void BuildAcos(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "acos");
    private void BuildAtan(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "atan");
    private void BuildAtan2(IRProgram program, Instruction instruction) => BuildBinaryIntrinsic(program, instruction, "atan2");

    // ===================== exponentials / rounding =====================

    private void BuildExp2(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "exp2");
    private void BuildLog2(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "log2");

    private void BuildFloor(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "floor");
    private void BuildCeil(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "ceil");
    private void BuildTrunc(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "trunc");

    private void BuildFmod(IRProgram program, Instruction instruction) => BuildBinaryIntrinsic(program, instruction, "fmod");
    private void BuildModf(IRProgram program, Instruction instruction) => BuildBinaryIntrinsic(program, instruction, "modf");
    private void BuildLdexp(IRProgram program, Instruction instruction) => BuildBinaryIntrinsic(program, instruction, "ldexp");
    private void BuildFrexp(IRProgram program, Instruction instruction) => BuildBinaryIntrinsic(program, instruction, "frexp");

    // ===================== vector / matrix geometry =====================

    private void BuildNormalize(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "normalize");
    private void BuildLength(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "length");
    private void BuildDistance(IRProgram program, Instruction instruction) => BuildBinaryIntrinsic(program, instruction, "distance");
    private void BuildCross(IRProgram program, Instruction instruction) => BuildBinaryIntrinsic(program, instruction, "cross");
    private void BuildReflect(IRProgram program, Instruction instruction) => BuildBinaryIntrinsic(program, instruction, "reflect");
    private void BuildRefract(IRProgram program, Instruction instruction) => BuildTernaryIntrinsic(program, instruction, "refract");
    private void BuildFaceForward(IRProgram program, Instruction instruction) => BuildTernaryIntrinsic(program, instruction, "faceforward");

    private void BuildTranspose(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "transpose");
    private void BuildDeterminant(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "determinant");
    private void BuildNoise(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, "noise");
}