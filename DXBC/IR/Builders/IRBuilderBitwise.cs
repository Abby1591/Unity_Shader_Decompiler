using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public partial class IRBuilder
{
    // ===================== and / or / xor / not =====================

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

    // ===================== shifts =====================

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

    // ===================== bit-scan / bit-count intrinsics =====================

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

    // ===================== bitfield insert / extract =====================

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

    // ===================== aliases =====================
    // BFRev is the same op as reversebits (bfrev is just the SM5 mnemonic).
    // InsertBits/ExtractBits are the HLSL-facing names for bfi/ibfe/ubfe.
    // Wave intrinsics (WaveActiveBit*, WavePrefixBit*, WaveMatch,
    // WaveMultiPrefix) are SM6-only and intentionally omitted.

    private void BuildBFRev(IRProgram program, Instruction instruction) => BuildReverseBits(program, instruction);

    private void BuildInsertBits(IRProgram program, Instruction instruction) => BuildBfi(program, instruction);

    private void BuildExtractBitsSigned(IRProgram program, Instruction instruction) => BuildIbfe(program, instruction);

    private void BuildExtractBitsUnsigned(IRProgram program, Instruction instruction) => BuildUbfe(program, instruction);
}