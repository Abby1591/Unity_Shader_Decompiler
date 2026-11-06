using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using AssetStudio;
using UnityShaderDecompiler.Core.Hlsl.Ast;
using UnityShaderDecompiler.Core.DXBC;
using UnityShaderDecompiler.Core.DXBC.Chunks;
using UnityShaderDecompiler.Core.DXBC.Extraction;
using UnityShaderDecompiler.Core.DXBC.IR;
using UnityShaderDecompiler.Core.DXBC.Metadata;

namespace UnityShaderDecompiler.Core;

/// <summary>
/// Options that control a single decompilation run. The defaults match the
/// command-line defaults (fusion on, surface-shader reconstruction on,
/// register bindings stripped).
/// </summary>
public sealed class DecompileOptions
{
    /// <summary>Print the IR after every pipeline phase.</summary>
    public bool DumpStages { get; init; }

    /// <summary>Print each subprogram's global and local keyword sets.</summary>
    public bool DumpKeywords { get; init; }

    /// <summary>Write per-subprogram <c>program{i}.bin/.dxbc/.hlsl</c> artifacts.</summary>
    public bool SaveSubprograms { get; init; }

    /// <summary>Fuse SSA copies into vector moves where possible.</summary>
    public bool FuseTemps { get; init; } = true;

    /// <summary>Rewrite recognized passes into <c>#pragma surface</c> form.</summary>
    public bool ReconstructSurfaceShaders { get; init; } = true;

    /// <summary>Keep the original compiled passes as comments after a surface rewrite.</summary>
    public bool KeepPasses { get; init; }

    /// <summary>Keep explicit <c>register(tN)</c> / <c>register(bN)</c> bindings.</summary>
    public bool KeepRegisterBindings { get; init; }

    /// <summary>Write the final <c>.shader</c> and any requested artifacts here.</summary>
    public string? OutRoot { get; init; }

    /// <summary>Emit progress and diagnostics to stdout.</summary>
    public bool Verbose { get; init; } = true;
}

/// <summary>One subprogram that produced an HLSL function.</summary>
public sealed class DecompiledSubprogram
{
    public required int Index { get; init; }
    public required HlslShaderStage Stage { get; init; }
    public required HlslFunctionNode Function { get; init; }
    public required IRPipeline.Result Pipeline { get; init; }
    public required DxbcFile Dxbc { get; init; }
    public required byte[] DxbcBytes { get; init; }
    public UnityNonComputeHeader? Header { get; init; }

    // Signature identity for variant pairing. Kept on the public result so
    // callers (and tests) can reason about how passes were grouped.
    public required string InputSignature { get; init; }
    public required string OutputSignature { get; init; }
    public required string InputInterpolators { get; init; }
    public required string OutputInterpolators { get; init; }
    internal string Hash { get; set; } = "";
}

/// <summary>Everything a decompilation produced.</summary>
public sealed class DecompilationResult
{
    public required ShaderProject Project { get; init; }
    public required HlslShaderNode Shader { get; init; }
    public required string ShaderText { get; init; }
    public required IReadOnlyList<DecompiledSubprogram> Subprograms { get; init; }
    public required IReadOnlyList<HlslPassNode> Passes { get; init; }
    public string? OutputPath { get; init; }
}

/// <summary>
/// The decompilation pipeline itself, decoupled from the CLI. Program.cs
/// parses arguments and delegates here; tests call it directly in-process.
/// </summary>
public static partial class Decompiler
{
    private static TextWriter Log(DecompileOptions options) =>
        options.Verbose ? Console.Out : TextWriter.Null;

    public static DecompilationResult DecompileFolder(
        string folderPath, DecompileOptions? options = null)
    {
        ArgumentException.ThrowIfNullOrWhiteSpace(folderPath);
        return Decompile(ShaderProject.LoadFromFolder(folderPath), options);
    }

