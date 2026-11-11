using System;
using System.CommandLine;
using System.IO;
using System.Linq;
using UnityShaderDecompiler.Core.DXBC.Metadata;
using UnityShaderDecompiler.Core;

namespace UnityShaderDecompiler.Cli;

internal class Program
{
    static int Main(string[] args)
    {
        RootCommand command = CliCommand.Create();
        command.SetAction(Run);
        return command.Parse(args).Invoke();
    }

    private static int Run(ParseResult args)
    {
        if (args.GetValue(CliOptions.RunSpecTests))
        {
            SpecTestVectors.Run();
            return 0;
        }

        if (args.GetValue(CliOptions.VerifySignatures))
        {
            // Cross-check the ISGN parse against d3dcompiler's own signature
            // extraction across every shipped subprogram.
            string root = args.GetValue(CliOptions.InputPath) ?? FindOutputRoot();
            SignatureCrossCheck.Run(root);
            return 0;
        }

        if (args.GetValue(CliOptions.StripSurvivors))
        {
            // Which DXBC chunks survive D3DStripShader(flags=7)?
            StripSurvivors.Run(FindOutputRoot());
            return 0;
        }

        if (args.GetValue(CliOptions.RecompileVerify))
        {
            // Recompile each decompiled HLSLPROGRAM pass with real
            // d3dcompiler and match its signatures against the shipped
            // bytecode — the gate that --surface-shaders waits on.
            string shader = args.GetValue(CliOptions.InputPath)
                ?? Path.Combine(FindOutputRoot(), "Corpus_01 Properties.shader");
            RecompileVerify.Run(shader);
            return 0;
        }

        if (args.GetValue(CliOptions.RecompileVerifyAll))
        {
            // Aggregate health across every decompiled .shader in the Output
            // root: one compile-rate + unmatched count instead of 39 runs.
            string root = args.GetValue(CliOptions.InputPath) ?? FindOutputRoot();
            RecompileVerify.RunAll(root);
            return 0;
        }

        if (args.GetValue(CliOptions.Disassemble))
        {
            // Dump every non-compute subprogram's DXBC disassembly to a
            // sibling <name>.disasm.txt for bytecode-level inspection.
            string target = args.GetValue(CliOptions.InputPath) ?? FindOutputRoot();
            RecompileVerify.DumpDisasm(target);
            return 0;
        }

        if (args.GetValue(CliOptions.FaithfulnessTest))
        {
            // Unified faithfulness test: decompile + recompile-verify +
            // metadata fidelity in one pass. Exits with 0 on full pass,
            // 1 on any failure.
            string? input = args.GetValue(CliOptions.InputPath);
            string folder = input is not null
                ? Path.GetFullPath(input)
                : FindOutputRoot();
            if (!Directory.Exists(folder))
            {
                Console.WriteLine($"Input not found: {folder}");
                return 1;
            }
            return RunFaithfulnessTest(folder, args);
        }

        string inputPath = args.GetValue(CliOptions.InputPath) ?? DefaultInputFolder();
        
        // Output root for the generated .shader (+ opt-in program*.bin/
        // .dxbc/.hlsl artifacts). Defaults to the project-local Output/ so
        // results are visible inside the IDE; --out-root overrides it.
        string outRoot = args.GetValue(CliOptions.OutRoot) ?? Decompiler.ProjectOutputRoot();

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
                return 1;
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
                return 1;
            }

            project = ShaderProject.LoadFromFolder(dir!);
        }
        else
        {
            Console.WriteLine($"Input not found: {inputPath}");
            return 1;
        }

        DecompileOptions decompileOptions = new DecompileOptions
        {
            OutRoot = outRoot,
            DumpStages = args.GetValue(CliOptions.DumpStages),
            DumpKeywords = args.GetValue(CliOptions.DumpKeywords),
            FailOnError = args.GetValue(CliOptions.FailOnError),
            SaveSubprograms = args.GetValue(CliOptions.SaveSubprograms),
            FuseTemps = !args.GetValue(CliOptions.NoFuseTemps),
            ReconstructSurfaceShaders = !args.GetValue(CliOptions.NoSurfaceShaders),
            KeepPasses = args.GetValue(CliOptions.KeepPasses),
            KeepRegisterBindings = args.GetValue(CliOptions.KeepRegisterBindings),
            Verbose = true,
        };

        Decompiler.Decompile(project, decompileOptions);
        return 0;
    }

    // Locate the decompiler Output/ folder regardless of the launch directory.
    private static string FindOutputRoot() => Decompiler.FindOutputRoot();

    // No-args input: the Corpus_01 Properties Stage 0 folder. Check the
    // working directory first, then one level up (the historical layout where
    // the app was launched from its own project folder).
    private static string DefaultInputFolder()
    {
        string cwd = Directory.GetCurrentDirectory();
        string[] candidates =
        {
            Path.Combine(cwd, "Output", "Corpus_01 Properties"),
            Path.Combine(cwd, "..", "Output", "Corpus_01 Properties"),
        };

        return candidates.FirstOrDefault(Directory.Exists) ?? candidates[0];
    }

    // Runs the full decompilation pipeline on a single blob folder, then
    // verifies the output .shader against the original DXBC bytecode.
    private static int RunFaithfulnessTest(string folder, ParseResult args)
    {
        string outRoot = args.GetValue(CliOptions.OutRoot) ?? Decompiler.ProjectOutputRoot();

        ShaderProject project;
        try
        {
            project = ShaderProject.LoadFromFolder(folder);
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Failed to load {folder}: {ex.Message}");
            return 1;
        }

        Console.WriteLine($"=== Faithfulness test: {project.Metadata.Name} ===");
        Console.WriteLine($"Input: {folder}");
        Console.WriteLine();

        DecompilationResult result;
        try
        {
            result = Decompiler.Decompile(project, new DecompileOptions
            {
                OutRoot = outRoot,
                FailOnError = args.GetValue(CliOptions.FailOnError),
                FuseTemps = !args.GetValue(CliOptions.NoFuseTemps),
                ReconstructSurfaceShaders = !args.GetValue(CliOptions.NoSurfaceShaders),
                KeepPasses = args.GetValue(CliOptions.KeepPasses),
                Verbose = false,
            });
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Decompilation failed: {ex}");
            return 1;
        }

        Console.WriteLine($"Decompiled: {result.OutputPath} ({result.ShaderText.Length} chars)");
        Console.WriteLine();

        // ── Run faithfulness checks ──
        FaithfulnessTest.Result report = FaithfulnessTest.Run(folder, result.ShaderText, outRoot);
        report.PipelineCompleted = true;
        return FaithfulnessTest.PrintReport(result.OutputPath!, report);
    }
}
