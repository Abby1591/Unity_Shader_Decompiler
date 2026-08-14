using System;
using System.IO;
using System.Linq;
using System.Text;
using Parser.DXBC;

namespace Parser;

// Automated rendering of spec §15 test vectors (shader_parser_spec.md) and
// the §14 classifier branches. Fully offline: every payload is synthesized.
// Run with `Parser.dll --run-spec-tests`.
public static class SpecTestVectors
{
    private static int s_failures;

    public static void Run()
    {
        Console.WriteLine("Spec test vectors (§14 classifier + §15)");
        Console.WriteLine("----------------------------------------");

        // ---- §15.1/15.10  Sparse CB (b3 only): cbExt=4, NO fabricated b0..b3.
        BlobCase(
            texExt: 0, cbExt: 4, sampExt: 0, uavExt: 0,
            asserts: blob =>
            {
                Check(blob.Kind == UnityShaderBlobKind.NonCompute, "sparse b3 → NonCompute");
                Check(blob.Header.Value.CbExtent == 4, "sparse b3 → cbExtent=4");
                Check(blob.Header.Value.TextureExtent == 0, "sparse b3 → texExtent=0");
                Check(blob.Header.Value.SamplerExtent == 0, "sparse b3 → sampExtent=0");
                Check(blob.Header.Value.UavExtent == 0, "sparse b3 → uavExtent=0");
                Check(blob.Header.Value.Flag == 0, "sparse b3 → flag=0");
                Check(blob.Dxbc.Length == MinimalDxbc().Length, "sparse b3 → DXBC sliced at 0x26");
            });

        // ---- §15.2  Sparse texture (t7 only): texExt=8.
        BlobCase(8, 0, 0, 0, b =>
            Check(b.Header.Value.TextureExtent == 8, "sparse t7 → texExtent=8"));

        // ---- §15.3  Sparse sampler (s5 only): sampExt=6.
        BlobCase(0, 0, 6, 0, b =>
            Check(b.Header.Value.SamplerExtent == 6, "sparse s5 → sampExtent=6"));

        // ---- §15.4  Multiple sparse (b3,b7,t2,t7,s5): cbExt=8, texExt=8,
        //      sampExt=6, uavExt=0. Parser reports ONLY extents.
        BlobCase(8, 8, 6, 0, b =>
        {
            Check(b.Header.Value.CbExtent == 8 && b.Header.Value.TextureExtent == 8
                && b.Header.Value.SamplerExtent == 6 && b.Header.Value.UavExtent == 0,
                "multiple sparse → cbExt=8 texExt=8 sampExt=6 uavExt=0");
            Check(b.Dxbc.Length == MinimalDxbc().Length,
                "multiple sparse → no resources fabricated (DXBC length untouched)");
        });

        // ---- §14.2  Compute marker: u64 sentinel + version 1.
        Case("compute marker", () =>
        {
            using var ms = new MemoryStream();
            using var w = new BinaryWriter(ms);
            w.Write(ulong.MaxValue);   // sentinel
            w.Write(1ul);              // version
            w.Write(0ul);              // CB block count (empty)
            w.Write(0ul);              // CB block trailing qword
            w.Write(0ul);              // param block count (empty)
            w.Write(0ul);              // shader array count (empty)
            w.Write((byte)0);          // trailing flag
            var blob = UnityShaderBlob.Parse(ms.ToArray(), "test");
            Check(blob.Kind == UnityShaderBlobKind.Compute, "compute sentinel → Compute kind");
            Check(blob.ComputeMetadata is not null, "minimal compute blob parses fully");
        });

        // ---- §14.2 error: truncated compute blob rejected (no partial commit).
        Case("compute truncated", () =>
        {
            var data = new byte[16];
            for (int i = 0; i < 8; i++) data[i] = 0xFF;
            data[8] = 1;
            Throws(() => UnityShaderBlob.Parse(data, "test"), "truncated compute blob rejected");
        });

        // ---- §14.1  Wire frame wrapping a non-compute blob.
        Case("wire frame", () =>
        {
            var inner = NonComputeBlob(0, 3, 0, 0);
            var wf = new byte[12 + inner.Length];
            wf[0] = 0xE4; wf[1] = 0xD1; wf[2] = 0x0B; wf[3] = 0x0C; // 0x0C0BD1E4
            byte[] size = BitConverter.GetBytes((ulong)inner.Length);
            Array.Copy(size, 0, wf, 4, 8);
            Array.Copy(inner, 0, wf, 12, inner.Length);

            var blob = UnityShaderBlob.Parse(wf, "ipc-capture");
            Check(blob.Kind == UnityShaderBlobKind.NonCompute, "wire frame unwraps to inner blob kind");
            Check(blob.Header.Value.CbExtent == 3, "wire frame → inner cbExtent preserved");
            Check(blob.Dxbc.Length == MinimalDxbc().Length, "wire frame → DXBC from inner payload");
        });

        // ---- §14.1 error: wire frame size extends past end of buffer.
        Case("wire frame oversized", () =>
        {
            var wf = new byte[16];
            wf[0] = 0xE4; wf[1] = 0xD1; wf[2] = 0x0B; wf[3] = 0x0C;
            byte[] size = BitConverter.GetBytes(ulong.MaxValue);
            Array.Copy(size, 0, wf, 4, 8);
            Throws(() => UnityShaderBlob.Parse(wf, "test"), "wire frame oversized payload rejected");
        });

        // ---- §14.1 error: wire frame nesting too deep.
        Case("wire frame depth", () =>
        {
            var inner = NonComputeBlob(0, 2, 0, 0);
            for (int i = 0; i < 10; i++)
            {
                var wf = new byte[12 + inner.Length];
                wf[0] = 0xE4; wf[1] = 0xD1; wf[2] = 0x0B; wf[3] = 0x0C;
                Array.Copy(BitConverter.GetBytes((ulong)inner.Length), 0, wf, 4, 8);
                Array.Copy(inner, 0, wf, 12, inner.Length);
                inner = wf;
            }
            Throws(() => UnityShaderBlob.Parse(inner, "test"), "excessive wire frame nesting rejected");
        });

        // ---- §14.4  Raw variant: byte0==0x00, DXBC at +1.
        Case("raw variant", () =>
        {
            var dxbc = MinimalDxbc();
            var data = new byte[1 + dxbc.Length];
            data[0] = 0x00;
            Array.Copy(dxbc, 0, data, 1, dxbc.Length);

            var blob = UnityShaderBlob.Parse(data, "test");
            Check(blob.Kind == UnityShaderBlobKind.RawVariant, "raw variant → RawVariant kind");
            Check(blob.Header is null, "raw variant → no non-compute header");
            Check(blob.Dxbc.Length == dxbc.Length, "raw variant → DXBC sliced at +1");
        });

        // ---- §14.5  Unknown format rejected.
        Case("unknown format", () =>
            Throws(() => UnityShaderBlob.Parse(Encoding.ASCII.GetBytes("GARBAGE"), "test"),
                "garbage bytes rejected"));

        // ---- §15.8  Unknown DXBC chunk preserved verbatim.
        Case("unknown DXBC chunk", () =>
        {
            var dxbc = DxbcWithChunk("JUNK", new byte[] { 0xDE, 0xAD, 0xBE, 0xEF });
            var file = new DxbcFile();
            file.Load(dxbc);

            Check(file.UnknownChunks.Count == 1, "unknown chunk tracked");
            var junk = file.UnknownChunks[0];
            Check(junk.Name.ToString() == "JUNK", "unknown chunk name preserved");
            Check(junk.Data.SequenceEqual(new byte[] { 0xDE, 0xAD, 0xBE, 0xEF }),
                "unknown chunk payload preserved verbatim");
            Check(file.Chunks.Count == 1, "chunk still present in Chunks");
        });

        // ---- §15.9  Malformed chunk offset rejected (no partial commit).
        Case("malformed chunk offset", () =>
        {
            var dxbc = DxbcWithChunk("JUNK", new byte[] { 1 }, offsetOverride: 0x1000);
            Throws(() => new DxbcFile().Load(dxbc), "chunk offset past container rejected");

            var blobData = NonComputeBlob(0, 1, 0, 0, dxbc);
            Throws(() => UnityShaderBlob.Parse(blobData, "test"), "blob wrapping malformed DXBC rejected");
        });

        // ---- §15.9  Malformed chunk length rejected.
        Case("malformed chunk length", () =>
        {
            var dxbc = DxbcWithChunk("JUNK", new byte[] { 1 }, sizeOverride: 0xFFFFFFF0);
            Throws(() => new DxbcFile().Load(dxbc), "chunk extending past container rejected");
        });

        // ---- §15.9  Truncated container (TotalLength lies) rejected.
        Case("truncated container", () =>
        {
            var dxbc = DxbcWithChunk("JUNK", new byte[] { 1, 2, 3, 4 });
            var lying = new byte[dxbc.Length];
            Array.Copy(dxbc, lying, dxbc.Length);
            uint small = 40u; // chunk (offset 36, size 4) extends past this
            byte[] tl = BitConverter.GetBytes(small);
            Array.Copy(tl, 0, lying, 24, 4); // TotalLength at +24
            Throws(() => new DxbcFile().Load(lying), "lying TotalLength rejected");
        });

        // ---- SFI0 (shader info; cTemps + cNumThreads carriers, spec §8) ----
        Case("SFI0 chunk", TestSfi0);

        // ---- PCON (patch-constant signature) ----
        Case("PCON chunk", TestPcon);

        // ---- §6 compute serialized blob ----
        Case("compute blob §6", TestComputeBlob);

        Console.WriteLine();
        Console.WriteLine(s_failures == 0
            ? "All spec vectors PASS."
            : $"{s_failures} spec vector(s) FAILED.");
    }

