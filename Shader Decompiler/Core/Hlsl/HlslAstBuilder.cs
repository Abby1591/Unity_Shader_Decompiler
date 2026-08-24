using System.Text.Json;
using AssetStudio;
using Parser.DXBC.Chunks;
using Parser.DXBC.Instructions;
using Parser.DXBC.IR;
using Parser.DXBC.Metadata;

namespace Parser.Core.Hlsl.Ast;

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
            CustomEditor = metadata.CustomEditor,
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
                DefaultComponents = p.DefaultComponents,
                // Range bounds are serialized into the same DefaultValue slot
                // array as {x:default, y:min, z:max} for m_Type==3 — confirmed
                // against PicaVoxel PBR Range(0,1) and Toon "Outline"
                // Range(0.002,0.03) reference sources. Null when the metadata
                // carried no default (then no bounds are known at all).
                Range = kind == HlslPropertyKind.Range && p.DefaultComponents.Length >= 3
                    ? (p.DefaultComponents[1], p.DefaultComponents[2])
                    : null,
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
                    if (cb.Slot >= 0 && !passNode.Cbuffers.ContainsKey((cb.Slot, cb.Stage)))
                        passNode.Cbuffers[(cb.Slot, cb.Stage)] = cb;

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

        if (inputSignature is not null)
            GroupSignatureByRegister(function.InputElementsByRegister, inputSignature.Elements);
        if (outputSignature is not null)
            GroupSignatureByRegister(function.OutputElementsByRegister, outputSignature.Elements);

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

    private static void GroupSignatureByRegister(Dictionary<uint, List<SignatureElement>> byRegister, List<SignatureElement> elements)
    {
        foreach (SignatureElement el in elements)
        {
            if (!byRegister.TryGetValue(el.Register, out List<SignatureElement>? list))
                byRegister[el.Register] = list = new List<SignatureElement>();
            list.Add(el);
        }
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
        Dictionary<(int Slot, string Stage), CbufferMetadata>? cbuffers = null, string stage = "",
        Dictionary<uint, string>? textureNames = null)
    {
        Dictionary<uint, uint> maxCbufferSlot = BuildMaxCbufferSlot(blocks, cbuffers, stage);

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
                    // can still emit real member names. The buffer is
                    // looked up by the current stage first, then the
                    // all-stages fallback — different stages may bind
                    // different buffers to the same slot.
                    if (cbuffers is not null
                        && (cbuffers.TryGetValue(((int)cb.Slot, stage), out CbufferMetadata? meta)
                            || cbuffers.TryGetValue(((int)cb.Slot, ""), out meta))
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
                    string texName = (textureNames is not null && textureNames.TryGetValue(res.Slot, out string? pname))
                        ? pname
                        : res.SymbolicName ?? $"t{res.Slot}";
                    yield return new HlslResourceNode
                    {
                        Name = texName,
                        Kind = HlslResourceKind.Texture,
                        Slot = res.Slot,
                        TypeHint = TextureTypeHint(res.Dimension),
                    };
                    break;

                case IRDeclaration.IRSamplerDeclaration samp:
                    bool isComparison = ComparisonSamplers(blocks).Contains(samp.Slot);
                    // Unity pairs samplers with textures by naming convention:
                    // "sampler_<TextureName>" must match a Texture2D named
                    // "<TextureName>".  Build the mapping from the IR's
                    // Sample() calls to find which texture each sampler serves.
                    string sampName;
                    if (textureNames is not null
                        && SamplerToTextureSlot(blocks, samp.Slot) is uint texSlot
                        && textureNames.TryGetValue(texSlot, out string? pairedTex))
                    {
                        // Unity convention: "sampler_<TextureName>" where
                        // TextureName has no leading underscore — so
                        // Texture2D _MainTex pairs with SamplerState sampler_MainTex.
                        string stripped = pairedTex.StartsWith('_') ? pairedTex[1..] : pairedTex;
                        sampName = $"sampler_{stripped}";
                    }
                    else
                        sampName = samp.SymbolicName ?? SamplerInlineName(samp.Slot, isComparison);
                    yield return new HlslResourceNode
                    {
                        Name = sampName,
                        Kind = HlslResourceKind.Sampler,
                        Slot = samp.Slot,
                        TypeHint = isComparison
                            ? "SamplerComparisonState"
                            : "SamplerState",
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
    //
    // `cbuffers`/`stage` are the ShaderLab-metadata layout for the pass
    // (the substitute for the RDEF Unity strips from shipped bytecode).
    // A read that the metadata resolves to a named member (HlslPrettyPrinter
    // resolves the same way) never touches the synthesized cbN_values array,
    // so it must not count toward the array's size — otherwise the fallback
    // is declared bigger than needed, or declared at all for a slot whose
    // every read resolves (a dead declaration).
    private static Dictionary<uint, uint> BuildMaxCbufferSlot(
        List<IRBlock>? blocks,
        Dictionary<(int Slot, string Stage), CbufferMetadata>? cbuffers,
        string stage)
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
                    {
                        elem = Math.Max(elem, 64);
                    }
                    // Reads the ShaderLab metadata resolves to a named member
                    // (variable name + optional row/component) render as that
                    // identifier, never as cbN_values[slot], so they impose no
                    // requirement on the synthesized fallback array.
                    else if (ResolvesToNamedMember(reg, cbuffers, stage))
                    {
                        continue;
                    }

                    if (!result.TryGetValue(slot, out uint max) || elem > max)
                        result[slot] = elem;
                }
            }
        }

        return result;
    }

    // Does the metadata layout cover this cbuffer read with a named member,
    // so the printer will render it as an identifier instead of cbN_values?
    // Mirrors HlslPrettyPrinter.RenderCbufferRead's metadata path exactly:
    // same per-stage lookup, same ResolveCbufferRead result.
    private static bool ResolvesToNamedMember(
        IRRegister reg,
        Dictionary<(int Slot, string Stage), CbufferMetadata>? cbuffers,
        string stage)
    {
        if (cbuffers is null || !cbuffers.TryGetValue(((int)reg.Indices[0], stage), out CbufferMetadata? meta)
            && !cbuffers.TryGetValue(((int)reg.Indices[0], ""), out meta))
            return false;

        return HlslPrettyPrinter.ResolveCbufferRead(meta, reg) is not null;
    }

    // Sampler slots used by comparison texture operations in the given IR.
    // These must be declared SamplerComparisonState, not SamplerState, or
    // d3dcompiler rejects the SampleCmp/GatherCmp call with X3013.
    private static HashSet<uint> ComparisonSamplers(List<IRBlock>? blocks)
    {
        var result = new HashSet<uint>();
        if (blocks is null)
            return result;
        foreach (IRBlock block in blocks)
        {
            foreach (IRStatement stmt in block.Statements)
            {
                foreach (IRExpression expr in AllExpressions(stmt))
                {
                    if (expr is not IRExpression.TextureOperationExpression tex)
                        continue;
                    if (tex.Operation is not (
                            IRExpression.TextureOperation.SampleCompare
                            or IRExpression.TextureOperation.SampleCompareLevelZero
                            or IRExpression.TextureOperation.GatherCompare))
                        continue;
                    if (tex.Sampler is { } s && s.RegisterType == RegisterType.Sampler)
                        result.Add(s.Index);
                }
            }
        }
        return result;
    }

    // Returns the texture register slot used with a given sampler slot
    // in the first Sample/SampleLevel/SampleBias/SampleGrad/Gather call
    // found in the IR, or null if the sampler is never used.
    private static uint? SamplerToTextureSlot(List<IRBlock>? blocks, uint samplerSlot)
    {
        if (blocks is null) return null;
        foreach (IRBlock block in blocks)
        {
            foreach (IRStatement stmt in block.Statements)
            {
                foreach (IRExpression expr in AllExpressions(stmt))
                {
                    if (expr is not IRExpression.TextureOperationExpression tex)
                        continue;
                    if (tex.Sampler is { RegisterType: RegisterType.Sampler } s && s.Index == samplerSlot
                        && tex.Resource is { RegisterType: RegisterType.Resource } r)
                        return r.Index;
                }
            }
        }
        return null;
    }

    // Returns a Unity-recognised inline sampler name for the given slot.
    // Unity's HLSL compiler rejects bare "SamplerState s0" — the name must
    // contain filter + wrap modes (e.g. "sampler_linear_clamp").
    // We use a base name that is always valid HLSL; the slot number is
    // appended only when needed for uniqueness.
    private static string SamplerInlineName(uint slot, bool comparison)
    {
        if (comparison)
            return slot == 0 ? "sampler_comparison_linear_clamp" : $"sampler_comparison_linear_clamp{slot}";
        return slot == 0 ? "sampler_linear_clamp" : $"sampler_linear_clamp{slot}";
    }

    // Depth-first walk of every sub-expression in a statement (mirrors
    // IRExpressionRewriter's traversal so new node types stay in sync).
    private static IEnumerable<IRExpression> AllExpressions(IRStatement stmt)
    {
        switch (stmt)
        {
            case IRStatement.IRAssignment ins:
                foreach (IRExpression sub in AllExpressions(ins.Expression))
                    yield return sub;
                break;
            case IRStatement.IRIf ifs:
                foreach (IRExpression sub in AllExpressions(ifs.Condition))
                    yield return sub;
                break;
            case IRStatement.IRBreak br: foreach (IRExpression sub in AllExpressions(br.Condition)) yield return sub; break;
            case IRStatement.IRContinue cont: foreach (IRExpression sub in AllExpressions(cont.Condition)) yield return sub; break;
            case IRStatement.IRReturn ret: foreach (IRExpression sub in AllExpressions(ret.Condition)) yield return sub; break;
            case IRStatement.IRSwitch sw: foreach (IRExpression sub in AllExpressions(sw.Selector)) yield return sub; break;
            case IRStatement.IRCase cs: foreach (IRExpression sub in AllExpressions(cs.Value)) yield return sub; break;
            case IRStatement.IRDiscard disc: foreach (IRExpression sub in AllExpressions(disc.Condition)) yield return sub; break;
            case IRStatement.IRCall call: foreach (IRExpression sub in AllExpressions(call.Condition)) yield return sub; break;
            case IRStatement.IRMemoryStore store:
                foreach (IRExpression sub in AllExpressions(store.Address)) yield return sub;
                foreach (IRExpression sub in AllExpressions(store.Value)) yield return sub;
                break;
            case IRStatement.IRMultiAssignment multi:
                foreach (IRExpression e in multi.Expressions)
                    foreach (IRExpression sub in AllExpressions(e))
                        yield return sub;
                break;
            case IRStatement.IRAtomicOp at:
                foreach (IRExpression sub in AllExpressions(at.Address)) yield return sub;
                foreach (IRExpression sub in AllExpressions(at.Value)) yield return sub;
                foreach (IRExpression sub in AllExpressions(at.CompareValue)) yield return sub;
                break;
            case IRStatement.IRInterfaceCall ic: foreach (IRExpression sub in AllExpressions(ic.Condition)) yield return sub; break;
            case IRStatement.IRPhi: yield break;
            default:
                yield break;
        }
    }

    private static IEnumerable<IRExpression> AllExpressions(IRExpression? expr)
    {
        if (expr is null)
            yield break;
        yield return expr;
        switch (expr)
        {
            case IRExpression.BinaryExpression be:
                foreach (IRExpression sub in AllExpressions(be.Left)) yield return sub;
                foreach (IRExpression sub in AllExpressions(be.Right)) yield return sub;
                break;
            case IRExpression.UnaryExpression ue:
                foreach (IRExpression sub in AllExpressions(ue.Operand)) yield return sub;
                break;
            case IRExpression.IntrinsicExpression ie:
                foreach (IRExpression arg in ie.Arguments)
                    foreach (IRExpression sub in AllExpressions(arg))
                        yield return sub;
                break;
            case IRExpression.FusedMultiplyAddExpression fma:
                foreach (IRExpression sub in AllExpressions(fma.A)) yield return sub;
                foreach (IRExpression sub in AllExpressions(fma.B)) yield return sub;
                foreach (IRExpression sub in AllExpressions(fma.C)) yield return sub;
                break;
            case IRExpression.MultiplyHighExpression mh:
                foreach (IRExpression sub in AllExpressions(mh.Left)) yield return sub;
                foreach (IRExpression sub in AllExpressions(mh.Right)) yield return sub;
                break;
            case IRExpression.Multiply64Expression m64:
                foreach (IRExpression sub in AllExpressions(m64.Left)) yield return sub;
                foreach (IRExpression sub in AllExpressions(m64.Right)) yield return sub;
                break;
            case IRExpression.BitFieldInsertExpression bfi:
                foreach (IRExpression sub in AllExpressions(bfi.Width)) yield return sub;
                foreach (IRExpression sub in AllExpressions(bfi.Offset)) yield return sub;
                foreach (IRExpression sub in AllExpressions(bfi.Insert)) yield return sub;
                foreach (IRExpression sub in AllExpressions(bfi.Base)) yield return sub;
                break;
            case IRExpression.BitFieldExtractExpression bfe:
                foreach (IRExpression sub in AllExpressions(bfe.Width)) yield return sub;
                foreach (IRExpression sub in AllExpressions(bfe.Offset)) yield return sub;
                foreach (IRExpression sub in AllExpressions(bfe.Value)) yield return sub;
                break;
            case IRExpression.ConditionalExpression ce:
                foreach (IRExpression sub in AllExpressions(ce.Condition)) yield return sub;
                foreach (IRExpression sub in AllExpressions(ce.TrueExpression)) yield return sub;
                foreach (IRExpression sub in AllExpressions(ce.FalseExpression)) yield return sub;
                break;
            case IRExpression.DotProductExpression dp:
                foreach (IRExpression sub in AllExpressions(dp.Left)) yield return sub;
                foreach (IRExpression sub in AllExpressions(dp.Right)) yield return sub;
                break;
            case IRExpression.SwizzleExpression sw:
                foreach (IRExpression sub in AllExpressions(sw.Value)) yield return sub;
                break;
            case IRExpression.MatrixVectorMultiplyExpression mv:
                foreach (IRExpression sub in AllExpressions(mv.Vector)) yield return sub;
                break;
            case IRExpression.TextureOperationExpression tex:
                foreach (IRExpression sub in AllExpressions(tex.Coordinates)) yield return sub;
                foreach (IRExpression sub in AllExpressions(tex.Offset)) yield return sub;
                foreach (IRExpression sub in AllExpressions(tex.LOD)) yield return sub;
                foreach (IRExpression sub in AllExpressions(tex.Bias)) yield return sub;
                foreach (IRExpression sub in AllExpressions(tex.CompareValue)) yield return sub;
                foreach (IRExpression sub in AllExpressions(tex.GradX)) yield return sub;
                foreach (IRExpression sub in AllExpressions(tex.GradY)) yield return sub;
                foreach (IRExpression sub in AllExpressions(tex.SampleIndex)) yield return sub;
                break;
        }
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

    // Semantic to field-identifier, in the idiom Unity's own generated HLSL
    // uses: "SV_x" keeps its "sv_" prefix in camelCase (SV_Position -> sv_Position,
    // SV_Target0 -> sv_Target0), every other semantic is lowercased
    // (COLOR0 -> color0, TEXCOORD0 -> texcoord0). The printer's read side must
    // use the exact same function or the struct field declarations won't resolve.
    internal static string ToFieldName(string semantic)
    {
        if (semantic.StartsWith("SV_"))
        {
            if (semantic.Length <= 3) return "sv_";
            return "sv_" + char.ToUpperInvariant(semantic[3]) + semantic[4..].ToLowerInvariant();
        }
        return semantic.ToLowerInvariant();
    }

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