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
        using JsonDocument json = JsonDocument.Parse(JsonSerializer.Serialize(new
        {
            name = "_Count", type = 5, defaultValue = new { x = serialized, y = 0, z = 0, w = 0 },
        }));
        metadata.Properties.Add(ShaderProperty.From(json.RootElement));
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

    [Theory]
    [InlineData("{\"type\":5}")]
    [InlineData("{\"type\":5,\"defaultValue\":{\"x\":\"NaN\"}}")]
    public void MissingOrUnrecoverableIntegerDefaultsFail(string input)
    {
        using JsonDocument json = JsonDocument.Parse(input);
        Assert.Throws<InvalidDataException>(() => ShaderProperty.From(json.RootElement));
    }
}
