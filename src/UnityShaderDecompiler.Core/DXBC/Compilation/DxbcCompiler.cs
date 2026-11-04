using System;
using System.Runtime.InteropServices;
using System.Text;
using Vortice.D3DCompiler;
using Vortice.Direct3D;

namespace Parser.DXBC.Compilation;

/// <summary>
/// Thin wrapper over the native <c>d3dcompiler_47.dll</c> entry point used by
/// the recompile/faithfulness checks. Kept in the core assembly because
/// "compile HLSL to DXBC" is a primitive the verification harnesses and the
/// test suite both need; the DLL is only loaded when a caller actually
/// compiles, so the rest of the pipeline stays platform-neutral.
/// </summary>
public static class DxbcCompiler
{
    /// <summary>
    /// Compiles <paramref name="hlsl"/> for <paramref name="profile"/>
    /// (e.g. <c>vs_5_0</c>), matching the flags the decompiler's
    /// recompile-verification uses. Throws with the compiler's diagnostics
    /// when compilation fails.
    /// </summary>
    public static byte[] Compile(string hlsl, string entry, string profile)
    {
        byte[] src = Encoding.UTF8.GetBytes(hlsl);
        int hr = D3DCompile(
            src, (nuint)src.Length, "decompiled.hlsl",
            IntPtr.Zero, IntPtr.Zero, entry, profile,
            (uint)(ShaderFlags.EnableStrictness | ShaderFlags.OptimizationLevel0),
            0, out IntPtr code, out IntPtr errors);
        if (hr < 0 || code == IntPtr.Zero)
        {
            string msg = errors == IntPtr.Zero
                ? $"HRESULT 0x{hr:X8}"
                : ReadComBlobString(errors);
            throw new InvalidOperationException(msg);
        }
        return ReadComBlob(code);
    }

    [DllImport("d3dcompiler_47.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.StdCall)]
    private static extern int D3DCompile(
        byte[] pSrcData, nuint srcDataSize, string pSourceName,
        IntPtr pDefines, IntPtr pInclude, string pEntrypoint, string pTarget,
        uint flags1, uint flags2, out IntPtr ppCode, out IntPtr ppErrorMsgs);

    private static byte[] ReadComBlob(IntPtr blob)
    {
        IntPtr vtbl = Marshal.ReadIntPtr(blob);
        var getPtr = Marshal.GetDelegateForFunctionPointer<GetBufferPointerFn>(Marshal.ReadIntPtr(vtbl, 3 * IntPtr.Size));
        var getSize = Marshal.GetDelegateForFunctionPointer<GetBufferSizeFn>(Marshal.ReadIntPtr(vtbl, 4 * IntPtr.Size));
        byte[] bytes = new byte[getSize(blob)];
        Marshal.Copy(getPtr(blob), bytes, 0, bytes.Length);
        return bytes;
    }

    private static string ReadComBlobString(IntPtr blob)
    {
        byte[] bytes = ReadComBlob(blob);
        return Encoding.UTF8.GetString(bytes).Trim('\0');
    }

    [UnmanagedFunctionPointer(CallingConvention.StdCall)]
    private delegate IntPtr GetBufferPointerFn(IntPtr self);

    [UnmanagedFunctionPointer(CallingConvention.StdCall)]
    private delegate nuint GetBufferSizeFn(IntPtr self);
}
