using UnityShaderDecompiler.Core.DXBC.IR;

namespace UnityShaderDecompiler.Core.DXBC.Instructions;

// D3D10_SB_TOKENIZED_PROGRAM_TYPE - decoded from bits 16-31 of the
// shader version token.
public enum ShaderProgramType
{
    Pixel = 0,
    Vertex = 1,
    Geometry = 2,
    Hull = 3,
    Domain = 4,
    Compute = 5,
    Unknown = 0xFFFF
}

public partial class ShdrParser
{
    public uint VersionToken { get; private set; }
    public uint DeclaredDwordCount { get; private set; }

    // Decoded from VersionToken: bits 0-3 minor version, bits 4-7 major
    // version, bits 16-31 program type (shader stage).
    public uint MinorVersion { get; private set; }
    public uint MajorVersion { get; private set; }
    public ShaderProgramType ProgramType { get; private set; }

    // Human-readable shader model string, e.g. "ps_5_0", "vs_4_1", "cs_5_0".
    public string ShaderModel =>
        $"{ProgramTypeAbbreviation(ProgramType)}_{MajorVersion}_{MinorVersion}";

    // Number of instructions actually decoded (distinct from
    // DeclaredDwordCount, which is the total DWORD length of the program
    // including the two header DWORDs, not an instruction tally).
    public int InstructionCount => Instructions.Count;

    private static string ProgramTypeAbbreviation(ShaderProgramType type) => type switch
    {
        ShaderProgramType.Pixel => "ps",
        ShaderProgramType.Vertex => "vs",
        ShaderProgramType.Geometry => "gs",
        ShaderProgramType.Hull => "hs",
        ShaderProgramType.Domain => "ds",
        ShaderProgramType.Compute => "cs",
        _ => "unknown"
    };

    public List<Instruction> Instructions { get; } = new();
    public List<string> Warnings { get; } = new();

    //------------------------------------------------------------------
    // Extended opcode tokens. For now this just stores the raw DWORD so
    // the parser stays synchronized. Later this should decode aoffimmi,
    // resource return type, etc. based on the extended opcode type in
    // bits 0-5 of the token.
    //------------------------------------------------------------------

    private void ParseExtendedOpcode(uint token, Instruction instruction)
    {
        instruction.ExtendedOpcode = token;

        // bits 0-5: extended opcode type. Type 1 is "sample controls"
        // (aoffimmi) - three signed 4-bit texel offsets (U/V/W) packed
        // into bits 9-12 / 13-16 / 17-20.
        uint extType = token & 0x3F;

        if (extType == 1)
        {
            instruction.HasSampleControls = true;
            instruction.AoffimmiU = SignExtend4((token >> 9) & 0xF);
            instruction.AoffimmiV = SignExtend4((token >> 13) & 0xF);
            instruction.AoffimmiW = SignExtend4((token >> 17) & 0xF);
        }
        else if (extType == 2)
        {
            // bits 6-10: resource dimension, bits 11-16: structure stride
            // (only meaningful for RESOURCE_DIMENSION_STRUCTURED_BUFFER)
            instruction.HasResourceDim = true;
            instruction.ResourceDim = (token >> 6) & 0x1F;
            instruction.ResourceStructureStride = (token >> 11) & 0xFFF;
        }
        else if (extType == 3)
        {
            // bits 6-9/10-13/14-17/18-21: return type per component (x/y/z/w)
            instruction.HasResourceReturnType = true;
            instruction.ResourceReturnTypeX = (token >> 6) & 0xF;
            instruction.ResourceReturnTypeY = (token >> 10) & 0xF;
            instruction.ResourceReturnTypeZ = (token >> 14) & 0xF;
            instruction.ResourceReturnTypeW = (token >> 18) & 0xF;
        }
    }

    // Sign-extend a 4-bit immediate (range -8..7) stored in the low
    // nibble of an unsigned value.
    private static sbyte SignExtend4(uint value)
    {
        return (sbyte)((value & 0x8) != 0 ? (int)value - 16 : (int)value);
    }

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

