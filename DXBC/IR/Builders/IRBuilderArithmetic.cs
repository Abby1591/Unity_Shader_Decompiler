using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public partial class IRBuilder
{
    // ===================== mov / movc =====================

    private void BuildMov(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);
        IRExpression expression = BuildExpression(instruction.Operands[1]);
        AddAssignment(program, destination, expression);
    }

    private void BuildMovC(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.ConditionalExpression
            {
                Condition = BuildBoolExpression(instruction.Operands[1]),
                TrueExpression = BuildExpression(instruction.Operands[2]),
                FalseExpression = BuildExpression(instruction.Operands[3])
            };

        AddAssignment(program, destination, expression);
    }

    // ===================== add / sub =====================

    private void BuildAdd(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.Add,
                Left = BuildExpression(instruction.Operands[1]),
                Right = BuildExpression(instruction.Operands[2])
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildIAdd(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.Add,
                Left = BuildIntExpression(instruction.Operands[1]),
                Right = BuildIntExpression(instruction.Operands[2])
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildSub(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.Subtract,
                Left = BuildExpression(instruction.Operands[1]),
                Right = BuildExpression(instruction.Operands[2])
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildISub(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.Subtract,
                Left = BuildIntExpression(instruction.Operands[1]),
                Right = BuildIntExpression(instruction.Operands[2])
            };

        AddAssignment(program, destination, expression);
    }

    // ===================== mul / div =====================

    private void BuildMul(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.Multiply,
                Left = BuildExpression(instruction.Operands[1]),
                Right = BuildExpression(instruction.Operands[2])
            };

        AddAssignment(program, destination, expression);
    }

    // imul dest_hi, dest_lo, src0, src1 — OperandCount=4 in ShdrParser's
    // OpcodeTable confirms this is a real two-destination instruction (32x32
    // multiply producing a 64-bit result split across two registers), not a
    // single-destination multiply. Either destination may be the "null"
    // register if the caller only wants one half.
    private void BuildIMul(IRProgram program, Instruction instruction)
    {
        var destinationHi = BuildRegister(instruction.Operands[0]);
        var destinationLo = BuildRegister(instruction.Operands[1]);

        IRExpression left = BuildIntExpression(instruction.Operands[2]);
        IRExpression right = BuildIntExpression(instruction.Operands[3]);

        var multiply = new IRExpression.BinaryExpression
        {
            Operation = IRExpression.BinaryOperation.Multiply,
            Left = left,
            Right = right
        };

        var statement = new IRStatement.IRMultiAssignment();

        statement.Destinations.Add(destinationHi.RegisterType == RegisterType.Null ? null : destinationHi);
        statement.Expressions.Add(new IRExpression.IntrinsicExpression { Name = "imul_hi", Arguments = { left, right } });

        statement.Destinations.Add(destinationLo.RegisterType == RegisterType.Null ? null : destinationLo);
        statement.Expressions.Add(multiply);

        program.Statements.Add(statement);
    }

    private void BuildUMul(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.Multiply,
                Left = BuildUIntExpression(instruction.Operands[1]),
                Right = BuildUIntExpression(instruction.Operands[2])
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildDiv(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.Divide,
                Left = BuildExpression(instruction.Operands[1]),
                Right = BuildExpression(instruction.Operands[2])
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildUDiv(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.Divide,
                Left = BuildUIntExpression(instruction.Operands[1]),
                Right = BuildUIntExpression(instruction.Operands[2])
            };

        AddAssignment(program, destination, expression);
    }

    // Real DXBC udiv is udiv dest_quot, dest_rem, src0, src1 (4 operands) —
    // same multi-destination shape as imul. Not wired into ConvertInstruction
    // yet since udiv has no OpcodeTable entry to confirm the operand order
    // against; BuildUDiv above stays as the single-output simplification
    // until then. Use this once confirmed.
    private void BuildUDivQuotientRemainder(IRProgram program, Instruction instruction)
    {
        var destinationQuotient = BuildRegister(instruction.Operands[0]);
        var destinationRemainder = BuildRegister(instruction.Operands[1]);

        IRExpression left = BuildUIntExpression(instruction.Operands[2]);
        IRExpression right = BuildUIntExpression(instruction.Operands[3]);

        var statement = new IRStatement.IRMultiAssignment();

        statement.Destinations.Add(destinationQuotient.RegisterType == RegisterType.Null ? null : destinationQuotient);
        statement.Expressions.Add(new IRExpression.BinaryExpression
        {
            Operation = IRExpression.BinaryOperation.Divide,
            Left = left,
            Right = right
        });

        statement.Destinations.Add(destinationRemainder.RegisterType == RegisterType.Null ? null : destinationRemainder);
        statement.Expressions.Add(new IRExpression.IntrinsicExpression { Name = "umod", Arguments = { left, right } });

        program.Statements.Add(statement);
    }

    // ===================== mad / imad =====================

    private void BuildMad(IRProgram program, Instruction instruction)
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

    private void BuildIMad(IRProgram program, Instruction instruction)
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
                        Left = BuildIntExpression(instruction.Operands[1]),
                        Right = BuildIntExpression(instruction.Operands[2])
                    },

                Right = BuildIntExpression(instruction.Operands[3])
            };

        AddAssignment(program, destination, expression);
    }

    // ===================== min / max =====================

    private void BuildMin(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "min",
                Arguments =
                {
                    BuildExpression(instruction.Operands[1]),
                    BuildExpression(instruction.Operands[2])
                }
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildMax(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "max",
                Arguments =
                {
                    BuildExpression(instruction.Operands[1]),
                    BuildExpression(instruction.Operands[2])
                }
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildIMin(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "min",
                Arguments =
                {
                    BuildIntExpression(instruction.Operands[1]),
                    BuildIntExpression(instruction.Operands[2])
                }
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildIMax(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "max",
                Arguments =
                {
                    BuildIntExpression(instruction.Operands[1]),
                    BuildIntExpression(instruction.Operands[2])
                }
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildUMin(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "min",
                Arguments =
                {
                    BuildUIntExpression(instruction.Operands[1]),
                    BuildUIntExpression(instruction.Operands[2])
                }
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildUMax(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "max",
                Arguments =
                {
                    BuildUIntExpression(instruction.Operands[1]),
                    BuildUIntExpression(instruction.Operands[2])
                }
            };

        AddAssignment(program, destination, expression);
    }

    // ===================== neg / abs =====================

    private void BuildNeg(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.UnaryExpression
            {
                Operation = IRExpression.UnaryExpression.UnaryOperation.Negate,
                Operand = BuildExpression(instruction.Operands[1])
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildAbs(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.UnaryExpression
            {
                Operation = IRExpression.UnaryExpression.UnaryOperation.Absolute,
                Operand = BuildExpression(instruction.Operands[1])
            };

        AddAssignment(program, destination, expression);
    }

    // ===================== lrp / dp2add / msad / dst =====================

    private void BuildLrp(IRProgram program, Instruction instruction) => BuildTernaryIntrinsic(program, instruction, "lerp");

    // dp2add: dot(a.xy, b.xy) + c
    private void BuildDp2Add(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.Add,
                Left = new IRExpression.DotProductExpression
                {
                    Left = BuildExpression(instruction.Operands[1]),
                    Right = BuildExpression(instruction.Operands[2]),
                    Components = 2
                },
                Right = BuildExpression(instruction.Operands[3])
            };

        AddAssignment(program, destination, expression);
    }

    // msad: masked sum-of-absolute-differences (used for texture-space skinning/video codecs)
    private void BuildMSad(IRProgram program, Instruction instruction) => BuildTernaryIntrinsic(program, instruction, "msad4");

    // dst: DirectX distance vector — (1, a1*b1, a2, b3)
    private void BuildDst(IRProgram program, Instruction instruction) => BuildBinaryIntrinsic(program, instruction, "dst");

    // ===================== 64-bit widening multiply =====================

    private void BuildMul64(IRProgram program, Instruction instruction) => BuildBinaryIntrinsic(program, instruction, "imul64");
    private void BuildUMul64(IRProgram program, Instruction instruction) => BuildBinaryIntrinsic(program, instruction, "umul64");

    // ===================== saturated variants =====================
    // _sat is a modifier on the destination in real DXBC (clamped to [0,1]
    // after the op), modeled here as wrapping the base expression in saturate().

    private void BuildAddSat(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression inner =
            new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.Add,
                Left = BuildExpression(instruction.Operands[1]),
                Right = BuildExpression(instruction.Operands[2])
            };

        IRExpression expression =
            new IRExpression.IntrinsicExpression { Name = "saturate", Arguments = { inner } };

        AddAssignment(program, destination, expression);
    }

    private void BuildMulSat(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression inner =
            new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.Multiply,
                Left = BuildExpression(instruction.Operands[1]),
                Right = BuildExpression(instruction.Operands[2])
            };

        IRExpression expression =
            new IRExpression.IntrinsicExpression { Name = "saturate", Arguments = { inner } };

        AddAssignment(program, destination, expression);
    }

    private void BuildMadSat(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression inner =
            new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.Add,

                Left = new IRExpression.BinaryExpression
                {
                    Operation = IRExpression.BinaryOperation.Multiply,
                    Left = BuildExpression(instruction.Operands[1]),
                    Right = BuildExpression(instruction.Operands[2])
                },

                Right = BuildExpression(instruction.Operands[3])
            };

        IRExpression expression =
            new IRExpression.IntrinsicExpression { Name = "saturate", Arguments = { inner } };

        AddAssignment(program, destination, expression);
    }
}