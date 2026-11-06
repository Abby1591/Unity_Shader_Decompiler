using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using AssetStudio;
using UnityShaderDecompiler.Core.Hlsl.Ast;
using UnityShaderDecompiler.Core.DXBC;
using UnityShaderDecompiler.Core.DXBC.Chunks;
using UnityShaderDecompiler.Core.DXBC.Extraction;
using UnityShaderDecompiler.Core.DXBC.IR;
using UnityShaderDecompiler.Core.DXBC.Metadata;

namespace UnityShaderDecompiler.Core;

// Stage 2b variant pairing: recover pass boundaries from the serialized
// stage sequence, match vertex/fragment variants by interpolator signature,
// and clone the metadata shell pass for every additional pair.
public static partial class Decompiler
{
    // Signature identity for variant pairing. The vertex/fragment hand-off is
    // the rasterized interpolator set, so the key is the exact ordered element
    // sequence of the signature chunk: semantic name, index, system value and
    // register. Component counts are deliberately excluded — a vertex writes
    // every lane of an interpolator (OSGN mask) while the fragment reads only
    // the lanes it uses (ISGN mask), so the two can legitimately differ for
    // the same variant. Register numbers must match too — the rasterizer
    // interpolates by register, so two programs with the same semantics in
    // different registers do not link.
    internal static string InterfaceKey(List<SignatureElement>? elements) =>
        elements is null
            ? ""
            : string.Join(";", elements.Select(e =>
                $"{e.SemanticName}:{e.SemanticIndex}:{e.SystemValue}:r{e.Register}"));

    internal static string InterfaceInterpKey(List<SignatureElement>? elements) =>
        elements is null
            ? ""
            : string.Join(";", elements
                .Where(e => e.SystemValue == 0)
                .Select(e => $"{e.SemanticName}:{e.SemanticIndex}:{e.SystemValue}:r{e.Register}"));

    // Stage rank in Unity's per-pass serialization order. A new pass begins
    // when the stage rank regresses in the serialized subprogram sequence.
    private static int StageRank(HlslShaderStage s) => s switch
    {
        HlslShaderStage.Vertex => 0,
        HlslShaderStage.Hull => 1,
        HlslShaderStage.Domain => 2,
        HlslShaderStage.Geometry => 3,
        HlslShaderStage.Fragment => 4,
        HlslShaderStage.Compute => 5,
        _ => 9,
    };

