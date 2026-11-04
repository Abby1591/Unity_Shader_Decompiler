using Parser.DXBC.IR;

namespace Parser.Core.Optimizations;

// Shared by every pass that needs to substitute or fold pieces of an
// expression tree: IRExpression nodes are immutable (init-only
// properties), so "changing" one means reconstructing it and everything
// above it. This walks bottom-up, rebuilding each node with its
// (already-rewritten) children, then calls `transform` on the rebuilt
// node — so `transform` only ever has to answer "is this one node,
// right here, something I can replace", never how to walk a tree.
public static class IRExpressionRewriter
{
    public static IRExpression? Rewrite(IRExpression? expr, Func<IRExpression, IRExpression> transform)
    {
        if (expr is null)
            return null;

        IRExpression rebuilt = expr switch
        {
            IRExpression.RegisterExpression or IRExpression.ConstantExpression => expr,

            IRExpression.BinaryExpression be => new IRExpression.BinaryExpression
            {
                Operation = be.Operation,
                Left = Rewrite(be.Left, transform)!,
                Right = Rewrite(be.Right, transform)!,
            },

            IRExpression.UnaryExpression ue => new IRExpression.UnaryExpression
            {
                Operation = ue.Operation,
                Operand = Rewrite(ue.Operand, transform)!,
            },

            IRExpression.IntrinsicExpression ie => RebuildIntrinsic(ie, transform),

            IRExpression.FusedMultiplyAddExpression fma => new IRExpression.FusedMultiplyAddExpression
            {
                A = Rewrite(fma.A, transform)!,
                B = Rewrite(fma.B, transform)!,
                C = Rewrite(fma.C, transform)!,
            },

            IRExpression.MultiplyHighExpression mh => new IRExpression.MultiplyHighExpression
            {
                Left = Rewrite(mh.Left, transform)!,
                Right = Rewrite(mh.Right, transform)!,
                Signed = mh.Signed,
            },

            IRExpression.Multiply64Expression m64 => new IRExpression.Multiply64Expression
            {
                Left = Rewrite(m64.Left, transform)!,
                Right = Rewrite(m64.Right, transform)!,
                Signed = m64.Signed,
            },

            IRExpression.BitFieldInsertExpression bfi => new IRExpression.BitFieldInsertExpression
            {
                Width = Rewrite(bfi.Width, transform)!,
                Offset = Rewrite(bfi.Offset, transform)!,
                Insert = Rewrite(bfi.Insert, transform)!,
                Base = Rewrite(bfi.Base, transform)!,
            },

            IRExpression.BitFieldExtractExpression bfe => new IRExpression.BitFieldExtractExpression
            {
                Width = Rewrite(bfe.Width, transform)!,
                Offset = Rewrite(bfe.Offset, transform)!,
                Value = Rewrite(bfe.Value, transform)!,
                Signed = bfe.Signed,
            },

            IRExpression.ConditionalExpression ce => new IRExpression.ConditionalExpression
            {
                Condition = Rewrite(ce.Condition, transform)!,
                TrueExpression = Rewrite(ce.TrueExpression, transform)!,
                FalseExpression = Rewrite(ce.FalseExpression, transform)!,
            },

            IRExpression.DotProductExpression dp => new IRExpression.DotProductExpression
            {
                Left = Rewrite(dp.Left, transform)!,
                Right = Rewrite(dp.Right, transform)!,
                Components = dp.Components,
            },

            IRExpression.SwizzleExpression sw => new IRExpression.SwizzleExpression
            {
                Value = Rewrite(sw.Value, transform)!,
                Components = sw.Components,
            },
            
            IRExpression.MatrixVectorMultiplyExpression mv => new IRExpression.MatrixVectorMultiplyExpression
            {
                Rows = mv.Rows,
                Vector = Rewrite(mv.Vector, transform)!,
            },

            IRExpression.TextureOperationExpression tex => new IRExpression.TextureOperationExpression
            {
                Operation = tex.Operation,
                Resource = tex.Resource,
                Sampler = tex.Sampler,
                Coordinates = Rewrite(tex.Coordinates, transform),
                Offset = Rewrite(tex.Offset, transform),
                LOD = Rewrite(tex.LOD, transform),
                Bias = Rewrite(tex.Bias, transform),
                CompareValue = Rewrite(tex.CompareValue, transform),
                GradX = Rewrite(tex.GradX, transform),
                GradY = Rewrite(tex.GradY, transform),
                SampleIndex = Rewrite(tex.SampleIndex, transform),
            },

            _ => expr, // unknown node type: leave untouched rather than guess at its shape
        };

        return transform(rebuilt);
    }

    private static IRExpression RebuildIntrinsic(
        IRExpression.IntrinsicExpression ie, Func<IRExpression, IRExpression> transform)
    {
        var rebuilt = new IRExpression.IntrinsicExpression { Intrinsic = ie.Intrinsic };

        foreach (IRExpression arg in ie.Arguments)
            rebuilt.Arguments.Add(Rewrite(arg, transform)!);

        return rebuilt;
    }
}
