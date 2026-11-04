using System;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using UnityEditor;
using UnityEditor.Rendering;
using UnityEngine;
using UnityEngine.Rendering;

public static class ShaderVariantChecks
{
    [Serializable] private sealed class Manifest
    {
        public int schemaVersion;
        public string shaderSha256;
        public Pass[] passes;
    }
    [Serializable] private sealed class Pass
    {
        public int passIndex;
        public Variant[] variants;
    }
    [Serializable] private sealed class Variant { public string[] keywords; }

    public static void Run()
    {
        if (Application.unityVersion != "6000.0.75f1" || SystemInfo.graphicsDeviceType != GraphicsDeviceType.Direct3D11)
            throw new InvalidOperationException("Variant checks require Unity 6000.0.75f1 and Direct3D 11.");
        string folder = Environment.GetEnvironmentVariable("SHADER_VARIANT_DIRECTORY");
        if (string.IsNullOrEmpty(folder) || !folder.Replace('\\', '/').StartsWith("Assets/", StringComparison.Ordinal))
            throw new InvalidOperationException("SHADER_VARIANT_DIRECTORY must name a folder under Assets/.");
        string[] paths = Directory.GetFiles(folder, "*.shader", SearchOption.AllDirectories);
        if (paths.Length == 0) throw new InvalidOperationException("No generated shaders found.");
        int compiled = 0;
        foreach (string path in paths.OrderBy(value => value, StringComparer.Ordinal))
        {
            Manifest manifest = JsonUtility.FromJson<Manifest>(File.ReadAllText(Path.ChangeExtension(path, ".variants.json")));
            using (SHA256 hasher = SHA256.Create())
            {
                string hash = BitConverter.ToString(hasher.ComputeHash(File.ReadAllBytes(path))).Replace("-", "");
                if (manifest.schemaVersion != 1 || !string.Equals(hash, manifest.shaderSha256, StringComparison.OrdinalIgnoreCase))
                    throw new InvalidOperationException("Manifest does not match shader: " + path);
            }
            string assetPath = path.Replace('\\', '/');
            AssetDatabase.ImportAsset(assetPath, ImportAssetOptions.ForceSynchronousImport);
            Shader shader = AssetDatabase.LoadAssetAtPath<Shader>(assetPath);
            if (shader == null || ShaderUtil.ShaderHasError(shader))
                throw new InvalidOperationException("Shader import failed: " + path);
            ShaderData data = ShaderUtil.GetShaderData(shader);
            int flatPass = 0;
            for (int sub = 0; sub < data.SubshaderCount; sub++)
            {
                ShaderData.Subshader subshader = data.GetSubshader(sub);
                for (int pass = 0; pass < subshader.PassCount; pass++, flatPass++)
                {
                    if (flatPass >= manifest.passes.Length || manifest.passes[flatPass].passIndex != flatPass)
                        throw new InvalidOperationException("Imported pass order differs from manifest.");
                    Pass entry = manifest.passes[flatPass];
                    if (entry.variants == null || entry.variants.Length == 0)
                        throw new InvalidOperationException("Pass has no variants.");
                    foreach (Variant variant in entry.variants)
                        foreach (ShaderType stage in new[] { ShaderType.Vertex, ShaderType.Fragment })
                        {
                            ShaderData.VariantCompileInfo result = subshader.GetPass(pass).CompileVariant(stage,
                                variant.keywords, ShaderCompilerPlatform.D3D, BuildTarget.StandaloneWindows64);
                            if (!result.Success || result.ShaderData == null || result.ShaderData.Length == 0)
                                throw new InvalidOperationException($"{path} pass {flatPass} {stage} [{string.Join(",", variant.keywords)}]: "
                                    + string.Join("; ", result.Messages.Select(message => message.message)));
                            compiled++;
                        }
                }
            }
            if (flatPass != manifest.passes.Length || ShaderUtil.ShaderHasError(shader))
                throw new InvalidOperationException("Imported pass count or compilation differs from manifest.");
            Debug.Log($"Validated {path}: {flatPass} passes.");
        }
        File.WriteAllText("shader-variant-results.json", "{\"passed\":true,\"shaders\":" + paths.Length
            + ",\"compiledStages\":" + compiled + ",\"editor\":\"" + Application.unityVersion + "\"}");
    }
}