    // Stage 2b — the reverse of Unity's subprogram serialization. The blob
    // stores, per pass, all vertex variants, then all fragment variants
    // (GLES first, DX11 after within each stage block). The pass a
    // subprogram belongs to is recoverable from the stage sequence alone:
    // a stage regression (fragment -> vertex) starts the next pass. Within
    // a pass group, a vertex variant pairs with the fragment variant whose
    // input signature equals its output signature; byte-identical pairs are
    // deduplicated (multiple keyword sets can compile to the same program).
    // The first pair of each group fills the metadata shell pass (keeping
    // the pre-existing output for pass 0); every further pair becomes a
    // cloned pass with the same tags/render state right after the shell.
    private static void BuildVariantPasses(
        HlslShaderNode astShader,
        List<HlslPassNode> allPasses,
        List<DecompiledSubprogram> candidates,
        TextWriter log)
    {
        if (candidates.Count == 0)
            return;

        // Build texture property name mapping: texture properties (type=4) in
        // declaration order map to t-register slots (0, 1, 2, ...). This lets
        // the decompiler emit "Texture2D _MainTex : register(t0)" instead of
        // "Texture2D t0 : register(t0)" — Unity needs variable names matching
        // the Properties block to bind textures at runtime.
        var textureNames = new Dictionary<uint, string>();
        uint texSlot = 0;
        foreach (HlslPropertyNode prop in astShader.Properties)
            if (prop.Kind == HlslPropertyKind.Texture)
                textureNames[texSlot++] = prop.Name;

        foreach (DecompiledSubprogram c in candidates)
            c.Hash = Convert.ToHexString(SHA256.HashData(c.DxbcBytes));

        var groups = new List<List<DecompiledSubprogram>>();
        foreach (DecompiledSubprogram c in candidates)
        {
            if (groups.Count == 0)
            {
                groups.Add(new List<DecompiledSubprogram> { c });
                continue;
            }
            if (StageRank(c.Stage) < StageRank(groups[^1][^1].Stage))
                groups.Add(new List<DecompiledSubprogram> { c });
            else
                groups[^1].Add(c);
        }

        var subshaderByPass = new Dictionary<HlslPassNode, HlslSubShaderNode>();
        foreach (HlslSubShaderNode ss in astShader.SubShaders)
            foreach (HlslPassNode p in ss.Passes)
                subshaderByPass[p] = ss;

        int totalPasses = 0;

        for (int gi = 0; gi < groups.Count; gi++)
        {
            List<DecompiledSubprogram> group = groups[gi];
            HlslPassNode shell = gi < allPasses.Count
                ? allPasses[gi]
                : allPasses[^1]; // more groups than metadata passes: reuse the last shell

            var verts = group.Where(c => c.Stage == HlslShaderStage.Vertex).ToList();
            var frags = group.Where(c => c.Stage == HlslShaderStage.Fragment).ToList();
            var others = group.Where(c => c.Stage is not (HlslShaderStage.Vertex or HlslShaderStage.Fragment)).ToList();

            // Pair by interpolator hand-off. The vertex and fragment must agree
            // on the interpolated set (the rasterized hand-off); the fragment
            // may additionally consume rasterizer-generated system values
            // (SV_IsFrontFace, ...) the vertex never writes, so the vertex
            // output is also required to be a subset of the fragment input.
            // Pairing is 1:1 — each vertex takes the first unused fragment it
            // links with (both are in serialized keyword-set order, so this
            // recovers Unity's original variant passes) and a fragment is
            // never reused. Byte-identical pairs therefore collapse and
            // genuinely unmatched variants are reported as folded.
            var pairs = new List<(DecompiledSubprogram V, DecompiledSubprogram F)>();
            var usedFrags = new HashSet<DecompiledSubprogram>();
            var seen = new HashSet<(string, string)>();
            foreach (DecompiledSubprogram v in verts)
            {
                string[] vertOut = v.OutputSignature.Split(';', StringSplitOptions.RemoveEmptyEntries);
                if (vertOut.Length == 0)
                    continue; // a vertex always writes interpolators; don't match an empty output
                foreach (DecompiledSubprogram f in frags)
                {
                    if (usedFrags.Contains(f))
                        continue;
                    if (v.OutputInterpolators == f.InputInterpolators
                        && vertOut.All(f.InputSignature.Split(';', StringSplitOptions.RemoveEmptyEntries).Contains)
                        && seen.Add((v.Hash, f.Hash)))
                    {
                        pairs.Add((v, f));
                        usedFrags.Add(f);
                        break;
                    }
                }
            }

            // First pair fills the shell pass; the rest get clones.
            for (int pi = 0; pi < pairs.Count; pi++)
            {
                var (v, f) = pairs[pi];
                HlslPassNode pass = pi == 0 ? shell : ClonePass(shell);
                if (!ReferenceEquals(pass, shell))
                {
                    HlslSubShaderNode ss = subshaderByPass[shell];
                    int insertAt = ss.Passes.IndexOf(shell) + 1;
                    ss.Passes.Insert(insertAt, pass);
                    subshaderByPass[pass] = ss;
                }

                AttachPassProgram(pass, v, textureNames, log);
                AttachPassProgram(pass, f, textureNames, log);
                totalPasses++;
            }

            // Stage functions that pair by position, not signature
            // (geometry/hull/domain/compute), attach to the shell pass.
            foreach (DecompiledSubprogram o in others)
            {
                AttachPassProgram(shell, o, textureNames, log);
                totalPasses++;
            }

            if (pairs.Count == 0 && others.Count == 0)
            {
                log.WriteLine($"  Pass group {gi}: {verts.Count} verts x {frags.Count} frags produced no renderable variant (skipped).");
            }
            else
            {
                int unpaired = verts.Count(v => !pairs.Any(p => ReferenceEquals(p.V, v)))
                             + frags.Count(f => !pairs.Any(p => ReferenceEquals(p.F, f)));
                log.WriteLine(
                    $"  Pass group {gi}: {verts.Count} verts x {frags.Count} frags => {pairs.Count} distinct variant pass(es) " +
                    $"({unpaired} unpaired duplicate(s) folded)");
            }
        }

        log.WriteLine($"BuildVariantPasses: {groups.Count} pass group(s), {totalPasses} pass(es) emitted total.");
    }

