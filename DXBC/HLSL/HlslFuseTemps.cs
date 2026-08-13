using Parser.DXBC.IR;
using Parser.DXBC.IR.Analysis;
using Parser.DXBC.IR.Optimizations;
using RegisterExpression = Parser.DXBC.IR.IRExpression.RegisterExpression;
using ConstantExpression = Parser.DXBC.IR.IRExpression.ConstantExpression;
using BinaryExpression = Parser.DXBC.IR.IRExpression.BinaryExpression;
using UnaryExpression = Parser.DXBC.IR.IRExpression.UnaryExpression;
using IntrinsicExpression = Parser.DXBC.IR.IRExpression.IntrinsicExpression;
using FusedMultiplyAddExpression = Parser.DXBC.IR.IRExpression.FusedMultiplyAddExpression;
using MultiplyHighExpression = Parser.DXBC.IR.IRExpression.MultiplyHighExpression;
using Multiply64Expression = Parser.DXBC.IR.IRExpression.Multiply64Expression;
using BitFieldInsertExpression = Parser.DXBC.IR.IRExpression.BitFieldInsertExpression;
using BitFieldExtractExpression = Parser.DXBC.IR.IRExpression.BitFieldExtractExpression;
using ConditionalExpression = Parser.DXBC.IR.IRExpression.ConditionalExpression;
using DotProductExpression = Parser.DXBC.IR.IRExpression.DotProductExpression;
using SwizzleExpression = Parser.DXBC.IR.IRExpression.SwizzleExpression;
using MatrixVectorMultiplyExpression = Parser.DXBC.IR.IRExpression.MatrixVectorMultiplyExpression;
using TextureOperationExpression = Parser.DXBC.IR.IRExpression.TextureOperationExpression;

namespace Parser.DXBC.Hlsl.Ast;

// Stage 13.5 — single-use temp fusion (opt-out via --no-fuse-temps).
//
// DXC's -O3 already eliminated dead code, but SSA form forces every
// intermediate value into its own register, so a decompiler sees hundreds
// of one-instruction declarations even in a tight shader. A temp that is
// read EXACTLY ONCE — by a pure expression, with the def dominating the
// use — can have its defining expression substituted into that one
// consumer and the definition dropped. This is the only rewriting that is
// guaranteed bit-exact: SSA versions are immutable (the value cannot
// change between def and use) and the def executes before the use, so the
// inlined computation recomputes exactly the bits the register held.
//
// The pass is deliberately conservative:
//   - def and use must sit in the same block, use strictly after def;
//   - the def must be a plain single-instruction temp assignment with a
//     contiguous write mask ([0..N-1], which is also what lets the
//     inlined SwizzleExpression map source components to the value's own
//     lanes positionally) and one SSA version across all lanes;
//   - the expression must be pure (no texture ops — keeps derivatives and
//     sampling context away) and must not contain unversioned temp reads
//     (those are don't-care registers that only the phi-fallback copies
//     know how to declare, and they'd lose that handling when inlined);
//   - the def must have exactly one reader, which must consume every lane
//     the def writes;
//   - a node-count cap keeps long chains from collapsing into one
//     unreadable mega-expression.
public static class HlslFuseTemps
{
    public static void Apply(HlslBlockStatement root, int maxNodes)
    {
        // Each successful pass removes at least one statement, so this
        // terminates by construction; the cap keeps chained inlining from
        // running away, and 200 passes is far more than any real function
        // needs.
        for (int i = 0; i < 200; i++)
        {
            if (!FuseOnce(root, maxNodes))
                return;
        }
    }

    private static bool FuseOnce(HlslBlockStatement root, int maxNodes)
    {
        var uses = new Dictionary<(IRStorageLocation, int), UseInfo>();
        var defCounts = new Dictionary<(IRStorageLocation, int), int>();
        WalkBlock(root, uses, defCounts);

        foreach (HlslBlockStatement block in AllBlocks(root))
        {
            for (int i = 0; i < block.Statements.Count; i++)
            {
                if (block.Statements[i] is not HlslAssignmentStatement def)
                    continue;
                if (TryFuse(block, i, def, uses, defCounts, maxNodes))
                    return true;
            }
        }

        return false;
    }

