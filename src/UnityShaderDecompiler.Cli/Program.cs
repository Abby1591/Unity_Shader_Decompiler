using System;
using System.IO;
using System.Linq;
using UnityShaderDecompiler.Core.DXBC.Metadata;
using UnityShaderDecompiler.Core;

namespace UnityShaderDecompiler.Cli;

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

        if (args.Contains("--faithfulness-test"))
        {
            // Unified faithfulness test: decompile + recompile-verify +
            // metadata fidelity in one pass. Exits with 0 on full pass,
            // 1 on any failure.
            int ffIdx = Array.IndexOf(args, "--faithfulness-test");
            string folder = ffIdx + 1 < args.Length
                ? Path.GetFullPath(args[ffIdx + 1])
                : FindOutputRoot();
            if (!Directory.Exists(folder))
            {
                Console.WriteLine($"Input not found: {folder}");
                Environment.ExitCode = 1;
                return;
            }
            Environment.ExitCode = RunFaithfulnessTest(folder, args);
            return;
        }

        // args[0] is a folder produced by Extract.py (blob.bin +
        // metadata.json + optional dummy.shader), or a direct blob.bin path.
        // No-args default: the HOLO_Holo input folder under the repo Output/,
        // resolved from either the working directory or one level up so the
        // app works whether it is launched from the repo root or from src/.
        string inputPath = args.Length > 0 ? args[0] : DefaultInputFolder();
        bool failOnError = args.Contains("--fail-on-error");

        // Output root for the generated .shader (+ opt-in program*.bin/
        // .dxbc/.hlsl artifacts). Defaults to the project-local Output/ so
        // results are visible inside the IDE; --out-root overrides it.
        string outRoot = Decompiler.ProjectOutputRoot();
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
                if (failOnError)
                {
                    Environment.ExitCode = 1;
                }
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
                if (failOnError)
                {
                    Environment.ExitCode = 1;
                }
                return;
            }

            project = ShaderProject.LoadFromFolder(dir!);
        }
        else
        {
            Console.WriteLine($"Input not found: {inputPath}");
            if (failOnError)
            {
                Environment.ExitCode = 1;
            }
            return;
        }

        var options = new DecompileOptions
        {
            OutRoot = outRoot,
            DumpStages = args.Contains("--dump-stages"),
            DumpKeywords = args.Contains("--dump-keywords"),
            FailOnError = failOnError,
            SaveSubprograms = args.Contains("--save-subprograms"),
            FuseTemps = !args.Contains("--no-fuse-temps"),
            ReconstructSurfaceShaders = !args.Contains("--no-surface-shaders"),
            KeepPasses = args.Contains("--keep-passes"),
            KeepRegisterBindings = args.Contains("--keep-register-bindings"),
            Verbose = true,
        };

        try { Decompiler.Decompile(project, options); }
        catch (Exception error) when (options.FailOnError)
        {
            Console.Error.WriteLine(error.Message);
            Environment.ExitCode = 1;
        }
    }

    // Locate the decompiler Output/ folder regardless of the launch directory.
    private static string FindOutputRoot() => Decompiler.FindOutputRoot();

    // No-args input: the HOLO_Holo Stage 0 folder. Check the working
    // directory first, then one level up (the historical layout where the app
    // was launched from its own project folder).
    private static string DefaultInputFolder()
    {
        string cwd = Directory.GetCurrentDirectory();
        string[] candidates =
        {
            Path.Combine(cwd, "Output", "HOLO_Holo"),
            Path.Combine(cwd, "..", "Output", "HOLO_Holo"),
        };

        return candidates.FirstOrDefault(Directory.Exists) ?? candidates[0];
    }

    // Runs the full decompilation pipeline on a single blob folder, then
    // verifies the output .shader against the original DXBC bytecode.
    private static int RunFaithfulnessTest(string folder, string[] args)
    {
        string outRoot = Decompiler.ProjectOutputRoot();
        int outRootFlag = Array.IndexOf(args, "--out-root");
        if (outRootFlag >= 0 && outRootFlag + 1 < args.Length)
            outRoot = args[outRootFlag + 1];

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
                FailOnError = args.Contains("--fail-on-error"),
                FuseTemps = !args.Contains("--no-fuse-temps"),
                ReconstructSurfaceShaders = !args.Contains("--no-surface-shaders"),
                KeepPasses = args.Contains("--keep-passes"),
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
        var report = FaithfulnessTest.Run(folder, result.ShaderText, outRoot);
        report.PipelineCompleted = true;
        return FaithfulnessTest.PrintReport(result.OutputPath!, report);
    }
}
