using Parser.DXBC.IR;

namespace Parser.Core.Optimizations;

// Bit-level scalar arithmetic on DXBC's raw 32-bit immediate encoding.
// Doubles go through a separate path (they're already stored as real
// doubles, not bit patterns) — everything else is Float/Int/UInt reading
// the same uint32 differently depending on Kind.
public static class IRConstantMath
{
    public static bool IsAllComponents(IRExpression.ConstantExpression c, double value)
    {
        if (c.Kind == IRExpression.ConstantExpression.ConstantKind.Double)
            return c.DoubleValues.Length > 0 && c.DoubleValues.All(v => v == value);

        if (c.RawValues.Length == 0)
            return false;

        for (int i = 0; i < c.RawValues.Length; i++)
            if (ToDouble(c, c.RawValues[i]) != value)
                return false;

        return true;
    }

    public static double ToDouble(IRExpression.ConstantExpression c, uint raw) => c.Kind switch
    {
        IRExpression.ConstantExpression.ConstantKind.Float => BitConverter.Int32BitsToSingle((int)raw),
        IRExpression.ConstantExpression.ConstantKind.Int => unchecked((int)raw),
        IRExpression.ConstantExpression.ConstantKind.UInt => raw,
        _ => 0
    };

    public static bool TryFoldBinary(
        IRExpression.BinaryOperation op,
        IRExpression.ConstantExpression left,
        IRExpression.ConstantExpression right,
        out IRExpression.ConstantExpression? result)
    {
        result = null;

        if (left.Kind != right.Kind || left.Kind == IRExpression.ConstantExpression.ConstantKind.Double)
            return false; // no cross-kind or double folding here — narrow but safe

        int n = Math.Max(left.RawValues.Length, right.RawValues.Length);
        if (n == 0) return false;
        if (left.RawValues.Length != 1 && left.RawValues.Length != n) return false;
        if (right.RawValues.Length != 1 && right.RawValues.Length != n) return false;

        bool isComparison = op is IRExpression.BinaryOperation.Equal
            or IRExpression.BinaryOperation.NotEqual
            or IRExpression.BinaryOperation.GreaterEqual
            or IRExpression.BinaryOperation.GreaterThan
            or IRExpression.BinaryOperation.LessThan
            or IRExpression.BinaryOperation.LessEqual;

        var outVals = new uint[n];

        for (int i = 0; i < n; i++)
        {
            uint l = left.RawValues[left.RawValues.Length == 1 ? 0 : i];
            uint r = right.RawValues[right.RawValues.Length == 1 ? 0 : i];

            if (!TryFoldBinaryScalar(op, left.Kind, l, r, out uint o))
                return false;

            outVals[i] = o;
        }

        result = new IRExpression.ConstantExpression
        {
            Kind = isComparison ? IRExpression.ConstantExpression.ConstantKind.UInt : left.Kind,
            RawValues = outVals,
        };
        return true;
    }

    public static bool TryFoldUnary(
        IRExpression.UnaryExpression.UnaryOperation op,
        IRExpression.ConstantExpression operand,
        out IRExpression.ConstantExpression? result)
    {
        result = null;

        if (operand.Kind == IRExpression.ConstantExpression.ConstantKind.Double)
            return false;

        var outVals = new uint[operand.RawValues.Length];
        if (outVals.Length == 0) return false;

        for (int i = 0; i < outVals.Length; i++)
        {
            if (!TryFoldUnaryScalar(op, operand.Kind, operand.RawValues[i], out uint o))
                return false;

            outVals[i] = o;
        }

        result = new IRExpression.ConstantExpression { Kind = operand.Kind, RawValues = outVals };
        return true;
    }

