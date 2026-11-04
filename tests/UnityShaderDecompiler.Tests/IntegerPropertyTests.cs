using System.Text.Json;
using Parser.Core.Hlsl.Ast;
using Parser.DXBC.Metadata;

namespace UnityShaderDecompiler.Tests;

public sealed class IntegerPropertyTests
{
    [Theory]
    [InlineData(0)]
    [InlineData(1)]
    [InlineData(42)]
    [InlineData(1065353216)]
    [InlineData(int.MinValue)]
    public void SerializedIntegerDefaultsPreserveBits(int expected)
    {
        float serialized = BitConverter.Int32BitsToSingle(expected);
        ShaderMetadata metadata = new ShaderMetadata
        {
            Name = "Test/IntegerProperty",
        };
        metadata.Properties.Add(new ShaderProperty
        {
            Name = "_Count", Type = "5", DefaultComponents = [serialized, 0, 0, 0],
        });
        string text = HlslPrettyPrinter.Print(HlslAstBuilder.BuildShell(metadata));
        Assert.Contains($"_Count (\"_Count\", Integer) = {expected}", text);
    }

    [Fact]
    public void NonFiniteDefaultCannotRecoverAnIntegerPayload()
    {
        HlslShaderNode shader = new HlslShaderNode();
        shader.Properties.Add(new HlslPropertyNode
        {
            Kind = HlslPropertyKind.Integer, DefaultComponents = [float.NaN, 0, 0, 0],
        });
        Assert.Throws<InvalidDataException>(() => HlslPrettyPrinter.Print(shader));
    }
}
