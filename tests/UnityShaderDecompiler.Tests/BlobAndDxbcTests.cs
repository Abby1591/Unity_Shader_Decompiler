using System;
using System.IO;
using System.Linq;
using System.Text;
using Parser.DXBC;
using Parser.DXBC.Extraction;

namespace UnityShaderDecompiler.Tests;

/// <summary>
/// Offline coverage for the §14 blob classifier and §15 DXBC container
/// vectors. These are the ported equivalents of the original
/// <c>--run-spec-tests</c> checks, now reported as individual xUnit cases.
/// </summary>
public class BlobAndDxbcTests
{
    // ── §14 / §15.1-15.4 resource extents ─────────────────────────────

    [Fact]
    public void SparseConstantBuffer_ReportsExtentOnly()
    {
        var blob = UnityShaderBlob.Parse(
            SpecBlobs.NonComputeBlob(texExt: 0, cbExt: 4, sampExt: 0, uavExt: 0), "test");

        Assert.Equal(UnityShaderBlobKind.NonCompute, blob.Kind);
        Assert.True(blob.Header.HasValue);
        var h = blob.Header.Value;
        Assert.Equal(4, h.CbExtent);
        Assert.Equal(0, h.TextureExtent);
        Assert.Equal(0, h.SamplerExtent);
        Assert.Equal(0, h.UavExtent);
        Assert.Equal(0, h.Flag);
        Assert.Equal(SpecBlobs.MinimalDxbc().Length, blob.Dxbc.Length);
    }

    [Fact]
    public void SparseTexture_ReportsExtent()
    {
        var blob = UnityShaderBlob.Parse(
            SpecBlobs.NonComputeBlob(texExt: 8, cbExt: 0, sampExt: 0, uavExt: 0), "test");

        Assert.Equal(8, blob.Header!.Value.TextureExtent);
    }

    [Fact]
    public void SparseSampler_ReportsExtent()
    {
        var blob = UnityShaderBlob.Parse(
            SpecBlobs.NonComputeBlob(texExt: 0, cbExt: 0, sampExt: 6, uavExt: 0), "test");

        Assert.Equal(6, blob.Header!.Value.SamplerExtent);
    }

    [Fact]
    public void MultipleSparseResources_ReportExtentsWithoutFabricatingResources()
    {
        var blob = UnityShaderBlob.Parse(
            SpecBlobs.NonComputeBlob(texExt: 8, cbExt: 8, sampExt: 6, uavExt: 0), "test");

        var h = blob.Header!.Value;
        Assert.Equal(8, h.CbExtent);
        Assert.Equal(8, h.TextureExtent);
        Assert.Equal(6, h.SamplerExtent);
        Assert.Equal(0, h.UavExtent);
        Assert.Equal(SpecBlobs.MinimalDxbc().Length, blob.Dxbc.Length);
    }

    // ── §14.2 compute marker ───────────────────────────────────────────

    [Fact]
    public void ComputeSentinel_ParsesAsComputeKind()
    {
        using var ms = new MemoryStream();
        using var w = new BinaryWriter(ms);
        w.Write(ulong.MaxValue);
        w.Write(1ul);
        w.Write(0ul);
        w.Write(0ul);
        w.Write(0ul);
        w.Write(0ul);
        w.Write((byte)0);

        var blob = UnityShaderBlob.Parse(ms.ToArray(), "test");

        Assert.Equal(UnityShaderBlobKind.Compute, blob.Kind);
        Assert.NotNull(blob.ComputeMetadata);
    }

    [Fact]
    public void TruncatedComputeBlob_IsRejected()
    {
        var data = new byte[16];
        for (int i = 0; i < 8; i++) data[i] = 0xFF;
        data[8] = 1;

        Assert.Throws<InvalidDataException>(() => UnityShaderBlob.Parse(data, "test"));
    }

    // ── §14.1 wire-frame wrapping ──────────────────────────────────────

    [Fact]
    public void WireFrame_UnwrapsInnerBlob()
    {
        var inner = SpecBlobs.NonComputeBlob(texExt: 0, cbExt: 3, sampExt: 0, uavExt: 0);
        var wf = WrapWireFrame(inner);

        var blob = UnityShaderBlob.Parse(wf, "ipc-capture");

        Assert.Equal(UnityShaderBlobKind.NonCompute, blob.Kind);
        Assert.Equal(3, blob.Header!.Value.CbExtent);
        Assert.Equal(SpecBlobs.MinimalDxbc().Length, blob.Dxbc.Length);
    }

