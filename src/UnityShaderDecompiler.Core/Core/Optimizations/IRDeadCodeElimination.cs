using Parser.DXBC.IR;
using Parser.Core.Analysis;

namespace Parser.Core.Optimizations;

// Phase 9.4: removes IRAssignment/IRPhi statements whose result is never
// read anywhere. Only ever touches pure statement types — anything that
// can affect memory or execution beyond its own destination register
// (IRMemoryStore, IRAtomicOp, texture sample side effects, branches,
// calls, ...) is left alone even if its result register goes unused.
//
// Liveness is tracked per SSA version, not per physical register: a phi
// that defines e.g. r9.z_8 is dead even if some *other* version of r9.z
// is read elsewhere in the program (physical-location-only tracking would
// keep it, and it would survive down to IRLeaveSsa, where its versionless
// operands — registers never written on that path — leak phantom
// identifiers into the HLSL). A def whose destination carries no version
// at all falls back to the conservative physical-location check.
public static class IRDeadCodeElimination
{
    public static bool Run(List<IRBlock> blocks)
    {
        // Exact (location, version) pairs read by the whole program.
        var readVersions = new HashSet<(IRStorageLocation Loc, int Version)>();
        // Physical locations read by any versioned operand — only used as a
        // conservative fallback for defs that carry no version of their own.
        var usedLocations = new HashSet<IRStorageLocation>();

        foreach (IRBlock block in blocks)
        {
            foreach (IRStatement stmt in block.Statements)
            {
                foreach (IRRegister reg in stmt.Uses)
                {
                    foreach (IRStorageLocation loc in IRStorageLocation.ReadLocationsOf(reg))
                    {
                        int? version = reg.SsaVersion[IRStorageLocation.ComponentToIndex(loc.Component)];
                        if (version is { } v)
                        {
                            readVersions.Add((loc, v));
                            usedLocations.Add(loc);
                        }
                    }
                }
            }
        }

        bool changed = false;

        foreach (IRBlock block in blocks)
        {
            for (int i = block.Statements.Count - 1; i >= 0; i--)
            {
                IRStatement stmt = block.Statements[i];

                if (!IsRemovable(stmt))
                    continue;

                bool anyUsed = false;
                foreach (IRRegister def in stmt.Defines)
                {
                    foreach (IRStorageLocation loc in IRStorageLocation.WriteLocationsOf(def))
                    {
                        int? version = def.SsaVersion[IRStorageLocation.ComponentToIndex(loc.Component)];
                        // Versionless reads (un-renamed phi operands: the
                        // register was never written on that path) mean
                        // "don't care" — they don't keep a versioned def
                        // alive. A def with no version of its own falls back
                        // to the physical-location check.
                        if (version is { } v)
                            anyUsed = readVersions.Contains((loc, v));
                        else
                            anyUsed = usedLocations.Contains(loc);

                        if (anyUsed)
                            break;
                    }
                    if (anyUsed)
                        break;
                }

                if (!anyUsed)
                {
                    block.Statements.RemoveAt(i);
                    changed = true;
                }
            }
        }

        return changed;
    }

    private static bool IsRemovable(IRStatement stmt)
    {
        if (stmt is not (IRStatement.IRAssignment or IRStatement.IRPhi))
            return false;

        // Output-register writes ARE the shader's result — nothing in-function
        // reads them, so never treat them as dead just because usedLocations
        // has no entry for them.
        if (stmt.Defines.Any(r => r.RegisterType == RegisterType.Output))
            return false;

        return true;
    }
}
