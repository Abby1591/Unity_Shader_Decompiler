using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

// sync's operand-less token itself carries which barrier flags are active
// (group-shared / device-memory / group-sync) as bits in the opcode token,
// not as separate instructions — DXBC has one "sync" opcode, and HLSL's
// distinct GroupMemoryBarrier/DeviceMemoryBarrier/AllMemoryBarrier (with or
// without ...WithGroupSync) all compile down to it with different flag bits
// set. ShdrParser doesn't decode those flag bits yet (no opcode-table entry
// for sync at all), so the six BuildXxxBarrier methods below assume the
// eventual sync instruction handling passes the decoded flags through
// instruction.ExtraData[0] as a BarrierFlags-shaped uint — adjust once the
// opcode number and flag-bit layout are confirmed against shader_sm4.c.
public partial class IRBuilder
{
    private void BuildSync(IRProgram program, Instruction instruction)
    {
        var flags = instruction.ExtraData.Count > 0
            ? (IRStatement.BarrierFlags)instruction.ExtraData[0]
            : IRStatement.BarrierFlags.None;

        program.Statements.Add(new IRStatement.IRBarrier { Flags = flags });
    }

    private void BuildGroupMemoryBarrier(IRProgram program, Instruction instruction)
        => program.Statements.Add(new IRStatement.IRBarrier { Flags = IRStatement.BarrierFlags.GroupShared });

    private void BuildGroupMemoryBarrierWithGroupSync(IRProgram program, Instruction instruction)
        => program.Statements.Add(new IRStatement.IRBarrier
        {
            Flags = IRStatement.BarrierFlags.GroupShared | IRStatement.BarrierFlags.GroupSync
        });

    private void BuildDeviceMemoryBarrier(IRProgram program, Instruction instruction)
        => program.Statements.Add(new IRStatement.IRBarrier { Flags = IRStatement.BarrierFlags.DeviceMemory });

    private void BuildDeviceMemoryBarrierWithGroupSync(IRProgram program, Instruction instruction)
        => program.Statements.Add(new IRStatement.IRBarrier
        {
            Flags = IRStatement.BarrierFlags.DeviceMemory | IRStatement.BarrierFlags.GroupSync
        });

    private void BuildAllMemoryBarrier(IRProgram program, Instruction instruction)
        => program.Statements.Add(new IRStatement.IRBarrier
        {
            Flags = IRStatement.BarrierFlags.GroupShared | IRStatement.BarrierFlags.DeviceMemory
        });

    private void BuildAllMemoryBarrierWithGroupSync(IRProgram program, Instruction instruction)
        => program.Statements.Add(new IRStatement.IRBarrier
        {
            Flags = IRStatement.BarrierFlags.GroupShared
                  | IRStatement.BarrierFlags.DeviceMemory
                  | IRStatement.BarrierFlags.GroupSync
        });
}