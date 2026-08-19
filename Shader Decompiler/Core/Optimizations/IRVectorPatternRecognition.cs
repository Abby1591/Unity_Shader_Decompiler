using Parser.DXBC.Instructions;

using Parser.DXBC.IR;
namespace Parser.Core.Optimizations;

// Post-SSA, pre-HLSL-generation pass (roadmap: "Vector pattern recognition").
// Runs in two passes, bottom-up like every other expression rewrite:
//
//   1. Dot-chain folding — turns a manually-expanded dot product such as
//        r0 = m00*v.x
//        r0 = fma(m01, v.y, r0)
//        r0 = fma(m02, v.z, r0)
//        r0 = fma(m03, v.w, r0)
//      (already inlined into one nested FMA tree by Copy Propagation /
//      Value Numbering by the time this runs) back into a single
//      DotProductExpression. This also does double duty as the first
//      half of matrix recognition — see IRMatrixPatternRecognition.
//
//   2. normalize() recognition — v * rsqrt(dot(v, v)) (either operand
//      order) collapses to normalize(v).
//
// Both rewrites are purely structural (no numeric evaluation), so they're
// safe to run even when the operands aren't compile-time constants.
public static class IRVectorPatternRecognition
{
    public static bool Run(List<IRBlock> blocks)
    {
        bool changed = false;

        foreach (IRBlock block in blocks)
        {
            for (int i = 0; i < block.Statements.Count; i++)
            {
                IRStatement rewritten = IRStatementRewriter.RewriteExpressions(block.Statements[i], Recognize);

                if (rewritten.ToString() != block.Statements[i].ToString())
                {
                    block.Statements[i] = rewritten;
                    changed = true;
                }
            }
        }

        return changed;
    }

    private static IRExpression Recognize(IRExpression expr)
    {
        if (expr is IRExpression.FusedMultiplyAddExpression or IRExpression.BinaryExpression { Operation: IRExpression.BinaryOperation.Add })
        {
            IRExpression? folded = TryFoldDotChain(expr);
            if (folded is not null)
                expr = folded;
        }

        if (expr is IRExpression.BinaryExpression { Operation: IRExpression.BinaryOperation.Multiply } mul)
        {
            IRExpression? normalized = TryRecognizeNormalize(mul.Left, mul.Right)
                ?? TryRecognizeNormalize(mul.Right, mul.Left);

            if (normalized is not null)
                return normalized;
        }

        return expr;
    }

    // v * rsqrt(dot(v, v)) -> normalize(v). `dotSide` is checked for the
    // rsqrt(dot(x,x)) shape; `vectorSide` must be the same vector as x.
    private static IRExpression? TryRecognizeNormalize(IRExpression vectorSide, IRExpression dotSide)
    {
        if (dotSide is not IRExpression.IntrinsicExpression { Intrinsic: IRExpression.IRIntrinsic.Rsqrt } rsqrt)
            return null;

        if (rsqrt.Arguments.Count != 1 || rsqrt.Arguments[0] is not IRExpression.DotProductExpression dot)
            return null;

        if (!StructurallyEqual(dot.Left, dot.Right))
            return null;

        if (!StructurallyEqual(dot.Left, vectorSide))
            return null;

        var normalize = new IRExpression.IntrinsicExpression { Intrinsic = IRExpression.IRIntrinsic.Normalize };
        normalize.Arguments.Add(vectorSide);
        return normalize;
    }

