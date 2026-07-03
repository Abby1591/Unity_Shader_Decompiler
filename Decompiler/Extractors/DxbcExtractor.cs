using System;

namespace Parser;

public static class DxbcExtractor
{
    public static byte[] Extract(ShaderSubProgram subProgram)
    {
        int offset = FindDxbc(subProgram.m_ProgramCode);

        if (offset < 0)
            throw new InvalidOperationException("DXBC not found.");

        byte[] result = new byte[subProgram.m_ProgramCode.Length - offset];

        Buffer.BlockCopy(
            subProgram.m_ProgramCode,
            offset,
            result,
            0,
            result.Length);

        return result;
    }

    private static int FindDxbc(byte[] data)
    {
        for (int i = 0; i <= data.Length - 4; i++)
        {
            if (data[i] == 'D' &&
                data[i + 1] == 'X' &&
                data[i + 2] == 'B' &&
                data[i + 3] == 'C')
            {
                return i;
            }
        }

        return -1;
    }
}