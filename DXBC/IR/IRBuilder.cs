using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR;

public partial class IRBuilder
{
    private readonly Dictionary<(RegisterType Type, uint Index), IRValueType> _registerTypes = new();
    
    public IRProgram Build(ShdrParser parser)
    {
        IRProgram program = new();

        foreach (Instruction instruction in parser.Instructions)
        {
            ConvertInstruction(program, instruction);
        }

        return program;
    }

    private void ConvertInstruction(IRProgram program, Instruction instruction)
    {
        switch (instruction.Opcode)
        {
            // Arithmetic
            case Opcode.Mov:
                BuildMov(program, instruction);
                break;

            case Opcode.Add:
                BuildAdd(program, instruction);
                break;
            
            case Opcode.IAdd:
                BuildIAdd(program, instruction);
                break;
            
            case Opcode.Sub:
                BuildSub(program, instruction);
                break;

            case Opcode.Mul:
                BuildMul(program, instruction);
                break;

            case Opcode.Div:
                BuildDiv(program, instruction);
                break;
            
            case Opcode.Neg:
                BuildNeg(program, instruction);
                break;

            case Opcode.Abs:
                BuildAbs(program, instruction);
                break;

            case Opcode.Min:
                BuildMin(program, instruction);
                break;

            case Opcode.Max:
                BuildMax(program, instruction);
                break;

            case Opcode.Mad:
                BuildMad(program, instruction);
                break;
            
            case Opcode.MovC:
                BuildMovC(program, instruction);
                break;
            
            case Opcode.Sqrt:
                BuildSqrt(program, instruction);
                break;

            case Opcode.Rsq:
                BuildRsqrt(program, instruction);
                break;

            case Opcode.Rcp:
                BuildRcp(program, instruction);
                break;

            case Opcode.Frc:
                BuildFrac(program, instruction);
                break;

            case Opcode.Exp:
                BuildExp(program, instruction);
                break;

            case Opcode.Log:
                BuildLog(program, instruction);
                break;

            case Opcode.Pow:
                BuildPow(program, instruction);
                break;

            case Opcode.Saturate:
                BuildSaturate(program, instruction);
                break;
            
            case Opcode.Dp2:
                BuildDp2(program, instruction);
                break;

            case Opcode.Dp3:
                BuildDp3(program, instruction);
                break;

            case Opcode.Dp4:
                BuildDp4(program, instruction);
                break;

            // Comparisons
            case Opcode.Eq:
                BuildEq(program, instruction);
                break;

            case Opcode.Ne:
                BuildNe(program, instruction);
                break;

            case Opcode.GE:
                BuildGE(program, instruction);
                break;

            case Opcode.Lt:
                BuildLt(program, instruction);
                break;
            
            case Opcode.IGe:
                BuildIge(program, instruction);
                break;

            case Opcode.ILt:
                BuildIlt(program, instruction);
                break;
            
            //Conversions
            
            case Opcode.Ftoi:
                BuildFtoi(program, instruction);
                break;

            case Opcode.RoundNI:
                BuildRoundNI(program, instruction);
                break;
            
            case Opcode.Ftou:
                BuildFtou(program, instruction);
                break;

            case Opcode.Itof:
                BuildItof(program, instruction);
                break;

            case Opcode.Utof:
                BuildUtof(program, instruction);
                break;
            
            //Declarations
            
            case Opcode.DclConstantBuffer:
                BuildConstantBuffer(program, instruction);
                break;
            
            case Opcode.DclSampler:
                BuildSampler(program, instruction);
                break;

            case Opcode.DclResource:
                BuildResource(program, instruction);
                break;
            
            case Opcode.DclInput:
                BuildInput(program, instruction);
                break;

            case Opcode.DclInputPS:
                BuildInputPS(program, instruction);
                break;

            case Opcode.DclOutput:
                BuildOutput(program, instruction);
                break;

            case Opcode.DclTemps:
                BuildTemps(program, instruction);
                break;
            
            //Texture
            
            case Opcode.Sample:
                BuildSample(program, instruction);
                break;

            case Opcode.SampleL:
                BuildSampleLevel(program, instruction);
                break;
            
            //Flow
            
            case Opcode.If:
                BuildIf(program, instruction);
                break;

            case Opcode.Else:
                BuildElse(program, instruction);
                break;

            case Opcode.EndIf:
                BuildEndIf(program, instruction);
                break;

            case Opcode.Loop:
                BuildLoop(program, instruction);
                break;

            case Opcode.EndLoop:
                BuildEndLoop(program, instruction);
                break;

            case Opcode.BreakC:
                BuildBreakC(program, instruction);
                break;

            case Opcode.Ret:
                BuildRet(program, instruction);
                break;
            
            //intrinsic
            
            case Opcode.SinCos:
                BuildSincos(program, instruction);
                break;

            // ===================== previously missing arithmetic/bitwise/comparison =====================

            case Opcode.ISub: BuildISub(program, instruction); break;
            case Opcode.UMul: BuildUMul(program, instruction); break;
            case Opcode.UDiv: BuildUDiv(program, instruction); break;
            case Opcode.IMul: BuildIMul(program, instruction); break;
            case Opcode.UMin: BuildUMin(program, instruction); break;
            case Opcode.UMax: BuildUMax(program, instruction); break;
            case Opcode.IMin: BuildIMin(program, instruction); break;
            case Opcode.IMax: BuildIMax(program, instruction); break;
            case Opcode.IMad: BuildIMad(program, instruction); break;
            case Opcode.Not: BuildNot(program, instruction); break;
            case Opcode.Or: BuildOr(program, instruction); break;
            case Opcode.Xor: BuildXor(program, instruction); break;
            case Opcode.Ishl: BuildIShl(program, instruction); break;
            case Opcode.Ushr: BuildUShr(program, instruction); break;
            case Opcode.Ishr: BuildIShr(program, instruction); break;
            case Opcode.CountBits: BuildCountBits(program, instruction); break;
            case Opcode.FirstBitHi: BuildFirstBitHi(program, instruction); break;
            case Opcode.FirstBitLo: BuildFirstBitLo(program, instruction); break;
            case Opcode.FirstBitSHi: BuildFirstBitSHi(program, instruction); break;
            case Opcode.ReverseBits: BuildReverseBits(program, instruction); break;
            case Opcode.Bfi: BuildBfi(program, instruction); break;
            case Opcode.Ubfe: BuildUbfe(program, instruction); break;
            case Opcode.Ibfe: BuildIbfe(program, instruction); break;
            case Opcode.INe: BuildIne(program, instruction); break;
            case Opcode.Le: BuildLe(program, instruction); break;
            case Opcode.Gt: BuildGt(program, instruction); break;
            case Opcode.Uge: BuildUge(program, instruction); break;
            case Opcode.Ult: BuildUlt(program, instruction); break;
            case Opcode.Ugt: BuildUgt(program, instruction); break;
            case Opcode.Ule: BuildUle(program, instruction); break;
            case Opcode.DerivRtx: BuildDerivRtx(program, instruction); break;
            case Opcode.DerivRty: BuildDerivRty(program, instruction); break;
            case Opcode.Any: BuildAny(program, instruction); break;
            case Opcode.All: BuildAll(program, instruction); break;
            case Opcode.Dp2Add: BuildDp2Add(program, instruction); break;

            // ===================== conversions =====================

            case Opcode.F16ToF32: BuildF16ToF32(program, instruction); break;
            case Opcode.F32ToF16: BuildF32ToF16(program, instruction); break;
            case Opcode.BitcastFloat: BuildBitcastFloat(program, instruction); break;
            case Opcode.BitcastInt: BuildBitcastInt(program, instruction); break;
            case Opcode.BitcastUInt: BuildBitcastUInt(program, instruction); break;

            // ===================== extended math =====================

            case Opcode.Lrp: BuildLrp(program, instruction); break;
            case Opcode.MSad: BuildMSad(program, instruction); break;
            case Opcode.Dst: BuildDst(program, instruction); break;
            case Opcode.Mul64: BuildMul64(program, instruction); break;
            case Opcode.UMul64: BuildUMul64(program, instruction); break;
            case Opcode.AddSat: BuildAddSat(program, instruction); break;
            case Opcode.MulSat: BuildMulSat(program, instruction); break;
            case Opcode.MadSat: BuildMadSat(program, instruction); break;

            // ===================== texture / buffer =====================

            case Opcode.LdMS: BuildLdMS(program, instruction); break;
            case Opcode.SampleInfo: BuildSampleInfo(program, instruction); break;
            case Opcode.SamplePos: BuildSamplePos(program, instruction); break;
            case Opcode.CheckAccessFullyMapped: BuildCheckAccessFullyMapped(program, instruction); break;
            case Opcode.Gather4: BuildGather4(program, instruction); break;
            case Opcode.Gather4C: BuildGather4C(program, instruction); break;
            case Opcode.Gather4Po: BuildGather4Po(program, instruction); break;
            case Opcode.Gather4PoC: BuildGather4PoC(program, instruction); break;
            case Opcode.Lod: BuildLod(program, instruction); break;
            case Opcode.ResInfo: BuildResInfo(program, instruction); break;
            case Opcode.BufInfo: BuildBufInfo(program, instruction); break;
            case Opcode.LdUAVTyped: BuildLdUAV(program, instruction); break;
            case Opcode.LdRaw: BuildLdRaw(program, instruction); break;
            case Opcode.LdStructured: BuildLdStructured(program, instruction); break;
            case Opcode.StoreRaw: BuildStoreRaw(program, instruction); break;
            case Opcode.StoreStructured: BuildStoreStructured(program, instruction); break;
            case Opcode.StoreUAV: BuildStoreUAV(program, instruction); break;
            case Opcode.SamplePo: BuildSamplePo(program, instruction); break;
            case Opcode.SamplePoC: BuildSamplePoC(program, instruction); break;
            case Opcode.SampleC: BuildSampleC(program, instruction); break;
            case Opcode.SampleCLZ: BuildSampleCLz(program, instruction); break;
            case Opcode.SampleB: BuildSampleB(program, instruction); break;
            case Opcode.SampleD: BuildSampleD(program, instruction); break;

            // ===================== declarations =====================

            case Opcode.DclUAV: BuildUAV(program, instruction); break;
            case Opcode.DclThreadGroup: BuildThreadGroup(program, instruction); break;
            case Opcode.DclIndexRange: BuildIndexRange(program, instruction); break;
            case Opcode.DclFunctionBody: BuildFunctionBody(program, instruction); break;
            case Opcode.DclFunctionTable: BuildFunctionTable(program, instruction); break;
            case Opcode.DclIndexableTemp: BuildIndexableTemp(program, instruction); break;
            case Opcode.DclStream: BuildStream(program, instruction); break;
            case Opcode.DclInterface: BuildInterface(program, instruction); break;
            case Opcode.DclInputControlPointCount: BuildInputControlPointCount(program, instruction); break;
            case Opcode.DclOutputControlPointCount: BuildOutputControlPointCount(program, instruction); break;
            case Opcode.DclHSMaxTessFactor: BuildHSMaxTessFactor(program, instruction); break;
            case Opcode.DclDomain: BuildDomain(program, instruction); break;
            case Opcode.DclPartitioning: BuildPartitioning(program, instruction); break;
            case Opcode.DclOutputTopology: BuildOutputTopology(program, instruction); break;
            case Opcode.DclTessOutputPrimitive: BuildTessOutputPrimitive(program, instruction); break;
            case Opcode.DclHSForkPhaseInstanceCount: BuildHSForkPhaseInstanceCount(program, instruction); break;
            case Opcode.DclHSJoinPhaseInstanceCount: BuildHSJoinPhaseInstanceCount(program, instruction); break;
            case Opcode.DclUAVRaw: BuildUAVRaw(program, instruction); break;
            case Opcode.DclUAVStructured: BuildUAVStructured(program, instruction); break;
            case Opcode.DclTGSMRaw: BuildTGSMRaw(program, instruction); break;
            case Opcode.DclTGSMStructured: BuildTGSMStructured(program, instruction); break;
            case Opcode.DclResourceRaw: BuildResourceRaw(program, instruction); break;
            case Opcode.DclResourceStructured: BuildResourceStructured(program, instruction); break;
            case Opcode.DclGSInstanceCount: BuildGSInstanceCount(program, instruction); break;

            // ===================== UAV atomics =====================

            case Opcode.AtomicIAdd: BuildAtomicIAdd(program, instruction); break;
            case Opcode.AtomicAnd: BuildAtomicAnd(program, instruction); break;
            case Opcode.AtomicOr: BuildAtomicOr(program, instruction); break;
            case Opcode.AtomicXor: BuildAtomicXor(program, instruction); break;
            case Opcode.AtomicIMin: BuildAtomicIMin(program, instruction); break;
            case Opcode.AtomicIMax: BuildAtomicIMax(program, instruction); break;
            case Opcode.AtomicUMin: BuildAtomicUMin(program, instruction); break;
            case Opcode.AtomicUMax: BuildAtomicUMax(program, instruction); break;
            case Opcode.AtomicCmpStore: BuildAtomicCmpStore(program, instruction); break;
            case Opcode.ImmAtomicIAdd: BuildImmAtomicIAdd(program, instruction); break;
            case Opcode.ImmAtomicAnd: BuildImmAtomicAnd(program, instruction); break;
            case Opcode.ImmAtomicOr: BuildImmAtomicOr(program, instruction); break;
            case Opcode.ImmAtomicXor: BuildImmAtomicXor(program, instruction); break;
            case Opcode.ImmAtomicIMin: BuildImmAtomicIMin(program, instruction); break;
            case Opcode.ImmAtomicIMax: BuildImmAtomicIMax(program, instruction); break;
            case Opcode.ImmAtomicUMin: BuildImmAtomicUMin(program, instruction); break;
            case Opcode.ImmAtomicUMax: BuildImmAtomicUMax(program, instruction); break;
            case Opcode.ImmAtomicExch: BuildImmAtomicExch(program, instruction); break;
            case Opcode.ImmAtomicCmpExch: BuildImmAtomicCmpExch(program, instruction); break;
            case Opcode.ImmAtomicAlloc: BuildImmAtomicAlloc(program, instruction); break;
            case Opcode.ImmAtomicConsume: BuildImmAtomicConsume(program, instruction); break;

            // ===================== synchronization =====================

            case Opcode.Sync: BuildSync(program, instruction); break;
            case Opcode.GroupMemoryBarrier: BuildGroupMemoryBarrier(program, instruction); break;
            case Opcode.GroupMemoryBarrierWithGroupSync: BuildGroupMemoryBarrierWithGroupSync(program, instruction); break;
            case Opcode.DeviceMemoryBarrier: BuildDeviceMemoryBarrier(program, instruction); break;
            case Opcode.DeviceMemoryBarrierWithGroupSync: BuildDeviceMemoryBarrierWithGroupSync(program, instruction); break;
            case Opcode.AllMemoryBarrier: BuildAllMemoryBarrier(program, instruction); break;
            case Opcode.AllMemoryBarrierWithGroupSync: BuildAllMemoryBarrierWithGroupSync(program, instruction); break;

            // ===================== geometry shader =====================

            case Opcode.Emit: BuildEmit(program, instruction); break;
            case Opcode.EmitStream: BuildEmitStream(program, instruction); break;
            case Opcode.Cut: BuildCut(program, instruction); break;
            case Opcode.CutStream: BuildCutStream(program, instruction); break;
            case Opcode.EmitThenCut: BuildEmitThenCut(program, instruction); break;
            case Opcode.EmitThenCutStream: BuildEmitThenCutStream(program, instruction); break;

            // ===================== hull shader =====================

            case Opcode.HSControlPointPhase: BuildHSControlPointPhase(program, instruction); break;
            case Opcode.HSForkPhase: BuildHSForkPhase(program, instruction); break;
            case Opcode.HSJoinPhase: BuildHSJoinPhase(program, instruction); break;

            // ===================== control flow additions =====================

            case Opcode.Call: BuildCall(program, instruction); break;
            case Opcode.CallC: BuildCallC(program, instruction); break;
            case Opcode.Case: BuildCase(program, instruction); break;
            case Opcode.Default: BuildDefault(program, instruction); break;
            case Opcode.Switch: BuildSwitch(program, instruction); break;
            case Opcode.EndSwitch: BuildEndSwitch(program, instruction); break;
            case Opcode.Continue: BuildContinue(program, instruction); break;
            case Opcode.ContinueC: BuildContinueC(program, instruction); break;
            case Opcode.Break: BuildBreak(program, instruction); break;
            case Opcode.Discard: BuildDiscard(program, instruction); break;
            case Opcode.Label: BuildLabel(program, instruction); break;

            // ===================== dynamic linkage =====================

            case Opcode.InterfaceCall: BuildInterfaceCall(program, instruction); break;
            case Opcode.InterfaceCallC: BuildInterfaceCallC(program, instruction); break;

            // ===================== double precision =====================

            case Opcode.DMov: BuildDMov(program, instruction); break;
            case Opcode.DMovC: BuildDMovC(program, instruction); break;
            case Opcode.DAdd: BuildDAdd(program, instruction); break;
            case Opcode.DSub: BuildDSub(program, instruction); break;
            case Opcode.DMul: BuildDMul(program, instruction); break;
            case Opcode.DDiv: BuildDDiv(program, instruction); break;
            case Opcode.DMax: BuildDMax(program, instruction); break;
            case Opcode.DMin: BuildDMin(program, instruction); break;
            case Opcode.DEq: BuildDEq(program, instruction); break;
            case Opcode.DGe: BuildDGe(program, instruction); break;
            case Opcode.DLt: BuildDLt(program, instruction); break;
            case Opcode.DNe: BuildDNe(program, instruction); break;
            case Opcode.DFma: BuildDFma(program, instruction); break;
            case Opcode.DRcp: BuildDRcp(program, instruction); break;
            case Opcode.DSqrt: BuildDSqrt(program, instruction); break;
            case Opcode.DRsq: BuildDRsq(program, instruction); break;
            case Opcode.DtoI: BuildDtoI(program, instruction); break;
            case Opcode.DtoU: BuildDtoU(program, instruction); break;
            case Opcode.ItoD: BuildItoD(program, instruction); break;
            case Opcode.UtoD: BuildUtoD(program, instruction); break;
            case Opcode.FtoD: BuildFtoD(program, instruction); break;
            case Opcode.DtoF: BuildDtoF(program, instruction); break;

            
            default:
                Console.WriteLine($"IR: Unsupported opcode {instruction.Name}");
                break;
        }
    }