    // ---------- def/use collection ----------

    private sealed class UseInfo
    {
        // Distinct reader RegisterExpression nodes (object identity).
        public HashSet<RegisterExpression> Readers { get; } = new();

        // True when some read of this value is not directly rewritable
        // (a read through relative indexing, or inside an unhandled raw
        // statement) — the value must then never be inlined away.
        public bool Raw;

        // The statement that reads this value, and where it sits.
        public HlslStatementNode? Statement;
        public HlslBlockStatement? Block;
        public int StatementIndex = -1;
    }

    private static void WalkBlock(HlslBlockStatement block, Dictionary<(IRStorageLocation, int), UseInfo> uses, Dictionary<(IRStorageLocation, int), int> defCounts)
    {
        for (int i = 0; i < block.Statements.Count; i++)
            WalkStatement(block, i, uses, defCounts, block.Statements[i]);
    }

    private static void WalkStatement(HlslBlockStatement block, int index, Dictionary<(IRStorageLocation, int), UseInfo> uses, Dictionary<(IRStorageLocation, int), int> defCounts, HlslStatementNode stmt)
    {
        switch (stmt)
        {
            case HlslAssignmentStatement a:
                RecordDef(a.Destination, defCounts);
                WalkExpr(a.Expression, stmt, block, index, uses);
                break;

            case HlslMultiAssignmentStatement ma:
                foreach (IRRegister dest in ma.Destinations)
                    RecordDef(dest, defCounts);
                foreach (IRExpression e in ma.Expressions)
                    WalkExpr(e, stmt, block, index, uses);
                break;

            case HlslIfStatement iff:
                WalkExpr(iff.Condition, stmt, block, index, uses);
                WalkBlock(iff.Then, uses, defCounts);
                if (iff.Else is not null)
                    WalkBlock(iff.Else, uses, defCounts);
                break;

            case HlslLoopStatement loop:
                WalkBlock(loop.Body, uses, defCounts);
                break;

            case HlslSwitchStatement sw:
                WalkExpr(sw.Selector, stmt, block, index, uses);
                foreach (HlslSwitchCase c in sw.Cases)
                {
                    if (c.Value is not null)
                        WalkExpr(c.Value, stmt, block, index, uses);
                    WalkBlock(c.Body, uses, defCounts);
                }
                break;

            case HlslBreakStatement b:
                if (b.Condition is not null) WalkExpr(b.Condition, stmt, block, index, uses);
                break;

            case HlslContinueStatement c:
                if (c.Condition is not null) WalkExpr(c.Condition, stmt, block, index, uses);
                break;

            case HlslReturnStatement r:
                if (r.Condition is not null) WalkExpr(r.Condition, stmt, block, index, uses);
                break;

            case HlslDiscardStatement d:
                WalkExpr(d.Condition, stmt, block, index, uses);
                break;

            case HlslMemoryStoreStatement ms:
                WalkExpr(ms.Address, stmt, block, index, uses);
                WalkExpr(ms.Value, stmt, block, index, uses);
                break;

            case HlslRawStatement raw:
                foreach (IRRegister r in raw.Source.Uses)
                    RecordUse(r, node: null, raw: true, stmt, block, index, uses);
                break;
        }
    }

    private static void RecordDef(IRRegister dest, Dictionary<(IRStorageLocation, int), int> defCounts)
    {
        if (dest.RegisterType is not (RegisterType.Temp or RegisterType.IndexableTemp))
            return;

        foreach (IRStorageLocation loc in WriteLocationsOf(dest))
        {
            int? v = dest.SsaVersion[IRStorageLocation.ComponentToIndex(loc.Component)];
            if (v is null)
                continue;
            defCounts[(loc, v.Value)] = defCounts.TryGetValue((loc, v.Value), out int c) ? c + 1 : 1;
        }
    }

