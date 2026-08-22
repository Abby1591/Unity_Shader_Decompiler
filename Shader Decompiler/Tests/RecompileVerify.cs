using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using AssetStudio;
using Parser.DXBC;
using Parser.DXBC.Chunks;
using Parser.DXBC.Disassembly;
using Parser.DXBC.Extraction;
using Parser.DXBC.Metadata;
using Vortice.D3DCompiler;
using Vortice.Direct3D;

namespace Parser;

// Recompile-verification harness (the gate that --surface-shaders waits on):
// every HLSLPROGRAM pass in a decompiled .shader is compiled with real
// d3dcompiler (vs_5_0/ps_5_0) and its input/output signature is compared
// against the shipped subprograms of the sibling blob.bin. A pass is faithful
// when some shipped subprogram carries the exact same ISGN+OSGN element set.
// Run with `Shader Decompiler.dll --recompile-verify <path to .shader>`.
public static class RecompileVerify
{
    public static void Run(string shaderFile)
    {
        string text = File.ReadAllText(shaderFile);
        string dir = Path.GetDirectoryName(shaderFile) ?? ".";
        // The .shader is written to the Output ROOT while its blob.bin lives
        // in the per-name subfolder (Output\{name}\blob.bin); the folder
        // name equals the .shader file's base name.
        string blobPath = Path.Combine(dir, Path.GetFileNameWithoutExtension(shaderFile), "blob.bin");

        // Shipped subprogram signatures, keyed by element-string set.
        var shipped = new List<(string Stage, string Label, HashSet<string> Input, HashSet<string> Output)>();
        if (File.Exists(blobPath))
            shipped.AddRange(LoadShipped(blobPath));

        Console.WriteLine($"{shipped.Count} shipped subprograms:");
        foreach (var s in shipped)
            Console.WriteLine($"  {s.Stage} {s.Label}: in[{string.Join(" ", s.Input)}] out[{string.Join(" ", s.Output)}]");
        Console.WriteLine();

        int passes = 0, compiled = 0, matched = 0, failures = 0;
        var unmatched = new List<string>();

        foreach (string block in ExtractHlslProgramBlocks(text))
        {
            passes++;
            string label = $"pass{passes}";
            string? vsEntry = PragmaEntry(block, "vertex");
            string? psEntry = PragmaEntry(block, "fragment");
            if (vsEntry is null && psEntry is null) continue;

            CompilePass(block, vsEntry, "vs_5_0", label, "Vertex", out var vsIn, out var vsOut, out string? vsErr);
            CompilePass(block, psEntry, "ps_5_0", label, "Fragment", out var psIn, out var psOut, out string? psErr);

            if (vsErr is not null || psErr is not null)
            {
                failures++;
                Console.WriteLine($"  {label}: compile FAILED");
                if (vsErr is not null) Console.WriteLine($"      vs: {FirstErrors(vsErr)}");
                if (psErr is not null) Console.WriteLine($"      ps: {FirstErrors(psErr)}");
                continue;
            }
            compiled++;

            var matches = shipped.Where(s =>
                vsEntry is not null && s.Stage == "Vertex" && SetsEqual(s.Input, vsIn) && SetsEqual(s.Output, vsOut)
                || psEntry is not null && s.Stage == "Fragment" && SetsEqual(s.Input, psIn) && SetsEqual(s.Output, psOut)).ToList();

            if (matches.Count == 0)
            {
                unmatched.Add(label);
                Console.WriteLine($"  {label}: compiled but NO shipped subprogram matches " +
                    $"(vs in={vsIn.Count} out={vsOut.Count} | ps in={psIn.Count} out={psOut.Count})");
                DumpSigDiff(label, shipped, vsEntry, vsIn, vsOut, psEntry, psIn, psOut);
            }
            else
            {
                matched += matches.Count;
                Console.WriteLine($"  {label}: MATCHES {matches.Count} shipped subprogram(s) " +
                    $"(vs in={vsIn.Count} out={vsOut.Count} | ps in={psIn.Count} out={psOut.Count})");
            }
        }

        Console.WriteLine();
        Console.WriteLine($"passes={passes} compiled={compiled} " +
                          $"matched={matched} compileFailures={failures}");
        Console.WriteLine(shipped.Count > 0
            ? (unmatched.Count == 0 && failures == 0
                ? "ALL decompiled passes recompile to signatures present in shipped bytecode."
                : "Some passes did not match shipped bytecode.")
            : "No blob.bin found next to the .shader; compile results only.");
    }

