#!/bin/sh

set -eu

event="${1:-}"

case "$event" in
  UserPromptSubmit|SubagentStart)
    cat <<EOF
{"hookSpecificOutput":{"hookEventName":"$event","additionalContext":"SCOPE LOCK\n\nExplore broadly. Prove necessity. Implement only what is necessary.\n\nExploration may expand understanding. It must not expand implementation scope by itself.\n\nBefore adding or changing code, tests, docs, config, abstractions, validation, refactors, cleanup, hardening, or future-proofing that the user did not explicitly request, prove all three from repository evidence:\n\n1. REACHABLE: the issue occurs through an actual traced code path.\n2. RELEVANT: it affects the user's requested behavior or acceptance criteria.\n3. NECESSARY: the requested task cannot be correct or safe without the change.\n\nIf any proof is missing, classify the finding as ADJACENT or SPECULATIVE. Do not implement it and do not make it a blocker. Report it only when useful.\n\nA discovered improvement is not authorization to implement it. Do not opportunistically refactor, generalize, clean up, harden unrelated paths, or prepare for hypothetical future requirements.\n\nOnce the requested behavior is correct, safe, tested, and complete: STOP."}}
EOF
    ;;

  PreToolUse)
    cat <<'EOF'
{"hookSpecificOutput":{"hookEventName":"PreToolUse","additionalContext":"MUTATION GATE\n\nBefore this edit, confirm that the mutation is either explicitly requested or proven necessary for the requested behavior to be correct or safe. Discovery alone is not authorization to modify code. If the change is merely adjacent, speculative, cleanup, refactoring, hardening, generalization, or future-proofing, do not make it."}}
EOF
    ;;

  *)
    exit 0
    ;;
esac
