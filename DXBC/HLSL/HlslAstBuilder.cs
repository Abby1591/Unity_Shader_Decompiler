using System.Text.Json;
using AssetStudio;
using Parser.DXBC.Chunks;
using Parser.DXBC.IR;
using Parser.DXBC.Metadata;

namespace Parser.DXBC.Hlsl.Ast;

// Stage 2 — Build HLSL AST.
//
// Two entry points, deliberately separate:
//
//   BuildShell(metadata)        -> the whole Shader/SubShader/Pass tree,
//                                   straight from metadata.json. No DXBC
//                                   involved yet.
//
//   BuildFunction(name, type, declarations, blocks)
//                                -> one VertexFunction/FragmentFunction/...
//                                   node, from one subprogram's IR. Caller
//                                   (Program.cs) attaches it to the right
//                                   HlslPassNode slot.
//
// Splitting it this way matches how Program.cs already has to work: the
// metadata for the whole shader is available up front, but each
// subprogram's IR only exists one DXBC blob at a time inside the main
// loop.
public static class HlslAstBuilder
{
    public static HlslShaderNode BuildShell(ShaderMetadata metadata)
    {
        var shader = new HlslShaderNode
        {
            Name = metadata.Name,
            Fallback = metadata.Fallback,
        };
        shader.Dependencies.AddRange(metadata.Dependencies);

        foreach (ShaderProperty p in metadata.Properties)
        {
            HlslPropertyKind kind = ParsePropertyKind(p.Type);
            HlslTextureDimension texDim = HlslTextureDimension.Unknown;

            if (kind == HlslPropertyKind.Texture && p.DefaultTexture is { } dt
                && dt.TryGetProperty("dimension", out var dimEl)
                && dimEl.ValueKind == JsonValueKind.Number)
            {
                int dim = dimEl.GetInt32();
                texDim = System.Enum.IsDefined(typeof(HlslTextureDimension), dim)
                    ? (HlslTextureDimension)dim
                    : HlslTextureDimension.Unknown;
            }

            shader.Properties.Add(new HlslPropertyNode
            {
                Name = p.Name,
                Description = p.Description,
                Type = p.Type,
                Kind = kind,
                TextureDimension = texDim,
                Attributes = p.Attributes,
                DefaultValue = p.DefaultValue,
                // Range min/max: see HlslPropertyNode.Range doc comment —
                // not populated until the field path is confirmed.
            });
        }

        foreach (SubShaderMetadata ss in metadata.SubShaders)
        {
            var subShaderNode = new HlslSubShaderNode { Lod = ss.Lod };
            foreach (var (k, v) in ss.Tags)
                subShaderNode.Tags[k] = v;

            foreach (PassMetadata pass in ss.Passes)
            {
                var passNode = new HlslPassNode
                {
                    Name = pass.Name,
                    RenderStateRaw = pass.RenderState,
                    State = HlslRenderStateBuilder.Build(pass.RenderState),
                };
                foreach (var (k, v) in pass.Tags)
                    passNode.Tags[k] = v;

                foreach (CbufferMetadata cb in pass.ConstantBuffers)
                    if (cb.Slot >= 0 && !passNode.Cbuffers.ContainsKey(cb.Slot))
                        passNode.Cbuffers[cb.Slot] = cb;

                subShaderNode.Passes.Add(passNode);
            }

            shader.SubShaders.Add(subShaderNode);
        }

        return shader;
    }

    public static HlslFunctionNode? BuildFunction(
        string sourceName,
        ShaderGpuProgramType programType,
        List<IRDeclaration> declarations,
        List<IRBlock> blocks,
        IsgnChunk? inputSignature = null,
        OsgnChunk? outputSignature = null)
    {
        HlslShaderStage? stage = StageFromProgramType(programType);
        if (stage is null)
            return null;

        var function = new HlslFunctionNode
        {
            Name = CanonicalFunctionName(stage.Value),
            SourceName = sourceName,
            Stage = stage.Value,
        };

        // Stage 8: prefer ISGN/OSGN — they carry the actual component
        // type (float/int/uint) and component count (popcount of Mask)
        // Unity's compiler produced, not just a semantic name. Falls
        // back to the Stage 2 declaration-only reconstruction (always
        // float4) only if a signature chunk wasn't parsed.
        function.InputStruct = inputSignature is not null
            ? BuildStructFromSignature($"{sourceName}Input", inputSignature.Elements)
            : BuildStruct($"{sourceName}Input", declarations
                .OfType<IRDeclaration.IRInputDeclaration>()
                .Select(d => (Register: d.Register, d.SymbolicName)));

        function.OutputStruct = outputSignature is not null
            ? BuildStructFromSignature($"{sourceName}Output", outputSignature.Elements)
            : BuildStruct($"{sourceName}Output", declarations
                .OfType<IRDeclaration.IROutputDeclaration>()
                .Select(d => (Register: d.Register, d.SymbolicName)));

        foreach (IRBlock block in blocks)
            function.Body.AddRange(block.Statements);

        // Stage 10 — build the structured tree from the same flat,
        // original-order list just assembled above (IRBlockBuilder never
        // reorders statements, so this is equivalent to parsing
        // pipelineResult.Program.Statements directly).
        function.Statements = HlslStatementBuilder.Build(function.Body);
        HlslNameRecovery.Apply(function.Statements);

        return function;
    }

