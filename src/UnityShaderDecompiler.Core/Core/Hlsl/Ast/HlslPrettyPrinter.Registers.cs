using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using UnityShaderDecompiler.Core.DXBC.Chunks;
using UnityShaderDecompiler.Core.DXBC.Instructions;
using UnityShaderDecompiler.Core.DXBC.IR;
using UnityShaderDecompiler.Core.Analysis;
using UnityShaderDecompiler.Core.DXBC.Metadata;

namespace UnityShaderDecompiler.Core.Hlsl.Ast;

// Stage 13 register/expression rendering: SSA version names, cbuffer and
// signature field access, component mask handling, and expression text.
public static partial class HlslPrettyPrinter
{
    private static void PrintStatement(StringBuilder sb, HlslStatementNode stmt, int indent, PrintContext ctx)
    {
        string pad = new(' ', indent * 4);

        switch (stmt)
        {
            case HlslIfStatement iff:
            {
                // Cross-branch phi copies (IRLeaveSsa writes the same
                // post-merge name at the top level of BOTH arms) must have
                // their declaration hoisted above the if. Declared per-arm,
                // the name is scoped to that arm's braces and dies at the
                // `}` — the sibling arm's write and any post-merge read
                // would then reference an identifier never in scope.
                foreach ((string name, int comps) in CrossBranchMergeNames(iff, ctx))
                {
                    if (!ctx.Declared.Add(name))
                        continue; // already in scope — don't redeclare
                    sb.Append(pad).Append(DeclType(comps)).Append(' ').Append(name).Append(";\n");
                }

                sb.Append(pad).Append("if (").Append(RenderCondition(iff.Condition, ctx)).Append(")\n");
                sb.Append(pad).Append("{\n");
                // Declarations inside an arm are scoped to that arm's braces.
                // ctx.Declared is function-wide, so restore the arm's names
                // afterwards or a sibling branch thinks they are in scope.
                var ifScope = new HashSet<string>(ctx.Declared);
                PrintBlock(sb, iff.Then, indent + 1, ctx);
                sb.Append(pad).Append("}\n");
                if (iff.Else is not null)
                {
                    sb.Append(pad).Append("else\n").Append(pad).Append("{\n");
                    PrintBlock(sb, iff.Else, indent + 1, ctx);
                    sb.Append(pad).Append("}\n");
                }
                ctx.Declared.Clear();
                ctx.Declared.UnionWith(ifScope);
                break;
            }

            case HlslLoopStatement loop:
            {
                // Names first written at the loop body's top level. A
                // declaration that lands inside the loop's braces is scoped
                // to the loop; a name that is also live out of the loop
                // (read or written after it) then references an identifier
                // that never comes back into scope. Hoist the declaration
                // above the loop. Hoisting loop-local names too is harmless
                // (they are always written in the body, never unused) and
                // is the only way to catch loop-carried names without a
                // full dataflow pass.
                foreach ((string name, int comps) in LoopCarriedDeclNames(loop, ctx))
                {
                    if (!ctx.Declared.Add(name))
                        continue; // already in scope — don't redeclare
                    sb.Append(pad).Append(DeclType(comps)).Append(' ').Append(name).Append(";\n");
                }

                sb.Append(pad).Append("[loop]\n").Append(pad).Append("while (true)\n").Append(pad).Append("{\n");
                var loopScope = new HashSet<string>(ctx.Declared);
                PrintBlock(sb, loop.Body, indent + 1, ctx);
                ctx.Declared.Clear();
                ctx.Declared.UnionWith(loopScope);
                sb.Append(pad).Append("}\n");
                break;
            }

            case HlslSwitchStatement sw:
                // Case labels share one scope, but a declaration inside the
                // first case cannot be jumped over by a later case. Hoist
                // every destination name the cases write above the switch,
                // the same way the if/loop paths do.
                foreach ((string name, int comps) in WrittenDeclNames(
                    sw.Cases.SelectMany(c => c.Body.Statements).ToList(), ctx))
                {
                    if (!ctx.Declared.Add(name))
                        continue;
                    sb.Append(pad).Append(DeclType(comps)).Append(' ').Append(name).Append(";\n");
                }
                sb.Append(pad).Append("switch (").Append(RenderCondition(sw.Selector, ctx)).Append(")\n").Append(pad).Append("{\n");
                var switchScope = new HashSet<string>(ctx.Declared);
                foreach (HlslSwitchCase c in sw.Cases)
                {
                    sb.Append(pad).Append(c.Value is null ? "default:\n" : $"case {RenderExpression(c.Value, ctx)}:\n");
                    PrintBlock(sb, c.Body, indent + 1, ctx);
                }
                ctx.Declared.Clear();
                ctx.Declared.UnionWith(switchScope);
                sb.Append(pad).Append("}\n");
                break;

            case HlslBreakStatement b:
                sb.Append(pad).Append(b.Condition is null ? "break;" : $"if ({RenderCondition(b.Condition, ctx)}) break;").Append('\n');
                break;

            case HlslContinueStatement c:
                sb.Append(pad).Append(c.Condition is null ? "continue;" : $"if ({RenderCondition(c.Condition, ctx)}) continue;").Append('\n');
                break;

            case HlslReturnStatement r:
            {
                // Geometry entry points are void: ret emits nothing, the
                // output goes through stream.Append before it.
                string ret = ctx.Stage == HlslShaderStage.Geometry ? "return;" : "return o;";
                sb.Append(pad).Append(r.Condition is null
                    ? ret
                    : $"if ({RenderCondition(r.Condition, ctx)}) {ret}").Append('\n');
                break;
            }

            case HlslEmitStatement e:
                sb.Append(pad).Append(StreamName((uint)e.Stream))
                  .Append(e.IsCut ? ".RestartStrip();" : ".Append(o);").Append('\n');
                break;

            case HlslDiscardStatement d:
                sb.Append(pad).Append("if (").Append(RenderCondition(d.Condition, ctx)).Append(") discard;\n");
                break;

            case HlslMemoryStoreStatement ms:
                sb.Append(pad).Append(RenderRegisterRead(ms.Resource, ctx))
                  .Append('[').Append(RenderExpression(ms.Address, ctx)).Append("] = ")
                  .Append(RenderExpression(ms.Value, ctx)).Append(";\n");
                break;

            case HlslRawStatement raw:
                sb.Append(pad).Append("// TODO: unhandled IR node — ").Append(raw.Source).Append('\n');
                break;
        }
    }

    // ---------- register/identifier rendering (the actual fix) ----------
    //
    // IRRegister.ToStringAs() is documented as debug-display only — its
    // SSA suffix comma-joins per-component version numbers and keeps the
    // ".xyz" dot-swizzle, neither of which is a legal HLSL identifier
    // ("r0.xyz_1,1,1" doesn't compile). Each vector component is actually
    // an independently-versioned scalar SSA value (see IRRegister's own
    // SsaVersion doc comment), so real HLSL needs one legal identifier
    // per (register, component, version) — this section builds those
    // instead of reusing the debug string.

    private const string ComponentLetters = "xyzw";

    // Which source-register component each active "slot" reads, in
    // output order. Mirrors IRRegister's private Mask/Swizzle/Select1
    // logic (duplicated here since that logic is private to IRRegister —
    // it only needs the public Mask/Swizzle/Component/ComponentMode
    // fields, so this is a small, safe duplication, not a guess).
    private static List<int> ActiveComponents(IRRegister reg) => reg.ComponentMode switch
    {
        Operand.OperandComponentMode.Mask => MaskIndices(reg.Mask),
        Operand.OperandComponentMode.Swizzle => new List<int>
        {
            reg.Swizzle & 3, (reg.Swizzle >> 2) & 3, (reg.Swizzle >> 4) & 3, (reg.Swizzle >> 6) & 3,
        },
        Operand.OperandComponentMode.Select1 => new List<int> { reg.Component },
        _ => new List<int> { 0, 1, 2, 3 }, // no mask/swizzle info — assume all 4 live
    };

    private static List<int> MaskIndices(byte mask)
    {
        var result = new List<int>();
        if ((mask & 1) != 0) result.Add(0);
        if ((mask & 2) != 0) result.Add(1);
        if ((mask & 4) != 0) result.Add(2);
        if ((mask & 8) != 0) result.Add(3);
        return result;
    }

    private static string BaseIdentifier(IRRegister reg, PrintContext ctx)
    {
        if (reg.SymbolicName is not null)
            return reg.SymbolicName;

        return reg.RegisterType switch
        {
            RegisterType.Temp => $"r{reg.Index}",
            RegisterType.IndexableTemp => IndexedName("x", reg, ctx),
            RegisterType.Input => $"v{reg.Index}",
            RegisterType.Output => $"o{reg.Index}",
            RegisterType.Resource => ctx.TextureNameBySlot.TryGetValue((int)reg.Index, out string? tName)
                ? tName
                : $"t{reg.Index}",
            RegisterType.Sampler => ctx.SamplerNameBySlot.TryGetValue((int)reg.Index, out string? sName)
                ? sName
                : $"s{reg.Index}",
            RegisterType.ConstantBuffer => CbufferElementName(reg, ctx),
            _ => $"{reg.RegisterType.ToString().ToLowerInvariant()}{reg.Index}",
        };
    }

