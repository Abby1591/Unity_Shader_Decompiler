using Parser.DXBC.IR;

namespace Parser.Core.Optimizations;

// Post-SSA, pre-HLSL-generation pass (roadmap: "Texture recognition").
// TextureOperationExpression already models every sample/load/gather
// opcode faithfully as parsed, so there's no restructuring to do the way
// there is for matrix/vector patterns — the one real simplification
// available at the IR level is collapsing an explicit sample-at-LOD-0
// into a plain Sample, since that's the shape a backend would otherwise
// have to special-case anyway:
//
//   SampleLevel(coord, lod=0) -> Sample(coord)
//
// (SampleLevel with a non-zero or non-constant LOD stays as-is — that's
// a genuine explicit-LOD sample, e.g. Texture2D.SampleLevel(), not a
// plain tex2D()/Texture2D.Sample().)
public static class IRTexturePatternRecognition
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
        if (expr is not IRExpression.TextureOperationExpression
            {
                Operation: IRExpression.TextureOperation.SampleLevel,
                LOD: IRExpression.ConstantExpression lod,
            } tex)
        {
            return expr;
        }

        if (!IRConstantMath.IsAllComponents(lod, 0))
            return expr;

        return new IRExpression.TextureOperationExpression
        {
            Operation = IRExpression.TextureOperation.Sample,
            Resource = tex.Resource,
            Sampler = tex.Sampler,
            Coordinates = tex.Coordinates,
            Offset = tex.Offset,
            // LOD intentionally dropped: Sample has no LOD field — that's
            // the whole point of this rewrite.
            Bias = tex.Bias,
            CompareValue = tex.CompareValue,
            GradX = tex.GradX,
            GradY = tex.GradY,
            SampleIndex = tex.SampleIndex,
        };
    }
}