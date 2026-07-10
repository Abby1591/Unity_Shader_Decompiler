using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

// Control-flow opcodes emit IRStatement nodes directly onto the program
// rather than producing/assigning an IRExpression.
public partial class IRBuilder
{
    // ===================== if / else / endif =====================

    private void BuildIf(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRIf
            {
                Condition = BuildBoolExpression(instruction.Operands[0])
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

    // ===================== loop / endloop =====================

    private void BuildLoop(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IRLoop());
    }

    private void BuildEndLoop(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IREndLoop());
    }

    // ===================== switch / case / default / endswitch =====================

    private void BuildSwitch(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRSwitch
            {
                Selector = BuildIntExpression(instruction.Operands[0])
            });
    }

    private void BuildCase(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRCase
            {
                Value = BuildIntExpression(instruction.Operands[0])
            });
    }

    private void BuildDefault(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IRDefault());
    }

    private void BuildEndSwitch(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IREndSwitch());
    }

    // ===================== break / continue =====================

    private void BuildBreak(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IRBreak());
    }

    private void BuildBreakC(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRBreak
            {
                Condition = BuildBoolExpression(instruction.Operands[0])
            });
    }

    private void BuildContinue(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IRContinue());
    }

    private void BuildContinueC(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRContinue
            {
                Condition = BuildBoolExpression(instruction.Operands[0])
            });
    }

    // ===================== return =====================

    private void BuildRet(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IRReturn());
    }

    private void BuildRetC(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRReturn
            {
                Condition = BuildBoolExpression(instruction.Operands[0])
            });
    }

    // ===================== discard =====================

    private void BuildDiscard(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRDiscard
            {
                Condition = BuildBoolExpression(instruction.Operands[0])
            });
    }

    // ===================== label =====================

    private void BuildLabel(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRLabel
            {
                Name = instruction.Operands[0].RegisterIndex.ToString()
            });
    }

    // ===================== call / callc =====================

    private void BuildCall(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRCall
            {
                Label = instruction.Operands[0].RegisterIndex.ToString()
            });
    }

    private void BuildCallC(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(
            new IRStatement.IRCall
            {
                Label = instruction.Operands[1].RegisterIndex.ToString(),
                Condition = BuildBoolExpression(instruction.Operands[0])
            });
    }
}