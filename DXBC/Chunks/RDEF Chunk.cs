namespace Parser.DXBC.Chunks;

public class RdefVariable
{
    public string Name = "";
    public uint Offset;
    public uint Size;
    public uint Flags;
    public uint TypeClass;
    public uint TypeKind;
    public uint TypeRows;
    public uint TypeColumns;
    public uint TypeElements;

    public override string ToString() => $"{Name} off={Offset} size={Size}";
}

public class RdefConstantBuffer
{
    public string Name = "";
    public uint Size;
    public uint Flags;
    public uint Type;
    public List<RdefVariable> Variables { get; } = new();

    public override string ToString() => $"cb {Name} size={Size} vars={Variables.Count}";
}

public class RdefResourceBinding
{
    public string Name = "";
    public uint Type;          // D3D_SHADER_INPUT_TYPE
    public uint ReturnType;    // D3D_RESOURCE_RETURN_TYPE
    public uint Dimension;     // D3D_SRV_DIMENSION
    public uint SampleCount;
    public uint BindPoint;
    public uint BindCount;
    public uint Flags;

    public override string ToString() => $"{Name} t={Type} reg={BindPoint} count={BindCount}";
}

public class RdefChunk
{
    public List<RdefConstantBuffer> ConstantBuffers { get; } = new();
    public List<RdefResourceBinding> ResourceBindings { get; } = new();
    public uint TargetVersion;
    public string TargetString = "";
    public List<string> Warnings { get; } = new();

    public void Read(BinaryReader reader)
    {
        long start = reader.BaseStream.Position;

        uint cbCount = reader.ReadUInt32();
        uint cbOffset = reader.ReadUInt32();
        uint resCount = reader.ReadUInt32();
        uint resOffset = reader.ReadUInt32();

        byte minorVer = reader.ReadByte();
        byte majorVer = reader.ReadByte();
        ushort programType = reader.ReadUInt16();
        TargetVersion = (uint)((majorVer << 8) | minorVer) | ((uint)programType << 16);

        uint flags = reader.ReadUInt32();
        uint targetStringOffset = reader.ReadUInt32();

        if (targetStringOffset < reader.BaseStream.Length)
        {
            long ret = reader.BaseStream.Position;
            reader.BaseStream.Position = start + targetStringOffset;
            TargetString = reader.ReadNullTerminatedString();
            reader.BaseStream.Position = ret;
        }

        // Resource bindings
        reader.BaseStream.Position = start + resOffset;
        var rawBindings = new List<(uint nameOff, uint type, uint ret, uint dim, uint sampleCount, uint bind, uint count, uint flags)>();
        for (int i = 0; i < resCount; i++)
        {
            uint nameOff = reader.ReadUInt32();
            uint type = reader.ReadUInt32();
            uint retType = reader.ReadUInt32();
            uint dim = reader.ReadUInt32();
            uint sampleCount = reader.ReadUInt32();
            uint bindPoint = reader.ReadUInt32();
            uint bindCount = reader.ReadUInt32();
            uint bindFlags = reader.ReadUInt32();
            rawBindings.Add((nameOff, type, retType, dim, sampleCount, bindPoint, bindCount, bindFlags));
        }

        foreach (var rb in rawBindings)
        {
            string name = ReadStringAt(reader, start, rb.nameOff);
            ResourceBindings.Add(new RdefResourceBinding
            {
                Name = name,
                Type = rb.type,
                ReturnType = rb.ret,
                Dimension = rb.dim,
                SampleCount = rb.sampleCount,
                BindPoint = rb.bind,
                BindCount = rb.count,
                Flags = rb.flags
            });
        }

        // Constant buffers
        reader.BaseStream.Position = start + cbOffset;
        var rawCbs = new List<(uint nameOff, uint varCount, uint varOffset, uint size, uint flags, uint type)>();
        for (int i = 0; i < cbCount; i++)
        {
            uint nameOff = reader.ReadUInt32();
            uint varCount = reader.ReadUInt32();
            uint varOffset = reader.ReadUInt32();
            uint size = reader.ReadUInt32();
            uint cbFlags = reader.ReadUInt32();
            uint cbType = reader.ReadUInt32();
            rawCbs.Add((nameOff, varCount, varOffset, size, cbFlags, cbType));
        }

        foreach (var rc in rawCbs)
        {
            var cb = new RdefConstantBuffer
            {
                Name = ReadStringAt(reader, start, rc.nameOff),
                Size = rc.size,
                Flags = rc.flags,
                Type = rc.type
            };

            long varTableStart = start + rc.varOffset;
            for (int v = 0; v < rc.varCount; v++)
            {
                reader.BaseStream.Position = varTableStart + v * 24; // D3D11_SHADER_VARIABLE_DESC packed: name,offset,size,flags,typeOffset,defaultValue,(sm5: +4 more)
                uint varNameOff = reader.ReadUInt32();
                uint varOffset = reader.ReadUInt32();
                uint varSize = reader.ReadUInt32();
                uint varFlags = reader.ReadUInt32();
                uint typeOffset = reader.ReadUInt32();
                uint defaultValueOffset = reader.ReadUInt32();

                var variable = new RdefVariable
                {
                    Name = ReadStringAt(reader, start, varNameOff),
                    Offset = varOffset,
                    Size = varSize,
                    Flags = varFlags
                };

                if (typeOffset != 0 && typeOffset < reader.BaseStream.Length)
                {
                    long ret = reader.BaseStream.Position;
                    reader.BaseStream.Position = start + typeOffset;
                    variable.TypeClass = reader.ReadUInt16();
                    variable.TypeKind = reader.ReadUInt16();
                    variable.TypeRows = reader.ReadUInt16();
                    variable.TypeColumns = reader.ReadUInt16();
                    variable.TypeElements = reader.ReadUInt16();
                    reader.BaseStream.Position = ret;
                }

                cb.Variables.Add(variable);
            }

            ConstantBuffers.Add(cb);
        }
    }

    private string ReadStringAt(BinaryReader reader, long start, uint offset)
    {
        if (offset >= reader.BaseStream.Length)
        {
            Warnings.Add($"Invalid string offset: {offset}");
            return "";
        }

        long ret = reader.BaseStream.Position;
        reader.BaseStream.Position = start + offset;
        string s = reader.ReadNullTerminatedString();
        reader.BaseStream.Position = ret;
        return s;
    }
}