    // ---- SFI0 (spec §8 carrier for cTemps / cNumThreads) ----
    private static void TestSfi0()
    {
        var dxbc = DxbcWithChunk("SFI0", Sfi0ChunkBytes(cTemps: 12, tgx: 8, tgy: 4, tgz: 1));
        var file = new DxbcFile();
        file.Load(dxbc);

        Check(file.ShaderInfo is not null, "SFI0 parsed");
        if (file.ShaderInfo is { } s)
        {
            Check(s.CTemps == 12, "SFI0 cTemps=12");
            Check(s.CNumThreadsX == 8 && s.CNumThreadsY == 4 && s.CNumThreadsZ == 1,
                "SFI0 cNumThreads=(8,4,1)");
            Check(file.UnknownChunks.Count == 0, "SFI0 not treated as unknown");
        }
    }

    // ---- PCON (patch-constant signature, same element layout as OSGN) ----
    private static void TestPcon()
    {
        var dxbc = DxbcWithChunk("PCON", PconChunkBytes());
        var file = new DxbcFile();
        file.Load(dxbc);

        Check(file.PatchConstantSignature is not null, "PCON parsed into PatchConstantSignature");
        Check(file.PatchConstantSignature!.Elements.Count == 1, "PCON has 1 element");
        Check(file.PatchConstantSignature.Elements[0].SemanticName == "SV_TessFactor",
            "PCON semantic name preserved");
    }

