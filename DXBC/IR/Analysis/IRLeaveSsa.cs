using Parser.DXBC.IR;

namespace Parser.DXBC.IR.Analysis;

// Phase 10 ("leave SSA" only — not full deconstruction into a
// register-allocated form): replaces every PHI with an equivalent copy
// inserted at the end of each predecessor block, then drops the PHI
// itself. Because SSA renaming (Phase 7) already gave every value a name
// that's used exactly once as a definition, a copy's destination here
// can never collide with another copy's source in the same predecessor
// — so no parallel-copy/swap sequencing is needed, unlike classic
// out-of-SSA translation for physical register allocation (that's a
// later, separate concern this doesn't attempt).
public static class IRLeaveSsa
{
    public static void Run(List<IRBlock> blocks)
    {
        foreach (IRBlock block in blocks)
        {
            List<IRStatement.IRPhi> phis = block.Statements.OfType<IRStatement.IRPhi>().ToList();
            if (phis.Count == 0)
                continue;

            for (int p = 0; p < block.Predecessors.Count; p++)
            {
                IRBlock pred = block.Predecessors[p];
                var copies = new List<IRStatement>();

                foreach (IRStatement.IRPhi phi in phis)
                {
                    if (p >= phi.Operands.Count)
                        continue; // malformed phi (IRSsaVerifier would've flagged it) — skip rather than crash

                    copies.Add(new IRStatement.IRAssignment
                    {
                        Destination = phi.Destination,
                        Expression = new IRExpression.RegisterExpression { Register = phi.Operands[p] },
                    });
                }

                InsertBeforeTerminator(pred, copies);
            }

            block.Statements.RemoveAll(s => s is IRStatement.IRPhi);
        }
    }

    private static void InsertBeforeTerminator(IRBlock pred, List<IRStatement> copies)
    {
        if (copies.Count == 0)
            return;

        int insertIndex = pred.Statements.Count;

        if (pred.Statements.Count > 0 && IsBranchLike(pred.Statements[^1]))
            insertIndex--;

        pred.Statements.InsertRange(insertIndex, copies);
    }

    // Statements that end a block by deciding where control goes next —
    // the copy has to execute before that decision, even if it means it
    // also (harmlessly) runs along a path that didn't strictly need it,
    // e.g. the fallthrough side of a conditional break.
    private static bool IsBranchLike(IRStatement stmt) => stmt is IRStatement.IRIf
        or IRStatement.IRBreak
        or IRStatement.IRContinue
        or IRStatement.IRReturn
        or IRStatement.IRSwitch
        or IRStatement.IRCall
        or IRStatement.IRInterfaceCall;
}
