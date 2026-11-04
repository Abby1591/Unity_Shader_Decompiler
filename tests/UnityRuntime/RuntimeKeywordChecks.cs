using System;
using System.IO;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;

// Run in a disposable Built-in project after exporting the native xUnit fixture into Assets.
public static class RuntimeKeywordChecks
{
    public static void Run()
    {
        if (Application.unityVersion != "6000.0.75f1")
            throw new InvalidOperationException("Runtime shader checks target Unity 6000.0.75f1.");
        if (SystemInfo.graphicsDeviceType != GraphicsDeviceType.Direct3D11)
            throw new InvalidOperationException("Runtime shader checks require Direct3D 11.");
        AssetDatabase.ImportAsset("Assets/RuntimeKeywords.shader", ImportAssetOptions.ForceSynchronousImport);
        Shader shader = AssetDatabase.LoadAssetAtPath<Shader>("Assets/RuntimeKeywords.shader");
        if (shader == null || ShaderUtil.ShaderHasError(shader))
            throw new InvalidOperationException("Generated shader failed Unity import.");
        LocalKeyword mode = new LocalKeyword(shader, "MODE");
        LocalKeyword detail = new LocalKeyword(shader, "DETAIL");
        if (!mode.isValid || !mode.isOverridable || !detail.isValid || detail.isOverridable)
            throw new InvalidOperationException("Keyword scopes differ from the serialized metadata.");
        Material material = new Material(shader);
        RenderTexture target = new RenderTexture(4, 4, 0, RenderTextureFormat.ARGBFloat, RenderTextureReadWrite.Linear);
        Texture2D readback = new Texture2D(4, 4, TextureFormat.RGBAFloat, false, true);
        Mesh quad = new Mesh
        {
            vertices = new[] { new Vector3(-1f, -1f, 0f), new Vector3(-1f, 1f, 0f),
                new Vector3(1f, 1f, 0f), new Vector3(1f, -1f, 0f) },
            triangles = new[] { 0, 1, 2, 0, 2, 3 },
        };
        RenderTexture previous = RenderTexture.active;
        bool previousSrgb = GL.sRGBWrite;
        int cases = 0;
        try
        {
            if (material.passCount != 2 || material.FindPass("Pass0") != 0 || material.FindPass("Pass1") != 1)
                throw new InvalidOperationException("Serialized pass count or order changed.");
            Shader.DisableKeyword("MODE");
            Shader.DisableKeyword("DETAIL");
            for (int pass = 0; pass < 2; pass++)
                for (int state = 0; state < 4; state++)
                {
                    material.SetKeyword(mode, (state & 1) != 0);
                    material.SetKeyword(detail, (state & 2) != 0);
                    Check(material, pass, target, readback, quad, new Color(
                        (state & 1) != 0 ? 0.75f : 0.25f,
                        (state & 2) != 0 ? 0.75f : 0.25f,
                        pass == 0 ? 0.5f : 1f, 1f));
                    cases++;
                }
            material.SetKeyword(mode, false);
            material.SetKeyword(detail, false);
            Shader.EnableKeyword("MODE");
            Shader.EnableKeyword("DETAIL");
            Check(material, 0, target, readback, quad, new Color(0.75f, 0.25f, 0.5f, 1f));
            cases++;
            if (ShaderUtil.ShaderHasError(shader))
                throw new InvalidOperationException("Shader compilation failed while selecting a variant.");
            File.WriteAllText("runtime-keyword-results.json", "{\"passed\":true,\"cases\":" + cases + ",\"backend\":\"Direct3D11\"}");
            Debug.Log($"Runtime keyword checks passed: {cases} GPU readbacks.");
        }
        finally
        {
            Shader.DisableKeyword("MODE");
            Shader.DisableKeyword("DETAIL");
            RenderTexture.active = previous;
            GL.sRGBWrite = previousSrgb;
            UnityEngine.Object.DestroyImmediate(material);
            UnityEngine.Object.DestroyImmediate(readback);
            UnityEngine.Object.DestroyImmediate(target);
            UnityEngine.Object.DestroyImmediate(quad);
        }
    }

    private static void Check(Material material, int pass, RenderTexture target, Texture2D readback, Mesh quad, Color expected)
    {
        RenderTexture.active = target;
        GL.sRGBWrite = false;
        GL.Clear(true, true, Color.magenta);
        if (!material.SetPass(pass)) throw new InvalidOperationException("Failed to activate the generated pass.");
        Graphics.DrawMeshNow(quad, Matrix4x4.identity);
        readback.ReadPixels(new Rect(0, 0, 4, 4), 0, 0);
        readback.Apply();
        Color actual = readback.GetPixel(2, 2);
        if (Mathf.Abs(actual.r - expected.r) > 0.001f || Mathf.Abs(actual.g - expected.g) > 0.001f
            || Mathf.Abs(actual.b - expected.b) > 0.001f || Mathf.Abs(actual.a - expected.a) > 0.001f)
            throw new InvalidOperationException($"Pass {pass}: expected {expected}, read {actual} from the GPU.");
    }
}