    private static void CompilePass(string block, string? entry, string profile, string label,
        string stage, out HashSet<string> sigIn, out HashSet<string> sigOut, out string? error)
    {
        sigIn = new();
        sigOut = new();
        if (entry is null)
        {
            // Stage not present in this pass (fragment-only image effects):
            // not a failure, nothing to compile or match.
            error = null;
            return;
        }

        byte[] dxbc;
        try
        {
            dxbc = Compile(block, entry, profile);
        }
        catch (Exception e)
        {
            error = e.Message;
            return;
        }
        error = null;

        var file = new DxbcFile();
        file.Load(dxbc);
        sigIn = file.InputSignature?.Elements.Select(Canonical).ToHashSet() ?? new();
        sigOut = file.OutputSignature?.Elements.Select(Canonical).ToHashSet() ?? new();
    }

    // Signature identity for matching. Excludes register numbers (allocation
    // artifacts) and the mask's lane POSITIONS: d3dcompiler freely packs
    // pairs of float2 outputs onto one register (TEXCOORD1 mask 0xC) where
    // the original compiler used separate registers (mask 0x3), so the same
    // interface compiles to different masks. The component COUNT is what
    // matters — a float2 vs float3 field is a real decompiler bug and still
    // mismatches via the popcount.
    private static string Canonical(SignatureElement e) =>
        $"{e.SemanticName}:{e.SemanticIndex}:{e.SystemValue}:{System.Numerics.BitOperations.PopCount(e.Mask)}";

    private static bool SetsEqual(HashSet<string> a, HashSet<string> b) =>
        a.SetEquals(b);

    // Shows which elements differ between a recompiled pass and the shipped
    // subprograms of the same stage, so a mismatch is diagnosable instead of
    // a bare count.
    private static void DumpSigDiff(string label, List<(string Stage, string Label, HashSet<string> Input, HashSet<string> Output)> shipped,
        string? vsEntry, HashSet<string> vsIn, HashSet<string> vsOut,
        string? psEntry, HashSet<string> psIn, HashSet<string> psOut)
    {
        if (vsEntry is not null)
        {
            var cand = shipped.Where(s => s.Stage == "Vertex").Select(s => (s.Input, s.Output)).ToList();
            Console.WriteLine($"      vs: {DescribeVs(vsIn, vsOut)}");
            if (cand.Count > 0)
            {
                var first = cand[0];
                Console.WriteLine($"      shipped vs[0] {first.Input.Count}/{first.Output.Count}:");
                Console.WriteLine($"        in  {string.Join(" ", first.Input)}");
                Console.WriteLine($"        out {string.Join(" ", first.Output)}");
            }
        }
        if (psEntry is not null)
        {
            var cand = shipped.Where(s => s.Stage == "Fragment").Select(s => (s.Input, s.Output)).ToList();
            Console.WriteLine($"      ps: {DescribeVs(psIn, psOut)}");
            if (cand.Count > 0)
            {
                var first = cand[0];
                Console.WriteLine($"      shipped ps[0] {first.Input.Count}/{first.Output.Count}:");
                Console.WriteLine($"        in  {string.Join(" ", first.Input)}");
                Console.WriteLine($"        out {string.Join(" ", first.Output)}");
            }
        }
    }

    private static string DescribeVs(HashSet<string> input, HashSet<string> output) =>
        $"in[{string.Join(" ", input)}] out[{string.Join(" ", output)}]";

    // d3dcompiler's error blob is mostly warnings; keep only the actual
    // "error" lines (up to two) so a failing pass is readable.
    private static string FirstErrors(string msg)
    {
        var errors = msg.Split('\n')
            .Where(l => l.Contains("error", StringComparison.OrdinalIgnoreCase))
            .ToList();
        return errors.Count > 0
            ? string.Join(" | ", errors.Take(2))
            : msg.Split('\n').LastOrDefault(l => l.Trim().Length > 0) ?? msg;
    }

