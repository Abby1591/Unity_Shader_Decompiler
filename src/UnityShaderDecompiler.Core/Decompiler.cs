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
    /// <summary>Abort on decompilation errors instead of logging and continuing.</summary>
    public bool FailOnError { get; init; }
    
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

    // The keyword set this subprogram was compiled for. Variants of one pass
    // differ only here; the pass is decompiled from the base one.
    public required string[] Keywords { get; init; }

    // Serialized program type (DX11VertexSM40, DX11HullSM50, ...); the shader
    // model needed for the pass's #pragma target comes from this.
    public required ShaderGpuProgramType ProgramType { get; init; }
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
public static class Decompiler
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

        // Unity 2019.3+ (including Unity 6) serialized shader-blob entry
        // layout: every subprogram entry carries an explicit segment index.
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

        // Stage 2 — shell (Shader/SubShaders/Passes/Properties) from
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

            if (!ShaderPlatform.IsDXBC(sp.m_ProgramType)) {
                log.WriteLine($"SubProgram Type not supported: {sp.m_ProgramType}");
                continue;
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

                IRPipeline.Result pipelineResult = IRPipeline.Run(dxbcFile, options.DumpStages, options.FailOnError);

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
                    if (options.FailOnError)
                    {
                        throw new InvalidDataException("SSA verification failed");
                    }
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
                        Keywords = sp.m_Keywords ?? Array.Empty<string>(),
                        ProgramType = sp.m_ProgramType,
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
                if (options.FailOnError)
                {
                    log.WriteLine($"Program{i} decompilation failed. Decompilation stopped.");
                    throw;
                }

                log.WriteLine($"Program{i} decompilation failed, {ex.Message}\n{ex.StackTrace}");
            }

            log.WriteLine();
        }

        log.WriteLine();

        // Stage 2b — recover the pass each candidate belongs to from the
        // serialization order and emit one pass per distinct compiled
        // (vertex, fragment) variant pair.
        BuildVariantPasses(astShader, allPasses, candidates, log);

        ApplyGrabTextures(astShader);

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

        // Stage 13.5 — surface-shader recognition: when a pass carries the
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

    // Signature identity for variant pairing. The vertex/fragment hand-off is
    // the rasterized interpolator set, so the key is the exact ordered element
    // sequence of the signature chunk: semantic name, index, system value and
    // register. Component counts are deliberately excluded — a vertex writes
    // every lane of an interpolator (OSGN mask) while the fragment reads only
    // the lanes it uses (ISGN mask), so the two can legitimately differ for
    // the same variant. Register numbers must match too — the rasterizer
    // interpolates by register, so two programs with the same semantics in
    // different registers do not link.
    internal static string InterfaceKey(List<SignatureElement>? elements) =>
        elements is null
            ? ""
            : string.Join(";", elements.Select(e =>
                $"{e.SemanticName}:{e.SemanticIndex}:{e.SystemValue}:r{e.Register}"));

    internal static string InterfaceInterpKey(List<SignatureElement>? elements) =>
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
        HlslShaderNode astShader,
        List<HlslPassNode> allPasses,
        List<DecompiledSubprogram> candidates,
        TextWriter log)
    {
        if (candidates.Count == 0)
            return;

        // Build texture property name mapping: texture properties (type=4) in
        // declaration order map to t-register slots (0, 1, 2, ...). This lets
        // the decompiler emit "Texture2D _MainTex : register(t0)" instead of
        // "Texture2D t0 : register(t0)" — Unity needs variable names matching
        // the Properties block to bind textures at runtime.
        var textureNames = new Dictionary<uint, string>();
        uint texSlot = 0;
        foreach (HlslPropertyNode prop in astShader.Properties)
            if (prop.Kind == HlslPropertyKind.Texture)
                textureNames[texSlot++] = prop.Name;

        // Unity serializes the subprograms each pass uses (m_BlobIndex per
        // stage), so use that association when the metadata carries it. The
        // stage-order grouping below is only a fallback for older exports.
        if (allPasses.Any(p => p.ProgramIndices.Count > 0))
        {
            BuildVariantPassesFromMetadata(allPasses, candidates, textureNames, log);
            return;
        }

        foreach (DecompiledSubprogram c in candidates)
            c.Hash = Convert.ToHexString(SHA256.HashData(c.DxbcBytes));

        var groups = new List<List<DecompiledSubprogram>>();
        foreach (DecompiledSubprogram c in candidates)
        {
            if (groups.Count == 0)
            {
                groups.Add(new List<DecompiledSubprogram> { c });
                continue;
            }
            if (StageRank(c.Stage) < StageRank(groups[^1][^1].Stage))
                groups.Add(new List<DecompiledSubprogram> { c });
            else
                groups[^1].Add(c);
        }

        int totalPasses = 0;

        for (int gi = 0; gi < groups.Count; gi++)
        {
            List<DecompiledSubprogram> group = groups[gi];
            HlslPassNode shell = gi < allPasses.Count
                ? allPasses[gi]
                : allPasses[^1]; // more groups than metadata passes: reuse the last shell

            var verts = group.Where(c => c.Stage == HlslShaderStage.Vertex).ToList();
            var frags = group.Where(c => c.Stage == HlslShaderStage.Fragment).ToList();
            var others = group.Where(c => c.Stage is not (HlslShaderStage.Vertex or HlslShaderStage.Fragment)).ToList();

            // Pair by interpolator hand-off. The vertex and fragment must agree
            // on the interpolated set (the rasterized hand-off); the fragment
            // may additionally consume rasterizer-generated system values
            // (SV_IsFrontFace, ...) the vertex never writes, so the vertex
            // output is also required to be a subset of the fragment input.
            // Pairing is 1:1 — each vertex takes the first unused fragment it
            // links with (both are in serialized keyword-set order, so this
            // recovers Unity's original variant passes) and a fragment is
            // never reused. Byte-identical pairs therefore collapse and
            // genuinely unmatched variants are reported as folded.
            var pairs = new List<(DecompiledSubprogram V, DecompiledSubprogram F)>();
            var usedFrags = new HashSet<DecompiledSubprogram>();
            var seen = new HashSet<(string, string)>();
            foreach (DecompiledSubprogram v in verts)
            {
                string[] vertOut = v.OutputSignature.Split(';', StringSplitOptions.RemoveEmptyEntries);
                if (vertOut.Length == 0)
                    continue; // a vertex always writes interpolators; don't match an empty output
                foreach (DecompiledSubprogram f in frags)
                {
                    if (usedFrags.Contains(f))
                        continue;
                    if (v.OutputInterpolators == f.InputInterpolators
                        && vertOut.All(f.InputSignature.Split(';', StringSplitOptions.RemoveEmptyEntries).Contains)
                        && seen.Add((v.Hash, f.Hash)))
                    {
                        pairs.Add((v, f));
                        usedFrags.Add(f);
                        break;
                    }
                }
            }

            // One pass per compiled variant set: the pairs in a group are
            // keyword variants of the same ShaderLab pass, so emitting each
            // as its own pass would run every variant on every draw and
            // shift pass indices. The body is the variant with the fewest
            // keywords (keyword sets only add to the base state); the rest
            // are folded and named in the output.
            string[] foldedKeywords = Array.Empty<string>();
            if (pairs.Count > 0)
            {
                var (v, f) = pairs.OrderBy(p => p.V.Keywords.Length).First();
                var baseKeywords = v.Keywords.ToHashSet(StringComparer.Ordinal);
                foldedKeywords = pairs
                    .SelectMany(p => p.V.Keywords)
                    .Where(k => !baseKeywords.Contains(k))
                    .Distinct(StringComparer.Ordinal)
                    .OrderBy(k => k, StringComparer.Ordinal)
                    .ToArray();
                foreach (string keyword in foldedKeywords)
                    shell.FoldedKeywords.Add(keyword);

                AttachPassProgram(shell, v, textureNames, log);
                AttachPassProgram(shell, f, textureNames, log);
                totalPasses++;
            }

            // Stage functions that pair by position, not signature
            // (geometry/hull/domain/compute), attach to the shell pass.
            foreach (DecompiledSubprogram o in others)
            {
                AttachPassProgram(shell, o, textureNames, log);
                totalPasses++;
            }

            if (pairs.Count == 0 && others.Count == 0)
            {
                log.WriteLine($"  Pass group {gi}: {verts.Count} verts x {frags.Count} frags produced no renderable variant (skipped).");
            }
            else
            {
                string folded = pairs.Count > 1
                    ? $", {pairs.Count - 1} keyword variant pair(s) folded" +
                      (foldedKeywords.Length > 0 ? $": {string.Join(", ", foldedKeywords)}" : "")
                    : "";
                log.WriteLine($"  Pass group {gi}: {verts.Count} verts x {frags.Count} frags => 1 pass{folded}.");
            }
        }

        log.WriteLine($"BuildVariantPasses: {groups.Count} pass group(s), {totalPasses} pass(es) emitted total.");
    }

    // Unity binds a GrabPass texture shader-wide, and the program that
    // samples it has no name for the anonymous tN resource, so give that
    // resource the grab name.
    // shortcut: when a pass binds more than one anonymous texture (e.g. a
    // grab texture plus _CameraDepthTexture) the lowest slot is assumed to be
    // the grab texture; upgrade if a shader needs a better association.
    private static void ApplyGrabTextures(HlslShaderNode shader)
    {
        foreach (HlslSubShaderNode ss in shader.SubShaders)
        {
            string? grab = ss.Passes
                .Select(p => p.GrabPassName)
                .FirstOrDefault(n => !string.IsNullOrEmpty(n));
            if (grab is null)
                continue;

            HlslResourceNode? anonymous = ss.Passes
                .SelectMany(p => p.Resources)
                .Where(r => r.Kind == HlslResourceKind.Texture
                    && r.TypeHint?.StartsWith("Texture") == true
                    && r.Name.Length > 1 && r.Name[0] == 't'
                    && r.Name[1..].All(char.IsDigit))
                .OrderBy(r => r.Slot)
                .FirstOrDefault();
            if (anonymous is not null)
                anonymous.Name = grab;
        }
    }

    // A pass can carry hundreds of keyword permutations (Corpus_27 has 768
    // vertex programs for one pass), so only passes with a small hand-written
    // set get a body per variant.
    // shortcut: larger passes keep one body and a merged multi_compile list.
    private const int MaxEmittedVariantBodies = 4;

    // Attaches each pass's own serialized subprograms. A vertex program can
    // serve several passes (Corpus_02 has seven passes sharing one vertex and
    // one fragment), so this follows the per-pass references instead of
    // pairing programs 1:1 by serialization order.
    private static void BuildVariantPassesFromMetadata(
        List<HlslPassNode> allPasses,
        List<DecompiledSubprogram> candidates,
        Dictionary<uint, string> textureNames,
        TextWriter log)
    {
        var byIndex = candidates.ToDictionary(c => c.Index);
        int totalPrograms = 0;

        foreach (HlslPassNode pass in allPasses)
        {
            // Per stage: every serialized program of that stage. A pass can
            // serialize several keyword permutations of one stage.
            var stageVariants = new Dictionary<HlslShaderStage, List<DecompiledSubprogram>>();
            foreach (var (stageName, indices) in pass.ProgramIndices)
            {
                if (!Enum.TryParse(stageName, out HlslShaderStage stage))
                    continue;
                var variants = indices
                    .Select(i => byIndex.GetValueOrDefault(i))
                    .Where(c => c is not null && c.Stage == stage)
                    .Select(c => c!)
                    .OrderBy(c => c.Keywords.Length)
                    .ThenBy(c => KeywordKey(c.Keywords), StringComparer.Ordinal)
                    .ToList();
                if (variants.Count > 0)
                    stageVariants[stage] = variants;
            }

            if (stageVariants.Count == 0)
            {
                if (string.IsNullOrEmpty(pass.UsePass))
                    log.WriteLine($"  Pass '{pass.Name}': no serialized subprogram, left empty.");
                continue;
            }

            // One keyword set per compiled permutation, shared across stages.
            var keywordSets = stageVariants.Values
                .SelectMany(v => v)
                .GroupBy(c => KeywordKey(c.Keywords), StringComparer.Ordinal)
                .ToDictionary(g => g.Key, g => g.First().Keywords, StringComparer.Ordinal);

            // Base body: the permutation with the fewest keywords (ties by
            // name, so the output is deterministic).
            string baseKey = keywordSets.Keys
                .OrderBy(k => keywordSets[k].Length)
                .ThenBy(k => k, StringComparer.Ordinal)
                .First();
            string[] baseKeywords = keywordSets[baseKey];

            foreach (var (_, variants) in stageVariants)
            {
                DecompiledSubprogram chosen =
                    variants.FirstOrDefault(c => KeywordKey(c.Keywords) == baseKey) ?? variants[0];
                AttachPassProgram(pass, chosen, textureNames, log);
                totalPrograms++;
            }

            bool emitBodies = keywordSets.Count <= MaxEmittedVariantBodies;
            foreach (var (key, keywords) in keywordSets)
            {
                if (key == baseKey)
                    continue;

                List<string> extra = keywords
                    .Where(k => !baseKeywords.Contains(k, StringComparer.Ordinal))
                    .OrderBy(k => k, StringComparer.Ordinal)
                    .ToList();
                foreach (string keyword in extra)
                    if (!pass.FoldedKeywords.Contains(keyword))
                        pass.FoldedKeywords.Add(keyword);

                if (!emitBodies || extra.Count == 0)
                    continue;

                // A branch needs a body for every stage the base body has; a
                // permutation missing one keeps the base body.
                if (stageVariants.Keys.Any(stage =>
                        !stageVariants[stage].Any(c => KeywordKey(c.Keywords) == key)))
                    continue;

                var variant = new HlslPassVariant();
                variant.Keywords.AddRange(extra);
                foreach (var (_, variants) in stageVariants)
                {
                    AttachPassProgram(pass,
                        variants.First(c => KeywordKey(c.Keywords) == key),
                        textureNames, log, variant);
                    totalPrograms++;
                }
                pass.Variants.Add(variant);
            }

            pass.FoldedKeywords.Sort(StringComparer.Ordinal);
        }

        log.WriteLine(
            $"BuildVariantPasses: {totalPrograms} program(s) attached from per-pass metadata across {allPasses.Count} pass(es).");
    }

    // Order-independent identity for one compiled keyword set.
    private static string KeywordKey(IEnumerable<string> keywords) =>
        string.Join('\0', keywords.OrderBy(k => k, StringComparer.Ordinal));

    // The serialized #pragma target is not in the blob, so infer the floor
    // from the compiled shader model: SM4.0 is Unity target 3.5, SM5.0 is 4.5,
    // and the tessellation stages need 5.0.
    // shortcut: a source target of 3.0 is emitted as 3.5 and 4.6 as 4.5;
    // upgrade if the exact target (platform gating) has to be preserved.
    private static HlslShaderTarget TargetFor(ShaderGpuProgramType type) => type switch
    {
        ShaderGpuProgramType.DX11HullSM50 or ShaderGpuProgramType.DX11DomainSM50
            => HlslShaderTarget.Sm50,
        ShaderGpuProgramType.DX11VertexSM40 or ShaderGpuProgramType.DX11PixelSM40
            or ShaderGpuProgramType.DX11GeometrySM40
            or ShaderGpuProgramType.DX10Level9Vertex or ShaderGpuProgramType.DX10Level9Pixel
            => HlslShaderTarget.Sm35,
        _ => HlslShaderTarget.Sm45,
    };

    // Attaches one candidate's function, resources and structs to a pass,
    // unioning cbuffer members the way the previous streaming loop did. When
    // variant is non-null the function and structs become that variant's body
    // instead (resources stay pass-wide).
    private static void AttachPassProgram(
        HlslPassNode pass,
        DecompiledSubprogram c,
        Dictionary<uint, string>? textureNames,
        TextWriter log,
        HlslPassVariant? variant = null)
    {
        HlslShaderTarget target = TargetFor(c.ProgramType);
        if (target > pass.Target)
            pass.Target = target;

        AttachFunction(pass, variant, c.Function);

        var resources = HlslAstBuilder.BuildResources(
            c.Pipeline.Program.Declarations,
            c.Dxbc.ResourceDefinition,
            c.Pipeline.Blocks,
            pass.Cbuffers,
            c.Stage.ToString(),
            textureNames).ToList();

        foreach (HlslResourceNode res in resources)
        {
            // Cbuffers merge by slot: vert and frag subprograms of the same
            // pass touch the same constant-buffer slots, so union the
            // members (keeping the largest array size for any fallback).
            // Match by slot only: two samplers that serve the same texture
            // carry the same name but live in different registers, and
            // dropping one leaves the body's sN reference undeclared.
            HlslResourceNode? existing = pass.Resources.FirstOrDefault(r =>
                r.Kind == res.Kind && r.Slot == res.Slot);

            if (existing is null)
            {
                // Sampler name collision: two different sampler slots may both
                // map to the same texture property (e.g. s0 and s2 both serve
                // _MainTex). Append the slot index to make the name unique.
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

        // A variable exposed in two different cbuffers of one pass (Unity's
        // metadata can list e.g. _Color in both the property buffer and the
        // globals buffer) is an HLSL redefinition. Keep the lowest-slot
        // declaration; member lookup is by name, so reads still resolve.
        var cbVars = new HashSet<string>(StringComparer.Ordinal);
        foreach (HlslResourceNode cb in pass.Resources
            .Where(r => r.Kind == HlslResourceKind.ConstantBuffer)
            .OrderBy(r => r.Slot))
        {
            // A variable listed in two cbuffers is an HLSL redefinition.
            // Keep the lowest-slot name and suffix the duplicate so the
            // higher slot still declares its register binding.
            // shortcut: reads that resolve to the duplicate still use the
            // kept name (same layout, possibly a different buffer value).
            for (int i = 0; i < cb.Variables.Count; i++)
            {
                HlslCBufferVariable v = cb.Variables[i];
                if (cbVars.Add(v.Name))
                    continue;
                // The same variant can be attached more than once, so the
                // suffixed name has to stay unique too.
                string baseName = $"{v.Name}_b{cb.Slot}";
                string name = baseName;
                for (int n = 2; cbVars.Contains(name); n++)
                    name = $"{baseName}_{n}";
                cbVars.Add(name);
                cb.Variables[i] = new HlslCBufferVariable
                {
                    Name = name,
                    TypeName = v.TypeName,
                    Offset = v.Offset,
                    Size = v.Size,
                    ArraySize = v.ArraySize,
                };
            }
        }
        // A buffer left empty by dedupe declares no member and nothing in
        // the body can reference it; emitting `cbuffer X { };` is not worth
        // the risk with older compilers.
        pass.Resources.RemoveAll(r =>
            r.Kind == HlslResourceKind.ConstantBuffer && r.Variables.Count == 0);

        if (c.Function.InputStruct is not null) (variant?.Structs ?? pass.Structs).Add(c.Function.InputStruct);
        if (c.Function.OutputStruct is not null) (variant?.Structs ?? pass.Structs).Add(c.Function.OutputStruct);

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
            log.WriteLine(
                $"  Header verify ({c.Stage} subprogram {c.Index}): " +
                $"cb {cb}/{hdr.CbExtent} {(cb == hdr.CbExtent ? "OK" : "MISMATCH")}  " +
                $"tex {tex}/{hdr.TextureExtent} {(tex == hdr.TextureExtent ? "OK" : "MISMATCH")}  " +
                $"samp {samp}/{hdr.SamplerExtent} {(samp == hdr.SamplerExtent ? "OK" : "MISMATCH")}  " +
                $"uav {uav}/{hdr.UavExtent} {(uav == hdr.UavExtent ? "OK" : "MISMATCH")}");
        }

        log.WriteLine(
            $"Stage 2: attached {c.Stage} function '{c.Function.Name}' to pass '{pass.Name}' " +
            $"(in:{c.Function.InputStruct?.Fields.Count ?? 0} out:{c.Function.OutputStruct?.Fields.Count ?? 0} " +
            $"resources+{pass.Resources.Count})");
    }

    private static void AttachFunction(HlslPassNode pass, HlslPassVariant? variant, HlslFunctionNode function)
    {
        switch (function.Stage)
        {
            case HlslShaderStage.Vertex:
                if (variant is null) pass.VertexFunction = function; else variant.VertexFunction = function;
                break;
            case HlslShaderStage.Fragment:
                if (variant is null) pass.FragmentFunction = function; else variant.FragmentFunction = function;
                break;
            case HlslShaderStage.Geometry:
                if (variant is null) pass.GeometryFunction = function; else variant.GeometryFunction = function;
                break;
            case HlslShaderStage.Hull:
                if (variant is null) pass.HullFunction = function; else variant.HullFunction = function;
                break;
            case HlslShaderStage.Domain:
                if (variant is null) pass.DomainFunction = function; else variant.DomainFunction = function;
                break;
            case HlslShaderStage.Compute:
                if (variant is null) pass.ComputeFunction = function; else variant.ComputeFunction = function;
                break;
        }
    }

    // Locate the decompiler Output/ folder regardless of the launch directory.
    // The executable lives under the repo tree, so walk up from it to find the
    // canonical repo-root Output first (this is deterministic — the same
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
    // Deterministic regardless of launch directory — the exe is always built
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
