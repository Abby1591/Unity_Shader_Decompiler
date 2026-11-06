using System.Text.Json;
using AssetStudio;
using UnityShaderDecompiler.Core.DXBC.Chunks;
using UnityShaderDecompiler.Core.DXBC.Instructions;
using UnityShaderDecompiler.Core.DXBC.IR;
using UnityShaderDecompiler.Core.DXBC.Metadata;

namespace UnityShaderDecompiler.Core.Hlsl.Ast;

// Resource declarations: cbuffer/constant-buffer binding, sampler and
// texture naming, and the IR walks used to recover them when reflection
// metadata has been stripped.
public static partial class HlslAstBuilder
{
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
}
