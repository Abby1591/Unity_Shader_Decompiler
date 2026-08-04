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

        // Populated only when Run(..., dumpStages: true) is used — one
        // text snapshot of every statement, taken right after each named
        // phase finishes. Diff consecutive entries to find exactly which
        // phase introduces a given piece of corruption.
        public List<(string Phase, string Text)> StageDumps { get; } = new();
    }

    public static Result Run(DxbcFile file, bool dumpStages = false)
    {
        var stageDumps = new List<(string Phase, string Text)>();

        void Snapshot(string phase, List<IRBlock> blocks)
        {
            if (!dumpStages)
                return;

            var text = new System.Text.StringBuilder();
            foreach (IRBlock block in blocks)
                foreach (IRStatement stmt in block.Statements)
                    text.AppendLine(stmt.ToString());

            stageDumps.Add((phase, text.ToString()));
        }

        // 1. Decode -> flat IR (no control flow structure yet)
        var builder = new IRBuilder();
        IRProgram program = builder.Build(file.Shader!);

        // 2. Split into basic blocks and wire up predecessors/successors
        List<IRBlock> blocks = IRBlockBuilder.Build(program);
        IRControlFlowGraphBuilder.Connect(blocks);
        Snapshot("01-cfg (pre-SSA)", blocks);

        // 3. SSA construction: dominators -> dominance frontier -> phi
        //    placement -> renaming
        IRDominatorInfo dom = IRDominatorAnalysis.Compute(blocks);
        Dictionary<IRBlock, HashSet<IRBlock>> frontier = IRDominanceFrontierAnalysis.Compute(blocks, dom);
        IRPhiInsertion.InsertPhis(blocks, frontier);
        Snapshot("02-phi-insertion (pre-rename)", blocks);
        IRSsaRenaming.Rename(blocks, dom);
        Snapshot("03-ssa-renamed (pre-optimize)", blocks);

        // 4. Optimize to a fixed point (constant folding through SCCP —
        //    see IROptimizationPipeline for the exact pass order). This
        //    re-verifies SSA internally and returns that result. When
        //    dumping, snapshot after every individual pass/iteration —
        //    coarse before/after snapshots aren't enough to tell which of
        //    the 9 passes (or which fixed-point round) introduces a given
        //    change.
        IRSsaVerificationResult ssaResult = IROptimizationPipeline.Run(
            blocks, dom,
            onPass: dumpStages ? (name, b) => Snapshot($"04-optimize-{name}", b) : null);
        Snapshot("04-optimized", blocks);

        // 5. Shader-specific pattern recognition — matrix/vector/texture
        //    rewrites need the optimizer's fixed point already reached
        //    (see IRShaderPatternRecognition for why), and loop detection
        //    is read-only so it doesn't matter when it runs relative to
        //    the others, but doing it here means it sees the same
        //    simplified shape as everything else.
            IRShaderPatternRecognition.Run(blocks);
            Snapshot("05-pattern-recognized", blocks);
            List<IRLoopPatternRecognition.LoopInfo> loops = IRShaderPatternRecognition.DetectLoops(blocks);

            // Pattern recognition can rewrite/discard defs — must re-verify before
            // leaving SSA, since IRLeaveSsa is the last point version info exists.
            IRSsaVerificationResult postPatternResult = IRSsaVerifier.Verify(blocks);
            // Merge any new errors found after pattern recognition into the
            // earlier SSA verification result so the pipeline's final
            // SsaVerification reflects the actual state of the final IR.
            foreach (string err in postPatternResult.Errors)
                ssaResult.Errors.Add(err);

        // 6. Leave SSA (phi elimination) — after this point register
        //    versions are gone, so nothing past here should need dom/SSA
        //    info again.
        IRLeaveSsa.Run(blocks);
        Snapshot("06-left-ssa", blocks);

        // 7. Attach human-readable names from RDEF/ISGN/OSGN. Last,
        //    deliberately — see IRMetadataBinding.
        IRShaderPatternRecognition.BindMetadata(blocks, program, file);
        Snapshot("07-metadata-bound", blocks);

        var result = new Result
        {
            Program = program,
            Blocks = blocks,
            SsaVerification = ssaResult,
            RecognizedLoops = loops,
        };
        result.StageDumps.AddRange(stageDumps);
        return result;
    }
}