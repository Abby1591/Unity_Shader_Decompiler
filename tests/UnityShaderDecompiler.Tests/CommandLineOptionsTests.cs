using System.CommandLine;
using UnityShaderDecompiler.Cli;

namespace UnityShaderDecompiler.Tests;

public class CommandLineOptionsTests
{
    [Theory]
    [InlineData("--fail-on-error", "INPUT", "--out-root", "output folder")]
    [InlineData("INPUT", "--fail-on-error", "--out-root", "output folder")]
    [InlineData("--out-root", "output folder", "--fail-on-error", "INPUT")]
    public void Parse_OptionsInAnyOrder_SeparatesInputAndOutput(params string[] args)
    {
        string input = TestPaths.FixtureFolder("Corpus_01 Properties");
        RootCommand command = CliCommand.Create();
        ParseResult result = command.Parse(args.Select(arg => arg == "INPUT" ? input : arg).ToArray());

        Assert.Empty(result.Errors);
        Assert.Equal(input, result.GetValue(CliOptions.InputPath));
        Assert.Equal("output folder", result.GetValue(CliOptions.OutRoot));
        Assert.True(result.GetValue(CliOptions.FailOnError));
    }

    [Fact]
    public void Parse_NoArguments_LeavesPathsUnset()
    {
        RootCommand command = CliCommand.Create();
        ParseResult result = command.Parse([]);

        Assert.Empty(result.Errors);
        Assert.Null(result.GetValue(CliOptions.InputPath));
        Assert.Null(result.GetValue(CliOptions.OutRoot));
        Assert.False(result.GetValue(CliOptions.FailOnError));
    }

    [Fact]
    public void Parse_OutputOnly_DoesNotTreatOutputAsInput()
    {
        RootCommand command = CliCommand.Create();
        ParseResult result = command.Parse(["--out-root=output folder"]);

        Assert.Empty(result.Errors);
        Assert.Null(result.GetValue(CliOptions.InputPath));
        Assert.Equal("output folder", result.GetValue(CliOptions.OutRoot));
    }

    [Theory]
    [InlineData("--verify-signatures")]
    [InlineData("--recompile-verify-all")]
    [InlineData("--disasm")]
    [InlineData("--faithfulness-test")]
    public void Parse_DirectoryMode_AcceptsInputBeforeOrAfterMode(string mode)
    {
        string input = TestPaths.FixtureFolder("Corpus_01 Properties");
        RootCommand command = CliCommand.Create();

        ParseResult before = command.Parse([input, mode]);
        ParseResult after = command.Parse([mode, input]);

        Assert.Empty(before.Errors);
        Assert.Empty(after.Errors);
        Assert.Equal(input, before.GetValue(CliOptions.InputPath));
        Assert.Equal(input, after.GetValue(CliOptions.InputPath));
    }

    [Theory]
    [InlineData("--out-root")]
    [InlineData("--out-root", "--fail-on-error")]
    [InlineData("--out-root", "")]
    [InlineData("--unknown")]
    [InlineData("--fail-on-error=invalid")]
    [InlineData("first", "second")]
    [InlineData("--disasm", "--faithfulness-test")]
    [InlineData("--verify-signatures", "--recompile-verify-all")]
    [InlineData("--run-spec-tests", "input")]
    [InlineData("--strip-survivors", "input")]
    public void Parse_InvalidArguments_ReturnsOneWithoutRunningCommand(params string[] args)
    {
        RootCommand command = CliCommand.Create();
        bool executed = false;
        command.SetAction(_ =>
        {
            executed = true;
            return 0;
        });
        using StringWriter output = new();
        using StringWriter error = new();

        int exitCode = command.Parse(args).Invoke(new InvocationConfiguration
        {
            Output = output, Error = error
        });

        Assert.Equal(1, exitCode);
        Assert.False(executed);
        Assert.False(string.IsNullOrWhiteSpace(error.ToString()));
    }

    [Fact]
    public void Parse_MissingInput_ReportsRequestedPath()
    {
        using TempDirectory temp = new();
        string missing = Path.Combine(temp.Path, "missing");
        RootCommand command = CliCommand.Create();

        ParseResult result = command.Parse(["--fail-on-error", missing]);

        Assert.Contains(result.Errors, error => error.Message == $"Input not found: {missing}");
    }
}