    // Dumps the DXBC disassembly of every non-compute subprogram in each
    // folder's blob.bin to <folder>\.disasm.txt — bytecode-level ground
    // truth for diagnosing decompiler output (swizzle/type bugs etc.).
    public static void DumpDisasm(string outputRoot)
    {
        if (File.Exists(Path.Combine(outputRoot, "blob.bin")))
        {
            DumpOne(outputRoot);
            return;
        }
        foreach (string dir in Directory.GetDirectories(outputRoot))
            DumpOne(dir);
    }

    private static void DumpOne(string dir)
    {
        string blobPath = Path.Combine(dir, "blob.bin");
        if (!File.Exists(blobPath)) return;
        var sb = new StringBuilder();
        sb.AppendLine($"# {Path.GetFileName(dir)}");
        foreach (var sub in LoadShipped(blobPath))
        {
            sb.AppendLine($"## {sub.Stage} {sub.Label}");
            sb.AppendLine($"in[{string.Join(" ", sub.Input)}]");
            sb.AppendLine($"out[{string.Join(" ", sub.Output)}]");
            sb.AppendLine(DisassembleSubprogram(blobPath, sub.Label));
        }
        string outFile = Path.Combine(Path.GetDirectoryName(dir)!, Path.GetFileName(dir) + ".disasm.txt");
        File.WriteAllText(outFile, sb.ToString());
        Console.WriteLine($"wrote {outFile}");
    }

    private static string DisassembleSubprogram(string blobPath, string label)
    {
        var project = ShaderProject.LoadFromFolder(Path.GetDirectoryName(blobPath)!);
        using var stream = new MemoryStream(project.Blob);
        using var reader = new BinaryReader(stream);
        var program = new ShaderProgram(reader, new[] { 2022, 3, 62 });
        program.Read(reader, 0);
        foreach (var sub in program.m_SubPrograms)
        {
            if (sub is null || sub.m_ProgramType.ToString() != label) continue;
            try
            {
                var blob = UnityShaderBlob.Parse(sub.m_ProgramCode, "shipped");
                if (blob.Kind != UnityShaderBlobKind.NonCompute) continue;
                return DxbcDisassembler.Disassemble(blob.Dxbc);
            }
            catch (Exception)
            {
            }
        }
        return "(no bytecode)";
    }

    // Category key for a compiler error: the "error Xnnnn" code (plus a
    // short tail hint), never the file://line/column prefix.
    private static string ErrorKey(string err)
    {
        int i = err.LastIndexOf("error X", StringComparison.OrdinalIgnoreCase);
        return i >= 0 ? err[i..] : err;
    }

    // Reads the entry point name from `#pragma vertex NAME` / `#pragma
    // fragment NAME`; returns null when the stage is not present in the
    // pass (image-effect passes are frequently fragment-only).
    private static string? PragmaEntry(string block, string stage) =>
        block.Split('\n')
            .Select(l => l.Trim())
            .FirstOrDefault(l => l.StartsWith($"#pragma {stage}", StringComparison.Ordinal))
            ?.Split(' ', StringSplitOptions.RemoveEmptyEntries)
            .Skip(2).FirstOrDefault();

