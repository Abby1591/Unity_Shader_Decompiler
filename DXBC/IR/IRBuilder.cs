using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public partial class IRBuilder
{
    private readonly Dictionary<(RegisterType Type, uint Index), IRValueType> _registerTypes = new();
    
    public IRProgram Build(ShdrParser parser)
    {
        IRProgram program = new();

        foreach (Instruction instruction in parser.Instructions)
        {
            ConvertInstruction(program, instruction);
        }

        return program;
    }

    private void ConvertInstruction(IRProgram program, Instruction instruction)
    {
        switch (instruction.Opcode)
        {
            // Arithmetic
            case Opcode.Mov:
                BuildMov(program, instruction);
                break;

            case Opcode.Add:
                BuildAdd(program, instruction);
                break;
            
            case Opcode.IAdd:
                BuildIAdd(program, instruction);
                break;

            case Opcode.Mul:
                BuildMul(program, instruction);
                break;

            case Opcode.Div:
                BuildDiv(program, instruction);
                break;

            case Opcode.Mad:
                BuildMad(program, instruction);
                break;
            
            case Opcode.MovC:
                BuildMovC(program, instruction);
                break;

            // Comparisons
            case Opcode.Eq:
                BuildEq(program, instruction);
                break;

            case Opcode.Ne:
                BuildNe(program, instruction);
                break;

            case Opcode.GE:
                BuildGE(program, instruction);
                break;

            case Opcode.Lt:
                BuildLt(program, instruction);
                break;
            
            case Opcode.IGe:
                BuildIge(program, instruction);
                break;

            case Opcode.ILt:
                BuildIlt(program, instruction);
                break;
            
            //Conversions
            
            case Opcode.Ftoi:
                BuildFtoi(program, instruction);
                break;

            case Opcode.RoundNI:
                BuildRoundNI(program, instruction);
                break;
            
            case Opcode.Ftou:
                BuildFtou(program, instruction);
                break;

            case Opcode.Itof:
                BuildItof(program, instruction);
                break;

            case Opcode.Utof:
                BuildUtof(program, instruction);
                break;
            
            //Declarations
            
            case Opcode.DclConstantBuffer:
                BuildConstantBuffer(program, instruction);
                break;
            
            case Opcode.DclSampler:
                BuildSampler(program, instruction);
                break;

            case Opcode.DclResource:
                BuildResource(program, instruction);
                break;
            
            case Opcode.DclInput:
                BuildInput(program, instruction);
                break;

            case Opcode.DclInputPS:
                BuildInputPS(program, instruction);
                break;

            case Opcode.DclOutput:
                BuildOutput(program, instruction);
                break;

            case Opcode.DclTemps:
                BuildTemps(program, instruction);
                break;
            
            //Texture
            
            case Opcode.Sample:
                BuildSample(program, instruction);
                break;

            case Opcode.SampleL:
                BuildSampleLevel(program, instruction);
                break;
            
            //Flow
            
            case Opcode.If:
                BuildIf(program, instruction);
                break;

            case Opcode.Else:
                BuildElse(program, instruction);
                break;

            case Opcode.EndIf:
                BuildEndIf(program, instruction);
                break;

            case Opcode.Loop:
                BuildLoop(program, instruction);
                break;

            case Opcode.EndLoop:
                BuildEndLoop(program, instruction);
                break;

            case Opcode.BreakC:
                BuildBreakC(program, instruction);
                break;

            case Opcode.Ret:
                BuildRet(program, instruction);
                break;
            
            //intrinsic
            
            case Opcode.SinCos:
                BuildSincos(program, instruction);
                break;

            
            default:
                Console.WriteLine($"IR: Unsupported opcode {instruction.Name}");
                break;
        }
    }

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