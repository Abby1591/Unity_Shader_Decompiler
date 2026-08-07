using Parser.DXBC.IR;

namespace Parser.DXBC.Hlsl.Ast;

// Stage 10 — Statement Generation.
//
// Deliberately does NOT introduce a parallel expression AST (no
// HlslExpressionNode) — IRExpression (DXBC/IR/IRExpression.cs) already
// covers arithmetic/intrinsics/texture-ops/ternary/swizzle-via-register
// with correct typing and a working ToString(), which is everything
// Stage 11 asked for. Duplicating that tree here would be pure
// busywork with no behavior difference, so statements just hold
// IRExpression/IRRegister directly. Stage 13's pretty printer is what
// turns these into real HLSL text (ToString() is debug output, not
// meant to be the final source).
public abstract class HlslStatementNode
{
}

public sealed class HlslBlockStatement : HlslStatementNode
{
    public List<HlslStatementNode> Statements { get; } = new();
}

public sealed class HlslAssignmentStatement : HlslStatementNode
{
    public IRRegister Destination { get; init; } = null!;
    public IRExpression Expression { get; init; } = null!;
}

// imul/udiv/etc — more than one destination from one instruction.
public sealed class HlslMultiAssignmentStatement : HlslStatementNode
{
    public List<IRRegister?> Destinations { get; } = new();
    public List<IRExpression> Expressions { get; } = new();
}

public sealed class HlslIfStatement : HlslStatementNode
{
    public IRExpression Condition { get; init; } = null!;
    public HlslBlockStatement Then { get; init; } = new();
    public HlslBlockStatement? Else { get; init; }
}

// DXBC's loop/endloop is an unconditional "loop forever, break out of
// it explicitly" construct — always lowered as a bare loop body with
// break/breakc inside, never re-inferred as a for/while here. (A later
// pass could pattern-match common for-loop shapes back out of this if
// wanted; Stage 10 just needs the structure to be correct, not pretty.)
public sealed class HlslLoopStatement : HlslStatementNode
{
    public HlslBlockStatement Body { get; init; } = new();
}

public sealed class HlslSwitchCase
{
    // null means "default:"
    public IRExpression? Value { get; init; }
    public HlslBlockStatement Body { get; init; } = new();
}

public sealed class HlslSwitchStatement : HlslStatementNode
{
    public IRExpression Selector { get; init; } = null!;
    public List<HlslSwitchCase> Cases { get; } = new();
}

public sealed class HlslBreakStatement : HlslStatementNode
{
    public IRExpression? Condition { get; init; }
}

public sealed class HlslContinueStatement : HlslStatementNode
{
    public IRExpression? Condition { get; init; }
}

public sealed class HlslReturnStatement : HlslStatementNode
{
    public IRExpression? Condition { get; init; }
}

public sealed class HlslDiscardStatement : HlslStatementNode
{
    public IRExpression Condition { get; init; } = null!;
}

public sealed class HlslMemoryStoreStatement : HlslStatementNode
{
    public IRRegister Resource { get; init; } = null!;
    public IRExpression Address { get; init; } = null!;
    public IRExpression Value { get; init; } = null!;
}

// Fallback for anything without a dedicated node yet (atomics, barriers,
// geometry-shader emit/cut, hull-shader phases, dynamic-linkage calls,
// post-SSA phi nodes) — wraps the original IRStatement verbatim rather
// than silently dropping it. Its ToString() is already sensible debug
// text; a real HLSL rendering (InterlockedAdd(...), GroupMemoryBarrier(),
// etc.) is Stage 13's job once these actually show up in a real shader
// and can be checked against real output.
public sealed class HlslRawStatement : HlslStatementNode
{
    public IRStatement Source { get; init; } = null!;
}

// Recursive-descent builder over DXBC's flat, well-formed-nesting
// statement stream (if/endif, loop/endloop, switch/case/default/endswitch
// are always balanced within one subprogram — DXBC is structured
// bytecode, not arbitrary goto soup; only call/callc uses labels, and
// those fall through to HlslRawStatement below rather than being
// mis-modeled).
public static class HlslStatementBuilder
{
    public static HlslBlockStatement Build(IReadOnlyList<IRStatement> statements)
    {
        int i = 0;
        return ParseBlock(statements, ref i);
    }

