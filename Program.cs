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

            // Save raw Unity shader program
            string rawPath = Path.Combine("Output", $"program{i}.bin");
            File.WriteAllBytes(rawPath, sp.m_ProgramCode);

            Console.WriteLine($"Saved: {rawPath}");

            try
            {
                byte[] dxbc = DxbcExtractor.Extract(sp);

                Console.WriteLine($"DXBC Size: {dxbc.Length} bytes");

                string dxbcPath = Path.Combine("Output", $"program{i}.dxbc");
                File.WriteAllBytes(dxbcPath, dxbc);

                Console.WriteLine($"Saved: {dxbcPath}");

                var dxbcFile = new DxbcFile();
                dxbcFile.Load(dxbcPath);
                
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
                            pipelineResult.Program.Declarations, dxbcFile.ResourceDefinition);
                        foreach (var res in resources)
                        {
                            bool alreadyPresent = pass.Resources.Any(r =>
                                r.Kind == res.Kind && r.Slot == res.Slot);
                            if (!alreadyPresent)
                                pass.Resources.Add(res);
                        }

                        if (function.InputStruct is not null) pass.Structs.Add(function.InputStruct);
                        if (function.OutputStruct is not null) pass.Structs.Add(function.OutputStruct);

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

                string hlsl = decompiler.Decompile(dxbc);
                string hlslPath = Path.Combine("Output", $"program{i}.hlsl");
                File.WriteAllText(hlslPath, hlsl);
                Console.WriteLine($"Saved: {hlslPath}");
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

        PrintFullShaderOutput(project, astShader);

        Console.WriteLine();
        Console.WriteLine("Finished.");
    }

    private static void PrintFullShaderOutput(ShaderProject project, HlslShaderNode astShader)
    {
        string text = HlslPrettyPrinter.Print(astShader);
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
}