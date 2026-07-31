using Parser.DXBC.IR;

namespace Parser.DXBC.IR.Analysis;

// Phase 7: walks the dominator tree in preorder, maintaining one stack of
// version numbers per storage location. Every write pushes a fresh
// version; every read stamps itself with whatever's on top; leaving a
// subtree pops exactly what that subtree pushed. This is what actually
// fills in the placeholder PHI operands IRPhiInsertion left behind, and
// what gives every register its "_N" in IRRegister.ToString().
public static class IRSsaRenaming
{
    public static void Rename(List<IRBlock> blocks, IRDominatorInfo dom)
    {
        if (blocks.Count == 0)
            return;

        Dictionary<IRBlock, List<IRBlock>> tree = dom.BuildTree();
        var counters = new Dictionary<IRStorageLocation, int>();
        var stacks = new Dictionary<IRStorageLocation, Stack<int>>();

        Visit(blocks[0], tree, counters, stacks);
    }

    private static void Visit(
        IRBlock block,
        Dictionary<IRBlock, List<IRBlock>> tree,
        Dictionary<IRStorageLocation, int> counters,
        Dictionary<IRStorageLocation, Stack<int>> stacks)
    {
        var pushedHere = new List<IRStorageLocation>();

        foreach (IRStatement stmt in block.Statements)
        {
            if (stmt is IRStatement.IRPhi phi)
            {
                // Operands are filled in below, from each predecessor's
                // exit state — not from this block's own stack top.
                DefineRegister(phi.Destination, counters, stacks, pushedHere);
                continue;
            }

            foreach (IRRegister used in stmt.Uses)
                UseRegister(used, stacks);

            foreach (IRRegister defined in stmt.Defines)
                DefineRegister(defined, counters, stacks, pushedHere);
        }

        // Fill in this block's contribution to every PHI in each
        // successor, using the values live at the end of THIS block.
        foreach (IRBlock succ in block.Successors)
        {
            int predIndex = succ.Predecessors.IndexOf(block);
            if (predIndex < 0)
                continue; // shouldn't happen if Connect() built this graph

            foreach (IRStatement stmt in succ.Statements)
            {
                if (stmt is not IRStatement.IRPhi phi)
                    continue; // PHIs are always at the top of the block

                if (predIndex < phi.Operands.Count)
                    UseRegister(phi.Operands[predIndex], stacks);
            }
        }

        if (tree.TryGetValue(block, out List<IRBlock>? children))
            foreach (IRBlock child in children)
                Visit(child, tree, counters, stacks);

        // Leaving this subtree: undo exactly what it pushed, so a
        // sibling subtree sees the versions live before we entered.
        foreach (IRStorageLocation loc in pushedHere)
            stacks[loc].Pop();
    }

    private static void UseRegister(IRRegister reg, Dictionary<IRStorageLocation, Stack<int>> stacks)
    {
        foreach (IRStorageLocation loc in IRStorageLocation.ReadLocationsOf(reg))
        {
            if (stacks.TryGetValue(loc, out Stack<int>? stack) && stack.Count > 0)
                reg.SsaVersion[IRStorageLocation.ComponentToIndex(loc.Component)] = stack.Peek();

            // Empty stack: this component is read before ever being
            // written on any path reaching here — an implicit function
            // input. Left as null (unrenamed) rather than guessed at.
        }
    }

    private static void DefineRegister(
        IRRegister reg,
        Dictionary<IRStorageLocation, int> counters,
        Dictionary<IRStorageLocation, Stack<int>> stacks,
        List<IRStorageLocation> pushedHere)
    {
        foreach (IRStorageLocation loc in IRStorageLocation.WriteLocationsOf(reg))
        {
            int version = counters.TryGetValue(loc, out int c) ? c : 1;
            counters[loc] = version + 1;

            if (!stacks.TryGetValue(loc, out Stack<int>? stack))
                stacks[loc] = stack = new Stack<int>();

            stack.Push(version);
            pushedHere.Add(loc);

            reg.SsaVersion[IRStorageLocation.ComponentToIndex(loc.Component)] = version;
        }
    }
}