    private IRExpression BuildExpression(Operand operand)
    {
        if (operand.RegisterType == RegisterType.Immediate32)
        {
            return new IRExpression.ConstantExpression
            {
                RawValues = operand.Immediate32Values,
                Kind = IRExpression.ConstantExpression.ConstantKind.Float
            };
        }

        return new IRExpression.RegisterExpression
        {
            Register = BuildRegister(operand)
        };
    }

    private IRExpression BuildIntExpression(Operand operand)
    {
        if (operand.RegisterType == RegisterType.Immediate32)
        {
            return new IRExpression.ConstantExpression
            {
                RawValues = operand.Immediate32Values!,
                Kind = IRExpression.ConstantExpression.ConstantKind.Int
            };
        }

        return new IRExpression.RegisterExpression
        {
            Register = BuildRegister(operand)
        };
    }

    private IRExpression BuildUIntExpression(Operand operand)
    {
        if (operand.RegisterType == RegisterType.Immediate32)
        {
            return new IRExpression.ConstantExpression
            {
                RawValues = operand.Immediate32Values!,
                Kind = IRExpression.ConstantExpression.ConstantKind.UInt
            };
        }

        return new IRExpression.RegisterExpression
        {
            Register = BuildRegister(operand)
        };
    }

    private IRExpression BuildDoubleExpression(Operand operand)
    {
        if (operand.RegisterType == RegisterType.Immediate64)
        {
            return new IRExpression.ConstantExpression
            {
                DoubleValues = operand.Immediate64Values!,
                Kind = IRExpression.ConstantExpression.ConstantKind.Double
            };
        }

        return new IRExpression.RegisterExpression
        {
            Register = BuildRegister(operand)
        };
    }
    
