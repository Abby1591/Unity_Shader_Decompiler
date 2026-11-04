using Parser.DXBC.Instructions;
using Parser.DXBC.IR;

namespace Parser.Core.Analysis;

// Identifies a single scalar component of a register (e.g. "r0.x") by
// value rather than by object identity. Two IRRegister instances that
// both mean r0.x are two different .NET objects — nothing in the IR
// layer interns them — so DEF/USE, liveness, dominance, and SSA renaming
// all need this instead of comparing IRRegister references directly.
//
// Dynamically-indexed locations (cb0[r2.x], x0[r2.y]) can't be resolved
// to a precise slot at this level, so they collapse to one location per
// register file+bank with Dynamic=true — conservative (may over-report
// interference between different dynamic indices into the same bank)
// rather than silently wrong.
public readonly record struct IRStorageLocation(
    RegisterType RegisterType,
    uint Bank,
    uint Slot,
    bool Dynamic,
    char Component)
{
    public override string ToString()
    {
        string name = RegisterType switch
        {
            RegisterType.Temp => $"r{Bank}",
            RegisterType.Input => $"v{Bank}",
            RegisterType.Output => $"o{Bank}",
            RegisterType.ConstantBuffer => Dynamic ? $"cb{Bank}[?]" : $"cb{Bank}[{Slot}]",
            RegisterType.IndexableTemp => Dynamic ? $"x{Bank}[?]" : $"x{Bank}[{Slot}]",
            _ => $"{RegisterType.ToString().ToLower()}{Bank}"
        };

        return $"{name}.{Component}";
    }

    // Locations a statement DEFINES by writing to `reg` — driven by its
    // write mask (reg.Mask), one location per set bit.
    public static IEnumerable<IRStorageLocation> WriteLocationsOf(IRRegister reg)
    {
        foreach (char c in ComponentsFromMask(reg.Mask))
            yield return Of(reg, c);
    }

    // Locations a statement READS via `reg`. Select1 gives one exact
    // component; Swizzle/Mask give up to four; anything else (a bare
    // register with no per-component info) is treated conservatively as
    // touching all four components.
    public static IEnumerable<IRStorageLocation> ReadLocationsOf(IRRegister reg)
    {
        IEnumerable<char> components = reg.ComponentMode switch
        {
            Operand.OperandComponentMode.Select1 => new[] { ComponentToChar(reg.Component) },
            Operand.OperandComponentMode.Swizzle => new[]
            {
                ComponentToChar((byte)(reg.Swizzle & 3)),
                ComponentToChar((byte)((reg.Swizzle >> 2) & 3)),
                ComponentToChar((byte)((reg.Swizzle >> 4) & 3)),
                ComponentToChar((byte)((reg.Swizzle >> 6) & 3)),
            },
            Operand.OperandComponentMode.Mask => ComponentsFromMask(reg.Mask),
            _ => new[] { 'x', 'y', 'z', 'w' }
        };

        foreach (char c in components)
            yield return Of(reg, c);
    }

    private static IRStorageLocation Of(IRRegister reg, char component)
    {
        uint bank = reg.Indices.Count > 0 ? reg.Indices[0] : reg.Index;
        uint slot = reg.Indices.Count > 1 ? reg.Indices[1] : 0;

        bool dynamic = reg.RelativeIndices[0] is not null
            || (reg.Indices.Count > 1 && reg.RelativeIndices[1] is not null);

        return new IRStorageLocation(reg.RegisterType, bank, dynamic ? 0 : slot, dynamic, component);
    }

    private static IEnumerable<char> ComponentsFromMask(byte mask)
    {
        if ((mask & 1) != 0) yield return 'x';
        if ((mask & 2) != 0) yield return 'y';
        if ((mask & 4) != 0) yield return 'z';
        if ((mask & 8) != 0) yield return 'w';
    }

    private static char ComponentToChar(byte c) => c switch
    {
        0 => 'x',
        1 => 'y',
        2 => 'z',
        3 => 'w',
        _ => '?'
    };

    // Round-trips this location back into a concrete IRRegister — needed
    // by PHI insertion (Phase 6), which has to synthesize brand new
    // register operands/destinations that didn't come from a real DXBC
    // instruction. Produces a single-component (Select1) register;
    // callers that want a write destination with this as its sole
    // written component should leave it as-is (ComponentMode stays
    // Select1, matching how single-component writes already render).
    public IRRegister ToRegister()
    {
        var reg = new IRRegister
        {
            RegisterType = RegisterType,
            ComponentMode = Operand.OperandComponentMode.Select1,
            Component = ComponentToIndex(Component),
            // WriteLocationsOf reads Mask (not ComponentMode) to decide
            // what a register defines, so this needs both set: Mask for
            // when this register is used as a def, ComponentMode+Component
            // for when it's used as a single-component read (e.g. a PHI
            // operand).
            Mask = (byte)(1 << ComponentToIndex(Component)),
        };

        if (RegisterType is RegisterType.ConstantBuffer or RegisterType.IndexableTemp)
        {
            reg.Indices.Add(Bank);
            if (!Dynamic)
                reg.Indices.Add(Slot);
        }
        else
        {
            reg.Index = Bank;
        }

        return reg;
    }

    public static byte ComponentToIndex(char c) => c switch
    {
        'x' => 0,
        'y' => 1,
        'z' => 2,
        'w' => 3,
        _ => 0
    };
}