    // Batch mode: run the per-file check across every decompiled .shader in
    // the Output root and aggregate the metrics, so the surface-shader gate
    // has a single health number instead of 39 ad-hoc runs.
    public static void RunAll(string outputRoot)
    {
        var files = Directory.GetFiles(outputRoot, "*.shader", SearchOption.TopDirectoryOnly)
            .Where(f => !Path.GetFileName(f).StartsWith("_", StringComparison.Ordinal)
                        && !Path.GetFileName(f).Equals("dummy.shader", StringComparison.OrdinalIgnoreCase))
            .OrderBy(f => f, StringComparer.OrdinalIgnoreCase).ToList();

        int passes = 0, compiled = 0, matched = 0, failures = 0;
        var compileBugs = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
        var unmatchedPasses = new List<(string File, string Label)>();

        foreach (string file in files)
        {
            Console.WriteLine($"=== {Path.GetFileName(file)} ===");
            string text = File.ReadAllText(file);
            string dir = Path.GetDirectoryName(file) ?? ".";
            string name = Path.GetFileNameWithoutExtension(file);
            string blobPath = Path.Combine(dir, name, "blob.bin");
            if (!File.Exists(blobPath))
            {
                string? walk = dir;
                for (int i = 0; i < 8 && walk is not null; i++)
                {
                    string candidate = Path.Combine(walk, name, "blob.bin");
                    if (File.Exists(candidate)) { blobPath = candidate; break; }
                    candidate = Path.Combine(walk, "Output", name, "blob.bin");
                    if (File.Exists(candidate)) { blobPath = candidate; break; }
                    walk = Path.GetDirectoryName(walk);
                }
            }
            var shipped = File.Exists(blobPath)
                ? LoadShipped(blobPath)
                : new List<(string Stage, string Label, HashSet<string> Input, HashSet<string> Output)>();

            int p = 0;
            foreach (string block in ExtractHlslProgramBlocks(text))
            {
                p++;
                string label = $"pass{p}";
                passes++;
                string? vsEntry = PragmaEntry(block, "vertex");
                string? psEntry = PragmaEntry(block, "fragment");
                if (vsEntry is null && psEntry is null) continue;

                CompilePass(block, vsEntry, "vs_5_0", label, "Vertex", out var vsIn, out var vsOut, out string? vsErr);
                CompilePass(block, psEntry, "ps_5_0", label, "Fragment", out var psIn, out var psOut, out string? psErr);

                if (vsErr is not null || psErr is not null)
                {
                    failures++;
                    string err = FirstErrors(vsErr ?? psErr ?? "");
                    string key = ErrorKey(err);
                    compileBugs[key] = compileBugs.GetValueOrDefault(key) + 1;
                    Console.WriteLine($"  {Path.GetFileName(file)} {label}: FAILED  {err}");
                    continue;
                }
                compiled++;

                var matches = shipped.Where(s =>
                    vsEntry is not null && s.Stage == "Vertex" && SetsEqual(s.Input, vsIn) && SetsEqual(s.Output, vsOut)
                    || psEntry is not null && s.Stage == "Fragment" && SetsEqual(s.Input, psIn) && SetsEqual(s.Output, psOut)).ToList();
                if (matches.Count == 0)
                {
                    unmatchedPasses.Add((Path.GetFileName(file), label));
                    Console.WriteLine($"  {label}: compiled, unmatched (vs in={vsIn.Count} out={vsOut.Count} | ps in={psIn.Count} out={psOut.Count})");
                }
                else
                {
                    matched += matches.Count;
                    Console.WriteLine($"  {label}: matched {matches.Count}");
                }
            }
        }

        Console.WriteLine();
        Console.WriteLine($"FILES={files.Count} passes={passes} compiled={compiled} matched={matched} compileFailures={failures} unmatched={unmatchedPasses.Count}");
        if (compileBugs.Count > 0)
        {
            Console.WriteLine("Compile-error categories:");
            foreach (var kv in compileBugs.OrderByDescending(kv => kv.Value))
                Console.WriteLine($"  {kv.Value,3}  {kv.Key}");
        }
        if (unmatchedPasses.Count > 0)
        {
            Console.WriteLine("Unmatched passes:");
            foreach (var (f, l) in unmatchedPasses)
                Console.WriteLine($"  {f} {l}");
        }
    }

