# UnityShaderCompiler.exe — compilation pipeline analysis

Target: `UnityShaderCompiler.exe` (Unity 6), image base `0x140000000`.
Ghidra project: `C:\Users\Abby\Software\Ghidra Projects\UnityShaderCompiler\Unityshadercompiler`,
program `/UnityShaderCompiler.exe`.

Scope: the compilation path only — how a request enters the worker, how source is
prepared, which compiler backend runs, how the result is reflected, stripped and
sent back. Library internals (hlslcc, glslang, SPIRV-Cross, DXC itself) are out of
scope and only named where they are reached.

Evidence markers used throughout:

- **[V]** verified in this build: read from the decompiler, a string xref or a
  vtable dump during this analysis.
- **[I]** inferred from the surrounding structure; plausible but not proven.

Addresses are file offsets in this build. An older revision of this document used
a different build (`FUN_140022fb0`, `FUN_1400b8a50`, …); those addresses do not
exist in the current dispatch chain and have been replaced.

---

## 0. Executive summary

A request arrives over a loopback IPC stream as one line of text
(`Cmd: compileSnippet …`). `CmdDispatcher_Dispatch` dispatches on the command name to one of
eight handlers. Every handler then runs the same five stages:

1. **Prepare** — keyword macros, `UNITY_VERSION`, `SHADER_STAGE_*`,
   `SHADER_AVAILABLE_*` availability macros, and (for CGPROGRAM blocks with
   `#pragma surface`) a full source-to-source expansion of the surface shader.
2. **Split** — `#pragma` directives are parsed into a `ShaderPragmaSet`, the block
   is cut into per-stage sources (`// SHADER_STAGE_x_begin` … `_end`), and the
   stage set is validated.
3. **Compile** — a language index picks one of four frontends (D3D/HLSL, GLSL,
   Metal, D3D/HLSL). The D3D frontend drives either `D3DCompile` (FXC) or the
   packaged DXC through the plugin interface at `0x140578000`.
4. **Reflect + strip** — before the blob leaves the process, FXC results are
   reflected through `ProcessFxcReflectionAndValidate` (signatures, cbuffers, resources) and then
   passed through `D3DStripShader` with flags `7` (reflection+debug+test blobs) or
   `6` (debug+test blobs only, reflection kept). Compute kernels are stripped with
   `7` unless the caller asks to keep reflection **[V]**.
5. **Collect** — `CollectCompiledPrograms` walks the per-program results and appends each
   `{name, bytecode}` pair to the response; the editor stores the bytecode next to
   the reflection data it just received.

Because reflection runs **before** stripping, the metadata a player build loses
(cbuffer names, variable layout, resource bindings) is still serialized by the
editor next to the bytecode. That is exactly the `constantBuffers` array this
decompiler reads from the AssetStudio JSON, and it is why the DXBC blob alone is
not the whole story.

---

## 1. Process model and IPC

`RunShaderCompilerWorkerLoop` is the worker loop **[V]**: it connects a loopback stream
(`"127.0.0.1"`, `"Couldn't create IPC stream\n"`,
`"Couldn't connect IPC stream\n"`), reads commands, and on EOF reports
`"IPC connection closed"`.

```
// RunShaderCompilerWorkerLoop - worker main
void WorkerMain() {
    IpcStream stream = ConnectLoopback("127.0.0.1");   // fatal on failure
    for (;;) {
        CommandLine cmd = stream.ReadCommand();        // "Error reading command"
        if (cmd.IsEof) Fatal("IPC connection closed");
        DispatchCommand(stream, cmd);                  // CmdDispatcher_Dispatch
    }
}
```

Each frame on the stream starts with a magic + length header **[V]**
(`ReceiveIpcFrameMagic` receives and validates it, `SendIpcFrameMagic` writes it,
`ReadIpcStreamBytes` / `WriteIpcStreamBytes` are the byte-level read/write helpers; all four
raise `"IPC not initialized"` when the stream is unbound):

```
struct IpcFrame {          // little endian
    uint32 magic;          // 0x0C0BD1E4  ("Protocol error - failed to match magic number")
    uint64 size;           // payload byte count
    byte   payload[size];
};
```

`magic` is compared as a raw 32-bit value inside `ReceiveIpcFrameMagic`; a mismatch is
fatal, not recoverable.

The payload is a text command whose fields are separated by the `Cmd: ` dispatch
keys and `key=value` pairs. Handlers answer with the same framing, sometimes
prefixed with a label such as `"computeData: "` or `"rayTracingData: "` **[V]**.

---

## 2. Command dispatch

`CmdDispatcher_Dispatch` is a large `if/else` chain over the command string **[V]**.
All nine command names and all eight handlers were confirmed to be referenced
from this function:

