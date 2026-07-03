using System;
using System.Runtime.InteropServices;
using SharpGen.Runtime;
using Vortice.D3DCompiler;
using Vortice.Direct3D;

namespace Parser;

public static class DxbcDisassembler
{
    public static unsafe string Disassemble(byte[] dxbc)
    {
        fixed (byte* ptr = dxbc)
        {
            Blob blob = Compiler.Disassemble(
                (IntPtr)ptr,
                new PointerUSize((nuint)dxbc.Length),
                DisasmFlags.EnableInstructionNumbering,
                "");

            return blob.AsString();
        }
    }
}