    // RDEF-less cbuffer reads: HlslAstBuilder declares a synthesized
    // `float4 cbN_values[K]` (one element per accessed 16-byte slot), so a
    // read of register `cbN[elem]` renders as cbN_values[elem]. With RDEF,
    // BaseIdentifier returns the bound SymbolicName instead and this is
    // never reached.
    private static string CbufferElementName(IRRegister reg, PrintContext ctx)
    {
        if (reg.Indices.Count < 2)
            return IndexedName("cb", reg, ctx);

        IRExpression? relative = reg.RelativeIndices.Length > 1 ? reg.RelativeIndices[1] : null;
        string elem = relative is not null
            ? (reg.Indices[1] != 0 ? $"{RenderExpression(relative, ctx)} + {reg.Indices[1]}" : RenderExpression(relative, ctx))
            : reg.Indices[1].ToString();

        return $"cb{reg.Indices[0]}_values[{elem}]";
    }

    // The full cbuffer read, in priority order:
    //   1. RDEF/Stage-1 bound names (SymbolicName) — real identifier + swizzle;
    //   2. ShaderLab-metadata layout — cbN[slot] resolves to the variable
    //      whose byte range covers the read (unity_ObjectToWorld[0], _M_map_ST);
    //   3. synthesized cbN_values[slot] fallback array.
    private static string RenderCbufferRead(IRRegister reg, PrintContext ctx)
    {
        if (reg.SymbolicName is not null)
        {
            string name = reg.SymbolicName;
            if (ctx.CbufferVarRenames.TryGetValue(name, out string? renamed))
                name = renamed;
            return name + MaskOrSwizzleSuffix(reg);
        }

        if (reg.Indices.Count >= 2
            && ctx.Cbuffers.TryGetValue((int)reg.Indices[0], out CbufferMetadata? cb)
            && ResolveCbufferRead(cb, reg) is { } named)
        {
            // Try exact match first.
            if (ctx.CbufferVarRenames.TryGetValue(named, out string? renamed))
                return renamed;

            // Try prefix match: ResolveCbufferRead may return
            // "varName.swizzle" but the rename map stores bare "varName".
            foreach (var (old, fresh) in ctx.CbufferVarRenames)
            {
                if (named == old || named.StartsWith(old + ".") || named.StartsWith(old + "["))
                    return named.Replace(old, fresh);
            }

            return named;
        }

        return CbufferElementName(reg, ctx) + MaskOrSwizzleSuffix(reg);
    }

    // Maps a cbN[reg] register read (plus its component swizzle) onto a
    // metadata variable by byte range, producing the HLSL identifier:
    //   - whole-variable read            -> bare name (_M_map_ST)
    //   - partial vector read            -> name + relative swizzle (_Color.xz)
    //   - matrix row read                -> name[row] (+ swizzle)
    // Array variables defer to the cbN_values fallback.
    // Returns null when no listed variable covers the read (partial layout).
    internal static string? ResolveCbufferRead(CbufferMetadata cb, IRRegister reg)
    {
        int[] comps = ReadComponentIndices(reg).ToArray();
        if (comps.Length == 0)
            return null;

        var distinct = comps.Distinct().OrderBy(c => c).ToArray();
        uint elem = reg.Indices[1];
        uint byteStart = elem * 16 + (uint)distinct[0] * 4;
        uint byteEnd = elem * 16 + (uint)distinct[^1] * 4 + 4;

        CbufferVariableMetadata? best = null;
        int bestSize = int.MaxValue;
        foreach (CbufferVariableMetadata v in cb.Variables)
        {
            if ((long)v.Offset <= byteStart && (long)v.Offset + v.SizeBytes >= byteEnd && v.SizeBytes < bestSize)
            {
                best = v;
                bestSize = v.SizeBytes;
            }
        }

        if (best is null)
            return null;

        uint rel = byteStart - (uint)best.Offset;
        string letters = string.Concat(comps.Select(c => ComponentLetters[c]));
        string swizzle = distinct.Length == 4 && distinct[0] == 0 && distinct[^1] == 3
            ? ""
            : "." + letters;

        if (best.IsMatrix || best.RowCount > 0)
        {
            if (best.ArraySize > 0)
                return null; // array-of-matrices: defer to cbN_values fallback

            uint row = rel / 16;
            return $"{best.Name}[{row}]{swizzle}";
        }

        if (best.ArraySize > 0)
            return null; // array reads: defer to cbN_values fallback

        // Read covers the whole variable — but only when the read is NOT a
        // broadcast (repeated components). A swizzle like .xxyz on a float3
        // ADDS a component and must keep its suffix; dropping it narrows the
        // expression (float3) so a later .w read on the result breaks.
        if (comps.Length == distinct.Length && bestSize == distinct.Length * 4 && rel == 0)
            return best.Name;

        int vsc = (int)(rel / 4);
        string letters2 = string.Concat(comps.Select(c => ComponentLetters[vsc + (c - distinct[0])]));
        return best.Name + "." + letters2;
    }

    // Component indices the read touches, in order (with repeats for a
    // swizzle). Mirrors MaskOrSwizzleSuffix's mode dispatch.
    private static List<int> ReadComponentIndices(IRRegister reg) => reg.ComponentMode switch
    {
        Operand.OperandComponentMode.Mask when reg.Mask != 0 => MaskIndices(reg.Mask),
        Operand.OperandComponentMode.Swizzle => ActiveComponents(reg),
        Operand.OperandComponentMode.Select1 => new List<int> { reg.Component },
        _ => new List<int> { 0 },
    };

    // cbuffer/indexable-temp registers carry TWO index slots (buffer/array
    // number, then element offset) in reg.Indices/RelativeIndices, not
    // just reg.Index — reg.Index alone would silently drop the element
    // offset (e.g. render "cb0" instead of "cb0[8]" for an unbound
    // constant-buffer read). Mirrors IRRegister.IndexToString's handling
    // of dynamic/relative indices (cb0[r2.x + 4]) via the same public
    // fields, since that logic is private to IRRegister.
    private static string IndexedName(string prefix, IRRegister reg, PrintContext ctx)
    {
        if (reg.Indices.Count == 0)
            return $"{prefix}{reg.Index}";

        string Slot(int i)
        {
            IRExpression? relative = i < reg.RelativeIndices.Length ? reg.RelativeIndices[i] : null;
            if (relative is not null)
            {
                uint constOffset = reg.Indices.Count > i ? reg.Indices[i] : 0;
                return constOffset != 0 ? $"{RenderExpression(relative, ctx)} + {constOffset}" : RenderExpression(relative, ctx);
            }
            return reg.Indices.Count > i ? reg.Indices[i].ToString() : "0";
        }

        return reg.Indices.Count >= 2
            ? $"{prefix}{Slot(0)}[{Slot(1)}]"
            : $"{prefix}{Slot(0)}";
    }

    // Scalar per-(register,component,version) identifier — always a
    // legal, unique C-style identifier. A versionless result is NOT an
    // implicit input (real function inputs are RegisterType.Input and
    // render via i.field in RenderRegisterRead, never here); for a temp it
    // means the register was never written on this reaching path — a
    // don't-care the phi-fallback guard in RenderAssignmentLines handles
    // by either dropping the copy or declaring the scalar uninitialized.
    private static string ScalarIdentifier(IRRegister reg, int component, PrintContext ctx)
    {
        string bare = BaseIdentifier(reg, ctx);
        int? version = reg.SsaVersion[component];
        return version is { } v
            ? $"{bare}_{ComponentLetters[component]}_{v}"
            : $"{bare}_{ComponentLetters[component]}";
    }

    // Reads a Temp/IndexableTemp register for use on the RHS of an
    // expression. Every active component is resolved to the identifier its
    // defining instruction actually declared (see PrintContext.DeclaredViews):
    //   - components co-written by one instruction share a vector name and
    //     read as a swizzle off it (r0.xyz -> r0_xyz_5, r0.x -> r0_xyz_5.x);
    //   - components written separately — even ones that coincidentally
    //     share a version number, since versions are per-component counters —
    //     build a constructor from their own declared names
    //     (float2(r0_xy_5.x, r0_w_2)).
    // The old heuristic (collapse whenever versions match) emitted view
    // strings like r0_x_1 that were never declared anywhere.
    private static string RenderTempRead(IRRegister reg, PrintContext ctx)
    {
        List<int> active = ActiveComponents(reg);
        if (active.Count == 0)
            return BaseIdentifier(reg, ctx);

        if (active.Count == 1)
            return ResolveComponent(reg, active[0], ctx);

        var resolved = active.Select(c =>
        {
            int? version = reg.SsaVersion[c];
            if (version is { } v
                && ctx.DeclaredViews.TryGetValue((LocationOf(reg, c), v), out (string Name, List<int> Active) entry))
                return (Comp: c, Name: entry.Name, Active: entry.Active);
            return (Comp: c, Name: ScalarIdentifier(reg, c, ctx), Active: new List<int> { c });
        }).ToList();

        string firstName = resolved[0].Name;
        List<int> declared = resolved[0].Active;
        if (resolved.All(r => r.Name == firstName))
        {
            // A scalar declared name (one active component) broadcasts one
            // value into every slot — HLSL scalars only permit .x repeats,
            // so the swizzle must be all 'x' no matter which logical
            // component (y/z/w) the scalar originally came from. Vector
            // names swizzle positionally: each read component's slot in
            // the declared vector comes from IndexOf, not its original
            // register letter (a float2 declared from components y,z reads
            // its z-slot as ".y", not ".z").
            string readLetters = declared.Count == 1
                ? new string('x', active.Count)
                : string.Concat(active.Select(c => ComponentLetters[declared.IndexOf(c)]));
            string declaredLetters = string.Concat(declared.Select(c => ComponentLetters[c]));
            return declaredLetters == readLetters
                ? firstName
                : $"{firstName}.{readLetters}";
        }

        return $"float{active.Count}({string.Join(", ", resolved.Select(r => ComponentView(r.Name, r.Active, r.Comp)))})";
    }