```
// CmdDispatcher_Dispatch - command dispatcher
void DispatchCommand(IpcStream& stream, Utf8String cmd) {
    if (cmd == "Cmd: shutdown")                  ShutdownWorker();
    else if (cmd == "Cmd: preprocess")           HandlePreprocess(stream);              // HandlePreprocessCommand
    else if (cmd == "Cmd: disassembleShader")    HandleDisassemble(stream);             // HandleDisassembleShaderCommand
    else if (cmd == "Cmd: compileSnippet")       HandleCompileSnippet(stream);          // HandleCompileSnippetCommand
    else if (cmd == "Cmd: initializeCompiler")   HandleInitializeCompiler(stream);      // HandleInitializeCompilerCommand
    else if (cmd == "Cmd: preprocessCompute")    HandlePreprocessCompute(stream);       // HandleComputeKernelPreprocessRequest
    else if (cmd == "Cmd: compileComputeKernel") HandleCompileComputeKernel(stream);    // HandleCompileComputeKernelCommand
    else if (cmd == "Cmd: compileRayTracingShader")  HandleCompileRayTracing(stream);   // HandleCompileRayTracingShaderCommand
    else if (cmd == "Cmd: preprocessRayTracingShader") HandlePreprocessRayTracing(stream); // HandleRayTracingPreprocessRequest
    else ReportError(stream, "Unknown command: " + cmd);
}
```

| Command | Handler | Purpose |
|---|---|---|
| `preprocess` | `HandlePreprocessCommand` | expand macros/includes only; returns source |
| `disassembleShader` | `HandleDisassembleShaderCommand` | DXBC → text disassembly |
| `compileSnippet` | `HandleCompileSnippetCommand` | compile one CGPROGRAM block into per-stage blobs |
| `initializeCompiler` | `HandleInitializeCompilerCommand` | load/validate compiler libraries, report capabilities |
| `preprocessCompute` | `HandleComputeKernelPreprocessRequest` | compute preprocess (multi-kernel aware) |
| `compileComputeKernel` | `HandleCompileComputeKernelCommand` | compile named `#pragma kernel` entry points |
| `compileRayTracingShader` | `HandleCompileRayTracingShaderCommand` | compile a raytracing library |
| `preprocessRayTracingShader` | `HandleRayTracingPreprocessRequest` | raytracing preprocess |

---

## 3. Stage 1 — preparing source

### 3.1 Macro setup

Before preprocessing, the frontends build the keyword macro list and add the
engine's own defines **[V]**:

```
// GenerateD3dHlslStageSource (D3D frontend) and siblings
struct Macro { Utf8String name; Utf8String value; };

void BuildPrelude(MacroList& macros, const CompileRequest& req) {
    foreach (keyword in req.keywords)                      // multi_compile / shader_feature set
        macros.Add({keyword, "1"});
    macros.Add({"UNITY_VERSION", req.unityVersion});       // "UNITY_VERSION" @ 0x140583ff0
    foreach (stage in req.stages)                          // SHADER_STAGE_* @ 0x1405780d0.. block
        macros.Add({StageName(stage), "1"});               // SHADER_STAGE_VERTEX/FRAGMENT/HULL/DOMAIN/GEOMETRY/RAY_TRACING
}
```

`SetCompilerAvailabilityMacros` adds the two availability defines that gate every
`#if SHADER_API_…` / `#if SHADER_TARGET_…` block in Unity shader code **[V]**:

```
// SetCompilerAvailabilityMacros
void AddAvailabilityMacros(MacroList& macros, const CompilerCapabilities& caps) {
    macros.Add({"SHADER_TARGET_AVAILABLE" + caps.targetSuffix, "1"});
    macros.Add({"SHADER_AVAILABLE_" + caps.apiSuffix, "1"});   // e.g. SHADER_AVAILABLE_D3D11
    AddCompiledDefines(macros, caps);                          // FUN_1400b18a0
}
```

### 3.2 Surface shader expansion

A CGPROGRAM block containing `#pragma surface` is not compiled as written. The
preprocess handler and `ProcessSurfaceShaderBlock` call `GenerateSurfaceShaderPasses`, which rejects mixed
blocks (`"CGPROGRAM cannot contain #pragma surface as well as other programs"`)
and rewrites the block into ordinary generated HLSL **[V]**:

```
// GenerateSurfaceShaderPasses - surface shader expansion
Utf8String ExpandSurfaceBlock(const SurfaceDesc& surface) {
    Utf8String out = "// Surface shader code generated based on:\n";     // 0x14057f2c8
    if (surface.vertexModifier != null) out += "// vertex modifier: '" + surface.vertexModifier + "'\n";
    out += EmitLightingModel(surface);        // GenerateSurfaceLightingModel - Standard / StandardSpecular / ...
    out += EmitForwardBase(surface);          // FUN_140079e30 | FUN_14007b3c0 | FUN_14007c5c0 ...
    if (surface.forwardAdd)     out += EmitForwardAdd(surface);      // GenerateForwardAddPasses  "#pragma multi_compile_fwdadd"
    if (surface.prepassFinal)   out += EmitPrepassFinal(surface);    // GeneratePrepassFinalPasses  "#pragma multi_compile_prepassfinal"
    return out;
}
```

The generator is **per lighting model**, not generic: `GenerateSurfaceLightingModel` contains the
`"Standard"` / `"StandardSpecular"` model names and dispatches to one of five pass
emitters (`FUN_140079e30`, `FUN_14007b3c0`, `FUN_14007c5c0`, `FUN_14007e320`,
`FUN_140080890`), each of which calls the shared block emitters
`GenerateSurfacePassHeader` (header + `"// vertex shader"` / `"// fragment shader"` markers)
and `GenerateV2fStruct` (`struct v2f_` declarations) **[V]**. That structure is why a
reconstructed `#pragma surface surf <model>` is the right shape: the original
shader really was compiled from a model-specific template.

`GenerateSurfaceStructWrapper` is the companion transform that turns a **reflected** `surfInput`
/ `surfOutput` struct back into HLSL (`"surfInput"`, `"_hlslin_.%s"`,
`"_Semantic_"`) for the generated wrapper pass **[V]**.

