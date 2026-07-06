namespace Parser.DXBC.Instructions;

public class ShdrParser
{
    public uint VersionToken { get; private set; }
    public uint DeclaredDwordCount { get; private set; }
    public List<Instruction> Instructions { get; } = new();
    public List<string> Warnings { get; } = new();

    private static readonly Dictionary<uint, OpcodeInfo> OpcodeTable = new()
    {
        { 0, new() { Opcode = Opcode.Add, Name = "add", OperandCount = 3 } },
        { 1, new() { Opcode = Opcode.And, Name = "and", OperandCount = 3 } },
        { 2, new() { Opcode = Opcode.Break, Name = "break", OperandCount = 0 } },
        { 3, new() { Opcode = Opcode.BreakC, Name = "breakc", OperandCount = 1 } },
        // NOTE: no CALL/CALLC opcode exists in Wine's SM4 enum (0x04/0x05 are
        // unused/reserved here) - your old 8/9 entries were never real opcodes.
        { 6, new() { Opcode = Opcode.Case, Name = "case", OperandCount = 1 } },
        { 7, new() { Opcode = Opcode.Continue, Name = "continue", OperandCount = 0 } },
        { 8, new() { Opcode = Opcode.ContinueC, Name = "continuec", OperandCount = 1 } },
        { 13, new() { Opcode = Opcode.Discard, Name = "discard", OperandCount = 1 } },
        { 14, new() { Opcode = Opcode.Div, Name = "div", OperandCount = 3 } },
        { 15, new() { Opcode = Opcode.Dp2, Name = "dp2", OperandCount = 3 } },
        { 16, new() { Opcode = Opcode.Dp3, Name = "dp3", OperandCount = 3 } },
        { 17, new() { Opcode = Opcode.Dp4, Name = "dp4", OperandCount = 3 } },
        { 18, new() { Opcode = Opcode.Else, Name = "else", OperandCount = 0 } },
        { 19, new() { Opcode = Opcode.Emit, Name = "emit", OperandCount = 0 } },
        { 20, new() { Opcode = Opcode.EmitThenCut, Name = "emitThenCut", OperandCount = 0 } },
        { 21, new() { Opcode = Opcode.EndIf, Name = "endif", OperandCount = 0 } },
        { 22, new() { Opcode = Opcode.EndLoop, Name = "endloop", OperandCount = 0 } },
        { 23, new() { Opcode = Opcode.EndSwitch, Name = "endswitch", OperandCount = 0 } },
        { 24, new() { Opcode = Opcode.Eq, Name = "eq", OperandCount = 3 } },
        { 25, new() { Opcode = Opcode.Exp, Name = "exp", OperandCount = 2 } },
        { 26, new() { Opcode = Opcode.Frc, Name = "frc", OperandCount = 2 } },
        { 27, new() { Opcode = Opcode.Ftoi, Name = "ftoi", OperandCount = 2 } },
        { 28, new() { Opcode = Opcode.Ftou, Name = "ftou", OperandCount = 2 } },
        { 29, new() { Opcode = Opcode.GE, Name = "ge", OperandCount = 3 } },
        { 30, new() { Opcode = Opcode.IAdd, Name = "iadd", OperandCount = 3 } },
        { 31, new() { Opcode = Opcode.If, Name = "if", OperandCount = 1 } },
        { 32, new() { Opcode = Opcode.IEq, Name = "ieq", OperandCount = 3 } },
        { 33, new() { Opcode = Opcode.IGe, Name = "ige", OperandCount = 3 } },
        { 34, new() { Opcode = Opcode.ILt, Name = "ilt", OperandCount = 3 } },
        { 35, new() { Opcode = Opcode.IMad, Name = "imad", OperandCount = 4 } },
        { 36, new() { Opcode = Opcode.IMax, Name = "imax", OperandCount = 3 } },
        { 37, new() { Opcode = Opcode.IMin, Name = "imin", OperandCount = 3 } },
        { 38, new() { Opcode = Opcode.IMul, Name = "imul", OperandCount = 3 } },
        { 39, new() { Opcode = Opcode.INe, Name = "ine", OperandCount = 3 } },
        { 44, new() { Opcode = Opcode.Label, Name = "label", OperandCount = 1 } },
        { 45, new() { Opcode = Opcode.Ld, Name = "ld", OperandCount = 3 } },
        { 47, new() { Opcode = Opcode.Log, Name = "log", OperandCount = 2 } },
        { 48, new() { Opcode = Opcode.Loop, Name = "loop", OperandCount = 0 } },
        { 50, new() { Opcode = Opcode.Mad, Name = "mad", OperandCount = 4 } },
        { 52, new() { Opcode = Opcode.Max, Name = "max", OperandCount = 3 } },
        { 54, new() { Opcode = Opcode.Mov, Name = "mov", OperandCount = 2 } },
        { 55, new() { Opcode = Opcode.MovC, Name = "movc", OperandCount = 4 } },
        { 56, new() { Opcode = Opcode.Mul, Name = "mul", OperandCount = 3 } },
        { 57, new() { Opcode = Opcode.Ne, Name = "ne", OperandCount = 3 } },
        { 58, new() { Opcode = Opcode.Nop, Name = "nop", OperandCount = 0 } },
        { 59, new() { Opcode = Opcode.Not, Name = "not", OperandCount = 2 } },
        { 60, new() { Opcode = Opcode.Or, Name = "or", OperandCount = 3 } },
        { 61, new() { Opcode = Opcode.ResInfo, Name = "resinfo", OperandCount = 3 } },
        { 62, new() { Opcode = Opcode.Ret, Name = "ret", OperandCount = 0 } },
        { 63, new() { Name = "retc", OperandCount = 1 } },
        { 64, new() { Name = "round_ne", OperandCount = 2 } },
        { 65, new() { Opcode = Opcode.RoundNI, Name = "round_ni", OperandCount = 2 } },
        { 66, new() { Opcode = Opcode.RoundPI, Name = "round_pi", OperandCount = 2 } },
        { 67, new() { Opcode = Opcode.RoundZ, Name = "round_z", OperandCount = 2 } },
        { 68, new() { Opcode = Opcode.Rsq, Name = "rsq", OperandCount = 2 } },
        { 69, new() { Opcode = Opcode.Sample, Name = "sample", OperandCount = 4 } },
        { 70, new() { Opcode = Opcode.SampleC, Name = "sample_c", OperandCount = 4 } },
        { 71, new() { Name = "sample_c_lz", OperandCount = 4 } },
        { 72, new() { Opcode = Opcode.SampleL, Name = "sample_l", OperandCount = 5 } },
        { 73, new() { Name = "sample_d", OperandCount = 6 } },
        { 74, new() { Name = "sample_b", OperandCount = 5 } },
        { 75, new() { Opcode = Opcode.Sqrt, Name = "sqrt", OperandCount = 2 } },
        { 76, new() { Name = "switch", OperandCount = 1 } },
        { 77, new() { Name = "sincos", OperandCount = 3 } },

        // declarations (these were the ones actually causing your desyncs)
        { 88, new() { Name = "dcl_resource", OperandCount = 1 } },
        { 89, new() { Name = "dcl_constantbuffer", OperandCount = 1 } },
        { 90, new() { Name = "dcl_sampler", OperandCount = 1 } },
        { 95, new() { Name = "dcl_input", OperandCount = 1 } },
        { 98, new() { Name = "dcl_input_ps", OperandCount = 1 } },
        { 101, new() { Name = "dcl_output", OperandCount = 1 } },
        { 103, new() { Name = "dcl_input_sgv", OperandCount = 1 } },
        { 104, new() { Name = "dcl_temps", OperandCount = 0 } },
        { 106, new() { Name = "dcl_globalFlags", OperandCount = 0 } },
    };

private OpcodeInfo DecodeOpcode(uint opcode)
    {
        if (OpcodeTable.TryGetValue(opcode, out var info))
            return info;

        return new OpcodeInfo
        {
            Opcode = Opcode.Unknown,
            Name = $"opcode_{opcode}",
            OperandCount = 0
        };
    }