    private IRExpression BuildBoolExpression(Operand operand)
    {
        IRExpression expression = BuildExpression(operand);

        if (expression.Type == IRValueType.Bool)
            return expression;

        return new IRExpression.BinaryExpression
        {
            Operation = IRExpression.BinaryOperation.NotEqual,
            Left = expression,
            Right = new IRExpression.ConstantExpression
            {
                Kind = expression.Type switch
                {
                    IRValueType.Int => IRExpression.ConstantExpression.ConstantKind.Int,
                    IRValueType.UInt => IRExpression.ConstantExpression.ConstantKind.UInt,
                    _ => IRExpression.ConstantExpression.ConstantKind.Float
                },
                RawValues = new uint[] { 0 }
            }
        };
    }
    
        private void BuildUnaryIntrinsic(IRProgram program, Instruction instruction, IRExpression.IRIntrinsic intrinsic)
        {
            BuildUnaryIntrinsic(program, instruction, intrinsic, BuildExpression);
        }

        private void BuildUnaryIntrinsic(
            IRProgram program,
            Instruction instruction,
            IRExpression.IRIntrinsic intrinsic,
            Func<Operand, IRExpression> buildOperand)
        {
            IRExpression expression =
                new IRExpression.IntrinsicExpression
                {
                    Intrinsic = intrinsic,
                    Arguments = { buildOperand(instruction.Operands[1]) }
                };

            Emit(program, instruction, expression);
        }