### 3.3 `#pragma` parsing

`ParseShaderPragmaDirective` is the single pragma parser; every directive it recognizes is a
directive that can appear in a shader asset **[V]**:

```
// ParseShaderPragmaDirective - reconstructed dispatch shape
void ParsePragma(Utf8String text, ShaderPragmaSet& out) {
    switch (Directive(text)) {
    case "surface":              out.surface = text.arg1;                     break;
    case "target":               out.shaderTarget = ParseTarget(text);        break;
    case "only_renderers":       out.onlyRenderers = ParseRendererList(text); break; // "Unrecognized renderer for #pragma only_renderers: "
    case "exclude_renderers":    out.excludeRenderers = ParseRendererList(text); break;
    case "hardware_tier_variants": out.tierVariants = ...;                    break;
    case "multi_compile": case "shader_feature":
    case "multi_compile_local": case "shader_feature_local":
                                 out.keywords.Add(text.args);                 break;
    case "multi_compile_fwdbase": case "multi_compile_fwdadd":
    case "multi_compile_fwdadd_fullshadows": case "multi_compile_fog":
    case "multi_compile_prepassfinal": case "multi_compile_shadowcaster":
                                 out.keywordSets.Add(text.directive);         break;
    case "skip_variants":        out.skippedVariants.Add(...);                break;
    case "use_dxc":              out.useDxc = true;                           break;
    case "never_use_dxc":        out.neverUseDxc = true;                      break;
    case "prefer_hlslcc": case "prefer_hlsl2glsl":
    case "metal_use_hlslcc": case "metal_use_hlsl2glsl":
                                 out.backendHints.Add(text.directive);        break;
    case "glsl_no_optimize": case "skip_optimizations":
    case "disable_fastmath": case "force_concat_matrices":
    case "enable_d3d11_debug_symbols":
    case "enable_ray_tracing_shader_debug_symbols":
    case "hlslcc_bytecode_disassembly":
    case "enable_cbuffer": case "enable_bindsets":
    case "editor_sync_compilation": case "no_auto_normalization":
    case "glsl_no_auto_normalization": case "profiles": case "profileoption":
    case "fragmentoption": case "lighting": case "warning": case "debug":
    case "instancing_options": case "argument": case "require":
    case "max_recursion_depth": case "PSSL_target_output_format":
    case "enable_bounds_check_block_accesses": case "glsl_es2": case "pssl2":
    case "dynamic_branch": case "raytracing":
                                 out.flags.Set(text.directive);               break;
    default:                     out.warnings.Add(text + " // Unity: Unrecognised #pragma directive");
    }
}
```

`#pragma profiles` is explicitly ignored with
`"Note: #pragma profiles is ignored (use #pragma target instead): "` **[V]**.

### 3.4 Splitting and validation

`SplitSourceByPragmaDirective` walks the preprocessed text line by line, extracts the pragmas
through `ParseShaderPragmaDirective`, and builds one source segment per declared stage, framed
by `// SHADER_STAGE_<stage>_begin` / `_end` markers **[V]**. `CheckStageSlotsNotEmpty`
then validates the seven-entry stage slot array and, when every slot is empty,
emits the warning
`"CGPROGRAM block does not contain #pragma vertex, #pragma fragment or #pragma surface directive, skipping"`
and drops the block **[V]**. `CheckVertexAndFragmentPresent` applies the analogous rule for GLSL/
Metal/`HLSLcc` (`"Both vertex and fragment programs must be present in a shader snippet. Excluding it from compilation."`) **[V]**.

```
// SplitSourceByPragmaDirective + CheckStageSlotsNotEmpty
void SplitIntoStages(Utf8String preprocessed, StageSource stages[7]) {
    ShaderPragmaSet pragmas;
    foreach (line in preprocessed.Lines()) {
        if (line.StartsWith("#pragma")) { ParsePragma(line, pragmas); continue; }
        stages[pragmas.currentStage].Append(line);
    }
    if (stages.AllEmpty())
        Warn("CGPROGRAM block does not contain #pragma vertex, #pragma fragment "
             "or #pragma surface directive, skipping");
}
```

---

## 4. Stage 2 — backend selection

`HandleCompileSnippetCommand` indexes a four-entry function table with the request's language
index **[V]**:

```
// HandleCompileSnippetCommand
enum Backend : int { D3DHlsl = 0, GlslHlslcc = 1, MetalMsl = 2, D3DHlslAlt = 3 };

using FrontendFn = void (*)(CompileRequest&, StageSource[7]);
static const FrontendFn kFrontends[4] = {          // DAT_1400b4e6x
    /* 0 */ GenerateD3dHlslStageSource,                          // D3D / HLSL
    /* 1 */ GenerateGlslStageSource,                          // GLSL via HLSLcc/glslang
    /* 2 */ GenerateMetalShaderStageSource,                          // Metal (MSL)
    /* 3 */ GenerateD3dHlslStageSource,                          // D3D / HLSL (alias)
};

void HandleCompileSnippet(CompileRequest& req) {
    kFrontends[req.language](req, req.stages);      // falls through to the output collector
}
```

The three frontends differ in what they do to the source before compiling:

| Frontend | Extra work before compiling |
|---|---|
| `GenerateD3dHlslStageSource` (D3D) | prepends `#define` keyword macros, `UNITY_VERSION`, `SHADER_STAGE_*`; calls preprocess (`ProcessShaderPreprocessor`); validates stages (`CheckStageSlotsNotEmpty`) **[V]** |
| `GenerateGlslStageSource` (GLSL) | prepends macros, drops `#version`, splits pragmas (`SplitSourceByPragmaDirective`), rewrites `// #pragma ` → `#pragma `, injects `GLSLSupport.glslinc`, `UnityStereoExtensions.glslinc`, `UnityStereoSupport.glslinc`, renames `texture2D` → `textureExternal` and `texture2DProj` → `textureProjExternal` **[V]** |
| `GenerateMetalShaderStageSource` (Metal) | splits pragmas, prepends macros and `SHADER_STAGE_*`, rewrites `// #pragma `, converts `'` → `"`, then fills `VGlobals`/`FGlobals` through `FUN_140062940`, `FUN_1400630c0`, `FUN_1400625d0`, `FUN_1400621e0`, `FUN_1400640f0` **[V]** |

Only the D3D frontend produces DXBC. Everything this decompiler consumes comes
from that path.

---

## 5. Stage 3 — D3D compile, reflect, strip

### 5.1 Compiler selection

The D3D frontend does not call `D3DCompile` directly. It calls a slot on the
compiler-plugin interface at `0x140578000` **[V]**:

```
// compiler plugin interface, vtable @ 0x140578000
struct CompilerPlugin {
    virtual ~CompilerPlugin();                                // +0x00
    virtual void Reserved08();                                // +0x08
    virtual void Reserved10();                                // +0x10
    virtual void Reserved18();                                // +0x18
    virtual void Reserved20();                                // +0x20 / guard_check_icall
    virtual void CompileGraphics(CompileBatch&)  = 0;         // +0x28 -> InvokeGraphicsFxcCompilePlugin (FXC)
    virtual void Disassemble(BytecodeBatch&)     = 0;         // +0x30 -> InvokeBytecodeDisassemblePlugin
    virtual void CompileCompute(CompileBatch&)   = 0;         // +0x38 -> InvokeComputeFxcCompilePlugin (FXC)
    virtual void CompileGraphicsDxc(CompileBatch&) = 0;       // +0x40 -> InvokeGraphicsDxcCompilePlugin (DXC)
    virtual void Reserved48();                                // +0x48
};
```

The two thunks are thin:

```
// InvokeGraphicsFxcCompilePlugin -> FXC graphics
void InvokeCompilerFxc(CompileBatch& batch) {
    LoadD3DCompiler();                        // CheckForceDxcOnSwitch (FORCE_DXC_ON_SWITCH handling)
    InitCompilerState();                      // FUN_140110570
    CompileGraphicsFxc(batch);                // ProcessGraphicsFxcCompile
}

// InvokeGraphicsDxcCompilePlugin -> DXC
void InvokeCompilerDxc(CompileBatch& batch) {
    LoadD3DCompiler();
    CompileGraphicsDxc(batch);                // FUN_140039430 -> ProcessGraphicsDxcCompile
}
```

`CheckForceDxcOnSwitch` decides "force DXC anyway" for Switch (`"FORCE_DXC_ON_SWITCH"`,
`"FORCE_DXC_ON_SWITCH2"`) **[V]**. Otherwise `#pragma use_dxc` /
`#pragma never_use_dxc` (parsed in §3.3) pick the compiler.

### 5.2 The FXC pass

`ProcessGraphicsFxcCompile` is the graphics FXC implementation **[V]**. Its essential order is:

```
// ProcessGraphicsFxcCompile - one graphics compile (abridged)
void CompileGraphicsFxc(CompileBatch& batch) {
    AddAvailabilityMacros(batch.macros, batch.caps);           // SetCompilerAvailabilityMacros
    D3DBlob* blob = null;
    HRESULT hr = Fxc->Compile(                                // vtable +0x18 -> FUN_14008aec0 -> D3DCompile
        batch.source, batch.entryPoint, batch.profile,        // e.g. "vs_5_0" / "ps_5_0"
        batch.macros, batch.flags, &blob);

    if (FAILED(hr)) { ReportCompileErrors(blob); return; }     // "): error ", "): warning "

    if (!batch.skipReflection) {
        ReflectAndValidate(blob, batch, out.passMetadata);     // ProcessFxcReflectionAndValidate
    }
    if (!batch.skipStrip) {
        u32 stripFlags = batch.skipReflection ? 6 : 7;         // (bVar3 ^ 1) + 6
        D3DBlob* stripped = null;
        if (Fxc->Strip(blob, stripFlags, &stripped) >= 0)       // vtable +0x40 -> FUN_14008b400 -> D3DStripShader
            blob = stripped;
    }
    out.programs.Add({batch.entryPoint, blob});
}
```

`stripFlags` semantics (`D3DCOMPILER_STRIP_FLAGS`): bit `0x1` reflection data,
`0x2` debug info, `0x4` test blobs. So:

- `7` = reflection + debug + test blobs removed → RDEF/DEBUG/TESTBLOBS gone,
  ISGN/OSGN/PCSG/SHDR/SHEX/STAT survive.
- `6` = debug + test blobs removed, **reflection kept** → RDEF survives.

Both outcomes are legal in shipped data. A parser must not assume RDEF is absent.

