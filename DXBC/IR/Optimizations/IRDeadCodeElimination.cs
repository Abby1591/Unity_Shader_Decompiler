using Parser.DXBC.IR;
using Parser.DXBC.IR.Analysis;

namespace Parser.DXBC.IR.Optimizations;

// Phase 9.4: removes IRAssignment/IRPhi statements whose result is never
// read anywhere. Only ever touches pure statement types — anything that
// can affect memory or execution beyond its own destination register
// (IRMemoryStore, IRAtomicOp, texture sample side effects, branches,
// calls, ...) is left alone even if its result register goes unused.
public static class IRDeadCodeElimination
{
    public static bool Run(List<IRBlock> blocks)
    {
        var usedLocations = new HashSet<IRStorageLocation>();

        foreach (IRBlock block in blocks)
        {
            foreach (IRStatement stmt in block.Statements)
            {
                foreach (IRRegister reg in stmt.Uses)
                    foreach (IRStorageLocation loc in IRStorageLocation.ReadLocationsOf(reg))
                        usedLocations.Add(loc);
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

                bool anyUsed = stmt.Defines.SelectMany(IRStorageLocation.WriteLocationsOf).Any(usedLocations.Contains);

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