    private static void WalkExpr(IRExpression expr, HlslStatementNode stmt, HlslBlockStatement block, int index, Dictionary<(IRStorageLocation, int), UseInfo> uses)
    {
        Walk(expr, node =>
        {
            if (node is not RegisterExpression re)
                return;

            RecordUse(re.Register, re, raw: false, stmt, block, index, uses);

            // Registers referenced only through dynamic indexing (e.g. the
            // r0 in cb0[r0.x]) are read but cannot be inlined — their
            // RegisterExpression lives in RelativeIndices, which the
            // expression rewriter does not touch. Mark them Raw so a def
            // consumed this way is never removed.
            foreach (IRRegister r in re.Register.IndexRegisterUses())
                RecordUse(r, node: null, raw: true, stmt, block, index, uses);
        });
    }

    private static void RecordUse(IRRegister reg, RegisterExpression? node, bool raw, HlslStatementNode stmt, HlslBlockStatement block, int index, Dictionary<(IRStorageLocation, int), UseInfo> uses)
    {
        if (reg.RegisterType is not (RegisterType.Temp or RegisterType.IndexableTemp))
            return; // inputs/cbuffer/resource reads are never values a def could own

        foreach (IRStorageLocation loc in ReadLocationsOf(reg))
        {
            int? v = reg.SsaVersion[IRStorageLocation.ComponentToIndex(loc.Component)];
            if (v is null)
                continue; // versionless (never-written-on-this-path) temp — no def to key

            if (!uses.TryGetValue((loc, v.Value), out UseInfo? info))
                uses[(loc, v.Value)] = info = new UseInfo();

            if (raw)
                info.Raw = true;
            else if (node is not null)
                info.Readers.Add(node);

            info.Statement = stmt;
            info.Block = block;
            info.StatementIndex = index;
        }
    }

    // ---------- candidate checks ----------

    private static bool IsInlineableDef(HlslAssignmentStatement def)
    {
        IRRegister dest = def.Destination;

        if (dest.RegisterType != RegisterType.Temp)
            return false;
        // A register that already carries a real semantic name (from
        // HlslSemanticNaming, which runs before this pass) should keep its
        // own declared line — inlining it splices the name's whole
        // expression into whatever consumes it and the name never reaches
        // the printed output, even though it was computed correctly.
        if (dest.SymbolicName is not null)
            return false;
        // Plain rN: Indices[] holds the constant register number (every
        // operand token carries one), which is fine — what disqualifies a
        // def from being inlined is a *dynamic* index (r0[r1.x] style),
        // i.e. an actual RelativeIndices slot.
        if (dest.RelativeIndices[0] is not null || dest.Indices.Count > 1)
            return false; // dynamically-indexed temp — can't inline the value

        List<int> active = MaskIndices(dest.Mask);
        if (active.Count == 0)
            return false;

        int? v0 = dest.SsaVersion[active[0]];
        if (v0 is null)
            return false;
        if (!active.All(c => dest.SsaVersion[c] == v0))
            return false; // per-component divergent versions — the def splits lines

        for (int i = 0; i < active.Count; i++)
            if (active[i] != i)
                return false; // non-contiguous mask — lane mapping is not positional

        if (HasTextureOp(def.Expression))
            return false;
        if (HasUnversionedTempRead(def.Expression))
            return false;

        return true;
    }

    private static bool HasTextureOp(IRExpression expr)
    {
        bool found = false;
        Walk(expr, n => { if (n is TextureOperationExpression) found = true; });
        return found;
    }

    private static bool HasUnversionedTempRead(IRExpression expr)
    {
        bool found = false;
        Walk(expr, n =>
        {
            if (found || n is not RegisterExpression re)
                return;
            if (re.Register.RegisterType is not (RegisterType.Temp or RegisterType.IndexableTemp))
                return;
            foreach (IRStorageLocation loc in ReadLocationsOf(re.Register))
                if (re.Register.SsaVersion[IRStorageLocation.ComponentToIndex(loc.Component)] is null)
                {
                    found = true;
                    return;
                }
        });
        return found;
    }

