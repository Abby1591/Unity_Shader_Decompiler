using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using AssetStudio;
using UnityShaderDecompiler.Core;
using UnityShaderDecompiler.Core.Hlsl;
using UnityShaderDecompiler.Core.Hlsl.Ast;
using UnityShaderDecompiler.Core.DXBC;
using UnityShaderDecompiler.Core.DXBC.Instructions;
using UnityShaderDecompiler.Core.DXBC.IR;
using Xunit;

namespace UnityShaderDecompiler.Tests;

// Covers register round trip.
internal static class RegisterRoundTrip
{
    // Compiles the fixture HLSL into a DXBC container.
    internal static DxbcFile Compile(string source, string entry = "main")
    {
        DxbcFile file = new DxbcFile();
        file.Load(UnityShaderDecompiler.Core.DXBC.Compilation.DxbcCompiler.Compile(source, entry, "ps_5_0"));
        return file;
    }

    // Decompiles and recompiles a fixture without changing its register bits.
    internal static DxbcFile Recompile(DxbcFile original, bool fuseTemps = false)
    {
        IRPipeline.Result pipeline = IRPipeline.Run(original, dumpStages: false, preserveArithmetic: !fuseTemps);
        Assert.True(pipeline.SsaVerification.IsValid);
        HlslFunctionNode function = HlslAstBuilder.BuildFunction("RoundTrip",
            ShaderGpuProgramType.DX11PixelSM50, pipeline.Program.Declarations,
            pipeline.Blocks, original.InputSignature, original.OutputSignature)!;
        function.RawTemporaryStorage = pipeline.PreserveRegisterBits;
        HlslPassNode pass = new HlslPassNode { FragmentFunction = function };
        pass.Structs.Add(function.InputStruct!);
        pass.Structs.Add(function.OutputStruct!);
        pass.Resources.AddRange(HlslAstBuilder.BuildResources(pipeline.Program.Declarations,
            original.ResourceDefinition, pipeline.Blocks));
        HlslSubShaderNode subShader = new HlslSubShaderNode();
        subShader.Passes.Add(pass);
        HlslShaderNode shader = new HlslShaderNode { Name = "Test/RegisterRoundTrip" };
        shader.SubShaders.Add(subShader);
        string shaderText = HlslPrettyPrinter.Print(shader, fuseTemps: fuseTemps);
        string hlsl = Regex.Match(shaderText, @"HLSLPROGRAM(.*?)ENDHLSL", RegexOptions.Singleline).Groups[1].Value;
        try { return Compile(hlsl, function.Name); }
        catch (InvalidOperationException error) { throw new InvalidOperationException(hlsl, error); }
    }

    // Deliberately limited to the bit-copy fixtures below; unexpected arithmetic fails.
    internal static uint[] Evaluate(DxbcFile file, uint[] input, uint[]? structuredWords = null)
    {
        Dictionary<(RegisterType, uint), uint[]> registers = new Dictionary<(RegisterType, uint), uint[]>
        {
            [(RegisterType.Input, 0)] = input,
        };
        foreach (Instruction instruction in file.Shader!.Instructions)
        {
            if (instruction.Opcode.ToString().StartsWith("Dcl", StringComparison.Ordinal))
            {
                continue;
            }
            if (instruction.Opcode == Opcode.Ret)
            {
                return registers[(RegisterType.Output, 0)];
            }
            ExecuteInstruction(file, instruction, registers, structuredWords);
        }
        throw new InvalidOperationException("Fixture has no return instruction.");
    }

    // Selects the source component requested by an operand.
    private static int Component(Operand operand, int lane) => operand.ComponentMode switch
    {
        Operand.OperandComponentMode.Select1 => operand.Component,
        Operand.OperandComponentMode.Swizzle => (operand.Swizzle >> (2 * lane)) & 3,
        _ => lane,
    };

    // Reads the selected operand lane without applying numeric conversion.
    private static uint Read(Operand operand, int lane, Dictionary<(RegisterType, uint), uint[]> registers)
    {
        Assert.Equal(ShdrParser.OperandModifier.None, operand.Modifier);
        int component = Component(operand, lane);
        if (operand.RegisterType == RegisterType.Immediate32)
        {
            return operand.Immediate32Values![operand.Immediate32Values.Length == 1 ? 0 : component];
        }
        return registers[(operand.RegisterType, operand.RegisterIndex)][component];
    }

