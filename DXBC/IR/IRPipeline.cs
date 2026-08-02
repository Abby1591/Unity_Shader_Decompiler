using Parser.DXBC;
using Parser.DXBC.IR.Analysis;
using Parser.DXBC.IR.Optimizations;

namespace Parser.DXBC.IR;

// The one place that actually chains every phase together: raw
// instruction decode -> IR build -> CFG -> SSA -> optimize to a fixed
// point -> shader-specific pattern recognition -> leave SSA -> bind
// human-readable names from the container's own reflection metadata.
//
// Nothing upstream of this file calls any of that yet — IRBuilder,
// IRBlockBuilder, IRDominatorAnalysis, IROptimizationPipeline,
// IRShaderPatternRecognition, IRLeaveSsa, and IRMetadataBinding all
// exist and work, but until now nothing wired them into one call. This
// is that wiring, and it's the last thing standing between "the passes
// exist" and "there's an IR you can actually hand to an HLSL emitter."
public static class IRPipeline
{
    public sealed class Result
    {
        public required IRProgram Program { get; init; }
        public required List<IRBlock> Blocks { get; init; }
        public required IRSsaVerificationResult SsaVerification { get; init; }
        public required List<IRLoopPatternRecognition.LoopInfo> RecognizedLoops { get; init; }
    }

    public static Result Run(DxbcFile file)
    {
        // 1. Decode -> flat IR (no control flow structure yet)
        var builder = new IRBuilder();
        IRProgram program = builder.Build(file.Shader!);

        // 2. Split into basic blocks and wire up predecessors/successors
        List<IRBlock> blocks = IRBlockBuilder.Build(program);
        IRControlFlowGraphBuilder.Connect(blocks);

        // 3. SSA construction: dominators -> dominance frontier -> phi
        //    placement -> renaming
        IRDominatorInfo dom = IRDominatorAnalysis.Compute(blocks);
        Dictionary<IRBlock, HashSet<IRBlock>> frontier = IRDominanceFrontierAnalysis.Compute(blocks, dom);
        IRPhiInsertion.InsertPhis(blocks, frontier);
        IRSsaRenaming.Rename(blocks, dom);

        // 4. Optimize to a fixed point (constant folding through SCCP —
        //    see IROptimizationPipeline for the exact pass order). This
        //    re-verifies SSA internally and returns that result.
        IRSsaVerificationResult ssaResult = IROptimizationPipeline.Run(blocks, dom);

        // 5. Shader-specific pattern recognition — matrix/vector/texture
        //    rewrites need the optimizer's fixed point already reached
        //    (see IRShaderPatternRecognition for why), and loop detection
        //    is read-only so it doesn't matter when it runs relative to
        //    the others, but doing it here means it sees the same
        //    simplified shape as everything else.
        IRShaderPatternRecognition.Run(blocks);
        List<IRLoopPatternRecognition.LoopInfo> loops = IRShaderPatternRecognition.DetectLoops(blocks);

        // 6. Leave SSA (phi elimination) — after this point register
        //    versions are gone, so nothing past here should need dom/SSA
        //    info again.
        IRLeaveSsa.Run(blocks);

        // 7. Attach human-readable names from RDEF/ISGN/OSGN. Last,
        //    deliberately — see IRMetadataBinding.
        IRShaderPatternRecognition.BindMetadata(blocks, program, file);

        return new Result
        {
            Program = program,
            Blocks = blocks,
            SsaVerification = ssaResult,
            RecognizedLoops = loops,
        };
    }
}