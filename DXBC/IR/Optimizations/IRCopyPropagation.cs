using Parser.DXBC.IR;
using Parser.DXBC.IR.Analysis;

namespace Parser.DXBC.IR.Optimizations;

// Phase 9.3: for every SSA value whose sole definition is a plain copy
// of another register (a = b), replaces reads of `a` with `b` directly
// and drops the copy (DCE picks up anything this makes unreachable
// afterward — this pass only rewires reads).
public static class IRCopyPropagation
{
    public static bool Run(List<IRBlock> blocks)
    {
        var copies = new Dictionary<IRStorageLocation, IRRegister>();

        foreach (IRBlock block in blocks)
        {
            foreach (IRStatement stmt in block.Statements)
            {
                if (stmt is not IRStatement.IRAssignment { Expression: IRExpression.RegisterExpression src } a)
                    continue;

                foreach (IRStorageLocation loc in IRStorageLocation.WriteLocationsOf(a.Destination))
                {
                    int? version = a.Destination.SsaVersion[IRStorageLocation.ComponentToIndex(loc.Component)];
                    if (version is null)
                        continue;

                    copies[loc] = src.Register;
                }
            }
        }

        if (copies.Count == 0)
            return false;

        bool changed = false;

        foreach (IRBlock block in blocks)
        {
            for (int i = 0; i < block.Statements.Count; i++)
            {
                IRStatement original = block.Statements[i];

                if (original is IRStatement.IRPhi)
                    continue; // see IRConstantPropagation — same reasoning

                IRStatement rewritten = IRStatementRewriter.RewriteExpressions(original, e => Substitute(e, copies));

                if (rewritten.ToString() != original.ToString())
                {
                    block.Statements[i] = rewritten;
                    changed = true;
                }
            }
        }

        return changed;
    }

    private static IRExpression Substitute(IRExpression expr, Dictionary<IRStorageLocation, IRRegister> copies)
    {
        if (expr is not IRExpression.RegisterExpression re)
            return expr;

        List<IRStorageLocation> locs = IRStorageLocation.ReadLocationsOf(re.Register).ToList();
        if (locs.Count != 1)
            return expr; // only chase the simple single-component case

        if (!copies.TryGetValue(locs[0], out IRRegister? source))
            return expr;

        // Don't chase through a copy whose source was itself never
        // renamed (e.g. reads straight off an input) — nothing gained.
        return new IRExpression.RegisterExpression { Register = source };
    }
}
