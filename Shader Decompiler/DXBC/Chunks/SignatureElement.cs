namespace Parser.DXBC.Chunks;

public class SignatureElement
{
    public string SemanticName = "";
    public uint SemanticIndex;

    public uint SystemValue;
    public uint ComponentType;

    // Signature-chunk SystemValue fields are D3D_NAME (d3dcommon.h) values —
    // distinct from the D3D10_SB_NAME numbering the instruction stream uses.
    // The raw uint is preserved above; this is its readable interpretation.
    public string SystemValueName => SystemValue.ToSignatureSystemValue().ToString();

    // D3D_REGISTER_COMPONENT_TYPE readable form (verified against
    // Microsoft's d3dcommon.h: 0=unknown, 1=uint32, 2=sint32, 3=float32).
    public string ComponentTypeName => ComponentType switch
    {
        1 => "uint",
        2 => "int",
        3 => "float",
        _ => "unknown"
    };

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
            $"Type={ComponentType} " +
            $"SV={SystemValueName}";
    }
}