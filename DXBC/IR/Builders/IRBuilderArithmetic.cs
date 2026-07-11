using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public partial class IRBuilder
{
    // ===================== mov / movc =====================

    private void BuildMov(IRProgram program, Instruction instruction)
    {
        Emit(program, instruction, BuildExpression(instruction.Operands[1]));
    }

    private void BuildMovC(IRProgram program, Instruction instruction)
    {
        IRExpression expression =
            new IRExpression.ConditionalExpression
            {
                Condition = BuildBoolExpression(instruction.Operands[1]),
                TrueExpression = BuildExpression(instruction.Operands[2]),
                FalseExpression = BuildExpression(instruction.Operands[3])
            };

        Emit(program, instruction, expression);
    }

    // ===================== add / sub =====================

    private void BuildAdd(IRProgram program, Instruction instruction) =>
        BuildTypedBinary(program, instruction, IRExpression.BinaryOperation.Add, BuildExpression);

    private void BuildIAdd(IRProgram program, Instruction instruction) =>
        BuildTypedBinary(program, instruction, IRExpression.BinaryOperation.Add, BuildIntExpression);

    private void BuildSub(IRProgram program, Instruction instruction) =>
        BuildTypedBinary(program, instruction, IRExpression.BinaryOperation.Subtract, BuildExpression);

    private void BuildISub(IRProgram program, Instruction instruction) =>
        BuildTypedBinary(program, instruction, IRExpression.BinaryOperation.Subtract, BuildIntExpression);

    // ===================== mul / div =====================

    private void BuildMul(IRProgram program, Instruction instruction) =>
        BuildTypedBinary(program, instruction, IRExpression.BinaryOperation.Multiply, BuildExpression);

    // imul dest_hi, dest_lo, src0, src1 — OperandCount=4 in ShdrParser's
    // OpcodeTable confirms this is a real two-destination instruction (32x32
    // multiply producing a 64-bit result split across two registers), not a
    // single-destination multiply. Either destination may be the "null"
    // register if the caller only wants one half.
    private void BuildIMul(IRProgram program, Instruction instruction)
    {
        IRExpression left = BuildIntExpression(instruction.Operands[2]);
        IRExpression right = BuildIntExpression(instruction.Operands[3]);

        EmitMulti(
            program,
            BuildRegister(instruction.Operands[0]),
            new IRExpression.MultiplyHighExpression { Left = left, Right = right, Signed = true },
            BuildRegister(instruction.Operands[1]),
            new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.Multiply,
                Left = left,
                Right = right
            });
    }

    private void BuildUMul(IRProgram program, Instruction instruction) =>
        BuildTypedBinary(program, instruction, IRExpression.BinaryOperation.Multiply, BuildUIntExpression);

    private void BuildDiv(IRProgram program, Instruction instruction) =>
        BuildTypedBinary(program, instruction, IRExpression.BinaryOperation.Divide, BuildExpression);

    private void BuildUDiv(IRProgram program, Instruction instruction) =>
        BuildTypedBinary(program, instruction, IRExpression.BinaryOperation.Divide, BuildUIntExpression);

    // Real DXBC udiv is udiv dest_quot, dest_rem, src0, src1 (4 operands) —
    // same multi-destination shape as imul. Not wired into ConvertInstruction
    // yet since udiv has no OpcodeTable entry to confirm the operand order
    // against; BuildUDiv above stays as the single-output simplification
    // until then. Use this once confirmed.
    private void BuildUDivQuotientRemainder(IRProgram program, Instruction instruction)
    {
        IRExpression left = BuildUIntExpression(instruction.Operands[2]);
        IRExpression right = BuildUIntExpression(instruction.Operands[3]);

        EmitMulti(
            program,
            BuildRegister(instruction.Operands[0]),
            new IRExpression.BinaryExpression { Operation = IRExpression.BinaryOperation.Divide, Left = left, Right = right },
            BuildRegister(instruction.Operands[1]),
            new IRExpression.BinaryExpression { Operation = IRExpression.BinaryOperation.Modulo, Left = left, Right = right });
    }

    // ===================== mad / imad =====================

    private void BuildMad(IRProgram program, Instruction instruction) =>
        BuildFusedMultiplyAdd(program, instruction, BuildExpression);

    private void BuildIMad(IRProgram program, Instruction instruction) =>
        BuildFusedMultiplyAdd(program, instruction, BuildIntExpression);

    // ===================== min / max =====================

    private void BuildMin(IRProgram program, Instruction instruction) =>
        BuildTypedBinaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Min, BuildExpression);

    private void BuildMax(IRProgram program, Instruction instruction) =>
        BuildTypedBinaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Max, BuildExpression);

    private void BuildIMin(IRProgram program, Instruction instruction) =>
        BuildTypedBinaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Min, BuildIntExpression);

    private void BuildIMax(IRProgram program, Instruction instruction) =>
        BuildTypedBinaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Max, BuildIntExpression);

    private void BuildUMin(IRProgram program, Instruction instruction) =>
        BuildTypedBinaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Min, BuildUIntExpression);

    private void BuildUMax(IRProgram program, Instruction instruction) =>
        BuildTypedBinaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Max, BuildUIntExpression);

    // ===================== neg / abs =====================

    private void BuildNeg(IRProgram program, Instruction instruction)
    {
        Emit(program, instruction, new IRExpression.UnaryExpression
        {
            Operation = IRExpression.UnaryExpression.UnaryOperation.Negate,
            Operand = BuildExpression(instruction.Operands[1])
        });
    }

    private void BuildAbs(IRProgram program, Instruction instruction)
    {
        Emit(program, instruction, new IRExpression.UnaryExpression
        {
            Operation = IRExpression.UnaryExpression.UnaryOperation.Absolute,
            Operand = BuildExpression(instruction.Operands[1])
        });
    }

    // ===================== lrp / dp2add / msad / dst =====================

    private void BuildLrp(IRProgram program, Instruction instruction) => BuildTernaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Lerp);

    // dp2add: dot(a.xy, b.xy) + c
    private void BuildDp2Add(IRProgram program, Instruction instruction)
    {
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

        Emit(program, instruction, expression);
    }

    // msad: masked sum-of-absolute-differences (used for texture-space skinning/video codecs)
    private void BuildMSad(IRProgram program, Instruction instruction) => BuildTernaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.MaskedSumOfAbsoluteDifferences);

    // dst: DirectX distance vector — (1, a1*b1, a2, b3)
    private void BuildDst(IRProgram program, Instruction instruction) => BuildBinaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.DirectionVector);

    // ===================== 64-bit widening multiply =====================

    private void BuildMul64(IRProgram program, Instruction instruction)
    {
        Emit(program, instruction, new IRExpression.MultiplyHighExpression
        {
            Left = BuildExpression(instruction.Operands[1]),
            Right = BuildExpression(instruction.Operands[2]),
            Signed = true
        });
    }

    private void BuildUMul64(IRProgram program, Instruction instruction)
    {
        Emit(program, instruction, new IRExpression.MultiplyHighExpression
        {
            Left = BuildExpression(instruction.Operands[1]),
            Right = BuildExpression(instruction.Operands[2]),
            Signed = false
        });
    }

    // ===================== saturated variants =====================
    // _sat is a modifier on the destination in real DXBC (clamped to [0,1]
    // after the op), modeled here as wrapping the base expression in
    // Clamp01(...).

    private void BuildSaturated(IRProgram program, Instruction instruction, IRExpression inner)
    {
        Emit(program, instruction, new IRExpression.IntrinsicExpression
        {
            Intrinsic = IRExpression.IRIntrinsic.Clamp01,
            Arguments = { inner }
        });
    }

    private void BuildAddSat(IRProgram program, Instruction instruction) =>
        BuildSaturated(program, instruction, new IRExpression.BinaryExpression
        {
            Operation = IRExpression.BinaryOperation.Add,
            Left = BuildExpression(instruction.Operands[1]),
            Right = BuildExpression(instruction.Operands[2])
        });

    private void BuildMulSat(IRProgram program, Instruction instruction) =>
        BuildSaturated(program, instruction, new IRExpression.BinaryExpression
        {
            Operation = IRExpression.BinaryOperation.Multiply,
            Left = BuildExpression(instruction.Operands[1]),
            Right = BuildExpression(instruction.Operands[2])
        });

    private void BuildMadSat(IRProgram program, Instruction instruction) =>
        BuildSaturated(program, instruction, new IRExpression.FusedMultiplyAddExpression
        {
            A = BuildExpression(instruction.Operands[1]),
            B = BuildExpression(instruction.Operands[2]),
            C = BuildExpression(instruction.Operands[3])
        });

    // ===================== and / or / xor / not =====================

    private void BuildAnd(IRProgram program, Instruction instruction) =>
        BuildTypedBinary(program, instruction, IRExpression.BinaryOperation.BitwiseAnd, BuildUIntExpression);

    private void BuildOr(IRProgram program, Instruction instruction) =>
        BuildTypedBinary(program, instruction, IRExpression.BinaryOperation.BitwiseOr, BuildUIntExpression);

    private void BuildXor(IRProgram program, Instruction instruction) =>
        BuildTypedBinary(program, instruction, IRExpression.BinaryOperation.BitwiseXor, BuildUIntExpression);

    private void BuildNot(IRProgram program, Instruction instruction) =>
        Emit(program, instruction, new IRExpression.UnaryExpression
        {
            Operation = IRExpression.UnaryExpression.UnaryOperation.BitwiseNot,
            Operand = BuildUIntExpression(instruction.Operands[1])
        });

    // ===================== shifts =====================

    private void BuildIShl(IRProgram program, Instruction instruction) =>
        BuildTypedBinary(program, instruction, IRExpression.BinaryOperation.LeftShift, BuildUIntExpression);

    // ushr: logical (unsigned) right shift — zero-fills from the top
    private void BuildUShr(IRProgram program, Instruction instruction) =>
        BuildTypedBinary(program, instruction, IRExpression.BinaryOperation.UnsignedRightShift, BuildUIntExpression);

    // ishr: arithmetic (signed) right shift — sign-extends from the top
    private void BuildIShr(IRProgram program, Instruction instruction) =>
        BuildTypedBinary(program, instruction, IRExpression.BinaryOperation.SignedRightShift, BuildIntExpression);

    // ===================== bit-scan / bit-count intrinsics =====================

    private void BuildCountBits(IRProgram program, Instruction instruction) =>
        Emit(program, instruction, new IRExpression.IntrinsicExpression
        {
            Intrinsic = IRExpression.IRIntrinsic.CountBits,
            Arguments = { BuildUIntExpression(instruction.Operands[1]) }
        });

    private void BuildFirstBitHi(IRProgram program, Instruction instruction) =>
        BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.FirstBitHigh);

    private void BuildFirstBitLo(IRProgram program, Instruction instruction) =>
        BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.FirstBitLow);

    // firstbitshi: first-bit-high for signed integers
    private void BuildFirstBitSHi(IRProgram program, Instruction instruction) =>
        Emit(program, instruction, new IRExpression.IntrinsicExpression
        {
            Intrinsic = IRExpression.IRIntrinsic.FirstBitHigh,
            Arguments = { BuildIntExpression(instruction.Operands[1]) }
        });

    private void BuildReverseBits(IRProgram program, Instruction instruction) =>
        Emit(program, instruction, new IRExpression.IntrinsicExpression
        {
            Intrinsic = IRExpression.IRIntrinsic.ReverseBits,
            Arguments = { BuildUIntExpression(instruction.Operands[1]) }
        });

    // ===================== bitfield insert / extract =====================

    // bfi dest, width, offset, src, dest_merge
    private void BuildBfi(IRProgram program, Instruction instruction) =>
        Emit(program, instruction, new IRExpression.BitFieldInsertExpression
        {
            Width = BuildUIntExpression(instruction.Operands[1]),
            Offset = BuildUIntExpression(instruction.Operands[2]),
            Insert = BuildUIntExpression(instruction.Operands[3]),
            Base = BuildUIntExpression(instruction.Operands[4])
        });

    // ubfe dest, width, offset, src (unsigned bitfield extract)
    private void BuildUbfe(IRProgram program, Instruction instruction) =>
        Emit(program, instruction, new IRExpression.BitFieldExtractExpression
        {
            Width = BuildUIntExpression(instruction.Operands[1]),
            Offset = BuildUIntExpression(instruction.Operands[2]),
            Value = BuildUIntExpression(instruction.Operands[3]),
            Signed = false
        });

    // ibfe dest, width, offset, src (signed bitfield extract)
    private void BuildIbfe(IRProgram program, Instruction instruction) =>
        Emit(program, instruction, new IRExpression.BitFieldExtractExpression
        {
            Width = BuildIntExpression(instruction.Operands[1]),
            Offset = BuildIntExpression(instruction.Operands[2]),
            Value = BuildIntExpression(instruction.Operands[3]),
            Signed = true
        });

    // ===================== aliases =====================
    // BFRev is the same op as reversebits (bfrev is just the SM5 mnemonic).
    // InsertBits/ExtractBits are the HLSL-facing names for bfi/ibfe/ubfe.
    // Wave intrinsics (WaveActiveBit*, WavePrefixBit*, WaveMatch,
    // WaveMultiPrefix) are SM6-only and intentionally omitted.

    private void BuildBFRev(IRProgram program, Instruction instruction) => BuildReverseBits(program, instruction);

    private void BuildInsertBits(IRProgram program, Instruction instruction) => BuildBfi(program, instruction);

    private void BuildExtractBitsSigned(IRProgram program, Instruction instruction) => BuildIbfe(program, instruction);

    private void BuildExtractBitsUnsigned(IRProgram program, Instruction instruction) => BuildUbfe(program, instruction);

    // ===================== dot products =====================

    private void BuildDotProduct(IRProgram program, Instruction instruction, int components) =>
        Emit(program, instruction, new IRExpression.DotProductExpression
        {
            Left = BuildExpression(instruction.Operands[1]),
            Right = BuildExpression(instruction.Operands[2]),
            Components = components
        });

    private void BuildDp2(IRProgram program, Instruction instruction) => BuildDotProduct(program, instruction, 2);
    private void BuildDp3(IRProgram program, Instruction instruction) => BuildDotProduct(program, instruction, 3);
    private void BuildDp4(IRProgram program, Instruction instruction) => BuildDotProduct(program, instruction, 4);

    // ===================== roots / exponentials =====================

    private void BuildSqrt(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Sqrt);
    private void BuildRsqrt(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Rsqrt);
    private void BuildExp(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Exp2);
    private void BuildLog(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Log2);
    private void BuildPow(IRProgram program, Instruction instruction) => BuildBinaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Pow);
    private void BuildFrac(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.FractionalPart);
    private void BuildRcp(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Reciprocal);

    // ===================== rounding =====================
    // The DXBC opcode name (round_ne/ni/pi/z) belongs to the parser, not the
    // IR — these all just describe standard rounding semantics.

    private void BuildRoundNE(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.RoundNearestEven);
    private void BuildRoundNI(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Floor);
    private void BuildRoundPI(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Ceiling);
    private void BuildRoundZ(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Truncate);

    // ===================== saturate =====================

    private void BuildSaturate(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Clamp01);

    // ===================== fma =====================

    private void BuildFma(IRProgram program, Instruction instruction) => BuildFusedMultiplyAdd(program, instruction, BuildExpression);

    // ===================== trig =====================
    // Not raw DXBC opcodes — SM4/5 has no native sin/cos/tan/etc, they're
    // synthesized from sincos/exp/log sequences by the compiler. Included
    // for use once a pattern-matcher recognizes the underlying sequence and
    // wants to emit the higher-level intrinsic instead.

    private void BuildCos(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Cos);
    private void BuildSin(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Sin);
    private void BuildTan(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Tan);
    private void BuildAsin(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Asin);
    private void BuildAcos(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Acos);
    private void BuildAtan(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Atan);
    private void BuildAtan2(IRProgram program, Instruction instruction) => BuildBinaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Atan2);

    // ===================== exponentials / rounding =====================

    private void BuildExp2(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Exp2);
    private void BuildLog2(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Log2);

    private void BuildFloor(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Floor);
    private void BuildCeil(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Ceiling);
    private void BuildTrunc(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Truncate);

    private void BuildFmod(IRProgram program, Instruction instruction) => BuildBinaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Fmod);
    private void BuildModf(IRProgram program, Instruction instruction) => BuildBinaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Modf);
    private void BuildLdexp(IRProgram program, Instruction instruction) => BuildBinaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Ldexp);
    private void BuildFrexp(IRProgram program, Instruction instruction) => BuildBinaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Frexp);

    // ===================== vector / matrix geometry =====================

    private void BuildNormalize(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Normalize);
    private void BuildLength(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Length);
    private void BuildDistance(IRProgram program, Instruction instruction) => BuildBinaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Distance);
    private void BuildCross(IRProgram program, Instruction instruction) => BuildBinaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Cross);
    private void BuildReflect(IRProgram program, Instruction instruction) => BuildBinaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Reflect);
    private void BuildRefract(IRProgram program, Instruction instruction) => BuildTernaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Refract);
    private void BuildFaceForward(IRProgram program, Instruction instruction) => BuildTernaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.FaceForward);

    private void BuildTranspose(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Transpose);
    private void BuildDeterminant(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Determinant);
    private void BuildNoise(IRProgram program, Instruction instruction) => BuildUnaryIntrinsic(program, instruction, IRExpression.IRIntrinsic.Noise);

    private void BuildDMov(IRProgram program, Instruction instruction) =>
        Emit(program, instruction, BuildDoubleExpression(instruction.Operands[1]));

    private void BuildDAdd(IRProgram program, Instruction instruction) =>
        BuildTypedBinary(program, instruction, IRExpression.BinaryOperation.Add, BuildDoubleExpression);

    private void BuildDSub(IRProgram program, Instruction instruction) =>
        BuildTypedBinary(program, instruction, IRExpression.BinaryOperation.Subtract, BuildDoubleExpression);

    private void BuildDMul(IRProgram program, Instruction instruction) =>
        BuildTypedBinary(program, instruction, IRExpression.BinaryOperation.Multiply, BuildDoubleExpression);

    private void BuildDDiv(IRProgram program, Instruction instruction) =>
        BuildTypedBinary(program, instruction, IRExpression.BinaryOperation.Divide, BuildDoubleExpression);

    private void BuildDFma(IRProgram program, Instruction instruction) =>
        BuildFusedMultiplyAdd(program, instruction, BuildDoubleExpression);

    private void BuildDRcp(IRProgram program, Instruction instruction) =>
        Emit(program, instruction, new IRExpression.IntrinsicExpression
        {
            Intrinsic = IRExpression.IRIntrinsic.Reciprocal,
            Arguments = { BuildDoubleExpression(instruction.Operands[1]) }
        });

    private void BuildDSqrt(IRProgram program, Instruction instruction) =>
        Emit(program, instruction, new IRExpression.IntrinsicExpression
        {
            Intrinsic = IRExpression.IRIntrinsic.Sqrt,
            Arguments = { BuildDoubleExpression(instruction.Operands[1]) }
        });

    private void BuildDRsq(IRProgram program, Instruction instruction) =>
        Emit(program, instruction, new IRExpression.IntrinsicExpression
        {
            Intrinsic = IRExpression.IRIntrinsic.Rsqrt,
            Arguments = { BuildDoubleExpression(instruction.Operands[1]) }
        });

    // ===================== conversions to/from double =====================

    private void BuildDtoI(IRProgram program, Instruction instruction) =>
        Emit(program, instruction, new IRExpression.IntrinsicExpression
        {
            Intrinsic = IRExpression.IRIntrinsic.CastInt,
            Arguments = { BuildDoubleExpression(instruction.Operands[1]) }
        });

    private void BuildDtoU(IRProgram program, Instruction instruction) =>
        Emit(program, instruction, new IRExpression.IntrinsicExpression
        {
            Intrinsic = IRExpression.IRIntrinsic.CastUInt,
            Arguments = { BuildDoubleExpression(instruction.Operands[1]) }
        });

    private void BuildItoD(IRProgram program, Instruction instruction) =>
        Emit(program, instruction, new IRExpression.IntrinsicExpression
        {
            Intrinsic = IRExpression.IRIntrinsic.CastDouble,
            Arguments = { BuildIntExpression(instruction.Operands[1]) }
        });

    private void BuildUtoD(IRProgram program, Instruction instruction) =>
        Emit(program, instruction, new IRExpression.IntrinsicExpression
        {
            Intrinsic = IRExpression.IRIntrinsic.CastDouble,
            Arguments = { BuildUIntExpression(instruction.Operands[1]) }
        });

    private void BuildFtoD(IRProgram program, Instruction instruction) =>
        Emit(program, instruction, new IRExpression.IntrinsicExpression
        {
            Intrinsic = IRExpression.IRIntrinsic.CastDouble,
            Arguments = { BuildExpression(instruction.Operands[1]) }
        });

    private void BuildDtoF(IRProgram program, Instruction instruction) =>
        Emit(program, instruction, new IRExpression.IntrinsicExpression
        {
            Intrinsic = IRExpression.IRIntrinsic.CastFloat,
            Arguments = { BuildDoubleExpression(instruction.Operands[1]) }
        });
}