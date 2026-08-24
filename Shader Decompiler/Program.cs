using System;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using Parser.DXBC;
using Parser.DXBC.Disassembly;
using Parser.DXBC.Extraction;
using AssetStudio;
using Parser.DXBC.IR;
using Parser.DXBC.Metadata;
using Parser.Core.Hlsl.Ast;

namespace Parser;

internal class Program
{
    static void Main(string[] args)
    {
        if (args.Contains("--run-spec-tests"))
        {
            SpecTestVectors.Run();
            return;
        }

        if (args.Contains("--verify-signatures"))
        {
            // Cross-check the ISGN parse against d3dcompiler's own signature
            // extraction across every shipped subprogram.
            string root = args.Length > 1 && Directory.Exists(args[1])
                ? args[1]
                : FindOutputRoot();
            SignatureCrossCheck.Run(root);
            return;
        }

        if (args.Contains("--strip-survivors"))
        {
            // Which DXBC chunks survive D3DStripShader(flags=7)?
            StripSurvivors.Run(FindOutputRoot());
            return;
        }

        if (args.Contains("--recompile-verify"))
        {
            // Recompile each decompiled HLSLPROGRAM pass with real
            // d3dcompiler and match its signatures against the shipped
            // bytecode — the gate that --surface-shaders waits on.
            string shader = args.Length > 1 && File.Exists(args[1])
                ? args[1]
                : Path.Combine(FindOutputRoot(), "PicaVoxel_PicaVoxel Diffuse.shader");
            RecompileVerify.Run(shader);
            return;
        }

        if (args.Contains("--recompile-verify-all"))
        {
            // Aggregate health across every decompiled .shader in the Output
            // root: one compile-rate + unmatched count instead of 39 runs.
            string root = args.Length > 1 && Directory.Exists(args[1])
                ? args[1]
                : FindOutputRoot();
            RecompileVerify.RunAll(root);
            return;
        }

        if (args.Contains("--disasm"))
        {
            // Dump every non-compute subprogram's DXBC disassembly to a
            // sibling <name>.disasm.txt for bytecode-level inspection.
            string target = args.Length > 1 && Directory.Exists(args[1])
                ? args[1]
                : FindOutputRoot();
            RecompileVerify.DumpDisasm(target);
            return;
        }

        // args[0] is a folder produced by Extract.py (blob.bin +
        // metadata.json + optional dummy.shader), or a direct blob.bin path.
        // No-args default: the HOLO_Holo input folder in the repo-root Output.
        string inputPath = args.Length > 0 ? args[0] : "../Output/HOLO_Holo";

        // Output root for the generated .shader (+ opt-in program*.bin/
        // .dxbc/.hlsl artifacts). Defaults to the project-local Output/ so
        // results are visible inside the IDE; --out-root overrides it.
        string outRoot = ProjectOutputRoot();
        int outRootFlag = Array.IndexOf(args, "--out-root");
        if (outRootFlag >= 0 && outRootFlag + 1 < args.Length)
            outRoot = args[outRootFlag + 1];

        ShaderProject project;

        if (Directory.Exists(inputPath))
        {
            try
            {
                project = ShaderProject.LoadFromFolder(inputPath);
            }
            catch (FileNotFoundException ex)
            {
                Console.WriteLine(
                    $"{ex.Message}. The default input folder '{inputPath}' needs " +
                    "blob.bin + metadata.json produced by Extract.py. Run " +
                    "`python Extract.py shaders_json/<name>.json --out-dir Output " +
                    "(--flat for a single root-level shader)` first, or pass the " +
                    "path to a folder/blob explicitly.");
                return;
            }
        }
        else if (File.Exists(inputPath))
        {
            // Legacy path: a bare blob.bin with no sibling metadata.
            string? dir = Path.GetDirectoryName(Path.GetFullPath(inputPath));
            string metaCandidate = Path.Combine(dir ?? ".", "metadata.json");

            if (!File.Exists(metaCandidate))
            {
                Console.WriteLine(
                    $"metadata.json not found next to {inputPath}. " +
                    "Run Extract.py to produce a proper Stage 0 output folder.");
                return;
            }

            project = ShaderProject.LoadFromFolder(dir!);
        }
        else
        {
            Console.WriteLine($"Input not found: {inputPath}");
            return;
        }

        Console.WriteLine("Unity Shader Parser");
        Console.WriteLine("-------------------");
        Console.WriteLine($"Shader: {project.Metadata.Name}");
        Console.WriteLine($"Properties: {project.Metadata.Properties.Count}");
        Console.WriteLine($"SubShaders: {project.Metadata.SubShaders.Count}");
        Console.WriteLine($"Dependencies: {project.Metadata.Dependencies.Count}");
        Console.WriteLine($"Dummy reference available: {project.DummyShaderSource != null}");
        Console.WriteLine();

        byte[] bytes = project.Blob;

        Console.WriteLine($"Blob Size: {bytes.Length} bytes");
        Console.WriteLine();

        using var stream = new MemoryStream(bytes);
        using var reader = new BinaryReader(stream);

        // Unity 2022.3.x
        int[] version = { 2022, 3, 62 };

        var program = new ShaderProgram(reader, version);

        Console.WriteLine($"SubPrograms: {program.entries.Length}");
        Console.WriteLine();

        for (int i = 0; i < program.entries.Length; i++)
        {
            var e = program.entries[i];

            Console.WriteLine(
                $"[{i}] Offset={e.Offset} Length={e.Length} Segment={e.Segment}");
        }

        Console.WriteLine();
        Console.WriteLine("Loading SubPrograms...");
        Console.WriteLine();

        program.Read(reader, 0);

        Directory.CreateDirectory(outRoot);

        // Stage 2 — shell (Shader/SubShaders/Passes/Properties) from
        // metadata.json alone. Functions get attached to pass slots below
        // as each subprogram's IR comes back from the pipeline.
        HlslShaderNode astShader = HlslAstBuilder.BuildShell(project.Metadata);

        // Stage 2 — subprogram functions are collected (not attached yet):
        // Unity serializes subprograms pass-by-pass, grouping each pass's
        // programs by stage (all vertex variants, then all fragment
        // variants, ...), with GLES programs first and DX11 after within a
        // stage group. A pass boundary is therefore a stage regression
        // (fragment -> vertex) in the serialized order. We collect every
        // mappable function with the data needed to recover those groups
        // and pair vertex/fragment variants by signature afterwards.
        List<HlslPassNode> allPasses = astShader.SubShaders
            .SelectMany(ss => ss.Passes)
            .ToList();
        var candidates = new List<SubprogramCandidate>();

        for (int i = 0; i < program.m_SubPrograms.Length; i++)
        {
            var sp = program.m_SubPrograms[i];

            Console.WriteLine($"========== SubProgram {i} ==========");

            if (sp == null)
            {
                Console.WriteLine("NULL");
                Console.WriteLine();
                continue;
            }

            Console.WriteLine($"Type     : {sp.m_ProgramType}");

            // DEBUG: keyword sets per subprogram
            if (args.Contains("--dump-keywords"))
                Console.WriteLine($"Keywords : [{string.Join(" | ", sp.m_Keywords)}]  Local: [{string.Join(" | ", sp.m_LocalKeywords ?? Array.Empty<string>())}]");
            Console.WriteLine($"Version  : {sp.m_Version}");
            Console.WriteLine($"Code Size: {sp.m_ProgramCode.Length}");

            // Debug artifacts (program{i}.bin/.dxbc/.hlsl) are opt-in via
            // --save-subprograms; the default run only writes the final .shader.
            bool saveSubprograms = args.Contains("--save-subprograms");

            if (saveSubprograms)
            {
                // Save raw Unity shader program
                string rawPath = Path.Combine(outRoot, $"program{i}.bin");
                File.WriteAllBytes(rawPath, sp.m_ProgramCode);

                Console.WriteLine($"Saved: {rawPath}");
            }

            try
            {
                // Classifier: kind + (for non-compute) the 0x26-byte header
                // of 4 per-class resource EXTENTS + flag byte. The header is
                // the only RDEF metadata guaranteed to survive the strip.
                UnityShaderBlob blob = UnityShaderBlob.Parse(sp.m_ProgramCode, "shipped");
                UnityNonComputeHeader? header = blob.Header;
                if (header is { } h)
                    Console.WriteLine(
                        $"Blob: kind={blob.Kind} tex={h.TextureExtent} cb={h.CbExtent} samp={h.SamplerExtent} " +
                        $"uav={h.UavExtent} flag={h.Flag} (DXBC@{h.DxbcOffset})");
                else if (blob.ComputeMetadata is { } cm)
                {
                    Console.WriteLine(
                        $"Blob: kind=Compute version={cm.Version} params={cm.ParamData.OuterCount} shaders={cm.ShaderEntries.Count}");
                    var e = cm.ShaderEntries.FirstOrDefault();
                    if (e is not null)
                        Console.WriteLine(
                            $"  '{e.Name}' threads=({e.ThreadGroupX},{e.ThreadGroupY},{e.ThreadGroupZ}) " +
                            $"dxbc={e.Dxbc.Length}B lists={e.ListA.Count}/{e.ListB.Count}/{e.ListC.Count}/{e.ListD.Count}");
                }

                byte[] dxbc = blob.Dxbc;

                Console.WriteLine($"DXBC Size: {dxbc.Length} bytes");

                var dxbcFile = new DxbcFile();
                dxbcFile.Load(dxbc);

                if (saveSubprograms)
                {
                    string dxbcPath = Path.Combine(outRoot, $"program{i}.dxbc");
                    File.WriteAllBytes(dxbcPath, dxbc);

                    Console.WriteLine($"Saved: {dxbcPath}");
                }
                
                bool dumpStages = args.Contains("--dump-stages");
                IRPipeline.Result pipelineResult = IRPipeline.Run(dxbcFile, dumpStages);

                if (dumpStages)
                {
                    foreach (var (phase, text) in pipelineResult.StageDumps)
                    {
                        Console.WriteLine($"==== {phase} ====");
                        Console.WriteLine(text);
                    }
                }

                Console.WriteLine("IR (post-optimization, pattern-recognized, metadata-bound)");
                Console.WriteLine("------------------------------------------------------------");

                foreach (var block in pipelineResult.Blocks)
                {
                    foreach (var stmt in block.Statements)
                    {
                        Console.WriteLine(stmt);
                    }
                }

                Console.WriteLine();

                if (!pipelineResult.SsaVerification.IsValid)
                {
                    Console.WriteLine("SSA verification FAILED:");
                    foreach (var error in pipelineResult.SsaVerification.Errors)
                        Console.WriteLine($"  {error}");
                    Console.WriteLine();
                }

                if (pipelineResult.RecognizedLoops.Count > 0)
                {
                    Console.WriteLine("Recognized loops:");
                    foreach (var loop in pipelineResult.RecognizedLoops)
                        Console.WriteLine($"  {loop}");
                    Console.WriteLine();
                }

                Console.WriteLine($"Length      : {dxbcFile.TotalLength}");
                Console.WriteLine($"Chunk Count : {dxbcFile.Chunks.Count}");
                Console.WriteLine();

                if (dxbcFile.InputSignature != null)
                {
                    Console.WriteLine($"ISGN Elements: {dxbcFile.InputSignature.Elements.Count}");
                    foreach (var warning in dxbcFile.InputSignature.Warnings)
                        Console.WriteLine(warning);
                    foreach (var element in dxbcFile.InputSignature.Elements)
                        Console.WriteLine(element);
                    Console.WriteLine();
                }

                if (dxbcFile.Shader != null)
                {
                    Console.WriteLine($"Shader Version Token : 0x{dxbcFile.Shader.VersionToken:X8}");
                    Console.WriteLine($"Instruction DWORDs   : {dxbcFile.Shader.DeclaredDwordCount}");
                    Console.WriteLine();
                    Console.WriteLine("Instructions");
                    Console.WriteLine("------------");

                    foreach (var inst in dxbcFile.Shader.Instructions)
                    {
                        Console.WriteLine($"{inst.Name,-20} Length={inst.Length}");

                        foreach (var operand in inst.Operands)
                        {
                            Console.WriteLine(operand);
                        }
                    }

                    foreach (var warning in dxbcFile.Shader.Warnings)
                        Console.WriteLine(warning);

                    Console.WriteLine();
                }

                Console.WriteLine($"IR statements: {pipelineResult.Program.Statements.Count}");

                // Stage 2 — build this subprogram's function node. The pass
                // it belongs to and the variant it pairs with are resolved
                // after the loop (see BuildVariantPasses), so just stash the
                // function + the data the pairing needs.
                HlslFunctionNode? function = HlslAstBuilder.BuildFunction(
                    $"program{i}",
                    sp.m_ProgramType,
                    pipelineResult.Program.Declarations,
                    pipelineResult.Blocks,
                    dxbcFile.InputSignature,
                    dxbcFile.OutputSignature);

                if (function is null)
                {
                    Console.WriteLine($"Stage 2: {sp.m_ProgramType} has no HLSL AST mapping (not DX11 SM4/5), skipped.");
                }
                else
                {
                    candidates.Add(new SubprogramCandidate
                    {
                        SubIndex = i,
                        Stage = function.Stage,
                        Function = function,
                        Pipeline = pipelineResult,
                        Dxbc = dxbcFile,
                        DxbcBytes = dxbc,
                        Header = header,
                        SigIn = InterfaceKey(dxbcFile.InputSignature?.Elements),
                        SigOut = InterfaceKey(dxbcFile.OutputSignature?.Elements),
                        SigInInterp = InterfaceInterpKey(dxbcFile.InputSignature?.Elements),
                        SigOutInterp = InterfaceInterpKey(dxbcFile.OutputSignature?.Elements),
                    });
                    Console.WriteLine($"Stage 2: collected {function.Stage} function '{function.Name}' (subprogram {i}).");
                }

                if (saveSubprograms)
                {
                    string hlsl = DxbcDisassembler.Disassemble(dxbc);
                    string hlslPath = Path.Combine(outRoot, $"program{i}.hlsl");
                    File.WriteAllText(hlslPath, hlsl);
                    Console.WriteLine($"Saved: {hlslPath}");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"No DXBC: {ex.Message}");
            }

            Console.WriteLine();
        }

        Console.WriteLine();

        // Stage 2b — recover the pass each candidate belongs to from the
        // serialization order and emit one pass per distinct compiled
        // (vertex, fragment) variant pair.
        BuildVariantPasses(astShader, allPasses, candidates);

        Console.WriteLine();
        Console.WriteLine("HLSL AST (Stage 2)");
        Console.WriteLine("-------------------");
        Console.WriteLine($"Shader '{astShader.Name}', {astShader.Properties.Count} properties, {astShader.SubShaders.Count} subshaders");
        foreach (HlslPassNode pass in astShader.SubShaders.SelectMany(ss => ss.Passes))
        {
            Console.WriteLine(
                $"  Pass '{pass.Name}': " +
                $"vert={pass.VertexFunction?.Name ?? "-"} frag={pass.FragmentFunction?.Name ?? "-"} " +
                $"structs={pass.Structs.Count} resources={pass.Resources.Count}");
        }

        bool surfaceReconstruct = !args.Contains("--no-surface-shaders");
        bool keepPasses = args.Contains("--keep-passes");
        bool keepRegisterBindings = args.Contains("--keep-register-bindings");

        PrintFullShaderOutput(project, astShader, !args.Contains("--no-fuse-temps"), surfaceReconstruct, keepPasses, keepRegisterBindings, outRoot);

        Console.WriteLine();
        Console.WriteLine("Finished.");
    }

