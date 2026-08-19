using Parser.DXBC.IR;
using Parser.Core.Analysis;

namespace Parser.Core.Optimizations;

// Phase 9.14: collapses a phi whose operands don't actually merge more than
// one distinct value — either every operand is literally the same register
// (phi(a, a)) or every operand besides a self-referencing back-edge
// resolves to one value (phi(a, a_from_the_loop_back_edge)). CFG cleanup
// and branch simplification create these constantly (an if/else that used
// to produce two different values now only has one live predecessor left,
// a loop's back-edge value turns out to equal its entry value, ...), so
// this needs to sit in the fixed-point loop alongside them rather than run
// once at the end.
public static class IRPhiSimplification
{
    public static bool Run(List<IRBlock> blocks)
    {
        var replacements = new Dictionary<(IRStorageLocation Loc, int Version), IRRegister>();
        var trivialPhis = new List<(IRBlock Block, IRStatement.IRPhi Phi)>();

        foreach (IRBlock block in blocks)
        {
            foreach (IRStatement stmt in block.Statements)
            {
                if (stmt is not IRStatement.IRPhi phi || phi.Operands.Count == 0)
                    continue;

                if (!TryGetTrivialValue(phi, out IRRegister? distinct))
                    continue;

                trivialPhis.Add((block, phi));

                foreach (IRStorageLocation loc in IRStorageLocation.WriteLocationsOf(phi.Destination))
                {
                    int? version = phi.Destination.SsaVersion[IRStorageLocation.ComponentToIndex(loc.Component)];
                    if (version is not null)
                        replacements[(loc, version.Value)] = distinct!;
                }
            }
        }

        if (trivialPhis.Count == 0)
            return false;

        foreach ((IRBlock block, IRStatement.IRPhi phi) in trivialPhis)
            block.Statements.Remove(phi);

        // Other phis can reference a now-eliminated phi's result as one of
        // their own operands (classic loop-carried shape) — Operands isn't
        // an IRExpression, so the generic statement rewriter below can't
        // reach it (same reasoning as IRConstantPropagation/IRCopyPropagation);
        // it needs its own substitution pass over phi operand lists.
        foreach (IRBlock block in blocks)
        {
            foreach (IRStatement stmt in block.Statements)
            {
                if (stmt is not IRStatement.IRPhi phi)
                    continue;

                for (int p = 0; p < phi.Operands.Count; p++)
                {
                    IRRegister operand = phi.Operands[p];
                    List<IRStorageLocation> locs = IRStorageLocation.ReadLocationsOf(operand).ToList();
                    if (locs.Count != 1)
                        continue;

                    int? version = operand.SsaVersion[IRStorageLocation.ComponentToIndex(locs[0].Component)];
                    if (version is not null && replacements.TryGetValue((locs[0], version.Value), out IRRegister? source))
                        phi.Operands[p] = source;
                }
            }
        }

        foreach (IRBlock block in blocks)
        {
            for (int i = 0; i < block.Statements.Count; i++)
            {
                IRStatement original = block.Statements[i];

                if (original is IRStatement.IRPhi)
                    continue;

                IRStatement rewritten = IRStatementRewriter.RewriteExpressions(original, e => Substitute(e, replacements));

                if (rewritten.ToString() != original.ToString())
                    block.Statements[i] = rewritten;
            }
        }

        return true;
    }

    // A phi is trivial when, ignoring operands that just refer back to its
    // own value (self-referencing back-edges), every remaining operand is
    // the same register. Comparing via ToString() (rather than a value
    // equality this codebase doesn't define on IRRegister) is the same
    // convention IRCopyPropagation/IRConstantPropagation already use to
    // detect "nothing actually changed" after a rewrite.
    private static bool TryGetTrivialValue(IRStatement.IRPhi phi, out IRRegister? distinct)
    {
        string selfText = phi.Destination.ToString();
        distinct = null;

        foreach (IRRegister operand in phi.Operands)
        {
            if (operand.ToString() == selfText)
                continue;

            if (distinct is null)
                distinct = operand;
            else if (operand.ToString() != distinct.ToString())
            {
                distinct = null;
                return false;
            }
        }

        // All-self (every operand loops back to the phi itself) isn't a
        // value this phi can be replaced with — leave it for DCE to drop
        // once nothing reads it.
        return distinct is not null;
    }

    private static IRExpression Substitute(
        IRExpression expr, Dictionary<(IRStorageLocation Loc, int Version), IRRegister> replacements)
    {
        if (expr is not IRExpression.RegisterExpression re)
            return expr;

        List<IRStorageLocation> locs = IRStorageLocation.ReadLocationsOf(re.Register).ToList();
        if (locs.Count != 1)
            return expr;

        int? version = re.Register.SsaVersion[IRStorageLocation.ComponentToIndex(locs[0].Component)];

        if (version is null || !replacements.TryGetValue((locs[0], version.Value), out IRRegister? source))
            return expr;

        return new IRExpression.RegisterExpression { Register = source };
    }
}