    [Fact]
    public void WireFrame_WithOversizedPayload_IsRejected()
    {
        var wf = new byte[16];
        wf[0] = 0xE4; wf[1] = 0xD1; wf[2] = 0x0B; wf[3] = 0x0C;
        Array.Copy(BitConverter.GetBytes(ulong.MaxValue), 0, wf, 4, 8);

        Assert.Throws<InvalidDataException>(() => UnityShaderBlob.Parse(wf, "test"));
    }

    [Fact]
    public void WireFrame_NestedTooDeep_IsRejected()
    {
        var inner = SpecBlobs.NonComputeBlob(texExt: 0, cbExt: 2, sampExt: 0, uavExt: 0);
        for (int i = 0; i < 10; i++)
            inner = WrapWireFrame(inner);

        Assert.Throws<InvalidDataException>(() => UnityShaderBlob.Parse(inner, "test"));
    }

    // ── §14.4 raw variant ─────────────────────────────────────────────

    [Fact]
    public void RawVariant_SlicesDxbcAtOffsetOne()
    {
        var dxbc = SpecBlobs.MinimalDxbc();
        var data = new byte[1 + dxbc.Length];
        data[0] = 0x00;
        Array.Copy(dxbc, 0, data, 1, dxbc.Length);

        var blob = UnityShaderBlob.Parse(data, "test");

        Assert.Equal(UnityShaderBlobKind.RawVariant, blob.Kind);
        Assert.Null(blob.Header);
        Assert.Equal(dxbc.Length, blob.Dxbc.Length);
    }

    [Fact]
    public void UnknownFormat_IsRejected()
    {
        Assert.Throws<InvalidDataException>(() =>
            UnityShaderBlob.Parse(Encoding.ASCII.GetBytes("GARBAGE"), "test"));
    }

    // ── §15.8/15.9 DXBC container validation ──────────────────────────

    [Fact]
    public void UnknownChunk_IsPreservedVerbatim()
    {
        var dxbc = SpecBlobs.DxbcWithChunk("JUNK", new byte[] { 0xDE, 0xAD, 0xBE, 0xEF });
        var file = new DxbcFile();
        file.Load(dxbc);

        Assert.Single(file.UnknownChunks);
        var junk = file.UnknownChunks[0];
        Assert.Equal("JUNK", junk.Name.ToString());
        Assert.Equal(new byte[] { 0xDE, 0xAD, 0xBE, 0xEF }, junk.Data);
        Assert.Single(file.Chunks);
    }

    [Fact]
    public void ChunkOffsetPastContainer_IsRejected()
    {
        var dxbc = SpecBlobs.DxbcWithChunk("JUNK", new byte[] { 1 }, offsetOverride: 0x1000);
        Assert.Throws<InvalidDataException>(() => new DxbcFile().Load(dxbc));

        var blobData = SpecBlobs.NonComputeBlob(0, 1, 0, 0, dxbc);
        Assert.Throws<InvalidDataException>(() => UnityShaderBlob.Parse(blobData, "test"));
    }

    [Fact]
    public void ChunkLengthPastContainer_IsRejected()
    {
        var dxbc = SpecBlobs.DxbcWithChunk("JUNK", new byte[] { 1 }, sizeOverride: 0xFFFFFFF0);
        Assert.Throws<InvalidDataException>(() => new DxbcFile().Load(dxbc));
    }

    [Fact]
    public void MisalignedChunkOffset_IsRejected()
    {
        var dxbc = SpecBlobs.DxbcWithChunk("JUNK", new byte[] { 1 }, offsetOverride: 37);
        Assert.Throws<InvalidDataException>(() => new DxbcFile().Load(dxbc));

        var blobData = SpecBlobs.NonComputeBlob(0, 1, 0, 0, dxbc);
        Assert.Throws<InvalidDataException>(() => UnityShaderBlob.Parse(blobData, "test"));
    }

    [Fact]
    public void TotalLengthShorterThanChunks_IsRejected()
    {
        var dxbc = SpecBlobs.DxbcWithChunk("JUNK", new byte[] { 1, 2, 3, 4 });
        var lying = (byte[])dxbc.Clone();
        Array.Copy(BitConverter.GetBytes(40u), 0, lying, 24, 4); // TotalLength at +24

        Assert.Throws<InvalidDataException>(() => new DxbcFile().Load(lying));
    }