    private static void PrintFullShaderOutput(ShaderProject project, HlslShaderNode astShader, bool fuseTemps, bool surfaceReconstruct, bool keepPasses, bool keepRegisterBindings, string outRoot)
    {
        string text = HlslPrettyPrinter.Print(astShader, fuseTemps, !keepRegisterBindings);

        // Stage 13.5 — surface-shader recognition: when a pass carries the
        // compiled signature of a `#pragma surface surf ...` source, rewrite
        // the lit pass back into the canonical CGPROGRAM surface form. The
        // original HLSLPROGRAM passes are kept as a comment only with
        // --keep-passes; by default the output is just the reconstructed
        // source so surface shaders match their original line count. Opt
        // out entirely with --no-surface-shaders.
        if (surfaceReconstruct)
        {
            string? reconstructed = HlslSurfaceShaderRecognizer.TryReconstruct(text, project.Metadata, keepPasses);
            if (reconstructed is not null)
            {
                text = reconstructed;
                Console.WriteLine("Stage 13.5: recognized Unity surface-shader boilerplate, rewrote lit pass to #pragma surface form.");
            }
        }

        string outPath = Path.Combine(outRoot, SafeFileName(astShader.Name) + ".shader");
        File.WriteAllText(outPath, text);
        Console.WriteLine();
        Console.WriteLine($"Stage 13/14: full shader written to {outPath} ({text.Length} chars)");
    }