    // Parses statements into `block` until it hits a marker that closes
    // an enclosing construct (Else/EndIf/EndLoop/Case/Default/EndSwitch)
    // — that marker is left unconsumed for the caller to handle. Nested
    // constructs consume their own closing marker via recursion, so the
    // first such marker seen at this call's level genuinely belongs to
    // whatever the caller is currently parsing.
    private static HlslBlockStatement ParseBlock(IReadOnlyList<IRStatement> statements, ref int i)
    {
        var block = new HlslBlockStatement();

        while (i < statements.Count)
        {
            switch (statements[i])
            {
                case IRStatement.IRElse:
                case IRStatement.IREndIf:
                case IRStatement.IREndLoop:
                case IRStatement.IRCase:
                case IRStatement.IRDefault:
                case IRStatement.IREndSwitch:
                    return block; // belongs to an enclosing construct — don't consume

                case IRStatement.IRIf ifStmt:
                {
                    i++;
                    HlslBlockStatement thenBlock = ParseBlock(statements, ref i);
                    HlslBlockStatement? elseBlock = null;

                    if (i < statements.Count && statements[i] is IRStatement.IRElse)
                    {
                        i++;
                        elseBlock = ParseBlock(statements, ref i);
                    }

                    if (i < statements.Count && statements[i] is IRStatement.IREndIf)
                        i++;

                    block.Statements.Add(new HlslIfStatement
                    {
                        Condition = ifStmt.Condition,
                        Then = thenBlock,
                        Else = elseBlock,
                    });
                    continue;
                }

                case IRStatement.IRLoop:
                {
                    i++;
                    HlslBlockStatement body = ParseBlock(statements, ref i);

                    if (i < statements.Count && statements[i] is IRStatement.IREndLoop)
                        i++;

                    block.Statements.Add(new HlslLoopStatement { Body = body });
                    continue;
                }

                case IRStatement.IRSwitch switchStmt:
                {
                    i++;
                    var switchNode = new HlslSwitchStatement { Selector = switchStmt.Selector };

                    while (i < statements.Count &&
                           statements[i] is IRStatement.IRCase or IRStatement.IRDefault)
                    {
                        IRExpression? caseValue = statements[i] is IRStatement.IRCase c ? c.Value : null;
                        i++;
                        HlslBlockStatement caseBody = ParseBlock(statements, ref i);
                        switchNode.Cases.Add(new HlslSwitchCase { Value = caseValue, Body = caseBody });
                    }

                    if (i < statements.Count && statements[i] is IRStatement.IREndSwitch)
                        i++;

                    block.Statements.Add(switchNode);
                    continue;
                }

                case IRStatement.IRAssignment a:
                    block.Statements.Add(new HlslAssignmentStatement { Destination = a.Destination, Expression = a.Expression });
                    i++;
                    continue;

                case IRStatement.IRMultiAssignment ma:
                {
                    var node = new HlslMultiAssignmentStatement();
                    node.Destinations.AddRange(ma.Destinations);
                    node.Expressions.AddRange(ma.Expressions);
                    block.Statements.Add(node);
                    i++;
                    continue;
                }

                case IRStatement.IRBreak b:
                    block.Statements.Add(new HlslBreakStatement { Condition = b.Condition });
                    i++;
                    continue;

                case IRStatement.IRContinue c:
                    block.Statements.Add(new HlslContinueStatement { Condition = c.Condition });
                    i++;
                    continue;

                case IRStatement.IRReturn r:
                    block.Statements.Add(new HlslReturnStatement { Condition = r.Condition });
                    i++;
                    continue;

                case IRStatement.IRDiscard d:
                    block.Statements.Add(new HlslDiscardStatement { Condition = d.Condition });
                    i++;
                    continue;

                case IRStatement.IRMemoryStore ms:
                    block.Statements.Add(new HlslMemoryStoreStatement
                    {
                        Resource = ms.Resource,
                        Address = ms.Address,
                        Value = ms.Value,
                    });
                    i++;
                    continue;

                default:
                    // IRLabel, IRCall, IRInterfaceCall, IRPhase, IRAtomicOp,
                    // IRBarrier, IREmitVertex, IRCutStream, IRPhi — all rare
                    // in the shaders this project targets (hull/geometry/
                    // compute stages, or post-SSA-only nodes). Preserved
                    // verbatim rather than guessed at.
                    block.Statements.Add(new HlslRawStatement { Source = statements[i] });
                    i++;
                    continue;
            }
        }

        return block;
    }
}