    // Renders one component of a declared name: a scalar declaration
    // stands alone, a vector declaration needs the component's POSITION
    // within the declared vector (IndexOf in the active-component list),
    // not the source register's original component letter — the swizzle
    // chars must index the declared variable's own slots.
    private static string ComponentView(string name, List<int> activeComponents, int component)
    {
        if (activeComponents.Count <= 1) return name;
        int pos = activeComponents.IndexOf(component);
        return $"{name}.{ComponentLetters[pos]}";
    }

    // Resolves a single-component read to the identifier its defining
    // instruction declared (swizzle off the vector if it was co-written),
    // falling back to the synthetic scalar name when nothing was recorded
    // (a versionless temp — a value never written on this reaching path).
    private static string ResolveComponent(IRRegister reg, int component, PrintContext ctx)
    {
        int? version = reg.SsaVersion[component];

        if (version is { } v
            && ctx.DeclaredViews.TryGetValue((LocationOf(reg, component), v), out (string Name, List<int> Active) entry))
            return ComponentView(entry.Name, entry.Active, component);

        return ScalarIdentifier(reg, component, ctx);
    }

    // Structural storage identity for (reg, component) — mirrors
    // IRStorageLocation.Of exactly (bank/slot from Indices, dynamic when a
    // relative index is present). This is the value-identity key for
    // DeclaredViews: it must NOT involve SymbolicName or the rendered name,
    // because synthesized registers (phi operands etc.) don't carry the
    // same names as the instruction that declared the value.
    private static IRStorageLocation LocationOf(IRRegister reg, int component)
    {
        uint bank = reg.Indices.Count > 0 ? reg.Indices[0] : reg.Index;
        uint slot = reg.Indices.Count > 1 ? reg.Indices[1] : 0;

        bool dynamic = reg.RelativeIndices[0] is not null
            || (reg.Indices.Count > 1 && reg.RelativeIndices[1] is not null);

        return new IRStorageLocation(reg.RegisterType, bank, dynamic ? 0 : slot, dynamic, ComponentLetters[component]);
    }

    private static string MaskOrSwizzleSuffix(IRRegister reg) => reg.ComponentMode switch
    {
        Operand.OperandComponentMode.Mask when reg.Mask != 0 =>
            "." + string.Concat(MaskIndices(reg.Mask).Select(c => ComponentLetters[c])),
        Operand.OperandComponentMode.Swizzle =>
            "." + string.Concat(ActiveComponents(reg).Select(c => ComponentLetters[c])),
        Operand.OperandComponentMode.Select1 => "." + ComponentLetters[reg.Component],
        _ => "",
    };

    // Central dispatch for reading ANY register on the RHS of an
    // expression — routes to struct-field access for input/output,
    // direct (already-valid) bound names for cbuffer/resource/sampler,
    // and the scalar-SSA machinery above for temps.
    private static string RenderRegisterRead(IRRegister reg, PrintContext ctx)
    {
        string rendered = reg.RegisterType switch
        {
            RegisterType.Temp or RegisterType.IndexableTemp =>
                RenderTempRead(reg, ctx),

            RegisterType.Input =>
                RenderSignatureField(reg, InputPrefix(reg, ctx), ctx.InputElements, ctx),

            RegisterType.Output =>
                RenderSignatureField(reg, "o", ctx.OutputElements, ctx),

            // Geometry input primitive ID is an implicit per-primitive system
            // value, not a field of the per-vertex array. Geometry shaders
            // take it as its own parameter; other stages still have it in the
            // input struct.
            RegisterType.InputPrimitiveID => ctx.Stage == HlslShaderStage.Geometry
                ? HlslAstBuilder.ToFieldName("SV_PrimitiveID0")
                : "i." + HlslAstBuilder.ToFieldName("SV_PrimitiveID0"),

            RegisterType.ConstantBuffer =>
                RenderCbufferRead(reg, ctx),

            RegisterType.Resource or RegisterType.Sampler or RegisterType.Uav =>
                // Texture/sampler/UAV objects are not vector values — the
                // DXBC operand swizzle on a resource handle is meaningless
                // (and t0.xyzw.Sample would never compile).
                BaseIdentifier(reg, ctx),

            _ =>
                BaseIdentifier(reg, ctx) + MaskOrSwizzleSuffix(reg),
        };

        return ApplyRegisterModifier(reg.Modifier, rendered);
    }

    // A DXBC source modifier (negate/abs/absneg) that is dropped here would
    // silently change the shader's math — e.g. `1.0 - i.vertexColor.a`
    // decompiling as `(i.cOLOR0.w + 1)`. The modifier lives on the IR register
    // itself, so it is applied once, in this central read dispatch.
    private static string ApplyRegisterModifier(ShdrParser.OperandModifier modifier, string rendered)
    {
        return modifier switch
        {
            ShdrParser.OperandModifier.Neg => $"-{rendered}",
            ShdrParser.OperandModifier.Abs => $"abs({rendered})",
            ShdrParser.OperandModifier.AbsNeg => $"-abs({rendered})",
            _ => rendered,
        };
    }

    // Geometry input registers carry the array element (vertex index) in
    // Indices[0]; every other stage's input is a single struct parameter.
    private static string InputPrefix(IRRegister reg, PrintContext ctx)
    {
        if (ctx.Stage != HlslShaderStage.Geometry || reg.Indices.Count == 0)
            return "i";

        IRExpression? relative = reg.RelativeIndices[0];
        string index = relative is not null
            ? RenderExpression(relative, ctx)
            : reg.Indices[0].ToString();
        return $"i[{index}]";
    }

    private static string FieldNameFor(IRRegister reg, PrintContext ctx)
    {
        string semantic = reg.SymbolicName ?? BaseIdentifier(reg, ctx);
        return HlslAstBuilder.ToFieldName(semantic);
    }

    private static string ElementFieldName(SignatureElement el)
        => HlslAstBuilder.ToFieldName($"{el.SemanticName}{el.SemanticIndex}");

    // Component letter a register position maps to WITHIN a signature
    // element: the number of element-owned register components below it.
    // A write of register position z owned by TEXCOORD1 (mask 0xC = zw) is
    // TEXCOORD1's local x, since TEXCOORD1 only occupies two lanes.
    private static char ElementLocalLetter(SignatureElement el, int registerPosition)
    {
        int below = System.Numerics.BitOperations.PopCount((uint)(el.Mask & ((1 << registerPosition) - 1)));
        return ComponentLetters[below];
    }

    private static string ElementLocalSuffix(SignatureElement el, List<int> positions)
        => "." + string.Concat(positions.Select(p => ElementLocalLetter(el, p)));

    // Renders an input/output register access as a struct-field reference
    // (i.field.swizzle / o.field.swizzle). A register PACKED across multiple
    // signature elements with disjoint masks has each component routed to
    // the element whose mask covers it, with letters remapped into that
    // element's own component space. Multi-element reads build a
    // constructor; multi-element writes are split by RenderOutputWrite.
    private static string RenderSignatureField(IRRegister reg, string prefix, Dictionary<uint, List<SignatureElement>> byRegister, PrintContext ctx)
    {
        List<int> positions = ActiveComponents(reg);
        if (byRegister.TryGetValue(reg.Index, out List<SignatureElement>? elements) && elements.Count > 1)
        {
            if (TryCoveringElement(elements, positions) is { } cover)
                return $"{prefix}.{ElementFieldName(cover)}{ElementLocalSuffix(cover, positions)}";

            // Positions span multiple elements — build a constructor whose
            // lanes are the per-position field reads, in output order.
            return $"float{positions.Count}({string.Join(", ", positions.Select(p => RoutePosition(reg, elements, p, prefix, ctx)))})";
        }

        return prefix + "." + FieldNameFor(reg, ctx) + MaskOrSwizzleSuffix(reg);
    }

    private static string RoutePosition(IRRegister reg, List<SignatureElement> elements, int position, string prefix, PrintContext ctx)
    {
        foreach (SignatureElement el in elements)
            if ((el.Mask & (1 << position)) != 0)
                return $"{prefix}.{ElementFieldName(el)}{ElementLocalSuffix(el, new List<int> { position })}";
        return $"{prefix}.{FieldNameFor(reg, ctx)}.{ComponentLetters[position]}";
    }

    private static SignatureElement? TryCoveringElement(List<SignatureElement> elements, List<int> positions)
    {
        foreach (SignatureElement el in elements)
        {
            bool all = positions.Count > 0;
            foreach (int p in positions)
                all &= (el.Mask & (1 << p)) != 0;
            if (all)
                return el;
        }
        return null;
    }

