using Parser.DXBC.IR;

namespace Parser.DXBC.IR.Optimizations;

// Phase 9.12: once constant folding / SCCP has proven an IRIf's condition
// is a compile-time constant, the branch itself is dead weight — control
// only ever goes one way. This prunes the CFG edge to the side that can
// never execute and drops the now-meaningless IRIf statement, leaving the
// block to fall straight through to its one remaining successor (the same
// implicit-fallthrough shape any other non-branching block already has).
//
// This only touches the CFG (blocks/edges) — it does not delete the dead
// branch's statements or merge blocks back together. That's IRCfgCleanup's
// job, deliberately kept separate so each pass stays a single, re-runnable
// concern (see IRCfgCleanup for why they need to alternate).
public static class IRBranchSimplification
{
    public static bool Run(List<IRBlock> blocks)
    {
        bool changed = false;

        foreach (IRBlock block in blocks)
        {
            if (block.Statements.Count == 0)
                continue;

            if (block.Statements[^1] is not IRStatement.IRIf ifStmt)
                continue;

            // SCCP only ever proves executability for a block that ends in
            // IRIf with exactly two successors (see its VisitBlock) — same
            // precondition here, so we're never misreading an already-
            // simplified (single-successor) if as still having two sides.
            if (block.Successors.Count != 2)
                continue;

            if (!TryGetTruthiness(ifStmt.Condition, out bool truthy))
                continue;

            IRBlock dead = block.Successors[truthy ? 1 : 0];

            IRCfgEdges.RemoveEdge(block, dead);
            block.Statements.RemoveAt(block.Statements.Count - 1);

            changed = true;
        }

        return changed;
    }

    private static bool TryGetTruthiness(IRExpression condition, out bool truthy)
    {
        truthy = false;

        if (condition is not IRExpression.ConstantExpression c)
            return false;

        if (c.Kind == IRExpression.ConstantExpression.ConstantKind.Double)
        {
            if (c.DoubleValues.Length == 0)
                return false;

            truthy = c.DoubleValues[0] != 0;
            return true;
        }

        if (c.RawValues.Length == 0)
            return false;

        // Same convention as IRSparseConditionalConstantPropagation: DXBC
        // treats bool as int/uint, nonzero is true.
        truthy = c.RawValues[0] != 0;
        return true;
    }
}