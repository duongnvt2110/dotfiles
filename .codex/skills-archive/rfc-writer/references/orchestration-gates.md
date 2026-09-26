# RFC Orchestration Gates

## Gate Matrix

| Condition | Gate | Action |
| --- | --- | --- |
| Problem framing unclear | Ambiguity gate | Invoke `brainstorming` |
| Cross-team change + weak evidence | Evidence gate | Invoke `deep-research` |
| Small local change, clear fix | No gate | Skip RFC and stay in planner |
| Decision already approved | No gate | Skip RFC and invoke `adr-recorder` |

## Cross-Team or External-Impact Examples

- Vendor or managed platform selection
- Security posture or auth model changes
- Compliance-impacting architecture
- Reliability/SLO/SLA model changes
- Major operational cost posture changes

## Evidence Sufficiency Checklist

- At least one credible source per major claim
- Trade-off data mapped to ranked criteria
- Risks and unknowns are explicit
- Reasonable alternatives are represented fairly