    private static string CanonicalFunctionName(HlslShaderStage stage) => stage switch
    {
        HlslShaderStage.Vertex => "vert",
        HlslShaderStage.Fragment => "frag",
        HlslShaderStage.Geometry => "geom",
        HlslShaderStage.Hull => "hull",
        HlslShaderStage.Domain => "domain",
        HlslShaderStage.Compute => "comp",
        _ => "main",
    };

    private static HlslStructNode BuildStructFromSignature(string name, List<SignatureElement> elements)
    {
        var s = new HlslStructNode { Name = name };

        foreach (SignatureElement el in elements)
        {
            string semantic = $"{el.SemanticName}{el.SemanticIndex}";
            s.Fields.Add(new HlslFieldNode
            {
                Name = ToFieldName(semantic),
                Semantic = semantic,
                TypeHint = TypeFromSignatureElement(el),
            });
        }

        return s;
    }

    // Component count from Mask (bitmask of which of .xyzw are actually
    // used, not necessarily contiguous from x — e.g. 0x0D is xzw) plus
    // the real base type ISGN/OSGN recorded, instead of assuming float4
    // for everything.
    private static string TypeFromSignatureElement(SignatureElement el)
    {
        int count = System.Numerics.BitOperations.PopCount(el.Mask);
        if (count == 0) count = 1;

        string baseName = el.ComponentTypeName == "unknown" ? "float" : el.ComponentTypeName;
        return count == 1 ? baseName : $"{baseName}{count}";
    }

