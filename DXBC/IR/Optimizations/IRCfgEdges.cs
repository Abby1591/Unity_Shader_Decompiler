using Parser.DXBC.IR;

namespace Parser.DXBC.IR.Optimizations;

// Shared plumbing for anything that deletes a CFG edge (branch
// simplification pruning a proven-dead successor, CFG cleanup dropping an
// unreachable block's outgoing edges, ...). Severing an edge is more than
// just list surgery on Predecessors/Successors: every IRPhi in the target
// block has an Operands list that's positionally parallel to that block's
// Predecessors (see IRPhi's doc comment) — removing a predecessor without
// removing the matching operand desyncs every phi in the block and leaves
// operands pointing at the wrong incoming edge.
public static class IRCfgEdges
{
    public static void RemoveEdge(IRBlock from, IRBlock to)
    {
        int index = to.Predecessors.IndexOf(from);

        if (index >= 0)
        {
            to.Predecessors.RemoveAt(index);

            foreach (IRStatement stmt in to.Statements)
            {
                if (stmt is IRStatement.IRPhi phi && index < phi.Operands.Count)
                    phi.Operands.RemoveAt(index);
            }
        }

        from.Successors.Remove(to);
    }
}