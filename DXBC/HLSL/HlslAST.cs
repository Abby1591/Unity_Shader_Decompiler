using System.Text.Json;

namespace Parser.DXBC.Hlsl.Ast;

// Stage 2 — Build HLSL AST.
//
// This is a tree, not text: Shader -> SubShaders -> Pass -> {VertexFunction,
// FragmentFunction, Resources, Structs, States}. Nothing here renders
// itself; the Pretty Printer (Stage 13) is the only thing allowed to turn
// this into source text. Everything below Stage 3 (header) through
// Stage 12 (name recovery) works by populating/mutating this tree, not by
// building strings directly.
//
// HlslFunctionNode.Body is intentionally still IR statements at this
// stage — lowering IRStatement/IRExpression into real
// HlslStatementNode/HlslExpressionNode trees is Stage 10/11's job, not
// Stage 2's. Everything else here (shell, structs, resources, functions
// as named slots) is real Stage 2 structure.

public sealed class HlslShaderNode
{
    public string Name { get; init; } = "";
    public List<HlslPropertyNode> Properties { get; } = new();
    public List<HlslSubShaderNode> SubShaders { get; } = new();
    public string Fallback { get; init; } = "";
    public List<string> Dependencies { get; } = new();
}

// Mirrors Unity's serialized shader property type enum
// (m_Type: Color=0, Vector=1, Float=2, Range=3, Texture=4).
public enum HlslPropertyKind
{
    Color = 0,
    Vector = 1,
    Float = 2,
    Range = 3,
    Texture = 4,
    Unknown = -1,
}

// Mirrors Unity's TextureDimension enum for m_DefTexture.m_TexDim.
// Only meaningful when Kind == Texture.
public enum HlslTextureDimension
{
    Unknown = -1,
    None = 0,
    Tex2D = 1,
    Tex3D = 2,
    Cube = 3,
    Tex2DArray = 4,
    CubeArray = 5,
}

public sealed class HlslPropertyNode
{
    public string Name { get; init; } = "";
    public string? Description { get; init; }

    // Kept for backward compat with earlier callers reading the raw
    // metadata.json numeric type as a string.
    public string? Type { get; init; }

    public HlslPropertyKind Kind { get; init; } = HlslPropertyKind.Unknown;
    public HlslTextureDimension TextureDimension { get; init; } = HlslTextureDimension.Unknown;

    // Raw attribute strings as Unity stored them (e.g. "HDR", "Toggle",
    // "NoScaleOffset") — not re-parsed/validated here, just carried
    // through for Stage 4's printer to emit as [Attr] before the property.
    public List<string> Attributes { get; init; } = new();

    public JsonElement? DefaultValue { get; init; }

    // Only populated for Kind == Range. NOTE: Unity's compiled shader
    // data doesn't carry an explicit min/max pair we've confirmed a field
    // path for yet — left null rather than guessing at which DefValue
    // slot(s) hold it. Fill in once a real Range property sample is
    // available to check against.
    public (float Min, float Max)? Range { get; init; }
}

public sealed class HlslSubShaderNode
{
    public Dictionary<string, string> Tags { get; } = new();
    public int? Lod { get; init; }
    public List<HlslPassNode> Passes { get; } = new();
}

public sealed class HlslPassNode
{
    public string Name { get; init; } = "";
    public Dictionary<string, string> Tags { get; } = new();

    // Raw render-state JSON carried through untouched — Stage 6 is
    // responsible for turning this into Blend/Cull/ZTest/... AST nodes;
    // Stage 2 just makes sure it travels with the right pass.
    public JsonElement RenderStateRaw { get; init; }

    public HlslFunctionNode? VertexFunction { get; set; }
    public HlslFunctionNode? FragmentFunction { get; set; }
    public HlslFunctionNode? GeometryFunction { get; set; }
    public HlslFunctionNode? HullFunction { get; set; }
    public HlslFunctionNode? DomainFunction { get; set; }
    public HlslFunctionNode? ComputeFunction { get; set; }

    public List<HlslResourceNode> Resources { get; } = new();
    public List<HlslStructNode> Structs { get; } = new();

    public IEnumerable<HlslFunctionNode> Functions()
    {
        foreach (var f in new[]
                 {
                     VertexFunction, FragmentFunction, GeometryFunction,
                     HullFunction, DomainFunction, ComputeFunction,
                 })
        {
            if (f is not null)
                yield return f;
        }
    }
}

public enum HlslShaderStage
{
    Vertex,
    Fragment,
    Geometry,
    Hull,
    Domain,
    Compute,
}

public sealed class HlslFunctionNode
{
    public string Name { get; init; } = "";
    public HlslShaderStage Stage { get; init; }

    public HlslStructNode? InputStruct { get; set; }
    public HlslStructNode? OutputStruct { get; set; }

    // Populated verbatim from the IR pipeline's output for this
    // subprogram. Stage 10/11 replaces/augments this with real
    // HlslStatementNode/HlslExpressionNode trees; kept as IRStatement for
    // now so Stage 2 doesn't have to duplicate the entire IR just to have
    // *something* to hang the function body on.
    public List<Parser.DXBC.IR.IRStatement> Body { get; } = new();
}

public enum HlslResourceKind
{
    ConstantBuffer,
    Texture,
    Sampler,
    Uav,
}

public sealed class HlslResourceNode
{
    public string Name { get; init; } = "";
    public HlslResourceKind Kind { get; init; }
    public uint Slot { get; init; }

    // e.g. "Texture2D", "TextureCube", "SamplerState" — filled in where
    // IRDeclaration carries enough info (ResourceDimension); left null
    // otherwise rather than guessing.
    public string? TypeHint { get; init; }
}

public sealed class HlslStructNode
{
    public string Name { get; init; } = "";
    public List<HlslFieldNode> Fields { get; } = new();
}

public sealed class HlslFieldNode
{
    public string Name { get; init; } = "";
    public string Semantic { get; init; } = "";

    // Type recovery for scalar/vector width isn't reliable from a single
    // dcl_input/dcl_output alone (mask tells you component count, not
    // float vs int vs uint) — left as a hint for Stage 8 to firm up, not
    // invented here.
    public string TypeHint { get; init; } = "float4";
}