namespace Parser.Decompiler;

public interface IDxbcDecompiler
{
    string Decompile(byte[] dxbc);
}