    // ---------- the rewrite ----------

    private static bool TryFuse(HlslBlockStatement block, int defIndex, HlslAssignmentStatement def, Dictionary<(IRStorageLocation, int), UseInfo> uses, Dictionary<(IRStorageLocation, int), int> defCounts, int maxNodes)
    {
        if (!IsInlineableDef(def))
            return false;

        var defLocs = WriteLocationsOf(def.Destination).ToList();
        int version = def.Destination.SsaVersion[IRStorageLocation.ComponentToIndex(defLocs[0].Component)]!.Value;

        // This version must be defined exactly once in the whole function.
        // Leaving SSA turns each phi into one copy per predecessor, all
        // writing the same version; a def whose version is also written
        // elsewhere (e.g. a hoisted fallback copy plus a reassignment on a
        // branch) is not the value the reader actually sees on every path.
        foreach (IRStorageLocation loc in defLocs)
            if (defCounts.TryGetValue((loc, version), out int n) && n != 1)
                return false;

        // Every lane the def writes must be read exactly once, by one
        // rewritable RegisterExpression, in the same block after the def.
        RegisterExpression? user = null;
        UseInfo? info = null;
        foreach (IRStorageLocation loc in defLocs)
        {
            if (!uses.TryGetValue((loc, version), out UseInfo? u))
                return false;
            if (u.Raw || u.Readers.Count != 1)
                return false;
            if (u.Block != block || u.StatementIndex <= defIndex)
                return false;

            RegisterExpression sole = u.Readers.First();
            if (user is null)
                user = sole;
            else if (user != sole)
                return false;

            if (info is null)
                info = u;
            else if (info.Block != u.Block || info.StatementIndex != u.StatementIndex)
                return false;
        }

        if (user is null || info is null)
            return false;

        var defActive = defLocs.Select(l => (int)IRStorageLocation.ComponentToIndex(l.Component)).ToList();
        var readActive = ReadLocationsOf(user.Register).Select(l => (int)IRStorageLocation.ComponentToIndex(l.Component)).ToList();

        // The reader must consume every lane the def writes (and nothing
        // else — extra lanes would belong to a different value's def).
        var readSet = readActive.Distinct().OrderBy(c => c).ToList();
        var defSet = defActive.Distinct().OrderBy(c => c).ToList();
        if (!readSet.SequenceEqual(defSet))
            return false;

        bool identity = readActive.SequenceEqual(defActive);
        IRExpression replacement = identity
            ? def.Expression
            : new SwizzleExpression { Value = def.Expression, Components = readActive };

        int consumerSize = StatementExprSize(info.Statement!);
        int newSize = consumerSize - 1 + Size(def.Expression) + (identity ? 0 : 1);
        if (newSize > maxNodes)
            return false;

        var rebuilt = RewriteStatement(info.Statement!, user, replacement);
        block.Statements[info.StatementIndex] = rebuilt;
        block.Statements.RemoveAt(defIndex);

        return true;
    }

    // Rebuilds a statement with the target RegisterExpression replaced by
    // `replacement`. Only the statement's direct expression fields are
    // touched — the rule that def and use share a block guarantees the
    // target is never inside a nested block.
    private static HlslStatementNode RewriteStatement(HlslStatementNode stmt, RegisterExpression target, IRExpression replacement)
    {
        IRExpression? Rewrite(IRExpression? e) =>
            IRExpressionRewriter.Rewrite(e, node => ReferenceEquals(node, target) ? replacement : node);

        return stmt switch
        {
            HlslAssignmentStatement a => new HlslAssignmentStatement
            {
                Destination = a.Destination,
                Expression = Rewrite(a.Expression)!,
            },

            HlslMultiAssignmentStatement ma =>
                RebuildMulti(ma, target, replacement),

            HlslIfStatement iff => new HlslIfStatement
            {
                Condition = Rewrite(iff.Condition)!,
                Then = iff.Then,
                Else = iff.Else,
            },

            HlslSwitchStatement sw =>
                RebuildSwitch(sw, target, replacement),

            HlslBreakStatement b => new HlslBreakStatement
            {
                Condition = b.Condition is null ? null : Rewrite(b.Condition),
            },

            HlslContinueStatement c => new HlslContinueStatement
            {
                Condition = c.Condition is null ? null : Rewrite(c.Condition),
            },

            HlslReturnStatement r => new HlslReturnStatement
            {
                Condition = r.Condition is null ? null : Rewrite(r.Condition),
            },

            HlslDiscardStatement d => new HlslDiscardStatement
            {
                Condition = Rewrite(d.Condition)!,
            },

            HlslMemoryStoreStatement ms => new HlslMemoryStoreStatement
            {
                Resource = ms.Resource,
                Address = Rewrite(ms.Address)!,
                Value = Rewrite(ms.Value)!,
            },

            _ => stmt,
        };
    }

