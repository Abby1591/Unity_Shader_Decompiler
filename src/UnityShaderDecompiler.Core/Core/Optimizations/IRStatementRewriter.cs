using Parser.DXBC.IR;

namespace Parser.Core.Optimizations;

// Symmetric counterpart to IRExpressionRewriter: IRStatement subclasses
// are just as immutable (init-only properties) as IRExpression ones, so
// changing an expression buried in a statement means building a new
// statement object. Centralizing that here means every optimization
// pass just supplies a Func<IRExpression, IRExpression> and never has to
// know which property of which statement type holds which expression.
//
// Note: rebuilt statements get a fresh Id (IRStatement.Id is assigned in
// the base constructor) — the original Id doesn't carry over. That's a
// cosmetic cost (debug/verifier messages reference the new Id), not a
// correctness one.
public static class IRStatementRewriter
{
    public static IRStatement RewriteExpressions(IRStatement stmt, Func<IRExpression, IRExpression> transform)
    {
        IRExpression? R(IRExpression? e) => IRExpressionRewriter.Rewrite(e, transform);

        return stmt switch
        {
            IRStatement.IRAssignment a => new IRStatement.IRAssignment
            {
                Destination = a.Destination,
                Expression = R(a.Expression)!,
            },

            IRStatement.IRMultiAssignment ma => RebuildMultiAssignment(ma, R),

            IRStatement.IRIf s => new IRStatement.IRIf { Condition = R(s.Condition)! },

            IRStatement.IRSwitch s => new IRStatement.IRSwitch { Selector = R(s.Selector)! },

            IRStatement.IRCase s => new IRStatement.IRCase { Value = R(s.Value)! },

            IRStatement.IRDiscard s => new IRStatement.IRDiscard { Condition = R(s.Condition)! },

            IRStatement.IRCall s => new IRStatement.IRCall { Label = s.Label, Condition = R(s.Condition) },

            IRStatement.IRInterfaceCall s => new IRStatement.IRInterfaceCall
            {
                InterfaceIndex = s.InterfaceIndex,
                FunctionIndex = s.FunctionIndex,
                Condition = R(s.Condition),
            },

            IRStatement.IRBreak s => new IRStatement.IRBreak { Condition = R(s.Condition) },
            IRStatement.IRContinue s => new IRStatement.IRContinue { Condition = R(s.Condition) },
            IRStatement.IRReturn s => new IRStatement.IRReturn { Condition = R(s.Condition) },

            IRStatement.IRMemoryStore s => new IRStatement.IRMemoryStore
            {
                Resource = s.Resource,
                Address = R(s.Address)!,
                Value = R(s.Value)!,
            },

            IRStatement.IRAtomicOp s => new IRStatement.IRAtomicOp
            {
                Operation = s.Operation,
                Resource = s.Resource,
                Address = R(s.Address)!,
                Value = R(s.Value)!,
                CompareValue = R(s.CompareValue),
                ResultDestination = s.ResultDestination,
            },

            // Labels, else/endif/loop/endloop/switch markers, and phis
            // carry no expression fields — nothing for this to rewrite.
            _ => stmt,
        };
    }

    private static IRStatement RebuildMultiAssignment(
        IRStatement.IRMultiAssignment ma, Func<IRExpression?, IRExpression?> r)
    {
        var rebuilt = new IRStatement.IRMultiAssignment();
        rebuilt.Destinations.AddRange(ma.Destinations);

        foreach (IRExpression e in ma.Expressions)
            rebuilt.Expressions.Add(r(e)!);

        return rebuilt;
    }
}