    // Flattens a mul/fma tree into its (a, b) product terms and, if every
    // term multiplies "the same base register, one component at a time"
    // against "another same base register, one component at a time" —
    // covering every component exactly once — folds the whole tree into
    // a single DotProductExpression.
    private static IRExpression? TryFoldDotChain(IRExpression expr)
    {
        List<(IRExpression A, IRExpression B)>? terms = ExtractProductTerms(expr);
        if (terms is null || terms.Count < 2)
            return null;

        IRRegister? leftBase = TryGetComponentSeries(terms.Select(t => t.A).ToList());
        IRRegister? rightBase = TryGetComponentSeries(terms.Select(t => t.B).ToList());

        if (leftBase is null || rightBase is null)
            return null;

        return new IRExpression.DotProductExpression
        {
            Left = new IRExpression.RegisterExpression { Register = leftBase },
            Right = new IRExpression.RegisterExpression { Register = rightBase },
            Components = terms.Count,
        };
    }

    private static List<(IRExpression, IRExpression)>? ExtractProductTerms(IRExpression? expr)
    {
        switch (expr)
        {
            case IRExpression.BinaryExpression { Operation: IRExpression.BinaryOperation.Multiply } mul:
                return new List<(IRExpression, IRExpression)> { (mul.Left, mul.Right) };

            case IRExpression.FusedMultiplyAddExpression fma:
            {
                List<(IRExpression, IRExpression)>? rest = ExtractProductTerms(fma.C) ?? new List<(IRExpression, IRExpression)>();

                // fma.C might be a plain non-product base case (e.g. the
                // very first partial sum r0 = m00*v.x, folded via the
                // Multiply case above already) or another fma/add — either
                // way rest already reflects it via recursion; if C wasn't
                // decomposable at all (e.g. a lone register/constant),
                // ExtractProductTerms(C) returns null above, so treat that
                // as "no more terms" only when C itself is not a product.
                var terms = new List<(IRExpression, IRExpression)> { (fma.A, fma.B) };
                terms.AddRange(rest);
                return terms;
            }

            case IRExpression.BinaryExpression { Operation: IRExpression.BinaryOperation.Add } add:
            {
                List<(IRExpression, IRExpression)>? left = ExtractProductTerms(add.Left);
                List<(IRExpression, IRExpression)>? right = ExtractProductTerms(add.Right);

                if (left is null || right is null)
                    return null;

                left.AddRange(right);
                return left;
            }

            default:
                return null;
        }
    }

    // Checks that every expression in `series` is a RegisterExpression
    // over the same underlying register (same type/index/indices),
    // selecting a single component (Select1), and that the components
    // selected are exactly 0..series.Count-1 in that order — i.e. this is
    // "the same register, read one component at a time, in order". If so,
    // returns a clone of that register covering all of those components
    // as a single read (the shape a DotProductExpression operand wants).
    private static IRRegister? TryGetComponentSeries(List<IRExpression> series)
    {
        IRRegister? baseRegister = null;

        for (int i = 0; i < series.Count; i++)
        {
            if (series[i] is not IRExpression.RegisterExpression { Register: { ComponentMode: Operand.OperandComponentMode.Select1 } reg })
                return null;

            if (reg.Component != i)
                return null;

            if (baseRegister is null)
            {
                baseRegister = reg;
            }
            else if (!SameUnderlyingRegister(baseRegister, reg))
            {
                return null;
            }
        }

        if (baseRegister is null)
            return null;

        byte mask = series.Count switch
        {
            2 => 0b0011,
            3 => 0b0111,
            _ => 0b1111,
        };

        var whole = new IRRegister
        {
            RegisterType = baseRegister.RegisterType,
            Type = baseRegister.Type,
            Index = baseRegister.Index,
            Mask = mask,
            ComponentMode = Operand.OperandComponentMode.Mask,
            Modifier = baseRegister.Modifier,
        };
        whole.Indices.AddRange(baseRegister.Indices);
        return whole;
    }

    private static bool SameUnderlyingRegister(IRRegister a, IRRegister b)
    {
        return a.RegisterType == b.RegisterType
            && a.Index == b.Index
            && a.Indices.SequenceEqual(b.Indices)
            && a.Modifier == b.Modifier;
    }

    private static bool StructurallyEqual(IRExpression a, IRExpression b)
    {
        return a.ToString() == b.ToString();
    }
}