    // ── SFI0 / PCON / compute blob ────────────────────────────────────

    [Fact]
    public void Sfi0Chunk_ExposesFeatureFlags()
    {
        var dxbc = SpecBlobs.DxbcWithChunk(
            "SFI0", SpecBlobs.Sfi0ChunkBytes(2UL));
        var file = new DxbcFile();
        file.Load(dxbc);

        Assert.NotNull(file.ShaderInfo);
        var s = file.ShaderInfo!;
        Assert.Equal(2UL, s.FeatureFlags);
        Assert.Empty(file.UnknownChunks);
    }

    [Fact]
    public void Sfi0Chunk_RejectsInvalidLength()
    {
        byte[] dxbc = SpecBlobs.DxbcWithChunk("SFI0", new byte[4]);
        Assert.Throws<InvalidDataException>(() => new DxbcFile().Load(dxbc));
    }

    [Fact]
    public void PconChunk_ExposesPatchConstantSignature()
    {
        var dxbc = SpecBlobs.DxbcWithChunk("PCON", SpecBlobs.PconChunkBytes());
        var file = new DxbcFile();
        file.Load(dxbc);

        Assert.NotNull(file.PatchConstantSignature);
        Assert.Single(file.PatchConstantSignature!.Elements);
        Assert.Equal("SV_TessFactor", file.PatchConstantSignature.Elements[0].SemanticName);
    }

    [Fact]
    public void ComputeBlob_RoundTripsKernelMetadata()
    {
        var blob = UnityShaderBlob.Parse(SpecBlobs.ComputeBlob(), "test");

        Assert.Equal(UnityShaderBlobKind.Compute, blob.Kind);
        var cm = Assert.IsType<UnityComputeMetadata>(blob.ComputeMetadata);
        Assert.Equal(1ul, cm.Version);
        Assert.Equal(0ul, cm.CbData.Count);
        Assert.Equal(1ul, cm.ParamData.OuterCount);

        var cb = cm.ParamData.Entries[0].Cbs[0];
        Assert.Equal("KernelCB", cb.Name);
        Assert.Equal(64u, cb.CbSize);
        Assert.Equal(2, cb.Variables.Count);
        Assert.Equal("g_color", cb.Variables[0].Name);
        Assert.Equal(0u, cb.Variables[0].UnityType);
        Assert.Equal(1u, cb.Variables[1].UnityType);
        Assert.Equal(16u, cb.Variables[1].StartOffset);

        var e = cm.ShaderEntries[0];
        Assert.Equal("KernelMain", e.Name);
        Assert.Single(e.ListB);
        Assert.Equal("_MainTex", e.ListB[0].Name);
        Assert.Equal(2u, e.ListB[0].V1);
        Assert.Single(e.ListD);
        Assert.Equal(3u, e.ListD[0].V0);
        Assert.Equal(0xFFFFFFFFu, e.ListD[0].V1);
        Assert.Equal(2u, e.ListD[0].V2);
        Assert.Single(e.UintPairs);
        Assert.Equal(0x1234u, e.UintPairs[0].Lo);
        Assert.Equal(7u, e.UintPairs[0].Hi);
        Assert.Equal(8u, e.ThreadGroupX);
        Assert.Equal(4u, e.ThreadGroupY);
        Assert.Equal(1u, e.ThreadGroupZ);
        Assert.Equal(SpecBlobs.MinimalDxbc().Length, e.Dxbc.Length);

        // The embedded DXBC must itself be a valid container.
        var kernel = new DxbcFile();
        kernel.Load(e.Dxbc);
        Assert.Empty(kernel.Chunks);
    }

    private static byte[] WrapWireFrame(byte[] inner)
    {
        var wf = new byte[12 + inner.Length];
        wf[0] = 0xE4; wf[1] = 0xD1; wf[2] = 0x0B; wf[3] = 0x0C; // 0x0C0BD1E4
        Array.Copy(BitConverter.GetBytes((ulong)inner.Length), 0, wf, 4, 8);
        Array.Copy(inner, 0, wf, 12, inner.Length);
        return wf;
    }
}