    // Resources (cbuffers/textures/samplers/UAVs) are pass-scoped in
    // ShaderLab, not function-scoped, even though DXBC declares them once
    // per subprogram — caller merges these into HlslPassNode.Resources
    // per-pass, deduping by (Kind, Slot, Name).
    //
    // `rdef` (Stage 7) is optional: when given, ConstantBuffer resources
    // get their actual member list populated by name match against
    // RdefChunk.ConstantBuffers — IRMetadataBinding (Stage 1) already
    // guarantees a declaration's SymbolicName equals the RDEF cbuffer
    // name it was bound from, so this is a plain lookup, not a guess.
    //
    // `blocks` is used only when a ConstantBuffer has no RDEF match
    // (Unity strips reflection from shipped bytecode). Without member
    // names/types, the body's cbN[slot] references can't resolve to real
    // fields, so we synthesize one float4 per accessed 16-byte slot —
    // D3D packs cbuffers on 16-byte register boundaries, so every
    // cbN[slot] reference maps to element `slot` of that array and the
    // output compiles.
    public static IEnumerable<HlslResourceNode> BuildResources(
        List<IRDeclaration> declarations, RdefChunk? rdef = null, List<IRBlock>? blocks = null,
        Dictionary<int, CbufferMetadata>? cbuffers = null)
    {
        Dictionary<uint, uint> maxCbufferSlot = BuildMaxCbufferSlot(blocks);

        foreach (IRDeclaration decl in declarations)
        {
            switch (decl)
            {
                case IRDeclaration.IRConstantBufferDeclaration cb:
                    RdefConstantBuffer? rdefMatch = rdef?.ConstantBuffers
                        .FirstOrDefault(r => r.Name == cb.SymbolicName);

                    if (rdefMatch is not null)
                    {
                        var rdNode = new HlslResourceNode
                        {
                            Name = cb.SymbolicName ?? $"cb{cb.Slot}",
                            Kind = HlslResourceKind.ConstantBuffer,
                            Slot = cb.Slot,
                        };
                        foreach (RdefVariable v in rdefMatch.Variables)
                        {
                            rdNode.Variables.Add(new HlslCBufferVariable
                            {
                                Name = v.Name,
                                TypeName = v.TypeName,
                                Offset = v.Offset,
                                Size = v.Size,
                            });
                        }
                        yield return rdNode;
                        break;
                    }

                    // Unity strips RDEF from shipped bytecode, but the
                    // ShaderLab metadata carries the same layout (per-slot
                    // buffer name + per-variable byte offset/type), so we
                    // can still emit real member names.
                    if (cbuffers is not null
                        && cbuffers.TryGetValue((int)cb.Slot, out CbufferMetadata? meta)
                        && meta.Variables.Count > 0)
                    {
                        var metaNode = new HlslResourceNode
                        {
                            Name = SanitizeIdentifier(meta.Name),
                            Kind = HlslResourceKind.ConstantBuffer,
                            Slot = cb.Slot,
                        };
                        foreach (CbufferVariableMetadata v in meta.Variables)
                            metaNode.Variables.Add(MakeCbufferVariable(v));
                        AddCbufferFallback(metaNode, cb.Slot, maxCbufferSlot);
                        yield return metaNode;
                        break;
                    }

                    var cbNode = new HlslResourceNode
                    {
                        Name = cb.SymbolicName ?? $"cb{cb.Slot}",
                        Kind = HlslResourceKind.ConstantBuffer,
                        Slot = cb.Slot,
                    };
                    AddCbufferFallback(cbNode, cb.Slot, maxCbufferSlot);
                    yield return cbNode;
                    break;

                case IRDeclaration.IRResourceDeclaration res:
                    yield return new HlslResourceNode
                    {
                        Name = res.SymbolicName ?? $"t{res.Slot}",
                        Kind = HlslResourceKind.Texture,
                        Slot = res.Slot,
                        TypeHint = TextureTypeHint(res.Dimension),
                    };
                    break;

                case IRDeclaration.IRSamplerDeclaration samp:
                    yield return new HlslResourceNode
                    {
                        Name = samp.SymbolicName ?? $"s{samp.Slot}",
                        Kind = HlslResourceKind.Sampler,
                        Slot = samp.Slot,
                        TypeHint = "SamplerState",
                    };
                    break;

                case IRDeclaration.IRUAVDeclaration uav:
                    yield return new HlslResourceNode
                    {
                        Name = uav.SymbolicName ?? $"u{uav.Slot}",
                        Kind = HlslResourceKind.Uav,
                        Slot = uav.Slot,
                        TypeHint = TextureTypeHint(uav.Dimension, uav: true),
                    };
                    break;
            }
        }
    }

    // Scans the subprogram's IR for cbuffer reads like cb2[10].yyyy and
    // returns, per cbuffer slot, the highest register index (element) used.
    // Used to size the synthesized float4 array for RDEF-less cbuffers.
    private static Dictionary<uint, uint> BuildMaxCbufferSlot(List<IRBlock>? blocks)
    {
        var result = new Dictionary<uint, uint>();

        if (blocks is null)
            return result;

        foreach (IRBlock block in blocks)
        {
            foreach (IRStatement stmt in block.Statements)
            {
                foreach (IRRegister reg in stmt.Uses.Concat(stmt.Defines))
                {
                    if (reg.RegisterType != RegisterType.ConstantBuffer || reg.Indices.Count < 2)
                        continue;

                    uint slot = reg.Indices[0];
                    uint elem = reg.Indices[1];

                    // Dynamic reads (cb0[r2.x + 4]) can touch any element up
                    // to the real cbuffer size, which RDEF-less bytecode
                    // doesn't tell us — reserve a generous range for them.
                    if (reg.RelativeIndices.Length > 1 && reg.RelativeIndices[1] is not null)
                        elem = Math.Max(elem, 64);

                    if (!result.TryGetValue(slot, out uint max) || elem > max)
                        result[slot] = elem;
                }
            }
        }

        return result;
    }

    // Converts a ShaderLab-metadata variable into an HLSL cbuffer member.
    private static HlslCBufferVariable MakeCbufferVariable(CbufferVariableMetadata v) => new()
    {
        Name = v.Name,
        TypeName = v.TypeName,
        Offset = (uint)v.Offset,
        Size = (uint)v.SizeBytes,
        ArraySize = v.ArraySize > 0 ? v.ArraySize : null,
    };

