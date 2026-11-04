using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using AssetStudio;
using Parser;
using Parser.Core.Hlsl;
using Parser.Core.Hlsl.Ast;
using Parser.DXBC;
using Parser.DXBC.Instructions;
using Parser.DXBC.IR;
using Xunit;

namespace UnityShaderDecompiler.Tests;

internal static class RegisterRoundTrip
{
    internal static DxbcFile Compile(string source, string entry = "main")
    {
        DxbcFile file = new DxbcFile();
        file.Load(RecompileVerify.CompileHlsl(source, entry, "ps_5_0"));
        return file;
    }

    internal static DxbcFile Recompile(DxbcFile original)
    {
        IRPipeline.Result pipeline = IRPipeline.Run(original, preserveArithmetic: true);
        Assert.True(pipeline.SsaVerification.IsValid);
        HlslFunctionNode function = HlslAstBuilder.BuildFunction("RoundTrip",
            ShaderGpuProgramType.DX11PixelSM50, pipeline.Program.Declarations,
            pipeline.Blocks, original.InputSignature, original.OutputSignature)!;
        function.RawTemporaryStorage = true;
        HlslPassNode pass = new HlslPassNode { FragmentFunction = function };
        pass.Structs.Add(function.InputStruct!);
        pass.Structs.Add(function.OutputStruct!);
        pass.Resources.AddRange(HlslAstBuilder.BuildResources(pipeline.Program.Declarations,
            original.ResourceDefinition, pipeline.Blocks));
        HlslSubShaderNode subShader = new HlslSubShaderNode();
        subShader.Passes.Add(pass);
        HlslShaderNode shader = new HlslShaderNode { Name = "Test/RegisterRoundTrip" };
        shader.SubShaders.Add(subShader);
        string shaderText = HlslPrettyPrinter.Print(shader, fuseTemps: false);
        string hlsl = Regex.Match(shaderText, @"HLSLPROGRAM(.*?)ENDHLSL", RegexOptions.Singleline).Groups[1].Value;
        return Compile(hlsl, function.Name);
    }

    // Deliberately limited to the bit-copy fixtures below; unexpected arithmetic fails.
    internal static uint[] Evaluate(DxbcFile file, uint[] input)
    {
        Dictionary<(RegisterType, uint), uint[]> registers = new Dictionary<(RegisterType, uint), uint[]>
        {
            [(RegisterType.Input, 0)] = input,
        };
        foreach (Instruction instruction in file.Shader!.Instructions)
        {
            if (instruction.Opcode.ToString().StartsWith("Dcl", StringComparison.Ordinal)) continue;
            if (instruction.Opcode == Opcode.Ret) return registers[(RegisterType.Output, 0)];
            Assert.True(instruction.Opcode is Opcode.Mov or Opcode.MovC or Opcode.INe or Opcode.IEq
                or Opcode.And, $"Unexpected opcode: {instruction.Opcode}");
            Operand destination = instruction.Operands[0];
            uint[] result = new uint[4];
            for (int lane = 0; lane < 4; lane++)
            {
                if ((destination.Mask & (1 << lane)) == 0) continue;
                uint first = Read(instruction.Operands[1], lane, registers);
                if (instruction.Opcode == Opcode.Mov) result[lane] = first;
                else if (instruction.Opcode == Opcode.MovC)
                    result[lane] = Read(instruction.Operands[first != 0 ? 2 : 3], lane, registers);
                else
                {
                    uint second = Read(instruction.Operands[2], lane, registers);
                    result[lane] = instruction.Opcode switch
                    {
                        Opcode.INe => first != second ? uint.MaxValue : 0u,
                        Opcode.IEq => first == second ? uint.MaxValue : 0u,
                        Opcode.And => first & second,
                        _ => throw new InvalidOperationException(),
                    };
                }
            }
            (RegisterType, uint) key = (destination.RegisterType, destination.RegisterIndex);
            if (!registers.TryGetValue(key, out uint[]? target)) registers[key] = target = new uint[4];
            for (int lane = 0; lane < 4; lane++)
                if ((destination.Mask & (1 << lane)) != 0) target[lane] = result[lane];
        }
        throw new InvalidOperationException("Fixture has no return instruction.");
    }

    private static int Component(Operand operand, int lane) => operand.ComponentMode switch
    {
        Operand.OperandComponentMode.Select1 => operand.Component,
        Operand.OperandComponentMode.Swizzle => (operand.Swizzle >> (2 * lane)) & 3,
        _ => lane,
    };

    private static uint Read(Operand operand, int lane, Dictionary<(RegisterType, uint), uint[]> registers)
    {
        Assert.Equal(ShdrParser.OperandModifier.None, operand.Modifier);
        int component = Component(operand, lane);
        if (operand.RegisterType == RegisterType.Immediate32)
            return operand.Immediate32Values![operand.Immediate32Values.Length == 1 ? 0 : component];
        return registers[(operand.RegisterType, operand.RegisterIndex)][component];
    }
}
