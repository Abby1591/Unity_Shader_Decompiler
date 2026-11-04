using System;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;

// Builds the D3D11 fixture bundle and rejects shader import errors.
public static class BuildFixtures
{
    // Runs the validation and writes its result report.
    public static void Run()
    {
        File.WriteAllText("fixture-build.json", "{\"passed\":false}");
        if (Application.unityVersion != "6000.0.75f1")
        {
            throw new InvalidOperationException("Fixture generation requires Unity 6000.0.75f1.");
        }
        if (SystemInfo.graphicsDeviceType != GraphicsDeviceType.Direct3D11)
        {
            throw new InvalidOperationException("Fixture generation requires Direct3D 11.");
        }
        string[] assets = Directory.GetFiles("Assets/VolumetricLights", "*.shader")
            .Select(path => path.Replace('\\', '/')).OrderBy(path => path, StringComparer.Ordinal).ToArray();
        if (assets.Length != 3)
        {
            throw new InvalidOperationException("Expected the three upstream shaders.");
        }
        ConfigureShaders(assets);
        Directory.CreateDirectory("FixtureBundle");
        AssetBundleBuild bundle = new AssetBundleBuild { assetBundleName = "volumetriclights", assetNames = assets };
        AssetBundleManifest manifest = BuildPipeline.BuildAssetBundles("FixtureBundle", new[] { bundle },
            BuildAssetBundleOptions.ForceRebuildAssetBundle | BuildAssetBundleOptions.StrictMode,
            BuildTarget.StandaloneWindows64);
        if (manifest == null || !File.Exists("FixtureBundle/volumetriclights"))
        {
            throw new InvalidOperationException("Fixture bundle compilation failed.");
        }
        foreach (string path in assets)
        {
            if (ShaderUtil.ShaderHasError(AssetDatabase.LoadAssetAtPath<Shader>(path)))
            {
                throw new InvalidOperationException("Shader compilation failed: " + path);
            }
        }
        File.WriteAllText("fixture-build.json", "{\"passed\":true,\"editor\":\"6000.0.75f1\",\"backend\":\"Direct3D11\",\"shaders\":3}");
    }

    // Configures D3D11 and includes every fixture shader in the bundle.
    private static void ConfigureShaders(string[] assets)
    {
        PlayerSettings.SetUseDefaultGraphicsAPIs(BuildTarget.StandaloneWindows64, false);
        PlayerSettings.SetGraphicsAPIs(BuildTarget.StandaloneWindows64, new[] { GraphicsDeviceType.Direct3D11 });
        SerializedObject graphics = new SerializedObject(AssetDatabase.LoadAllAssetsAtPath("ProjectSettings/GraphicsSettings.asset")[0]);
        SerializedProperty included = graphics.FindProperty("m_AlwaysIncludedShaders");
        included.arraySize = assets.Length;
        for (int index = 0; index < assets.Length; index++)
        {
            AssetDatabase.ImportAsset(assets[index], ImportAssetOptions.ForceSynchronousImport);
            Shader shader = AssetDatabase.LoadAssetAtPath<Shader>(assets[index]);
            if (shader == null || ShaderUtil.ShaderHasError(shader))
            {
                throw new InvalidOperationException("Shader import failed: " + assets[index]);
            }
            included.GetArrayElementAtIndex(index).objectReferenceValue = shader;
        }
        graphics.ApplyModifiedPropertiesWithoutUndo();
        AssetDatabase.SaveAssets();
    }
}
