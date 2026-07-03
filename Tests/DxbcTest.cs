using Parser.DXBC;

namespace Parser;

public static class DxbcTest
{
    public static void Run()
    {
        var dxbc = new DxbcFile();

        dxbc.Load("Output/program1.dxbc");

        Console.WriteLine();

        foreach (var chunk in dxbc.Chunks)
        {
            Console.WriteLine($"{chunk.Name}  Size={chunk.Size}");
        }
    }
}