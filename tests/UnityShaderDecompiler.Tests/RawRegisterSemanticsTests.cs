using System;
using System.Linq;
using Parser.Core.Hlsl;
using Parser.Core.Hlsl.Ast;
using Parser.Core.Analysis;
using Parser.Core.Optimizations;
using Parser.DXBC.Instructions;
using Parser.DXBC.IR;
using Xunit;

namespace UnityShaderDecompiler.Tests;

public sealed class RawRegisterSemanticsTests
{
    [Theory]
    [InlineData("uint", false)]
    [InlineData("int", false)]
    [InlineData("uint", true)]
    [InlineData("int", true)]
    [Trait("Category", "D3D")]
    public void IntegerMovesPreserveBitsThroughNativeRoundTrip(string type, bool conditional)
    {
        if (!OperatingSystem.IsWindows()) return;

        // These integers also encode NaNs, a subnormal and negative zero as floats.
        uint[] selected = { 0xffffffffu, 0x7fc12345u, 0x00000001u, 0x80000000u };
        uint[] alternate = { 0x01000001u, 0xffc54321u, 0x7fffffffu, 0x80000001u };
        string first = $"{type}4(0xffffffffu, 0x7fc12345u, 1u, 0x80000000u)";
        string second = $"{type}4(0x01000001u, 0xffc54321u, 0x7fffffffu, 0x80000001u)";
        string value = conditional ? $"condition ? {first} : {second}" : first;
        Parser.DXBC.DxbcFile original = RegisterRoundTrip.Compile(
            $"{type}4 main(nointerpolation uint condition : TEXCOORD0) : SV_Target {{ return {value}; }}");
        Assert.Contains(original.Shader!.Instructions, instruction =>
            instruction.Opcode == (conditional ? Opcode.MovC : Opcode.Mov));
        Parser.DXBC.DxbcFile rebuilt = RegisterRoundTrip.Recompile(original);
        Assert.Equal(original.OutputSignature!.Elements[0].ComponentType,
            rebuilt.OutputSignature!.Elements[0].ComponentType);
        foreach (uint condition in new uint[] { 0, 1, 0x80000000u, uint.MaxValue })
        {
            uint[] input = { condition, 0, 0, 0 };
            uint[] expected = conditional && condition == 0 ? alternate : selected;
            Assert.Equal(expected, RegisterRoundTrip.Evaluate(original, input));
            Assert.Equal(expected, RegisterRoundTrip.Evaluate(rebuilt, input));
        }
    }

    [Fact]
    public void IntegerSourceModifierIsAppliedAfterBitInterpretation()
    {
        ShdrParser parser = new ShdrParser();
        parser.Instructions.Add(new Instruction
        {
            Opcode = Opcode.IMax,
            Operands =
            {
                new Operand { RegisterType = RegisterType.Temp, RegisterIndex = 1, Mask = 1 },
                new Operand { RegisterType = RegisterType.Temp, RegisterIndex = 0, Mask = 1,
                    Modifier = ShdrParser.OperandModifier.Neg },
                new Operand { RegisterType = RegisterType.Immediate32, Immediate32Values = new uint[] { 0 } },
            },
        });
        IRProgram program = new IRBuilder(preserveRegisterBits: true).Build(parser);
        IRStatement.IRAssignment assignment = Assert.IsType<IRStatement.IRAssignment>(Assert.Single(program.Statements));
        IRExpression.IntrinsicExpression maximum = Assert.IsType<IRExpression.IntrinsicExpression>(assignment.Expression);
        IRExpression.UnaryExpression negation = Assert.IsType<IRExpression.UnaryExpression>(maximum.Arguments[0]);
        Assert.Equal(IRExpression.UnaryExpression.UnaryOperation.Negate, negation.Operation);
        Assert.Equal(IRValueType.Int, negation.Type);
        IRExpression.IntrinsicExpression cast = Assert.IsType<IRExpression.IntrinsicExpression>(negation.Operand);
        Assert.Equal(IRExpression.IRIntrinsic.AsInt, cast.Intrinsic);
        IRExpression.RegisterExpression register = Assert.IsType<IRExpression.RegisterExpression>(Assert.Single(cast.Arguments));
        Assert.Equal(ShdrParser.OperandModifier.None, register.Register.Modifier);
    }

