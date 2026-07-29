namespace Parser.DXBC.IR;

public abstract class IRDeclaration
{
    public sealed class IRConstantBufferDeclaration : IRDeclaration
    {
        public uint Slot { get; init; }
    }

    public sealed class IRSamplerDeclaration : IRDeclaration
    {
        public uint Slot { get; init; }
    }

    public sealed class IRResourceDeclaration : IRDeclaration
    {
        public uint Slot { get; init; }

        // Decoded from instruction.ExtraData[0] (already captured by ShdrParser
        // for dcl_resource, previously left as an uninterpreted uint).
        public ResourceDimension Dimension { get; init; } = ResourceDimension.Unknown;
    }

    public sealed class IRInputDeclaration : IRDeclaration
    {
        public uint Register { get; init; }

        // Only set for dcl_input_sgv (system-generated-value inputs, e.g. vertex/instance id)
        public uint? SystemValue { get; init; }

        // Only meaningful for dcl_input_ps — see InterpolationMode.cs for why
        // this isn't decoded from the token yet.
        public InterpolationMode Interpolation { get; init; } = InterpolationMode.Undefined;
    }

    public sealed class IROutputDeclaration : IRDeclaration
    {
        public uint Register { get; init; }

        // Only set for dcl_output_siv (system-interpreted-value outputs, e.g. SV_Position)
        public uint? SystemValue { get; init; }
    }

    public sealed class IRTempDeclaration : IRDeclaration
    {
        public uint Count { get; init; }
    }

    public sealed class IRGlobalFlagsDeclaration : IRDeclaration
    {
        public uint Flags { get; init; }
    }

    public sealed class IRUAVDeclaration : IRDeclaration
    {
        public uint Slot { get; init; }

        public ResourceDimension Dimension { get; init; } = ResourceDimension.Unknown;
    }

    public sealed class IRThreadGroupDeclaration : IRDeclaration
    {
        public uint X { get; init; }
        public uint Y { get; init; }
        public uint Z { get; init; }
    }

    public sealed class IRIndexRangeDeclaration : IRDeclaration
    {
        public uint Register { get; init; }
        public uint Count { get; init; }
    }

    public sealed class IRFunctionBodyDeclaration : IRDeclaration
    {
        public uint Index { get; init; }
    }

    public sealed class IRFunctionTableDeclaration : IRDeclaration
    {
        public uint Index { get; init; }
    }

    // dcl_indexable_temp: indexable temp array (x#[n], used for dynamic indexing)
    public sealed class IRIndexableTempDeclaration : IRDeclaration
    {
        public uint Register { get; init; }
        public uint Count { get; init; }
        public uint ComponentCount { get; init; }
    }

    // dcl_stream: active geometry-shader output stream (SM5 multi-stream GS)
    public sealed class IRStreamDeclaration : IRDeclaration
    {
        public uint Index { get; init; }
    }

    // dcl_interface: SM5 interface/class slot table for dynamic linkage
    public sealed class IRInterfaceDeclaration : IRDeclaration
    {
        public uint Index { get; init; }
        public uint NumTypes { get; init; }
        public uint TableLength { get; init; }
    }

    // ===================== hull / domain shader =====================
    // These carry values encoded directly in their opcode tokens rather than
    // a trailing ExtraData DWORD or an Operand — exact bit layout needs
    // confirming against shader_sm4.c before wiring up decode, same caveat
    // as InterpolationMode. Fields are provided so that's a one-line change.

    public sealed class IRInputControlPointCountDeclaration : IRDeclaration
    {
        public uint Count { get; init; }
    }

    public sealed class IROutputControlPointCountDeclaration : IRDeclaration
    {
        public uint Count { get; init; }
    }

    public sealed class IRMaxTessFactorDeclaration : IRDeclaration
    {
        public float Value { get; init; }
    }

    public enum TessellatorDomain
    {
        Undefined = 0,
        Isoline = 1,
        Tri = 2,
        Quad = 3,
    }

    public sealed class IRDomainDeclaration : IRDeclaration
    {
        public TessellatorDomain Domain { get; init; }
    }

    public enum TessellatorPartitioning
    {
        Undefined = 0,
        Integer = 1,
        Pow2 = 2,
        FractionalOdd = 3,
        FractionalEven = 4,
    }

    public sealed class IRPartitioningDeclaration : IRDeclaration
    {
        public TessellatorPartitioning Partitioning { get; init; }
    }

    public enum TessellatorOutputPrimitive
    {
        Undefined = 0,
        Point = 1,
        Line = 2,
        TriangleClockwise = 3,
        TriangleCounterclockwise = 4,
    }

    public sealed class IROutputTopologyDeclaration : IRDeclaration
    {
        public TessellatorOutputPrimitive Topology { get; init; }
    }

    // ============================================================
    // Raw/structured resource & UAV/TGSM declarations (opcodes 157-162)
    // ============================================================

    public sealed class IRUAVRawDeclaration : IRDeclaration
    {
        public uint Slot { get; init; }
    }

    public sealed class IRUAVStructuredDeclaration : IRDeclaration
    {
        public uint Slot { get; init; }
        public uint StructureStride { get; init; }
    }

    public sealed class IRTGSMRawDeclaration : IRDeclaration
    {
        public uint Slot { get; init; }
        public uint ByteCount { get; init; }
    }

    public sealed class IRTGSMStructuredDeclaration : IRDeclaration
    {
        public uint Slot { get; init; }
        public uint StructureStride { get; init; }
        public uint ElementCount { get; init; }
    }

    public sealed class IRResourceRawDeclaration : IRDeclaration
    {
        public uint Slot { get; init; }
    }

    public sealed class IRResourceStructuredDeclaration : IRDeclaration
    {
        public uint Slot { get; init; }
        public uint StructureStride { get; init; }
    }

    // ============================================================
    // Instance/phase counts (opcodes 153, 154, 206)
    // ============================================================

    public sealed class IRHSForkPhaseInstanceCountDeclaration : IRDeclaration
    {
        public uint Count { get; init; }
    }

    public sealed class IRHSJoinPhaseInstanceCountDeclaration : IRDeclaration
    {
        public uint Count { get; init; }
    }

    public sealed class IRGSInstanceCountDeclaration : IRDeclaration
    {
        public uint Count { get; init; }
    }
}