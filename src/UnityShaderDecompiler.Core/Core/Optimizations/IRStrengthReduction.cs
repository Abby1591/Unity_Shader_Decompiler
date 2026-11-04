using Parser.DXBC.IR;

namespace Parser.Core.Optimizations;

// Phase 9.7: replaces a multiply by a compile-time-constant power of two
// with a cheaper equivalent — a left shift for Int/UInt, or a self-add
// for Float (GPUs don't have a float shift, but float+float is cheaper
// than a full multiply on most architectures and skips a constant-bank
// fetch). Only fires when every component of the constant operand is the
// same value, so a vector multiply by a non-uniform constant is left
// alone rather than partially reduced.
public static class IRStrengthReduction
{
    public static bool Run(List<IRBlock> blocks)
    {
        bool changed = false;

        foreach (IRBlock block in blocks)
        {
            for (int i = 0; i < block.Statements.Count; i++)
            {
                IRStatement rewritten = IRStatementRewriter.RewriteExpressions(block.Statements[i], Reduce);

                if (rewritten.ToString() != block.Statements[i].ToString())
                {
                    block.Statements[i] = rewritten;
                    changed = true;
                }
            }
        }

        return changed;
    }

    private static IRExpression Reduce(IRExpression expr)
    {
        if (expr is not IRExpression.BinaryExpression { Operation: IRExpression.BinaryOperation.Multiply } be)
            return expr;

        IRExpression? variable = null;
        IRExpression.ConstantExpression? constant = null;

        if (be.Right is IRExpression.ConstantExpression rc) { variable = be.Left; constant = rc; }
        else if (be.Left is IRExpression.ConstantExpression lc) { variable = be.Right; constant = lc; }

        if (variable is null || constant is null || constant.RawValues.Length == 0)
            return expr;

        if (constant.Kind is IRExpression.ConstantExpression.ConstantKind.Int or IRExpression.ConstantExpression.ConstantKind.UInt)
        {
            uint v = constant.RawValues[0];
            if (!constant.RawValues.All(x => x == v))
                return expr;

            int shift = PowerOfTwoShift(v);
            if (shift <= 0)
                return expr;

            return new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.LeftShift,
                Left = variable,
                Right = new IRExpression.ConstantExpression
                {
                    Kind = constant.Kind,
                    RawValues = new uint[] { (uint)shift },
                },
            };
        }

        if (constant.Kind == IRExpression.ConstantExpression.ConstantKind.Float
            && IRConstantMath.IsAllComponents(constant, 2))
        {
            return new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.Add,
                Left = variable,
                Right = variable,
            };
        }

        return expr;
    }

    // Returns the shift amount if v is a power of two greater than 1,
    // otherwise -1 (0 and 1 are handled by Algebraic Simplification, not
    // this pass, and 0/non-power-of-two obviously don't reduce cleanly).
    private static int PowerOfTwoShift(uint v)
    {
        if (v <= 1 || (v & (v - 1)) != 0)
            return -1;

        int shift = 0;
        while (v > 1)
        {
            v >>= 1;
            shift++;
        }

        return shift;
    }
}
