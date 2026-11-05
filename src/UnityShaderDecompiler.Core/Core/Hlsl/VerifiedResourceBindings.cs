using System.IO;
using UnityShaderDecompiler.Core.Hlsl.Ast;

namespace UnityShaderDecompiler.Core.Hlsl;

// Rejects missing identities and incompatible resource layouts before emission.
internal static class VerifiedResourceBindings
{
    // Requires a name recovered from reflection or serialized binding metadata.
    internal static string RequireName(string? name, string kind, uint slot)
    {
        if (string.IsNullOrWhiteSpace(name))
        {
            throw new InvalidDataException($"Missing {kind} binding name at slot {slot}; resource parameter metadata is required.");
        }
        return name;
    }

    // Combines only resources whose identities and layouts agree across stages.
    internal static void Attach(List<HlslResourceNode> resources, HlslResourceNode incoming, string stage)
    {
        incoming.Stage = stage;
        Validate(incoming);
        HlslResourceNode? existing = resources.FirstOrDefault(item => item.Kind == incoming.Kind && item.Slot == incoming.Slot);
        HlslResourceNode? duplicate = resources.FirstOrDefault(item => item.Name == incoming.Name && item != existing);
        if (duplicate is not null)
        {
            throw new InvalidDataException($"Resource {incoming.Name} has incompatible bindings in {duplicate.Stage} and {stage}.");
        }
        if (existing is null)
        {
            resources.Add(incoming);
            return;
        }
        if (existing.Name != incoming.Name || existing.TypeHint != incoming.TypeHint)
        {
            throw new InvalidDataException($"Conflicting {incoming.Kind} slot {incoming.Slot}: {existing.Stage} {existing.Name}, {stage} {incoming.Name}.");
        }
        foreach (HlslCBufferVariable variable in incoming.Variables)
        {
            MergeVariable(existing, variable);
        }
    }

    // Requires named, non-overlapping members instead of replacement storage.
    internal static void Validate(HlslResourceNode resource)
    {
        RequireName(resource.Name, resource.Kind.ToString(), resource.Slot);
        if (resource.Kind != HlslResourceKind.ConstantBuffer)
        {
            return;
        }
        HlslResourceNode checkedLayout = new HlslResourceNode { Name = resource.Name };
        foreach (HlslCBufferVariable variable in resource.Variables)
        {
            RequireName(variable.Name, "constant-buffer member", resource.Slot);
            if (string.IsNullOrWhiteSpace(variable.TypeName) || variable.Size == 0)
            {
                throw new InvalidDataException($"Incomplete member layout for {resource.Name}.{variable.Name}.");
            }
            MergeVariable(checkedLayout, variable);
        }
    }

    // Rejects duplicate names instead of inventing new runtime binding names.
    internal static void ValidatePass(IEnumerable<HlslResourceNode> resources)
    {
        HashSet<string> names = new HashSet<string>(StringComparer.Ordinal);
        foreach (HlslResourceNode resource in resources)
        {
            Validate(resource);
            if (!names.Add(resource.Name))
            {
                throw new InvalidDataException($"Duplicate resource name {resource.Name}; cannot invent a replacement binding.");
            }
        }
    }

    // Preserves members only when their byte ranges and types are compatible.
    private static void MergeVariable(HlslResourceNode resource, HlslCBufferVariable incoming)
    {
        foreach (HlslCBufferVariable existing in resource.Variables)
        {
            if (existing.Name == incoming.Name && existing.TypeName == incoming.TypeName &&
                existing.Offset == incoming.Offset && existing.Size == incoming.Size && existing.ArraySize == incoming.ArraySize)
            {
                return;
            }
            if (existing.Name == incoming.Name ||
                ((ulong)existing.Offset < (ulong)incoming.Offset + incoming.Size &&
                 (ulong)incoming.Offset < (ulong)existing.Offset + existing.Size))
            {
                throw new InvalidDataException($"Conflicting member layouts for {resource.Name}: {existing.Name} and {incoming.Name}.");
            }
        }
        resource.Variables.Add(incoming);
    }
}
