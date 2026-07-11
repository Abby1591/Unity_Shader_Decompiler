using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public partial class IRBuilder
{
    private void BuildEmit(IRProgram program, Instruction instruction)
        => program.Statements.Add(new IRStatement.IREmitVertex());

    private void BuildEmitStream(IRProgram program, Instruction instruction)
        => program.Statements.Add(new IRStatement.IREmitVertex { Stream = instruction.Operands[0].RegisterIndex });

    // cut / RestartStrip are the same operation (RestartStrip is just the
    // HLSL-facing name for the SM4 "cut" opcode)
    private void BuildCut(IRProgram program, Instruction instruction)
        => program.Statements.Add(new IRStatement.IRCutStream());

    private void BuildCutStream(IRProgram program, Instruction instruction)
        => program.Statements.Add(new IRStatement.IRCutStream { Stream = instruction.Operands[0].RegisterIndex });

    private void BuildEmitThenCut(IRProgram program, Instruction instruction)
        => program.Statements.Add(new IRStatement.IRCutStream { EmitBeforeCut = true });

    private void BuildEmitThenCutStream(IRProgram program, Instruction instruction)
        => program.Statements.Add(new IRStatement.IRCutStream
        {
            Stream = instruction.Operands[0].RegisterIndex,
            EmitBeforeCut = true
        });
}