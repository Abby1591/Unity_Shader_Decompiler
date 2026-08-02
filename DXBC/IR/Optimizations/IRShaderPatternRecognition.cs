using Parser.DXBC;

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
// MatrixVectorMultiplyExpression. Loops to a fixed point because folding
// a row can occasionally simplify a neighboring statement enough to
// unblock the next match (e.g. once dead partial-sum temporaries drop
// out, two previously non-adjacent statements become adjacent).
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
            changedOverall |= changed;
        }

        return changedOverall;
    }
    
    // Call last, once Run() above has reached its fixed point — see
    // IRMetadataBinding for why naming has to come after shape settles
    // rather than before or during it.
    public static void BindMetadata(List<IRBlock> blocks, DxbcFile file)
        => IRMetadataBinding.Run(blocks, file);
}