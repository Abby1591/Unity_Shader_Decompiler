namespace Parser.DXBC.Instructions;

public enum Opcode
{
    Add = 0,
    And = 1,
    Break = 2,
    BreakC = 3,
    Call = 4,

    Mov = 54,
    Mul = 56,
    Mad = 50,
    Dp3 = 65,
    Sample = 69,
    SampleL = 72,
    Rsq = 77,
    Ret = 62,

    Unknown = 9999
}