    public static DecompilationResult Decompile(
        ShaderProject project, DecompileOptions? options = null)
    {
        ArgumentNullException.ThrowIfNull(project);
        options ??= new DecompileOptions();
        TextWriter log = Log(options);

        log.WriteLine("Unity Shader Parser");
        log.WriteLine("-------------------");
        log.WriteLine($"Shader: {project.Metadata.Name}");
        log.WriteLine($"Properties: {project.Metadata.Properties.Count}");
        log.WriteLine($"SubShaders: {project.Metadata.SubShaders.Count}");
        log.WriteLine($"Dependencies: {project.Metadata.Dependencies.Count}");
        log.WriteLine($"Dummy reference available: {project.DummyShaderSource != null}");
        log.WriteLine();

        byte[] bytes = project.Blob;
        log.WriteLine($"Blob Size: {bytes.Length} bytes");
        log.WriteLine();

        using var stream = new MemoryStream(bytes);
        using var reader = new BinaryReader(stream);

        // Unity 2022.3.x â€” the serialized shader-blob version this tool targets.
        int[] version = { 2022, 3, 62 };
        var program = new ShaderProgram(reader, version);

        log.WriteLine($"SubPrograms: {program.entries.Length}");
        log.WriteLine();

        for (int i = 0; i < program.entries.Length; i++)
        {
            var e = program.entries[i];
            log.WriteLine($"[{i}] Offset={e.Offset} Length={e.Length} Segment={e.Segment}");
        }

        log.WriteLine();
        log.WriteLine("Loading SubPrograms...");
        log.WriteLine();

        program.Read(reader, 0);

        if (options.OutRoot is { } createRoot)
            Directory.CreateDirectory(createRoot);

        // Stage 2 â€” shell (Shader/SubShaders/Passes/Properties) from
        // metadata.json alone. Functions get attached to pass slots below
        // as each subprogram's IR comes back from the pipeline.
        HlslShaderNode astShader = HlslAstBuilder.BuildShell(project.Metadata);

        // Subprogram functions are collected (not attached yet): Unity
        // serializes subprograms pass-by-pass, grouping each pass's programs
        // by stage (all vertex variants, then all fragment variants, ...),
        // with GLES programs first and DX11 after within a stage group. A
        // pass boundary is therefore a stage regression (fragment -> vertex)
        // in the serialized order. We collect every mappable function with
        // the data needed to recover those groups and pair vertex/fragment
        // variants by signature afterwards.
        List<HlslPassNode> allPasses = astShader.SubShaders
            .SelectMany(ss => ss.Passes)
            .ToList();
        var candidates = new List<DecompiledSubprogram>();

        for (int i = 0; i < program.m_SubPrograms.Length; i++)
        {
            var sp = program.m_SubPrograms[i];

            log.WriteLine($"========== SubProgram {i} ==========");

            if (sp == null)
            {
                log.WriteLine("NULL");
                log.WriteLine();
                continue;
            }

            log.WriteLine($"Type     : {sp.m_ProgramType}");

            if (options.DumpKeywords)
                log.WriteLine($"Keywords : [{string.Join(" | ", sp.m_Keywords)}]  Local: [{string.Join(" | ", sp.m_LocalKeywords ?? Array.Empty<string>())}]");
            log.WriteLine($"Version  : {sp.m_Version}");
            log.WriteLine($"Code Size: {sp.m_ProgramCode.Length}");

            if (options.SaveSubprograms && options.OutRoot is { } saveRoot)
            {
                string rawPath = Path.Combine(saveRoot, $"program{i}.bin");
                File.WriteAllBytes(rawPath, sp.m_ProgramCode);
                log.WriteLine($"Saved: {rawPath}");
            }

            try
            {
                // Classifier: kind + (for non-compute) the 0x26-byte header
                // of 4 per-class resource EXTENTS + flag byte. The header is
                // the only RDEF metadata guaranteed to survive the strip.
                UnityShaderBlob blob = UnityShaderBlob.Parse(sp.m_ProgramCode, "shipped");
                UnityNonComputeHeader? header = blob.Header;
                if (header is { } h)
                    log.WriteLine(
                        $"Blob: kind={blob.Kind} tex={h.TextureExtent} cb={h.CbExtent} samp={h.SamplerExtent} " +
                        $"uav={h.UavExtent} flag={h.Flag} (DXBC@{h.DxbcOffset})");
                else if (blob.ComputeMetadata is { } cm)
                {
                    log.WriteLine(
                        $"Blob: kind=Compute version={cm.Version} params={cm.ParamData.OuterCount} shaders={cm.ShaderEntries.Count}");
                    var e = cm.ShaderEntries.FirstOrDefault();
                    if (e is not null)
                        log.WriteLine(
                            $"  '{e.Name}' threads=({e.ThreadGroupX},{e.ThreadGroupY},{e.ThreadGroupZ}) " +
                            $"dxbc={e.Dxbc.Length}B lists={e.ListA.Count}/{e.ListB.Count}/{e.ListC.Count}/{e.ListD.Count}");
                }

                byte[] dxbc = blob.Dxbc;

                log.WriteLine($"DXBC Size: {dxbc.Length} bytes");

                var dxbcFile = new DxbcFile();
                dxbcFile.Load(dxbc);

                if (options.SaveSubprograms && options.OutRoot is { } dxbcRoot)
                {
                    string dxbcPath = Path.Combine(dxbcRoot, $"program{i}.dxbc");
                    File.WriteAllBytes(dxbcPath, dxbc);
                    log.WriteLine($"Saved: {dxbcPath}");
                }

                IRPipeline.Result pipelineResult = IRPipeline.Run(dxbcFile, options.DumpStages);

                if (options.DumpStages)
                {
                    foreach (var (phase, stageText) in pipelineResult.StageDumps)
                    {
                        log.WriteLine($"==== {phase} ====");
                        log.WriteLine(stageText);
                    }
                }

                log.WriteLine("IR (post-optimization, pattern-recognized, metadata-bound)");
                log.WriteLine("------------------------------------------------------------");

                foreach (var block in pipelineResult.Blocks)
                {
                    foreach (var stmt in block.Statements)
                        log.WriteLine(stmt);
                }

                log.WriteLine();

                if (!pipelineResult.SsaVerification.IsValid)
                {
                    log.WriteLine("SSA verification FAILED:");
                    foreach (var error in pipelineResult.SsaVerification.Errors)
                        log.WriteLine($"  {error}");
                    log.WriteLine();
                }

                if (pipelineResult.RecognizedLoops.Count > 0)
                {
                    log.WriteLine("Recognized loops:");
                    foreach (var loop in pipelineResult.RecognizedLoops)
                        log.WriteLine($"  {loop}");
                    log.WriteLine();
                }

                log.WriteLine($"Length      : {dxbcFile.TotalLength}");
                log.WriteLine($"Chunk Count : {dxbcFile.Chunks.Count}");
                log.WriteLine();

                if (dxbcFile.InputSignature != null)
                {
                    log.WriteLine($"ISGN Elements: {dxbcFile.InputSignature.Elements.Count}");
                    foreach (var warning in dxbcFile.InputSignature.Warnings)
                        log.WriteLine(warning);
                    foreach (var element in dxbcFile.InputSignature.Elements)
                        log.WriteLine(element);
                    log.WriteLine();
                }

                if (dxbcFile.Shader != null)
                {
                    log.WriteLine($"Shader Version Token : 0x{dxbcFile.Shader.VersionToken:X8}");
                    log.WriteLine($"Instruction DWORDs   : {dxbcFile.Shader.DeclaredDwordCount}");
                    log.WriteLine();
                    log.WriteLine("Instructions");
                    log.WriteLine("------------");

                    foreach (var inst in dxbcFile.Shader.Instructions)
                    {
                        log.WriteLine($"{inst.Name,-20} Length={inst.Length}");
                        foreach (var operand in inst.Operands)
                            log.WriteLine(operand);
                    }

                    foreach (var warning in dxbcFile.Shader.Warnings)
                        log.WriteLine(warning);

                    log.WriteLine();
                }

                log.WriteLine($"IR statements: {pipelineResult.Program.Statements.Count}");

                // Build this subprogram's function node. The pass it belongs
                // to and the variant it pairs with are resolved after the
                // loop (see BuildVariantPasses), so just stash the function +
                // the data the pairing needs.
                HlslFunctionNode? function = HlslAstBuilder.BuildFunction(
                    $"program{i}",
                    sp.m_ProgramType,
                    pipelineResult.Program.Declarations,
                    pipelineResult.Blocks,
                    dxbcFile.InputSignature,
                    dxbcFile.OutputSignature);

                if (function is null)
                {
                    log.WriteLine($"Stage 2: {sp.m_ProgramType} has no HLSL AST mapping (not DX11 SM4/5), skipped.");
                }
                else
                {
                    candidates.Add(new DecompiledSubprogram
                    {
                        Index = i,
                        Stage = function.Stage,
                        Function = function,
                        Pipeline = pipelineResult,
                        Dxbc = dxbcFile,
                        DxbcBytes = dxbc,
                        Header = header,
                        InputSignature = InterfaceKey(dxbcFile.InputSignature?.Elements),
                        OutputSignature = InterfaceKey(dxbcFile.OutputSignature?.Elements),
                        InputInterpolators = InterfaceInterpKey(dxbcFile.InputSignature?.Elements),
                        OutputInterpolators = InterfaceInterpKey(dxbcFile.OutputSignature?.Elements),
                    });
                    log.WriteLine($"Stage 2: collected {function.Stage} function '{function.Name}' (subprogram {i}).");
                }

                if (options.SaveSubprograms && options.OutRoot is { } hlslRoot)
                {
                    string hlsl = UnityShaderDecompiler.Core.DXBC.Disassembly.DxbcDisassembler.Disassemble(dxbc);
                    string hlslPath = Path.Combine(hlslRoot, $"program{i}.hlsl");
                    File.WriteAllText(hlslPath, hlsl);
                    log.WriteLine($"Saved: {hlslPath}");
                }
            }
            catch (Exception ex)
            {
                log.WriteLine($"No DXBC: {ex.Message}");
            }

            log.WriteLine();
        }

        log.WriteLine();

        // Stage 2b â€” recover the pass each candidate belongs to from the
        // serialization order and emit one pass per distinct compiled
        // (vertex, fragment) variant pair.
        BuildVariantPasses(astShader, allPasses, candidates, log);

        log.WriteLine();
        log.WriteLine("HLSL AST (Stage 2)");
        log.WriteLine("-------------------");
        log.WriteLine($"Shader '{astShader.Name}', {astShader.Properties.Count} properties, {astShader.SubShaders.Count} subshaders");
        foreach (HlslPassNode pass in astShader.SubShaders.SelectMany(ss => ss.Passes))
        {
            log.WriteLine(
                $"  Pass '{pass.Name}': " +
                $"vert={pass.VertexFunction?.Name ?? "-"} frag={pass.FragmentFunction?.Name ?? "-"} " +
                $"structs={pass.Structs.Count} resources={pass.Resources.Count}");
        }

        string text = HlslPrettyPrinter.Print(
            astShader, options.FuseTemps, !options.KeepRegisterBindings);

        // Stage 13.5 â€” surface-shader recognition: when a pass carries the
        // compiled signature of a `#pragma surface surf ...` source, rewrite
        // the lit pass back into the canonical CGPROGRAM surface form. The
        // original HLSLPROGRAM passes are kept as a comment only with
        // --keep-passes; by default the output is just the reconstructed
        // source so surface shaders match their original line count.
        if (options.ReconstructSurfaceShaders)
        {
            string? reconstructed = HlslSurfaceShaderRecognizer.TryReconstruct(
                text, project.Metadata, options.KeepPasses);
            if (reconstructed is not null)
            {
                text = reconstructed;
                log.WriteLine("Stage 13.5: recognized Unity surface-shader boilerplate, rewrote lit pass to #pragma surface form.");
            }
        }

        string? outputPath = null;
        if (options.OutRoot is { } outRoot)
        {
            outputPath = Path.Combine(outRoot, SafeFileName(astShader.Name) + ".shader");
            File.WriteAllText(outputPath, text);
            log.WriteLine();
            log.WriteLine($"Stage 13/14: full shader written to {outputPath} ({text.Length} chars)");
        }

        log.WriteLine();
        log.WriteLine("Finished.");

        return new DecompilationResult
        {
            Project = project,
            Shader = astShader,
            ShaderText = text,
            Subprograms = candidates,
            Passes = astShader.SubShaders.SelectMany(ss => ss.Passes).ToList(),
            OutputPath = outputPath,
        };
    }

    public static string SafeFileName(string name) =>
        string.Join("_", name.Split(Path.GetInvalidFileNameChars())).TrimEnd(' ', '.');


    // Locate the decompiler Output/ folder regardless of the launch directory.
    // The executable lives under the repo tree, so walk up from it to find the
    // canonical repo-root Output first (this is deterministic â€” the same
    // folder no matter where the process was launched). Only fall back to
    // <cwd>/Output when the executable is not under the repo at all.
    public static string FindOutputRoot()
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
    // Deterministic regardless of launch directory â€” the exe is always built
    // under <project>/bin/<config>/<tfm>.
    public static string ProjectOutputRoot()
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
