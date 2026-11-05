using UnityShaderDecompiler.Core.Hlsl;
using UnityShaderDecompiler.Core.Hlsl.Ast;
using UnityShaderDecompiler.Core.DXBC.IR;

namespace UnityShaderDecompiler.Tests;

// Verifies that resource reconstruction never invents runtime bindings.
public sealed class ResourceBindingLayoutsTests
{
    // Keeps the original member name when the layout is fully identified.
    [Fact]
    public void KnownMembersRemainNamed()
    {
        HlslResourceNode buffer = Buffer("NamedBuffer", "NamedValue");
        string source = HlslPrettyPrinter.Print(Shader(buffer), fuseTemps: false);
        Assert.Contains("NamedValue : packoffset(c0)", source);
        Assert.DoesNotContain("cb0_values", source);
    }

    // Refuses to erase known members when other accesses are unresolved.
    [Fact]
    public void PartialBufferCannotReplaceNamedMembersWithRawStorage()
    {
        HlslResourceNode buffer = Buffer("NamedBuffer", "NamedValue");
        buffer.Variables.Add(new HlslCBufferVariable
        {
            Name = "cb0_values", TypeName = "float4", Offset = 0, Size = 32, ArraySize = 2,
        });
        InvalidDataException error = Assert.Throws<InvalidDataException>(() => HlslPrettyPrinter.Print(Shader(buffer)));
        Assert.Contains("Conflicting member layouts", error.Message);
        Assert.Equal("NamedValue", buffer.Variables[0].Name);
    }

    // Rejects different buffer identities sharing a slot across stages.
    [Fact]
    public void DifferentStageBuffersCannotMergeBySlot()
    {
        List<HlslResourceNode> resources = new List<HlslResourceNode>();
        VerifiedResourceBindings.Attach(resources, Buffer("PerObject", "ObjectValue"), "Vertex");
        InvalidDataException error = Assert.Throws<InvalidDataException>(() =>
            VerifiedResourceBindings.Attach(resources, Buffer("PerCamera", "CameraValue"), "Fragment"));
        Assert.Contains("Vertex PerObject, Fragment PerCamera", error.Message);
        Assert.Single(resources);
    }

    // Allows matching identities and layouts to be shared by both stages.
    [Fact]
    public void MatchingStageBuffersShareTheirVerifiedLayout()
    {
        List<HlslResourceNode> resources = new List<HlslResourceNode>();
        VerifiedResourceBindings.Attach(resources, Buffer("Shared", "Value"), "Vertex");
        VerifiedResourceBindings.Attach(resources, Buffer("Shared", "Value"), "Fragment");
        Assert.Single(Assert.Single(resources).Variables);
    }

    // Rejects overlapping members instead of redirecting reads to another name.
    [Fact]
    public void DifferentMembersAtTheSameOffsetAreRejected()
    {
        List<HlslResourceNode> resources = new List<HlslResourceNode>();
        VerifiedResourceBindings.Attach(resources, Buffer("Shared", "Left"), "Vertex");
        Assert.Throws<InvalidDataException>(() =>
            VerifiedResourceBindings.Attach(resources, Buffer("Shared", "Right"), "Fragment"));
    }

    // Does not rename a duplicate texture into an unbound material property.
    [Fact]
    public void DuplicateTextureNamesAreRejectedWithoutMutation()
    {
        HlslResourceNode first = new HlslResourceNode { Name = "_Tex", Kind = HlslResourceKind.Texture, Slot = 0 };
        HlslResourceNode second = new HlslResourceNode { Name = "_Tex", Kind = HlslResourceKind.Texture, Slot = 1 };
        Assert.Throws<InvalidDataException>(() => HlslPrettyPrinter.Print(Shader(first, second)));
        Assert.Equal("_Tex", second.Name);
    }

    // Requires texture metadata instead of inventing t0 or a property name.
    [Fact]
    public void MissingTextureNameStopsResourceConstruction()
    {
        List<IRDeclaration> declarations = new List<IRDeclaration>
        {
            new IRDeclaration.IRResourceDeclaration { Slot = 0 },
        };
        InvalidDataException error = Assert.Throws<InvalidDataException>(() => HlslAstBuilder.BuildResources(declarations).ToList());
        Assert.Contains("Missing texture binding name", error.Message);
    }

    // Creates a fully specified buffer for binding checks.
    private static HlslResourceNode Buffer(string name, string member)
    {
        HlslResourceNode buffer = new HlslResourceNode { Name = name, Kind = HlslResourceKind.ConstantBuffer, Slot = 0 };
        buffer.Variables.Add(new HlslCBufferVariable { Name = member, TypeName = "float4", Offset = 0, Size = 16 });
        return buffer;
    }

    // Wraps resources in a pass that the shader printer will process.
    private static HlslShaderNode Shader(params HlslResourceNode[] resources)
    {
        HlslShaderNode shader = new HlslShaderNode { Name = "Test/Bindings" };
        HlslSubShaderNode subshader = new HlslSubShaderNode();
        HlslPassNode pass = new HlslPassNode();
        pass.Resources.AddRange(resources);
        subshader.Passes.Add(pass);
        shader.SubShaders.Add(subshader);
        return shader;
    }
}
