using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using Parser.Core.Hlsl.Ast;

namespace Parser;

internal sealed record RuntimeCompilationCase(int Pass, int Variant, string Hlsl,
    int Vertex, int Fragment, string VertexProfile, string FragmentProfile);

internal static class RuntimeVariantManifest
{
    internal const string Marker = "#error No serialized program matches this shader keyword state";

    internal static void Write(string shaderPath, string text, HlslShaderNode shader,
        IReadOnlyList<DecompiledSubprogram> programs)
    {
        Dictionary<int, DecompiledSubprogram> byIndex = programs.ToDictionary(program => program.Index);
        object manifest = new
        {
            schemaVersion = 1,
            shaderSha256 = Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(text))),
            passes = shader.SubShaders.SelectMany(sub => sub.Passes).Select((pass, index) => new
            {
                passIndex = index,
                variants = pass.RuntimeVariants!.States.Select(state => new
                {
                    vertex = state.Vertex, fragment = state.Fragment, keywords = state.Keywords,
                    vertexProfile = byIndex[state.Vertex].Dxbc.Shader!.ShaderModel,
                    fragmentProfile = byIndex[state.Fragment].Dxbc.Shader!.ShaderModel,
                }),
            }),
        };
        File.WriteAllText(Path.ChangeExtension(shaderPath, ".variants.json"),
            JsonSerializer.Serialize(manifest, new JsonSerializerOptions { WriteIndented = true }));
    }

    internal static List<RuntimeCompilationCase> Read(string shaderPath)
    {
        string text = File.ReadAllText(shaderPath);
        using JsonDocument manifest = JsonDocument.Parse(File.ReadAllText(Path.ChangeExtension(shaderPath, ".variants.json")));
        JsonElement root = manifest.RootElement;
        string hash = Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(text)));
        if (root.GetProperty("schemaVersion").GetInt32() != 1
            || !string.Equals(root.GetProperty("shaderSha256").GetString(), hash, StringComparison.OrdinalIgnoreCase))
            throw new InvalidDataException("Variant manifest does not match the generated shader.");
        MatchCollection blocks = Regex.Matches(text, @"HLSLPROGRAM(.*?)ENDHLSL", RegexOptions.Singleline);
        JsonElement passes = root.GetProperty("passes");
        if (passes.GetArrayLength() != blocks.Count || blocks.Count == 0)
            throw new InvalidDataException("Variant manifest has an invalid pass count.");
        List<RuntimeCompilationCase> cases = new List<RuntimeCompilationCase>();
        int passIndex = 0;
        foreach (JsonElement pass in passes.EnumerateArray())
        {
            if (pass.GetProperty("passIndex").GetInt32() != passIndex)
                throw new InvalidDataException("Variant manifest pass order is invalid.");
            int variantIndex = 0;
            foreach (JsonElement variant in pass.GetProperty("variants").EnumerateArray())
            {
                string[] keywords = variant.GetProperty("keywords").EnumerateArray().Select(value => value.GetString()!).ToArray();
                if (keywords.Any(keyword => !Regex.IsMatch(keyword, @"\A[A-Za-z_][A-Za-z0-9_]*\z")))
                    throw new InvalidDataException("Variant manifest contains an invalid keyword.");
                string vertexProfile = variant.GetProperty("vertexProfile").GetString()!;
                string fragmentProfile = variant.GetProperty("fragmentProfile").GetString()!;
                if (!Regex.IsMatch(vertexProfile, @"\Avs_[45]_0\z") || !Regex.IsMatch(fragmentProfile, @"\Aps_[45]_0\z"))
                    throw new InvalidDataException("Variant manifest contains an unsupported shader profile.");
                string definitions = string.Concat(keywords.Select(keyword => $"#define {keyword} 1\n"));
                cases.Add(new RuntimeCompilationCase(passIndex, variantIndex++, definitions + blocks[passIndex].Groups[1].Value,
                    variant.GetProperty("vertex").GetInt32(), variant.GetProperty("fragment").GetInt32(), vertexProfile, fragmentProfile));
            }
            if (variantIndex == 0) throw new InvalidDataException("Variant manifest contains an empty pass.");
            passIndex++;
        }
        return cases;
    }

    internal static void VerifyCompilation(string shaderPath)
    {
        List<RuntimeCompilationCase> cases = Read(shaderPath);
        foreach (RuntimeCompilationCase item in cases)
        {
            RecompileVerify.CompileHlsl(item.Hlsl, "vert", item.VertexProfile);
            RecompileVerify.CompileHlsl(item.Hlsl, "frag", item.FragmentProfile);
            Console.WriteLine($"pass{item.Pass + 1} variant{item.Variant + 1}: compiled programs {item.Vertex}/{item.Fragment}");
        }
        Console.WriteLine($"passes={cases.Select(item => item.Pass).Distinct().Count()} variants={cases.Count} compiled={cases.Count} compileFailures=0");
    }
}
