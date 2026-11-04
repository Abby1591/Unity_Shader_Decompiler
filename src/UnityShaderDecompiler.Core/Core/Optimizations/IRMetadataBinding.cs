using Parser.DXBC;
using Parser.DXBC.Chunks;
using Parser.DXBC.IR;

namespace Parser.Core.Optimizations;

// Runs at the very end of the pipeline — after IROptimizationPipeline and
// IRShaderPatternRecognition have both reached their fixed point, so the
// IR is already in its final shape. Purely additive: attaches
// human-readable names (IRRegister.SymbolicName) from the DXBC
// container's own reflection chunks onto every register that already
// exists in the IR. Nothing about control flow, dataflow, or expression
// shape changes here — this only makes ToString() output readable, which
// is deliberate: HLSL generation should be a pure formatting pass over an
// IR that's already this readable, not the thing that has to go dig
// through RDEF/ISGN/OSGN itself.
//
// Sources used (all parsed elsewhere in the codebase):
//   RDEF resource bindings  -> cbuffer bind-slot -> RdefConstantBuffer,
//                               and t#/s#/u# bind-slot -> resource name
//   RDEF constant buffer variables -> byte offset -> variable name/type
//   ISGN/OSGN               -> v#/o# register -> semantic name+index
public static class IRMetadataBinding
{
    // D3D_SHADER_INPUT_TYPE (d3dcommon.h) — only the values that matter
    // for telling apart which bind-slot namespace (t#/s#/u#) a
    // RdefResourceBinding belongs to.
    private const uint SitCBuffer = 0;
    private const uint SitSampler = 3;
    private static readonly HashSet<uint> SitUav = new() { 4, 6, 8, 9, 10, 11 };
    // Everything else observed in practice (Texture=2, TBuffer=1,
    // Structured=5, ByteAddress=7, and any future SRV-shaped type) shares
    // the t# bind-slot namespace, so it's treated as "resource" by default.

    public static void Run(List<IRBlock> blocks, IRProgram program, DxbcFile file)
    {
        RdefChunk? rdef = file.ResourceDefinition;

        Dictionary<uint, RdefConstantBuffer> cbuffersBySlot = BuildConstantBufferSlots(rdef);
        Dictionary<uint, string> resourceNames = BuildResourceNames(rdef, isMatch: t => t != SitCBuffer && t != SitSampler && !SitUav.Contains(t));
        Dictionary<uint, string> samplerNames = BuildResourceNames(rdef, isMatch: t => t == SitSampler);
        Dictionary<uint, string> uavNames = BuildResourceNames(rdef, isMatch: SitUav.Contains);
        Dictionary<uint, SignatureElement> inputsByRegister = BuildSignatureSlots(file.InputSignature?.Elements);
        Dictionary<uint, SignatureElement> outputsByRegister = BuildSignatureSlots(file.OutputSignature?.Elements);

        foreach (IRBlock block in blocks)
        {
            foreach (IRStatement stmt in block.Statements)
            {
                foreach (IRRegister reg in stmt.Uses.Concat(stmt.Defines))
                {
                    Bind(reg, cbuffersBySlot, resourceNames, samplerNames, uavNames, inputsByRegister, outputsByRegister);
                }
            }
        }

        foreach (IRDeclaration decl in program.Declarations)
        {
            BindDeclaration(decl, cbuffersBySlot, resourceNames, samplerNames, uavNames, inputsByRegister, outputsByRegister);
        }
    }

    // Same idea as Bind() below, just for the dcl_* metadata objects
    // instead of register reads/writes — a constant buffer's own
    // dcl_constantbuffer gets the buffer's name (not a variable's — there's
    // no offset here, just the buffer as a whole), resources/samplers/UAVs
    // get their binding name, and inputs/outputs get their semantic.
    private static void BindDeclaration(
        IRDeclaration decl,
        Dictionary<uint, RdefConstantBuffer> cbuffersBySlot,
        Dictionary<uint, string> resourceNames,
        Dictionary<uint, string> samplerNames,
        Dictionary<uint, string> uavNames,
        Dictionary<uint, SignatureElement> inputsByRegister,
        Dictionary<uint, SignatureElement> outputsByRegister)
    {
        switch (decl)
        {
            case IRDeclaration.IRConstantBufferDeclaration cbDecl:
                if (cbuffersBySlot.TryGetValue(cbDecl.Slot, out RdefConstantBuffer? cb))
                    cbDecl.SymbolicName = cb.Name;
                break;

            case IRDeclaration.IRResourceDeclaration resDecl:
                if (resourceNames.TryGetValue(resDecl.Slot, out string? resName))
                    resDecl.SymbolicName = resName;
                break;

            case IRDeclaration.IRSamplerDeclaration sampDecl:
                if (samplerNames.TryGetValue(sampDecl.Slot, out string? sampName))
                    sampDecl.SymbolicName = sampName;
                break;

            case IRDeclaration.IRUAVDeclaration uavDecl:
                if (uavNames.TryGetValue(uavDecl.Slot, out string? uavName))
                    uavDecl.SymbolicName = uavName;
                break;

            case IRDeclaration.IRInputDeclaration inDecl:
                if (inputsByRegister.TryGetValue(inDecl.Register, out SignatureElement? inElem))
                    inDecl.SymbolicName = SemanticName(inElem);
                break;

            case IRDeclaration.IROutputDeclaration outDecl:
                if (outputsByRegister.TryGetValue(outDecl.Register, out SignatureElement? outElem))
                    outDecl.SymbolicName = SemanticName(outElem);
                break;
        }
    }

