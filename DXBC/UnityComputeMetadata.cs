using System;
using System.IO;
using System.Text;

namespace Parser.DXBC;

// §6 compute serialized format (shader_parser_spec.md), PROVEN layouts:
//
//     u64 sentinel = 0xffffffffffffffff
//     u64 version  = 1
//     CB block        (§6.2)
//     Param block     (§6.3)
//     Shader array    (§6.4)
//     u8 trailingFlags
//
// Strings are [i32 LE len][len raw bytes] (§6.6). Every read is bounds-checked
// against the remaining buffer — on any length overflow the parse throws
// InvalidDataException with no partial commit (§15.9).
public sealed class UnityComputeMetadata
{
    public ulong Sentinel { get; private set; }
    public ulong Version { get; private set; }
    public CbBlock CbData { get; private set; } = new();
    public ParamBlock ParamData { get; private set; } = new();
    public List<ShaderEntry> ShaderEntries { get; } = new();
    public byte TrailingFlags { get; private set; }

    public sealed class CbBlock
    {
        public ulong Count { get; set; }
        public List<CbEntry> Entries { get; } = new();
        public ulong Trailing { get; set; }
    }

    public sealed class CbEntry
    {
        public string? Name { get; set; }
        public ulong VarCount { get; set; }
        public List<VarPair> Vars { get; } = new();
    }

    public sealed class VarPair
    {
        public string? Name { get; set; }
        public string? Type { get; set; }
    }

    public sealed class ParamBlock
    {
        public ulong OuterCount { get; set; }
        public List<ParamOuter> Entries { get; } = new();
    }

    public sealed class ParamOuter
    {
        public ulong CbCount { get; set; }
        public List<CbRecord> Cbs { get; } = new();
    }

    public sealed class CbRecord
    {
        public string? Name { get; set; }
        public uint CbSize { get; set; }
        public ulong VarCount { get; set; }
        public List<Variable> Variables { get; } = new();
    }

    public sealed class Variable
    {
        public string? Name { get; set; }
        public uint UnityType { get; set; }   // a1 (§7.1 mapping)
        public uint StartOffset { get; set; } // a2
        public uint Elements { get; set; }    // a3
        public uint Rows { get; set; }        // a4
        public uint Columns { get; set; }     // a5
    }

    public sealed class ShaderEntry
    {
        public string? Name { get; set; }
        public List<List64Entry> ListA { get; } = new(); // CB names
        public List<List64Entry> ListB { get; } = new(); // textures (+0x54 sampler patch)
        public List<List64Entry> ListC { get; } = new(); // buffers/structured
        public List<List64Entry> ListD { get; } = new(); // UAVs {bindpoint, 0xffffffff, dimMap}
        public List<(uint Lo, uint Hi)> UintPairs { get; } = new(); // unmatched samplers
        public byte[] Dxbc { get; set; } = Array.Empty<byte>();
        public uint ThreadGroupX { get; set; }
        public uint ThreadGroupY { get; set; }
        public uint ThreadGroupZ { get; set; }
    }

    public sealed class List64Entry
    {
        public string? Name { get; set; }
        public string? Type { get; set; }
        public uint V0 { get; set; }
        public uint V1 { get; set; }
        public uint V2 { get; set; }
    }

    public static UnityComputeMetadata Parse(byte[] data)
    {
        try
        {
            return ParseInner(data);
        }
        catch (EndOfStreamException e)
        {
            // Truncated input is a malformed-length case (§15.9): reject with a
            // uniform exception type, never partial data.
            throw new InvalidDataException("Compute blob: truncated (unexpected end of stream).", e);
        }
    }