    // (element, register positions it owns) groups for an output write's
    // active positions, preserving position order.
    private static List<(SignatureElement Element, List<int> Positions)> GroupOutputPositions(List<SignatureElement> elements, List<int> active)
    {
        var groups = new List<(SignatureElement, List<int>)>();
        foreach (int p in active)
        {
            SignatureElement? el = elements.FirstOrDefault(e => (e.Mask & (1 << p)) != 0);
            if (el is null)
                continue;
            var group = groups.FirstOrDefault(g => g.Item1 == el);
            if (group.Item1 is null)
            {
                group = (el, new List<int>());
                groups.Add(group);
            }
            group.Item2.Add(p);
        }
        return groups;
    }

    // Emits an output-register write, routing each written component to the
    // struct field whose signature element owns it (packed registers split
    // into one statement per element). The RHS is the trimmed-to-width value
    // when a single element covers everything; a split takes its per-group
    // lanes straight off the full-width expression.
    private static IEnumerable<string> RenderOutputWrite(IRRegister dest, string rhs, string rawRhs, PrintContext ctx)
    {
        List<int> active = MaskIndices(dest.Mask);
        if (active.Count == 0)
            active = new List<int> { 0 };

        if (ctx.OutputElements.TryGetValue(dest.Index, out List<SignatureElement>? elements) && elements.Count > 1)
        {
            List<(SignatureElement Element, List<int> Positions)> groups = GroupOutputPositions(elements, active);
            if (groups.Count == 1 && groups[0].Positions.Count == active.Count)
            {
                var (el, pos) = groups[0];
                yield return $"o.{ElementFieldName(el)}{ElementLocalSuffix(el, pos)} = {rhs};";
            }
            else if (groups.Count > 1)
            {
                foreach ((SignatureElement el, List<int> pos) in groups)
                {
                    string slice = string.Concat(pos.Select(p => ComponentLetters[p]));
                    yield return $"o.{ElementFieldName(el)}{ElementLocalSuffix(el, pos)} = ({rawRhs}).{slice};";
                }
            }
            else
            {
                yield return $"o.{FieldNameFor(dest, ctx)}{MaskOrSwizzleSuffix(dest)} = {rhs};";
            }
            yield break;
        }

        yield return $"o.{FieldNameFor(dest, ctx)}{MaskOrSwizzleSuffix(dest)} = {rhs};";
    }

    // Emits one or more statement lines for a single destination write.
    // Multiple lines only happen when the written components have
    // diverged to different SSA versions (see below) — the common case
    // is exactly one line.
    // The single identifier an assignment to `dest` would declare (vector
    // name when components share a version, scalar name for one component),
    // or null when the write splits into per-component names. Used by the
    // phi-fallback-copy guard to check whether the destination is already
    // in scope before deciding to drop the copy.
    private static string? SingleDestName(IRRegister dest, List<int> active, PrintContext ctx)
    {
        if (dest.RegisterType == RegisterType.Output)
            return null;

        bool sameVersion = active.All(c => dest.SsaVersion[c] == dest.SsaVersion[active[0]]);
        if (active.Count > 1 && !sameVersion)
            return null;

        string letters = string.Concat(active.Select(c => ComponentLetters[c]));
        string bare = BaseIdentifier(dest, ctx);
        int? version = dest.SsaVersion[active[0]];
        return version is { } v ? $"{bare}_{letters}_{v}" : $"{bare}_{letters}";
    }

    private static IEnumerable<string> RenderAssignmentLines(IRRegister dest, IRExpression expr, PrintContext ctx)
    {
        List<int> active = MaskIndices(dest.Mask); // destinations are always write-masks, never swizzles
        if (active.Count == 0)
            active = new List<int> { 0 };

        // Phi-fallback copies (IRLeaveSsa): when the source register was
        // never written on this path, its SSA version is null. DXBC leaves
        // such values as don't-care, so emitting the read would produce
        // phantom identifiers (r8_x) that no instruction declares. If the
        // destination is already in scope (a hoisted cross-branch merge
        // name), drop the copy entirely — the variable stays
        // declared-but-uninitialized on this path, matching DXBC. Otherwise
        // declare the unversioned source scalars so the assignment still
        // compiles (it reads garbage, which is the same semantics).
        if (expr is IRExpression.RegisterExpression { Register: { } src }
            && src.RegisterType is RegisterType.Temp or RegisterType.IndexableTemp)
        {
            List<int> srcActive = ActiveComponents(src);
            if (srcActive.Count > 0 && srcActive.Any(c => src.SsaVersion[c] is null))
            {
                bool allUnversioned = srcActive.All(c => src.SsaVersion[c] is null);
                if (allUnversioned && dest.RegisterType != RegisterType.Output
                    && SingleDestName(dest, active, ctx) is { } destName
                    && ctx.Declared.Contains(destName))
                {
                    yield break;
                }
                foreach (int c in srcActive)
                {
                    if (src.SsaVersion[c] is not null)
                        continue;
                    string scalar = ScalarIdentifier(src, c, ctx);
                    if (ctx.Declared.Add(scalar))
                        yield return $"float {scalar};";
                }
            }
        }

        // resinfo has no expression-form HLSL equivalent: GetDimensions
        // reports through out-parameters, so query into uint locals and then
        // build the destination value from them.
        if (expr is IRExpression.TextureOperationExpression
            { Operation: IRExpression.TextureOperation.ResInfo } info
            && SingleDestName(dest, active, ctx) is { } infoName)
        {
            foreach (string line in RenderResInfo(info, infoName, active, dest, ctx))
                yield return line;
            yield break;
        }

        string rawRhs = RenderExpression(expr, ctx);

        // DXBC computes full-lane expressions (the source operand's 4-wide
        // swizzle) regardless of how many components the destination
        // write-mask actually consumes, so the rendered RHS is naturally
        // wider than the destination far more often than not. HLSL rejects
        // a wide RHS assigned into a narrow L-value, so narrow it to the
        // destination width with a trailing trim swizzle — the source
        // lane's first N components are exactly what the positional mask
        // semantics assign.
        string rhs = TrimToWidth(rawRhs, active, expr, ctx);

        if (dest.RegisterType == RegisterType.Output)
        {
            foreach (string line in RenderOutputWrite(dest, rhs, rawRhs, ctx))
                yield return line;
            yield break;
        }

        bool sameVersion = active.All(c => dest.SsaVersion[c] == dest.SsaVersion[active[0]]);

        if (active.Count == 1 || sameVersion)
        {
            string letters = string.Concat(active.Select(c => ComponentLetters[c]));
            string bare = BaseIdentifier(dest, ctx);
            int? version = dest.SsaVersion[active[0]];
            string name = version is { } v ? $"{bare}_{letters}_{v}" : $"{bare}_{letters}";

            // Register the identifier this write declares for each written
            // component so later reads reference this same name (swizzling
            // off it) instead of synthesizing a view that was never
            // declared. A single instruction co-writes these components,
            // so recording the shared vector name is sound here — the
            // version-coincidence hazard only affects the read side.
            if (version is { } vv)
                foreach (int c in active)
                    ctx.DeclaredViews[(LocationOf(dest, c), vv)] = (name, active);

            yield return ctx.Declared.Add(name)
                ? $"{DeclType(active.Count)} {name} = {rhs};"
                : $"{name} = {rhs};";
            yield break;
        }

        // Components diverged to different versions in one instruction.
        // Split each component directly off the RHS expression rather than
        // routing through a synthetic vector temp — the RHS is pure (texture
        // Samples included), so each extract re-reads the same lane the temp
        // would have held, and each scalar still records its own
        // correctly-versioned identifier so later reads resolve it.
        for (int i = 0; i < active.Count; i++)
        {
            int c = active[i];
            string scalarName = ScalarIdentifier(dest, c, ctx);
            if (dest.SsaVersion[c] is { } v)
                ctx.DeclaredViews[(LocationOf(dest, c), v)] = (scalarName, new List<int> { c });
            string line = $"{scalarName} = {ExtractComponent(expr, c, ctx)};";
            yield return ctx.Declared.Add(scalarName) ? $"float {line}" : line;
        }
    }

    // Renders a single ORIGINAL-register-position component of an
    // expression's value. Temp register reads compact sparse lanes into
    // fewer-wide constructors (float2 holding positions z,w), so swizzling
    // the rendered value by the original letter (.z) would be invalid —
    // extract through the register's own declared names instead, which
    // resolve the position regardless of the lane count. Non-temp renders
    // (fields, cbuffers, intrinsics) are always full-width, so a plain
    // letter swizzle on the rendered value is correct there.
    private static string ExtractComponent(IRExpression expr, int component, PrintContext ctx)
    {
        IRExpression inner = expr;
        int pos = component;
        while (inner is IRExpression.SwizzleExpression sw)
        {
            pos = sw.Components[pos];
            inner = sw.Value;
        }
        if (inner is IRExpression.RegisterExpression { Register: { } r }
            && r.RegisterType is RegisterType.Temp or RegisterType.IndexableTemp)
        {
            // A swizzle-mode source reads components by output position
            // (ActiveComponents[p]); a Select1 source is one fixed
            // component; a mask source is position-aligned.
            int source = r.ComponentMode switch
            {
                Operand.OperandComponentMode.Swizzle => ActiveComponents(r)[pos],
                Operand.OperandComponentMode.Select1 => r.Component,
                _ => pos,
            };
            return ResolveComponent(r, source, ctx);
        }
        return $"({RenderExpression(expr, ctx)}).{ComponentLetters[component]}";
    }

