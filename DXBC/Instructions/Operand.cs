using System.Linq;

namespace Parser.DXBC.Instructions;

public class Operand
{
    public RegisterType RegisterType { get; set; }

    // The raw 8-bit register type field from the token, kept alongside the
    // enum. Future shader models can add register types this enum doesn't
    // know about yet (decoded as RegisterType.Unknown) - keeping the raw
    // bits means decode -> optimize -> re-encode doesn't silently drop them.
    public byte RawRegisterType { get; set; }

    public uint RegisterIndex { get; set; }

    // RegisterIndex as originally decoded, before any later pass (e.g. SSA
    // renaming) reassigns it. Preserved for debugging/reconstruction.
    public uint OriginalRegisterIndex { get; set; }

    // Number of register indices this operand was encoded with (0-3), i.e.
    // indexCount from the token's "order" field. Stored explicitly so later
    // passes don't need to recompute it from Indices.Count / raw bits.
    public int IndexCount { get; set; }

    // True for Immediate32/Immediate64 operands. Equivalent to checking
    // RegisterType directly, just less noisy at call sites.
    public bool IsImmediate =>
        RegisterType == RegisterType.Immediate32 || RegisterType == RegisterType.Immediate64;

    public int NumComponents { get; set; }

    public OperandComponentMode ComponentMode;

    public OperandIndexRepresentation[] IndexRepresentation = new OperandIndexRepresentation[3];

    public bool IsExtended { get; set; }

    // The raw, unmodified first operand token (OperandToken0). Kept so
    // optimization/reconstruction passes can recover any bits Microsoft's
    // compiler stuffs into fields this parser doesn't yet interpret,
    // without having to re-derive the token from the decoded fields.
    public uint RawToken { get; set; }

    // Every extension token read for this operand, in stream order,
    // raw and unmodified - including ones this parser doesn't currently
    // decode further (see ShdrParser.DecodeOperand's extension-type
    // switch). Nothing read off the wire is discarded.
    public List<uint> ExtensionTokens { get; } = new();

    public byte Mask { get; set; }

    public byte Swizzle { get; set; }

    public byte Component { get; set; }

    public List<uint> Indices { get; } = new();

    // Convenience accessors over Indices - avoids Indices[0]/[1]/[2] with
    // bounds-checking littered across every consumer.
    public uint Index0 => Indices.Count > 0 ? Indices[0] : 0;
    public uint Index1 => Indices.Count > 1 ? Indices[1] : 0;
    public uint Index2 => Indices.Count > 2 ? Indices[2] : 0;
    
    public uint[]? Immediate32Values;
    
    public double[]? Immediate64Values;
    
    public Operand?[] RelativeOperands = new Operand?[3];
    
    public ShdrParser.OperandModifier Modifier { get; set; } = ShdrParser.OperandModifier.None;

    // ---- typed immediate accessors -------------------------------------
    // Immediate32Values is stored as raw bits (uint[]) since the same
    // token could be reinterpreted as float or int depending on how the
    // consuming instruction uses it. These expose all three views without
    // requiring callers to bit-cast manually - handy when reconstructing
    // HLSL literals (e.g. 0x3F800000 -> 1.0f).

    public float[] ImmediateFloats =>
        Immediate32Values?.Select(v => BitConverter.Int32BitsToSingle((int)v)).ToArray() ?? Array.Empty<float>();

    public int[] ImmediateInts =>
        Immediate32Values?.Select(v => unchecked((int)v)).ToArray() ?? Array.Empty<int>();

    public uint[] ImmediateUInts => Immediate32Values ?? Array.Empty<uint>();
    
    public float GetImmediateFloat(int index)
    {
        return BitConverter.Int32BitsToSingle((int)Immediate32Values![index]);
    }

    public int GetImmediateInt(int index)
    {
        return unchecked((int)Immediate32Values![index]);
    }

    public uint GetImmediateUInt(int index)
    {
        return Immediate32Values![index];
    }
    
    private static string DecodeSwizzle(byte swizzle)
    {
        char[] c = { 'x', 'y', 'z', 'w' };

        return new string(new[]
        {
            c[(swizzle >> 0) & 3],
            c[(swizzle >> 2) & 3],
            c[(swizzle >> 4) & 3],
            c[(swizzle >> 6) & 3]
        });
    }
    
    public string GetComponentString()
    {
        switch (ComponentMode)
        {
            case OperandComponentMode.Mask:
                return "." + DecodeMask(Mask);

            case OperandComponentMode.Swizzle:
                return "." + DecodeSwizzle(Swizzle);

            case OperandComponentMode.Select1:
                return "." + "xyzw"[Component];

            default:
                return "";
        }
    }
    
    private static string DecodeMask(byte mask)
    {
        string s = "";

        if ((mask & 1) != 0) s += "x";
        if ((mask & 2) != 0) s += "y";
        if ((mask & 4) != 0) s += "z";
        if ((mask & 8) != 0) s += "w";

        return s;
    }
    
    public override string ToString()
    {
        if (RegisterType == RegisterType.Immediate32 && Immediate32Values != null)
        {
            return "l(" + string.Join(", ", Immediate32Values.Select(v => BitConverter.Int32BitsToSingle((int)v))) + ")";
        }

        if (RegisterType == RegisterType.Immediate64 && Immediate64Values != null)
            return "d(" + string.Join(", ", Immediate64Values) + ")";
        
        string reg = RegisterType switch
        {
            RegisterType.Temp => $"r{RegisterIndex}",
            RegisterType.Input => $"v{RegisterIndex}",
            RegisterType.Output => $"o{RegisterIndex}",
            RegisterType.ConstantBuffer => $"cb{RegisterIndex}",
            RegisterType.Resource => $"t{RegisterIndex}",
            RegisterType.Sampler => $"s{RegisterIndex}",
            RegisterType.Immediate32 => "l",
            RegisterType.Null => "null",
            _ => $"{RegisterType}{RegisterIndex}"
        };

        return reg + GetComponentString();
    }
    
    public enum OperandNumComponents
    {
        Zero = 0,
        One = 1,
        Four = 2,
        N = 3
    }

    public enum OperandComponentSelectionMode
    {
        Mask = 0,
        Swizzle = 1,
        Select1 = 2
    }
    
    
    public enum OperandComponentMode
    {
        Mask = 0,
        Swizzle = 1,
        Select1 = 2
    }

    public enum OperandIndexRepresentation
    {
        Immediate32 = 0,
        Immediate64 = 1,
        Relative = 2,
        Immediate32PlusRelative = 3,
        Immediate64PlusRelative = 4
    }
    
}