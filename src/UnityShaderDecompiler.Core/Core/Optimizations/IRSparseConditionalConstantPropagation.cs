using Parser.DXBC.IR;
using Parser.Core.Analysis;

namespace Parser.Core.Optimizations;

// Phase 9.10: the classic two-worklist SCCP (Wegman & Zadeck). Unlike
// plain Constant Propagation, this tracks which *edges* are provably
// executable, so a PHI only merges values coming from branches that can
// actually be taken — proving more values constant than propagation
// alone when a branch condition is itself provably constant.
//
// Scope note: this proves values constant and substitutes them, same as
// IRConstantPropagation, but does NOT delete now-unreachable blocks or
// edges — that's CFG surgery, a separate concern from constant
// propagation, left for a future dead-block-elimination pass. Symbolic
// evaluation only understands Binary/Unary/Constant/Register nodes;
// anything else (intrinsics, fma, texture ops, ...) is treated as
// Bottom (not provably constant) once all of its operands have
// resolved, same conservative-but-sound stance IRValueNumbering takes.
public static class IRSparseConditionalConstantPropagation
{
    private enum Kind { Top, Constant, Bottom }

    private readonly struct Lattice
    {
        public Kind Kind { get; }
        public IRExpression.ConstantExpression? Value { get; }

        private Lattice(Kind kind, IRExpression.ConstantExpression? value)
        {
            Kind = kind;
            Value = value;
        }

        public static readonly Lattice Top = new(Kind.Top, null);
        public static readonly Lattice Bottom = new(Kind.Bottom, null);
        public static Lattice Const(IRExpression.ConstantExpression c) => new(Kind.Constant, c);

        public bool SameAs(Lattice other) =>
            Kind == other.Kind && (Kind != Kind.Constant || Value!.ToString() == other.Value!.ToString());
    }

