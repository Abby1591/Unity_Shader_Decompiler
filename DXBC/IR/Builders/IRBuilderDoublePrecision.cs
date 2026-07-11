using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

// dadd/dmul/ddiv/dfma/dmov/drcp/dsqrt/drsq operate on register pairs in real
// DXBC (a double occupies two adjacent 32-bit components), but this models
// them at the value level via BuildDoubleExpression/IRValueType.Double —
// consistent with how the rest of this IR treats registers as typed values
// rather than raw component slots.
public partial class IRBuilder
{
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

    // ===================== conversions to/from double =====================

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