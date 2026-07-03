namespace Parser;

public class ShaderSubProgramEntry
{
    public int Offset;
    public int Length;
    public int Segment;

    public ShaderSubProgramEntry(BinaryReader reader, int[] version)
    {
        Offset = reader.ReadInt32();
        Length = reader.ReadInt32();
        if (version[0] > 2019 || (version[0] == 2019 && version[1] >= 3)) //2019.3 and up
        {
            Segment = reader.ReadInt32();
        }
    }
}