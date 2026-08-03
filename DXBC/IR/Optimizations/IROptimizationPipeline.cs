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
    public static IRSsaVerificationResult Run(List<IRBlock> blocks, IRDominatorInfo dom, Action<string, List<IRBlock>>? onPass = null)
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
            onPass?.Invoke($"iter{iterations}-1-ConstantFolding", blocks);

            changed |= IRConstantPropagation.Run(blocks);
            onPass?.Invoke($"iter{iterations}-2-ConstantPropagation", blocks);

            changed |= IRCopyPropagation.Run(blocks);
            onPass?.Invoke($"iter{iterations}-3-CopyPropagation", blocks);

            changed |= IRDeadCodeElimination.Run(blocks);
            onPass?.Invoke($"iter{iterations}-4-DeadCodeElimination", blocks);

            changed |= IRAlgebraicSimplification.Run(blocks);
            onPass?.Invoke($"iter{iterations}-5-AlgebraicSimplification", blocks);

            changed |= IRValueNumbering.Run(blocks, dom);
            onPass?.Invoke($"iter{iterations}-6-ValueNumbering", blocks);

            changed |= IRStrengthReduction.Run(blocks);
            onPass?.Invoke($"iter{iterations}-7-StrengthReduction", blocks);

            changed |= IRLoopInvariantCodeMotion.Run(blocks);
            onPass?.Invoke($"iter{iterations}-8-LoopInvariantCodeMotion", blocks);

            changed |= IRSparseConditionalConstantPropagation.Run(blocks);
            onPass?.Invoke($"iter{iterations}-9-SCCP", blocks);
        }

        // Every pass above is supposed to preserve SSA well-formedness —
        // this is what catches it immediately if one of them doesn't.
        return IRSsaVerifier.Verify(blocks);
    }
}