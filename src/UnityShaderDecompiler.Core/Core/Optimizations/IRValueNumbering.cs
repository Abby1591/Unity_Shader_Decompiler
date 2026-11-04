using Parser.DXBC.IR;
using Parser.Core.Analysis;

namespace Parser.Core.Optimizations;

// Phase 9.6 + 9.9: under SSA, "common subexpression elimination" and
// "value numbering" are the same technique — a table from expression
// shape to the SSA value that already computed it, scoped by dominance
// (so a value computed in a branch never leaks into a sibling branch
// that doesn't dominate). Walking the dominator tree in preorder with a
// scoped table, pushing on entry and popping on exit, is exactly the
// renaming pattern from Phase 7. Commutative operators (add, multiply,
// bitwise/logical and/or) are canonicalized before hashing so `a+b` and
// `b+a` are recognized as the same value — the "numbering" half of this.
public static class IRValueNumbering
{
    public static bool Run(List<IRBlock> blocks, IRDominatorInfo dom)
    {
        if (blocks.Count == 0)
            return false;

        Dictionary<IRBlock, List<IRBlock>> tree = dom.BuildTree();
        var table = new Dictionary<string, IRRegister>();
        bool changed = false;

        Visit(blocks[0], tree, table, ref changed);
        return changed;
    }

    private static void Visit(
        IRBlock block, Dictionary<IRBlock, List<IRBlock>> tree, Dictionary<string, IRRegister> table, ref bool changed)
    {
        var pushedKeys = new List<string>();

        for (int i = 0; i < block.Statements.Count; i++)
        {
            if (block.Statements[i] is not IRStatement.IRAssignment)
                continue;

            IRStatement rewritten = IRStatementRewriter.RewriteExpressions(block.Statements[i], e => Reuse(e, table));

            if (rewritten.ToString() != block.Statements[i].ToString())
            {
                block.Statements[i] = rewritten;
                changed = true;
            }

            var a = (IRStatement.IRAssignment)block.Statements[i];

            // Trivial expressions (bare reads/constants) aren't worth
            // caching — reusing them saves nothing over reading them
            // again, and it'd just bloat the table.
            if (a.Expression is IRExpression.RegisterExpression or IRExpression.ConstantExpression)
                continue;

            string key = CanonicalKey(a.Expression);
            if (table.TryAdd(key, a.Destination))
                pushedKeys.Add(key);
        }

        if (tree.TryGetValue(block, out List<IRBlock>? children))
            foreach (IRBlock child in children)
                Visit(child, tree, table, ref changed);

        foreach (string key in pushedKeys)
            table.Remove(key);
    }

    private static IRExpression Reuse(IRExpression expr, Dictionary<string, IRRegister> table)
    {
        if (expr is IRExpression.RegisterExpression or IRExpression.ConstantExpression)
            return expr;

        return table.TryGetValue(CanonicalKey(expr), out IRRegister? reg)
            ? new IRExpression.RegisterExpression { Register = reg }
            : expr;
    }

    private static string CanonicalKey(IRExpression expr)
    {
        if (expr is IRExpression.BinaryExpression be && IsCommutative(be.Operation))
        {
            string l = be.Left.ToString() ?? "";
            string r = be.Right.ToString() ?? "";

            return string.CompareOrdinal(l, r) <= 0
                ? $"{be.Operation}({l},{r})"
                : $"{be.Operation}({r},{l})";
        }

        return expr.ToString() ?? "";
    }

    private static bool IsCommutative(IRExpression.BinaryOperation op) => op is
        IRExpression.BinaryOperation.Add or
        IRExpression.BinaryOperation.Multiply or
        IRExpression.BinaryOperation.Equal or
        IRExpression.BinaryOperation.NotEqual or
        IRExpression.BinaryOperation.BitwiseAnd or
        IRExpression.BinaryOperation.BitwiseOr or
        IRExpression.BinaryOperation.BitwiseXor or
        IRExpression.BinaryOperation.LogicalAnd or
        IRExpression.BinaryOperation.LogicalOr;
}
