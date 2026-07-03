using System;
using System.IO;
using Parser.Decompiler;
using Parser.DXBC;

namespace Parser;

internal class Program
{
    static void Main(string[] args)
    {
        string blobPath = args.Length > 0 ? args[0] : "../blob.bin";

        if (!File.Exists(blobPath))
        {
            Console.WriteLine($"Blob not found: {blobPath}");
            return;
        }

        Console.WriteLine("Unity Shader Parser");
        Console.WriteLine("-------------------");
        Console.WriteLine();

        byte[] bytes = File.ReadAllBytes(blobPath);

        Console.WriteLine($"Blob Size: {bytes.Length} bytes");
        Console.WriteLine();

        using var stream = new MemoryStream(bytes);
        using var reader = new BinaryReader(stream);

        // Unity 2022.3.x
        int[] version = { 2022, 3, 62 };

        var program = new ShaderProgram(reader, version);

        Console.WriteLine($"SubPrograms: {program.entries.Length}");
        Console.WriteLine();

        for (int i = 0; i < program.entries.Length; i++)
        {
            var e = program.entries[i];

            Console.WriteLine(
                $"[{i}] Offset={e.Offset} Length={e.Length} Segment={e.Segment}");
        }

        Console.WriteLine();
        Console.WriteLine("Loading SubPrograms...");
        Console.WriteLine();

        program.Read(reader, 0);

        Directory.CreateDirectory("Output");

        var decompiler = new HlslGenerator();

        for (int i = 0; i < program.m_SubPrograms.Length; i++)
        {
            var sp = program.m_SubPrograms[i];

            Console.WriteLine($"========== SubProgram {i} ==========");

            if (sp == null)
            {
                Console.WriteLine("NULL");
                Console.WriteLine();
                continue;
            }

            Console.WriteLine($"Type     : {sp.m_ProgramType}");
            Console.WriteLine($"Version  : {sp.m_Version}");
            Console.WriteLine($"Code Size: {sp.m_ProgramCode.Length}");

            // Save raw Unity shader program
            string rawPath = Path.Combine("Output", $"program{i}.bin");
            File.WriteAllBytes(rawPath, sp.m_ProgramCode);

            Console.WriteLine($"Saved: {rawPath}");

            try
            {
                byte[] dxbc = DxbcExtractor.Extract(sp);

                Console.WriteLine($"DXBC Size: {dxbc.Length} bytes");

                string dxbcPath = Path.Combine("Output", $"program{i}.dxbc");
                File.WriteAllBytes(dxbcPath, dxbc);

                Console.WriteLine($"Saved: {dxbcPath}");

                var dxbcFile = new DxbcFile();
                dxbcFile.Load(dxbcPath);

                Console.WriteLine($"Length      : {dxbcFile.TotalLength}");
                Console.WriteLine($"Chunk Count : {dxbcFile.Chunks.Count}");
                Console.WriteLine();

                if (dxbcFile.InputSignature != null)
                {
                    Console.WriteLine($"ISGN Elements: {dxbcFile.InputSignature.Elements.Count}");
                    foreach (var warning in dxbcFile.InputSignature.Warnings)
                        Console.WriteLine(warning);
                    foreach (var element in dxbcFile.InputSignature.Elements)
                        Console.WriteLine(element);
                    Console.WriteLine();
                }

                if (dxbcFile.Shader != null)
                {
                    Console.WriteLine($"Shader Version Token : 0x{dxbcFile.Shader.VersionToken:X8}");
                    Console.WriteLine($"Instruction DWORDs   : {dxbcFile.Shader.DeclaredDwordCount}");
                    Console.WriteLine();
                    Console.WriteLine("Instructions");
                    Console.WriteLine("------------");

                    foreach (var inst in dxbcFile.Shader.Instructions)
                    {
                        Console.WriteLine($"{inst.Opcode,-10} Length={inst.Length}");
                    }

                    foreach (var warning in dxbcFile.Shader.Warnings)
                        Console.WriteLine(warning);

                    Console.WriteLine();
                }

                string hlsl = decompiler.Decompile(dxbc);
                string hlslPath = Path.Combine("Output", $"program{i}.hlsl");
                File.WriteAllText(hlslPath, hlsl);
                Console.WriteLine($"Saved: {hlslPath}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"No DXBC: {ex.Message}");
            }

            Console.WriteLine();
        }

        Console.WriteLine("Finished.");
    }
}