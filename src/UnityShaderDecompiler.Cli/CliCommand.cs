using System.CommandLine;
using System.CommandLine.Parsing;

namespace UnityShaderDecompiler.Cli;

public static class CliCommand
{
    public static RootCommand Create()
    {
        RootCommand command = new("Decompile Unity DXBC shaders to ShaderLab/HLSL")
        {
            CliOptions.InputPath, CliOptions.OutRoot, CliOptions.FailOnError,
            CliOptions.DumpStages, CliOptions.DumpKeywords, CliOptions.SaveSubprograms,
            CliOptions.NoFuseTemps, CliOptions.NoSurfaceShaders, CliOptions.KeepPasses,
            CliOptions.KeepRegisterBindings, CliOptions.RunSpecTests, CliOptions.VerifySignatures,
            CliOptions.StripSurvivors, CliOptions.RecompileVerify, CliOptions.RecompileVerifyAll,
            CliOptions.Disassemble, CliOptions.FaithfulnessTest
        };

        command.Validators.Add(Validate);
        return command;
    }

    private static void ValidateOutRoot(OptionResult result)
    {
        string? directory = result.GetValueOrDefault<string>();
        if (string.IsNullOrWhiteSpace(directory) || directory.StartsWith("--", StringComparison.Ordinal))
        {
            result.AddError("--out-root requires a directory path (use ./ for names starting with --).");
        }
    }

    private static void Validate(CommandResult result)
    {
        if (result.GetResult(CliOptions.OutRoot) is OptionResult outRoot && outRoot.Tokens.Count > 0)
        {
            ValidateOutRoot(outRoot);
        }

        Option<bool>[] modes =
        [
            CliOptions.RunSpecTests, CliOptions.VerifySignatures, CliOptions.StripSurvivors, CliOptions.RecompileVerify,
            CliOptions.RecompileVerifyAll, CliOptions.Disassemble, CliOptions.FaithfulnessTest
        ];
        if (modes.Count(mode => result.GetValue(mode)) > 1)
        {
            result.AddError("Only one verification or analysis mode can be selected.");
        }

        string? inputPath = result.GetValue(CliOptions.InputPath);
        if (inputPath is null)
        {
            return;
        }

        if (result.GetValue(CliOptions.RunSpecTests) || result.GetValue(CliOptions.StripSurvivors))
        {
            result.AddError("This mode does not accept an input path.");
            return;
        }

        bool expectsDirectory = result.GetValue(CliOptions.VerifySignatures) || result.GetValue(CliOptions.RecompileVerifyAll)
            || result.GetValue(CliOptions.Disassemble) || result.GetValue(CliOptions.FaithfulnessTest);
        bool inputExists;
        if (expectsDirectory)
        {
            inputExists = Directory.Exists(inputPath);
        }
        else if (result.GetValue(CliOptions.RecompileVerify))
        {
            inputExists = File.Exists(inputPath);
        }
        else
        {
            inputExists = Directory.Exists(inputPath) || File.Exists(inputPath);
        }

        if (!inputExists)
        {
            result.AddError($"Input not found: {inputPath}");
        }
    }
}
