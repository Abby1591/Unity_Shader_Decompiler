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
    }

    public sealed class IROutputDeclaration : IRDeclaration
    {
        public uint Register { get; init; }
    }
    
    public sealed class IRTempDeclaration : IRDeclaration
    {
        public uint Count { get; init; }
    }
}