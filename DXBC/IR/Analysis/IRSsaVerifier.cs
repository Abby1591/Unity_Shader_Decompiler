using Parser.DXBC.IR;

namespace Parser.DXBC.IR.Analysis;

public sealed class IRSsaVerificationResult
{
    public List<string> Errors { get; } = new();

    public bool IsValid => Errors.Count == 0;
}

// Phase 8: every optimization pass from here on (Phase 9+) can — and
// should — run this afterward. Catches the three things that actually
// matter for SSA correctness:
//   1. every SSA value (location, version) is defined exactly once
//   2. every read's version has a def that actually produced it
//   3. every PHI has exactly one operand per predecessor edge
public static class IRSsaVerifier
{
    public static IRSsaVerificationResult Verify(List<IRBlock> blocks)
    {
        var result = new IRSsaVerificationResult();
        var definedBy = new Dictionary<(IRStorageLocation Loc, int Version), int>();

        // Pass 1: collect every definition, flagging duplicates and
        // anything that reached the verifier without ever being renamed.
        foreach (IRBlock block in blocks)
        {
            foreach (IRStatement stmt in block.Statements)
            {
                foreach (IRRegister reg in stmt.Defines)
                {
                    foreach (IRStorageLocation loc in IRStorageLocation.WriteLocationsOf(reg))
                    {
                        int? version = reg.SsaVersion[IRStorageLocation.ComponentToIndex(loc.Component)];

                        if (version is null)
                        {
                            result.Errors.Add(
                                $"Statement #{stmt.Id} defines {loc} but it was never SSA-renamed.");
                            continue;
                        }

                        (IRStorageLocation loc, int Value) key = (loc, version.Value);

                        if (definedBy.TryGetValue(key, out int existingId))
                            result.Errors.Add(
                                $"{loc}_{version} is defined more than once (statements #{existingId} and #{stmt.Id}).");
                        else
                            definedBy[key] = stmt.Id;
                    }
                }
            }
        }

        // Pass 2: every read must resolve to something Pass 1 saw defined,
        // and every PHI must have exactly one operand per predecessor.
        foreach (IRBlock block in blocks)
        {
            foreach (IRStatement stmt in block.Statements)
            {
                if (stmt is IRStatement.IRPhi phi && phi.Operands.Count != block.Predecessors.Count)
                {
                    result.Errors.Add(
                        $"Statement #{stmt.Id}: phi has {phi.Operands.Count} operand(s) but " +
                        $"block {block.Id} has {block.Predecessors.Count} predecessor(s).");
                }

                foreach (IRRegister reg in stmt.Uses)
                {
                    foreach (IRStorageLocation loc in IRStorageLocation.ReadLocationsOf(reg))
                    {
                        int? version = reg.SsaVersion[IRStorageLocation.ComponentToIndex(loc.Component)];

                        if (version is null)
                            continue; // implicit function input — never defined in-program, that's fine

                        if (!definedBy.ContainsKey((loc, version.Value)))
                            result.Errors.Add(
                                $"Statement #{stmt.Id} reads {loc}_{version} but no statement defines it.");
                    }
                }
            }
        }

        return result;
    }
}
