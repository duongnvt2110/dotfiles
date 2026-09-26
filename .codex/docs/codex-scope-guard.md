# Codex Scope Guard

## Purpose

The scope guard reduces a recurring Codex failure mode: the agent explores a
repository correctly, discovers adjacent or theoretical issues, and then
silently expands the implementation beyond the user's request.

The operating rule is:

> Explore broadly. Prove necessity. Implement only what is necessary.

Exploration may expand understanding. It must not expand implementation scope
by itself.

## Problem It Prevents

Without an execution-time guard, Codex can turn this:

```text
possible edge case
    -> useful improvement
    -> should handle
    -> required change
    -> blocker
```

into implementation work even when the issue is not part of the requested
feature.

The scope guard changes the decision path to:

```text
discovered finding
    |
    +-- explicitly requested? ----------------------> allowed
    |
    +-- reachable through an actual code path?
    |       no -> SPECULATIVE -> do not implement
    |
    +-- relevant to the requested behavior?
    |       no -> ADJACENT -> do not implement
    |
    +-- necessary for correctness or safety?
            no -> ADJACENT -> do not implement
            yes -> REQUIRED -> may implement
```

A discovered improvement is not authorization to implement it.

## Files

```text
~/.codex/
├── AGENTS.md
├── hooks.json
└── hooks/
    └── scope-guard.sh
```

In this dotfiles repository, the source files are:

```text
.codex/AGENTS.md
.codex/hooks.json
.codex/hooks/scope-guard.sh
```

`scripts/link-codex.sh` links the hook configuration and script directory into
`~/.codex`.

## Runtime Dependency

The scope guard intentionally does not depend on Python, Node.js, `jq`, Ruby,
or another language runtime.

Codex invokes one POSIX shell script through `/bin/sh` and passes the lifecycle
event name as the first argument:

```text
scope-guard.sh UserPromptSubmit
scope-guard.sh SubagentStart
scope-guard.sh PreToolUse
```

The script does not parse Codex's stdin payload. It only selects a static
context response from the event argument and emits JSON with shell built-ins
and `cat`.

This keeps the hook portable across the macOS/Linux environments where
`/bin/sh` is part of the base system.

## Enforcement Layers

### Global `AGENTS.md`

The global instructions define the durable policy:

- keep implementation inside the approved scope;
- do not refactor unrelated code;
- prove reachability, relevance, and necessity before treating unrequested
  work as required or blocking;
- classify unproven findings as adjacent or speculative;
- stop when the requested behavior is correct, safe, verified, and complete.

This is the policy source, but static instructions alone are not sufficient for
long sessions or delegated work.

### `UserPromptSubmit`

Every user turn reinjects the full scope lock.

This keeps the scope rule close to the current request instead of depending on
Codex remembering an earlier instruction after a long exploration.

### `SubagentStart`

Every spawned subagent receives the same scope lock.

This prevents reviewer or exploration subagents from broadening the task merely
because they discovered additional issues.

### `PreToolUse`

Before normal editing tools run, the hook injects a smaller mutation gate.

The edit is allowed only when it is:

1. explicitly requested by the user; or
2. proven necessary for the requested behavior to be correct or safe.

The current matcher targets normal Codex edit aliases:

```text
apply_patch
Write
Edit
```

It intentionally does not attempt to parse every shell command. Adding shell
heuristics would introduce false positives and additional complexity without a
proven need.

## Classification Contract

Use these meanings consistently during reviews and implementation.

### REQUIRED

The requested task cannot be considered correct or safe without addressing the
finding.

An unrequested REQUIRED finding must have repository evidence for all three:

- **REACHABLE** — an actual traced code path reaches the issue;
- **RELEVANT** — the issue affects the requested behavior or acceptance
  criteria;
- **NECESSARY** — the task cannot be correct or safe without fixing it.

### ADJACENT

The finding is real but not required for the current request.

It may be reported when useful, but it must not expand implementation scope
unless the user explicitly asks for it.

### SPECULATIVE

The finding is theoretical, unproven, unreachable from the traced path, or
dependent on assumptions that the repository does not establish.

It must not be treated as a blocker or implemented as part of the current task.

## Interaction With Ponytail

Ponytail remains enabled separately.

Ponytail provides broader anti-overengineering behavior and lifecycle
reinjection. The local scope guard does not replace it. It adds a narrower rule
for a recurring failure mode:

```text
finding something != permission to implement it
```

The two mechanisms are complementary:

```text
Ponytail
    -> prefer simpler implementations

Scope Guard
    -> first prove the extra implementation belongs to the task at all
```

Both can listen to the same Codex lifecycle events. Codex runs the matching
plugin and user hooks independently.

## Installation

Run the dotfiles linker:

```sh
scripts/link-codex.sh
```

The resulting live paths should include:

```text
~/.codex/hooks      -> <dotfiles>/.codex/hooks
~/.codex/hooks.json -> <dotfiles>/.codex/hooks.json
```

Codex requires new hooks to be reviewed and trusted. In interactive Codex, run:

```text
/hooks
```

Review and trust the scope-guard hooks once.

## Verification

Check the shell script syntax:

```sh
/bin/sh -n .codex/hooks/scope-guard.sh
```

Check each event directly:

```sh
/bin/sh .codex/hooks/scope-guard.sh UserPromptSubmit
/bin/sh .codex/hooks/scope-guard.sh SubagentStart
/bin/sh .codex/hooks/scope-guard.sh PreToolUse
```

Each command should emit one JSON object containing `hookSpecificOutput`, the
same event name, and non-empty `additionalContext`.

Validate the linker syntax separately:

```sh
bash -n scripts/link-codex.sh
```

For an end-to-end Codex smoke test, start Codex, trust the hooks through
`/hooks`, and submit a normal task. The `UserPromptSubmit` hook should appear as
active, while edit operations should trigger the mutation gate.

## Expected Behavior

For a request such as:

```text
Fix the raw-content leak in ReadText -> MCP serialization.
```

Codex may inspect related parsing and serialization paths. If it discovers a
hypothetical malformed-input case but cannot prove that the current path
produces it, the expected result is:

```text
Classification: SPECULATIVE
Action: do not implement
```

If it discovers a reachable issue that directly prevents the requested fix from
being correct, and the fix is necessary, the expected result is:

```text
Classification: REQUIRED
Action: implement the smallest sufficient change
```

## Scope Limits

The guard deliberately does not include:

- an LLM-as-judge stop hook;
- persistent task state;
- automatic rewriting of Codex output;
- repository-wide shell-command parsing;
- mandatory proof tables for every finding;
- a new orchestration framework.

Add stronger enforcement only after a concrete failure demonstrates that the
current mechanism is insufficient.
