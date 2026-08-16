using System;
using System.IO;
using System.Linq;
using Parser.Decompiler;
using Parser.DXBC;
using AssetStudio;
using Parser.DXBC.IR;
using Parser.DXBC.Metadata;
using Parser.DXBC.Hlsl.Ast;

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
            // §16.9: cross-check our ISGN parse against d3dcompiler's own
            // signature extraction, across every real shipped subprogram.
            string root = args.Length > 1 && Directory.Exists(args[1])
                ? args[1]
                : FindOutputRoot();
            SignatureCrossCheck.Run(root);
            return;
        }

        if (args.Contains("--strip-survivors"))
        {
            // §16.1: which DXBC chunks survive D3DStripShader(flags=7)?
            // Compile a synthetic shader with real d3dcompiler and observe
            // the before/after chunk sets per shader type.
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
            // Aggregate health across every decompiled .shader in the
            // Output root: one compile-rate + unmatched count instead of
            // 39 ad-hoc single-file runs.
            RecompileVerify.RunAll(FindOutputRoot());
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

        // args[0] is now a folder produced by Extract.py, containing
        // blob.bin + metadata.json (+ optional dummy.shader). For
        // backwards compat, a direct path to a blob.bin still works
        // (metadata/dummy are simply treated as absent in that case).
        string inputPath = args.Length > 0 ? args[0] : "../Output";

        ShaderProject project;

        if (Directory.Exists(inputPath))
        {
            project = ShaderProject.LoadFromFolder(inputPath);
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

        Directory.CreateDirectory("Output");

        var decompiler = new HlslGenerator();

        // Stage 2 — shell (Shader/SubShaders/Passes/Properties) from
        // metadata.json alone. Functions get attached to pass slots below
        // as each subprogram's IR comes back from the pipeline.
        HlslShaderNode astShader = HlslAstBuilder.BuildShell(project.Metadata);

        // Pass index isn't carried on ShaderSubProgram itself — Unity
        // assigns subprograms to passes in the order passes/programs were
        // serialized, so subprogram i's pass is whichever pass has an
        // open slot for that program's stage, in order. Flatten once so
        // "next pass needing a vertex/fragment function" is a simple walk.
        List<HlslPassNode> allPasses = astShader.SubShaders
            .SelectMany(ss => ss.Passes)
            .ToList();
        var nextPassIndexForStage = new Dictionary<HlslShaderStage, int>();

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
            Console.WriteLine($"Version  : {sp.m_Version}");
            Console.WriteLine($"Code Size: {sp.m_ProgramCode.Length}");

            // Debug artifacts (program{i}.bin/.dxbc/.hlsl) are opt-in via
            // --save-subprograms; the default run only writes the final .shader.
            bool saveSubprograms = args.Contains("--save-subprograms");

            if (saveSubprograms)
            {
                // Save raw Unity shader program
                string rawPath = Path.Combine("Output", $"program{i}.bin");
                File.WriteAllBytes(rawPath, sp.m_ProgramCode);

                Console.WriteLine($"Saved: {rawPath}");
            }

            try
            {
                // §14 classifier: kind + (for non-compute) the 0x26-byte
                // header of 4 per-class resource EXTENTS + flag byte. The
                // header is the only RDEF metadata guaranteed to survive the
                // strip, and doubles as a cross-check against the
                // metadata-driven slot layouts below.
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
                    string dxbcPath = Path.Combine("Output", $"program{i}.dxbc");
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

                // Stage 2 — attach this subprogram's function node (+ its
                // resources) to the next pass slot still waiting for a
                // function of this stage.
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
                    int passIdx = nextPassIndexForStage.GetValueOrDefault(function.Stage, 0);
                    if (passIdx < allPasses.Count)
                    {
                        HlslPassNode pass = allPasses[passIdx];
                        AttachFunction(pass, function);

                        var resources = HlslAstBuilder.BuildResources(
                            pipelineResult.Program.Declarations, dxbcFile.ResourceDefinition, pipelineResult.Blocks, pass.Cbuffers, function.Stage.ToString()).ToList();
                        foreach (var res in resources)
                        {
                            HlslResourceNode? existing = pass.Resources.FirstOrDefault(r =>
                                r.Kind == res.Kind && r.Slot == res.Slot);

                            if (existing is null)
                            {
                                pass.Resources.Add(res);
                            }
                            else if (res.Kind == HlslResourceKind.ConstantBuffer)
                            {
                                // vert/frag subprograms of one pass can touch
                                // different slots of the same cbuffer, and each
                                // BuildResources call only sees its own blocks.
                                // Union the members, keeping the largest array
                                // size so the RDEF-less float4 fallback covers
                                // every subprogram's accesses.
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

                        if (function.InputStruct is not null) pass.Structs.Add(function.InputStruct);
                        if (function.OutputStruct is not null) pass.Structs.Add(function.OutputStruct);

                        // Cross-check the compiler-proven header extents against
                        // the metadata/IR-derived slot layout for THIS stage.
                        // resources was built from this subprogram's own
                        // declarations, so each extent should match exactly.
                        if (header is { } hdr)
                        {
                            int MaxPlus1(HlslResourceKind kind) =>
                                resources.Where(r => r.Kind == kind).Select(r => (int)r.Slot)
                                         .DefaultIfEmpty(-1).Max() + 1;
                            int cb = MaxPlus1(HlslResourceKind.ConstantBuffer);
                            int tex = MaxPlus1(HlslResourceKind.Texture);
                            int samp = MaxPlus1(HlslResourceKind.Sampler);
                            int uav = MaxPlus1(HlslResourceKind.Uav);
                            Console.WriteLine(
                                $"  Header verify ({function.Stage}): " +
                                $"cb {cb}/{hdr.CbExtent} {(cb == hdr.CbExtent ? "OK" : "MISMATCH")}  " +
                                $"tex {tex}/{hdr.TextureExtent} {(tex == hdr.TextureExtent ? "OK" : "MISMATCH")}  " +
                                $"samp {samp}/{hdr.SamplerExtent} {(samp == hdr.SamplerExtent ? "OK" : "MISMATCH")}  " +
                                $"uav {uav}/{hdr.UavExtent} {(uav == hdr.UavExtent ? "OK" : "MISMATCH")}");
                        }

                        nextPassIndexForStage[function.Stage] = passIdx + 1;

                        Console.WriteLine(
                            $"Stage 2: attached {function.Stage} function '{function.Name}' to pass '{pass.Name}' " +
                            $"(in:{function.InputStruct?.Fields.Count ?? 0} out:{function.OutputStruct?.Fields.Count ?? 0} " +
                            $"resources+{pass.Resources.Count})");
                    }
                    else
                    {
                        Console.WriteLine(
                            $"Stage 2: no pass slot left for {function.Stage} subprogram {i} " +
                            "(metadata.json has fewer passes than subprograms of this stage — check metadata.py's pass parsing).");
                    }
                }

                if (saveSubprograms)
                {
                    string hlsl = decompiler.Decompile(dxbc);
                    string hlslPath = Path.Combine("Output", $"program{i}.hlsl");
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
        Console.WriteLine("HLSL AST (Stage 2)");
        Console.WriteLine("-------------------");
        Console.WriteLine($"Shader '{astShader.Name}', {astShader.Properties.Count} properties, {astShader.SubShaders.Count} subshaders");
        foreach (HlslPassNode pass in allPasses)
        {
            Console.WriteLine(
                $"  Pass '{pass.Name}': " +
                $"vert={pass.VertexFunction?.Name ?? "-"} frag={pass.FragmentFunction?.Name ?? "-"} " +
                $"structs={pass.Structs.Count} resources={pass.Resources.Count}");
        }

        bool surfaceReconstruct = !args.Contains("--no-surface-shaders");

        PrintFullShaderOutput(project, astShader, !args.Contains("--no-fuse-temps"), surfaceReconstruct);

        Console.WriteLine();
        Console.WriteLine("Finished.");
    }

    private static void PrintFullShaderOutput(ShaderProject project, HlslShaderNode astShader, bool fuseTemps, bool surfaceReconstruct)
    {
        string text = HlslPrettyPrinter.Print(astShader, fuseTemps);

        // Stage 13.5 — surface-shader recognition: when a pass carries the
        // compiled signature of a `#pragma surface surf ...` source, rewrite
        // the lit pass back into the canonical CGPROGRAM surface form.
        // ON by default since the recompile-verify gate went green (every
        // decompiled pass compiles and matches its shipped signature, so the
        // rewrite sits on verified bytecode-faithful HLSL). The original
        // HLSLPROGRAM passes are kept as a comment in the output, so the
        // verified form remains present. Opt out with --no-surface-shaders.
        if (surfaceReconstruct)
        {
            string? reconstructed = HlslSurfaceShaderRecognizer.TryReconstruct(text, project.Metadata);
            if (reconstructed is not null)
            {
                text = reconstructed;
                Console.WriteLine("Stage 13.5: recognized Unity surface-shader boilerplate, rewrote lit pass to #pragma surface form.");
            }
        }

        string outPath = Path.Combine("Output", SafeFileName(astShader.Name) + ".shader");
        File.WriteAllText(outPath, text);
        Console.WriteLine();
        Console.WriteLine($"Stage 13/14: full shader written to {outPath} ({text.Length} chars)");
    }

    private static string SafeFileName(string name) =>
        string.Join("_", name.Split(Path.GetInvalidFileNameChars()));

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

    // Locate the decompiler Output/ folder regardless of the launch directory:
    // walk up from the executable until a directory with an Output subfolder is
    // found, falling back to <cwd>/Output.
    private static string FindOutputRoot()
    {
        string cwd = Directory.GetCurrentDirectory();
        string direct = Path.Combine(cwd, "Output");
        if (Directory.Exists(direct)) return direct;

        var dir = new DirectoryInfo(AppContext.BaseDirectory);
        while (dir is not null)
        {
            string candidate = Path.Combine(dir.FullName, "Output");
            if (Directory.Exists(candidate)) return candidate;
            dir = dir.Parent;
        }
        return direct;
    }
}