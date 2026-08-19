using Parser.DXBC.IR;

namespace Parser.Core.Analysis;

// Phase 5: DF(n) = every block m where n dominates some predecessor of m
// but does not strictly dominate m itself — i.e. the first points past
// each of n's paths where n's dominance "runs out". This is exactly the
// set of blocks that need a PHI for anything n defines (Phase 6).
public static class IRDominanceFrontierAnalysis
{
    public static Dictionary<IRBlock, HashSet<IRBlock>> Compute(List<IRBlock> blocks, IRDominatorInfo dom)
    {
        var df = new Dictionary<IRBlock, HashSet<IRBlock>>();

        foreach (IRBlock block in blocks)
            df[block] = new HashSet<IRBlock>();

        foreach (IRBlock b in blocks)
        {
            if (b.Predecessors.Count < 2)
                continue; // merge points are the only source of frontier edges

            if (!dom.ImmediateDominator.TryGetValue(b, out IRBlock? idomB))
                continue; // b unreachable

            foreach (IRBlock p in b.Predecessors)
            {
                if (!dom.ImmediateDominator.ContainsKey(p))
                    continue; // p unreachable

                IRBlock runner = p;

                while (runner != idomB)
                {
                    df[runner].Add(b);

                    if (!dom.ImmediateDominator.TryGetValue(runner, out IRBlock? next) || next == runner)
                        break; // reached entry

                    runner = next;
                }
            }
        }

        return df;
    }
}