The same wrapper object is reached through the global at `DAT_14074ece0`
(`(**(code **)*DAT_14074ece0)()` returns the API vtable), which is why the strip
call sites look indirect in the decompilation **[V]**.

### 5.3 Reflection and validation

`ProcessFxcReflectionAndValidate` is the FXC reflection pass **[V]**:

```
// ProcessFxcReflectionAndValidate - reflection + sanity checks (abridged)
void ReflectAndValidate(D3DBlob* blob, CompileBatch& batch, PassMetadata& out) {
    ID3D11ShaderReflection* refl = Fxc->Reflect(blob);          // vtable +0x38 -> FUN_14008b310 -> D3DReflect
    if (!refl) { Error("Failed to get HLSL Reflection interface"); return; }

    D3D11_SHADER_DESC desc = refl->GetDesc();

    for (uint i = 0; i < desc.InputParameters; ++i) {
        D3D11_SIGNATURE_PARAMETER_DESC p = refl->GetInputParameterDesc(i);
        out.inputs.Add({p.SemanticName, p.SemanticIndex, ChannelOf(p.SemanticName), p.Register});
    }
    for (uint i = 0; i < desc.ConstantBuffers; ++i) {
        ID3D11ShaderReflectionConstantBuffer* cb = refl->GetConstantBufferByIndex(i);
        D3D11_SHADER_BUFFER_DESC bd = cb->GetDesc();
        if (bd.Size > 0x10000) Error("The maximum size for Constant Buffers is %d bytes. Constant Buffer \"%s\" (%d bytes) exceeded the maximum size.");
        if (out.HasName(bd.Name)) Error("Duplicate constant buffer declaration: %s");
        if (bd.Type == D3D_SVC_STRUCT && strcmp(bd.Name, "UnityInstancing") == 0)
            out.instancing = true;
        foreach (var in cb.Variables where (var.uFlags & D3D_SVF_USED))
            out.variables.Add({var.Name, var.StartOffset, var.Size, var.Type});
    }
    for (uint i = 0; i < desc.BoundResources; ++i) {
        D3D11_SHADER_INPUT_BIND_DESC b = refl->GetResourceBindingDesc(i);   // verbatim 0x28 bytes kept
        out.resources.Add(b);
    }
}
```

The vertex-channel table is fixed (`"POSITION"`, `"NORMAL"`, `"TANGENT"`,
`"COLOR"`, `"TEXCOORD"`, `"BLENDWEIGHTS"`, `"BLENDINDICES"`) and lives in the same
function **[V]**. This is the same information the ISGN/OSGN chunks carry, which is
why `--verify-signatures` can cross-check reflection against `d3dcompiler`.

### 5.4 DXC path

`ProcessGraphicsDxcCompile` drives the packaged DXC **[V]**. Its arguments include
`/Qembed_debug`, `/Zpc`, `/auto-binding-space`, `/enable-16bit-types`, target
`HLSL`, and profile `lib_6_3` / `lib_6_6` for raytracing; errors are re-formatted
into Unity's `): error ` style. Reflection and result handling sit in
`ProcessDxcCompileResult` → `ProcessDxcReflectionResult` (`"Compilation failed: Couldn't retrieve shader
reflection information."`). DXC output is not DXBC, so it is out of scope for this
decompiler.

### 5.5 Collecting results

`CollectCompiledPrograms` walks the result object and appends each program **[V]**:

```
// CollectCompiledPrograms
void AppendPrograms(IpcResponse& response, const CompileResult& result) {
    uint count = result.Count();                      // vtable +0x30
    for (uint i = 0; i < count; ++i) {
        Utf8String name; D3DBlob* code; u32 size; u8 stage;
        result.Get(i, name, code, size, stage);       // vtable +0x38
        response.AddProgram(name, code, size, stage); // AppendProgramToResponse
    }
    FinalizeResponse(response);                       // FinalizeCompileResponse
}
```

`FinalizeCompileResponse` post-processes the response and can reject a result outright
(`"Surface shader Input structure needs INTERNAL_DATA for this WorldNormalVector or
WorldReflectionVector usage"`) **[V]**.

---

## 6. Compute kernels

`HandleCompileComputeKernelCommand` is the handler; the compile core is `ProcessComputeFxcCompile` **[V]**. It is
the same shape as §5.2 with three differences: `cs_5_0`, an entry-point lookup per
`#pragma kernel`, and reflection stripped by default.

```
// ProcessComputeFxcCompile - compute compile (abridged)
void CompileComputeKernel(CompileRequest& req) {
    foreach (kernel in req.kernels) {                       // "kernel: %s %i"
        StageSource cs = Preprocess(req.source, req.macros); // ProcessShaderPreprocessor
        void* entry = FindKernelEntry(cs, kernel.name);      // FindComputeKernelEntryPoint
        if (!entry) { Error("Did not find shader kernel '" + kernel.name + "'"); continue; }

        D3DBlob* blob = Fxc->Compile(cs, kernel.name, "cs_5_0", req.macros);   // vtable +0x18

        bool keepReflection = (req.flags[7] & 0x1004) != 0;  // bits 2 and 12
        if (!keepReflection) {
            D3DBlob* stripped = null;
            if (Fxc->Strip(blob, 7, &stripped) >= 0) blob = stripped;          // vtable +0x40
        }
        Emit(kernel.name, blob, threadGroupSize);
    }
}
```

