using System;
using System.IO;
using System.Linq;
using UnityShaderDecompiler.Core;

namespace UnityShaderDecompiler.Tests;

public class MetadataTests
{
    [Fact]
    public void LoadFromFolder_ReadsNamePropertiesAndSubShaders()
    {
        var project = UnityShaderDecompiler.Core.DXBC.Metadata.ShaderProject.LoadFromFolder(
            TestPaths.FixtureFolder("Corpus_01 Properties"));

        Assert.Equal("Corpus/01 Properties", project.Metadata.Name);
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
            UnityShaderDecompiler.Core.DXBC.Metadata.ShaderProject.LoadFromFolder(temp.Path));
        Assert.Contains("blob.bin", ex.Message);
    }

    [Theory]
    [InlineData("Corpus/01 Properties", "Corpus_01 Properties")]
    [InlineData("Corpus/16 UsePass Consumer", "Corpus_16 UsePass Consumer")]
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
