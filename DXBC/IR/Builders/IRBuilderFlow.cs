using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public partial class IRBuilder
{
    private void BuildIf(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRIf
            {
                Condition = BuildExpression(instruction.Operands[0])
            });
    }

    private void BuildElse(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IRElse());
    }

    private void BuildEndIf(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IREndIf());
    }

    private void BuildLoop(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IRLoop());
    }

    private void BuildEndLoop(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IREndLoop());
    }

    private void BuildBreakC(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRBreak
            {
                Condition = BuildExpression(instruction.Operands[0])
            });
    }

    private void BuildRet(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IRReturn());
    }
}