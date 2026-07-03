namespace Parser.DXBC.Instructions;

public enum RegisterType
{
    Temp,

    Input,

    Output,

    ConstantBuffer,

    Sampler,

    Resource,

    Immediate32,

    Immediate64,

    Unknown
}