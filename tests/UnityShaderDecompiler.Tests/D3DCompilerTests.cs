using System;
using System.Text;
using Parser;
using Parser.DXBC.Compilation;

namespace UnityShaderDecompiler.Tests;

/// <summary>
/// Windows-only checks that exercise the native d3dcompiler path. These are
/// tagged <c>Category=D3D</c> so CI can run them on Windows only (they are
/// no-ops elsewhere rather than failing on a missing DLL).
/// </summary>
public class D3DCompilerTests
{
    [Fact]
    [Trait("Category", "D3D")]
    public void CompileHlsl_SimpleVertexShader_ProducesDxbc()
    {
        if (!OperatingSystem.IsWindows())
            return;

        const string hlsl =
            "float4 main(float4 position : POSITION) : SV_POSITION { return position; }";

        byte[] dxbc = DxbcCompiler.Compile(hlsl, "main", "vs_5_0");

        Assert.True(dxbc.Length > 4);
        Assert.Equal("DXBC", Encoding.ASCII.GetString(dxbc, 0, 4));
    }

    [Fact]
    [Trait("Category", "D3D")]
    public void CompileHlsl_InvalidSource_Throws()
    {
        if (!OperatingSystem.IsWindows())
            return;

        Assert.ThrowsAny<Exception>(() =>
            DxbcCompiler.Compile("this is not hlsl", "main", "vs_5_0"));
    }
}
