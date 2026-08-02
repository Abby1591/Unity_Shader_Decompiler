using Parser.DXBC.IR;

namespace Parser.DXBC.IR.Optimizations;

// Post-SSA, pre-HLSL-generation pass (roadmap: "Loop recognition").
//
// Unlike vector/matrix/texture recognition, this one is deliberately
// non-destructive: it does NOT rewrite the loop/breakc/endloop statements
// into a new IRForLoop node, because doing so would mean restructuring
// the block list (removing the now-redundant breakc, hoisting the
// increment out of the body, changing what the CFG/dominator info built
// earlier describes) — real surgery that belongs right next to whatever
// HLSL backend is going to consume it, not baked into an IR shape every
// other pass has to know about.
//
// Instead this walks the already-built blocks and reports, for every
// `loop ... breakc ... endloop`, whether it matches the canonical
// counting-loop shape:
//
//   i = <init>              (statement immediately before `loop`)
//   loop
//     breakc (i >= <bound>)   <- first statement of the loop body
//     ...body...
//     i = i + <step>          <- last statement before `endloop`
//   endloop
//
// A backend can use a positive match to print `for (i = init; !exit; i
// += step) { body }` instead of `while (true) { if (exit) break; ...
// i += step; }` — Init is null when no simple initializer was found
// immediately before the loop (e.g. it comes from a phi), in which case
// the backend should fall back to a plain `for (; !exit; i += step)` or
// the while(true) form.
public static class IRLoopPatternRecognition
{
    public sealed class LoopInfo
    {
        public required IRBlock LoopBlock { get; init; }
        public required IRBlock EndLoopBlock { get; init; }
        public required IRRegister InductionVariable { get; init; }
        public required IRExpression ExitCondition { get; init; }
        public required IRExpression Increment { get; init; }
        public IRExpression? Init { get; init; }

        public override string ToString()
        {
            string init = Init is null ? "?" : Init.ToString()!;
            return $"for ({InductionVariable} = {init}; !({ExitCondition}); {InductionVariable} = {Increment})";
        }
    }

    public static List<LoopInfo> Detect(List<IRBlock> blocks)
    {
        var results = new List<LoopInfo>();
        var loopStack = new Stack<int>();

        for (int i = 0; i < blocks.Count; i++)
        {
            IRStatement first = blocks[i].Statements[0];

            if (first is IRStatement.IRLoop)
            {
                loopStack.Push(i);
            }
            else if (first is IRStatement.IREndLoop && loopStack.Count > 0)
            {
                int loopIdx = loopStack.Pop();

                // Only attempt to recognize the innermost loop of a
                // matched pair as-is here — a nested loop between loopIdx
                // and i is left for its own (later, innermost-first)
                // iteration of this same loop to have already reported.
                LoopInfo? info = TryMatch(blocks, loopIdx, i);
                if (info is not null)
                    results.Add(info);
            }
        }

        return results;
    }

    private static LoopInfo? TryMatch(List<IRBlock> blocks, int loopIdx, int endLoopIdx)
    {
        int bodyStart = loopIdx + 1;
        int bodyEnd = endLoopIdx - 1;

        if (bodyStart > bodyEnd)
            return null; // empty loop body

        // ---- exit check: breakc must be the loop's very first statement ----
        List<IRStatement> firstBodyStatements = blocks[bodyStart].Statements;
        if (firstBodyStatements is not [IRStatement.IRBreak { Condition: { } exitCondition }])
            return null;

        // ---- increment: last statement before endloop ----
        List<IRStatement> lastBodyStatements = blocks[bodyEnd].Statements;
        if (lastBodyStatements[^1] is not IRStatement.IRAssignment
            {
                Destination: { } incDest,
                Expression: IRExpression.BinaryExpression { Operation: IRExpression.BinaryOperation.Add } incExpr,
            })
        {
            return null;
        }

        if (!IsSelfReferencing(incExpr, incDest))
            return null;

        // ---- tie the exit condition's register to the incremented one ----
        IRRegister? inductionVariable = exitCondition
            .CollectRegisterUses()
            .FirstOrDefault(r => SameBaseRegister(r, incDest));

        if (inductionVariable is null)
            return null;

        // ---- optional initializer: simple assignment right before `loop` ----
        IRExpression? init = null;
        if (loopIdx > 0)
        {
            List<IRStatement> priorStatements = blocks[loopIdx - 1].Statements;
            if (priorStatements.Count > 0
                && priorStatements[^1] is IRStatement.IRAssignment { Destination: { } initDest } initAssign
                && SameBaseRegister(initDest, inductionVariable))
            {
                init = initAssign.Expression;
            }
        }

        return new LoopInfo
        {
            LoopBlock = blocks[loopIdx],
            EndLoopBlock = blocks[endLoopIdx],
            InductionVariable = inductionVariable,
            ExitCondition = exitCondition,
            Increment = incExpr,
            Init = init,
        };
    }

    // "i = i + step" (or "i = step + i") — one side of the add must read
    // the exact same register the assignment writes to.
    private static bool IsSelfReferencing(IRExpression.BinaryExpression add, IRRegister destination)
    {
        return IsSameRegisterRead(add.Left, destination) || IsSameRegisterRead(add.Right, destination);
    }

    private static bool IsSameRegisterRead(IRExpression expr, IRRegister destination)
    {
        return expr is IRExpression.RegisterExpression re && SameBaseRegister(re.Register, destination);
    }

    private static bool SameBaseRegister(IRRegister a, IRRegister b)
    {
        return a.RegisterType == b.RegisterType
            && a.Index == b.Index
            && a.Indices.SequenceEqual(b.Indices);
    }
}