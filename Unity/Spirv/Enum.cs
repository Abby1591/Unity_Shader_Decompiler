namespace Parser
{
    public enum ShaderGpuProgramType
    {
        Unknown = 0,
        GLLegacy = 1,
        GLES31AEP = 2,
        GLES31 = 3,
        GLES3 = 4,
        GLES = 5,
        GLCore32 = 6,
        GLCore41 = 7,
        GLCore43 = 8,
        DX9VertexSM20 = 9,
        DX9VertexSM30 = 10,
        DX9PixelSM20 = 11,
        DX9PixelSM30 = 12,
        DX10Level9Vertex = 13,
        DX10Level9Pixel = 14,
        DX11VertexSM40 = 15,
        DX11VertexSM50 = 16,
        DX11PixelSM40 = 17,
        DX11PixelSM50 = 18,
        DX11GeometrySM40 = 19,
        DX11GeometrySM50 = 20,
        DX11HullSM50 = 21,
        DX11DomainSM50 = 22,
        MetalVS = 23,
        MetalFS = 24,
        SPIRV = 25,
        ConsoleVS = 26,
        ConsoleFS = 27,
        ConsoleHS = 28,
        ConsoleDS = 29,
        ConsoleGS = 30,
        RayTracing = 31,
        PS5NGGC = 32
    };
}