    private static List<(string Stage, string Label, HashSet<string> Input, HashSet<string> Output)> LoadShipped(string blobPath)
    {
        var project = ShaderProject.LoadFromFolder(Path.GetDirectoryName(blobPath)!);
        var result = new List<(string, string, HashSet<string>, HashSet<string>)>();
        using var stream = new MemoryStream(project.Blob);
        using var reader = new BinaryReader(stream);
        var program = new ShaderProgram(reader, new[] { 2022, 3, 62 });
        program.Read(reader, 0);

        foreach (var sub in program.m_SubPrograms)
        {
            if (sub is null) continue;
            UnityShaderBlob blob;
            try
            {
                blob = UnityShaderBlob.Parse(sub.m_ProgramCode, "shipped");
            }
            catch (Exception)
            {
                continue;
            }
            if (blob.Kind != UnityShaderBlobKind.NonCompute) continue;

            string stage = sub.m_ProgramType is ShaderGpuProgramType.DX11VertexSM40
                    or ShaderGpuProgramType.DX11VertexSM50
                ? "Vertex"
                : sub.m_ProgramType is ShaderGpuProgramType.DX11PixelSM40
                    or ShaderGpuProgramType.DX11PixelSM50
                ? "Fragment"
                : "Other";
            if (stage == "Other") continue;

            var file = new DxbcFile();
            file.Load(blob.Dxbc);
            var input = file.InputSignature?.Elements.Select(Canonical).ToHashSet() ?? new();
            var output = file.OutputSignature?.Elements.Select(Canonical).ToHashSet() ?? new();
            result.Add((stage, sub.m_ProgramType.ToString(), input, output));
        }
        return result;
    }

    private static IEnumerable<string> ExtractHlslProgramBlocks(string text)
    {
        int i = 0;
        while (true)
        {
            int start = text.IndexOf("HLSLPROGRAM", i, StringComparison.Ordinal);
            if (start < 0) yield break;
            start += "HLSLPROGRAM".Length;
            int end = text.IndexOf("ENDHLSL", start, StringComparison.Ordinal);
            if (end < 0) yield break;
            yield return text[start..end];
            i = end + "ENDHLSL".Length;
        }
    }

    // --- d3dcompiler interop (see StripSurvivors for the blob reading) ---
    private static byte[] Compile(string hlsl, string entry, string profile)
    {
        byte[] src = Encoding.UTF8.GetBytes(hlsl);
        int hr = D3DCompile(
            src, (nuint)src.Length, "decompiled.hlsl",
            IntPtr.Zero, IntPtr.Zero, entry, profile,
            (uint)(ShaderFlags.EnableStrictness | ShaderFlags.OptimizationLevel0),
            0, out IntPtr code, out IntPtr errors);
        if (hr < 0 || code == IntPtr.Zero)
        {
            string msg = errors == IntPtr.Zero
                ? $"HRESULT 0x{hr:X8}"
                : ReadComBlobString(errors);
            throw new InvalidOperationException(msg);
        }
        return ReadComBlob(code);
    }

    [DllImport("d3dcompiler_47.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
    private static extern int D3DCompile(
        byte[] pSrcData, nuint srcDataSize, string pSourceName,
        IntPtr pDefines, IntPtr pInclude, string pEntrypoint, string pTarget,
        uint flags1, uint flags2, out IntPtr ppCode, out IntPtr ppErrorMsgs);

    private static byte[] ReadComBlob(IntPtr blob)
    {
        IntPtr vtbl = Marshal.ReadIntPtr(blob);
        var getPtr = Marshal.GetDelegateForFunctionPointer<GetBufferPointerFn>(Marshal.ReadIntPtr(vtbl, 3 * IntPtr.Size));
        var getSize = Marshal.GetDelegateForFunctionPointer<GetBufferSizeFn>(Marshal.ReadIntPtr(vtbl, 4 * IntPtr.Size));
        byte[] bytes = new byte[getSize(blob)];
        Marshal.Copy(getPtr(blob), bytes, 0, bytes.Length);
        return bytes;
    }

    private static string ReadComBlobString(IntPtr blob)
    {
        byte[] bytes = ReadComBlob(blob);
        return Encoding.UTF8.GetString(bytes).Trim('\0');
    }

    [UnmanagedFunctionPointer(CallingConvention.StdCall)]
    private delegate IntPtr GetBufferPointerFn(IntPtr self);

    [UnmanagedFunctionPointer(CallingConvention.StdCall)]
    private delegate nuint GetBufferSizeFn(IntPtr self);
}