    private static bool TryFoldBinaryScalar(
        IRExpression.BinaryOperation op,
        IRExpression.ConstantExpression.ConstantKind kind,
        uint l, uint r, out uint result)
    {
        result = 0;

        // Bit-level ops behave the same regardless of Float/Int/UInt —
        // they operate on the raw pattern, not the interpreted value.
        switch (op)
        {
            case IRExpression.BinaryOperation.BitwiseAnd:
            case IRExpression.BinaryOperation.LogicalAnd:
                result = l & r; return true;
            case IRExpression.BinaryOperation.BitwiseOr:
            case IRExpression.BinaryOperation.LogicalOr:
                result = l | r; return true;
            case IRExpression.BinaryOperation.BitwiseXor:
                result = l ^ r; return true;
            case IRExpression.BinaryOperation.LeftShift:
                result = l << (int)(r & 31); return true;
            case IRExpression.BinaryOperation.UnsignedRightShift:
                result = l >> (int)(r & 31); return true;
            case IRExpression.BinaryOperation.SignedRightShift:
                result = unchecked((uint)(((int)l) >> (int)(r & 31))); return true;
        }

        if (kind == IRExpression.ConstantExpression.ConstantKind.Float)
        {
            float lf = BitConverter.Int32BitsToSingle((int)l);
            float rf = BitConverter.Int32BitsToSingle((int)r);

            float? of = op switch
            {
                IRExpression.BinaryOperation.Add => lf + rf,
                IRExpression.BinaryOperation.Subtract => lf - rf,
                IRExpression.BinaryOperation.Multiply => lf * rf,
                IRExpression.BinaryOperation.Divide => rf != 0 ? lf / rf : null,
                IRExpression.BinaryOperation.Modulo => rf != 0 ? lf % rf : null,
                _ => null
            };

            if (of is float ofv)
            {
                result = unchecked((uint)BitConverter.SingleToInt32Bits(ofv));
                return true;
            }

            bool? bf = op switch
            {
                IRExpression.BinaryOperation.Equal => lf == rf,
                IRExpression.BinaryOperation.NotEqual => lf != rf,
                IRExpression.BinaryOperation.GreaterEqual => lf >= rf,
                IRExpression.BinaryOperation.GreaterThan => lf > rf,
                IRExpression.BinaryOperation.LessThan => lf < rf,
                IRExpression.BinaryOperation.LessEqual => lf <= rf,
                _ => null
            };

            if (bf is bool bfv) { result = bfv ? 0xFFFFFFFFu : 0u; return true; }
            return false;
        }

        if (kind == IRExpression.ConstantExpression.ConstantKind.Int)
        {
            int li = unchecked((int)l), ri = unchecked((int)r);

            int? oi = op switch
            {
                IRExpression.BinaryOperation.Add => unchecked(li + ri),
                IRExpression.BinaryOperation.Subtract => unchecked(li - ri),
                IRExpression.BinaryOperation.Multiply => unchecked(li * ri),
                IRExpression.BinaryOperation.Divide => ri != 0 ? li / ri : null,
                IRExpression.BinaryOperation.Modulo => ri != 0 ? li % ri : null,
                _ => null
            };

            if (oi is int oiv) { result = unchecked((uint)oiv); return true; }

            bool? bi = op switch
            {
                IRExpression.BinaryOperation.Equal => li == ri,
                IRExpression.BinaryOperation.NotEqual => li != ri,
                IRExpression.BinaryOperation.GreaterEqual => li >= ri,
                IRExpression.BinaryOperation.GreaterThan => li > ri,
                IRExpression.BinaryOperation.LessThan => li < ri,
                IRExpression.BinaryOperation.LessEqual => li <= ri,
                _ => null
            };

            if (bi is bool biv) { result = biv ? 0xFFFFFFFFu : 0u; return true; }
            return false;
        }

        if (kind == IRExpression.ConstantExpression.ConstantKind.UInt)
        {
            uint? ou = op switch
            {
                IRExpression.BinaryOperation.Add => unchecked(l + r),
                IRExpression.BinaryOperation.Subtract => unchecked(l - r),
                IRExpression.BinaryOperation.Multiply => unchecked(l * r),
                IRExpression.BinaryOperation.Divide => r != 0 ? l / r : null,
                IRExpression.BinaryOperation.UnsignedDivide => r != 0 ? l / r : null,
                IRExpression.BinaryOperation.Modulo => r != 0 ? l % r : null,
                _ => null
            };

            if (ou is uint ouv) { result = ouv; return true; }

            bool? bu = op switch
            {
                IRExpression.BinaryOperation.Equal => l == r,
                IRExpression.BinaryOperation.NotEqual => l != r,
                IRExpression.BinaryOperation.GreaterEqual => l >= r,
                IRExpression.BinaryOperation.GreaterThan => l > r,
                IRExpression.BinaryOperation.LessThan => l < r,
                IRExpression.BinaryOperation.LessEqual => l <= r,
                _ => null
            };

            if (bu is bool buv) { result = buv ? 0xFFFFFFFFu : 0u; return true; }
            return false;
        }

        return false;
    }

    private static bool TryFoldUnaryScalar(
        IRExpression.UnaryExpression.UnaryOperation op,
        IRExpression.ConstantExpression.ConstantKind kind,
        uint v, out uint result)
    {
        result = 0;

        switch (op)
        {
            case IRExpression.UnaryExpression.UnaryOperation.BitwiseNot:
                result = ~v; return true;

            case IRExpression.UnaryExpression.UnaryOperation.LogicalNot:
                result = v == 0 ? 0xFFFFFFFFu : 0u; return true;

            case IRExpression.UnaryExpression.UnaryOperation.Negate:
                if (kind == IRExpression.ConstantExpression.ConstantKind.Float)
                {
                    result = unchecked((uint)BitConverter.SingleToInt32Bits(-BitConverter.Int32BitsToSingle((int)v)));
                    return true;
                }
                if (kind == IRExpression.ConstantExpression.ConstantKind.Int)
                {
                    result = unchecked((uint)(-(int)v));
                    return true;
                }
                return false;

            case IRExpression.UnaryExpression.UnaryOperation.Absolute:
                if (kind == IRExpression.ConstantExpression.ConstantKind.Float)
                {
                    result = unchecked((uint)BitConverter.SingleToInt32Bits(Math.Abs(BitConverter.Int32BitsToSingle((int)v))));
                    return true;
                }
                if (kind == IRExpression.ConstantExpression.ConstantKind.Int)
                {
                    result = unchecked((uint)Math.Abs((int)v));
                    return true;
                }
                return false;

            default:
                return false;
        }
    }
}
