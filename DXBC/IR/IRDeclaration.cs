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
}