    public enum OperandModifier
    {
        None,
        Neg,
        Abs,
        AbsNeg
    }

    private Operand DecodeOperand(BinaryReader reader)
    {
        uint token = reader.ReadUInt32();

        Operand op = new();

        //--------------------------------------------------------
        // bits 0-1
        // Number of components
        //--------------------------------------------------------

        op.NumComponents = (int)(token & 0x3);

        //--------------------------------------------------------
        // bits 2-3
        // Component selection mode
        //--------------------------------------------------------

        op.ComponentMode =
            (Operand.OperandComponentMode)((token >> 2) & 0x3);

        //--------------------------------------------------------
        // bits 4-11
        // Mask / Swizzle / Component
        //--------------------------------------------------------

        switch (op.ComponentMode)
        {
            case Operand.OperandComponentMode.Mask:
                op.Mask = (byte)((token >> 4) & 0xF);
                break;

            case Operand.OperandComponentMode.Swizzle:
                op.Swizzle = (byte)((token >> 4) & 0xFF);
                break;

            case Operand.OperandComponentMode.Select1:
                op.Component = (byte)((token >> 4) & 0x3);
                break;
        }

        //--------------------------------------------------------
        // bits 12-19
        // Register type (8 bits only - NOT extended by bits 20-21,
        // those belong to the index count "order" field below)
        //--------------------------------------------------------

        uint regType = (token >> 12) & 0xFF;

        Console.WriteLine(
            $"Operand token=0x{token:X8}  regType={regType} ({DecodeRegisterType(regType)})");

        op.RegisterType = DecodeRegisterType(regType);

        //--------------------------------------------------------
        // Immediate values
        //--------------------------------------------------------

        if (op.RegisterType == RegisterType.Immediate32)
        {
            int count = op.NumComponents switch
            {
                0 => 0,
                1 => 1,
                2 => 4,
                _ => throw new InvalidDataException()
            };

            op.Immediate32Values = new float[count];

            for (int i = 0; i < count; i++)
                op.Immediate32Values[i] = reader.ReadSingle();

            return op;
        }

        if (op.RegisterType == RegisterType.Immediate64)
        {
            int count = op.NumComponents switch
            {
                0 => 0,
                1 => 1,
                2 => 4,
                _ => throw new InvalidDataException()
            };

            op.Immediate64Values = new Double[count];

            for (int i = 0; i < count; i++)
                op.Immediate64Values[i] = reader.ReadDouble();

            return op;
        }

        //--------------------------------------------------------
        // bits 20-21
        // "Order" - the number of register indices that follow.
        // This is read directly from the token, NOT derived from
        // register type. (Previously this code used GetIndexCount()
        // based on RegisterType, which is incorrect - that table
        // silently desyncs the parser whenever a register type
        // uses an index count the table didn't predict.)
        //--------------------------------------------------------

        int indexCount = (int)((token >> 20) & 0x3);

        //--------------------------------------------------------
        // bits 22-24
        // Addressing mode / index representation 0
        //--------------------------------------------------------

        if (indexCount > 0)
            op.IndexRepresentation[0] =
                (Operand.OperandIndexRepresentation)((token >> 22) & 0x7);

        //--------------------------------------------------------
        // bits 25-27
        // Addressing mode / index representation 1
        //--------------------------------------------------------

        if (indexCount > 1)
            op.IndexRepresentation[1] =
                (Operand.OperandIndexRepresentation)((token >> 25) & 0x7);

        //--------------------------------------------------------
        // bits 28-30
        // Addressing mode / index representation 2
        //--------------------------------------------------------

        if (indexCount > 2)
            op.IndexRepresentation[2] =
                (Operand.OperandIndexRepresentation)((token >> 28) & 0x7);

        //--------------------------------------------------------
        // bit 31
        // Extended operand
        //--------------------------------------------------------

        op.IsExtended = (token & 0x80000000) != 0;

        //--------------------------------------------------------
        // Read indices
        //--------------------------------------------------------

        for (int i = 0; i < indexCount; i++)
        {
            switch (op.IndexRepresentation[i])
            {
                case Operand.OperandIndexRepresentation.Immediate32:

                    op.Indices.Add(reader.ReadUInt32());
                    break;

                case Operand.OperandIndexRepresentation.Relative:

                    op.RelativeOperands[i] = DecodeOperand(reader);
                    op.Indices.Add(0);
                    break;

                case Operand.OperandIndexRepresentation.Immediate32PlusRelative:

                    op.Indices.Add(reader.ReadUInt32());
                    op.RelativeOperands[i] = DecodeOperand(reader);
                    break;

                default:
                    throw new InvalidDataException(
                        $"Unknown index representation {op.IndexRepresentation[i]}");
            }
        }

        if (op.Indices.Count > 0)
            op.RegisterIndex = op.Indices[0];

        //--------------------------------------------------------
        // Extension token(s)
        // First extension token (if present) encodes a source
        // modifier (neg/abs/absneg). Further chained extension
        // tokens (bit 31 set again) are skipped - not modeled.
        //--------------------------------------------------------

        if (op.IsExtended)
        {
            uint ext = reader.ReadUInt32();

            op.Modifier = (ext & 0xFF) switch
            {
                0x41 => OperandModifier.Neg,
                0x81 => OperandModifier.Abs,
                0xC1 => OperandModifier.AbsNeg,
                _ => OperandModifier.None
            };

            while ((ext & 0x80000000) != 0)
                ext = reader.ReadUInt32();
        }

        return op;
    }


private RegisterType DecodeRegisterType(uint type)
    {
        return type switch
        {
            0  => RegisterType.Temp,
            1  => RegisterType.Input,
            2  => RegisterType.Output,
            3  => RegisterType.IndexableTemp,
            4  => RegisterType.Immediate32,
            5  => RegisterType.Immediate64,
            6  => RegisterType.Sampler,
            7  => RegisterType.Resource,
            8  => RegisterType.ConstantBuffer,
            9  => RegisterType.ImmediateConstantBuffer,
            10 => RegisterType.Label,
            11 => RegisterType.InputPrimitiveID,
            12 => RegisterType.OutputDepth,
            13 => RegisterType.Null,
            14 => RegisterType.Rasterizer,
            15 => RegisterType.OutputCoverageMask,
            16 => RegisterType.Stream,
            17 => RegisterType.FunctionBody,
            18 => RegisterType.FunctionTable,
            19 => RegisterType.Interface,
            20 => RegisterType.FunctionInput,
            21 => RegisterType.FunctionOutput,
            22 => RegisterType.OutputControlPointID,
            23 => RegisterType.InputForkInstanceID,
            24 => RegisterType.InputJoinInstanceID,
            25 => RegisterType.InputControlPoint,
            26 => RegisterType.OutputControlPoint,
            27 => RegisterType.InputPatchConstant,
            28 => RegisterType.InputDomainPoint,
            29 => RegisterType.ThisPointer,
            30 => RegisterType.UnorderedAccessView,
            31 => RegisterType.ThreadGroupSharedMemory,
            32 => RegisterType.InputThreadID,
            33 => RegisterType.InputThreadGroupID,
            34 => RegisterType.InputThreadIDInGroup,
            35 => RegisterType.InputCoverageMask,
            36 => RegisterType.InputThreadIDInGroupFlattened,
            37 => RegisterType.InputGSInstanceID,
            38 => RegisterType.OutputDepthGreaterEqual,
            39 => RegisterType.OutputDepthLessEqual,
            40 => RegisterType.CycleCounter,

            _ => RegisterType.Unknown
        };
    }

