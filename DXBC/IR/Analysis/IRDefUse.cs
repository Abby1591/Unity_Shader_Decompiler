using Parser.DXBC.IR;

namespace Parser.DXBC.IR.Analysis;

public sealed class IRBlockDefUse
{
    // Every location written anywhere in the block.
    public HashSet<IRStorageLocation> Def { get; } = new();

    // Locations read by the block before being (re)defined by it — i.e.
    // "upward exposed" uses. This is the set liveness analysis needs:
    // a location only counts as USE if the block could observe a value
    // that came in from a predecessor rather than one it wrote itself.
    public HashSet<IRStorageLocation> Use { get; } = new();
}

public static class IRDefUseAnalysis
{
    public static IRBlockDefUse Compute(IRBlock block)
    {
        var result = new IRBlockDefUse();

        foreach (IRStatement stmt in block.Statements)
        {
            foreach (IRRegister reg in stmt.Uses)
                foreach (IRStorageLocation loc in IRStorageLocation.ReadLocationsOf(reg))
                    if (!result.Def.Contains(loc))
                        result.Use.Add(loc);

            foreach (IRRegister reg in stmt.Defines)
                foreach (IRStorageLocation loc in IRStorageLocation.WriteLocationsOf(reg))
                    result.Def.Add(loc);
        }

        return result;
    }

    public static Dictionary<IRBlock, IRBlockDefUse> ComputeAll(IEnumerable<IRBlock> blocks)
    {
        var map = new Dictionary<IRBlock, IRBlockDefUse>();

        foreach (IRBlock block in blocks)
            map[block] = Compute(block);

        return map;
    }
}
