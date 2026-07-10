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
    }

    public sealed class IRInputDeclaration : IRDeclaration
    {
        public uint Register { get; init; }

        // Only set for dcl_input_sgv (system-generated-value inputs, e.g. vertex/instance id)
        public uint? SystemValue { get; init; }
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
}