Errors are reported as `"Compilation failed for kernel '%s' [0x%08x - unknown
error] '%s'"` / `"Compilation failed [0x%08x - %s]"` **[V]**.

`HandleComputeKernelPreprocessRequest` is the compute preprocess (multi-kernel source expansion) and
shares the preprocessor pipeline with the graphics path **[V]**.

---

## 7. Ray tracing

`HandleCompileRayTracingShaderCommand` (compile) and `HandleRayTracingPreprocessRequest` (preprocess) run the same pipeline
with `lib_6_3` / `lib_6_6` targets and the `"raytracing"` pragma. Both reuse
`ProcessShaderPreprocessor`, `PrepareStageSourceSegment`, `PrepareComputeStageSource`, `CollectCompiledPrograms` **[V]**. Metal
raytracing is explicitly rejected
(`"DXC: attempting to compile a raytracing shader stage for Metal - this is not yet
supported"`) and inline ray queries are rejected
(`"Inline Ray Tracing (Ray Queries) is not supported in Ray Tracing Shaders."`).

---

## 8. Disassembly and initialisation

- `HandleDisassembleShaderCommand` (`disassembleShader`) hands the blob to the plugin's
  `Disassemble` slot → `InvokeBytecodeDisassemblePlugin` → `ProcessDxbcDisassemble`, which produces text
  (`"// Failed to disassemble shader"`, `"// Invalid bytecode blob found"`) or an
  error (`"D3D11 shader compiler could not be loaded"`) **[V]**. A SPIR-V variant
  exists (`InvokeCompilerDisassembleSPIRV` → `ProcessSpirvDisassemble`).
- `HandleInitializeCompilerCommand` (`initializeCompiler`) loads and probes the compiler libraries and
  reports capabilities **[I]** (no user-visible strings; it initialises the plugin
  objects whose vtables are listed in §5.1).

---

## 9. D3DCompiler wrapper

`InitializeD3dCompilerLibrary` loads `D3DCompiler_47.dll` (`"Failed to read D3DCompiler DLL file"`)
and resolves seven entry points with `GetProcAddress`, in this order **[V]**:
`D3DCompile`, `D3DDisassemble`, `D3DAssemble`, `D3DPreprocess`, `D3DReflect`,
`D3DStripShader`, `D3DGetBlobPart`.

They are stored both in the object (offsets `+0x50` … `+0x80`) and in a vtable at
`0x1405891b0`:

| Slot | Address | API |
|---|---|---|
| `+0x18` | `FUN_14008aec0` | `D3DCompile` |
| `+0x20` | `FUN_14008ada0` | `D3DDisassemble` |
| `+0x28` | `FUN_14008b010` | `D3DAssemble` |
| `+0x30` | `FUN_14008b1f0` | `D3DPreprocess` |
| `+0x38` | `FUN_14008b310` | `D3DReflect` |
| `+0x40` | `FUN_14008b400` | `D3DStripShader` |
| `+0x48` | `FUN_14008b100` | `D3DGetBlobPart` |

The name strings sit back to back at `0x140584cd0` … `0x140584d30`; each stub
references its own name, which is how the mapping above was confirmed.

`FUN_14006a310` is a separate small probe that compiles a fixed `ps_5_0` snippet
and calls `GenerateSurfaceStructWrapper` — the surface-struct rewriter — presumably to validate
the generator's output on startup **[I]**.

---

## 10. What survives into the data this project reads

Scan of the checked-in fixtures (`tests/Fixtures/*/blob.bin`) **[V]**:

| Chunk | Present in fixture blobs |
|---|---|
| `RDEF` | **no** |
| `ISGN` | yes |
| `OSGN` | yes |
| `SHEX` | yes |
| `STAT`, `PCSG` | no (not needed by these graphics-only passes) |

That matches §5.2 with `stripFlags = 7`: reflection is extracted first, then
removed from the bytecode. Consequently:

- **Cbuffer names, variable layouts, resource bindings are not in the bytecode.**
  They come from Unity's serialized shader, which the editor writes immediately
  after reflection. `Shadermetadata.cs` reads exactly that (`constantBuffers` per
  pass) and its own comment already says the shipped bytecode has it stripped.
- **Signatures are recoverable from the bytecode** (ISGN/OSGN/PCSG), and they are
  the same data `ProcessFxcReflectionAndValidate` extracts, so `--verify-signatures` is comparing two
  independent copies of one fact rather than guessing.
- **Blobs with `RDEF` intact are legal** (`stripFlags = 6`, compute with
  `keepReflection`). The parser must keep accepting them — `RdefChunk` stays, it is
  just not the normal case.

---

## 11. Findings that shaped this decompiler

1. **Surface shaders are generated per lighting model** (§3.2). Reconstructing
   `#pragma surface surf <model>` plus an `Input` struct and a `surf()` body mirrors
   what `GenerateSurfaceShaderPasses` produced, instead of inventing a generic template. The
   compiled passes remain authoritative; `--keep-passes` keeps them visible.
2. **The generator's markers are stable**: `// Surface shader code generated based
   on:`, `// vertex shader`, `// fragment shader` **[V]**. They explain the comment
   shapes seen in decompiled surface shaders.
3. **Keyword sets are compile-time only.** `multi_compile`/`shader_feature` variants
   reach the compiler as plain `#define`s, so the only trace left in shipped data is
   the set of distinct bytecode variants. That is the basis for emitting variant
   bodies when a pass has ≤4 distinct keyword sets.
