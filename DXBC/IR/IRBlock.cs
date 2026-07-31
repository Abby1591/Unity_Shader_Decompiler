namespace Parser.DXBC.IR;

// A maximal straight-line run of statements with a single entry (nothing
// branches into the middle of it) and a single exit (nothing branches out
// of the middle of it either). Predecessors/Successors are left empty by
// the Phase 1 splitter below — wiring them up is Phase 2 (CFG construction).
public sealed class IRBlock
{
    public int Id { get; init; }

    public List<IRStatement> Statements { get; } = new();

    public List<IRBlock> Predecessors { get; } = new();

    public List<IRBlock> Successors { get; } = new();

    public override string ToString()
        => $"Block{Id} ({Statements.Count} stmt)";
}

// Phase 1: splits a flat IRProgram.Statements list into IRBlocks using
// standard leader-based basic-block detection. Only splits — does not
// connect blocks (that's IRControlFlowGraphBuilder, Phase 2).
public static class IRBlockBuilder
{
    public static List<IRBlock> Build(IRProgram program)
    {
        List<IRStatement> statements = program.Statements;

        if (statements.Count == 0)
            return new List<IRBlock>();

        // dcl_function_body labels: call/callc branch to these by name,
        // so the target statement is a leader even though nothing above
        // it in program order looks like a branch.
        var labelIndices = new Dictionary<string, int>();
        for (int i = 0; i < statements.Count; i++)
        {
            if (statements[i] is IRStatement.IRLabel label)
                labelIndices[label.Name] = i;
        }

        var leaders = new SortedSet<int> { 0 };

        for (int i = 0; i < statements.Count; i++)
        {
            IRStatement stmt = statements[i];

            // Statements that must be the FIRST statement of a block —
            // either because something branches straight to them (loop
            // start, else, endif, ...) or because they mark a structural
            // boundary a consumer will want to reason about as a unit.
            bool isLeader = stmt is IRStatement.IRIf
                or IRStatement.IRElse
                or IRStatement.IREndIf
                or IRStatement.IRLoop
                or IRStatement.IREndLoop
                or IRStatement.IRSwitch
                or IRStatement.IRCase
                or IRStatement.IRDefault
                or IRStatement.IREndSwitch
                or IRStatement.IRLabel
                or IRStatement.IRPhase;

            if (isLeader)
                leaders.Add(i);

            // Statements that must be the LAST statement of a block —
            // control doesn't fall through past them in a single
            // predictable way, so whatever comes next starts a new block.
            bool isTerminator = stmt is IRStatement.IRIf
                or IRStatement.IRElse
                or IRStatement.IREndIf
                or IRStatement.IRLoop
                or IRStatement.IREndLoop
                or IRStatement.IRSwitch
                or IRStatement.IRCase
                or IRStatement.IRDefault
                or IRStatement.IREndSwitch
                or IRStatement.IRReturn
                or IRStatement.IRBreak
                or IRStatement.IRContinue
                or IRStatement.IRCall
                or IRStatement.IRInterfaceCall
                or IRStatement.IRPhase;

            if (isTerminator && i + 1 < statements.Count)
                leaders.Add(i + 1);

            if (stmt is IRStatement.IRCall call && labelIndices.TryGetValue(call.Label, out int target))
                leaders.Add(target);
        }

        List<int> boundaries = leaders.ToList();
        var blocks = new List<IRBlock>(boundaries.Count);

        for (int b = 0; b < boundaries.Count; b++)
        {
            int start = boundaries[b];
            int end = b + 1 < boundaries.Count ? boundaries[b + 1] : statements.Count;

            var block = new IRBlock { Id = b };
            for (int i = start; i < end; i++)
                block.Statements.Add(statements[i]);

            blocks.Add(block);
        }

        return blocks;
    }
}

