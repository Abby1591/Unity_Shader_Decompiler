using Parser.DXBC.IR;

namespace Parser.Core.Optimizations;

// Phase 9.13: cleans up the CFG shape left behind once IRBranchSimplification
// (or anything else) prunes edges — deletes blocks nothing can reach any
// more, and collapses straight-line A->B runs into one block. Kept as its
// own pass rather than folded into branch simplification because the two
// need to alternate: pruning one branch can make a downstream block
// unreachable, and merging blocks can turn what used to be a two-successor
// if-block into a straight fallthrough that a later branch-simplification
// pass now sees clearly. The caller's fixed-point loop is what actually
// drives that back-and-forth — this pass just does one sweep of each.
//
// Deliberately does NOT touch dominators — mutating Predecessors/Successors
// invalidates whatever IRDominatorInfo the caller computed earlier, and
// recomputing that is the caller's responsibility (see IROptimizationPipeline),
// same as it already is for anything else that changes CFG shape.
public static class IRCfgCleanup
{
    public static bool Run(List<IRBlock> blocks)
    {
        bool changed = false;

        changed |= RemoveUnreachableBlocks(blocks);
        changed |= MergeStraightLineBlocks(blocks);

        return changed;
    }

    // Blocks with no predecessors other than the entry block (blocks[0])
    // can no longer execute — typically the losing side of an
    // IRBranchSimplification fold once its only edge in is gone. Anything
    // reachable only through a chain of such blocks goes too, so this
    // works from actual reachability off the entry block rather than just
    // an empty-Predecessors check on each block in isolation.
    private static bool RemoveUnreachableBlocks(List<IRBlock> blocks)
    {
        if (blocks.Count == 0)
            return false;

        var reachable = new HashSet<IRBlock> { blocks[0] };
        var worklist = new Queue<IRBlock>();
        worklist.Enqueue(blocks[0]);

        while (worklist.Count > 0)
        {
            IRBlock block = worklist.Dequeue();

            foreach (IRBlock succ in block.Successors)
            {
                if (reachable.Add(succ))
                    worklist.Enqueue(succ);
            }
        }

        bool changed = false;

        for (int i = blocks.Count - 1; i >= 0; i--)
        {
            IRBlock block = blocks[i];

            if (reachable.Contains(block))
                continue;

            foreach (IRBlock succ in block.Successors.ToList())
                IRCfgEdges.RemoveEdge(block, succ);

            blocks.RemoveAt(i);
            changed = true;
        }

        return changed;
    }

    // A block with exactly one successor S, where S has exactly that block
    // as its only predecessor, is a straight-line run — nothing else can
    // ever enter S except by falling through from this block, so the two
    // can just become one block. This also naturally absorbs empty blocks
    // (e.g. the shell IRBranchSimplification leaves behind after deleting
    // an IRIf), since an empty block is just the degenerate case of this
    // same shape.
    private static bool MergeStraightLineBlocks(List<IRBlock> blocks)
    {
        bool changed = false;

        for (int i = blocks.Count - 1; i >= 0; i--)
        {
            IRBlock block = blocks[i];

            if (block.Successors.Count != 1)
                continue;

            IRBlock succ = block.Successors[0];

            if (succ == block) // self-loop — leave it, not a straight line
                continue;

            if (succ.Predecessors.Count != 1 || succ.Predecessors[0] != block)
                continue;

            block.Statements.AddRange(succ.Statements);

            block.Successors.Clear();
            block.Successors.AddRange(succ.Successors);

            foreach (IRBlock succOfSucc in succ.Successors)
            {
                int idx = succOfSucc.Predecessors.IndexOf(succ);
                if (idx >= 0)
                    succOfSucc.Predecessors[idx] = block;
            }

            blocks.Remove(succ);
            changed = true;
        }

        return changed;
    }
}