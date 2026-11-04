using UnityShaderDecompiler.Core.DXBC.IR;

namespace UnityShaderDecompiler.Core.Optimizations;

// Retain the public pass entry point; explicit LOD must not become implicit sampling.
public static class IRTexturePatternRecognition
{
    public static bool Run(List<IRBlock> blocks) => false;
}