// Phase 2: wires Predecessors/Successors between blocks produced by
// IRBlockBuilder.Build. Blocks stay in original program order (splitting
// never reorders), so most control flow is just "falls through to the
// next block" — the exceptions handled explicitly below are: If's false
// branch (skips past the then-body), Loop's back edge + Break's exit
// edge, Switch's edges to every case/default, and unconditional
// Return/Break/Continue suppressing the fallthrough edge entirely.
public static class IRControlFlowGraphBuilder
{
    public static void Connect(List<IRBlock> blocks)
    {
        if (blocks.Count == 0)
            return;

        var ifStack = new Stack<int>();
        var ifHasElse = new HashSet<int>();

        // continue always targets the nearest enclosing LOOP specifically
        // (a switch nested in a loop doesn't intercept continue).
        var loopStack = new Stack<int>();

        // break targets whichever of loop/switch is innermost, so these
        // share one stack + one pending-edge table keyed by the frame's
        // block index (loop and switch block indices never collide).
        var breakTargetStack = new Stack<int>();
        var pendingBreaks = new Dictionary<int, List<int>>();

        var switchStack = new Stack<int>();
        var switchCases = new Dictionary<int, List<int>>();

        for (int i = 0; i < blocks.Count; i++)
        {
            IRStatement first = blocks[i].Statements[0];
            IRStatement last = blocks[i].Statements[^1];

            // ---- structural bookkeeping (single-statement leader blocks) ----
            switch (first)
            {
                case IRStatement.IRIf:
                    ifStack.Push(i);
                    break;

                case IRStatement.IRElse:
                {
                    int ifIdx = ifStack.Peek();
                    if (i + 1 < blocks.Count)
                        Link(blocks[ifIdx], blocks[i + 1]); // false branch -> else-body
                    ifHasElse.Add(ifIdx);
                    break;
                }

                case IRStatement.IREndIf:
                {
                    int ifIdx = ifStack.Pop();
                    if (!ifHasElse.Contains(ifIdx))
                        Link(blocks[ifIdx], blocks[i]); // no else: false branch -> endif
                    ifHasElse.Remove(ifIdx);
                    break;
                }

                case IRStatement.IRLoop:
                    loopStack.Push(i);
                    breakTargetStack.Push(i);
                    pendingBreaks[i] = new List<int>();
                    break;

                case IRStatement.IREndLoop:
                {
                    int loopIdx = loopStack.Pop();
                    breakTargetStack.Pop();
                    Link(blocks[i], blocks[loopIdx]); // back edge

                    foreach (int breakSrc in pendingBreaks[loopIdx])
                        if (i + 1 < blocks.Count)
                            Link(blocks[breakSrc], blocks[i + 1]); // break -> after loop

                    pendingBreaks.Remove(loopIdx);
                    break;
                }

                case IRStatement.IRSwitch:
                    switchStack.Push(i);
                    breakTargetStack.Push(i);
                    switchCases[i] = new List<int>();
                    pendingBreaks[i] = new List<int>();
                    break;

                case IRStatement.IRCase or IRStatement.IRDefault when switchStack.Count > 0:
                    switchCases[switchStack.Peek()].Add(i);
                    break;

                case IRStatement.IREndSwitch:
                {
                    int switchIdx = switchStack.Pop();
                    breakTargetStack.Pop();
                    foreach (int caseIdx in switchCases[switchIdx])
                        Link(blocks[switchIdx], blocks[caseIdx]);
                    switchCases.Remove(switchIdx);

                    foreach (int breakSrc in pendingBreaks[switchIdx])
                        if (i + 1 < blocks.Count)
                            Link(blocks[breakSrc], blocks[i + 1]); // break -> after switch

                    pendingBreaks.Remove(switchIdx);
                    break;
                }
            }

            // ---- break / continue (can be the last statement of any block) ----
            if (last is IRStatement.IRBreak brk && breakTargetStack.Count > 0)
            {
                pendingBreaks[breakTargetStack.Peek()].Add(i);
                if (brk.Condition is null)
                    continue; // unconditional: no fallthrough
            }
            else if (last is IRStatement.IRContinue cont && loopStack.Count > 0)
            {
                Link(blocks[i], blocks[loopStack.Peek()]);
                if (cont.Condition is null)
                    continue; // unconditional: no fallthrough
            }
            else if (last is IRStatement.IRReturn ret && ret.Condition is null)
            {
                continue; // unconditional return: no fallthrough, no successors
            }

            // EndLoop's only successor is the back edge already linked above.
            if (first is IRStatement.IREndLoop)
                continue;

            // ---- default: fall through to the next block in program order ----
            if (i + 1 < blocks.Count)
                Link(blocks[i], blocks[i + 1]);
        }
    }

    private static void Link(IRBlock from, IRBlock to)
    {
        if (!from.Successors.Contains(to))
            from.Successors.Add(to);

        if (!to.Predecessors.Contains(from))
            to.Predecessors.Add(from);
    }
}