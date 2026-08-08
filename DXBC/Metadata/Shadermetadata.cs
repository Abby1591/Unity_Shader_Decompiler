using System;
using System.Collections.Generic;
using System.IO;
using System.Text.Json;

namespace Parser.DXBC.Metadata;

/// <summary>
/// Deserializes metadata.json produced by Stage 0.2 (libs/metadata.py).
/// Kept loose (JsonElement-backed) rather than strict POCOs, since the
/// upstream Unity SerializedShader schema isn't fully pinned down yet —
/// callers should treat missing fields as "unknown", not an error.
/// </summary>
public sealed class ShaderMetadata
{
    public string Name { get; init; } = "";
    public List<ShaderProperty> Properties { get; init; } = new();
    public List<SubShaderMetadata> SubShaders { get; init; } = new();
    public string Fallback { get; init; } = "";
    public List<string> Dependencies { get; init; } = new();
    public JsonElement Raw { get; init; }

    public static ShaderMetadata Load(string path)
    {
        using var doc = JsonDocument.Parse(File.ReadAllText(path));
        var root = doc.RootElement.Clone();

        var meta = new ShaderMetadata
        {
            Name = GetString(root, "name"),
            Fallback = GetString(root, "fallback"),
            Dependencies = GetDependencies(root),
            Raw = root,
        };

        if (root.TryGetProperty("properties", out var props) && props.ValueKind == JsonValueKind.Array)
        {
            foreach (var p in props.EnumerateArray())
                meta.Properties.Add(ShaderProperty.From(p));
        }

        if (root.TryGetProperty("subShaders", out var subs) && subs.ValueKind == JsonValueKind.Array)
        {
            foreach (var s in subs.EnumerateArray())
                meta.SubShaders.Add(SubShaderMetadata.From(s));
        }

        return meta;
    }

    private static string GetString(JsonElement el, string key) =>
        el.TryGetProperty(key, out var v) && v.ValueKind == JsonValueKind.String
            ? v.GetString() ?? ""
            : "";

    // metadata.py passes m_Dependencies through untouched, and its shape
    // isn't pinned down yet (could be a plain string array, or an array of
    // {"first": key, "second": value} pairs like Unity's other paired
    // structures) — handle both rather than guessing wrong and crashing.
    private static List<string> GetDependencies(JsonElement root)
    {
        var result = new List<string>();
        if (!root.TryGetProperty("dependencies", out var deps) || deps.ValueKind != JsonValueKind.Array)
            return result;

        foreach (var d in deps.EnumerateArray())
        {
            if (d.ValueKind == JsonValueKind.String)
            {
                result.Add(d.GetString() ?? "");
            }
            else if (d.ValueKind == JsonValueKind.Object)
            {
                string? second = d.TryGetProperty("second", out var s) ? s.GetString() : null;
                result.Add(second ?? d.ToString());
            }
        }

        return result;
    }
}

public sealed class ShaderProperty
{
    public string Name { get; init; } = "";
    public string? Description { get; init; }
    public string? Type { get; init; }
    public JsonElement? DefaultValue { get; init; }
    public List<string> Attributes { get; init; } = new();
    public JsonElement? DefaultTexture { get; init; }

    public static ShaderProperty From(JsonElement el) => new()
    {
        Name = el.TryGetProperty("name", out var n) ? n.GetString() ?? "" : "",
        Description = el.TryGetProperty("description", out var d) ? d.GetString() : null,
        Type = el.TryGetProperty("type", out var t) ? t.ToString() : null,
        DefaultValue = el.TryGetProperty("defaultValue", out var v) ? v : null,
        Attributes = el.TryGetProperty("attributes", out var attrs) && attrs.ValueKind == JsonValueKind.Array
            ? attrs.EnumerateArray().Select(a => a.ToString()).ToList()
            : new List<string>(),
        DefaultTexture = el.TryGetProperty("defaultTexture", out var dt) ? dt : null,
    };
}

public sealed class SubShaderMetadata
{
    public Dictionary<string, string> Tags { get; init; } = new();
    public int? Lod { get; init; }
    public List<PassMetadata> Passes { get; init; } = new();

    public static SubShaderMetadata From(JsonElement el)
    {
        var result = new SubShaderMetadata
        {
            Lod = el.TryGetProperty("lod", out var lod) && lod.ValueKind == JsonValueKind.Number
                ? lod.GetInt32()
                : null,
        };

        if (el.TryGetProperty("tags", out var tags) && tags.ValueKind == JsonValueKind.Object)
            foreach (var t in tags.EnumerateObject())
                result.Tags[t.Name] = t.Value.ToString();

        if (el.TryGetProperty("passes", out var passes) && passes.ValueKind == JsonValueKind.Array)
            foreach (var p in passes.EnumerateArray())
                result.Passes.Add(PassMetadata.From(p));

        return result;
    }
}

