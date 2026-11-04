using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text.Json;
using UnityShaderDecompiler.Core.Hlsl.Ast;
using UnityShaderDecompiler.Core.DXBC.IR;
using Xunit;

namespace UnityShaderDecompiler.Tests;

// Covers invariant numeric formatting in IR constants and emitted ShaderLab.
public sealed class InvariantNumericOutputTests
{
    // Checks scalar and vector constants under cultures that use decimal commas.
    [Theory]
    [InlineData("fr-FR")]
    [InlineData("de-DE")]
    public void NumericConstantsUseInvariantDecimalSeparators(string culture)
    {
        WithCulture(culture, () =>
        {
            IRExpression.ConstantExpression scalar = new IRExpression.ConstantExpression
            {
                RawValues = new[] { BitConverter.SingleToUInt32Bits(0.125f) },
            };
            Assert.Equal("0.125", scalar.ToString());
            IRExpression.ConstantExpression vector = new IRExpression.ConstantExpression
            {
                Kind = IRExpression.ConstantExpression.ConstantKind.Double,
                DoubleValues = new[] { 0.125, 1.25 },
            };
            Assert.Equal("double2(0.125, 1.25)", vector.ToString());
        });
    }

    // Checks both range bounds in the public pretty-printer output.
    [Theory]
    [InlineData("fr-FR")]
    [InlineData("de-DE")]
    public void RangeBoundsUseInvariantDecimalSeparators(string culture)
    {
        WithCulture(culture, () =>
        {
            string text = RenderProperty(new HlslPropertyNode
            {
                Name = "_Amount", Kind = HlslPropertyKind.Range,
                Range = (-0.5f, 2.75f), DefaultComponents = new[] { 0.125f, 0f, 0f, 0f },
            });
            Assert.Contains("_Amount (\"_Amount\", Range(-0.5, 2.75)) = 0.125\n", text);
        });
    }

    // Exercises typed defaults and the legacy JSON fallback for every numeric property kind.
    public static IEnumerable<object[]> PropertyCases()
    {
        foreach (string culture in new[] { "fr-FR", "de-DE" })
        {
            foreach (HlslPropertyKind kind in new[] { HlslPropertyKind.Float, HlslPropertyKind.Range,
                HlslPropertyKind.Color, HlslPropertyKind.Vector })
            {
                yield return new object[] { culture, kind, true };
                yield return new object[] { culture, kind, false };
            }
        }
    }

    // Checks exact scalar and four-component defaults through the public printer.
    [Theory]
    [MemberData(nameof(PropertyCases))]
    public void PropertyDefaultsUseInvariantDecimalSeparators(string culture, HlslPropertyKind kind, bool typed)
    {
        WithCulture(culture, () =>
        {
            using JsonDocument json = JsonDocument.Parse("{\"x\":0.125,\"y\":-0.5,\"z\":2.75,\"w\":1.25}");
            string text = RenderProperty(new HlslPropertyNode
            {
                Name = "_Value", Kind = kind, Range = (0f, 3f),
                DefaultComponents = typed ? new[] { 0.125f, -0.5f, 2.75f, 1.25f } : Array.Empty<float>(),
                DefaultValue = typed ? null : json.RootElement,
            });
            string type = kind == HlslPropertyKind.Range ? "Range(0, 3)" : kind.ToString();
            string value = kind is HlslPropertyKind.Color or HlslPropertyKind.Vector
                ? "(0.125,-0.5,2.75,1.25)" : "0.125";
            Assert.Contains($"_Value (\"_Value\", {type}) = {value}\n", text);
        });
    }

    // Checks both signed polygon-offset values in an emitted shader pass.
    [Theory]
    [InlineData("fr-FR")]
    [InlineData("de-DE")]
    public void RenderStateOffsetUsesInvariantDecimalSeparators(string culture)
    {
        WithCulture(culture, () =>
        {
            HlslShaderNode shader = new HlslShaderNode { Name = "Test/NumericOffset" };
            HlslSubShaderNode subshader = new HlslSubShaderNode();
            subshader.Passes.Add(new HlslPassNode
            {
                State = new HlslRenderState { OffsetFactor = -0.125f, OffsetUnits = 1.25f },
            });
            shader.SubShaders.Add(subshader);
            Assert.Contains("            Offset -0.125, 1.25\n", HlslPrettyPrinter.Print(shader));
        });
    }

    // Emits one property without involving unrelated shader-program generation.
    private static string RenderProperty(HlslPropertyNode property)
    {
        HlslShaderNode shader = new HlslShaderNode { Name = "Test/NumericProperty" };
        shader.Properties.Add(property);
        return HlslPrettyPrinter.Print(shader);
    }

    // Restores the caller's culture even when an assertion fails.
    private static void WithCulture(string culture, Action assertion)
    {
        CultureInfo previous = CultureInfo.CurrentCulture;
        try
        {
            CultureInfo.CurrentCulture = new CultureInfo(culture);
            assertion();
        }
        finally
        {
            CultureInfo.CurrentCulture = previous;
        }
    }
}