    // ---- §6 compute serialized blob (PROVEN layout) ----
    private static void TestComputeBlob()
    {
        byte[] data = ComputeBlob();
        var blob = UnityShaderBlob.Parse(data, "test");

        Check(blob.Kind == UnityShaderBlobKind.Compute, "compute blob → Compute kind");
        var cm = blob.ComputeMetadata!;
        Check(cm.Version == 1, "compute version = 1");
        Check(cm.CbData.Count == 0, "compute CB block empty (kernel path)");

        Check(cm.ParamData.OuterCount == 1, "param block 1 kernel");
        var cb = cm.ParamData.Entries[0].Cbs[0];
        Check(cb.Name == "KernelCB", "kernel CB name");
        Check(cb.CbSize == 64, "kernel CB size = 64");
        Check(cb.Variables.Count == 2, "kernel CB 2 variables");

        var v0 = cb.Variables[0];
        Check(v0.Name == "g_color", "var name g_color");
        Check(v0.UnityType == 0 && v0.Rows == 1 && v0.Columns == 4 && v0.Elements == 1,
            "float4 → a1=0 rows=1 cols=4");
        var v1 = cb.Variables[1];
        Check(v1.UnityType == 1 && v1.StartOffset == 16, "int → a1=1, StartOffset=16");

        var e = cm.ShaderEntries[0];
        Check(e.Name == "KernelMain", "kernel entry name");
        Check(e.ListB.Count == 1 && e.ListB[0].Name == "_MainTex" && e.ListB[0].V1 == 2,
            "listB texture + sampler bindpoint patch v1=2");
        Check(e.ListD.Count == 1
            && e.ListD[0].V0 == 3 && e.ListD[0].V1 == 0xFFFFFFFFu && e.ListD[0].V2 == 2,
            "listD UAV {bindpoint=3, 0xffffffff, dimMap=2}");
        Check(e.UintPairs.Count == 1 && e.UintPairs[0].Lo == 0x1234 && e.UintPairs[0].Hi == 7,
            "sampler uint-pair (state, bindpoint)");
        Check(e.ThreadGroupX == 8 && e.ThreadGroupY == 4 && e.ThreadGroupZ == 1,
            "thread group = (8,4,1)");
        Check(e.Dxbc.Length == MinimalDxbc().Length, "kernel DXBC sliced");

        // The embedded DXBC must itself be a valid container.
        try
        {
            new DxbcFile().Load(e.Dxbc);
            Check(true, "kernel DXBC is a valid container");
        }
        catch (Exception ex)
        {
            Check(false, $"kernel DXBC is a valid container (threw {ex.Message})");
        }
    }

