using System.Text;
using UnityShaderDecompiler.Core.DXBC.Container;

namespace UnityShaderDecompiler.Core.DXBC;

public static class BinaryReaderExtensions
{
    public static FourCC ReadFourCC(this BinaryReader reader)
    {
        return new FourCC(reader.ReadUInt32());
    }
    
    public static string ReadNullTerminatedString(this BinaryReader reader)
    {
        List<byte> bytes = new();

        while (true)
        {
            byte b = reader.ReadByte();

            if (b == 0)
                break;

            bytes.Add(b);
        }

        return Encoding.ASCII.GetString(bytes.ToArray());
    }
}