    private static string DeclType(int componentCount) => componentCount == 1 ? "float" : $"float{componentCount}";

    // HLSL (like C) won't assign a wide vector into a narrower L-value, but
    // DXBC's per-lane semantics mean the RHS expression naturally renders at
    // its full width (usually float4, via the source swizzle) even when the
    // destination write-mask only consumes two or three components. If the
    // RHS is genuinely wider than the destination, append a trailing swizzle
    // that selects the source components by DESTINATION position.
    //
    // A leading-N trim would be wrong: the destination's active components
    // are its mask positions (e.g. .zw -> [2,3]), and DXBC consumes source
    // lane values at exactly those positions, so `o.field.zw = r0.zzzw`
    // needs `r0.zzzw.zw` (z,w) — trimming to `.xy` would silently write
    // (z,z) into z,w. The `.xyz` masks everyone sees are only correct by
    // coincidence (their positions are the leading ones).
    //
    // Parenthesized so the swizzle binds at the top level regardless of the
    // expression's own structure (casts, ternaries, unary prefixes).
    private static string TrimToWidth(string rhs, List<int> active, IRExpression expr, PrintContext ctx)
    {
        int width = ExpressionWidth(expr, ctx);
        if (width <= active.Count)
            return rhs;
        return $"({rhs}).{string.Concat(active.Select(c => ComponentLetters[c]))}";
    }

    // Natural component width of a rendered expression — mirrors the width
    // each render path actually produces (register read width, constant
    // arity, the scalar-collapsing intrinsics, texture samples as float4).
    // Only used to decide whether TrimToWidth must narrow the RHS; when the
    // width is unknowable (a bare field read with no swizzle info) it
    // returns 1 so no invalid trim is ever emitted.
    private static int ExpressionWidth(IRExpression expr, PrintContext ctx) => expr switch
    {
        IRExpression.RegisterExpression r => RegisterReadWidth(r.Register, ctx),
        IRExpression.ConstantExpression c => Math.Max(1, Math.Max(c.RawValues.Length, c.DoubleValues.Length)),
        IRExpression.BinaryExpression b => Math.Max(ExpressionWidth(b.Left, ctx), ExpressionWidth(b.Right, ctx)),
        IRExpression.UnaryExpression u => ExpressionWidth(u.Operand, ctx),
        IRExpression.IntrinsicExpression i => IntrinsicWidth(i, ctx),
        IRExpression.FusedMultiplyAddExpression f => Math.Max(Math.Max(ExpressionWidth(f.A, ctx), ExpressionWidth(f.B, ctx)), ExpressionWidth(f.C, ctx)),
        IRExpression.MultiplyHighExpression => 1,
        IRExpression.Multiply64Expression => 1,
        IRExpression.BitFieldInsertExpression => 1,
        IRExpression.BitFieldExtractExpression => 1,
        IRExpression.ConditionalExpression c => Math.Max(ExpressionWidth(c.TrueExpression, ctx), ExpressionWidth(c.FalseExpression, ctx)),
        IRExpression.DotProductExpression => 1,
        IRExpression.SwizzleExpression s => Math.Max(1, s.Components.Count),
        IRExpression.MatrixVectorMultiplyExpression mv => Math.Max(1, mv.Rows.Count),
        IRExpression.TextureOperationExpression tex => TextureOpWidth(tex.Operation),
        _ => 1,
    };

    // How many components a register read renders as. Temps render via the
    // active-component machinery (swizzle/mask/select1 — exact). Inputs,
    // outputs and cbuffer reads render as `name` + a swizzle suffix, so the
    // suffix's length is the true width; a bare read (no suffix) has an
    // unknown width and is left untrimmed rather than guessed at.
    private static int RegisterReadWidth(IRRegister reg, PrintContext ctx)
    {
        if (reg.RegisterType is RegisterType.Temp or RegisterType.IndexableTemp)
        {
            List<int> active = ActiveComponents(reg);
            return active.Count == 0 ? 1 : active.Count;
        }

        string suffix = MaskOrSwizzleSuffix(reg);
        return suffix.Length > 1 ? suffix.Length - 1 : 1;
    }

    // DXBC conditions test one lane. A cbuffer read without an explicit
    // swizzle renders as the whole variable/row (RegisterReadWidth can't see
    // a suffix), so treat an unsuffixed non-temp read as 4 here.
    private static string RenderCondition(IRExpression expr, PrintContext ctx)
    {
        string text = RenderExpression(expr, ctx);
        return ConditionWidth(expr, ctx) > 1 ? $"({text}).x" : text;
    }

    private static int ConditionWidth(IRExpression expr, PrintContext ctx) => expr switch
    {
        // A comparison against a cbuffer/matrix/signature read is the usual
        // vector-vs-scalar mix. Appending .x to any such read is safe: HLSL
        // allows scalar swizzles, so a genuinely scalar read still works.
        IRExpression.RegisterExpression r
            when r.Register.RegisterType is not (RegisterType.Temp or RegisterType.IndexableTemp) => 4,
        IRExpression.BinaryExpression b => Math.Max(ConditionWidth(b.Left, ctx), ConditionWidth(b.Right, ctx)),
        IRExpression.UnaryExpression u => ConditionWidth(u.Operand, ctx),
        IRExpression.ConditionalExpression c => Math.Max(ConditionWidth(c.TrueExpression, ctx), ConditionWidth(c.FalseExpression, ctx)),
        IRExpression.SwizzleExpression s => Math.Max(1, s.Components.Count),
        _ => ExpressionWidth(expr, ctx),
    };

    // Element-wise intrinsics keep their argument's width; a handful
    // collapse their result to a scalar; Cross produces a float3.
    private static int IntrinsicWidth(IRExpression.IntrinsicExpression expr, PrintContext ctx)
    {
        switch (expr.Intrinsic)
        {
            case IRExpression.IRIntrinsic.Dot:
            case IRExpression.IRIntrinsic.Length:
            case IRExpression.IRIntrinsic.Distance:
            case IRExpression.IRIntrinsic.Determinant:
            case IRExpression.IRIntrinsic.Any:
            case IRExpression.IRIntrinsic.All:
            case IRExpression.IRIntrinsic.CountBits:
            case IRExpression.IRIntrinsic.ReverseBits:
            case IRExpression.IRIntrinsic.FirstBitHigh:
            case IRExpression.IRIntrinsic.FirstBitLow:
            case IRExpression.IRIntrinsic.CheckAccessFullyMapped:
                return 1;
            case IRExpression.IRIntrinsic.Cross:
                return 3;
            default:
                int w = 1;
                foreach (IRExpression arg in expr.Arguments)
                    w = Math.Max(w, ExpressionWidth(arg, ctx));
                return w;
        }
    }

    // Texture samples/loads/gathers return float4 in HLSL; the info-style
    // queries return scalars.
    private static int TextureOpWidth(IRExpression.TextureOperation op) => op switch
    {
        IRExpression.TextureOperation.Sample
            or IRExpression.TextureOperation.SampleLevel
            or IRExpression.TextureOperation.SampleGrad
            or IRExpression.TextureOperation.SampleBias
            or IRExpression.TextureOperation.Load
            or IRExpression.TextureOperation.Gather => 4,
        // Comparison ops return a single scalar in HLSL (the bytecode writes
        // one lane of the dest register; any single-lane read of it is that
        // same scalar).
        IRExpression.TextureOperation.SampleCompare
            or IRExpression.TextureOperation.SampleCompareLevelZero
            or IRExpression.TextureOperation.GatherCompare => 1,
        _ => 1,
    };

    // Names written at the top level of BOTH of an if's arms — the
    // IRLeaveSsa phi copies that merge a value at this if. These are the
    // identifiers whose declarations must be hoisted above the if (see the
    // HlslIfStatement print case). Returns (rendered name, component count
    // for the declaration type), mirroring the exact naming/typing
    // RenderAssignmentLines will produce when it prints those same writes.
    private static List<(string Name, int Components)> CrossBranchMergeNames(HlslIfStatement iff, PrintContext ctx)
    {
        var result = new List<(string, int)>();
        if (iff.Else is null)
            return result;

        Dictionary<string, int> thenNames = WrittenDeclNames(iff.Then.Statements, ctx);
        Dictionary<string, int> elseNames = WrittenDeclNames(iff.Else.Statements, ctx);

        foreach ((string name, int comps) in thenNames)
            if (elseNames.TryGetValue(name, out int elseComps))
                result.Add((name, Math.Max(comps, elseComps)));

        return result;
    }

    // Names first written at the top level of a loop body that are not yet
    // in scope (see the HlslLoopStatement print case). Only names not
    // already declared are candidates — an existing declaration is already
    // visible inside the loop.
    private static Dictionary<string, int> LoopCarriedDeclNames(HlslLoopStatement loop, PrintContext ctx)
    {
        var names = new Dictionary<string, int>();
        foreach ((string name, int comps) in WrittenDeclNames(loop.Body.Statements, ctx))
        {
            if (ctx.Declared.Contains(name))
                continue;
            if (!names.TryGetValue(name, out int prev) || comps > prev)
                names[name] = comps;
        }
        return names;
    }

