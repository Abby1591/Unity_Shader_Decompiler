using Parser.DXBC.Instructions;

namespace Parser.DXBC.IR.Optimizations;

// Post-SSA, pre-HLSL-generation pass (roadmap: "Matrix recognition").
// Expects to run after IRVectorPatternRecognition has already folded each
// individual mul/fma/fma/fma component chain into a DotProductExpression
// (one row · vector dot product per output component). What's left for
// this pass is purely structural: find N consecutive statements that
// write consecutive components (.x, .y, .z, ...) of the same destination
// register, each as row_i · vector for the same vector and consecutive
// constant-buffer rows, and fuse them into one MatrixVectorMultiplyExpression
// assigned to the whole destination register at once.
//
//   r0.x = dot(cb0[4], v)
//   r0.y = dot(cb0[5], v)
//   r0.z = dot(cb0[6], v)
//   r0.w = dot(cb0[7], v)
//
// becomes
//
//   r0.xyzw = mul(cb0[4..7], v)
public static class IRMatrixPatternRecognition
{
    public static bool Run(List<IRBlock> blocks)
    {
        bool changed = false;

        foreach (IRBlock block in blocks)
        {
            List<IRStatement> statements = block.Statements;
            int i = 0;

            while (i < statements.Count)
            {
                int matched = TryMatchRun(statements, i, out IRStatement.IRAssignment? fused);

                if (matched > 1 && fused is not null)
                {
                    statements.RemoveRange(i, matched);
                    statements.Insert(i, fused);
                    changed = true;
                    i++;
                }
                else
                {
                    i++;
                }
            }
        }

        return changed;
    }

    // Tries to match a run starting at `start` of consecutive single-
    // component assignments to the same base register (components in
    // order 0, 1, 2, ...), each RHS a DotProductExpression sharing the
    // same vector operand and consecutive rows on the other operand.
    // Returns the number of statements consumed (0 or 1 = no match).
    private static int TryMatchRun(List<IRStatement> statements, int start, out IRStatement.IRAssignment? fused)
    {
        fused = null;

        var rows = new List<IRRegister>();
        IRExpression? sharedVector = null;
        IRRegister? destBase = null;
        int count = 0;

        for (int i = start; i < statements.Count && count < 4; i++)
        {
            if (statements[i] is not IRStatement.IRAssignment
                {
                    Destination: { ComponentMode: Operand.OperandComponentMode.Select1 } dest,
                    Expression: IRExpression.DotProductExpression dot,
                } assign)
            {
                break;
            }

            if (dest.Component != count)
                break;

            (IRRegister? rowFromLeft, IRExpression? vectorFromRight) = AsRowVector(dot.Left, dot.Right);
            (IRRegister? rowFromRight, IRExpression? vectorFromLeft) = AsRowVector(dot.Right, dot.Left);

            IRRegister? row = rowFromLeft ?? rowFromRight;
            IRExpression? vector = rowFromLeft is not null ? vectorFromRight : vectorFromLeft;

            if (row is null || vector is null)
                break;

            if (destBase is null)
            {
                destBase = dest;
            }
            else if (!SameBaseRegister(destBase, dest))
            {
                break;
            }

            if (sharedVector is null)
            {
                sharedVector = vector;
            }
            else if (sharedVector.ToString() != vector.ToString())
            {
                break;
            }

            if (rows.Count > 0 && !IsNextRow(rows[^1], row))
                break;

            rows.Add(row);
            count++;

            _ = assign; // matched; keep scanning for the next component
        }

        if (count < 2 || destBase is null || sharedVector is null)
            return 0;

        byte destMask = count switch
        {
            2 => 0b0011,
            3 => 0b0111,
            _ => 0b1111,
        };

        var wholeDest = new IRRegister
        {
            RegisterType = destBase.RegisterType,
            Type = destBase.Type,
            Index = destBase.Index,
            Mask = destMask,
            ComponentMode = Operand.OperandComponentMode.Mask,
            Modifier = destBase.Modifier,
        };
        wholeDest.Indices.AddRange(destBase.Indices);

        fused = new IRStatement.IRAssignment
        {
            Destination = wholeDest,
            Expression = new IRExpression.MatrixVectorMultiplyExpression
            {
                Rows = rows,
                Vector = sharedVector,
            },
        };

        return count;
    }

    // A dot's operand is a "matrix row" when it's a whole-register read
    // (not a single-component select) coming from a constant buffer — the
    // natural shape of "one row of a matrix living in a cbuffer". The
    // other operand is then the shared vector, whatever it is.
    private static (IRRegister? row, IRExpression? vector) AsRowVector(IRExpression candidate, IRExpression other)
    {
        if (candidate is IRExpression.RegisterExpression { Register: { RegisterType: RegisterType.ConstantBuffer } reg }
            && reg.ComponentMode != Operand.OperandComponentMode.Select1)
        {
            return (reg, other);
        }

        return (null, null);
    }

    private static bool SameBaseRegister(IRRegister a, IRRegister b)
    {
        return a.RegisterType == b.RegisterType
            && a.Index == b.Index
            && a.Indices.SequenceEqual(b.Indices)
            && a.Modifier == b.Modifier;
    }

    // "Next row" means same constant buffer / base indices except the
    // last index slot (the row index within the buffer) incremented by
    // exactly one, with no dynamic/relative indexing involved.
    private static bool IsNextRow(IRRegister previous, IRRegister next)
    {
        if (previous.RegisterType != next.RegisterType || previous.Index != next.Index)
            return false;

        if (previous.Indices.Count == 0 || previous.Indices.Count != next.Indices.Count)
            return false;

        if (previous.RelativeIndices.Any(r => r is not null) || next.RelativeIndices.Any(r => r is not null))
            return false;

        for (int i = 0; i < previous.Indices.Count - 1; i++)
        {
            if (previous.Indices[i] != next.Indices[i])
                return false;
        }

        return next.Indices[^1] == previous.Indices[^1] + 1;
    }
}