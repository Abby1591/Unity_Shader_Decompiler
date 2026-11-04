using Parser.DXBC.IR;
using Parser.Core.Analysis;

namespace Parser.Core.Optimizations;

// Phase 9.8: hoists computations out of loops when every value they read
// is defined outside the loop body. Loop bodies are identified
// positionally rather than via back-edge/natural-loop discovery: DXBC's
// loop/endloop is always properly structured (no gotos), and
// IRBlockBuilder never reorders blocks, so a loop's body is always the
// contiguous run of blocks between its IRLoop and matching IREndLoop —
// exactly what IRControlFlowGraphBuilder's own loopStack pairing relies
// on. Samples are deliberately never hoisted: GPU texture sampling needs
// implicit derivatives from neighboring pixels' *current* execution,
// which moving it outside the loop's control flow can break.
public static class IRLoopInvariantCodeMotion
{
    public static bool Run(List<IRBlock> blocks)
    {
        bool changed = false;
        var loopStack = new Stack<int>();

        for (int i = 0; i < blocks.Count; i++)
        {
            IRStatement first = blocks[i].Statements[0];

            if (first is IRStatement.IRLoop)
            {
                loopStack.Push(i);
            }
            else if (first is IRStatement.IREndLoop && loopStack.Count > 0)
            {
                int headerIdx = loopStack.Pop();

                if (headerIdx > 0 && HoistLoop(blocks, headerIdx, i))
                    changed = true;
            }
        }

        return changed;
    }

    private static bool HoistLoop(List<IRBlock> blocks, int headerIdx, int endLoopIdx)
    {
        IRBlock preheader = blocks[headerIdx - 1];
        List<IRBlock> body = blocks.GetRange(headerIdx, endLoopIdx - headerIdx + 1);

        var definedInLoop = new HashSet<IRStorageLocation>();
        foreach (IRBlock b in body)
            foreach (IRStatement s in b.Statements)
                foreach (IRRegister r in s.Defines)
                    foreach (IRStorageLocation loc in IRStorageLocation.WriteLocationsOf(r))
                        definedInLoop.Add(loc);

        bool changed = false;
        bool progress = true;

        // Fixed point: hoisting A can make a statement that depends only
        // on A (and other already-invariant values) hoistable too.
        while (progress)
        {
            progress = false;

            foreach (IRBlock b in body)
            {
                for (int i = 0; i < b.Statements.Count; i++)
                {
                    IRStatement stmt = b.Statements[i];

                    if (!IsHoistable(stmt))
                        continue;

                    bool invariant = stmt.Uses
                        .SelectMany(IRStorageLocation.ReadLocationsOf)
                        .All(loc => !definedInLoop.Contains(loc));

                    if (!invariant)
                        continue;

                    b.Statements.RemoveAt(i);
                    preheader.Statements.Add(stmt);

                    foreach (IRRegister r in stmt.Defines)
                        foreach (IRStorageLocation loc in IRStorageLocation.WriteLocationsOf(r))
                            definedInLoop.Remove(loc);

                    changed = true;
                    progress = true;
                    i--; // re-check what's now at this index after the removal
                }
            }
        }

        return changed;
    }

    private static bool IsHoistable(IRStatement stmt)
    {
        if (stmt is not IRStatement.IRAssignment a)
            return false;

        // Bare reads/constants aren't worth relocating; texture samples
        // are never safe to relocate (see class remarks).
        return a.Expression is not IRExpression.RegisterExpression
            and not IRExpression.ConstantExpression
            and not IRExpression.TextureOperationExpression;
    }
}
