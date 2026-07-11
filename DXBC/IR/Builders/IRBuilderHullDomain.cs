using System;
using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

// See the caveat in IRDeclaration.cs's "hull / domain shader" section — the
// values these read from ExtraData/operands are placeholders until the real
// opcode numbers and token bit layouts are confirmed against shader_sm4.c.
public partial class IRBuilder
{
    // ===================== phases =====================

    private void BuildHSControlPointPhase(IRProgram program, Instruction instruction)
        => program.Statements.Add(new IRStatement.IRPhase { Kind = IRStatement.HullShaderPhaseKind.ControlPoint });

    private void BuildHSForkPhase(IRProgram program, Instruction instruction)
        => program.Statements.Add(new IRStatement.IRPhase { Kind = IRStatement.HullShaderPhaseKind.Fork });

    private void BuildHSJoinPhase(IRProgram program, Instruction instruction)
        => program.Statements.Add(new IRStatement.IRPhase { Kind = IRStatement.HullShaderPhaseKind.Join });

    // ===================== declarations =====================

    private void BuildInputControlPointCount(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IRInputControlPointCountDeclaration
            {
                Count = instruction.ExtraData.Count > 0 ? instruction.ExtraData[0] : 0
            });
    }

    private void BuildOutputControlPointCount(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IROutputControlPointCountDeclaration
            {
                Count = instruction.ExtraData.Count > 0 ? instruction.ExtraData[0] : 0
            });
    }

    // dcl_hs_max_tessfactor carries a 32-bit float packed as its ExtraData DWORD
    private void BuildHSMaxTessFactor(IRProgram program, Instruction instruction)
    {
        float value = instruction.ExtraData.Count > 0
            ? BitConverter.Int32BitsToSingle((int)instruction.ExtraData[0])
            : 0f;

        program.Declarations.Add(new IRDeclaration.IRMaxTessFactorDeclaration { Value = value });
    }

    private void BuildDomain(IRProgram program, Instruction instruction)
    {
        var domain = instruction.ExtraData.Count > 0
            ? (IRDeclaration.TessellatorDomain)instruction.ExtraData[0]
            : IRDeclaration.TessellatorDomain.Undefined;

        program.Declarations.Add(new IRDeclaration.IRDomainDeclaration { Domain = domain });
    }

    private void BuildPartitioning(IRProgram program, Instruction instruction)
    {
        var partitioning = instruction.ExtraData.Count > 0
            ? (IRDeclaration.TessellatorPartitioning)instruction.ExtraData[0]
            : IRDeclaration.TessellatorPartitioning.Undefined;

        program.Declarations.Add(new IRDeclaration.IRPartitioningDeclaration { Partitioning = partitioning });
    }

    private void BuildOutputTopology(IRProgram program, Instruction instruction)
    {
        var topology = instruction.ExtraData.Count > 0
            ? (IRDeclaration.TessellatorOutputPrimitive)instruction.ExtraData[0]
            : IRDeclaration.TessellatorOutputPrimitive.Undefined;

        program.Declarations.Add(new IRDeclaration.IROutputTopologyDeclaration { Topology = topology });
    }
}