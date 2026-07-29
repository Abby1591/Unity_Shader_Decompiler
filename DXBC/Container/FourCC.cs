namespace Parser.DXBC.Container;

public readonly struct FourCC : IEquatable<FourCC>
{
    public readonly uint Value;

    public FourCC(uint value)
    {
        Value = value;
    }

    public FourCC(string text)
    {
        if (text.Length != 4)
            throw new ArgumentException("FourCC must be exactly four characters.");

        Value =
            (uint)text[0] |
            ((uint)text[1] << 8) |
            ((uint)text[2] << 16) |
            ((uint)text[3] << 24);
    }

    public override string ToString()
    {
        return new string(new[]
        {
            (char)(Value & 0xFF),
            (char)((Value >> 8) & 0xFF),
            (char)((Value >> 16) & 0xFF),
            (char)((Value >> 24) & 0xFF)
        });
    }

    public bool Equals(FourCC other) => Value == other.Value;
    public override bool Equals(object? obj) => obj is FourCC other && Equals(other);
    public override int GetHashCode() => (int)Value;

    public static bool operator ==(FourCC left, FourCC right) => left.Equals(right);
    public static bool operator !=(FourCC left, FourCC right) => !left.Equals(right);

    public static readonly FourCC ISGN = new("ISGN");
    public static readonly FourCC OSGN = new("OSGN");
    public static readonly FourCC SHDR = new("SHDR");
    public static readonly FourCC SHEX = new("SHEX");
    public static readonly FourCC RDEF = new("RDEF");
    public static readonly FourCC STAT = new("STAT");
    public static readonly FourCC OSG5 = new("OSG5");
    public static readonly FourCC PSGN = new("PSGN");
    public static readonly FourCC ISG1 = new("ISG1");
}