    [Fact]
    [Trait("Category", "D3D")]
    public void FractionalPartRetainsPrecedingAdditionWhenRecompiled()
    {
        if (!OperatingSystem.IsWindows()) return;

        Parser.DXBC.Chunks.SignatureElement input = new Parser.DXBC.Chunks.SignatureElement
        {
            SemanticName = "TEXCOORD", Mask = 1, ComponentType = 3,
        };
        Parser.DXBC.Chunks.SignatureElement output = new Parser.DXBC.Chunks.SignatureElement
        {
            SemanticName = "SV_Target", Mask = 1, ComponentType = 3,
        };
        HlslFunctionNode function = new HlslFunctionNode
        {
            Name = "frag", Stage = HlslShaderStage.Fragment, RawTemporaryStorage = true,
            InputStruct = new HlslStructNode { Name = "TestInput" },
            OutputStruct = new HlslStructNode { Name = "TestOutput" },
        };
        function.InputStruct.Fields.Add(new HlslFieldNode
        {
            Name = HlslAstBuilder.ToFieldName("TEXCOORD0"), Semantic = "TEXCOORD0", TypeHint = "float",
        });
        function.OutputStruct.Fields.Add(new HlslFieldNode
        {
            Name = HlslAstBuilder.ToFieldName("SV_Target0"), Semantic = "SV_Target0", TypeHint = "float",
        });
        function.InputElementsByRegister[0] = new() { input };
        function.OutputElementsByRegister[0] = new() { output };
        IRRegister source = Temp(0);
        source.RegisterType = RegisterType.Input;
        source.SymbolicName = "TEXCOORD0";
        IRRegister destination = Temp(0);
        destination.RegisterType = RegisterType.Output;
        destination.SymbolicName = "SV_Target0";
        function.Statements.Statements.Add(new HlslAssignmentStatement
        {
            Destination = Temp(1),
            Expression = new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.Add,
                Left = new IRExpression.RegisterExpression { Register = source }, Right = Float(1),
            },
        });
        function.Statements.Statements.Add(new HlslAssignmentStatement
        {
            Destination = destination,
            Expression = new IRExpression.IntrinsicExpression
            {
                Intrinsic = IRExpression.IRIntrinsic.FractionalPart,
                Arguments = { new IRExpression.RegisterExpression { Register = Temp(1) } },
            },
        });
        function.Statements.Statements.Add(new HlslReturnStatement());
        HlslShaderNode shader = new HlslShaderNode { Name = "Test/Fraction" };
        HlslSubShaderNode subShader = new HlslSubShaderNode();
        HlslPassNode pass = new HlslPassNode { FragmentFunction = function };
        pass.Structs.Add(function.InputStruct);
        pass.Structs.Add(function.OutputStruct);
        subShader.Passes.Add(pass);
        shader.SubShaders.Add(subShader);
        string text = HlslPrettyPrinter.Print(shader, fuseTemps: false);
        string hlsl = System.Text.RegularExpressions.Regex.Match(text,
            @"HLSLPROGRAM(.*?)ENDHLSL", System.Text.RegularExpressions.RegexOptions.Singleline).Groups[1].Value;
        Parser.DXBC.DxbcFile dxbc = new Parser.DXBC.DxbcFile();
        dxbc.Load(Parser.RecompileVerify.CompileHlsl(hlsl, "frag", "ps_4_0"));

        // frac(x + 1) loses the add under fxc optimization; round_ni must keep it.
        System.Collections.Generic.List<Instruction> instructions = dxbc.Shader!.Instructions;
        int floor = instructions.FindIndex(i => i.Opcode == Opcode.RoundNI);
        Assert.True(floor > 0);
        Assert.Contains(instructions.Take(floor), i => i.Opcode == Opcode.Add);
        Assert.Contains(instructions.Skip(floor + 1), i => i.Opcode == Opcode.Add);
    }

    [Fact]
    public void RawTemporaryStorageKeepsComparisonMasksAndIntegerArithmetic()
    {
        HlslFunctionNode function = new HlslFunctionNode
        {
            Name = "frag", Stage = HlslShaderStage.Fragment, RawTemporaryStorage = true,
        };
        function.Statements.Statements.Add(new HlslAssignmentStatement
        {
            Destination = Temp(0),
            Expression = new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.LessThan,
                Left = Float(1), Right = Float(2),
            },
        });
        IRExpression.IntrinsicExpression signedRead = new IRExpression.IntrinsicExpression
        {
            Intrinsic = IRExpression.IRIntrinsic.AsInt,
            Arguments = { new IRExpression.RegisterExpression { Register = Temp(0) } },
        };
        function.Statements.Statements.Add(new HlslAssignmentStatement
        {
            Destination = Temp(1),
            Expression = new IRExpression.BinaryExpression
            {
                Operation = IRExpression.BinaryOperation.Add,
                Left = signedRead,
                Right = new IRExpression.ConstantExpression
                {
                    Kind = IRExpression.ConstantExpression.ConstantKind.Int, RawValues = new uint[] { 2 },
                },
            },
        });
        string source = Print(function);
        Assert.Contains("uint r0_x_1", source);
        Assert.Contains("? 0xffffffffu : 0u", source);
        Assert.Contains("asint(asfloat(r0_x_1))", source);
        Assert.Contains("uint r1_x_1 = asuint(", source);
    }

    private static string Print(HlslFunctionNode function)
    {
        HlslShaderNode shader = new HlslShaderNode { Name = "Test/Scope" };
        HlslSubShaderNode subShader = new HlslSubShaderNode();
        subShader.Passes.Add(new HlslPassNode { FragmentFunction = function });
        shader.SubShaders.Add(subShader);
        return HlslPrettyPrinter.Print(shader, fuseTemps: false);
    }

    private static IRRegister Temp(uint index, byte mask = 1)
    {
        IRRegister register = new IRRegister
        {
            RegisterType = RegisterType.Temp,
            Index = index,
            Type = IRValueType.Float,
            Mask = mask,
            ComponentMode = Operand.OperandComponentMode.Mask,
        };
        for (int component = 0; component < 4; component++)
            if ((mask & (1 << component)) != 0)
                register.SsaVersion[component] = 1;
        return register;
    }

    private static IRExpression.ConstantExpression Float(float value) => new()
    {
        RawValues = new[] { unchecked((uint)BitConverter.SingleToInt32Bits(value)) },
    };
}
