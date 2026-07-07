using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public partial class IRBuilder
{
    private void BuildConstantBuffer(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IRConstantBufferDeclaration
            {
                Slot = instruction.Operands[0].RegisterIndex
            });
    }
    
    private void BuildSampler(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IRSamplerDeclaration
            {
                Slot = instruction.Operands[0].RegisterIndex
            });
    }

    private void BuildResource(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IRResourceDeclaration
            {
                Slot = instruction.Operands[0].RegisterIndex
            });
    }

    private void BuildInput(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IRInputDeclaration
            {
                Register = instruction.Operands[0].RegisterIndex
            });
    }
    
    private void BuildInputPS(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IRInputDeclaration
            {
                Register = instruction.Operands[0].RegisterIndex
            });
    }

    private void BuildOutput(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IROutputDeclaration
            {
                Register = instruction.Operands[0].RegisterIndex
            });
    }

    private void BuildTemps(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IRTempDeclaration
            {
                Count = instruction.ExtraData.Count > 0
                    ? instruction.ExtraData[0]
                    : 0
            });
    }
}