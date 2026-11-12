namespace AssetStudio;

public static class ShaderPlatform
{
    // all DirectX except DX9
    public static bool IsDXBC(ShaderGpuProgramType programType)
        => programType.ToString().StartsWith("DX", StringComparison.Ordinal) && !IsDX9(programType);

    public static bool IsDX9(ShaderGpuProgramType programType)
        => programType.ToString().StartsWith("DX9", StringComparison.Ordinal);

    public static bool IsOpenGL(ShaderGpuProgramType programType)
        => programType.ToString().StartsWith("GL", StringComparison.Ordinal);

    public static bool IsVulkan(ShaderGpuProgramType programType)
        => programType == ShaderGpuProgramType.SPIRV;

    public static bool IsMetal(ShaderGpuProgramType programType)
        => programType.ToString().StartsWith("Metal", StringComparison.Ordinal);

    public static bool IsConsole(ShaderGpuProgramType programType)
        => programType.ToString().StartsWith("Console", StringComparison.Ordinal)
           || programType.ToString().StartsWith("PS", StringComparison.Ordinal);
}