    // Destination names a block's statements declare, mapped to the
    // component count (declaration type) of the write. Recurses through
    // nested if/loop/switch bodies: a value written only inside a nested arm
    // still needs its declaration hoisted by the enclosing merge.
    private static Dictionary<string, int> WrittenDeclNames(List<HlslStatementNode> statements, PrintContext ctx)
    {
        var names = new Dictionary<string, int>();
        foreach (HlslStatementNode stmt in statements)
            CollectWrittenNames(stmt, names, ctx);
        return names;
    }

    private static void CollectWrittenNames(HlslStatementNode stmt, Dictionary<string, int> names, PrintContext ctx)
    {
        IEnumerable<IRRegister> dests = stmt switch
        {
            HlslAssignmentStatement a => new[] { a.Destination },
            HlslMultiAssignmentStatement ma => ma.Destinations.Where(d => d is not null).Cast<IRRegister>(),
            _ => Array.Empty<IRRegister>(),
        };

        foreach (IRRegister dest in dests)
            foreach ((string name, int comps) in DestinationDeclNames(dest, ctx))
                if (!names.TryGetValue(name, out int prev) || comps > prev)
                    names[name] = comps;

        switch (stmt)
        {
            case HlslIfStatement i:
                CollectWrittenNames(i.Then, names, ctx);
                if (i.Else is not null)
                    CollectWrittenNames(i.Else, names, ctx);
                break;
            case HlslLoopStatement l:
                CollectWrittenNames(l.Body, names, ctx);
                break;
            case HlslSwitchStatement s:
                foreach (HlslSwitchCase c in s.Cases)
                    CollectWrittenNames(c.Body, names, ctx);
                break;
        }
    }

    // The exact identifier(s) and width RenderAssignmentLines would declare
    // for a destination — shared so the hoisting pre-pass and the emit
    // path agree on names and types.
    private static List<(string Name, int Components)> DestinationDeclNames(IRRegister dest, PrintContext ctx)
    {
        var result = new List<(string, int)>();
        if (dest.RegisterType == RegisterType.Output)
            return result; // outputs are `o.field = rhs`, never locals

        List<int> active = MaskIndices(dest.Mask);
        if (active.Count == 0)
            active = new List<int> { 0 };

        bool sameVersion = active.All(c => dest.SsaVersion[c] == dest.SsaVersion[active[0]]);

        if (active.Count == 1 || sameVersion)
        {
            string letters = string.Concat(active.Select(c => ComponentLetters[c]));
            string bare = BaseIdentifier(dest, ctx);
            int? version = dest.SsaVersion[active[0]];
            string name = version is { } v ? $"{bare}_{letters}_{v}" : $"{bare}_{letters}";
            result.Add((name, active.Count));
        }
        else
        {
            // Divergent component versions — RenderAssignmentLines splits
            // into one scalar per component, each declared individually.
            foreach (int c in active)
                result.Add((ScalarIdentifier(dest, c, ctx), 1));
        }

        return result;
    }

    // ---------- expressions ----------

    private static string RenderExpression(IRExpression expr, PrintContext ctx) => expr switch
    {
        IRExpression.IntrinsicExpression i => RenderIntrinsic(i, ctx),
        IRExpression.FusedMultiplyAddExpression f => $"mad({RenderExpression(f.A, ctx)}, {RenderExpression(f.B, ctx)}, {RenderExpression(f.C, ctx)})",
        IRExpression.MatrixVectorMultiplyExpression mv => RenderMatrixMultiply(mv, ctx),
        IRExpression.TextureOperationExpression tex => RenderTextureOp(tex, ctx),
        IRExpression.BinaryExpression b when IsBitwise(b.Operation) => RenderBitwise(b, ctx),
        // DXBC integer arithmetic reads register bits; HLSL rejects % on
        // floats, and asuint keeps the width of either operand.
        IRExpression.BinaryExpression b when b.Operation is IRExpression.BinaryOperation.Modulo
            or IRExpression.BinaryOperation.UnsignedDivide =>
            $"({IntBits(b.Left, ctx)} {BinaryOpText(b.Operation)} {IntBits(b.Right, ctx)})",
        IRExpression.BinaryExpression b => $"({RenderExpression(b.Left, ctx)} {BinaryOpText(b.Operation)} {RenderExpression(b.Right, ctx)})",
        IRExpression.UnaryExpression u => RenderUnary(u, ctx),
        IRExpression.ConditionalExpression c => $"({RenderExpression(c.Condition, ctx)} ? {RenderExpression(c.TrueExpression, ctx)} : {RenderExpression(c.FalseExpression, ctx)})",
        IRExpression.DotProductExpression d => $"dot({RenderExpression(d.Left, ctx)}, {RenderExpression(d.Right, ctx)})",
        IRExpression.SwizzleExpression s => RenderSwizzle(s, ctx),
        IRExpression.RegisterExpression r => RenderRegisterRead(r.Register, ctx),
        // HLSL has no bfi/bfe builtins; expand the bitfield forms inline.
        // shortcut: bfe's sign-extend shift is UB for width 0 or 32, which
        // DXBC does not emit; guard if a shader ever hits it.
        IRExpression.BitFieldInsertExpression bfi =>
            $"((((uint)({RenderExpression(bfi.Base, ctx)}) & ~({MaskOf(bfi.Width, ctx)} << ({RenderExpression(bfi.Offset, ctx)})))"
            + $" | (((uint)({RenderExpression(bfi.Insert, ctx)}) & {MaskOf(bfi.Width, ctx)}) << ({RenderExpression(bfi.Offset, ctx)}))))",
        IRExpression.BitFieldExtractExpression bfe when !bfe.Signed =>
            $"(((uint)({RenderExpression(bfe.Value, ctx)}) >> ({RenderExpression(bfe.Offset, ctx)})) & {MaskOf(bfe.Width, ctx)})",
        IRExpression.BitFieldExtractExpression bfe =>
            $"((int)((((uint)({RenderExpression(bfe.Value, ctx)}) >> ({RenderExpression(bfe.Offset, ctx)})) & {MaskOf(bfe.Width, ctx)}) << (32 - ({RenderExpression(bfe.Width, ctx)}))) >> (32 - ({RenderExpression(bfe.Width, ctx)})))",
        IRExpression.ConstantExpression => expr.ToString()!,
        _ => expr.ToString()!, // no dedicated renderer yet — fall back to IR debug text rather than crash
    };

    // Bitfield width mask: (1 << width) - 1, with the 32-bit full mask
    // special-cased because shifting a 32-bit value by 32 is undefined.
    private static string MaskOf(IRExpression width, PrintContext ctx)
    {
        if (width is IRExpression.ConstantExpression
            { Kind: IRExpression.ConstantExpression.ConstantKind.Int or IRExpression.ConstantExpression.ConstantKind.UInt, RawValues.Length: 1 } c)
        {
            uint w = c.Kind == IRExpression.ConstantExpression.ConstantKind.Int
                ? unchecked((uint)(int)c.RawValues[0])
                : c.RawValues[0];
            return w >= 32 ? "0xFFFFFFFFu" : $"{(1u << (int)w) - 1u}u";
        }

        string wExpr = RenderExpression(width, ctx);
        return $"(({wExpr}) >= 32 ? 0xFFFFFFFFu : ((1u << ({wExpr})) - 1u))";
    }

    // Lane selection for an inlined single-use temp. Components are source
    // register component indices relative to the value's own lanes, so a
    // width-1 value (a scalar def) broadcasts via a scalar swizzle — HLSL
    // scalars only permit .x repeats, no matter which register lane the
    // scalar originally came from — and a wider value swizzles positionally.
    // A `.xxxx` broadcast, not a `float4(x)` constructor, so a scalar bool
    // (a comparison result) stays a bool4 and never hits the single-
    // initializer constructor that HLSL rejects.
    private static string RenderSwizzle(IRExpression.SwizzleExpression s, PrintContext ctx)
    {
        string inner = RenderExpression(s.Value, ctx);
        if (ExpressionWidth(s.Value, ctx) <= 1)
            return s.Components.Count <= 1
                ? $"({inner})"
                : $"({inner}).{new string('x', s.Components.Count)}";

        // A temp read compacts sparse lanes (float2 holding original
        // positions z,w), so the requested ORIGINAL positions must be mapped
        // into the compacted lanes (IndexOf) — swizzling the compacted value
        // by the original letters (.z) would be an invalid subscript. Only a
        // direct MASK-mode register read can compact: swizzle-mode reads
        // render the full 4-wide value (r0_w_7.xxxx), and a nested swizzle's
        // output is already leading-positioned.
        if (s.Value is IRExpression.RegisterExpression { Register: { } r }
            && r.RegisterType is RegisterType.Temp or RegisterType.IndexableTemp
            && r.ComponentMode == Operand.OperandComponentMode.Mask
            && MaskIndices(r.Mask) is { } active
            && !IsLeading(active))
        {
            string letters = string.Concat(s.Components.Select(p => ComponentLetters[active.IndexOf(p)]));
            return $"({inner}).{letters}";
        }

        return $"({inner}).{string.Concat(s.Components.Select(i => ComponentLetters[i]))}";
    }

    private static bool IsLeading(List<int> components)
    {
        for (int i = 0; i < components.Count; i++)
            if (components[i] != i)
                return false;
        return true;
    }

