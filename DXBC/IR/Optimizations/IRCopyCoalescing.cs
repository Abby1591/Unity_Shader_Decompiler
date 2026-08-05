using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR.Optimizations;

// Post-LeaveSSA pass. IRLeaveSsa lowers every PHI into one scalar copy
// statement per component (e.g. r4.w_5=r4.w_3, r4.z_5=r4.z_3, r4.y_5=r4.y_3,
// r4.x_5=r4.x_3) because PHI operands/destinations are tracked per-component.
// Those never get vectorized by anything upstream (IRVectorPatternRecognition
// only folds dot-product/normalize *expression* shapes, not sequences of
// whole copy statements), so they'd otherwise stay as 4 separate lines all
// the way to HLSL output. This pass walks each block once and fuses any run
// of adjacent, component-preserving, identity-copy statements that share the
// same source register and same destination register into a single vector
// move, e.g. r4.w_5=r4.w_3 / r4.z_5=r4.z_3 / r4.y_5=r4.y_3 / r4.x_5=r4.x_3
// -> r4.xyzw_5 = r4.xyzw_3.
public static class IRCopyCoalescing
{
    public static bool Run(List<IRBlock> blocks)
    {
        bool changed = false;

        foreach (IRBlock block in blocks)
            changed |= CoalesceBlock(block);

        return changed;
    }

    private static bool CoalesceBlock(IRBlock block)
    {
        bool changed = false;
        var result = new List<IRStatement>(block.Statements.Count);

        int i = 0;
        while (i < block.Statements.Count)
        {
            if (!TryGetSimpleCopy(block.Statements[i], out IRRegister? dest0, out IRRegister? src0))
            {
                result.Add(block.Statements[i]);
                i++;
                continue;
            }

            // Collect a run of adjacent simple copies that share the same
            // destination/source base register, one distinct component each.
            var members = new List<(IRRegister Dest, IRRegister Src)> { (dest0!, src0!) };
            var usedComponents = new HashSet<byte> { dest0!.Component };

            int j = i + 1;
            while (j < block.Statements.Count &&
                   TryGetSimpleCopy(block.Statements[j], out IRRegister? destN, out IRRegister? srcN) &&
                   SameBaseRegister(destN!, dest0) &&
                   SameBaseRegister(srcN!, src0!) &&
                   usedComponents.Add(destN!.Component))
            {
                members.Add((destN!, srcN!));
                j++;
            }

            if (members.Count < 2)
            {
                // Nothing to fuse — emit the single statement as-is and
                // resume scanning right after it.
                result.Add(block.Statements[i]);
                i++;
                continue;
            }

            result.Add(BuildMergedCopy(dest0, src0!, members));
            i = j;
            changed = true;
        }

        block.Statements.Clear();
        block.Statements.AddRange(result);
        return changed;
    }

    // A "simple copy" is exactly what IRLeaveSsa emits for a phi operand:
    // dest.<single component> = src.<same component> with no modifiers
    // (negate/abs would change the value, so those are never candidates).
    private static bool TryGetSimpleCopy(IRStatement stmt, out IRRegister? dest, out IRRegister? src)
    {
        dest = null;
        src = null;

        if (stmt is not IRStatement.IRAssignment { Expression: IRExpression.RegisterExpression regExpr } assign)
            return false;

        IRRegister d = assign.Destination;
        IRRegister s = regExpr.Register;

        if (d.ComponentMode != Operand.OperandComponentMode.Select1)
            return false;
        if (s.ComponentMode != Operand.OperandComponentMode.Select1)
            return false;
        if (d.Component != s.Component)
            return false; // only fuse component-preserving copies
        if (s.Modifier != ShdrParser.OperandModifier.None)
            return false; // negate/abs changes the value — not a pure copy

        dest = d;
        src = s;
        return true;
    }

    // Same underlying register (ignoring the per-statement component
    // selection, SSA-version bookkeeping, and modifiers, which legitimately
    // differ statement-to-statement within the run being fused).
    private static bool SameBaseRegister(IRRegister a, IRRegister b)
    {
        if (a.RegisterType != b.RegisterType) return false;
        if (a.Index != b.Index) return false;
        if (a.SymbolicName != b.SymbolicName) return false;
        if (!a.Indices.SequenceEqual(b.Indices)) return false;

        for (int k = 0; k < a.RelativeIndices.Length; k++)
        {
            IRExpression? ra = a.RelativeIndices[k];
            IRExpression? rb = b.RelativeIndices[k];
            if (ra is null != rb is null) return false;
            if (ra is not null && ra.ToString() != rb!.ToString()) return false;
        }

        return true;
    }

    private static IRStatement BuildMergedCopy(
        IRRegister destTemplate,
        IRRegister srcTemplate,
        List<(IRRegister Dest, IRRegister Src)> members)
    {
        byte mask = 0;
        foreach ((IRRegister dest, _) in members)
            mask |= (byte)(1 << dest.Component);

        IRRegister mergedDest = CloneAsMask(destTemplate, mask, members, useDestVersion: true);
        IRRegister mergedSrc = CloneAsMask(srcTemplate, mask, members, useDestVersion: false);

        return new IRStatement.IRAssignment
        {
            Destination = mergedDest,
            Expression = new IRExpression.RegisterExpression { Register = mergedSrc },
        };
    }

    private static IRRegister CloneAsMask(
        IRRegister template,
        byte mask,
        List<(IRRegister Dest, IRRegister Src)> members,
        bool useDestVersion)
    {
        var merged = new IRRegister
        {
            RegisterType = template.RegisterType,
            Type = template.Type,
            Index = template.Index,
            Mask = mask,
            ComponentMode = Operand.OperandComponentMode.Mask,
            Modifier = ShdrParser.OperandModifier.None,
            SymbolicName = template.SymbolicName,
        };

        merged.Indices.AddRange(template.Indices);
        for (int k = 0; k < template.RelativeIndices.Length; k++)
            merged.RelativeIndices[k] = template.RelativeIndices[k];

        // Carry over each component's own SSA version so the merged
        // statement prints identical version info to the un-merged lines
        // (e.g. "_5333" for def-side, matching whichever per-component
        // version each original scalar copy carried).
        foreach ((IRRegister dest, IRRegister src) in members)
        {
            IRRegister source = useDestVersion ? dest : src;
            int component = dest.Component;
            merged.SsaVersion[component] = source.SsaVersion[component];
        }

        return merged;
    }
}