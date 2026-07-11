using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public partial class IRBuilder
{
    // ============================================================
    // Mov / movc
    // ============================================================

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

    // ============================================================
    // Add / sub
    // ============================================================

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

    // ============================================================
    // Mul / div
    // ============================================================

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

    // ============================================================
    // Mad / imad
    // ============================================================

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

    // ============================================================
    // Min / max
    // ============================================================

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

    // ============================================================
    // Neg / abs
    // ============================================================

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

    // ============================================================
    // Lrp / dp2add / msad / dst
    // ============================================================

    private void BuildLrp(IRProgram program, Instruction instruction)
    {
        BuildTernaryIntrinsic(program, instruction, "lerp");
    }

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
    private void BuildMSad(IRProgram program, Instruction instruction)
    {
        BuildTernaryIntrinsic(program, instruction, "msad4");
    }

    // dst: DirectX distance vector — (1, a1*b1, a2, b3)
    private void BuildDst(IRProgram program, Instruction instruction)
    {
        BuildBinaryIntrinsic(program, instruction, "dst");
    }

    // ============================================================
    // 64-bit widening multiply
    // ============================================================

    private void BuildMul64(IRProgram program, Instruction instruction)
    {
        BuildBinaryIntrinsic(program, instruction, "imul64");
    }

    private void BuildUMul64(IRProgram program, Instruction instruction)
    {
        BuildBinaryIntrinsic(program, instruction, "umul64");
    }

    // ============================================================
    // Saturated variants
    // ============================================================
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

    // ============================================================
    // And / or / xor / not
    // ============================================================

    private void BuildAnd(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.BitwiseAnd,
                Left = BuildUIntExpression(instruction.Operands[1]),
                Right = BuildUIntExpression(instruction.Operands[2])
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildOr(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.BitwiseOr,
                Left = BuildUIntExpression(instruction.Operands[1]),
                Right = BuildUIntExpression(instruction.Operands[2])
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildXor(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.BitwiseXor,
                Left = BuildUIntExpression(instruction.Operands[1]),
                Right = BuildUIntExpression(instruction.Operands[2])
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildNot(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.UnaryExpression
            {
                Operation = IRExpression.UnaryExpression.UnaryOperation.BitwiseNot,
                Operand = BuildUIntExpression(instruction.Operands[1])
            };

        AddAssignment(program, destination, expression);
    }

    // ============================================================
    // Shifts
    // ============================================================

    private void BuildIShl(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.LeftShift,
                Left = BuildUIntExpression(instruction.Operands[1]),
                Right = BuildUIntExpression(instruction.Operands[2])
            };

        AddAssignment(program, destination, expression);
    }

    // ushr: logical (unsigned) right shift
    private void BuildUShr(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.RightShift,
                Left = BuildUIntExpression(instruction.Operands[1]),
                Right = BuildUIntExpression(instruction.Operands[2])
            };

        AddAssignment(program, destination, expression);
    }

    // ishr: arithmetic (signed) right shift
    private void BuildIShr(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.RightShift,
                Left = BuildIntExpression(instruction.Operands[1]),
                Right = BuildIntExpression(instruction.Operands[2])
            };

        AddAssignment(program, destination, expression);
    }

    // ============================================================
    // Bit-scan / bit-count intrinsics
    // ============================================================

    private void BuildCountBits(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "countbits",
                Arguments = { BuildUIntExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildFirstBitHi(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "firstbithigh",
                Arguments = { BuildUIntExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildFirstBitLo(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "firstbitlow",
                Arguments = { BuildUIntExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }

    // firstbitshi: first-bit-high for signed integers
    private void BuildFirstBitSHi(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "firstbithigh",
                Arguments = { BuildIntExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildReverseBits(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "reversebits",
                Arguments = { BuildUIntExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }

    // ============================================================
    // Bitfield insert / extract
    // ============================================================

    // bfi dest, width, offset, src, dest_merge
    private void BuildBfi(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "bitfieldinsert",
                Arguments =
                {
                    BuildUIntExpression(instruction.Operands[1]),
                    BuildUIntExpression(instruction.Operands[2]),
                    BuildUIntExpression(instruction.Operands[3]),
                    BuildUIntExpression(instruction.Operands[4])
                }
            };

        AddAssignment(program, destination, expression);
    }

    // ubfe dest, width, offset, src (unsigned bitfield extract)
    private void BuildUbfe(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "bitfieldextract",
                Arguments =
                {
                    BuildUIntExpression(instruction.Operands[1]),
                    BuildUIntExpression(instruction.Operands[2]),
                    BuildUIntExpression(instruction.Operands[3])
                }
            };

        AddAssignment(program, destination, expression);
    }

    // ibfe dest, width, offset, src (signed bitfield extract)
    private void BuildIbfe(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "bitfieldextract",
                Arguments =
                {
                    BuildIntExpression(instruction.Operands[1]),
                    BuildIntExpression(instruction.Operands[2]),
                    BuildIntExpression(instruction.Operands[3])
                }
            };

        AddAssignment(program, destination, expression);
    }

    // ============================================================
    // Aliases
    // ============================================================
    // BFRev is the same op as reversebits (bfrev is just the SM5 mnemonic).
    // InsertBits/ExtractBits are the HLSL-facing names for bfi/ibfe/ubfe.
    // Wave intrinsics (WaveActiveBit*, WavePrefixBit*, WaveMatch,
    // WaveMultiPrefix) are SM6-only and intentionally omitted.

    private void BuildBFRev(IRProgram program, Instruction instruction)
    {
        BuildReverseBits(program, instruction);
    }

    private void BuildInsertBits(IRProgram program, Instruction instruction)
    {
        BuildBfi(program, instruction);
    }

    private void BuildExtractBitsSigned(IRProgram program, Instruction instruction)
    {
        BuildIbfe(program, instruction);
    }

    private void BuildExtractBitsUnsigned(IRProgram program, Instruction instruction)
    {
        BuildUbfe(program, instruction);
    }

    // ============================================================
    // Dot products
    // ============================================================

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

    // ============================================================
    // Roots / exponentials
    // ============================================================

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

    // ============================================================
    // Rounding
    // ============================================================

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

    // ============================================================
    // Saturate
    // ============================================================

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

    // ============================================================
    // Fma
    // ============================================================

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

    // ============================================================
    // Trig
    // ============================================================
    // Not raw DXBC opcodes — SM4/5 has no native sin/cos/tan/etc, they're
    // synthesized from sincos/exp/log sequences by the compiler. Included
    // for use once a pattern-matcher recognizes the underlying sequence and
    // wants to emit the higher-level intrinsic instead.

    private void BuildCos(IRProgram program, Instruction instruction)
    {
        BuildUnaryIntrinsic(program, instruction, "cos");
    }

    private void BuildSin(IRProgram program, Instruction instruction)
    {
        BuildUnaryIntrinsic(program, instruction, "sin");
    }

    private void BuildTan(IRProgram program, Instruction instruction)
    {
        BuildUnaryIntrinsic(program, instruction, "tan");
    }

    private void BuildAsin(IRProgram program, Instruction instruction)
    {
        BuildUnaryIntrinsic(program, instruction, "asin");
    }

    private void BuildAcos(IRProgram program, Instruction instruction)
    {
        BuildUnaryIntrinsic(program, instruction, "acos");
    }

    private void BuildAtan(IRProgram program, Instruction instruction)
    {
        BuildUnaryIntrinsic(program, instruction, "atan");
    }

    private void BuildAtan2(IRProgram program, Instruction instruction)
    {
        BuildBinaryIntrinsic(program, instruction, "atan2");
    }

    // ============================================================
    // Exponentials / rounding
    // ============================================================

    private void BuildExp2(IRProgram program, Instruction instruction)
    {
        BuildUnaryIntrinsic(program, instruction, "exp2");
    }

    private void BuildLog2(IRProgram program, Instruction instruction)
    {
        BuildUnaryIntrinsic(program, instruction, "log2");
    }

    private void BuildFloor(IRProgram program, Instruction instruction)
    {
        BuildUnaryIntrinsic(program, instruction, "floor");
    }

    private void BuildCeil(IRProgram program, Instruction instruction)
    {
        BuildUnaryIntrinsic(program, instruction, "ceil");
    }

    private void BuildTrunc(IRProgram program, Instruction instruction)
    {
        BuildUnaryIntrinsic(program, instruction, "trunc");
    }

    private void BuildFmod(IRProgram program, Instruction instruction)
    {
        BuildBinaryIntrinsic(program, instruction, "fmod");
    }

    private void BuildModf(IRProgram program, Instruction instruction)
    {
        BuildBinaryIntrinsic(program, instruction, "modf");
    }

    private void BuildLdexp(IRProgram program, Instruction instruction)
    {
        BuildBinaryIntrinsic(program, instruction, "ldexp");
    }

    private void BuildFrexp(IRProgram program, Instruction instruction)
    {
        BuildBinaryIntrinsic(program, instruction, "frexp");
    }

    // ============================================================
    // Vector / matrix geometry
    // ============================================================

    private void BuildNormalize(IRProgram program, Instruction instruction)
    {
        BuildUnaryIntrinsic(program, instruction, "normalize");
    }

    private void BuildLength(IRProgram program, Instruction instruction)
    {
        BuildUnaryIntrinsic(program, instruction, "length");
    }

    private void BuildDistance(IRProgram program, Instruction instruction)
    {
        BuildBinaryIntrinsic(program, instruction, "distance");
    }

    private void BuildCross(IRProgram program, Instruction instruction)
    {
        BuildBinaryIntrinsic(program, instruction, "cross");
    }

    private void BuildReflect(IRProgram program, Instruction instruction)
    {
        BuildBinaryIntrinsic(program, instruction, "reflect");
    }

    private void BuildRefract(IRProgram program, Instruction instruction)
    {
        BuildTernaryIntrinsic(program, instruction, "refract");
    }

    private void BuildFaceForward(IRProgram program, Instruction instruction)
    {
        BuildTernaryIntrinsic(program, instruction, "faceforward");
    }

    private void BuildTranspose(IRProgram program, Instruction instruction)
    {
        BuildUnaryIntrinsic(program, instruction, "transpose");
    }

    private void BuildDeterminant(IRProgram program, Instruction instruction)
    {
        BuildUnaryIntrinsic(program, instruction, "determinant");
    }

    private void BuildNoise(IRProgram program, Instruction instruction)
    {
        BuildUnaryIntrinsic(program, instruction, "noise");
    }

    // dadd/dmul/ddiv/dfma/dmov/drcp/dsqrt/drsq operate on register pairs in real
    // DXBC (a double occupies two adjacent 32-bit components), but this models
    // them at the value level via BuildDoubleExpression/IRValueType.Double —
    // consistent with how the rest of this IR treats registers as typed values
    // rather than raw component slots.
    private void BuildDMov(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);
        IRExpression expression = BuildDoubleExpression(instruction.Operands[1]);
        AddAssignment(program, destination, expression);
    }

    private void BuildDAdd(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.Add,
                Left = BuildDoubleExpression(instruction.Operands[1]),
                Right = BuildDoubleExpression(instruction.Operands[2])
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildDSub(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.Subtract,
                Left = BuildDoubleExpression(instruction.Operands[1]),
                Right = BuildDoubleExpression(instruction.Operands[2])
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildDMul(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.Multiply,
                Left = BuildDoubleExpression(instruction.Operands[1]),
                Right = BuildDoubleExpression(instruction.Operands[2])
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildDDiv(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.Divide,
                Left = BuildDoubleExpression(instruction.Operands[1]),
                Right = BuildDoubleExpression(instruction.Operands[2])
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildDFma(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.Add,

                Left = new IRExpression.BinaryExpression
                {
                    Operation = IRExpression.BinaryOperation.Multiply,
                    Left = BuildDoubleExpression(instruction.Operands[1]),
                    Right = BuildDoubleExpression(instruction.Operands[2])
                },

                Right = BuildDoubleExpression(instruction.Operands[3])
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildDRcp(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "rcp",
                Arguments = { BuildDoubleExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildDSqrt(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "sqrt",
                Arguments = { BuildDoubleExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildDRsq(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "rsqrt",
                Arguments = { BuildDoubleExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }

    // ============================================================
    // Conversions to/from double
    // ============================================================

    private void BuildDtoI(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "int",
                Arguments = { BuildDoubleExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildDtoU(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "uint",
                Arguments = { BuildDoubleExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildItoD(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "double",
                Arguments = { BuildIntExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildUtoD(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "double",
                Arguments = { BuildUIntExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildFtoD(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "double",
                Arguments = { BuildExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }

    private void BuildDtoF(IRProgram program, Instruction instruction)
    {
        var destination = BuildRegister(instruction.Operands[0]);

        IRExpression expression =
            new IRExpression.IntrinsicExpression
            {
                Name = "float",
                Arguments = { BuildDoubleExpression(instruction.Operands[1]) }
            };

        AddAssignment(program, destination, expression);
    }
}