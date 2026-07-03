using System;

namespace Parser.Decompiler;

public sealed class HlslGenerator : IDxbcDecompiler
{
    public string Decompile(byte[] dxbc)
    {
        if (dxbc == null)
            throw new ArgumentNullException(nameof(dxbc));

        if (dxbc.Length < 4)
            throw new ArgumentException("Invalid DXBC shader.");

        if (dxbc[0] != 'D' ||
            dxbc[1] != 'X' ||
            dxbc[2] != 'B' ||
            dxbc[3] != 'C')
        {
            throw new ArgumentException("Not a DXBC shader.");
        }

        return DxbcDisassembler.Disassemble(dxbc);
    }
}