    private static string SafeFileName(string name) =>
        string.Join("_", name.Split(Path.GetInvalidFileNameChars())).TrimEnd(' ', '.');

    // One mappable subprogram: the built function node plus everything
    // needed to group it into a pass and pair it with its counterpart
    // stage by interpolator hand-off (OSGN(vert) == ISGN(frag)).
    private sealed class SubprogramCandidate
    {
        public required int SubIndex;
        public required HlslShaderStage Stage;
        public required HlslFunctionNode Function;
        public required IRPipeline.Result Pipeline;
        public required DxbcFile Dxbc;
        public required byte[] DxbcBytes;
        public UnityNonComputeHeader? Header;
        public required string SigIn;
        public required string SigOut;
        // Interpolator-only keys (SystemValue == 0): the rasterized hand-off
        // set. Fragment inputs may add rasterizer system values (SV_IsFrontFace,
        // ...) the vertex never writes, so pairing compares these, not the
        // full signature.
        public required string SigInInterp;
        public required string SigOutInterp;
        public string Hash = "";
    }

// Signature identity for variant pairing. The vertex/fragment hand-off is
// the rasterized interpolator set, so the key is the exact ordered element
// sequence of the signature chunk: semantic name, index, system value and
// register. Component counts are deliberately excluded — a vertex writes
// every lane of an interpolator (OSGN mask) while the fragment reads only
// the lanes it uses (ISGN mask), so the two can legitimately differ for
// the same variant. Register numbers must match too — the rasterizer
// interpolates by register, so two programs with the same semantics in
// different registers do not link. The interpolator-only variant (system
// values dropped) is what variant pairing compares; see SubprogramCandidate.
private static string InterfaceKey(List<Parser.DXBC.Chunks.SignatureElement>? elements) =>
        elements is null
            ? ""
            : string.Join(";", elements.Select(e =>
                $"{e.SemanticName}:{e.SemanticIndex}:{e.SystemValue}:r{e.Register}"));
private static string InterfaceInterpKey(List<Parser.DXBC.Chunks.SignatureElement>? elements) =>
        elements is null
            ? ""
            : string.Join(";", elements
                .Where(e => e.SystemValue == 0)
                .Select(e => $"{e.SemanticName}:{e.SemanticIndex}:{e.SystemValue}:r{e.Register}"));

