using System.CommandLine;

namespace UnityShaderDecompiler.Cli;

public static class CliOptions
{
    public static Argument<string?> InputPath { get; } = new("input")
    {
        Description = "Shader folder, blob.bin, or input for the selected verification mode",
        Arity = ArgumentArity.ZeroOrOne
    };

    public static Option<string?> OutRoot { get; } = new("--out-root")
    {
        Description = "Directory for the generated shader and subprogram artifacts",
        Arity = ArgumentArity.ExactlyOne
    };

    public static Option<bool> FailOnError { get; } = new("--fail-on-error")
    {
        Description = "Stop as soon as a subprogram encounters a decompilation error"
    };

    public static Option<bool> DumpStages { get; } = new("--dump-stages")
    {
        Description = "Print IR snapshots after pipeline phases and optimization passes"
    };

    public static Option<bool> DumpKeywords { get; } = new("--dump-keywords")
    {
        Description = "Print each subprogram's keywords"
    };

    public static Option<bool> SaveSubprograms { get; } = new("--save-subprograms")
    {
        Description = "Write per-subprogram binary, DXBC, and disassembly files"
    };

    public static Option<bool> NoFuseTemps { get; } = new("--no-fuse-temps")
    {
        Description = "Disable temporary-variable fusion"
    };

    public static Option<bool> NoSurfaceShaders { get; } = new("--no-surface-shaders")
    {
        Description = "Disable surface-shader recognition"
    };

    public static Option<bool> KeepPasses { get; } = new("--keep-passes")
    {
        Description = "Keep original passes as comments when reconstructing surface shaders"
    };

    public static Option<bool> KeepRegisterBindings { get; } = new("--keep-register-bindings")
    {
        Description = "Keep explicit register bindings in the generated HLSL"
    };

    public static Option<bool> RunSpecTests { get; } = new("--run-spec-tests")
    {
        Description = "Run the offline parser spec vectors"
    };

    public static Option<bool> VerifySignatures { get; } = new("--verify-signatures")
    {
        Description = "Cross-check signatures in the input directory using d3dcompiler"
    };

    public static Option<bool> StripSurvivors { get; } = new("--strip-survivors")
    {
        Description = "Analyze DXBC chunks retained by D3DStripShader"
    };

    public static Option<bool> RecompileVerify { get; } = new("--recompile-verify")
    {
        Description = "Recompile and verify the input shader file"
    };

    public static Option<bool> RecompileVerifyAll { get; } = new("--recompile-verify-all")
    {
        Description = "Recompile and verify all shaders in the input directory"
    };

    public static Option<bool> Disassemble { get; } = new("--disasm")
    {
        Description = "Write DXBC disassembly for shaders in the input directory"
    };

    public static Option<bool> FaithfulnessTest { get; } = new("--faithfulness-test")
    {
        Description = "Decompile the input folder and verify signatures and metadata"
    };

}