4. **`#pragma surface` blocks always carry a fixed pragma neighbourhood**
   (`multi_compile_fwdbase`, `multi_compile_fwdadd`, `multi_compile_fog`,
   `multi_compile_shadowcaster`, …) emitted by `GenerateForwardAddPasses` / `GeneratePrepassFinalPasses`
   **[V]**, so a reconstructed surface shader can reproduce the original's pragma
   list without guessing.
5. **Vertex channel mapping is a hard table in the compiler** (§5.3), so
   `uv_*`/`uv2_*` reconstruction from `_ST` transforms is the only free variable —
   the semantic → channel part is deterministic.
6. **`UNITY_VERSION`, `SHADER_STAGE_*`, `SHADER_AVAILABLE_*` are injected by the
   compiler, not written by the shader author** (§3.1). They must never be emitted
   as user code.
7. **Only the D3D frontend yields DXBC.** GLSL/Metal frontends rewrite the source
   (including `texture2D` → `textureExternal`), so their output cannot be fed to the
   DXBC/HLSL path; they are recognised but not decompiled.

---

## 12. Function inventory

Every function below carries this name and a plate comment in the Ghidra
database, so the names here and in the decompiler match. Addresses are virtual
addresses (image base `0x140000000`); `FUN_` prefixed entries are the few
functions left unnamed on purpose (see the note under each group). The D3D
pipeline has its decompiled bodies archived in [`decomp/`](decomp/); the
GLSL/Metal/WGSL backends are listed for orientation only and are not archived.

### Transport and dispatch

| Function | Address | Role |
|---|---|---|
| `RunShaderCompilerWorkerLoop` | `0x1400d0770` | worker main / command loop |
| `CmdDispatcher_Dispatch` | `0x1400cc6d0` | command dispatcher (`Cmd: …`) |
| `ReceiveIpcFrameMagic` | `0x1400c7ea0` | receive + verify frame magic |
| `SendIpcFrameMagic` | `0x1400c8c30` | send frame magic |
| `ReadIpcStreamBytes` | `0x1400c76e0` | byte-level stream read |
| `WriteIpcStreamBytes` | `0x1400c8820` | byte-level stream write |

### Command handlers

| Function | Address | Command |
|---|---|---|
| `HandlePreprocessCommand` | `0x1400b7db0` | `preprocess` |
| `HandleDisassembleShaderCommand` | `0x1400b5680` | `disassembleShader` |
| `HandleCompileSnippetCommand` | `0x1400b4e40` | `compileSnippet` |
| `HandleInitializeCompilerCommand` | `0x1400b5080` | `initializeCompiler` |
| `HandleComputeKernelPreprocessRequest` | `0x1400b6370` | `preprocessCompute` |
| `HandleCompileComputeKernelCommand` | `0x1400b4100` | `compileComputeKernel` |
| `HandleCompileRayTracingShaderCommand` | `0x1400b4760` | `compileRayTracingShader` |
| `HandleRayTracingPreprocessRequest` | `0x1400b7270` | `preprocessRayTracingShader` |

### Source preparation

| Function | Address | Role |
|---|---|---|
| `GenerateD3dHlslStageSource` | `0x1400b9770` | D3D/HLSL frontend |
| `GenerateGlslStageSource` | `0x1400b8600` | GLSL frontend |
| `GenerateMetalShaderStageSource` | `0x1400ba6e0` | Metal frontend |
| `SplitSourceByPragmaDirective` | `0x1400bd520` | pragma extraction + per-stage split |
| `ParseShaderPragmaDirective` | `0x1400c48f0` | `#pragma` parser (full directive list, §3.3) |
| `CheckStageSlotsNotEmpty` | `0x1400b84c0` | stage-slot validation ("does not contain #pragma vertex…") |
| `CheckVertexAndFragmentPresent` | `0x1400b3c90` | GLSL/Metal stage requirement check |
| `ProcessShaderPreprocessor` | `0x140097870` | preprocessor |
| `ProcessPreprocessorPragmaState` | `0x1400977c0` | preprocessor helper (pragma state) |
| `ProcessPreprocessorIncludeStack` | `0x140097ea0` | preprocessor helper (include stack) |
| `SetCompilerAvailabilityMacros` | `0x1400b0e60` | `SHADER_AVAILABLE_*` / `SHADER_TARGET_AVAILABLE*` macros |
| `PrepareCompileRequestSource` | `0x1400b0550` | compile-request source preparation **[I]** |
| `PrepareStageSourceSegment` | `0x1400b1070` | per-stage segment preparation **[I]** |
| `PrepareComputeStageSource` | `0x1400b13b0` | compute stage source preparation **[I]** |
| `PrepareBackendSourceBuffer` | `0x1400bacc0` | backend source buffer preparation **[I]** |
| `CollectCompiledPrograms` | `0x1400b1150` | append compiled programs to the response |
| `FinalizeCompileResponse` | `0x1400c1d10` | finalise response / emit validation error |
| `AppendProgramToResponse` | `0x140089750` | add one `{name, bytecode}` program |

`FUN_1400b18a0` (compiled-define accumulation, called from
`SetCompilerAvailabilityMacros`) is the one helper left unnamed.

### Surface shader generator