    // Stage rank in Unity's per-pass serialization order. A new pass begins
    // when the stage rank regresses in the serialized subprogram sequence.
    private static int StageRank(HlslShaderStage s) => s switch
    {
        HlslShaderStage.Vertex => 0,
        HlslShaderStage.Hull => 1,
        HlslShaderStage.Domain => 2,
        HlslShaderStage.Geometry => 3,
        HlslShaderStage.Fragment => 4,
        HlslShaderStage.Compute => 5,
        _ => 9,
    };

    // Stage 2b — the reverse of Unity's subprogram serialization. The blob
    // stores, per pass, all vertex variants, then all fragment variants
    // (GLES first, DX11 after within each stage block). The pass a
    // subprogram belongs to is recoverable from the stage sequence alone:
    // a stage regression (fragment -> vertex) starts the next pass. Within
    // a pass group, a vertex variant pairs with the fragment variant whose
    // input signature equals its output signature; byte-identical pairs are
    // deduplicated (multiple keyword sets can compile to the same program).
    // The first pair of each group fills the metadata shell pass (keeping
    // the pre-existing output for pass 0); every further pair becomes a
    // cloned pass with the same tags/render state right after the shell.
    private static void BuildVariantPasses(
        HlslShaderNode astShader, List<HlslPassNode> allPasses, List<SubprogramCandidate> candidates)
    {
        if (candidates.Count == 0)
            return;

        // Build texture property name mapping: texture properties (type=4) in
        // declaration order map to t-register slots (0, 1, 2, ...).  This lets
        // the decompiler emit "Texture2D _MainTex : register(t0)" instead of
        // "Texture2D t0 : register(t0)" — Unity needs variable names matching
        // the Properties block to bind textures at runtime.
        var textureNames = new Dictionary<uint, string>();
        uint texSlot = 0;
        foreach (HlslPropertyNode prop in astShader.Properties)
            if (prop.Kind == HlslPropertyKind.Texture)
                textureNames[texSlot++] = prop.Name;

        foreach (SubprogramCandidate c in candidates)
            c.Hash = Convert.ToHexString(SHA256.HashData(c.DxbcBytes));

        var groups = new List<List<SubprogramCandidate>>();
        foreach (SubprogramCandidate c in candidates)
        {
            if (groups.Count == 0)
            {
                groups.Add(new List<SubprogramCandidate> { c });
                continue;
            }
            if (StageRank(c.Stage) < StageRank(groups[^1][^1].Stage))
                groups.Add(new List<SubprogramCandidate> { c });
            else
                groups[^1].Add(c);
        }

        var subshaderByPass = new Dictionary<HlslPassNode, HlslSubShaderNode>();
        foreach (HlslSubShaderNode ss in astShader.SubShaders)
            foreach (HlslPassNode p in ss.Passes)
                subshaderByPass[p] = ss;

        int totalPasses = 0;

        for (int gi = 0; gi < groups.Count; gi++)
        {
            List<SubprogramCandidate> group = groups[gi];
            HlslPassNode shell = gi < allPasses.Count
                ? allPasses[gi]
                : allPasses[^1]; // more groups than metadata passes: reuse the last shell

            var verts = group.Where(c => c.Stage == HlslShaderStage.Vertex).ToList();
            var frags = group.Where(c => c.Stage == HlslShaderStage.Fragment).ToList();
            var others = group.Where(c => c.Stage is not (HlslShaderStage.Vertex or HlslShaderStage.Fragment)).ToList();

            // Pair by interpolator hand-off. The vertex and fragment must agree on the
            // interpolated set (the rasterized hand-off); the fragment may
            // additionally consume rasterizer-generated system values
            // (SV_IsFrontFace, ...) the vertex never writes, so the vertex
            // output is also required to be a subset of the fragment input.
            // Pairing is 1:1 — each vertex takes the first unused fragment it
            // links with (both are in serialized keyword-set order, so this
            // recovers Unity's original variant passes) and a fragment is
            // never reused. Byte-identical pairs therefore collapse and
            // genuinely unmatched variants are reported as folded.
            var pairs = new List<(SubprogramCandidate V, SubprogramCandidate F)>();
            var usedFrags = new HashSet<SubprogramCandidate>();
            var seen = new HashSet<(string, string)>();
            foreach (SubprogramCandidate v in verts)
            {
                string[] vertOut = v.SigOut.Split(';', StringSplitOptions.RemoveEmptyEntries);
                if (vertOut.Length == 0)
                    continue; // a vertex always writes interpolators; don't match an empty output
                foreach (SubprogramCandidate f in frags)
                {
                    if (usedFrags.Contains(f))
                        continue;
                    if (v.SigOutInterp == f.SigInInterp
                        && vertOut.All(f.SigIn.Split(';', StringSplitOptions.RemoveEmptyEntries).Contains)
                        && seen.Add((v.Hash, f.Hash)))
                    {
                        pairs.Add((v, f));
                        usedFrags.Add(f);
                        break;
                    }
                }
            }

            // First pair fills the shell pass; the rest get clones.
            for (int pi = 0; pi < pairs.Count; pi++)
            {
                var (v, f) = pairs[pi];
                HlslPassNode pass = pi == 0 ? shell : ClonePass(shell);
                if (!ReferenceEquals(pass, shell))
                {
                    HlslSubShaderNode ss = subshaderByPass[shell];
                    int insertAt = ss.Passes.IndexOf(shell) + 1;
                    ss.Passes.Insert(insertAt, pass);
                    subshaderByPass[pass] = ss;
                }

                AttachPassProgram(pass, v, textureNames);
                AttachPassProgram(pass, f, textureNames);
                totalPasses++;
            }

            // Stage functions that pair by position, not signature
            // (geometry/hull/domain/compute), attach to the shell pass.
            foreach (SubprogramCandidate o in others)
            {
                AttachPassProgram(shell, o, textureNames);
                totalPasses++;
            }

            if (pairs.Count == 0 && others.Count == 0)
            {
                Console.WriteLine($"  Pass group {gi}: {verts.Count} verts x {frags.Count} frags produced no renderable variant (skipped).");
            }
            else
            {
                int unpaired = verts.Count(v => !pairs.Any(p => ReferenceEquals(p.V, v)))
                             + frags.Count(f => !pairs.Any(p => ReferenceEquals(p.F, f)));
                Console.WriteLine(
                    $"  Pass group {gi}: {verts.Count} verts x {frags.Count} frags => {pairs.Count} distinct variant pass(es) " +
                    $"({unpaired} unpaired duplicate(s) folded)");
            }
        }

        Console.WriteLine($"BuildVariantPasses: {groups.Count} pass group(s), {totalPasses} pass(es) emitted total.");
    }