    public void Parse(byte[] data)
    {
        using var stream = new MemoryStream(data);
        using var reader = new BinaryReader(stream);

        VersionToken = reader.ReadUInt32();

        MinorVersion = VersionToken & 0xF;
        MajorVersion = (VersionToken >> 4) & 0xF;

        uint programTypeValue = (VersionToken >> 16) & 0xFFFF;
        ProgramType = Enum.IsDefined(typeof(ShaderProgramType), (int)programTypeValue)
            ? (ShaderProgramType)programTypeValue
            : ShaderProgramType.Unknown;

        DeclaredDwordCount = reader.ReadUInt32();

        // Parse up to the declared shader size (in DWORDs), not just
        // until we happen to hit a RET or run out of stream. Clamp to
        // the actual buffer length in case the declared count lies.
        long declaredEndByte = (long)DeclaredDwordCount * 4;
        long parseEndByte = Math.Min(declaredEndByte, reader.BaseStream.Length);

        if (declaredEndByte != reader.BaseStream.Length)
        {
            Warnings.Add($"Declared shader size ({DeclaredDwordCount} DWORDs) does not match chunk data length ({reader.BaseStream.Length / 4} DWORDs).");
        }

        while (reader.BaseStream.Position < parseEndByte)
        {
            long instructionStartByte = reader.BaseStream.Position;
            int instructionStart = (int)(instructionStartByte / 4);

            uint token = reader.ReadUInt32();

            int opcodeValue = (int)(token & 0x7FF);

            //------------------------------------------------------------------
            // CUSTOMDATA (opcode 53) is the only opcode whose length is NOT
            // taken from bits 24-30 - it has its own length DWORD that
            // immediately follows, covering the whole custom data block
            // (including the two header DWORDs already read). Handle it
            // before any of the normal length/operand logic runs, or the
            // parser will desync on every shader that uses it (e.g. for
            // immediate constant buffers).
            //------------------------------------------------------------------

            if (opcodeValue == 53)
            {
                uint customLength = reader.ReadUInt32();

                var customInstruction = new Instruction
                {
                    Opcode = Opcode.CustomData,
                    Name = "customdata",
                    OpcodeToken = token,
                    DwordOffset = instructionStart,
                    CustomDataLength = customLength,
                    CustomData = reader.ReadBytes((int)((customLength - 2) * 4))
                };

                customInstruction.Length = (int)customLength;

                customInstruction.InstructionIndex = Instructions.Count;
                Instructions.Add(customInstruction);
                continue;
            }

            int length = (int)((token >> 24) & 0x7F);

            if (length == 0)
            {
                Warnings.Add($"Invalid instruction at DWORD {instructionStart}");
                break;
            }

            OpcodeInfo info = DecodeOpcode((uint)opcodeValue);

            if (info.Opcode == Opcode.Unknown)
            {
                Warnings.Add($"Warning: Unknown opcode {opcodeValue} at DWORD {instructionStart}. Skipping {length} DWORDs.");
            }

            var instruction = new Instruction
            {
                Opcode = info.Opcode,
                Name = info.Name,
                OpcodeToken = token,
                Length = length,
                DwordOffset = instructionStart,

                // bit 13: saturate result
                Saturate = (token & 0x2000) != 0,

                // bit 31: this opcode token is followed by an extended
                // opcode token
                HasExtendedOpcode = (token & 0x80000000) != 0,

                // bit 18: test boolean (used by breakc/if/continuec/retc/etc.)
                TestBoolean = (InstructionTestBoolean)((token >> 18) & 1),

                // bits 19-22: "precise" flags, one bit per component (xyzw)
                Precise = (byte)((token >> 19) & 0xF),

                // bits 11-23: raw opcode-specific control bits, meaning
                // varies per opcode - see field doc comment on Instruction.
                OpcodeControls = (token >> 11) & 0x1FFF
            };

            //------------------------------------------------------------------
            // Extended opcode token(s). Each is decoded via
            // ParseExtendedOpcode(); if bit 31 is set again, another
            // extension token follows immediately (chained extensions),
            // so keep decoding until a token without bit 31 is read.
            //------------------------------------------------------------------

            if (instruction.HasExtendedOpcode)
            {
                uint ext;

                do
                {
                    ext = reader.ReadUInt32();
                    ParseExtendedOpcode(ext, instruction);
                }
                while ((ext & 0x80000000) != 0);
            }

            if (opcodeValue == 88) // dcl_resource
            {
                uint resourceDim = (token >> 11) & 0xF;
                instruction.ExtraData.Add(resourceDim);
                instruction.DeclaredResourceDimension = resourceDim.ToResourceDimension();
            }
            else if (opcodeValue == 90) // dcl_sampler
            {
                uint samplerMode = (token >> 11) & 0xF;
                instruction.ExtraData.Add(samplerMode);
            }
            else if (opcodeValue == 89)
            {
                uint indexType = (token >> 11) & 0x1;
                instruction.ExtraData.Add(indexType);
            }
            else if (opcodeValue == 98) // dcl_input_ps: interpolation mode, bits 11-14
            {
                instruction.Interpolation = (InterpolationMode)((token >> 11) & 0xF);
            }
            else if (opcodeValue == 190) // sync: D3D11_SB_SYNC_* flags, bits 11-14
            {
                instruction.SyncThreadsInGroup = (token & 0x00000800) != 0;
                instruction.SyncThreadGroupSharedMemory = (token & 0x00001000) != 0;
                instruction.SyncUAVMemoryGroup = (token & 0x00002000) != 0;
                instruction.SyncUAVMemoryGlobal = (token & 0x00004000) != 0;
            }

            for (int i = 0; i < info.OperandCount; i++)
            {
                try
                {
                    bool isDestination = IsDestinationOperand(info, i);
                    Operand operand = DecodeOperand(reader, isDestination);
                    
                    instruction.Operands.Add(operand);

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
                case 96:
                    instruction.ExtraData.Add(reader.ReadUInt32()); // system-value semantic
                    break;
                
                //----------------------------------------------------------
                // dcl_output_siv
                //----------------------------------------------------------
                
                case 103:
                    instruction.ExtraData.Add(reader.ReadUInt32());
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
                //----------------------------------------------------------
                // dcl_tessellator_domain / partitioning / output_primitive
                // - value is packed directly into opcode-specific control
                // bits (11+), same pattern as dcl_input_ps interpolation.
                // Populated as ExtraData[0] since BuildDomain/BuildPartitioning/
                // BuildOutputTopology already read it from there.
                //----------------------------------------------------------
                case 149: // dcl_tessellator_domain, bits 11-12
                    instruction.ExtraData.Add((token >> 11) & 0x3);
                    break;

                case 150: // dcl_tessellator_partitioning, bits 11-13
                    instruction.ExtraData.Add((token >> 11) & 0x7);
                    break;

                case 151: // dcl_tessellator_output_primitive, bits 11-13
                    instruction.ExtraData.Add((token >> 11) & 0x7);
                    break;

                case 106:
                    break;

                //----------------------------------------------------------
                // dcl_hs_fork_phase_instance_count / dcl_hs_join_phase_instance_count
                // - 1 raw immediate DWORD: instance count
                //----------------------------------------------------------
                case 153:
                case 154:
                    instruction.ExtraData.Add(reader.ReadUInt32());
                    break;

                //----------------------------------------------------------
                // dcl_uav_structured - 1 raw immediate DWORD: structure stride
                //----------------------------------------------------------
                case 158:
                    instruction.ExtraData.Add(reader.ReadUInt32());
                    break;

                //----------------------------------------------------------
                // dcl_tgsm_raw - 1 raw immediate DWORD: byte count
                //----------------------------------------------------------
                case 159:
                    instruction.ExtraData.Add(reader.ReadUInt32());
                    break;

                //----------------------------------------------------------
                // dcl_tgsm_structured - 2 raw immediate DWORDs: stride, count
                //----------------------------------------------------------
                case 160:
                    instruction.ExtraData.Add(reader.ReadUInt32()); // structure stride
                    instruction.ExtraData.Add(reader.ReadUInt32()); // element count
                    break;

                //----------------------------------------------------------
                // dcl_resource_structured - 1 raw immediate DWORD: structure stride
                //----------------------------------------------------------
                case 162:
                    instruction.ExtraData.Add(reader.ReadUInt32());
                    break;

                //----------------------------------------------------------
                // dcl_gs_instance_count - 1 raw immediate DWORD: instance count
                //----------------------------------------------------------
                case 206:
                    instruction.ExtraData.Add(reader.ReadUInt32());
                    break;

                //----------------------------------------------------------
                // dcl_indexableTemp - 3 raw immediate DWORDs: register
                // index, number of registers, number of components.
                // Not encoded as normal operand tokens.
                //----------------------------------------------------------
                case 105:
                    instruction.ExtraData.Add(reader.ReadUInt32()); // register index
                    instruction.ExtraData.Add(reader.ReadUInt32()); // num registers
                    instruction.ExtraData.Add(reader.ReadUInt32()); // num components
                    break;

                //----------------------------------------------------------
                // dcl_thread_group - 3 raw immediate DWORDs: x, y, z
                // thread group sizes. Not encoded as normal operand tokens.
                //----------------------------------------------------------
                case 155:
                    instruction.ExtraData.Add(reader.ReadUInt32()); // x
                    instruction.ExtraData.Add(reader.ReadUInt32()); // y
                    instruction.ExtraData.Add(reader.ReadUInt32()); // z
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
                Warnings.Add($"Instruction desync after {info.Name}: expected DWORD {expectedEnd}, got {actualEnd}");
            }

            //------------------------------------------------------------------
            // Move to the official end of the instruction.
            //------------------------------------------------------------------

            reader.BaseStream.Position = instructionStartByte + length * 4;

            instruction.InstructionIndex = Instructions.Count;
            Instructions.Add(instruction);
        }
    }
}