    private static UnityComputeMetadata ParseInner(byte[] data)
    {
        using var ms = new MemoryStream(data, writable: false);
        using var reader = new BinaryReader(ms);
        var meta = new UnityComputeMetadata();

        meta.Sentinel = reader.ReadUInt64();
        if (meta.Sentinel != ulong.MaxValue)
            throw new InvalidDataException("Compute blob: bad sentinel.");
        meta.Version = reader.ReadUInt64();

        // §6.2 CB block.
        meta.CbData.Count = reader.ReadUInt64();
        for (ulong i = 0; i < meta.CbData.Count; i++)
        {
            var e = new CbEntry
            {
                Name = ReadString(reader),
                VarCount = reader.ReadUInt64(),
            };
            for (ulong j = 0; j < e.VarCount; j++)
                e.Vars.Add(new VarPair { Name = ReadString(reader), Type = ReadString(reader) });
            meta.CbData.Entries.Add(e);
        }
        meta.CbData.Trailing = reader.ReadUInt64();

        // §6.3 Param block.
        meta.ParamData.OuterCount = reader.ReadUInt64();
        for (ulong i = 0; i < meta.ParamData.OuterCount; i++)
        {
            var outer = new ParamOuter { CbCount = reader.ReadUInt64() };
            for (ulong j = 0; j < outer.CbCount; j++)
            {
                var cb = new CbRecord
                {
                    Name = ReadString(reader),
                    CbSize = reader.ReadUInt32(),
                    VarCount = reader.ReadUInt64(),
                };
                for (ulong k = 0; k < cb.VarCount; k++)
                    cb.Variables.Add(new Variable
                    {
                        Name = ReadString(reader),
                        UnityType = reader.ReadUInt32(),
                        StartOffset = reader.ReadUInt32(),
                        Elements = reader.ReadUInt32(),
                        Rows = reader.ReadUInt32(),
                        Columns = reader.ReadUInt32(),
                    });
                outer.Cbs.Add(cb);
            }
            meta.ParamData.Entries.Add(outer);
        }

        // §6.4 Shader array — authoritative sequential order.
        ulong shaderCount = reader.ReadUInt64();
        for (ulong i = 0; i < shaderCount; i++)
        {
            var entry = new ShaderEntry { Name = ReadString(reader) };
            ReadList64(reader, entry.ListA);
            ReadList64(reader, entry.ListB);
            ReadList64(reader, entry.ListC);
            ReadList64(reader, entry.ListD);
            ulong pairCount = reader.ReadUInt64();
            for (ulong j = 0; j < pairCount; j++)
                entry.UintPairs.Add((reader.ReadUInt32(), reader.ReadUInt32()));
            ulong dxbcSize = reader.ReadUInt64();
            entry.Dxbc = ReadBytes(reader, dxbcSize);
            entry.ThreadGroupX = reader.ReadUInt32();
            entry.ThreadGroupY = reader.ReadUInt32();
            entry.ThreadGroupZ = reader.ReadUInt32();
            meta.ShaderEntries.Add(entry);
        }

        // Single trailing flag byte (§6.1) — may legitimately be absent when
        // the blob is exactly consumed.
        if (reader.BaseStream.Position < reader.BaseStream.Length)
            meta.TrailingFlags = reader.ReadByte();

        return meta;
    }

    private static void ReadList64(BinaryReader reader, List<List64Entry> into)
    {
        ulong count = reader.ReadUInt64();
        for (ulong i = 0; i < count; i++)
            into.Add(new List64Entry
            {
                Name = ReadString(reader),
                Type = ReadString(reader),
                V0 = reader.ReadUInt32(),
                V1 = reader.ReadUInt32(),
                V2 = reader.ReadUInt32(),
            });
    }

    // §6.6 string: [i32 LE len][len raw bytes].
    private static string ReadString(BinaryReader reader)
    {
        int len = reader.ReadInt32();
        if (len < 0)
            throw new InvalidDataException($"Compute blob: negative string length {len}.");
        if ((ulong)len > (ulong)(reader.BaseStream.Length - reader.BaseStream.Position))
            throw new InvalidDataException($"Compute blob: string length {len} extends past end of buffer.");
        var bytes = reader.ReadBytes(len);
        return Encoding.UTF8.GetString(bytes);
    }

    private static byte[] ReadBytes(BinaryReader reader, ulong count)
    {
        if (count > (ulong)(reader.BaseStream.Length - reader.BaseStream.Position))
            throw new InvalidDataException($"Compute blob: block of {count} bytes extends past end of buffer.");
        return reader.ReadBytes((int)count);
    }
}