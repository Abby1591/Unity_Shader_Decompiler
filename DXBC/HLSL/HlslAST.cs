using System.Text.Json;
using Parser.DXBC.Metadata;

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

// Mirrors UnityEngine.Rendering.CullMode.
public enum HlslCullMode { Off = 0, Front = 1, Back = 2 }

// Mirrors UnityEngine.Rendering.CompareFunction — used for both ZTest and
// stencil comparison.
public enum HlslCompareFunction
{
    Disabled = 0, Never = 1, Less = 2, Equal = 3, LessEqual = 4,
    Greater = 5, NotEqual = 6, GreaterEqual = 7, Always = 8,
}

// Mirrors UnityEngine.Rendering.BlendMode.
public enum HlslBlendMode
{
    Zero = 0, One = 1, DstColor = 2, SrcColor = 3, OneMinusDstColor = 4,
    SrcAlpha = 5, OneMinusSrcAlpha = 6, DstAlpha = 7, OneMinusDstAlpha = 8,
    SrcAlphaSaturate = 9, OneMinusSrcColor = 10,
}

// Mirrors UnityEngine.Rendering.BlendOp.
public enum HlslBlendOp { Add = 0, Subtract = 1, ReverseSubtract = 2, Min = 3, Max = 4 }

// Mirrors UnityEngine.Rendering.StencilOp.
public enum HlslStencilOp
{
    Keep = 0, Zero = 1, Replace = 2, IncrementSaturate = 3,
    DecrementSaturate = 4, Invert = 5, IncrementWrap = 6, DecrementWrap = 7,
}

// Unity's compiled m_FogMode: 0 means "not set" in practice (fog block
// wasn't authored), rather than a real mode — everything else matches
// UnityEngine.FogMode.
public enum HlslFogMode { None = 0, Linear = 1, Exp2 = 2, Exp = 3 }

public sealed class HlslBlendState
{
    public HlslBlendMode SrcBlend { get; init; } = HlslBlendMode.One;
    public HlslBlendMode DstBlend { get; init; } = HlslBlendMode.Zero;
    public HlslBlendMode SrcBlendAlpha { get; init; } = HlslBlendMode.One;
    public HlslBlendMode DstBlendAlpha { get; init; } = HlslBlendMode.Zero;
    public HlslBlendOp BlendOp { get; init; } = HlslBlendOp.Add;
    public HlslBlendOp BlendOpAlpha { get; init; } = HlslBlendOp.Add;

    // Raw ColorWriteMask bit flags (Red=8,Green=4,Blue=2,Alpha=1, All=15);
    // null means "not specified" (defaults to All), distinct from 0
    // ("write nothing") which Unity does allow.
    public int? ColorMask { get; init; }
}

public sealed class HlslStencilFaceState
{
    public HlslCompareFunction Comp { get; init; } = HlslCompareFunction.Always;
    public HlslStencilOp Fail { get; init; } = HlslStencilOp.Keep;
    public HlslStencilOp ZFail { get; init; } = HlslStencilOp.Keep;
    public HlslStencilOp Pass { get; init; } = HlslStencilOp.Keep;
}

public sealed class HlslRenderState
{
    public HlslCullMode Cull { get; init; } = HlslCullMode.Back;
    public HlslCompareFunction ZTest { get; init; } = HlslCompareFunction.LessEqual;
    public bool ZWrite { get; init; } = true;
    public bool ZClip { get; init; } = true;
    public bool Lighting { get; init; }
    public HlslFogMode FogMode { get; init; } = HlslFogMode.None;
    public bool AlphaToMask { get; init; }
    public float OffsetFactor { get; init; }
    public float OffsetUnits { get; init; }
    public bool Conservative { get; init; }

    public int StencilRef { get; init; }
    public int StencilReadMask { get; init; } = 255;
    public int StencilWriteMask { get; init; } = 255;
    public HlslStencilFaceState StencilFront { get; init; } = new();
    public HlslStencilFaceState StencilBack { get; init; } = new();

