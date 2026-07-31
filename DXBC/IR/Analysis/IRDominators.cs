using Parser.DXBC.IR;

namespace Parser.DXBC.IR.Analysis;

public sealed class IRDominatorInfo
{
    // Immediate dominator of every reachable block. The entry block maps
    // to itself (there's nothing above it).
    public Dictionary<IRBlock, IRBlock> ImmediateDominator { get; } = new();

    public bool Dominates(IRBlock a, IRBlock b)
    {
        foreach (IRBlock d in Dominators(b))
            if (d == a)
                return true;

        return false;
    }

    // Walks up from `b` through immediate dominators to the entry block,
    // inclusive of `b` itself.
    public IEnumerable<IRBlock> Dominators(IRBlock b)
    {
        if (!ImmediateDominator.ContainsKey(b))
            yield break; // unreachable block: has no dominators

        IRBlock cursor = b;
        yield return cursor;

        while (ImmediateDominator[cursor] != cursor)
        {
            cursor = ImmediateDominator[cursor];
            yield return cursor;
        }
    }

    // children[X] = blocks whose immediate dominator is X.
    public Dictionary<IRBlock, List<IRBlock>> BuildTree()
    {
        var children = new Dictionary<IRBlock, List<IRBlock>>();

        foreach ((IRBlock block, IRBlock idom) in ImmediateDominator)
        {
            if (block == idom)
                continue; // entry has no parent in the tree

            if (!children.TryGetValue(idom, out List<IRBlock>? list))
                children[idom] = list = new List<IRBlock>();

            list.Add(block);
        }

        return children;
    }
}

// Phase 4: Cooper, Harvey & Kennedy's "A Simple, Fast Dominance
// Algorithm" — converges in a handful of passes over reverse postorder
// without needing a full dataflow bitvector solve.
public static class IRDominatorAnalysis
{
    public static IRDominatorInfo Compute(List<IRBlock> blocks)
    {
        var info = new IRDominatorInfo();

        if (blocks.Count == 0)
            return info;

        IRBlock entry = blocks[0];

        List<IRBlock> rpo = ReversePostorder(entry);
        var rpoIndex = new Dictionary<IRBlock, int>();
        for (int i = 0; i < rpo.Count; i++)
            rpoIndex[rpo[i]] = i;

        info.ImmediateDominator[entry] = entry;

        bool changed = true;
        while (changed)
        {
            changed = false;

            for (int i = 1; i < rpo.Count; i++) // skip entry
            {
                IRBlock block = rpo[i];
                IRBlock? newIdom = null;

                foreach (IRBlock pred in block.Predecessors)
                {
                    if (!info.ImmediateDominator.ContainsKey(pred))
                        continue; // predecessor not processed yet this pass

                    newIdom = newIdom is null ? pred : Intersect(newIdom, pred, info.ImmediateDominator, rpoIndex);
                }

                if (newIdom is null)
                    continue; // no processed predecessor yet — try again next pass

                if (!info.ImmediateDominator.TryGetValue(block, out IRBlock? current) || current != newIdom)
                {
                    info.ImmediateDominator[block] = newIdom;
                    changed = true;
                }
            }
        }

        return info;
    }

    private static IRBlock Intersect(
        IRBlock a, IRBlock b, Dictionary<IRBlock, IRBlock> idom, Dictionary<IRBlock, int> rpoIndex)
    {
        while (a != b)
        {
            while (rpoIndex[a] > rpoIndex[b])
                a = idom[a];

            while (rpoIndex[b] > rpoIndex[a])
                b = idom[b];
        }

        return a;
    }

    // DFS postorder over the CFG (unreachable blocks are simply excluded
    // — they have no dominators), reversed so entry comes first.
    private static List<IRBlock> ReversePostorder(IRBlock entry)
    {
        var visited = new HashSet<IRBlock>();
        var postorder = new List<IRBlock>();

        void Visit(IRBlock block)
        {
            if (!visited.Add(block))
                return;

            foreach (IRBlock succ in block.Successors)
                Visit(succ);

            postorder.Add(block);
        }

        Visit(entry);
        postorder.Reverse();
        return postorder;
    }
}
