# Debugging

Diagnose before patching. A fix should follow from a traced failure path and a falsifiable explanation.

## Procedure

1. Reproduce the failure or establish the exact observable symptom.
2. Trace the execution/data path to the failing boundary.
3. Minimise the case when that materially improves diagnosis.
4. Form a concrete hypothesis that explains the evidence.
5. Instrument or inspect the smallest point that can confirm/refute it.
6. Apply the narrowest fix supported by the evidence.
7. Add or run regression verification against the original symptom.

## Guardrails

- Canonical flow: reproduce → trace → minimise → hypothesis → instrument → fix → regression verification.