    private static string RenderUnary(IRExpression.UnaryExpression u, PrintContext ctx) => u.Operation switch
    {
        IRExpression.UnaryExpression.UnaryOperation.Negate => $"-{RenderExpression(u.Operand, ctx)}",
        IRExpression.UnaryExpression.UnaryOperation.LogicalNot => $"!{RenderExpression(u.Operand, ctx)}",
        // DXBC bit ops reinterpret the register bits; HLSL rejects ~ on float.
        IRExpression.UnaryExpression.UnaryOperation.BitwiseNot => $"~asuint({RenderExpression(u.Operand, ctx)})",
        IRExpression.UnaryExpression.UnaryOperation.Absolute => $"abs({RenderExpression(u.Operand, ctx)})",
        _ => RenderExpression(u.Operand, ctx),
    };

    private static bool IsBitwise(IRExpression.BinaryOperation op) => op switch
    {
        IRExpression.BinaryOperation.BitwiseAnd
            or IRExpression.BinaryOperation.BitwiseOr
            or IRExpression.BinaryOperation.BitwiseXor
            or IRExpression.BinaryOperation.LeftShift
            or IRExpression.BinaryOperation.SignedRightShift
            or IRExpression.BinaryOperation.UnsignedRightShift => true,
        _ => false,
    };

    // True when the expression renders as an HLSL bool (a comparison or a
    // swizzle/negation of one). Bitwise ops in DXBC operate on raw float
    // register bits (the `and r0, r0, l(0x3f800000)` boolean-mask trick),
    // and HLSL rejects `&`/`|` on floats — so we reinterpret both sides as
    // ints, bitwise-op them, and reinterpret back. Comparisons must first
    // be cast to float (asint() does not accept bool).
    private static bool IsComparisonish(IRExpression e) => e switch
    {
        IRExpression.BinaryExpression b => b.Operation is IRExpression.BinaryOperation.Equal
            or IRExpression.BinaryOperation.NotEqual
            or IRExpression.BinaryOperation.GreaterEqual
            or IRExpression.BinaryOperation.GreaterThan
            or IRExpression.BinaryOperation.LessThan
            or IRExpression.BinaryOperation.LessEqual,
        IRExpression.UnaryExpression u => u.Operation == IRExpression.UnaryExpression.UnaryOperation.LogicalNot,
        IRExpression.SwizzleExpression s => IsComparisonish(s.Value),
        _ => false,
    };

    private static string RenderBitwise(IRExpression.BinaryExpression b, PrintContext ctx)
    {
        string Op(IRExpression side)
        {
            string s = RenderExpression(side, ctx);
            // A literal is already an integer; asint has no int overload.
            if (side is IRExpression.ConstantExpression) return s;
            return IsComparisonish(side) ? $"(float)({s})" : s;
        }
        return $"asfloat(asint({Op(b.Left)}) {BinaryOpText(b.Operation)} asint({Op(b.Right)}))";
    }

    // Reinterprets an operand as the uint bits the integer opcode sees.
    // D3DCompiler folds max(a, -a) into an abs source modifier, which integer
    // opcodes reject (X8000); clamp is a no-op that keeps the value explicit.
    // shortcut: only the max(a, -a) spelling is guarded, add other abs-fold
    // spellings if a shader hits the same X8000.
    private static string IntBits(IRExpression expr, PrintContext ctx)
    {
        bool abs = expr is IRExpression.IntrinsicExpression { Intrinsic: IRExpression.IRIntrinsic.Max } max
            && max.Arguments.Count == 2
            && (IsNegationOf(max.Arguments[0], max.Arguments[1], ctx)
                || IsNegationOf(max.Arguments[1], max.Arguments[0], ctx));
        string text = RenderExpression(expr, ctx);
        return abs
            ? $"asuint(clamp({text}, -3.4e38, 3.4e38))"
            : $"asuint({text})";
    }

    private static bool IsNegationOf(IRExpression maybeNegated, IRExpression value, PrintContext ctx)
    {
        // The negate can live on the register operand (source modifier) or in
        // a UnaryExpression, so compare the rendered text rather than shape.
        string plain = RenderExpression(value, ctx);
        string negated = RenderExpression(maybeNegated, ctx);
        return negated == "-" + plain || negated == "(-" + plain + ")";
    }

    private static string BinaryOpText(IRExpression.BinaryOperation op) => op switch
    {
        IRExpression.BinaryOperation.Add => "+",
        IRExpression.BinaryOperation.Subtract => "-",
        IRExpression.BinaryOperation.Multiply => "*",
        IRExpression.BinaryOperation.Divide => "/",
        IRExpression.BinaryOperation.UnsignedDivide => "/",
        IRExpression.BinaryOperation.Modulo => "%",
        IRExpression.BinaryOperation.Equal => "==",
        IRExpression.BinaryOperation.NotEqual => "!=",
        IRExpression.BinaryOperation.GreaterEqual => ">=",
        IRExpression.BinaryOperation.GreaterThan => ">",
        IRExpression.BinaryOperation.LessThan => "<",
        IRExpression.BinaryOperation.LessEqual => "<=",
        IRExpression.BinaryOperation.LogicalAnd => "&&",
        IRExpression.BinaryOperation.LogicalOr => "||",
        IRExpression.BinaryOperation.BitwiseAnd => "&",
        IRExpression.BinaryOperation.BitwiseOr => "|",
        IRExpression.BinaryOperation.BitwiseXor => "^",
        IRExpression.BinaryOperation.LeftShift => "<<",
        IRExpression.BinaryOperation.SignedRightShift => ">>",
        IRExpression.BinaryOperation.UnsignedRightShift => ">>",
        _ => "?",
    };

    // DXBC/HLSL-specific spelling deliberately lives here, not in the IR
    // (see the IRIntrinsic enum's own doc comment) — this is the mapping
    // it was asking for.
    private static string RenderIntrinsic(IRExpression.IntrinsicExpression expr, PrintContext ctx)
    {
        string Arg(int n) => RenderExpression(expr.Arguments[n], ctx);
        string AllArgs() => string.Join(", ", expr.Arguments.Select(a => RenderExpression(a, ctx)));

        // Casts use C-style cast syntax, not a function call. DXBC converts
        // per component, so a vector argument needs a vector cast type:
        // `(int)float4` is a scalar cast and `(...).xy` on it is invalid.
        string Cast(string type)
        {
            int width = ExpressionWidth(expr.Arguments[0], ctx);
            return width > 1 ? $"({type}{width})({Arg(0)})" : $"({type})({Arg(0)})";
        }

        switch (expr.Intrinsic)
        {
            case IRExpression.IRIntrinsic.CastFloat: return Cast("float");
            case IRExpression.IRIntrinsic.CastInt: return Cast("int");
            case IRExpression.IRIntrinsic.CastUInt: return Cast("uint");
            case IRExpression.IRIntrinsic.CastDouble: return Cast("double");
            case IRExpression.IRIntrinsic.CastBool: return Cast("bool");
        }

        string? name = expr.Intrinsic switch
        {
            IRExpression.IRIntrinsic.AsFloat => "asfloat",
            IRExpression.IRIntrinsic.AsInt => "asint",
            IRExpression.IRIntrinsic.AsUInt => "asuint",
            IRExpression.IRIntrinsic.F16ToF32 => "f16tof32",
            IRExpression.IRIntrinsic.F32ToF16 => "f32tof16",
            IRExpression.IRIntrinsic.Sqrt => "sqrt",
            IRExpression.IRIntrinsic.Rsqrt => "rsqrt",
            IRExpression.IRIntrinsic.Min => "min",
            IRExpression.IRIntrinsic.Max => "max",
            IRExpression.IRIntrinsic.Pow => "pow",
            IRExpression.IRIntrinsic.Exp2 => "exp2",
            IRExpression.IRIntrinsic.Log2 => "log2",
            IRExpression.IRIntrinsic.Reciprocal => "rcp",
            IRExpression.IRIntrinsic.Clamp01 => "saturate",
            IRExpression.IRIntrinsic.FractionalPart => "frac",
            IRExpression.IRIntrinsic.RoundNearestEven => "round",
            IRExpression.IRIntrinsic.Floor => "floor",
            IRExpression.IRIntrinsic.Ceiling => "ceil",
            IRExpression.IRIntrinsic.Truncate => "trunc",
            IRExpression.IRIntrinsic.Sin => "sin",
            IRExpression.IRIntrinsic.Cos => "cos",
            IRExpression.IRIntrinsic.Tan => "tan",
            IRExpression.IRIntrinsic.Asin => "asin",
            IRExpression.IRIntrinsic.Acos => "acos",
            IRExpression.IRIntrinsic.Atan => "atan",
            IRExpression.IRIntrinsic.Atan2 => "atan2",
            IRExpression.IRIntrinsic.Normalize => "normalize",
            IRExpression.IRIntrinsic.Length => "length",
            IRExpression.IRIntrinsic.Distance => "distance",
            IRExpression.IRIntrinsic.Reflect => "reflect",
            IRExpression.IRIntrinsic.Refract => "refract",
            IRExpression.IRIntrinsic.FaceForward => "faceforward",
            IRExpression.IRIntrinsic.Cross => "cross",
            IRExpression.IRIntrinsic.Dot => "dot",
            IRExpression.IRIntrinsic.Transpose => "transpose",
            IRExpression.IRIntrinsic.Determinant => "determinant",
            IRExpression.IRIntrinsic.Noise => "noise",
            IRExpression.IRIntrinsic.CountBits => "countbits",
            IRExpression.IRIntrinsic.ReverseBits => "reversebits",
            IRExpression.IRIntrinsic.FirstBitHigh => "firstbithigh",
            IRExpression.IRIntrinsic.FirstBitLow => "firstbitlow",
            IRExpression.IRIntrinsic.Lerp => "lerp",
            IRExpression.IRIntrinsic.Fmod => "fmod",
            IRExpression.IRIntrinsic.Modf => "modf",
            IRExpression.IRIntrinsic.Ldexp => "ldexp",
            IRExpression.IRIntrinsic.Frexp => "frexp",
            IRExpression.IRIntrinsic.DerivativeX => "ddx",
            IRExpression.IRIntrinsic.DerivativeXCoarse => "ddx_coarse",
            IRExpression.IRIntrinsic.DerivativeXFine => "ddx_fine",
            IRExpression.IRIntrinsic.DerivativeY => "ddy",
            IRExpression.IRIntrinsic.DerivativeYCoarse => "ddy_coarse",
            IRExpression.IRIntrinsic.DerivativeYFine => "ddy_fine",
            IRExpression.IRIntrinsic.Any => "any",
            IRExpression.IRIntrinsic.All => "all",
            IRExpression.IRIntrinsic.CheckAccessFullyMapped => "CheckAccessFullyMapped",
            _ => null, // DistanceVector, MaskedSumOfAbsoluteDifferences, Eval* — no confirmed HLSL builtin
        };

        return name is not null
            ? expr.Intrinsic is IRExpression.IRIntrinsic.CountBits
                or IRExpression.IRIntrinsic.ReverseBits
                or IRExpression.IRIntrinsic.FirstBitHigh
                or IRExpression.IRIntrinsic.FirstBitLow
                // These take int/uint; the operand register is float-typed
                // in the emitted HLSL, so reinterpret the bits as DXBC does.
                ? $"{name}({string.Join(", ", expr.Arguments.Select(a => $"asuint({RenderExpression(a, ctx)})"))})"
                : $"{name}({AllArgs()})"
            : $"/* TODO: no HLSL mapping for {expr.Intrinsic} */ {expr.Intrinsic}({AllArgs()})";
    }