    private static void Bind(
        IRRegister reg,
        Dictionary<uint, RdefConstantBuffer> cbuffersBySlot,
        Dictionary<uint, string> resourceNames,
        Dictionary<uint, string> samplerNames,
        Dictionary<uint, string> uavNames,
        Dictionary<uint, SignatureElement> inputsByRegister,
        Dictionary<uint, SignatureElement> outputsByRegister)
    {
        switch (reg.RegisterType)
        {
            case RegisterType.ConstantBuffer:
                BindConstantBuffer(reg, cbuffersBySlot);
                break;

            case RegisterType.Resource:
                if (resourceNames.TryGetValue(reg.Index, out string? texName))
                    reg.SymbolicName = texName;
                break;

            case RegisterType.Sampler:
                if (samplerNames.TryGetValue(reg.Index, out string? sampName))
                    reg.SymbolicName = sampName;
                break;

            case RegisterType.Uav:
                if (uavNames.TryGetValue(reg.Index, out string? uavName))
                    reg.SymbolicName = uavName;
                break;

            case RegisterType.Input:
                if (inputsByRegister.TryGetValue(reg.Index, out SignatureElement? inElem))
                    reg.SymbolicName = SemanticName(inElem);
                break;

            case RegisterType.Output:
                if (outputsByRegister.TryGetValue(reg.Index, out SignatureElement? outElem))
                    reg.SymbolicName = SemanticName(outElem);
                break;
        }
    }

    // cb#[offset] -> the RdefVariable that owns byte-offset `offset*16`
    // within that buffer. Multi-slot variables (matrices, arrays) get an
    // explicit "[n]" relative-slot suffix so e.g. a matrix's four row
    // registers don't all collapse into the same indistinguishable name.
    private static void BindConstantBuffer(IRRegister reg, Dictionary<uint, RdefConstantBuffer> cbuffersBySlot)
    {
        if (reg.Indices.Count < 2)
            return; // whole-buffer reference (e.g. the dcl_constantbuffer statement itself) - nothing to name

        uint cbSlot = reg.Indices[0];
        if (!cbuffersBySlot.TryGetValue(cbSlot, out RdefConstantBuffer? cb))
            return;

        uint byteOffset = reg.Indices[1] * 16;

        RdefVariable? variable = cb.Variables.FirstOrDefault(v => byteOffset >= v.Offset && byteOffset < v.Offset + v.Size);
        if (variable is null)
            return;

        bool multiSlot = variable.Size > 16;
        reg.SymbolicName = multiSlot
            ? $"{variable.Name}[{(byteOffset - variable.Offset) / 16}]"
            : variable.Name;
    }

    // Join RDEF's resource-binding table (which has bind points but, for
    // cbuffers, only a name to join on) with RDEF's constant-buffer table
    // (which has the variables but no bind point of its own) by name, and
    // key the result by bind slot.
    private static Dictionary<uint, RdefConstantBuffer> BuildConstantBufferSlots(RdefChunk? rdef)
    {
        var result = new Dictionary<uint, RdefConstantBuffer>();
        if (rdef is null)
            return result;

        Dictionary<string, RdefConstantBuffer> byName = rdef.ConstantBuffers
            .GroupBy(cb => cb.Name)
            .ToDictionary(g => g.Key, g => g.First());

        foreach (RdefResourceBinding binding in rdef.ResourceBindings)
        {
            if (binding.Type == SitCBuffer && byName.TryGetValue(binding.Name, out RdefConstantBuffer? cb))
                result[binding.BindPoint] = cb;
        }

        return result;
    }

    private static Dictionary<uint, string> BuildResourceNames(RdefChunk? rdef, Func<uint, bool> isMatch)
    {
        var result = new Dictionary<uint, string>();
        if (rdef is null)
            return result;

        foreach (RdefResourceBinding binding in rdef.ResourceBindings)
        {
            if (isMatch(binding.Type))
                result[binding.BindPoint] = binding.Name;
        }

        return result;
    }

    private static Dictionary<uint, SignatureElement> BuildSignatureSlots(List<SignatureElement>? elements)
    {
        var result = new Dictionary<uint, SignatureElement>();
        if (elements is null)
            return result;

        foreach (SignatureElement element in elements)
        {
            // First element to claim a register wins — a register can in
            // principle be split across two elements with disjoint masks
            // (packed attributes); disambiguating that fully belongs with
            // the eventual HLSL input/output struct generation, not here.
            result.TryAdd(element.Register, element);
        }

        return result;
    }

    private static string SemanticName(SignatureElement element)
        => $"{element.SemanticName}{element.SemanticIndex}";
}