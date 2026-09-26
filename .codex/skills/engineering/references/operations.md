# Operations

Use operational evidence to diagnose and stabilize production/runtime problems. Prefer mitigation and verified recovery before broad redesign.

## Procedure

1. Establish the exact symptom, affected population, start time, and impact.
2. Check the system's existing signals: logs, metrics, traces, health checks, queue depth, resource usage, or error rates as applicable.
3. Correlate evidence across the smallest relevant time window and component path.
4. Form a falsifiable hypothesis and inspect the boundary that can confirm or reject it.
5. If impact is ongoing, choose the smallest safe mitigation supported by existing operations:
   - rollback;
   - disable/revert a feature path;
   - restart/recycle a failed component;
   - reduce load or concurrency;
   - fail over;
   - apply another documented runbook action.
6. Verify recovery using the original symptom and operational signals.
7. After recovery, record the confirmed cause, missing detection/guardrail, and the smallest follow-up action.

## Guardrails

- Do not infer production state from code alone when runtime evidence is available.
- Do not expose secrets, tokens, customer data, or sensitive log payloads.
- Do not change production configuration or execute destructive recovery actions without explicit authorization.
- Avoid speculative architecture work during active mitigation. Stabilize first, then evaluate follow-up changes with better evidence.

## Incident closure

A useful closure note contains:

```text
symptom and impact
observed evidence
confirmed cause or remaining uncertainty
mitigation/recovery performed
recovery verification
follow-up prevention/detection work
```