    // ---- helpers ----

    private static void BlobCase(byte texExt, byte cbExt, byte sampExt, byte uavExt, Action<UnityShaderBlob> asserts)
    {
        try
        {
            var blob = UnityShaderBlob.Parse(NonComputeBlob(texExt, cbExt, sampExt, uavExt), "test");
            asserts(blob);
        }
        catch (Exception e)
        {
            Console.WriteLine($"  FAIL  unexpected exception: {e.Message}");
            s_failures++;
        }
    }

    private static void Case(string name, Action action)
    {
        Console.WriteLine($"- {name}");
        try { action(); }
        catch (Exception e)
        {
            Console.WriteLine($"  FAIL  unexpected exception: {e.Message}");
            s_failures++;
        }
    }

    private static void Check(bool cond, string name)
    {
        Console.WriteLine($"  {(cond ? "PASS" : "FAIL")}  {name}");
        if (!cond) s_failures++;
    }

    private static void Throws(Action action, string name)
    {
        try { action(); Check(false, name); }
        catch (InvalidDataException) { Check(true, name); }
        catch (Exception e) { Check(false, $"{name} (wrong exception: {e.GetType().Name})"); }
    }

    // Valid DXBC container, 0 chunks.
    private static byte[] MinimalDxbc()
    {
        using var ms = new MemoryStream();
        using var w = new BinaryWriter(ms);
        w.Write("DXBC"u8);
        w.Write(new byte[16]);
        w.Write(1u);
        w.Write(32u);
        w.Write(0u);
        return ms.ToArray();
    }

    // DXBC container with one chunk (payload padded to 4-byte alignment; the
    // chunk record itself is 8 bytes + payload).
    private static byte[] DxbcWithChunk(string name, byte[] payload, uint? offsetOverride = null, uint? sizeOverride = null)
    {
        uint chunkSize = (uint)payload.Length;
        uint aligned = (chunkSize + 3u) & ~3u;
        uint headerLen = 32u;                       // magic+checksum+version+totalLength+chunkCount
        uint chunkOffset = headerLen + 4u;          // + offset-table entry; first chunk after it
        uint total = chunkOffset + 8u + aligned;

        using var ms = new MemoryStream();
        using var w = new BinaryWriter(ms);
        w.Write("DXBC"u8);
        w.Write(new byte[16]);
        w.Write(1u);
        w.Write(total);
        w.Write(1u);                                 // chunkCount
        w.Write(offsetOverride ?? chunkOffset);
        w.Write(Encoding.ASCII.GetBytes(name));
        w.Write(sizeOverride ?? chunkSize);
        w.Write(payload);
        w.Write(new byte[aligned - chunkSize]);       // pad
        return ms.ToArray();
    }

    // 0x26-byte non-compute header wrapping the (default: minimal) DXBC.
    private static byte[] NonComputeBlob(byte texExt, byte cbExt, byte sampExt, byte uavExt, byte[]? dxbc = null)
    {
        var body = dxbc ?? MinimalDxbc();
        var blob = new byte[0x26 + body.Length];
        blob[0] = 0x02;
        blob[1] = texExt;
        blob[2] = cbExt;
        blob[3] = sampExt;
        blob[4] = uavExt;
        Array.Copy(body, 0, blob, 0x26, body.Length);
        return blob;
    }