| Function | Address | Role |
|---|---|---|
| `ProcessSurfaceShaderBlock` | `0x1400c5ef0` | entry into surface expansion |
| `GenerateSurfaceShaderPasses` | `0x1400bec60` | CGPROGRAM → generated passes; rejects mixed blocks |
| `GenerateSurfaceLightingModel` | `0x140084d60` | lighting-model dispatch (`Standard`, `StandardSpecular`) |
| `FUN_140079e30` | `0x140079e30` | per-model pass emitter |
| `FUN_14007b3c0` | `0x14007b3c0` | per-model pass emitter |
| `FUN_14007c5c0` | `0x14007c5c0` | per-model pass emitter |
| `FUN_14007e320` | `0x14007e320` | per-model pass emitter |
| `FUN_140080890` | `0x140080890` | per-model pass emitter |
| `GenerateSurfacePassHeader` | `0x140082760` | header + vertex-modifier comments |
| `GenerateV2fStruct` | `0x1400749c0` | `struct v2f_` emission |
| `GenerateForwardAddPasses` | `0x14007acc0` | ForwardAdd pragmas |
| `GeneratePrepassFinalPasses` | `0x140079820` | prepass-final pragmas |
| `GenerateSurfaceAdditionalPass` | `0x14007deb0` | additional pass emitter **[I]** |
| `GenerateSurfaceStructWrapper` | `0x140085d60` | reflected `surfInput`/`surfOutput` → HLSL wrapper |

The five per-model emitters stay unnamed: their bodies are assembled from the
same shared block emitters and their lighting model is chosen by the caller,
so a name would assert a mapping that was not proven (see §3.2).

### Compilers

| Function | Address | Role |
|---|---|---|
| `InvokeGraphicsFxcCompilePlugin` | `0x140006e80` | plugin slot `+0x28` |
| `InvokeComputeFxcCompilePlugin` | `0x140006f90` | plugin slot `+0x38` |
| `InvokeBytecodeDisassemblePlugin` | `0x140006ec0` | plugin slot `+0x30` |
| `InvokeGraphicsDxcCompilePlugin` | `0x1400070f0` | plugin slot `+0x40` |
| `FUN_140039430` | `0x140039430` | DXC compile thunk |
| `ProcessGraphicsFxcCompile` | `0x1400317e0` | FXC graphics: compile → reflect → strip |
| `ProcessComputeFxcCompile` | `0x1400cb330` | FXC compute: kernel lookup → `cs_5_0` → strip |
| `FindComputeKernelEntryPoint` | `0x1400c34c0` | kernel entry-point lookup |
| `ProcessFxcReflectionAndValidate` | `0x1400218e0` | FXC reflection + validation (signatures, cbuffers, resources) |
| `ProcessDxbcDisassemble` | `0x140039190` | disassembler (DXBC / SPIR-V text) |
| `ProcessGraphicsDxcCompile` | `0x14010d2f0` | DXC driver (`lib_6_3` / `lib_6_6`, `HLSL`) |
| `ProcessDxcCompileResult` | `0x140113330` | DXC compile result handling |
| `ProcessDxcReflectionResult` | `0x14011a330` | DXC reflection result handling |
| `ProcessGlslangGraphicsCompile` | `0x14002ff60` | glslang graphics |
| `ProcessGlslangComputeCompile` | `0x140036a50` | glslang compute |
| `ProcessHlslccGraphicsCompile` | `0x140033340` | HLSLcc graphics |
| `ProcessHlslccComputeCompile` | `0x140037450` | HLSLcc compute |
| `ProcessWgslGraphicsCompile` | `0x140034ea0` | WGSL graphics |
| `ProcessComputeKernelCompileVariant` | `0x140037f90` | additional compute variant |
| `ProcessSpirvDisassemble` | `0x14002fbe0` | SPIR-V disassembly |
| `CheckForceDxcOnSwitch` | `0x140039af0` | `FORCE_DXC_ON_SWITCH*` decision |
| `InitializeD3dCompilerLibrary` | `0x14008f070` | `D3DCompiler_47.dll` loader (7 entry points) |
| `FUN_14008ada0` … `FUN_14008b400` | `0x14008ada0`–`0x14008b400` | `D3DCompile`, `D3DDisassemble`, … wrapper stubs (slot mapping in §9) |

The GLSL/Metal backends (glslang, HLSLcc, WGSL, SPIR-V) are named for
orientation only; this project only consumes the D3D path, so their bodies are
not analysed. The `D3DCompiler_47.dll` stubs stay unnamed because their real
names are the imported symbols they forward to (§9).

### Globals

| Address | Meaning |
|---|---|
| `0x140578000` | compiler-plugin interface vtable |
| `0x1405891b0` | `D3DCompiler_47.dll` wrapper vtable |
| `DAT_14074ece0` | compiler wrapper singleton (returns the API vtable) |
| `0x1405780d0` | `SHADER_STAGE_*` name block |

---

## 13. Not verified in this build

- The exact `D3DCompile` flag word passed per stage (only the profile/entry strings
  were confirmed).
- Which upstream condition sets `skipReflection` (`bVar3` in `ProcessGraphicsFxcCompile`); only
  its consequence — reflection-then-strip vs. pass-through — is proven.
- The internal meaning of `PrepareCompileRequestSource`, `PrepareStageSourceSegment`, `PrepareComputeStageSource`,
  `PrepareBackendSourceBuffer` and `GenerateSurfaceAdditionalPass` beyond their call position.
- `initializeCompiler`'s capability report layout (no strings; structure inferred
  from the plugin objects it initialises).
