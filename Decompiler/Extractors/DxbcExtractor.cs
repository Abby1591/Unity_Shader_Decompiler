using System;

namespace Parser;

// The 0x26-byte header UnityShaderCompiler.exe prefixes onto every
// non-compute D3D11 program payload (PROVEN, see
// Parser/Docs/shader_compiler_analysis.md §3 + shader_parser_spec.md §3):
//
//     u8 0x02
//     u8 texExt   max(bindpoint+1) over resource type-class {2,5,7}
//     u8 cbExt    max(bindpoint+1) over type-class {0}
//     u8 sampExt  max(bindpoint+1) over type-class {3}
//     u8 uavExt   max(bindpoint+1) over type-class {4,6,8,9,10,0xb}
//     u8 flag     (0 on D3D11 non-compute)
//     u8[0x20] reserved zeros
//     <stripped DXBC at 0x26>
//
// The four resource bytes are EXTENTS (highest bindpoint + 1), NOT counts —
// never synthesize bindpoints b0..bN-1 from them. This header is the only
// RDEF-derived reflection metadata guaranteed to survive D3DStripShader.
public readonly record struct UnityNonComputeHeader(
    byte VersionTag, byte TextureExtent, byte CbExtent,
    byte SamplerExtent, byte UavExtent, byte Flag, int DxbcOffset);

public static class DxbcExtractor
{
    // Parses the 0x26-byte non-compute header when present. Returns null for
    // the raw-variant layout (strip flags = 6, no header — byte0 == 0x00 and
    // "DXBC" at +1) and for unrecognized formats.
    public static UnityNonComputeHeader? TryParseHeader(byte[] data)
    {
        const int hdr = 0x26;
        if (data.Length >= hdr + 4
            && data[0] == 0x02
            && data[hdr] == 'D' && data[hdr + 1] == 'X'
            && data[hdr + 2] == 'B' && data[hdr + 3] == 'C')
        {
            return new UnityNonComputeHeader(
                VersionTag: data[0],
                TextureExtent: data[1],
                CbExtent: data[2],
                SamplerExtent: data[3],
                UavExtent: data[4],
                Flag: data[5],
                DxbcOffset: hdr);
        }
        return null;
    }
}