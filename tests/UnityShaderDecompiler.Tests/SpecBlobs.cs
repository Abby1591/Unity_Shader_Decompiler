using System;
using System.IO;
using System.Text;

namespace UnityShaderDecompiler.Tests;

/// <summary>
/// Synthesized Unity shader blobs and DXBC containers used by the offline
/// parser spec tests. Ported from the original <c>SpecTestVectors</c> helpers
/// so the xUnit suite does not need any on-disk fixtures.
/// </summary>
internal static class SpecBlobs
{
    /// <summary>Valid DXBC container with zero chunks.</summary>
    public static byte[] MinimalDxbc()
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

    /// <summary>
    /// DXBC container with one chunk. The payload is padded to 4-byte
    /// alignment; the chunk record itself is 8 bytes + payload.
    /// </summary>
    public static byte[] DxbcWithChunk(
        string name,
        byte[] payload,
        uint? offsetOverride = null,
        uint? sizeOverride = null)
    {
        uint chunkSize = (uint)payload.Length;
        uint aligned = (chunkSize + 3u) & ~3u;
        uint headerLen = 32u;
        uint chunkOffset = headerLen + 4u;
        uint total = chunkOffset + 8u + aligned;

        using var ms = new MemoryStream();
        using var w = new BinaryWriter(ms);
        w.Write("DXBC"u8);
        w.Write(new byte[16]);
        w.Write(1u);
        w.Write(total);
        w.Write(1u);
        w.Write(offsetOverride ?? chunkOffset);
        w.Write(Encoding.ASCII.GetBytes(name));
        w.Write(sizeOverride ?? chunkSize);
        w.Write(payload);
        w.Write(new byte[aligned - chunkSize]);
        return ms.ToArray();
    }

    /// <summary>0x26-byte non-compute header wrapping the given DXBC.</summary>
    public static byte[] NonComputeBlob(byte texExt, byte cbExt, byte sampExt, byte uavExt, byte[]? dxbc = null)
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

    /// <summary>SFI0 chunk payload: one 64-bit shader feature flag mask.</summary>
    public static byte[] Sfi0ChunkBytes(ulong featureFlags) => BitConverter.GetBytes(featureFlags);

    /// <summary>PCON patch-constant signature payload (OSGN element layout).</summary>
    public static byte[] PconChunkBytes()
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

    /// <summary>
    /// §6.1 top-level compute blob. CB block empty (kernel path), one kernel
    /// in the param block, one shader entry with texture/UAV/sampler-pair/threads.
    /// </summary>
    public static byte[] ComputeBlob()
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

    private static void WriteList64(
        BinaryWriter w,
        params (string Name, string Type, uint V0, uint V1, uint V2)[] entries)
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