        private void BuildBinaryIntrinsic(IRProgram program, Instruction instruction, IRExpression.IRIntrinsic intrinsic)
        {
            IRExpression expression =
                new IRExpression.IntrinsicExpression
                {
                    Intrinsic = intrinsic,
                    Arguments =
                    {
                        BuildExpression(instruction.Operands[1]),
                        BuildExpression(instruction.Operands[2])
                    }
                };

            Emit(program, instruction, expression);
        }

        private void BuildTernaryIntrinsic(IRProgram program, Instruction instruction, IRExpression.IRIntrinsic intrinsic)
        {
            IRExpression expression =
                new IRExpression.IntrinsicExpression
                {
                    Intrinsic = intrinsic,
                    Arguments =
                    {
                        BuildExpression(instruction.Operands[1]),
                        BuildExpression(instruction.Operands[2]),
                        BuildExpression(instruction.Operands[3])
                    }
                };

            Emit(program, instruction, expression);
        }

        // Destination is always Operands[0] and the expression always gets
        // AddAssignment'd to it — nearly every builder in this file was
        // repeating that pair of lines around whatever expression it built.
        private void Emit(IRProgram program, Instruction instruction, IRExpression expression)
        {
            AddAssignment(program, BuildRegister(instruction.Operands[0]), expression);
        }