    // Attaches one candidate's function, resources and structs to a pass,
    // unioning cbuffer members the way the previous streaming loop did.
    private static void AttachPassProgram(HlslPassNode pass, SubprogramCandidate c, Dictionary<uint, string>? textureNames = null)
    {
        AttachFunction(pass, c.Function);

        var resources = HlslAstBuilder.BuildResources(
            c.Pipeline.Program.Declarations, c.Dxbc.ResourceDefinition, c.Pipeline.Blocks, pass.Cbuffers, c.Stage.ToString(), textureNames).ToList();
        foreach (HlslResourceNode res in resources)
        {
            HlslResourceNode? existing = pass.Resources.FirstOrDefault(r =>
                r.Kind == res.Kind && r.Slot == res.Slot);

            if (existing is null)
            {
                // Sampler name collision: two different sampler slots may both
                // map to the same texture property (e.g. s0 and s2 both serve
                // _MainTex).  Append the slot index to make the name unique.
                if (res.Kind == HlslResourceKind.Sampler
                    && pass.Resources.Any(r => r.Kind == HlslResourceKind.Sampler && r.Name == res.Name))
                {
                    res.Name = $"{res.Name}{res.Slot}";
                }
                pass.Resources.Add(res);
            }
            else if (res.Kind == HlslResourceKind.ConstantBuffer)
            {
                // vert/frag subprograms of one pass can touch different
                // slots of the same cbuffer, and each BuildResources call
                // only sees its own blocks. Union the members, keeping the
                // largest array size so the RDEF-less float4 fallback
                // covers every subprogram's accesses.
                foreach (HlslCBufferVariable v in res.Variables)
                {
                    HlslCBufferVariable? match = existing.Variables.FirstOrDefault(x => x.Name == v.Name);
                    if (match is null)
                    {
                        existing.Variables.Add(v);
                    }
                    else if (v.ArraySize is { } n && (match.ArraySize is not { } m || n > m))
                    {
                        existing.Variables.Remove(match);
                        existing.Variables.Add(v);
                    }
                }
            }
        }

        if (c.Function.InputStruct is not null) pass.Structs.Add(c.Function.InputStruct);
        if (c.Function.OutputStruct is not null) pass.Structs.Add(c.Function.OutputStruct);

        // Cross-check the compiler-proven header extents against the
        // metadata/IR-derived slot layout for THIS stage. resources was
        // built from this subprogram's own declarations, so each extent
        // should match exactly.
        if (c.Header is { } hdr)
        {
            int MaxPlus1(HlslResourceKind kind) =>
                resources.Where(r => r.Kind == kind).Select(r => (int)r.Slot)
                         .DefaultIfEmpty(-1).Max() + 1;
            int cb = MaxPlus1(HlslResourceKind.ConstantBuffer);
            int tex = MaxPlus1(HlslResourceKind.Texture);
            int samp = MaxPlus1(HlslResourceKind.Sampler);
            int uav = MaxPlus1(HlslResourceKind.Uav);
            Console.WriteLine(
                $"  Header verify ({c.Stage} subprogram {c.SubIndex}): " +
                $"cb {cb}/{hdr.CbExtent} {(cb == hdr.CbExtent ? "OK" : "MISMATCH")}  " +
                $"tex {tex}/{hdr.TextureExtent} {(tex == hdr.TextureExtent ? "OK" : "MISMATCH")}  " +
                $"samp {samp}/{hdr.SamplerExtent} {(samp == hdr.SamplerExtent ? "OK" : "MISMATCH")}  " +
                $"uav {uav}/{hdr.UavExtent} {(uav == hdr.UavExtent ? "OK" : "MISMATCH")}");
        }

        Console.WriteLine(
            $"Stage 2: attached {c.Stage} function '{c.Function.Name}' to pass '{pass.Name}' " +
            $"(in:{c.Function.InputStruct?.Fields.Count ?? 0} out:{c.Function.OutputStruct?.Fields.Count ?? 0} " +
            $"resources+{pass.Resources.Count})");
    }

