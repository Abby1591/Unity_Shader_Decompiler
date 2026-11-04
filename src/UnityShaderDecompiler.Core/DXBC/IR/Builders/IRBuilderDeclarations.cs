using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public partial class IRBuilder
{
    // Declarations don't produce executable IR statements — they populate
    // shader metadata on the IRProgram (resources, bindings, temp count, flags).
    private void BuildResource(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IRResourceDeclaration
            {
                Slot = instruction.Operands[0].RegisterIndex,

                // ShdrParser.Parse() already stashes the resourceDim bits
                // from the dcl_resource opcode token into ExtraData[0] —
                // this just interprets them.
                Dimension = instruction.ExtraData.Count > 0
                    ? instruction.ExtraData[0].ToResourceDimension()
                    : ResourceDimension.Unknown
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

    // NOTE: dcl_uav has no opcode-table entry yet, so ShdrParser doesn't
    // capture a resourceDim ExtraData DWORD for it the way it does for
    // dcl_resource. Once the opcode number and its ExtraData capture are
    // added to ShdrParser, populate Dimension here the same way BuildResource does.
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

    // ============================================================
    // Indexable temps / streams / interfaces
    // ============================================================

    private void BuildIndexableTemp(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IRIndexableTempDeclaration
            {
                Register = instruction.Operands[0].RegisterIndex,
                Count = instruction.ExtraData.Count > 0 ? instruction.ExtraData[0] : 0,
                ComponentCount = instruction.ExtraData.Count > 1 ? instruction.ExtraData[1] : 0
            });
    }

    private void BuildStream(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IRStreamDeclaration
            {
                Index = instruction.Operands[0].RegisterIndex
            });
    }

    private void BuildInterface(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IRInterfaceDeclaration
            {
                Index = instruction.Operands[0].RegisterIndex,
                NumTypes = instruction.ExtraData.Count > 0 ? instruction.ExtraData[0] : 0,
                TableLength = instruction.ExtraData.Count > 1 ? instruction.ExtraData[1] : 0
            });
    }

    // See the caveat in IRDeclaration.cs's "hull / domain shader" section — the
    // values these read from ExtraData/operands are placeholders until the real
    // opcode numbers and token bit layouts are confirmed against shader_sm4.c.
    // ============================================================
    // Phases
    // ============================================================

    private void BuildHSControlPointPhase(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IRPhase { Kind = IRStatement.HullShaderPhaseKind.ControlPoint });
    }

    private void BuildHSForkPhase(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IRPhase { Kind = IRStatement.HullShaderPhaseKind.Fork });
    }

    private void BuildHSJoinPhase(IRProgram program, Instruction instruction)
    {
        program.Statements.Add(new IRStatement.IRPhase { Kind = IRStatement.HullShaderPhaseKind.Join });
    }

    // ============================================================
    // Declarations
    // ============================================================

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

    // ============================================================
    // Raw/structured resource & UAV/TGSM declarations
    // ============================================================

    private void BuildUAVRaw(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IRUAVRawDeclaration { Slot = instruction.Operands[0].RegisterIndex });
    }

    private void BuildUAVStructured(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IRUAVStructuredDeclaration
            {
                Slot = instruction.Operands[0].RegisterIndex,
                StructureStride = instruction.ExtraData.Count > 0 ? instruction.ExtraData[0] : 0
            });
    }

    private void BuildTGSMRaw(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IRTGSMRawDeclaration
            {
                Slot = instruction.Operands[0].RegisterIndex,
                ByteCount = instruction.ExtraData.Count > 0 ? instruction.ExtraData[0] : 0
            });
    }

    private void BuildTGSMStructured(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IRTGSMStructuredDeclaration
            {
                Slot = instruction.Operands[0].RegisterIndex,
                StructureStride = instruction.ExtraData.Count > 0 ? instruction.ExtraData[0] : 0,
                ElementCount = instruction.ExtraData.Count > 1 ? instruction.ExtraData[1] : 0
            });
    }

    private void BuildResourceRaw(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IRResourceRawDeclaration { Slot = instruction.Operands[0].RegisterIndex });
    }

    private void BuildResourceStructured(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IRResourceStructuredDeclaration
            {
                Slot = instruction.Operands[0].RegisterIndex,
                StructureStride = instruction.ExtraData.Count > 0 ? instruction.ExtraData[0] : 0
            });
    }

    // ============================================================
    // Instance/phase counts
    // ============================================================

    private void BuildHSForkPhaseInstanceCount(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IRHSForkPhaseInstanceCountDeclaration
            {
                Count = instruction.ExtraData.Count > 0 ? instruction.ExtraData[0] : 0
            });
    }

    private void BuildHSJoinPhaseInstanceCount(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IRHSJoinPhaseInstanceCountDeclaration
            {
                Count = instruction.ExtraData.Count > 0 ? instruction.ExtraData[0] : 0
            });
    }

    private void BuildGSInstanceCount(IRProgram program, Instruction instruction)
    {
        program.Declarations.Add(
            new IRDeclaration.IRGSInstanceCountDeclaration
            {
                Count = instruction.ExtraData.Count > 0 ? instruction.ExtraData[0] : 0
            });
    }

    // dcl_tessellator_output_primitive (151) genuinely uses this same
    // TessellatorOutputPrimitive enum/IR class - that part is correct.
    // Flagging for a later pass: Opcode.DclOutputTopology (92, GS
    // primitive topology - D3D10_SB_PRIMITIVE_TOPOLOGY: pointlist/
    // linelist/trianglestrip/etc, a completely different value set) is
    // ALSO wired to this same BuildOutputTopology/IROutputTopologyDeclaration
    // pair via the main dispatcher switch - that pairing predates this
    // change and looks like a mismatch, not something introduced here.
    private void BuildTessOutputPrimitive(IRProgram program, Instruction instruction)
    {
        BuildOutputTopology(program, instruction);
    }
}