    private static string RenderMatrixMultiply(IRExpression.MatrixVectorMultiplyExpression mv, PrintContext ctx)
    {
        if (mv.Rows.Count == 0)
            return $"/* TODO: empty matrix */ {RenderExpression(mv.Vector, ctx)}";

        string rows = string.Join(", ", mv.Rows.Select(r => RenderRegisterRead(r, ctx)));
        return $"mul(float{mv.Rows.Count}x4({rows}), {RenderExpression(mv.Vector, ctx)})";
    }

    // The location arity a comparison intrinsic wants for a given texture
    // type: TextureCube/3D/2D-array take float3, Texture2D takes float2.
    private static string CompareCoordinateSwizzle(string textureType) => textureType switch
    {
        "Texture1D" => ".x",
        "Texture2D" or "Texture2DMS" => ".xy",
        "TextureCubeArray" => ".xyzw",
        _ => ".xyz",
    };

    // DXBC resinfo has no expression-form HLSL equivalent: GetDimensions
    // reports through uint out-parameters. Query into locals named off the
    // destination, then build the destination value from them.
    // shortcut: the 2D/3D/cube families are mapped; a multisampled target
    // omits the mip parameter, other exotic resource types fall back to 3.
    private static IEnumerable<string> RenderResInfo(
        IRExpression.TextureOperationExpression tex,
        string name,
        List<int> active,
        IRRegister dest,
        PrintContext ctx)
    {
        string resource = RenderRegisterRead(tex.Resource, ctx);
        string type = tex.Resource is { } rr
            ? ctx.TextureTypeBySlot.GetValueOrDefault((int)rr.Index, "Texture2D")
            : "Texture2D";
        int outCount = ResInfoOutCount(type);
        bool hasMip = !type.Contains("MS", StringComparison.Ordinal);

        var outs = Enumerable.Range(0, outCount).Select(i => $"{name}_{ComponentLetters[i]}").ToList();
        yield return $"uint {string.Join(", ", outs)};";

        var args = new List<string>();
        if (hasMip)
        {
            string mip = tex.LOD is null ? "0" : RenderExpression(tex.LOD, ctx);
            args.Add($"(uint)({mip})");
        }
        args.AddRange(outs);
        yield return $"{resource}.GetDimensions({string.Join(", ", args)});";

        string value = active.Count == 1
            ? outs[active[0]]
            : $"float{active.Count}({string.Join(", ", active.Select(c => outs[c]))})";

        if (dest.SsaVersion[active[0]] is { } v)
            foreach (int c in active)
                ctx.DeclaredViews[(LocationOf(dest, c), v)] = (name, active);

        yield return ctx.Declared.Add(name)
            ? $"{DeclType(active.Count)} {name} = {value};"
            : $"{name} = {value};";
    }

    private static int ResInfoOutCount(string type) => type switch
    {
        "Texture1D" => 2,
        "Texture2D" or "TextureCube" or "Texture1DArray" => 3,
        "Texture2DArray" or "Texture3D" or "TextureCubeArray" => 4,
        _ => 3,
    };

    // Confirmed 1:1 against real Texture2D/TextureCube method names;
    // Load/Sample/SampleLevel/SampleBias/SampleGrad/Gather keep the same
    // name DXBC uses, only the Compare variants and argument order/style
    // needed fixing up from the debug ToString().
    private static string RenderTextureOp(IRExpression.TextureOperationExpression tex, PrintContext ctx)
    {
        string resource = RenderRegisterRead(tex.Resource, ctx);
        string? sampler = tex.Sampler is null ? null : RenderRegisterRead(tex.Sampler, ctx);
        string? coord = tex.Coordinates is null ? null : RenderExpression(tex.Coordinates, ctx);
        string? offset = tex.Offset is null ? null : RenderExpression(tex.Offset, ctx);

        // The bytecode's coordinate operand is always a full 4-component
        // register read.  HLSL's Sample/SampleLevel/SampleBias/SampleGrad/
        // Gather intrinsics accept exactly the component count the texture
        // dimension demands (.xy for 2D, .xyz for cube/3D/array, .xyzw for
        // cube array).  Trimming avoids implicit-truncation warnings and
        // matches what the original author would have written.
        // Load() is excluded — it takes int3 where .z is the mip level.
        if (tex.Operation is not IRExpression.TextureOperation.Load
            && tex.Coordinates is not null && coord is not null)
        {
            string type = tex.Resource is { } rr
                ? ctx.TextureTypeBySlot.GetValueOrDefault((int)rr.Index, "Texture2D")
                : "Texture2D";
            coord = $"({coord}){CompareCoordinateSwizzle(type)}";
        }

        string Args(params string?[] parts) => string.Join(", ", parts.Where(p => p is not null));

        return tex.Operation switch
        {
            IRExpression.TextureOperation.Sample when ctx.Stage == HlslShaderStage.Vertex =>
                // Implicit-LOD Sample does not exist in a vertex shader —
                // the bytecode's `sample` is sample_l(implicit 0), which is
                // SampleLevel(..., 0) and is valid in both vs_4_0 and vs_5_0.
                $"{resource}.SampleLevel({Args(sampler, coord, "0", offset)})",
            IRExpression.TextureOperation.Sample =>
                $"{resource}.Sample({Args(sampler, coord, offset)})",
            IRExpression.TextureOperation.SampleLevel =>
                $"{resource}.SampleLevel({Args(sampler, coord, tex.LOD is null ? null : RenderExpression(tex.LOD, ctx), offset)})",
            IRExpression.TextureOperation.SampleBias =>
                $"{resource}.SampleBias({Args(sampler, coord, tex.Bias is null ? null : RenderExpression(tex.Bias, ctx), offset)})",
            IRExpression.TextureOperation.SampleGrad =>
                $"{resource}.SampleGrad({Args(sampler, coord, tex.GradX is null ? null : RenderExpression(tex.GradX, ctx), tex.GradY is null ? null : RenderExpression(tex.GradY, ctx), offset)})",
            IRExpression.TextureOperation.SampleCompare =>
                $"{resource}.SampleCmp({Args(sampler, coord, tex.CompareValue is null ? null : RenderExpression(tex.CompareValue, ctx), offset)})",
            IRExpression.TextureOperation.SampleCompareLevelZero =>
                $"{resource}.SampleCmpLevelZero({Args(sampler, coord, tex.CompareValue is null ? null : RenderExpression(tex.CompareValue, ctx), offset)})",
            IRExpression.TextureOperation.Load =>
                $"{resource}.Load({Args(coord, offset)})", // no sampler — Load reads texels directly
            IRExpression.TextureOperation.Gather =>
                $"{resource}.Gather({Args(sampler, coord, offset)})",
            IRExpression.TextureOperation.GatherCompare =>
                $"{resource}.GatherCmp({Args(sampler, coord, tex.CompareValue is null ? null : RenderExpression(tex.CompareValue, ctx), offset)})",
            _ =>
                $"/* TODO: no confirmed HLSL mapping for {tex.Operation} */ {resource}.{tex.Operation}({Args(sampler, coord)})",
        };
    }
}