    // Unity's internal cbuffer name for the per-material block is
    // "$Globals" — not a legal HLSL identifier. Map to _Globals.
    private static string SanitizeIdentifier(string name)
    {
        if (string.IsNullOrEmpty(name))
            return name;

        char[] chars = name.Select(c => char.IsLetterOrDigit(c) || c == '_' ? c : '_').ToArray();
        if (char.IsDigit(chars[0]))
            chars[0] = '_';
        return new string(chars);
    }

    // Safety net: Unity's per-buffer layout is "partial" (some members are
    // omitted), so a few reads may not resolve to a named variable. Keep a
    // synthesized float4 array covering every accessed slot so those reads
    // still compile as cbN_values[slot].
    private static void AddCbufferFallback(HlslResourceNode node, uint slot, Dictionary<uint, uint> maxCbufferSlot)
    {
        if (!maxCbufferSlot.TryGetValue(slot, out uint maxSlot))
            return;

        node.Variables.Add(new HlslCBufferVariable
        {
            Name = $"cb{slot}_values",
            TypeName = "float4",
            Offset = 0,
            Size = (maxSlot + 1) * 16,
            ArraySize = (int)(maxSlot + 1),
        });
    }

    private static HlslStructNode BuildStruct(string name, IEnumerable<(uint Register, string? SymbolicName)> entries)
    {
        var s = new HlslStructNode { Name = name };

        foreach (var (register, symbolicName) in entries)
        {
            // SymbolicName is "SEMANTIC+INDEX" (e.g. "POSITION0") when
            // IRMetadataBinding has run; falls back to a placeholder that
            // at least round-trips the register number if it hasn't.
            string semantic = symbolicName ?? $"TEXCOORD{register}";

            s.Fields.Add(new HlslFieldNode
            {
                Name = symbolicName is null ? $"v{register}" : ToFieldName(symbolicName),
                Semantic = semantic,
            });
        }

        return s;
    }

    // "POSITION0" -> "position0"-ish isn't useful; strip a trailing
    // "0" index only when it's the sole occurrence of that semantic is
    // deferred to Stage 12 (name recovery) — for now just lowercase the
    // first letter so it reads as a field name rather than a semantic.
    private static string ToFieldName(string semantic)
        => char.ToLowerInvariant(semantic[0]) + semantic[1..];

    private static string? TextureTypeHint(ResourceDimension dimension, bool uav = false)
    {
        string prefix = uav ? "RW" : "";
        return dimension switch
        {
            ResourceDimension.Texture1D => $"{prefix}Texture1D",
            ResourceDimension.Texture2D => $"{prefix}Texture2D",
            ResourceDimension.Texture2DMS => $"{prefix}Texture2DMS",
            ResourceDimension.Texture3D => $"{prefix}Texture3D",
            ResourceDimension.TextureCube => $"{prefix}TextureCube",
            ResourceDimension.Texture1DArray => $"{prefix}Texture1DArray",
            ResourceDimension.Texture2DArray => $"{prefix}Texture2DArray",
            ResourceDimension.Texture2DMSArray => $"{prefix}Texture2DMSArray",
            ResourceDimension.TextureCubeArray => $"{prefix}TextureCubeArray",
            ResourceDimension.Buffer => $"{prefix}Buffer",
            ResourceDimension.RawBuffer => $"{prefix}ByteAddressBuffer",
            ResourceDimension.StructuredBuffer => $"{prefix}StructuredBuffer",
            _ => null,
        };
    }

    private static HlslPropertyKind ParsePropertyKind(string? typeRaw)
    {
        if (typeRaw is not null && int.TryParse(typeRaw, out int type)
            && System.Enum.IsDefined(typeof(HlslPropertyKind), type))
        {
            return (HlslPropertyKind)type;
        }
        return HlslPropertyKind.Unknown;
    }

    private static HlslShaderStage? StageFromProgramType(ShaderGpuProgramType type) => type switch
    {
        ShaderGpuProgramType.DX11VertexSM40 or ShaderGpuProgramType.DX11VertexSM50
            => HlslShaderStage.Vertex,
        ShaderGpuProgramType.DX11PixelSM40 or ShaderGpuProgramType.DX11PixelSM50
            => HlslShaderStage.Fragment,
        ShaderGpuProgramType.DX11GeometrySM40 or ShaderGpuProgramType.DX11GeometrySM50
            => HlslShaderStage.Geometry,
        ShaderGpuProgramType.DX11HullSM50
            => HlslShaderStage.Hull,
        ShaderGpuProgramType.DX11DomainSM50
            => HlslShaderStage.Domain,
        _ => null, // not a DX11 DXBC-bearing stage (GL/Metal/SPIR-V/console/etc.) — nothing for this AST to build
    };
}