    public bool SeparateBlend { get; init; }
    public HlslBlendState Blend { get; init; } = new();
    // Only meaningful when SeparateBlend is true (MRT blending) — index 0
    // duplicates Blend for the common single-target case.
    public List<HlslBlendState> BlendTargets { get; } = new();
}

public sealed class HlslPassNode
{
    public string Name { get; init; } = "";
    public Dictionary<string, string> Tags { get; } = new();

    // Raw render-state JSON, kept for anything Stage 6's typed parse
    // doesn't cover yet (or as a fallback if parsing throws on an
    // unexpected shape) — State below is what Stage 13 should actually
    // print from.
    public JsonElement RenderStateRaw { get; init; }
    public HlslRenderState State { get; set; } = new();

    public HlslFunctionNode? VertexFunction { get; set; }
    public HlslFunctionNode? FragmentFunction { get; set; }
    public HlslFunctionNode? GeometryFunction { get; set; }
    public HlslFunctionNode? HullFunction { get; set; }
    public HlslFunctionNode? DomainFunction { get; set; }
    public HlslFunctionNode? ComputeFunction { get; set; }

    public List<HlslResourceNode> Resources { get; } = new();
    public List<HlslStructNode> Structs { get; } = new();

    // Cbuffer layout recovered from the ShaderLab metadata (per-pass
    // replacement for the stripped RDEF chunk), keyed by (register slot,
    // stage). Stages bind their own tables, so a slot number alone is
    // ambiguous — UnityPerDraw and $Globals can both occupy b0 in one
    // pass, just in different stages. Stage "" is a buffer shared by all
    // stages. Stage 13 uses it to render cbN[slot] reads as the real
    // variable names instead of opaque cbN_values arrays.
    public Dictionary<(int Slot, string Stage), CbufferMetadata> Cbuffers { get; } = new();

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
    // Canonical per-stage name (Stage 9): vert/frag/geom/hull/domain/comp.
    // No collision risk between passes — each Pass has its own function
    // slots, so every pass's vertex function is just called "vert".
    public string Name { get; init; } = "";

    // Original per-subprogram label (e.g. "program3") this was built
    // from — kept for cross-referencing Program.cs's debug output /
    // program{i}.hlsl / program{i}.dxbc against the AST.
    public string SourceName { get; init; } = "";

    public HlslShaderStage Stage { get; init; }

    public HlslStructNode? InputStruct { get; set; }
    public HlslStructNode? OutputStruct { get; set; }

    // Populated verbatim from the IR pipeline's output for this
    // subprogram — kept for anything that wants the flat original-order
    // list (debug dumps, cross-checking). Statements below (Stage 10) is
    // the real structured tree; prefer that for anything doing actual
    // codegen.
    public List<Parser.DXBC.IR.IRStatement> Body { get; } = new();

    // Stage 10 — If/Loop/Switch/etc as real nested nodes instead of a
    // flat list with begin/end markers you have to track by hand.
    public HlslBlockStatement Statements { get; set; } = new();
}

public enum HlslResourceKind
{
    ConstantBuffer,
    Texture,
    Sampler,
    Uav,
}

public sealed class HlslCBufferVariable
{
    public string Name { get; init; } = "";
    public string TypeName { get; init; } = "float4"; // reconstructed from RDEF's TypeClass/TypeKind/dims
    public uint Offset { get; init; }
    public uint Size { get; init; }

    // When non-null, this variable is a synthesized float4 array (an RDEF-less
    // cbuffer fallback: one element per accessed 16-byte slot, so the cbN[slot]
    // references in the body resolve). The printer emits it as `float4 Name[N];`.
    public int? ArraySize { get; init; }
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

    // Only populated for Kind == ConstantBuffer, from RDEF (the actual
    // member layout Unity's compiler produced) — empty if no RDEF match
    // was found, not an error, just means Stage 7's CBUFFER_START/END
    // body will come out empty for that buffer.
    public List<HlslCBufferVariable> Variables { get; } = new();
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