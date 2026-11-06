using UnityShaderDecompiler.Core.DXBC.Instructions;

namespace UnityShaderDecompiler.Core.DXBC.IR;

// Expression and register construction shared by the per-opcode builders.
public partial class IRBuilder
{
    private IRExpression BuildExpression(Operand operand)
    {
        if (operand.RegisterType == RegisterType.Immediate32)
        {
            return new IRExpression.ConstantExpression
            {
                RawValues = operand.Immediate32Values,
                Kind = IRExpression.ConstantExpression.ConstantKind.Float
            };
        }

        return new IRExpression.RegisterExpression
        {
            Register = BuildRegister(operand)
        };
    }

    private IRExpression BuildIntExpression(Operand operand)
    {
        if (operand.RegisterType == RegisterType.Immediate32)
        {
            return new IRExpression.ConstantExpression
            {
                RawValues = operand.Immediate32Values!,
                Kind = IRExpression.ConstantExpression.ConstantKind.Int
            };
        }

        return new IRExpression.RegisterExpression
        {
            Register = BuildRegister(operand)
        };
    }

    private IRExpression BuildUIntExpression(Operand operand)
    {
        if (operand.RegisterType == RegisterType.Immediate32)
        {
            return new IRExpression.ConstantExpression
            {
                RawValues = operand.Immediate32Values!,
                Kind = IRExpression.ConstantExpression.ConstantKind.UInt
            };
        }

        return new IRExpression.RegisterExpression
        {
            Register = BuildRegister(operand)
        };
    }

    private IRExpression BuildDoubleExpression(Operand operand)
    {
        if (operand.RegisterType == RegisterType.Immediate64)
        {
            return new IRExpression.ConstantExpression
            {
                DoubleValues = operand.Immediate64Values!,
                Kind = IRExpression.ConstantExpression.ConstantKind.Double
            };
        }

        return new IRExpression.RegisterExpression
        {
            Register = BuildRegister(operand)
        };
    }
    
    private IRExpression BuildBoolExpression(Operand operand)
    {
        IRExpression expression = BuildExpression(operand);

        if (expression.Type == IRValueType.Bool)
            return expression;

        return new IRExpression.BinaryExpression
        {
            Operation = IRExpression.BinaryOperation.NotEqual,
            Left = expression,
            Right = new IRExpression.ConstantExpression
            {
                Kind = expression.Type switch
                {
                    IRValueType.Int => IRExpression.ConstantExpression.ConstantKind.Int,
                    IRValueType.UInt => IRExpression.ConstantExpression.ConstantKind.UInt,
                    _ => IRExpression.ConstantExpression.ConstantKind.Float
                },
                RawValues = new uint[] { 0 }
            }
        };
    }
    
        private void BuildUnaryIntrinsic(IRProgram program, Instruction instruction, IRExpression.IRIntrinsic intrinsic)
        {
            BuildUnaryIntrinsic(program, instruction, intrinsic, BuildExpression);
        }

        private void BuildUnaryIntrinsic(
            IRProgram program,
            Instruction instruction,
            IRExpression.IRIntrinsic intrinsic,
            Func<Operand, IRExpression> buildOperand)
        {
            IRExpression expression =
                new IRExpression.IntrinsicExpression
                {
                    Intrinsic = intrinsic,
                    Arguments = { buildOperand(instruction.Operands[1]) }
                };

            Emit(program, instruction, expression);
        }

        private void BuildBinaryIntrinsic(IRProgram program, Instruction instruction, IRExpression.IRIntrinsic intrinsic)
        {
            IRExpression expression =
                new IRExpression.IntrinsicExpression
                {
                    Intrinsic = intrinsic,
                    Arguments =
                    {
                        BuildExpression(instruction.Operands[1]),
                        BuildExpression(instruction.Operands[2])
                    }
                };

            Emit(program, instruction, expression);
        }

        private void BuildTernaryIntrinsic(IRProgram program, Instruction instruction, IRExpression.IRIntrinsic intrinsic)
        {
            IRExpression expression =
                new IRExpression.IntrinsicExpression
                {
                    Intrinsic = intrinsic,
                    Arguments =
                    {
                        BuildExpression(instruction.Operands[1]),
                        BuildExpression(instruction.Operands[2]),
                        BuildExpression(instruction.Operands[3])
                    }
                };

            Emit(program, instruction, expression);
        }

        // Destination is always Operands[0] and the expression always gets
        // AddAssignment'd to it — nearly every builder in this file was
        // repeating that pair of lines around whatever expression it built.
        private void Emit(IRProgram program, Instruction instruction, IRExpression expression)
        {
            // DXBC encodes saturate as bit 13 on the opcode token, not as a
            // separate opcode.  add_sat, mul_sat, mad_sat etc. arrive here as
            // regular Add/Mul/Mad with Saturate=true.  Wrap in Clamp01 so the
            // pretty-printer emits saturate(...).
            if (instruction.Saturate)
            {
                expression = new IRExpression.IntrinsicExpression
                {
                    Intrinsic = IRExpression.IRIntrinsic.Clamp01,
                    Arguments = { expression }
                };
            }
            AddAssignment(program, BuildRegister(instruction.Operands[0]), expression);
        }

        // Two-destination form (imul, udiv-with-remainder, etc). Either
        // destination may legally be the "null" register when the caller
        // only wants one half of the result.
        private void EmitMulti(
            IRProgram program,
            IRRegister destinationA, IRExpression expressionA,
            IRRegister destinationB, IRExpression expressionB)
        {
            var statement = new IRStatement.IRMultiAssignment();

            statement.Destinations.Add(destinationA.RegisterType == RegisterType.Null ? null : destinationA);
            statement.Expressions.Add(expressionA);

            statement.Destinations.Add(destinationB.RegisterType == RegisterType.Null ? null : destinationB);
            statement.Expressions.Add(expressionB);

            program.Statements.Add(statement);
        }

