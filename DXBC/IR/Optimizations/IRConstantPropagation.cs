using Parser.DXBC.IR;
using Parser.DXBC.IR.Analysis;

namespace Parser.DXBC.IR.Optimizations;

// Phase 9.2: for every SSA value whose sole definition is a plain
// constant (r0.x_3 = 5), replaces every read of it with that constant
// directly, everywhere in the expression tree — not just at statement
// top level, since operands are usually nested (inside fma, intrinsics,
// texture coordinates, ...).
public static class IRConstantPropagation
{
    public static bool Run(List<IRBlock> blocks)
    {
        var constants = new Dictionary<(IRStorageLocation Loc, int Version), IRExpression.ConstantExpression>();

        foreach (IRBlock block in blocks)
        {
            foreach (IRStatement stmt in block.Statements)
            {
                if (stmt is not IRStatement.IRAssignment { Expression: IRExpression.ConstantExpression c } a)
                    continue;

                foreach (IRStorageLocation loc in IRStorageLocation.WriteLocationsOf(a.Destination))
                {
                    int? version = a.Destination.SsaVersion[IRStorageLocation.ComponentToIndex(loc.Component)];
                    if (version is null)
                        continue; // not SSA-renamed yet — nothing to key this by

                    // Re-key onto a single-component constant matching
                    // just this location, so a later read of one
                    // component of a multi-component constant load
                    // still resolves correctly.
                    constants[(loc, version.Value)] = SingleComponent(c, loc.Component, a.Destination);
                }
            }
        }

        if (constants.Count == 0)
            return false;

        bool changed = false;

        foreach (IRBlock block in blocks)
        {
            for (int i = 0; i < block.Statements.Count; i++)
            {
                IRStatement original = block.Statements[i];

                // PHI operands aren't IRExpression, so the generic
                // rewriter can't reach them — nothing to do here for
                // phis; copy/const-prop into them happens at Leave-SSA.
                if (original is IRStatement.IRPhi)
                    continue;

                IRStatement rewritten = IRStatementRewriter.RewriteExpressions(original, e => Substitute(e, constants));

                if (rewritten.ToString() != original.ToString())
                {
                    block.Statements[i] = rewritten;
                    changed = true;
                }
            }
        }

        return changed;
    }

    private static IRExpression Substitute(
        IRExpression expr, Dictionary<(IRStorageLocation Loc, int Version), IRExpression.ConstantExpression> constants)
    {
        if (expr is not IRExpression.RegisterExpression re)
            return expr;

        // A register expression can itself span multiple components
        // (e.g. a swizzled read) — only safe to substitute the whole
        // thing with a constant when every component it reads resolves
        // to one, otherwise leave it as a register read.
        var pieces = new List<IRExpression.ConstantExpression>();

        foreach (IRStorageLocation loc in IRStorageLocation.ReadLocationsOf(re.Register))
        {
            // Every SSA version of the same register+component gets its
            // own entry — a location alone (without the version) doesn't
            // identify a single value, so this MUST check the specific
            // version this read actually carries, not just whether the
            // bare location is known-constant for *some* version.
            int? version = re.Register.SsaVersion[IRStorageLocation.ComponentToIndex(loc.Component)];

            if (version is null || !constants.TryGetValue((loc, version.Value), out IRExpression.ConstantExpression? c))
                return expr; // at least one component isn't known-constant at this exact version

            pieces.Add(c);
        }

        if (pieces.Count == 0)
            return expr;

        if (pieces.Count == 1)
            return pieces[0];

        var merged = new uint[pieces.Count];
        for (int i = 0; i < pieces.Count; i++)
            merged[i] = pieces[i].RawValues.Length > 0 ? pieces[i].RawValues[0] : 0;

        return new IRExpression.ConstantExpression { Kind = pieces[0].Kind, RawValues = merged };
    }

    private static IRExpression.ConstantExpression SingleComponent(
        IRExpression.ConstantExpression c, char component, IRRegister destReg)
    {
        // The write mask tells us which bit of RawValues this component
        // corresponds to positionally among the *written* components.
        int written = 0;
        for (int bit = 0; bit < 4; bit++)
        {
            if ((destReg.Mask & (1 << bit)) == 0)
                continue;

            if ("xyzw"[bit] == component)
                break;

            written++;
        }

        uint raw = c.RawValues.Length == 1 ? c.RawValues[0]
            : written < c.RawValues.Length ? c.RawValues[written]
            : c.RawValues.Length > 0 ? c.RawValues[0] : 0;

        return new IRExpression.ConstantExpression { Kind = c.Kind, RawValues = new[] { raw } };
    }
}