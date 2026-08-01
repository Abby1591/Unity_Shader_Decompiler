using Parser.DXBC.IR;

namespace Parser.DXBC.IR.Optimizations;

// Phase 9.1: folds a Binary/Unary node into a single ConstantExpression
// wherever both (or the one) operand(s) are already constants. Runs as a
// bottom-up tree rewrite so it also catches constants that only became
// adjacent after Constant Propagation ran.
public static class IRConstantFolding
{
    public static bool Run(List<IRBlock> blocks)
    {
        bool changed = false;

        foreach (IRBlock block in blocks)
        {
            for (int i = 0; i < block.Statements.Count; i++)
            {
                IRStatement rewritten = IRStatementRewriter.RewriteExpressions(block.Statements[i], Fold);

                if (!ReferenceEquals(rewritten, block.Statements[i]) && !StructurallyEqual(rewritten, block.Statements[i]))
                {
                    block.Statements[i] = rewritten;
                    changed = true;
                }
            }
        }

        return changed;
    }

    private static IRExpression Fold(IRExpression expr)
    {
        if (expr is IRExpression.BinaryExpression be
            && be.Left is IRExpression.ConstantExpression l
            && be.Right is IRExpression.ConstantExpression r
            && IRConstantMath.TryFoldBinary(be.Operation, l, r, out IRExpression.ConstantExpression? folded))
        {
            return folded!;
        }

        if (expr is IRExpression.UnaryExpression ue
            && ue.Operand is IRExpression.ConstantExpression c
            && IRConstantMath.TryFoldUnary(ue.Operation, c, out IRExpression.ConstantExpression? foldedU))
        {
            return foldedU!;
        }

        return expr;
    }

    // Cheap enough for a "did anything actually change" check without
    // wiring up full structural equality: a rewrite that changed nothing
    // still allocates fresh objects, so compare by rendered text instead.
    private static bool StructurallyEqual(IRStatement a, IRStatement b) => a.ToString() == b.ToString();
}
