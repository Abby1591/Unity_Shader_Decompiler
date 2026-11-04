using UnityShaderDecompiler.Core.DXBC.Container;

namespace UnityShaderDecompiler.Core.DXBC;

public class DxbcChunk
{
    public FourCC Name { get; set; }

    public uint Offset { get; set; }

    public uint Size { get; set; }

    public byte[] Data { get; set; } = [];
}