        // Builds `left <op> right` where both sides go through the same
        // typed operand builder (BuildExpression / BuildIntExpression /
        // BuildUIntExpression / BuildDoubleExpression), then emits it to
        // Operands[0]. Collapses e.g. BuildAdd/BuildIAdd/BuildDAdd into
        // one-line callers.
        private void BuildTypedBinary(
            IRProgram program,
            Instruction instruction,
            IRExpression.BinaryOperation operation,
            Func<Operand, IRExpression> buildOperand)
        {
            IRExpression expression =
                new IRExpression.BinaryExpression
                {
                    Operation = operation,
                    Left = buildOperand(instruction.Operands[1]),
                    Right = buildOperand(instruction.Operands[2])
                };

            Emit(program, instruction, expression);
        }

        // Same idea for a two-argument intrinsic call (min/max/etc) where
        // both arguments share a typed operand builder.
        private void BuildTypedBinaryIntrinsic(
            IRProgram program,
            Instruction instruction,
            IRExpression.IRIntrinsic intrinsic,
            Func<Operand, IRExpression> buildOperand)
        {
            IRExpression expression =
                new IRExpression.IntrinsicExpression
                {
                    Intrinsic = intrinsic,
                    Arguments =
                    {
                        buildOperand(instruction.Operands[1]),
                        buildOperand(instruction.Operands[2])
                    }
                };

            Emit(program, instruction, expression);
        }

        // Backs every eq/ne/ge/lt/ieq/ine/ige/ilt/uge/ult comparison opcode.
        // swap=true builds Operands[2] <op> Operands[1] instead of the
        // normal order — used for le/gt/ugt/ule, which SM4 synthesizes by
        // flipping operands around ge/lt rather than having real opcodes.
        private void BuildComparison(
            IRProgram program,
            Instruction instruction,
            IRExpression.BinaryOperation operation,
            Func<Operand, IRExpression> buildOperand,
            bool swap = false)
        {
            IRExpression left = buildOperand(instruction.Operands[swap ? 2 : 1]);
            IRExpression right = buildOperand(instruction.Operands[swap ? 1 : 2]);

            Emit(program, instruction, new IRExpression.BinaryExpression
            {
                Operation = operation,
                Left = left,
                Right = right
            });
        }

        // Backs ftoi/ftou/itof/utof and any other single-argument type cast.
        private void BuildCast(
            IRProgram program,
            Instruction instruction,
            IRExpression.IRIntrinsic intrinsic,
            Func<Operand, IRExpression> buildOperand)
        {
            Emit(program, instruction, new IRExpression.IntrinsicExpression
            {
                Intrinsic = intrinsic,
                Arguments = { buildOperand(instruction.Operands[1]) }
            });
        }

        // sincos and any other instruction that writes to multiple
        // independent destinations, any of which may legally be "null"
        // (DXBC's way of saying "discard this output").
        private void EmitIfNotNull(IRProgram program, Operand destinationOperand, IRExpression expression)
        {
            if (destinationOperand.RegisterType == RegisterType.Null)
                return;

            AddAssignment(program, BuildRegister(destinationOperand), expression);
        }

        // (a * b) + c, typed. Backs mad/imad/fma/dfma so the multiply-add
        // tree only gets built in one place.
        private void BuildFusedMultiplyAdd(
            IRProgram program,
            Instruction instruction,
            Func<Operand, IRExpression> buildOperand)
        {
            IRExpression expression =
                new IRExpression.FusedMultiplyAddExpression
                {
                    A = buildOperand(instruction.Operands[1]),
                    B = buildOperand(instruction.Operands[2]),
                    C = buildOperand(instruction.Operands[3])
                };

            Emit(program, instruction, expression);
        }

        private IRRegister BuildRegister(Operand operand)
    {
        IRRegister reg = new()
        {
            RegisterType = operand.RegisterType,
            Type = GetRegisterType(operand.RegisterType, operand.RegisterIndex),
            Index = operand.RegisterIndex,

            Mask = operand.Mask,

            ComponentMode = operand.ComponentMode,
            Swizzle = operand.Swizzle,
            Component = operand.Component,

            Modifier = operand.Modifier
        };

        foreach (uint i in operand.Indices)
            reg.Indices.Add(i);

        // Relative/dynamic indexing (cb0[r2.x + 4], x0[r2.y], etc.) was
        // previously parsed into Operand.RelativeOperands but silently
        // discarded here — only the constant Indices made it into the IR.
        for (int i = 0; i < operand.RelativeOperands.Length; i++)
        {
            if (operand.RelativeOperands[i] is { } relativeOperand)
                reg.RelativeIndices[i] = BuildUIntExpression(relativeOperand);
        }

        return reg;
    }
    
    private void AddAssignment(IRProgram program, IRRegister destination, IRExpression expression)
    {
        if (expression.Type != IRValueType.Unknown)
        {
            destination.Type = expression.Type;
            SetRegisterType(destination);
        }

        program.Statements.Add(
            new IRStatement.IRAssignment
            {
                Destination = destination,
                Expression = expression
            });
    }
    
    private void SetRegisterType(IRRegister register)
    {
        _registerTypes[(register.RegisterType, register.Index)] = register.Type;
    }

    private IRValueType GetRegisterType(RegisterType type, uint index)
    {
        if (_registerTypes.TryGetValue((type, index), out var value))
            return value;

        return IRValueType.Unknown;
    }
    
}
