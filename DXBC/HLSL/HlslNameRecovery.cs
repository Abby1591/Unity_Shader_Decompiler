using Parser.DXBC.Instructions;
using Parser.DXBC.IR;

namespace Parser.DXBC.Hlsl.Ast;

// Stage 12 — Name Recovery.
//
// The spec's own example ("r0 -> albedo") is illustrative, not literal —
// DXBC doesn't preserve temp-register names, so there is no source of
// truth for "this temp is semantically the albedo". The ONE thing that
// genuinely counts as recovery rather than invention: a temp register
// that's a pure copy of an already-named value (metadata-bound input/
// cbuffer/resource register, or another temp this same pass already
// named) can safely take that name, because it IS that value under a
// different register slot — not a guess about what it represents.
//
// Anything without that provable chain stays r0/r1/... exactly as the
// spec says it should ("otherwise leave r0. Don't invent names.").
public static class HlslNameRecovery
{
    // Identifies one SSA-renamed value: same register index + same
    // per-component version numbers = same value, even though DXBC's IR
    // gives every occurrence its own IRRegister instance.
    private readonly record struct RegKey(RegisterType Type, uint Index, int? V0, int? V1, int? V2, int? V3);

    public static void Apply(HlslBlockStatement root)
    {
        var names = new Dictionary<RegKey, string>();

        // Copy chains (r1 = r0; r2 = r1; ...) need one pass per hop to
        // fully propagate regardless of the order statements happen to
        // appear in — iterate to a fixed point rather than assuming a
        // single top-to-bottom pass suffices.
        bool changed = true;
        for (int pass = 0; changed && pass < 16; pass++)
        {
            changed = false;
            foreach ((IRRegister dest, IRExpression expr) in EnumerateAssignments(root))
            {
                if (expr is not IRExpression.RegisterExpression re)
                    continue;

                string? sourceName = re.Register.SymbolicName
                    ?? (names.TryGetValue(KeyOf(re.Register), out var n) ? n : null);

                if (sourceName is null)
                    continue;

                RegKey key = KeyOf(dest);
                if (!names.TryGetValue(key, out string? existing) || existing != sourceName)
                {
                    names[key] = sourceName;
                    changed = true;
                }
            }
        }

        // Apply to every occurrence (definitions AND reads) of a matching
        // temp throughout the function — mutates the shared IRRegister
        // instances in place, so this also improves the existing raw
        // ToString() debug dumps in Program.cs for free.
        foreach (IRRegister reg in EnumerateAllRegisters(root))
        {
            if (reg.SymbolicName is not null) continue;
            if (reg.RegisterType != RegisterType.Temp) continue;
            if (names.TryGetValue(KeyOf(reg), out string? name))
                reg.SymbolicName = name;
        }
    }

    private static RegKey KeyOf(IRRegister reg) =>
        new(reg.RegisterType, reg.Index, reg.SsaVersion[0], reg.SsaVersion[1], reg.SsaVersion[2], reg.SsaVersion[3]);

    private static IEnumerable<(IRRegister Dest, IRExpression Expr)> EnumerateAssignments(HlslStatementNode node)
    {
        switch (node)
        {
            case HlslBlockStatement b:
                foreach (var s in b.Statements)
                    foreach (var r in EnumerateAssignments(s))
                        yield return r;
                break;

            case HlslAssignmentStatement a:
                yield return (a.Destination, a.Expression);
                break;

            case HlslIfStatement iff:
                foreach (var r in EnumerateAssignments(iff.Then)) yield return r;
                if (iff.Else is not null)
                    foreach (var r in EnumerateAssignments(iff.Else)) yield return r;
                break;

            case HlslLoopStatement loop:
                foreach (var r in EnumerateAssignments(loop.Body)) yield return r;
                break;

            case HlslSwitchStatement sw:
                foreach (var c in sw.Cases)
                    foreach (var r in EnumerateAssignments(c.Body))
                        yield return r;
                break;
        }
    }

    private static IEnumerable<IRRegister> EnumerateAllRegisters(HlslStatementNode node)
    {
        switch (node)
        {
            case HlslBlockStatement b:
                foreach (var s in b.Statements)
                    foreach (var r in EnumerateAllRegisters(s))
                        yield return r;
                break;

            case HlslAssignmentStatement a:
                yield return a.Destination;
                foreach (var r in a.Destination.IndexRegisterUses()) yield return r;
                foreach (var r in a.Expression.CollectRegisterUses()) yield return r;
                break;

            case HlslMultiAssignmentStatement ma:
                for (int idx = 0; idx < ma.Destinations.Count; idx++)
                {
                    if (ma.Destinations[idx] is { } d)
                    {
                        yield return d;
                        foreach (var r in d.IndexRegisterUses()) yield return r;
                    }
                }
                foreach (var e in ma.Expressions)
                    foreach (var r in e.CollectRegisterUses())
                        yield return r;
                break;

            case HlslIfStatement iff:
                foreach (var r in iff.Condition.CollectRegisterUses()) yield return r;
                foreach (var r in EnumerateAllRegisters(iff.Then)) yield return r;
                if (iff.Else is not null)
                    foreach (var r in EnumerateAllRegisters(iff.Else)) yield return r;
                break;

            case HlslLoopStatement loop:
                foreach (var r in EnumerateAllRegisters(loop.Body)) yield return r;
                break;

            case HlslSwitchStatement sw:
                foreach (var r in sw.Selector.CollectRegisterUses()) yield return r;
                foreach (var c in sw.Cases)
                {
                    if (c.Value is not null)
                        foreach (var r in c.Value.CollectRegisterUses()) yield return r;
                    foreach (var r in EnumerateAllRegisters(c.Body)) yield return r;
                }
                break;

            case HlslBreakStatement br when br.Condition is not null:
                foreach (var r in br.Condition.CollectRegisterUses()) yield return r;
                break;

            case HlslContinueStatement co when co.Condition is not null:
                foreach (var r in co.Condition.CollectRegisterUses()) yield return r;
                break;

            case HlslReturnStatement ret when ret.Condition is not null:
                foreach (var r in ret.Condition.CollectRegisterUses()) yield return r;
                break;

            case HlslDiscardStatement disc:
                foreach (var r in disc.Condition.CollectRegisterUses()) yield return r;
                break;

            case HlslMemoryStoreStatement ms:
                yield return ms.Resource;
                foreach (var r in ms.Resource.IndexRegisterUses()) yield return r;
                foreach (var r in ms.Address.CollectRegisterUses()) yield return r;
                foreach (var r in ms.Value.CollectRegisterUses()) yield return r;
                break;

            // Fallback wrapper (atomics, barriers, GS emit/cut, hull phases,
            // phi, dynamic-linkage calls) — reuse the original IRStatement's
            // own Defines/Uses rather than re-deriving them here.
            case HlslRawStatement raw:
                foreach (var r in raw.Source.Defines) yield return r;
                foreach (var r in raw.Source.Uses) yield return r;
                break;
        }
    }
}