    // A variant pass: same name/tags/render state and the same per-pass
    // cbuffer layout as the shell pass it was cloned from, but its own
    // function slots/resources/structs (filled by AttachPassProgram).
    private static HlslPassNode ClonePass(HlslPassNode src)
    {
        var clone = new HlslPassNode
        {
            Name = src.Name,
            RenderStateRaw = src.RenderStateRaw,
            State = src.State,
        };
        foreach (var (k, v) in src.Tags)
            clone.Tags[k] = v;
        foreach (var (k, v) in src.Cbuffers)
            clone.Cbuffers[k] = v;
        return clone;
    }

    private static void AttachFunction(HlslPassNode pass, HlslFunctionNode function)
    {
        switch (function.Stage)
        {
            case HlslShaderStage.Vertex: pass.VertexFunction = function; break;
            case HlslShaderStage.Fragment: pass.FragmentFunction = function; break;
            case HlslShaderStage.Geometry: pass.GeometryFunction = function; break;
            case HlslShaderStage.Hull: pass.HullFunction = function; break;
            case HlslShaderStage.Domain: pass.DomainFunction = function; break;
            case HlslShaderStage.Compute: pass.ComputeFunction = function; break;
        }
    }

    // Locate the decompiler Output/ folder regardless of the launch directory.
    // The executable lives under the repo tree, so walk up from it to find the
    // canonical repo-root Output first (this is deterministic — the same
    // folder no matter where the process was launched). Only fall back to
    // <cwd>/Output when the executable is not under the repo at all. Keeping
    // this shared by reads AND writes avoids a second, stale Output folder
    // appearing next to the project when the tool is launched from Parser/.
    private static string FindOutputRoot()
    {
        string cwd = Directory.GetCurrentDirectory();

        var dir = new DirectoryInfo(AppContext.BaseDirectory);
        while (dir is not null)
        {
            string candidate = Path.Combine(dir.FullName, "Output");
            if (Directory.Exists(candidate)) return candidate;
            dir = dir.Parent;
        }

        return Path.Combine(cwd, "Output");
    }

    // Project-local Output root: the Output/ folder INSIDE the C# project
    // (the folder that owns the .csproj), found by walking up from the
    // executable. This is where generated .shader files are written so they
    // show up in an IDE whose workspace root is the project itself.
    // Deterministic regardless of launch directory — the exe is always built
    // under <project>/bin/<config>/<tfm>.
    private static string ProjectOutputRoot()
    {
        var dir = new DirectoryInfo(AppContext.BaseDirectory);
        while (dir is not null)
        {
            if (Directory.EnumerateFiles(dir.FullName, "*.csproj").Any())
                return Path.Combine(dir.FullName, "Output");
            dir = dir.Parent;
        }

        return FindOutputRoot();
    }
}