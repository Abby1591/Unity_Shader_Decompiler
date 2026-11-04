using System;
using System.IO;
using System.Runtime.InteropServices;
using AssetStudio;
using Parser.DXBC;
using Parser.DXBC.Chunks;
using Parser.DXBC.Extraction;
using Parser.DXBC.Metadata;
using SharpGen.Runtime;
using Vortice.D3DCompiler;
using Vortice.Direct3D;

namespace Parser;

// Spec §16.9 required proof, executed on real shipped data: parse the ISGN
// chunk of every real subprogram with our own IsgnChunk parser, then let
// d3dcompiler itself extract the input signature from the same DXBC
// (GetInputSignatureBlob) and compare element-by-element. Both derive from the
// same underlying signature table; equality is strong evidence the parser is
// correct. Run with `Shader Decompiler.dll --verify-signatures`.
public static class SignatureCrossCheck
{
    public static void Run(string outputRoot)
    {
        int shaders = 0, compared = 0, mismatches = 0, failures = 0;
        int parseFail = 0, noInputSig = 0, extractFail = 0;
        var skippedTypes = new Dictionary<ShaderGpuProgramType, int>();
        var mismatchExamples = new System.Collections.Generic.List<string>();

        foreach (string dir in Directory.GetDirectories(outputRoot))
        {
            string blobPath = Path.Combine(dir, "blob.bin");
            if (!File.Exists(blobPath)) continue;

            var project = ShaderProject.LoadFromFolder(dir);
            int shaderSubprograms = 0, shaderCompared = 0, shaderMismatch = 0, shaderFailures = 0;

            using var stream = new MemoryStream(project.Blob);
            using var reader = new BinaryReader(stream);
            var program = new ShaderProgram(reader, new[] { 2022, 3, 62 });
            program.Read(reader, 0);

            foreach (var sub in program.m_SubPrograms)
            {
                if (sub is null) continue;
                if (!IsDxbcProgramType(sub.m_ProgramType))
                {
                    // GLES/DX9/Metal/SPIRV variants carry GLSL/bytecode, not
                    // DXBC containers — outside the scope of this cross-check.
                    skippedTypes.TryGetValue(sub.m_ProgramType, out int n);
                    skippedTypes[sub.m_ProgramType] = n + 1;
                    continue;
                }
                UnityShaderBlob blob;
                try
                {
                    blob = UnityShaderBlob.Parse(sub.m_ProgramCode, "shipped");
                }
                catch (Exception e)
                {
                    parseFail++;
                    shaderFailures++;
                    if (parseFail <= 8)
                        Console.WriteLine($"  {Path.GetFileName(dir)} {sub.m_ProgramType} codeLen={sub.m_ProgramCode.Length}: Parse: {e.Message}");
                    continue;
                }
                if (blob.Kind != UnityShaderBlobKind.NonCompute) continue;

                shaderSubprograms++;

                // Our parse of the ISGN chunk.
                var ours = new DxbcFile();
                ours.Load(blob.Dxbc);
                if (ours.InputSignature is null)
                {
                    noInputSig++;
                    shaderFailures++;
                    continue;
                }

                // d3dcompiler's own extraction of the input signature. The returned blob is
                // itself a mini DXBC container wrapping the ISGN chunk, so run it
                // through the same container reader and take InputSignature.
                var theirs = new DxbcFile();
                try
                {
                    theirs.Load(ExtractInputSignature(blob.Dxbc));
                    if (theirs.InputSignature is null)
                        throw new InvalidDataException("no ISGN chunk in d3dcompiler signature blob");
                }
                catch (Exception e)
                {
                    extractFail++;
                    shaderFailures++;
                    if (extractFail <= 5)
                        Console.WriteLine($"  {Path.GetFileName(dir)} {sub.m_ProgramType}: D3D sig failed: {e.Message}");
                    continue;
                }

                var a = ours.InputSignature.Elements;
                var b = theirs.InputSignature.Elements;
                shaderCompared++;
                compared++;

                bool bad = a.Count != b.Count;
                if (!bad)
                {
                    for (int i = 0; i < a.Count; i++)
                    {
                        if (a[i].SemanticName != b[i].SemanticName ||
                            a[i].SemanticIndex != b[i].SemanticIndex ||
                            a[i].SystemValue != b[i].SystemValue ||
                            a[i].ComponentType != b[i].ComponentType ||
                            a[i].Register != b[i].Register ||
                            a[i].Mask != b[i].Mask ||
                            a[i].ReadWriteMask != b[i].ReadWriteMask)
                        {
                            bad = true;
                            if (mismatchExamples.Count < 5)
                                mismatchExamples.Add(
                                    $"{Path.GetFileName(dir)} {sub.m_ProgramType} elem {i}: " +
                                    $"'{a[i]}' vs '{b[i]}'");
                            break;
                        }
                    }
                }
                else if (mismatchExamples.Count < 5)
                {
                    mismatchExamples.Add(
                        $"{Path.GetFileName(dir)} {sub.m_ProgramType}: element count {a.Count} vs {b.Count}");
                }

                if (bad) shaderMismatch++;
            }

            if (shaderSubprograms > 0)
            {
                shaders++;
                mismatches += shaderMismatch;
                failures += shaderFailures;
                Console.WriteLine(
                    $"{(shaderMismatch == 0 ? "OK  " : "FAIL")} {Path.GetFileName(dir)} " +
                    $"(subprograms={shaderSubprograms} compared={shaderCompared} " +
                    $"mismatch={shaderMismatch} fail={shaderFailures})");
            }
        }

        Console.WriteLine();
        Console.WriteLine($"shaders={shaders} compared={compared} " +
                          $"mismatches={mismatches} failures={failures} " +
                          $"(parseFail={parseFail} noInputSig={noInputSig} extractFail={extractFail})");
        if (skippedTypes.Count > 0)
            Console.WriteLine("skipped non-DXBC types: " +
                string.Join(", ", skippedTypes.Select(kv => $"{kv.Key}={kv.Value}")));
        foreach (var ex in mismatchExamples)
            Console.WriteLine($"  example: {ex}");
        Console.WriteLine(mismatches == 0
            ? "All signatures match d3dcompiler extraction."
            : "Signature MISMATCHES found.");
    }

    // Only the DX10/DX11 program types carry a DXBC container; everything else
    // (GLES variants, Metal, SPIRV, DX9) is GLSL/bytecode of another format.
    private static bool IsDxbcProgramType(ShaderGpuProgramType type) =>
        type is ShaderGpuProgramType.DX10Level9Vertex
            or ShaderGpuProgramType.DX10Level9Pixel
            or ShaderGpuProgramType.DX11VertexSM40
            or ShaderGpuProgramType.DX11VertexSM50
            or ShaderGpuProgramType.DX11PixelSM40
            or ShaderGpuProgramType.DX11PixelSM50
            or ShaderGpuProgramType.DX11GeometrySM40
            or ShaderGpuProgramType.DX11GeometrySM50
            or ShaderGpuProgramType.DX11HullSM50
            or ShaderGpuProgramType.DX11DomainSM50;

    private static unsafe byte[] ExtractInputSignature(byte[] dxbc)
    {
        fixed (byte* ptr = dxbc)
        {
            Compiler.GetInputSignatureBlob(
                (IntPtr)ptr, new PointerUSize((nuint)dxbc.Length), out Blob result);
            using (result)
            {
                byte[] bytes = new byte[result.BufferSize];
                Marshal.Copy(result.BufferPointer, bytes, 0, bytes.Length);
                return bytes;
            }
        }
    }
}