        // Two-destination form (imul, udiv-with-remainder, etc). Either
        // destination may legally be the "null" register when the caller
        // only wants one half of the result.
        private void EmitMulti(
            IRProgram program,
            IRRegister destinationA, IRExpression expressionA,
            IRRegister destinationB, IRExpression expressionB)
        {
            var statement = new IRStatement.IRMultiAssignment();

            statement.Destinations.Add(destinationA.RegisterType == RegisterType.Null ? null : destinationA);
            statement.Expressions.Add(expressionA);

            statement.Destinations.Add(destinationB.RegisterType == RegisterType.Null ? null : destinationB);
            statement.Expressions.Add(expressionB);

            program.Statements.Add(statement);
        }

        // Builds `left <op> right` where both sides go through the same
        // typed operand builder (BuildExpression / BuildIntExpression /
        // BuildUIntExpression / BuildDoubleExpression), then emits it to
        // Operands[0]. Collapses e.g. BuildAdd/BuildIAdd/BuildDAdd into
        // one-line callers.
        private void BuildTypedBinary(
            IRProgram program,
            Instruction instruction,
            IRExpression.BinaryOperation operation,
            Func<Operand, IRExpression> buildOperand)
        {
            IRExpression expression =
                new IRExpression.BinaryExpression
                {
                    Operation = operation,
                    Left = buildOperand(instruction.Operands[1]),
                    Right = buildOperand(instruction.Operands[2])
                };

            Emit(program, instruction, expression);
        }

