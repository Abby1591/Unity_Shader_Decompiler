using System;
using System.Text;
using UnityShaderDecompiler.Core;
using UnityShaderDecompiler.Core.DXBC;
using UnityShaderDecompiler.Core.DXBC.Compilation;
using UnityShaderDecompiler.Core.DXBC.IR;
using UnityShaderDecompiler.Core.Hlsl.Ast;
using AssetStudio;

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
    public void CompileHlsl_DecompiledGeometryShader_Compiles()
    {
        if (!OperatingSystem.IsWindows())
            return;

        string text = FixtureCache.Decompile("Corpus_18 Geometry Shader").ShaderText;
        int start = text.IndexOf("HLSLPROGRAM", StringComparison.Ordinal) + "HLSLPROGRAM".Length;
        int end = text.IndexOf("ENDHLSL", start, StringComparison.Ordinal);
        string block = text[start..end];

        Assert.Contains("#pragma geometry geom", block);
        byte[] dxbc = DxbcCompiler.Compile(block, "geom", "gs_5_0");

        Assert.Equal("DXBC", Encoding.ASCII.GetString(dxbc, 0, 4));
    }

    [Fact]
    [Trait("Category", "D3D")]
    public void DomainPatchConstantReads_RouteToConstParameter()
    {
        if (!OperatingSystem.IsWindows())
            return;

        // A domain shader that actually reads its tess factors: the vpcN
        // registers must become fields of the CONST patch-constant parameter.
        const string hlsl = """
            struct V2H { float4 pos : POSITION; float3 normal : NORMAL; };
            struct H2D { float4 pos : SV_POSITION; };
            struct HS_CONST { float edges[3] : SV_TessFactor; float inside : SV_InsideTessFactor; };
            [domain("tri")]
            H2D domain(HS_CONST CONST, float3 bary : SV_DomainLocation, const OutputPatch<V2H, 3> patch)
            {
                H2D o;
                o.pos = patch[0].pos * bary.x + patch[1].pos * bary.y + patch[2].pos * bary.z;
                o.pos *= CONST.edges[1] + CONST.inside;
                return o;
            }
            """;

        byte[] dxbc = DxbcCompiler.Compile(hlsl, "domain", "ds_5_0");
        var file = new DxbcFile();
        file.Load(dxbc);
        IRPipeline.Result pipeline = IRPipeline.Run(file);
        HlslFunctionNode? fn = HlslAstBuilder.BuildFunction(
            "program0", ShaderGpuProgramType.DX11DomainSM50,
            pipeline.Program.Declarations, pipeline.Blocks,
            file.InputSignature, file.OutputSignature, file.PatchConstantSignature);
        Assert.NotNull(fn);

        var pass = new HlslPassNode { DomainFunction = fn };
        foreach (HlslStructNode? s in new[] { fn.InputStruct, fn.OutputStruct, fn.PatchConstantStruct })
            if (s is not null)
                pass.Structs.Add(s);
        var subShader = new HlslSubShaderNode();
        subShader.Passes.Add(pass);
        var shader = new HlslShaderNode { Name = "DomainPatchConstant" };
        shader.SubShaders.Add(subShader);

        string text = HlslPrettyPrinter.Print(shader, fuseTemps: false);

        Assert.Contains("[domain(\"tri\")]", text);
        Assert.Contains("program0PatchConstant CONST", text);
        Assert.Contains("CONST.edges[1]", text);
        Assert.Contains("CONST.inside", text);

        // The emitted domain still compiles with the tess factors it reads.
        int start = text.IndexOf("HLSLPROGRAM", StringComparison.Ordinal) + "HLSLPROGRAM".Length;
        int end = text.IndexOf("ENDHLSL", start, StringComparison.Ordinal);
        byte[] roundTrip = DxbcCompiler.Compile(text[start..end], "domain", "ds_5_0");
        Assert.Equal("DXBC", Encoding.ASCII.GetString(roundTrip, 0, 4));
    }

    [Fact]
    [Trait("Category", "D3D")]
    public void CompileHlsl_DecompiledHullAndDomain_Compile()
    {
        if (!OperatingSystem.IsWindows())
            return;

        string text = FixtureCache.Decompile("Corpus_19 Hull Domain").ShaderText;
        int start = text.IndexOf("HLSLPROGRAM", StringComparison.Ordinal) + "HLSLPROGRAM".Length;
        int end = text.IndexOf("ENDHLSL", start, StringComparison.Ordinal);
        string block = text[start..end];

        Assert.Contains("#pragma hull hull", block);
        Assert.Contains("#pragma domain domain", block);
        Assert.Equal("DXBC", Encoding.ASCII.GetString(DxbcCompiler.Compile(block, "hull", "hs_5_0"), 0, 4));
        Assert.Equal("DXBC", Encoding.ASCII.GetString(DxbcCompiler.Compile(block, "domain", "ds_5_0"), 0, 4));
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