    public static bool Run(List<IRBlock> blocks)
    {
        if (blocks.Count == 0)
            return false;

        var executableBlocks = new HashSet<IRBlock>();
        var executableEdges = new HashSet<(IRBlock From, IRBlock To)>();
        var lattice = new Dictionary<(IRStorageLocation Loc, int Version), Lattice>();
        var readers = new Dictionary<(IRStorageLocation Loc, int Version), List<(IRBlock Block, IRStatement Stmt)>>();

        foreach (IRBlock b in blocks)
        {
            foreach (IRStatement s in b.Statements)
            {
                foreach (IRRegister reg in s.Uses)
                {
                    foreach (IRStorageLocation loc in IRStorageLocation.ReadLocationsOf(reg))
                    {
                        int? v = reg.SsaVersion[IRStorageLocation.ComponentToIndex(loc.Component)];
                        if (v is null) continue;

                        var key = (loc, v.Value);
                        if (!readers.TryGetValue(key, out List<(IRBlock, IRStatement)>? list))
                            readers[key] = list = new List<(IRBlock, IRStatement)>();

                        list.Add((b, s));
                    }
                }
            }
        }

        Lattice Get(IRStorageLocation loc, int version) =>
            lattice.TryGetValue((loc, version), out Lattice v) ? v : Lattice.Top;

        var blockWorklist = new Queue<IRBlock>();
        var ssaWorklist = new Queue<(IRStorageLocation, int)>();

        void SetLattice(IRStorageLocation loc, int version, Lattice v)
        {
            var key = (loc, version);
            if (!lattice.TryGetValue(key, out Lattice existing) || !existing.SameAs(v))
            {
                lattice[key] = v;
                ssaWorklist.Enqueue(key);
            }
        }

        void MarkEdgeExecutable(IRBlock from, IRBlock to)
        {
            if (!executableEdges.Add((from, to)))
                return;

            executableBlocks.Add(to);
            blockWorklist.Enqueue(to);
        }

        Lattice EvalRegister(IRRegister reg)
        {
            List<IRStorageLocation> locs = IRStorageLocation.ReadLocationsOf(reg).ToList();
            if (locs.Count == 0)
                return Lattice.Bottom;

            var pieces = new List<IRExpression.ConstantExpression>();

            foreach (IRStorageLocation loc in locs)
            {
                int? v = reg.SsaVersion[IRStorageLocation.ComponentToIndex(loc.Component)];
                Lattice lv = v is null ? Lattice.Bottom : Get(loc, v.Value);

                if (lv.Kind == Kind.Bottom) return Lattice.Bottom;
                if (lv.Kind == Kind.Top) return Lattice.Top; // wait for it to resolve

                pieces.Add(lv.Value!);
            }

            if (pieces.Count == 1)
                return Lattice.Const(pieces[0]);

            var merged = new uint[pieces.Count];
            for (int i = 0; i < pieces.Count; i++)
                merged[i] = pieces[i].RawValues.Length > 0 ? pieces[i].RawValues[0] : 0;

            return Lattice.Const(new IRExpression.ConstantExpression { Kind = pieces[0].Kind, RawValues = merged });
        }

        Lattice Eval(IRExpression expr)
        {
            switch (expr)
            {
                case IRExpression.ConstantExpression c:
                    return Lattice.Const(c);

                case IRExpression.RegisterExpression re:
                    return EvalRegister(re.Register);

                case IRExpression.BinaryExpression be:
                {
                    Lattice l = Eval(be.Left), r = Eval(be.Right);
                    if (l.Kind == Kind.Bottom || r.Kind == Kind.Bottom) return Lattice.Bottom;
                    if (l.Kind == Kind.Top || r.Kind == Kind.Top) return Lattice.Top;
                    return IRConstantMath.TryFoldBinary(be.Operation, l.Value!, r.Value!, out var f)
                        ? Lattice.Const(f!) : Lattice.Bottom;
                }

                case IRExpression.UnaryExpression ue:
                {
                    Lattice v = Eval(ue.Operand);
                    if (v.Kind == Kind.Bottom) return Lattice.Bottom;
                    if (v.Kind == Kind.Top) return Lattice.Top;
                    return IRConstantMath.TryFoldUnary(ue.Operation, v.Value!, out var f)
                        ? Lattice.Const(f!) : Lattice.Bottom;
                }

                default:
                {
                    // Can't symbolically evaluate this node shape. Stay Top
                    // while any operand is still unresolved (don't lock in
                    // Bottom prematurely); once everything's resolved and
                    // we still can't fold it, give up as Bottom.
                    bool anyBottom = false, anyTop = false;

                    foreach (IRRegister reg in expr.CollectRegisterUses())
                    {
                        foreach (IRStorageLocation loc in IRStorageLocation.ReadLocationsOf(reg))
                        {
                            int? v = reg.SsaVersion[IRStorageLocation.ComponentToIndex(loc.Component)];
                            Lattice lv = v is null ? Lattice.Bottom : Get(loc, v.Value);
                            if (lv.Kind == Kind.Bottom) anyBottom = true;
                            else if (lv.Kind == Kind.Top) anyTop = true;
                        }
                    }

                    if (anyBottom) return Lattice.Bottom;
                    if (anyTop) return Lattice.Top;
                    return Lattice.Bottom;
                }
            }
        }

        void UpdateDef(IRRegister destReg, Lattice v)
        {
            foreach (IRStorageLocation loc in IRStorageLocation.WriteLocationsOf(destReg))
            {
                int? ver = destReg.SsaVersion[IRStorageLocation.ComponentToIndex(loc.Component)];
                if (ver is null) continue;
                SetLattice(loc, ver.Value, v);
            }
        }

        void VisitStatement(IRBlock block, IRStatement stmt)
        {
            if (stmt is IRStatement.IRPhi phi)
            {
                Lattice merged = Lattice.Top;

                for (int p = 0; p < phi.Operands.Count && p < block.Predecessors.Count; p++)
                {
                    if (!executableEdges.Contains((block.Predecessors[p], block)))
                        continue; // ignore unreachable incoming edges entirely

                    Lattice val = EvalRegister(phi.Operands[p]);

                    merged = merged.Kind == Kind.Top ? val
                        : val.Kind == Kind.Top ? merged
                        : merged.SameAs(val) ? merged
                        : Lattice.Bottom;
                }

                UpdateDef(phi.Destination, merged);
                return;
            }

            if (stmt is IRStatement.IRAssignment a)
            {
                UpdateDef(a.Destination, Eval(a.Expression));
                return;
            }

            // Anything else this pass doesn't symbolically model
            // (multi-assign, atomics, ...): its results are Bottom.
            foreach (IRRegister reg in stmt.Defines)
                UpdateDef(reg, Lattice.Bottom);
        }

        void VisitBlock(IRBlock block)
        {
            foreach (IRStatement s in block.Statements)
                VisitStatement(block, s);

            if (block.Statements[^1] is IRStatement.IRIf ifStmt && block.Successors.Count == 2)
            {
                Lattice cond = Eval(ifStmt.Condition);

                if (cond.Kind == Kind.Bottom)
                {
                    MarkEdgeExecutable(block, block.Successors[0]);
                    MarkEdgeExecutable(block, block.Successors[1]);
                }
                else if (cond.Kind == Kind.Constant)
                {
                    bool truthy = cond.Value!.RawValues.Length > 0 && cond.Value.RawValues[0] != 0;
                    MarkEdgeExecutable(block, block.Successors[truthy ? 0 : 1]);
                }
                // Top: condition not resolved yet — revisit later once it is.
            }
            else
            {
                foreach (IRBlock succ in block.Successors)
                    MarkEdgeExecutable(block, succ);
            }
        }

        executableBlocks.Add(blocks[0]);
        blockWorklist.Enqueue(blocks[0]);

        while (blockWorklist.Count > 0 || ssaWorklist.Count > 0)
        {
            while (blockWorklist.Count > 0)
                VisitBlock(blockWorklist.Dequeue());

            while (ssaWorklist.Count > 0)
            {
                (IRStorageLocation Loc, int Version) key = ssaWorklist.Dequeue();
                if (!readers.TryGetValue(key, out List<(IRBlock, IRStatement)>? list))
                    continue;

                foreach ((IRBlock b, IRStatement s) in list)
                    if (executableBlocks.Contains(b))
                        VisitStatement(b, s);
            }
        }

        // --- substitute every proven-constant read, same shape as
        // IRConstantPropagation but seeded from this pass's richer lattice.
        bool changed = false;

        IRExpression Substitute(IRExpression expr)
        {
            if (expr is not IRExpression.RegisterExpression re)
                return expr;

            var pieces = new List<IRExpression.ConstantExpression>();

            foreach (IRStorageLocation loc in IRStorageLocation.ReadLocationsOf(re.Register))
            {
                int? v = re.Register.SsaVersion[IRStorageLocation.ComponentToIndex(loc.Component)];
                if (v is null || Get(loc, v.Value).Kind != Kind.Constant)
                    return expr;

                pieces.Add(Get(loc, v.Value).Value!);
            }

            if (pieces.Count == 0) return expr;
            if (pieces.Count == 1) return pieces[0];

            var merged = new uint[pieces.Count];
            for (int i = 0; i < pieces.Count; i++)
                merged[i] = pieces[i].RawValues.Length > 0 ? pieces[i].RawValues[0] : 0;

            return new IRExpression.ConstantExpression { Kind = pieces[0].Kind, RawValues = merged };
        }

        foreach (IRBlock block in blocks)
        {
            for (int i = 0; i < block.Statements.Count; i++)
            {
                IRStatement original = block.Statements[i];
                if (original is IRStatement.IRPhi) continue;

                IRStatement rewritten = IRStatementRewriter.RewriteExpressions(original, Substitute);
                if (rewritten.ToString() != original.ToString())
                {
                    block.Statements[i] = rewritten;
                    changed = true;
                }
            }
        }

        return changed;
    }
}