        // Same idea for a two-argument intrinsic call (min/max/etc) where
        // both arguments share a typed operand builder.
        private void BuildTypedBinaryIntrinsic(
            IRProgram program,
            Instruction instruction,
            IRExpression.IRIntrinsic intrinsic,
            Func<Operand, IRExpression> buildOperand)
        {
            IRExpression expression =
                new IRExpression.IntrinsicExpression
                {
                    Intrinsic = intrinsic,
                    Arguments =
                    {
                        buildOperand(instruction.Operands[1]),
                        buildOperand(instruction.Operands[2])
                    }
                };

            Emit(program, instruction, expression);
        }

        // Backs every eq/ne/ge/lt/ieq/ine/ige/ilt/uge/ult comparison opcode.
        // swap=true builds Operands[2] <op> Operands[1] instead of the
        // normal order — used for le/gt/ugt/ule, which SM4 synthesizes by
        // flipping operands around ge/lt rather than having real opcodes.
        private void BuildComparison(
            IRProgram program,
            Instruction instruction,
            IRExpression.BinaryOperation operation,
            Func<Operand, IRExpression> buildOperand,
            bool swap = false)
        {
            IRExpression left = buildOperand(instruction.Operands[swap ? 2 : 1]);
            IRExpression right = buildOperand(instruction.Operands[swap ? 1 : 2]);

            Emit(program, instruction, new IRExpression.BinaryExpression
            {
                Operation = operation,
                Left = left,
                Right = right
            });
        }

