using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public partial class IRBuilder
{
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

    private IRRegister BuildRegister(Operand operand)
    {
        Console.WriteLine($"{operand.RegisterType}  idx={operand.RegisterIndex}");
        IRRegister reg = new()
        {
            Type = operand.RegisterType,
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
}