    // Executes one supported fixture instruction and writes its masked result.
    private static void ExecuteInstruction(DxbcFile file, Instruction instruction, Dictionary<(RegisterType, uint), uint[]> registers, uint[]? structuredWords)
    {
        Assert.True(instruction.Opcode is Opcode.Mov or Opcode.MovC or Opcode.INe or Opcode.IEq
            or Opcode.And or Opcode.LdStructured or Opcode.IAdd or Opcode.Ishl or Opcode.Ushr or Opcode.Bfi,
            $"Unexpected opcode: {instruction.Opcode}");
        Operand destination = instruction.Operands[0];
        uint[] result = new uint[4];
        for (int lane = 0; lane < 4; lane++)
        {
            if ((destination.Mask & (1 << lane)) == 0)
            {
                continue;
            }
            result[lane] = EvaluateLane(file, instruction, lane, registers, structuredWords);
            if (instruction.Saturate)
            {
                float value = BitConverter.UInt32BitsToSingle(result[lane]);
                result[lane] = BitConverter.SingleToUInt32Bits(float.IsNaN(value) ? 0f : Math.Clamp(value, 0f, 1f));
            }
        }
        (RegisterType, uint) key = (destination.RegisterType, destination.RegisterIndex);
        if (!registers.TryGetValue(key, out uint[]? target))
        {
            registers[key] = target = new uint[4];
        }
        for (int lane = 0; lane < 4; lane++)
        {
            if ((destination.Mask & (1 << lane)) != 0)
            {
                target[lane] = result[lane];
            }
        }
    }

    // Evaluates one lane without changing its raw register bits.
    private static uint EvaluateLane(DxbcFile file, Instruction instruction, int lane, Dictionary<(RegisterType, uint), uint[]> registers, uint[]? structuredWords)
    {
        uint first = Read(instruction.Operands[1], lane, registers);
        if (instruction.Opcode == Opcode.Mov)
        {
            return first;
        }
        else if (instruction.Opcode == Opcode.MovC)
        {
            return Read(instruction.Operands[first != 0 ? 2 : 3], lane, registers);
        }
        else if (instruction.Opcode == Opcode.Bfi)
        {
            int width = (int)(first & 31);
            int offset = (int)(Read(instruction.Operands[2], lane, registers) & 31);
            uint mask = unchecked(((1u << width) - 1u) << offset);
            uint insert = Read(instruction.Operands[3], lane, registers);
            uint original = Read(instruction.Operands[4], lane, registers);
            return ((insert << offset) & mask) | (original & ~mask);
        }
        else if (instruction.Opcode == Opcode.LdStructured)
        {
            return ReadStructuredWord(file, instruction, lane, registers, structuredWords, first);
        }
        else
        {
            uint second = Read(instruction.Operands[2], lane, registers);
            return instruction.Opcode switch
            {
                Opcode.INe => first != second ? uint.MaxValue : 0u,
                Opcode.IEq => first == second ? uint.MaxValue : 0u,
                Opcode.And => first & second,
                Opcode.IAdd => unchecked(first + second),
                Opcode.Ishl => first << (int)(second & 31),
                Opcode.Ushr => first >> (int)(second & 31),
                _ => throw new InvalidOperationException(),
            };
        }
    }

    // Reads one structured-buffer word using the serialized stride and offset.
    private static uint ReadStructuredWord(DxbcFile file, Instruction instruction, int lane, Dictionary<(RegisterType, uint), uint[]> registers, uint[]? structuredWords, uint first)
    {
        Assert.NotNull(structuredWords);
        Operand resource = instruction.Operands[3];
        Instruction declaration = Assert.Single(file.Shader!.Instructions,
            item => item.Opcode == Opcode.DclResourceStructured
                && item.Operands[0].RegisterIndex == resource.RegisterIndex);
        uint stride = declaration.ExtraData.Single();
        uint offset = Read(instruction.Operands[2], lane, registers);
        Assert.Equal(0u, offset % 4);
        return structuredWords[checked((int)((first * stride + offset) / 4)) + Component(resource, lane)];
    }
}
