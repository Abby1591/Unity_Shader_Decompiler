using Parser.DXBC;
using Parser.DXBC.IR;

namespace Parser.DXBC.IR.Optimizations;

// Roadmap position: "After SSA but before HLSL generation" — run this
// once IROptimizationPipeline.Run has reached its fixed point (so the
// mul/fma chains and copy-propagated registers these passes pattern-match
// on are already in their most-simplified form) and before handing the
// blocks to a backend/HLSL generator.
//
// Order matters: vector recognition folds row·vector dot-product chains
// (and, separately, normalize()) first, which is what gives matrix
// recognition the DotProductExpression nodes it groups into
// MatrixVectorMultiplyExpression. Texture recognition is independent of
// both and just tags along in the same fixed-point sweep. Loops to a
// fixed point because folding a row can occasionally simplify a
// neighboring statement enough to unblock the next match (e.g. once dead
// partial-sum temporaries drop out, two previously non-adjacent
// statements become adjacent).
//
// Loop recognition is deliberately NOT part of this rewrite loop — it's
// a non-destructive analysis (see IRLoopPatternRecognition) that reports
// canonical for-loop shapes without touching the blocks, so it's exposed
// separately via DetectLoops rather than folded into Run's changed-bool
// bookkeeping.
public static class IRShaderPatternRecognition
{
    public static bool Run(List<IRBlock> blocks)
    {
        bool changedOverall = false;
        bool changed = true;
        int iterations = 0;

        while (changed && iterations++ < 50)
        {
            changed = false;
            changed |= IRVectorPatternRecognition.Run(blocks);
            changed |= IRMatrixPatternRecognition.Run(blocks);
            changed |= IRTexturePatternRecognition.Run(blocks);
            changedOverall |= changed;
        }

        return changedOverall;
    }

    public static List<IRLoopPatternRecognition.LoopInfo> DetectLoops(List<IRBlock> blocks)
        => IRLoopPatternRecognition.Detect(blocks);

    // Call last, once Run() above has reached its fixed point — see
    // IRMetadataBinding for why naming has to come after shape settles
    // rather than before or during it.
    public static void BindMetadata(List<IRBlock> blocks, IRProgram program, DxbcFile file)
        => IRMetadataBinding.Run(blocks, program, file);
}