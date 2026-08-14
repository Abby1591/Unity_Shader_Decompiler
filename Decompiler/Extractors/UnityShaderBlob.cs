using System;
using System.IO;
using Parser.DXBC;

namespace Parser;

// §13 Final parser data model (shader_parser_spec.md). Optional fields are
// nullable and never fabricated. A single magic value is never enough — each
// branch of the classifier re-validates the DXBC header + chunk table before
// committing.
public enum UnityShaderBlobKind
{
    NonCompute,
    Compute,
    RawVariant,
    WireFrame,
}

public sealed class UnityShaderBlob
{
    public UnityShaderBlobKind Kind { get; private set; }
    public string Source { get; private set; } = "unknown";
    public UnityNonComputeHeader? Header { get; private set; }
    public UnityComputeMetadata? ComputeMetadata { get; private set; }
    public byte[] Dxbc { get; private set; } = Array.Empty<byte>();
    public byte[] RawBytes { get; private set; } = Array.Empty<byte>();

    // §14 Classifier decision tree, in spec order. Depth-capped for wire frames.
    public static UnityShaderBlob Parse(byte[] data, string source = "unknown")
        => ParseRecursive(data, source, depth: 0);

    private static UnityShaderBlob ParseRecursive(byte[] data, string source, int depth)
    {
        var blob = new UnityShaderBlob
        {
            RawBytes = data,
            Source = source,
        };

        // 1. Wire frame: first u32 == 0x0C0BD1E4 → u64 size at +4, payload =
        //    the next `size` bytes, recurse on the payload.
        if (data.Length >= 12 && BitConverter.ToUInt32(data, 0) == 0x0C0BD1E4)
        {
            ulong size = BitConverter.ToUInt64(data, 4);
            if (size > (ulong)(data.Length - 12))
                throw new InvalidDataException("Wire frame payload extends past end of buffer.");
            if (depth >= 8)
                throw new InvalidDataException("Wire frame nesting exceeds depth limit of 8.");

            blob.Kind = UnityShaderBlobKind.WireFrame;

            var payload = new byte[size];
            Buffer.BlockCopy(data, 12, payload, 0, payload.Length);
            return ParseRecursive(payload, source, depth + 1);
        }

        // 2. Compute: first u64 == 0xffffffffffffffff AND second u64 == 1.
        if (data.Length >= 16
            && BitConverter.ToUInt64(data, 0) == ulong.MaxValue
            && BitConverter.ToUInt64(data, 8) == 1)
        {
            blob.Kind = UnityShaderBlobKind.Compute;
            blob.ComputeMetadata = UnityComputeMetadata.Parse(data);
            return blob;
        }

        // 3. Non-compute: byte0 == 0x02 AND "DXBC" at [0x26,0x2a).
        if (DxbcExtractor.TryParseHeader(data) is { } h)
        {
            blob.Kind = UnityShaderBlobKind.NonCompute;
            blob.Header = h;
            blob.Dxbc = Slice(data, h.DxbcOffset);
            ValidateDxbc(blob.Dxbc);
            return blob;
        }

        // 4. Raw/non-D3D11 variant: byte0 == 0x00 AND "DXBC" at [0x01,0x05).
        if (data.Length >= 5
            && data[0] == 0x00
            && data[1] == 'D' && data[2] == 'X' && data[3] == 'B' && data[4] == 'C')
        {
            blob.Kind = UnityShaderBlobKind.RawVariant;
            blob.Dxbc = Slice(data, 1);
            ValidateDxbc(blob.Dxbc);
            return blob;
        }

        // 5. Otherwise: unknown format.
        throw new InvalidDataException("Unknown shader blob format.");
    }

    private static byte[] Slice(byte[] data, int offset)
    {
        var result = new byte[data.Length - offset];
        Buffer.BlockCopy(data, offset, result, 0, result.Length);
        return result;
    }

    // Re-validates the DXBC header, version, and chunk table (throws
    // InvalidDataException on any malformed length/offset — no partial commit).
    private static void ValidateDxbc(byte[] dxbc)
    {
        new DxbcFile().Load(dxbc);
    }
}