    private static HlslStatementNode RebuildMulti(HlslMultiAssignmentStatement ma, RegisterExpression target, IRExpression replacement)
    {
        var rebuilt = new HlslMultiAssignmentStatement();
        rebuilt.Destinations.AddRange(ma.Destinations);
        foreach (IRExpression e in ma.Expressions)
            rebuilt.Expressions.Add(IRExpressionRewriter.Rewrite(e, node => ReferenceEquals(node, target) ? replacement : node)!);
        return rebuilt;
    }

    private static HlslStatementNode RebuildSwitch(HlslSwitchStatement sw, RegisterExpression target, IRExpression replacement)
    {
        IRExpression? Rewrite(IRExpression? e) =>
            IRExpressionRewriter.Rewrite(e, node => ReferenceEquals(node, target) ? replacement : node);

        var rebuilt = new HlslSwitchStatement { Selector = Rewrite(sw.Selector)! };
        foreach (HlslSwitchCase c in sw.Cases)
        {
            var nc = new HlslSwitchCase
            {
                Value = c.Value is null ? null : Rewrite(c.Value),
                Body = c.Body,
            };
            rebuilt.Cases.Add(nc);
        }
        return rebuilt;
    }

    // ---------- size helpers ----------

    private static int StatementExprSize(HlslStatementNode stmt) => stmt switch
    {
        HlslAssignmentStatement a => Size(a.Expression),
        HlslMultiAssignmentStatement ma => ma.Expressions.Sum(Size),
        HlslIfStatement iff => Size(iff.Condition),
        HlslSwitchStatement sw => Size(sw.Selector) + sw.Cases.Sum(c => c.Value is null ? 0 : Size(c.Value)),
        HlslBreakStatement b => b.Condition is null ? 0 : Size(b.Condition),
        HlslContinueStatement c => c.Condition is null ? 0 : Size(c.Condition),
        HlslReturnStatement r => r.Condition is null ? 0 : Size(r.Condition),
        HlslDiscardStatement d => Size(d.Condition),
        HlslMemoryStoreStatement ms => Size(ms.Address) + Size(ms.Value),
        _ => 0,
    };

    private static int Size(IRExpression? e) => e switch
    {
        null => 0,
        RegisterExpression or ConstantExpression => 1,
        BinaryExpression b => 1 + Size(b.Left) + Size(b.Right),
        UnaryExpression u => 1 + Size(u.Operand),
        IntrinsicExpression i => 1 + i.Arguments.Sum(Size),
        FusedMultiplyAddExpression f => 1 + Size(f.A) + Size(f.B) + Size(f.C),
        MultiplyHighExpression m => 1 + Size(m.Left) + Size(m.Right),
        Multiply64Expression m => 1 + Size(m.Left) + Size(m.Right),
        BitFieldInsertExpression b => 1 + Size(b.Width) + Size(b.Offset) + Size(b.Insert) + Size(b.Base),
        BitFieldExtractExpression b => 1 + Size(b.Width) + Size(b.Offset) + Size(b.Value),
        ConditionalExpression c => 1 + Size(c.Condition) + Size(c.TrueExpression) + Size(c.FalseExpression),
        DotProductExpression d => 1 + Size(d.Left) + Size(d.Right),
        SwizzleExpression s => 1 + Size(s.Value),
        MatrixVectorMultiplyExpression m => 1 + Size(m.Vector) + m.Rows.Count,
        _ => 1,
    };

