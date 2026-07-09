using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

// Declarations don't produce executable IR statements — they populate
// shader metadata on the IRProgram (resources, bindings, temp count, flags).
public partial class IRBuilder
{
    private void BuildResource(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IRResourceDeclaration
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

    private void BuildConstantBuffer(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IRConstantBufferDeclaration
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

    // dcl_input_sgv: system-generated-value input (e.g. vertex id, instance id)
    private void BuildInputSGV(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IRInputDeclaration
            {
                Register = instruction.Operands[0].RegisterIndex,
                SystemValue = instruction.ExtraData.Count > 0
                    ? instruction.ExtraData[0]
                    : 0
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

    // dcl_output_siv: system-interpreted-value output (e.g. SV_Position)
    private void BuildOutputSIV(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IROutputDeclaration
            {
                Register = instruction.Operands[0].RegisterIndex,
                SystemValue = instruction.ExtraData.Count > 0
                    ? instruction.ExtraData[0]
                    : 0
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

    private void BuildGlobalFlags(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IRGlobalFlagsDeclaration
            {
                Flags = instruction.ExtraData.Count > 0
                    ? instruction.ExtraData[0]
                    : 0
            });
    }

    private void BuildUAV(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IRUAVDeclaration
            {
                Slot = instruction.Operands[0].RegisterIndex
            });
    }

    private void BuildThreadGroup(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IRThreadGroupDeclaration
            {
                X = instruction.ExtraData.Count > 0 ? instruction.ExtraData[0] : 0,
                Y = instruction.ExtraData.Count > 1 ? instruction.ExtraData[1] : 0,
                Z = instruction.ExtraData.Count > 2 ? instruction.ExtraData[2] : 0
            });
    }

    private void BuildIndexRange(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IRIndexRangeDeclaration
            {
                Register = instruction.Operands[0].RegisterIndex,
                Count = instruction.ExtraData.Count > 0
                    ? instruction.ExtraData[0]
                    : 0
            });
    }

    private void BuildFunctionBody(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IRFunctionBodyDeclaration
            {
                Index = instruction.ExtraData.Count > 0
                    ? instruction.ExtraData[0]
                    : 0
            });
    }

    private void BuildFunctionTable(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IRFunctionTableDeclaration
            {
                Index = instruction.ExtraData.Count > 0
                    ? instruction.ExtraData[0]
                    : 0
            });
    }
}