public sealed class PassMetadata
{
    public string Name { get; init; } = "";
    public Dictionary<string, string> Tags { get; init; } = new();
    public JsonElement RenderState { get; init; }

    // Per-pass cbuffer layout recovered from Unity's serialized shader
    // (m_CommonParameters) — the substitute for the RDEF chunk Unity
    // strips from shipped bytecode. Keyed by register slot.
    public List<CbufferMetadata> ConstantBuffers { get; init; } = new();

    public static PassMetadata From(JsonElement el)
    {
        var result = new PassMetadata
        {
            Name = el.TryGetProperty("name", out var n) ? n.GetString() ?? "" : "",
            RenderState = el.TryGetProperty("renderState", out var rs) ? rs : default,
        };

        if (el.TryGetProperty("tags", out var tags) && tags.ValueKind == JsonValueKind.Object)
            foreach (var t in tags.EnumerateObject())
                result.Tags[t.Name] = t.Value.ToString();

        if (el.TryGetProperty("constantBuffers", out var cbs) && cbs.ValueKind == JsonValueKind.Array)
            foreach (var cb in cbs.EnumerateArray())
                result.ConstantBuffers.Add(CbufferMetadata.From(cb));

        return result;
    }
}

/// <summary>One cbuffer in a pass: register slot -> name + variables.</summary>
public sealed class CbufferMetadata
{
    public int Slot { get; init; } = -1;
    // Stage this buffer is bound in (Vertex/Fragment/Geometry/...). Stages
    // bind their own cbuffer tables, so two different buffers can legally
    // share a slot number across stages (e.g. UnityPerDraw and $Globals
    // both at b0); "" means the buffer is shared across all stages.
    public string Stage { get; init; } = "";
    public string Name { get; init; } = "";
    public List<CbufferVariableMetadata> Variables { get; init; } = new();

    public static CbufferMetadata From(JsonElement el)
    {
        var result = new CbufferMetadata
        {
            Slot = el.TryGetProperty("slot", out var s) && s.ValueKind == JsonValueKind.Number
                ? s.GetInt32()
                : -1,
            Stage = el.TryGetProperty("stage", out var st) && st.ValueKind == JsonValueKind.String
                ? st.GetString() ?? ""
                : "",
            Name = el.TryGetProperty("name", out var n) ? n.GetString() ?? "" : "",
        };

        if (el.TryGetProperty("variables", out var vars) && vars.ValueKind == JsonValueKind.Array)
            foreach (var v in vars.EnumerateArray())
                result.Variables.Add(CbufferVariableMetadata.From(v));

        return result;
    }
}

/// <summary>A variable inside a cbuffer: byte offset + name + shape.</summary>
public sealed class CbufferVariableMetadata
{
    public string Name { get; init; } = "";
    public int Offset { get; init; }
    public int Dim { get; init; }        // 1-4 for vectors (float/float2/float3/float4)
    public int RowCount { get; init; }   // 4 for float4x4 (matrices)
    public int ArraySize { get; init; }
    public bool IsMatrix { get; init; }

    public int Rows => Math.Max(RowCount, 4);

    // Byte size of the variable (16 bytes per matrix row / 4 per vector
    // component, times the array length).
    public int SizeBytes => (IsMatrix || RowCount > 0)
        ? Rows * 16 * Math.Max(1, ArraySize)
        : Math.Max(1, Dim) * 4 * Math.Max(1, ArraySize);

    public string TypeName => (IsMatrix || RowCount > 0)
        ? (Rows == 4 ? "float4x4" : $"float{Rows}x4")
        : (Math.Max(1, Dim) switch
        {
            1 => "float",
            2 => "float2",
            3 => "float3",
            _ => "float4",
        });

    public static CbufferVariableMetadata From(JsonElement el) => new()
    {
        Name = el.TryGetProperty("name", out var n) ? n.GetString() ?? "" : "",
        Offset = el.TryGetProperty("offset", out var o) && o.ValueKind == JsonValueKind.Number
            ? o.GetInt32()
            : 0,
        Dim = el.TryGetProperty("dim", out var d) && d.ValueKind == JsonValueKind.Number
            ? d.GetInt32()
            : 0,
        RowCount = el.TryGetProperty("rowCount", out var r) && r.ValueKind == JsonValueKind.Number
            ? r.GetInt32()
            : 0,
        ArraySize = el.TryGetProperty("arraySize", out var a) && a.ValueKind == JsonValueKind.Number
            ? a.GetInt32()
            : 0,
        IsMatrix = el.TryGetProperty("isMatrix", out var m) && m.ValueKind == JsonValueKind.True,
    };
}