        // Backs ftoi/ftou/itof/utof and any other single-argument type cast.
        private void BuildCast(
            IRProgram program,
            Instruction instruction,
            IRExpression.IRIntrinsic intrinsic,
            Func<Operand, IRExpression> buildOperand)
        {
            Emit(program, instruction, new IRExpression.IntrinsicExpression
            {
                Intrinsic = intrinsic,
                Arguments = { buildOperand(instruction.Operands[1]) }
            });
        }

        // sincos and any other instruction that writes to multiple
        // independent destinations, any of which may legally be "null"
        // (DXBC's way of saying "discard this output").
        private void EmitIfNotNull(IRProgram program, Operand destinationOperand, IRExpression expression)
        {
            if (destinationOperand.RegisterType == RegisterType.Null)
                return;

            AddAssignment(program, BuildRegister(destinationOperand), expression);
        }

        // (a * b) + c, typed. Backs mad/imad/fma/dfma so the multiply-add
        // tree only gets built in one place.
        private void BuildFusedMultiplyAdd(
            IRProgram program,
            Instruction instruction,
            Func<Operand, IRExpression> buildOperand)
        {
            IRExpression expression =
                new IRExpression.FusedMultiplyAddExpression
                {
                    A = buildOperand(instruction.Operands[1]),
                    B = buildOperand(instruction.Operands[2]),
                    C = buildOperand(instruction.Operands[3])
                };

            Emit(program, instruction, expression);
        }

        private IRRegister BuildRegister(Operand operand)
    {
        IRRegister reg = new()
        {
            RegisterType = operand.RegisterType,
            Type = GetRegisterType(operand.RegisterType, operand.RegisterIndex),
            Index = operand.RegisterIndex,

            Mask = operand.Mask,

            ComponentMode = operand.ComponentMode,
            Swizzle = operand.Swizzle,
            Component = operand.Component,

            Modifier = operand.Modifier
        };

        foreach (uint i in operand.Indices)
            reg.Indices.Add(i);

        // Relative/dynamic indexing (cb0[r2.x + 4], x0[r2.y], etc.) was
        // previously parsed into Operand.RelativeOperands but silently
        // discarded here — only the constant Indices made it into the IR.
        for (int i = 0; i < operand.RelativeOperands.Length; i++)
        {
            if (operand.RelativeOperands[i] is { } relativeOperand)
                reg.RelativeIndices[i] = BuildUIntExpression(relativeOperand);
        }

        return reg;
    }
    
    private void AddAssignment(IRProgram program, IRRegister destination, IRExpression expression)
    {
        if (expression.Type != IRValueType.Unknown)
        {
            destination.Type = expression.Type;
            SetRegisterType(destination);
        }

        program.Statements.Add(
            new IRStatement.IRAssignment
            {
                Destination = destination,
                Expression = expression
            });
    }
    
    private void SetRegisterType(IRRegister register)
    {
        _registerTypes[(register.RegisterType, register.Index)] = register.Type;
    }

    private IRValueType GetRegisterType(RegisterType type, uint index)
    {
        if (_registerTypes.TryGetValue((type, index), out var value))
            return value;

        return IRValueType.Unknown;
    }
    
}