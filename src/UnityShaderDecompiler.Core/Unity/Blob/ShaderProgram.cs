using System.Text.RegularExpressions;

namespace AssetStudio;

public class ShaderProgram
{
    public ShaderSubProgramEntry[] entries;
    public ShaderSubProgram[] m_SubPrograms;

    public ShaderProgram(BinaryReader reader, int[] version)
    {
        var subProgramsCapacity = reader.ReadInt32();
        entries = new ShaderSubProgramEntry[subProgramsCapacity];
        for (int i = 0; i < subProgramsCapacity; i++)
        {
            entries[i] = new ShaderSubProgramEntry(reader, version);
        }
        m_SubPrograms = new ShaderSubProgram[subProgramsCapacity];
    }

    public void Read(BinaryReader reader, int segment)
    {
        for (int i = 0; i < entries.Length; i++)
        {
            var entry = entries[i];
            if (entry.Segment == segment)
            {
                reader.BaseStream.Position = entry.Offset;
                try
                {
                    m_SubPrograms[i] = new ShaderSubProgram(reader);
                }
                catch (Exception)
                {
                    // Non-DX11 subprogram formats (e.g. GLES) can lay out the
                    // header differently than the DX11 path expects; skipping
                    // a bad subprogram lets the rest of the blob still parse.
                    m_SubPrograms[i] = null;
                }
            }
        }
    }

    public string Export(string shader)
    {
        var evaluator = new MatchEvaluator(match =>
        {
            var index = int.Parse(match.Groups[1].Value);
            return m_SubPrograms[index].Export();
        });
        shader = Regex.Replace(shader, "GpuProgramIndex (.+)", evaluator);
        return shader;
    }
}