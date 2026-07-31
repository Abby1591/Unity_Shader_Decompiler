using Parser.DXBC.IR;

namespace Parser.DXBC.IR.Analysis;

// Phase 6: classic Cytron et al. PHI placement. For every storage
// location defined in more than one block, walk the iterated dominance
// frontier of its def-sites and drop a PHI at each one — that's exactly
// where two differently-defined values can reach the same point.
public static class IRPhiInsertion
{
    public static void InsertPhis(List<IRBlock> blocks, Dictionary<IRBlock, HashSet<IRBlock>> df)
    {
        Dictionary<IRBlock, IRBlockDefUse> defUse = IRDefUseAnalysis.ComputeAll(blocks);

        var defBlocks = new Dictionary<IRStorageLocation, HashSet<IRBlock>>();

        foreach (IRBlock block in blocks)
        {
            foreach (IRStorageLocation loc in defUse[block].Def)
            {
                if (!defBlocks.TryGetValue(loc, out HashSet<IRBlock>? set))
                    defBlocks[loc] = set = new HashSet<IRBlock>();

                set.Add(block);
            }
        }

        foreach ((IRStorageLocation loc, HashSet<IRBlock> defs) in defBlocks)
        {
            if (defs.Count < 2)
                continue; // only ever defined in one block: nothing to merge, no PHI possible

            var hasPhi = new HashSet<IRBlock>();
            var worklist = new Queue<IRBlock>(defs);

            while (worklist.Count > 0)
            {
                IRBlock b = worklist.Dequeue();

                if (!df.TryGetValue(b, out HashSet<IRBlock>? frontier))
                    continue;

                foreach (IRBlock d in frontier)
                {
                    if (!hasPhi.Add(d))
                        continue;

                    var phi = new IRStatement.IRPhi { Destination = loc.ToRegister() };

                    // One operand slot per predecessor edge — all start as
                    // the same pre-renaming location; Phase 7 rewrites each
                    // to whatever definition actually reaches it along that
                    // specific edge.
                    for (int i = 0; i < d.Predecessors.Count; i++)
                        phi.Operands.Add(loc.ToRegister());

                    d.Statements.Insert(0, phi);

                    if (!defs.Contains(d))
                        worklist.Enqueue(d);
                }
            }
        }
    }
}
