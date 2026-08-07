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
    public JsonElement Raw { get; init; }

    public static ShaderMetadata Load(string path)
    {
        using var doc = JsonDocument.Parse(File.ReadAllText(path));
        var root = doc.RootElement.Clone();

        var meta = new ShaderMetadata
        {
            Name = GetString(root, "name"),
            Fallback = GetString(root, "fallback"),
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
}

public sealed class ShaderProperty
{
    public string Name { get; init; } = "";
    public string? Description { get; init; }
    public string? Type { get; init; }
    public JsonElement? DefaultValue { get; init; }

    public static ShaderProperty From(JsonElement el) => new()
    {
        Name = el.TryGetProperty("name", out var n) ? n.GetString() ?? "" : "",
        Description = el.TryGetProperty("description", out var d) ? d.GetString() : null,
        Type = el.TryGetProperty("type", out var t) ? t.ToString() : null,
        DefaultValue = el.TryGetProperty("defaultValue", out var v) ? v : null,
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

        return result;
    }
}