    public void Parse(byte[] data)
    {
        using var stream = new MemoryStream(data);
        using var reader = new BinaryReader(stream);

        VersionToken = reader.ReadUInt32();
        DeclaredDwordCount = reader.ReadUInt32();

        while (reader.BaseStream.Position < reader.BaseStream.Length)
        {
            long instructionStartByte = reader.BaseStream.Position;
            int instructionStart = (int)(instructionStartByte / 4);

            uint token = reader.ReadUInt32();

            int opcodeValue = (int)(token & 0x7FF);
            int length = (int)((token >> 24) & 0x7F);

            if (length == 0)
            {
                Warnings.Add($"Invalid instruction at DWORD {instructionStart}");
                break;
            }
            
            Console.WriteLine($"IndexRep0={(token >> 22) & 7}");

            OpcodeInfo info = DecodeOpcode((uint)opcodeValue);

            var instruction = new Instruction
            {
                Opcode = info.Opcode,
                Name = info.Name,
                OpcodeToken = token,
                Length = length
            };
            
            Console.WriteLine($"Instruction {info.Name}");
            for (int i = 0; i < length; i++)
            {
                uint dw = BitConverter.ToUInt32(data, (instructionStart + i) * 4);
                Console.WriteLine($"{i}: 0x{dw:X8}");
            }
            
            if (opcodeValue == 88) // dcl_resource
            {
                uint resourceDim = (token >> 11) & 0x1F; // verify shift/width against actual dumps
                instruction.ExtraData.Add(resourceDim);
            }
            else if (opcodeValue == 90) // dcl_sampler
            {
                uint samplerMode = (token >> 11) & 0x3;
                instruction.ExtraData.Add(samplerMode);
            }
            else if (opcodeValue == 89)
            {
                uint indexType = (token >> 11) & 0x1;
                instruction.ExtraData.Add(indexType);
            }

            foreach (uint value in instruction.ExtraData)
            {
                Console.WriteLine($"    Extra = 0x{value:X8}");
            }
            
            Console.WriteLine(
                $"[{instructionStart}] {info.Name,-20} Length={length} Operands={info.OperandCount}");

            for (int i = 0; i < info.OperandCount; i++)
            {
                try
                {
                    Operand operand = DecodeOperand(reader);
                    
                    Console.WriteLine($"    Extended={operand.IsExtended}  EndDWORD={reader.BaseStream.Position / 4}");

                    instruction.Operands.Add(operand);

                    Console.WriteLine($"    {i}: {operand}");
                }
                catch (Exception ex)
                {
                    throw new Exception(
                        $"Failed decoding operand {i} of {info.Name} " +
                        $"at DWORD {instructionStart} (stream DWORD {reader.BaseStream.Position / 4})",
                        ex);
                }
            }
            
            if (opcodeValue == 88)
            {
                uint returnType = reader.ReadUInt32();
                instruction.ExtraData.Add(returnType);
            }
            
            switch (opcodeValue)
            {

                //----------------------------------------------------------
                // dcl_output
                //----------------------------------------------------------
                case 101:
                    // no extra DWORD
                    break;
                
                //----------------------------------------------------------
                // dcl_input_sgv
                //----------------------------------------------------------
                case 103:
                    instruction.ExtraData.Add(reader.ReadUInt32()); // system-value semantic
                    break;
                    
                //----------------------------------------------------------
                // dcl_temps
                //----------------------------------------------------------
                case 104:
                    instruction.ExtraData.Add(reader.ReadUInt32());
                    break;

                //----------------------------------------------------------
                // dcl_globalFlags
                //----------------------------------------------------------
                case 106:
                    instruction.ExtraData.Add(reader.ReadUInt32()); // flags
                    break;
            }

            //------------------------------------------------------------------
            // Check that DecodeOperand() consumed exactly the correct number
            // of DWORDs for this instruction.
            //------------------------------------------------------------------

            int expectedEnd = instructionStart + length;
            int actualEnd = (int)(reader.BaseStream.Position / 4);

            if (actualEnd != expectedEnd)
            {
                Console.ForegroundColor = ConsoleColor.Yellow;

                Console.WriteLine(
                    $"*** DESYNC *** {info.Name}");

                Console.WriteLine($"Expected end : DWORD {expectedEnd}");
                Console.WriteLine($"Actual end   : DWORD {actualEnd}");
                Console.WriteLine($"Difference   : {actualEnd - expectedEnd}");

                Console.ResetColor();
            }

            //------------------------------------------------------------------
            // Move to the official end of the instruction.
            //------------------------------------------------------------------

            reader.BaseStream.Position = instructionStartByte + length * 4;

            Instructions.Add(instruction);

            if (opcodeValue == 62) // ret
                break;
        }
    }
}