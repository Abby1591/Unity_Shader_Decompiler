using System;
using System.IO;
using System.Linq;
using Parser;

namespace UnityShaderDecompiler.Tests;

public class MetadataTests
{
    [Fact]
    public void LoadFromFolder_ReadsNamePropertiesAndSubShaders()
    {
        var project = Parser.DXBC.Metadata.ShaderProject.LoadFromFolder(
            TestPaths.FixtureFolder("HOLO_Holo"));

        Assert.Equal("HOLO/Holo", project.Metadata.Name);
        Assert.NotEmpty(project.Metadata.Properties);
        Assert.NotEmpty(project.Metadata.SubShaders);
        Assert.NotNull(project.DummyShaderSource);
        Assert.True(project.Blob.Length > 0);
    }

    [Fact]
    public void LoadFromFolder_MissingBlob_ThrowsFileNotFound()
    {
        using var temp = new TempDirectory();
        var ex = Assert.Throws<FileNotFoundException>(() =>
            Parser.DXBC.Metadata.ShaderProject.LoadFromFolder(temp.Path));
        Assert.Contains("blob.bin", ex.Message);
    }

    [Theory]
    [InlineData("HOLO/Holo", "HOLO_Holo")]
    [InlineData("Toon/Basic", "Toon_Basic")]
    public void SafeFileName_ReplacesDirectorySeparators(string input, string expected)
    {
        Assert.Equal(expected, Decompiler.SafeFileName(input));
    }

    [Fact]
    public void SafeFileName_RemovesInvalidCharactersAndTrailingDots()
    {
        char invalid = Path.GetInvalidFileNameChars().First(c => c != '\0');
        string safe = Decompiler.SafeFileName($"name{invalid}value. ");

        Assert.All(safe, c => Assert.DoesNotContain(c, Path.GetInvalidFileNameChars()));
        Assert.False(safe.EndsWith('.'));
        Assert.False(safe.EndsWith(' '));
    }
}