    // ---------- generic expression walk ----------

    private static void Walk(IRExpression? e, Action<IRExpression> visit)
    {
        if (e is null)
            return;
        visit(e);

        switch (e)
        {
            case BinaryExpression b:
                Walk(b.Left, visit);
                Walk(b.Right, visit);
                break;
            case UnaryExpression u:
                Walk(u.Operand, visit);
                break;
            case IntrinsicExpression i:
                foreach (IRExpression a in i.Arguments)
                    Walk(a, visit);
                break;
            case FusedMultiplyAddExpression f:
                Walk(f.A, visit);
                Walk(f.B, visit);
                Walk(f.C, visit);
                break;
            case MultiplyHighExpression m:
                Walk(m.Left, visit);
                Walk(m.Right, visit);
                break;
            case Multiply64Expression m:
                Walk(m.Left, visit);
                Walk(m.Right, visit);
                break;
            case BitFieldInsertExpression b:
                Walk(b.Width, visit);
                Walk(b.Offset, visit);
                Walk(b.Insert, visit);
                Walk(b.Base, visit);
                break;
            case BitFieldExtractExpression b:
                Walk(b.Width, visit);
                Walk(b.Offset, visit);
                Walk(b.Value, visit);
                break;
            case ConditionalExpression c:
                Walk(c.Condition, visit);
                Walk(c.TrueExpression, visit);
                Walk(c.FalseExpression, visit);
                break;
            case DotProductExpression d:
                Walk(d.Left, visit);
                Walk(d.Right, visit);
                break;
            case SwizzleExpression s:
                Walk(s.Value, visit);
                break;
            case MatrixVectorMultiplyExpression m:
                Walk(m.Vector, visit);
                break;
            case TextureOperationExpression t:
                Walk(t.Coordinates, visit);
                Walk(t.Offset, visit);
                Walk(t.LOD, visit);
                Walk(t.Bias, visit);
                Walk(t.CompareValue, visit);
                Walk(t.GradX, visit);
                Walk(t.GradY, visit);
                Walk(t.SampleIndex, visit);
                break;
        }
    }

    // ---------- register helpers (mirrors of the printer's, operating on
    // IRStorageLocation which is the def/use identity) ----------

    private static IEnumerable<IRStorageLocation> ReadLocationsOf(IRRegister reg) =>
        IRStorageLocation.ReadLocationsOf(reg);

    private static IEnumerable<IRStorageLocation> WriteLocationsOf(IRRegister reg) =>
        IRStorageLocation.WriteLocationsOf(reg);

    private static List<int> MaskIndices(byte mask)
    {
        var result = new List<int>();
        if ((mask & 1) != 0) result.Add(0);
        if ((mask & 2) != 0) result.Add(1);
        if ((mask & 4) != 0) result.Add(2);
        if ((mask & 8) != 0) result.Add(3);
        return result;
    }

    private static IEnumerable<HlslBlockStatement> AllBlocks(HlslBlockStatement block)
    {
        yield return block;
        foreach (HlslStatementNode stmt in block.Statements)
        {
            switch (stmt)
            {
                case HlslIfStatement iff:
                    foreach (HlslBlockStatement b in AllBlocks(iff.Then)) yield return b;
                    if (iff.Else is not null)
                        foreach (HlslBlockStatement b in AllBlocks(iff.Else)) yield return b;
                    break;
                case HlslLoopStatement loop:
                    foreach (HlslBlockStatement b in AllBlocks(loop.Body)) yield return b;
                    break;
                case HlslSwitchStatement sw:
                    foreach (HlslSwitchCase c in sw.Cases)
                        foreach (HlslBlockStatement b in AllBlocks(c.Body)) yield return b;
                    break;
            }
        }
    }
}   