    // Attaches one candidate's function, resources and structs to a pass,
    // unioning cbuffer members the way the previous streaming loop did.
    private static void AttachPassProgram(
        HlslPassNode pass,
        DecompiledSubprogram c,
        Dictionary<uint, string>? textureNames,
        TextWriter log)
    {
        AttachFunction(pass, c.Function);

        var resources = HlslAstBuilder.BuildResources(
            c.Pipeline.Program.Declarations,
            c.Dxbc.ResourceDefinition,
            c.Pipeline.Blocks,
            pass.Cbuffers,
            c.Stage.ToString(),
            textureNames).ToList();

        foreach (HlslResourceNode res in resources)
        {
            // Cbuffers merge by slot: vert and frag subprograms of the same
            // pass touch the same constant-buffer slots, so union the
            // members (keeping the largest array size for any fallback).
            HlslResourceNode? existing = pass.Resources.FirstOrDefault(r =>
                r.Kind == res.Kind && (res.Kind == HlslResourceKind.ConstantBuffer
                    ? r.Slot == res.Slot
                    : r.Slot == res.Slot || r.Name == res.Name));

            if (existing is null)
            {
                // Sampler name collision: two different sampler slots may both
                // map to the same texture property (e.g. s0 and s2 both serve
                // _MainTex). Append the slot index to make the name unique.
                if (res.Kind == HlslResourceKind.Sampler
                    && pass.Resources.Any(r => r.Kind == HlslResourceKind.Sampler && r.Name == res.Name))
                {
                    res.Name = $"{res.Name}{res.Slot}";
                }
                pass.Resources.Add(res);
            }
            else if (res.Kind == HlslResourceKind.ConstantBuffer)
            {
                // vert/frag subprograms of one pass can touch different
                // slots of the same cbuffer, and each BuildResources call
                // only sees its own blocks. Union the members, keeping the
                // largest array size so the RDEF-less float4 fallback
                // covers every subprogram's accesses.
                foreach (HlslCBufferVariable v in res.Variables)
                {
                    HlslCBufferVariable? match = existing.Variables.FirstOrDefault(x => x.Name == v.Name);
                    if (match is null)
                    {
                        existing.Variables.Add(v);
                    }
                    else if (v.ArraySize is { } n && (match.ArraySize is not { } m || n > m))
                    {
                        existing.Variables.Remove(match);
                        existing.Variables.Add(v);
                    }
                }
            }
        }

        if (c.Function.InputStruct is not null) pass.Structs.Add(c.Function.InputStruct);
        if (c.Function.OutputStruct is not null) pass.Structs.Add(c.Function.OutputStruct);

        // Cross-check the compiler-proven header extents against the
        // metadata/IR-derived slot layout for THIS stage. resources was
        // built from this subprogram's own declarations, so each extent
        // should match exactly.
        if (c.Header is { } hdr)
        {
            int MaxPlus1(HlslResourceKind kind) =>
                resources.Where(r => r.Kind == kind).Select(r => (int)r.Slot)
                         .DefaultIfEmpty(-1).Max() + 1;
            int cb = MaxPlus1(HlslResourceKind.ConstantBuffer);
            int tex = MaxPlus1(HlslResourceKind.Texture);
            int samp = MaxPlus1(HlslResourceKind.Sampler);
            int uav = MaxPlus1(HlslResourceKind.Uav);
            log.WriteLine(
                $"  Header verify ({c.Stage} subprogram {c.Index}): " +
                $"cb {cb}/{hdr.CbExtent} {(cb == hdr.CbExtent ? "OK" : "MISMATCH")}  " +
                $"tex {tex}/{hdr.TextureExtent} {(tex == hdr.TextureExtent ? "OK" : "MISMATCH")}  " +
                $"samp {samp}/{hdr.SamplerExtent} {(samp == hdr.SamplerExtent ? "OK" : "MISMATCH")}  " +
                $"uav {uav}/{hdr.UavExtent} {(uav == hdr.UavExtent ? "OK" : "MISMATCH")}");
        }

        log.WriteLine(
            $"Stage 2: attached {c.Stage} function '{c.Function.Name}' to pass '{pass.Name}' " +
            $"(in:{c.Function.InputStruct?.Fields.Count ?? 0} out:{c.Function.OutputStruct?.Fields.Count ?? 0} " +
            $"resources+{pass.Resources.Count})");
    }

    // A variant pass: same name/tags/render state and the same per-pass
    // cbuffer layout as the shell pass it was cloned from, but its own
    // function slots/resources/structs (filled by AttachPassProgram).
    private static HlslPassNode ClonePass(HlslPassNode src)
    {
        var clone = new HlslPassNode
        {
            Name = src.Name,
            RenderStateRaw = src.RenderStateRaw,
            State = src.State,
        };
        foreach (var (k, v) in src.Tags)
            clone.Tags[k] = v;
        foreach (var (k, v) in src.Cbuffers)
            clone.Cbuffers[k] = v;
        return clone;
    }

    private static void AttachFunction(HlslPassNode pass, HlslFunctionNode function)
    {
        switch (function.Stage)
        {
            case HlslShaderStage.Vertex: pass.VertexFunction = function; break;
            case HlslShaderStage.Fragment: pass.FragmentFunction = function; break;
            case HlslShaderStage.Geometry: pass.GeometryFunction = function; break;
            case HlslShaderStage.Hull: pass.HullFunction = function; break;
            case HlslShaderStage.Domain: pass.DomainFunction = function; break;
            case HlslShaderStage.Compute: pass.ComputeFunction = function; break;
        }
    }

}