    // SFI0 chunk payload: 35 u32 fields. CTemps at index 7, cNumThreads X/Y/Z
    // at indices 17/18/19.
    private static byte[] Sfi0ChunkBytes(uint cTemps, uint tgx, uint tgy, uint tgz)
    {
        var buf = new byte[35 * 4];
        void Set(int idx, uint v) => Array.Copy(BitConverter.GetBytes(v), 0, buf, idx * 4, 4);
        Set(7, cTemps);
        Set(17, tgx);
        Set(18, tgy);
        Set(19, tgz);
        return buf;
    }

    // PCON patch-constant signature payload (OSGN element layout).
    private static byte[] PconChunkBytes()
    {
        using var ms = new MemoryStream();
        using var w = new BinaryWriter(ms);
        w.Write(1u);            // elementCount
        w.Write(0u);            // unknown
        w.Write(32u);           // nameOffset (start + 8 + 24 = 32)
        w.Write(0u);            // semanticIndex
        w.Write(0u);            // systemValue
        w.Write(0u);            // componentType
        w.Write(0u);            // register
        w.Write((byte)0xFF);    // mask
        w.Write((byte)0xFF);    // rwMask
        w.Write((ushort)0);     // reserved
        w.Write(Encoding.ASCII.GetBytes("SV_TessFactor"));
        w.Write((byte)0);       // null terminator
        return ms.ToArray();
    }

    // §6.1 top-level compute blob. CB block empty (kernel path), one kernel in
    // the param block, one shader entry with texture/UAV/sampler-pair/threads.
    private static byte[] ComputeBlob()
    {
        using var ms = new MemoryStream();
        using var w = new BinaryWriter(ms);

        w.Write(ulong.MaxValue);        // sentinel
        w.Write(1ul);                   // version

        // §6.2 CB block (empty on the kernel path).
        w.Write(0ul);                   // cbCount
        w.Write(0ul);                   // trailing qword

        // §6.3 Param block: 1 outer, 1 CB, 2 variables.
        w.Write(1ul);                   // paramCount
        w.Write(1ul);                   // outer cbCount
        WriteString(w, "KernelCB");
        w.Write(64u);                   // cbSize
        w.Write(2ul);                   // varCount
        WriteString(w, "g_color");
        w.Write(0u); w.Write(0u); w.Write(1u); w.Write(1u); w.Write(4u); // float4 → a1=0
        WriteString(w, "g_count");
        w.Write(1u); w.Write(16u); w.Write(1u); w.Write(1u); w.Write(1u); // int → a1=1, offset 16

        // §6.4 Shader array: 1 entry.
        w.Write(1ul);                   // shaderCount
        WriteString(w, "KernelMain");
        WriteList64(w);                                  // listA (CB names) — empty
        WriteList64(w, ("_MainTex", "", 0u, 2u, 0u));    // listB texture + sampler patch v1=2
        WriteList64(w);                                  // listC — empty
        WriteList64(w, ("u_out", "", 3u, 0xFFFFFFFFu, 2u)); // listD UAV {bp, 0xffffffff, dimMap}
        w.Write(1ul);                   // uintPairCount
        w.Write(0x1234u); w.Write(7u);  // (packed sampler state, sampler bindpoint)
        byte[] dxbc = MinimalDxbc();
        w.Write((ulong)dxbc.Length);
        w.Write(dxbc);
        w.Write(8u); w.Write(4u); w.Write(1u);  // thread group X/Y/Z

        w.Write((byte)0);               // §6.1 trailing flag byte
        return ms.ToArray();
    }

    private static void WriteString(BinaryWriter w, string s)
    {
        byte[] bytes = Encoding.UTF8.GetBytes(s);
        w.Write(bytes.Length);
        w.Write(bytes);
    }

    private static void WriteList64(BinaryWriter w, params (string Name, string Type, uint V0, uint V1, uint V2)[] entries)
    {
        w.Write((ulong)entries.Length);
        foreach (var e in entries)
        {
            WriteString(w, e.Name);
            WriteString(w, e.Type);
            w.Write(e.V0);
            w.Write(e.V1);
            w.Write(e.V2);
        }
    }
}
