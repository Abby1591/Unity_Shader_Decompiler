namespace Parser.DXBC.Chunks;

public class SignatureElement
{
    public string SemanticName = "";
    public uint SemanticIndex;

    public uint SystemValue;
    public uint ComponentType;

    public uint Register;
    public byte Mask;
    public byte ReadWriteMask;
    public uint Stream; // only used by OSG5

    public override string ToString()
    {
        return
            $"{SemanticName}{SemanticIndex,-2} " +
            $"Reg={Register,-2} " +
            $"Mask=0x{Mask:X2} " +
            $"Type={ComponentType}";
    }
}