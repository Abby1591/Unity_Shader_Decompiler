using Parser.DXBC.IR;

namespace Parser.DXBC.IR.Optimizations;

// Phase 9.5: identity/annihilator rewrites — x+0, x*1, x*0, and their
// mirror images (0+x, 1*x, 0*x since DXBC operands aren't always
// canonically ordered). Runs as a bottom-up rewrite so it also cleans up
// whatever Constant Propagation/Folding exposed.
public static class IRAlgebraicSimplification
{
    public static bool Run(List<IRBlock> blocks)
    {
        bool changed = false;

        foreach (IRBlock block in blocks)
        {
            for (int i = 0; i < block.Statements.Count; i++)
            {
                IRStatement rewritten = IRStatementRewriter.RewriteExpressions(block.Statements[i], Simplify);

                if (rewritten.ToString() != block.Statements[i].ToString())
                {
                    block.Statements[i] = rewritten;
                    changed = true;
                }
            }
        }

        return changed;
    }

    private static IRExpression Simplify(IRExpression expr)
    {
        if (expr is not IRExpression.BinaryExpression be)
            return expr;

        bool leftIsConst = be.Left is IRExpression.ConstantExpression;
        bool rightIsConst = be.Right is IRExpression.ConstantExpression;

        switch (be.Operation)
        {
            case IRExpression.BinaryOperation.Add:
                if (rightIsConst && IRConstantMath.IsAllComponents((IRExpression.ConstantExpression)be.Right, 0)) return be.Left;
                if (leftIsConst && IRConstantMath.IsAllComponents((IRExpression.ConstantExpression)be.Left, 0)) return be.Right;
                break;

            case IRExpression.BinaryOperation.Subtract:
                if (rightIsConst && IRConstantMath.IsAllComponents((IRExpression.ConstantExpression)be.Right, 0)) return be.Left;
                break;

            case IRExpression.BinaryOperation.Multiply:
                if (rightIsConst && IRConstantMath.IsAllComponents((IRExpression.ConstantExpression)be.Right, 1)) return be.Left;
                if (leftIsConst && IRConstantMath.IsAllComponents((IRExpression.ConstantExpression)be.Left, 1)) return be.Right;
                if (rightIsConst && IRConstantMath.IsAllComponents((IRExpression.ConstantExpression)be.Right, 0)) return be.Right;
                if (leftIsConst && IRConstantMath.IsAllComponents((IRExpression.ConstantExpression)be.Left, 0)) return be.Left;
                break;

            case IRExpression.BinaryOperation.Divide:
            case IRExpression.BinaryOperation.UnsignedDivide:
                if (rightIsConst && IRConstantMath.IsAllComponents((IRExpression.ConstantExpression)be.Right, 1)) return be.Left;
                break;
        }

        return expr;
    }
}
