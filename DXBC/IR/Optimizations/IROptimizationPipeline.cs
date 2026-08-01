using Parser.DXBC.IR;
using Parser.DXBC.IR.Analysis;

namespace Parser.DXBC.IR.Optimizations;

// Runs every Phase 9 pass to a fixed point, in the order the roadmap
// lays out. Each pass can expose new opportunities for the others
// (constant propagation exposes folds, folds expose dead code, DCE
// shrinks what value numbering has to hash, ...), so this loops until
// nothing changes rather than running each pass exactly once.
public static class IROptimizationPipeline
{
    public static IRSsaVerificationResult Run(List<IRBlock> blocks, IRDominatorInfo dom)
    {
        bool changed = true;
        int iterations = 0;

        // Guards against an unexpected non-terminating rewrite cycle
        // between passes rather than looping forever; 50 sweeps is far
        // more than any real shader should need to reach a fixed point.
        while (changed && iterations++ < 50)
        {
            changed = false;

            changed |= IRConstantFolding.Run(blocks);
            changed |= IRConstantPropagation.Run(blocks);
            changed |= IRCopyPropagation.Run(blocks);
            changed |= IRDeadCodeElimination.Run(blocks);
            changed |= IRAlgebraicSimplification.Run(blocks);
            changed |= IRValueNumbering.Run(blocks, dom);
            changed |= IRStrengthReduction.Run(blocks);
            changed |= IRLoopInvariantCodeMotion.Run(blocks);
            changed |= IRSparseConditionalConstantPropagation.Run(blocks);
        }

        // Every pass above is supposed to preserve SSA well-formedness —
        // this is what catches it immediately if one of them doesn't.
        return IRSsaVerifier.Verify(blocks);
    }
}
