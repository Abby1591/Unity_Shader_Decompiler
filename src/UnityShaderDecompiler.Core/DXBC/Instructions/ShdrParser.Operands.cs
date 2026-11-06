using UnityShaderDecompiler.Core.DXBC.IR;

namespace UnityShaderDecompiler.Core.DXBC.Instructions;

// Operand token decoding: modifiers, immediate values, and register types.
public partial class ShdrParser
{
    public enum OperandModifier
    {
        None,
        Neg,
        Abs,
        AbsNeg
    }

    // Determines if the first operand of an opcode is typically a destination.
    // Most arithmetic, texture sampling, and comparison opcodes write to operand[0].
    // Control flow (if/else/loop), declarations, and pure sources do not.
    private static bool IsDestinationOperand(OpcodeInfo info, int operandIndex)
    {
        // Only operand 0 can be a destination in most cases
        if (operandIndex != 0)
            return false;

        // Flow control and declarations don't have a real destination
        return info.Opcode switch
        {
            // Flow control
            Opcode.If => false,
            Opcode.Else => false,
            Opcode.EndIf => false,
            Opcode.Loop => false,
            Opcode.EndLoop => false,
            Opcode.BreakC => false,
            Opcode.Ret => false,
            Opcode.Retc => false,
            Opcode.Call => false,
            Opcode.CallC => false,
            Opcode.Case => false,
            Opcode.Default => false,
            Opcode.Switch => false,
            Opcode.EndSwitch => false,
            Opcode.Continue => false,
            Opcode.ContinueC => false,
            Opcode.Break => false,
            Opcode.Label => false,
            Opcode.Discard => false,

            // Declarations - these operands describe what's being declared, not destinations
            Opcode.DclConstantBuffer => false,
            Opcode.DclSampler => false,
            Opcode.DclResource => false,
            Opcode.DclInput => false,
            Opcode.DclInputPS => false,
            Opcode.DclInputSVG => false,
            Opcode.DclOutput => false,
            Opcode.DclOutputSIV => false,
            Opcode.DclTemps => false,
            Opcode.DclIndexableTemp => false,
            Opcode.DclUAV => false,
            Opcode.DclStream => false,
            Opcode.DclInterface => false,
            Opcode.DclIndexRange => false,
            Opcode.DclFunctionBody => false,
            Opcode.DclFunctionTable => false,
            Opcode.DclThreadGroup => false,
            Opcode.DclUAVRaw => false,
            Opcode.DclUAVStructured => false,
            Opcode.DclTGSMRaw => false,
            Opcode.DclTGSMStructured => false,
            Opcode.DclResourceRaw => false,
            Opcode.DclResourceStructured => false,

            // Everything else: arithmetic, texture ops, comparisons, etc. typically write to operand[0]
            _ => true
        };
    }

    private Operand DecodeOperand(BinaryReader reader, bool isDestination = false)
    {
        uint token = reader.ReadUInt32();

        Operand op = new();
        op.RawToken = token;
        op.IsDestinationOperand = isDestination;

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

        op.RawRegisterType = (byte)regType;
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

            op.Immediate32Values = new uint[count];

            for (int i = 0; i < count; i++)
                op.Immediate32Values[i] = reader.ReadUInt32();

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
            op.Immediate64RawBits = new ulong[count];

            for (int i = 0; i < count; i++)
            {
                ulong bits = reader.ReadUInt64();
                op.Immediate64RawBits[i] = bits;
                op.Immediate64Values[i] = BitConverter.UInt64BitsToDouble(bits);
            }

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
        op.IndexCount = indexCount;

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
        op.OperandControlField = (token >> 20) & 0x7FF;

        //--------------------------------------------------------
        // Extension token(s)
        // First extension token (if present) encodes a source
        // modifier (neg/abs/absneg). Further chained extension
        // tokens (bit 31 set again) are skipped - not modeled.
        //--------------------------------------------------------

        if (op.IsExtended)
        {
            uint ext;

            do
            {
                ext = reader.ReadUInt32();
                op.ExtensionTokens.Add(ext);

                // bits 0-5: D3D10_SB_EXTENDED_OPERAND_TYPE. Only EMPTY (0) and
                // MODIFIER (1) are defined for operand extension tokens today
                // (unlike instruction-level extended opcodes, which also have
                // resource-dim/return-type variants - see ParseExtendedOpcode).
                // Structured as a switch, not an inline assumption, so any
                // future extension type just falls through to "raw token
                // preserved, nothing decoded" instead of misparsing.
                uint extensionType = ext & 0x3F;

                switch (extensionType)
                {
                    case 1: // D3D10_SB_EXTENDED_OPERAND_MODIFIER
                        op.Modifier = (ext & 0xFF) switch
                        {
                            0x41 => OperandModifier.Neg,
                            0x81 => OperandModifier.Abs,
                            0xC1 => OperandModifier.AbsNeg,
                            _ => OperandModifier.None
                        };
                        break;

                    default:
                        // Unrecognized/future extension type - the raw token
                        // is already preserved in op.ExtensionTokens above,
                        // so no information is lost even though we don't
                        // interpret it yet.
                        break;
                }
            }
            while ((ext & 0x80000000) != 0);
        }
        
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

                case Operand.OperandIndexRepresentation.Immediate64:

                    // 64-bit immediate index (rare in practice - register
                    // indices this large don't occur - but must still be
                    // consumed correctly or every later operand desyncs).
                    ulong idx64 = reader.ReadUInt64();
                    op.Indices.Add(checked((uint)idx64));
                    break;

                case Operand.OperandIndexRepresentation.Relative:

                    op.RelativeOperands[i] = DecodeOperand(reader, isDestination: false);
                    op.Indices.Add(0);
                    break;

                case Operand.OperandIndexRepresentation.Immediate32PlusRelative:

                    op.Indices.Add(reader.ReadUInt32());
                    op.RelativeOperands[i] = DecodeOperand(reader, isDestination: false);
                    break;

                case Operand.OperandIndexRepresentation.Immediate64PlusRelative:

                    ulong idx64b = reader.ReadUInt64();
                    op.Indices.Add(checked((uint)idx64b));
                    op.RelativeOperands[i] = DecodeOperand(reader, isDestination: false);
                    break;

                default:
                    throw new InvalidDataException(
                        $"Unknown index representation {op.IndexRepresentation[i]}");
            }
        }

        if (op.Indices.Count > 0)
            op.RegisterIndex = op.Indices[0];

        op.OriginalRegisterIndex = op.RegisterIndex;

        // Safety check: if this is a destination operand with Mask mode and no mask bits
        // are set, that's likely a decoding error. Set mask to include all components
        // to avoid the issue where no components are marked as defined by SSA renaming.
        if (isDestination && op.ComponentMode == Operand.OperandComponentMode.Mask && op.Mask == 0)
        {
            op.Mask = 0xF; // All components (xyzw)
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

}
