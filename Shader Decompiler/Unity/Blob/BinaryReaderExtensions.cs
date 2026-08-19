using System.Collections.Generic;
using System.IO;
using System.Text;

namespace AssetStudio;

// BinaryReader helpers for Unity's serialized binary formats (shader blobs
// and ShaderProgram entries). Unity packs strings as [int32 byte count][raw
// bytes], 4-byte aligned, and length-prefixes byte arrays the same way.
public static class BinaryReaderExtensions
{
    // Aligns the stream position up to the next 4-byte boundary, matching
    // Unity's 4-byte alignment of every serialized block.
    public static void AlignStream(this BinaryReader reader)
    {
        reader.BaseStream.Position = (reader.BaseStream.Position + 3) & ~3L;
    }

    // [int32 length][length raw bytes], UTF-8, 4-byte aligned. A zero or
    // negative length yields the empty string; a length that overruns the
    // buffer is rejected instead of throwing mid-read.
    public static string ReadAlignedString(this BinaryReader reader)
    {
        int length = reader.ReadInt32();
        if (length <= 0 || length > reader.BaseStream.Length - reader.BaseStream.Position)
            return "";
        var bytes = reader.ReadBytes(length);
        reader.AlignStream();
        return Encoding.UTF8.GetString(bytes);
    }

    // [int32 length][length raw bytes] (no alignment). Negative length
    // yields an empty array.
    public static byte[] ReadUInt8Array(this BinaryReader reader)
    {
        int length = reader.ReadInt32();
        return length <= 0 ? System.Array.Empty<byte>() : reader.ReadBytes(length);
    }

    // NUL-terminated byte string (no length prefix, no alignment) — used by
    // Metal subprogram headers.
    public static string ReadStringToNull(this BinaryReader reader)
    {
        var bytes = new List<byte>();
        byte b;
        while (reader.BaseStream.Position < reader.BaseStream.Length && (b = reader.ReadByte()) != 0)
            bytes.Add(b);
        return Encoding.UTF8.GetString(bytes.ToArray());
    }
}