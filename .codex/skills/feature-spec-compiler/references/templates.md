# Feature Spec Templates

Use these templates to generate structured artifacts, not prose. Replace
placeholders, keep outputs machine-checkable, and return questions when policy
inputs are missing.

## Template: Eligibility Decision

Required inputs: {{glossary}}, {{policy_sources}}, {{eligibility_outcomes}},
{{candidate_inputs}}.

Expected outputs: decision contract, decision table with reason codes, tests,
validation checks, missing-input questions.

```text
System:
You are a requirements-to-business-logic compiler. Do not invent policy.
Output valid JSON that matches the provided schema.

User:
Glossary: {{glossary}}
Policy sources: {{policy_sources}}
Decision: Eligibility
Allowed outcomes: {{eligibility_outcomes}}
Candidate inputs: {{candidate_inputs}}
Tasks:
1) Define decision contract with inputs, outputs, and precedence.
2) Produce a decision table with a MANUAL_REVIEW fallback.
3) Add stable reason codes for each rule.
4) Provide at least 8 test scenarios with boundary and missing data cases.
5) List validation checks for coverage and contradictions.
```

## Template: Pricing Decision

Required inputs: {{glossary}}, {{policy_sources}}, {{price_components}},
{{pricing_constraints}}, {{rounding_rules}}.

Expected outputs: computation contract, stacking rules, discount tables, tests,
validation checks.

```text
System:
You produce implementable pricing specifications. Flag conflicts.
Output structured artifacts, not prose.

User:
Glossary: {{glossary}}
Policy sources: {{policy_sources}}
Decision: Pricing
Price components: {{price_components}}
Constraints: {{pricing_constraints}}
Rounding rules: {{rounding_rules}}
Tasks:
1) Define inputs and outputs with line items and totals.
2) Define stacking precedence and exclusions.
3) Produce discount eligibility and stacking tables.
4) Provide at least 10 test scenarios with rounding and expiry edges.
5) List validation checks for floors, caps, and monotonicity.
```

## Template: Routing Decision

Required inputs: {{glossary}}, {{policy_sources}}, {{routing_targets}},
{{routing_objectives}}, {{signals}}, {{constraints}}.

Expected outputs: routing contract, priority rules, fallback policy, tests,
validation checks.

```text
System:
You specify deterministic routing logic with explicit tie-breakers.
Output structured artifacts and tests.

User:
Glossary: {{glossary}}
Policy sources: {{policy_sources}}
Decision: Routing
Targets: {{routing_targets}}
Objectives: {{routing_objectives}}
Signals: {{signals}}
Constraints: {{constraints}}
Tasks:
1) Define routing inputs, outputs, and requiredness.
2) Produce a priority rule table with tie-breakers.
3) Define fallback behavior when no target is available.
4) Provide 8 test scenarios including capacity exhaustion.
5) List validation checks for constraint enforcement.
```

## Template: Fraud Or Risk Decision

Required inputs: {{glossary}}, {{policy_sources}}, {{risk_signals}},
{{risk_outcomes}}, {{thresholds}}.

Expected outputs: risk contract, rules or score bands, manual review triggers,
calibration tests, validation checks.

```text
System:
You specify risk decision logic. Do not invent thresholds.
Output JSON that matches the schema.

User:
Glossary: {{glossary}}
Policy sources: {{policy_sources}}
Decision: Fraud or Risk
Signals: {{risk_signals}}
Outcomes: {{risk_outcomes}}
Thresholds: {{thresholds}}
Tasks:
1) Define inputs, outputs, and precedence rules.
2) Produce rules or score bands with manual review triggers.
3) Provide at least 8 tests with false-positive and false-negative cases.
4) List validation checks for overlap and missing signals.
```

## Template: Personalization Decision

Required inputs: {{glossary}}, {{policy_sources}}, {{candidates}},
{{constraints}}, {{frequency_caps}}.

Expected outputs: ranking or selection rules, suppression rules, tests,
validation checks.

```text
System:
You specify personalization logic with explicit constraints.
Do not infer missing preferences.

User:
Glossary: {{glossary}}
Policy sources: {{policy_sources}}
Decision: Personalization
Candidates: {{candidates}}
Constraints: {{constraints}}
Frequency caps: {{frequency_caps}}
Tasks:
1) Define inputs and outputs for selection or ranking.
2) Provide selection rules with tie-breakers.
3) Define suppression and frequency caps explicitly.
4) Provide 8 test scenarios including cold-start and cap violations.
5) List validation checks for constraint priority.
```

## Template: Notification Decision

Required inputs: {{glossary}}, {{policy_sources}}, {{event_types}},
{{channels}}, {{consent_rules}}, {{suppression_rules}}.

Expected outputs: notification policy table, dedupe rules, tests, validation
checks.

```text
System:
You specify notification logic with explicit consent requirements.
Never assume consent. Output structured artifacts.

User:
Glossary: {{glossary}}
Policy sources: {{policy_sources}}
Decision: Notifications
Event types: {{event_types}}
Channels: {{channels}}
Consent rules: {{consent_rules}}
Suppression rules: {{suppression_rules}}
Tasks:
1) Define outputs such as send, channel, schedule_time, template_id.
2) Produce a policy table mapping events to behavior.
3) Define idempotency and dedupe keys.
4) Provide 8 test scenarios including quiet hours and opt-out.
5) List validation checks for consent and suppression.
```

## Template: SLA Or SLO Enforcement

Required inputs: {{glossary}}, {{policy_sources}}, {{user_journeys}}, {{slis}},
{{targets}}, {{actions}}.

Expected outputs: SLI definitions, SLO targets, enforcement actions, tests,
validation checks.

```text
System:
You specify measurable SLO and SLA rules with enforcement actions.
Ask for missing targets. Output structured artifacts.

User:
Glossary: {{glossary}}
Policy sources: {{policy_sources}}
Feature: SLA or SLO enforcement
Journeys: {{user_journeys}}
Candidate SLIs: {{slis}}
Targets: {{targets}}
Actions: {{actions}}
Tasks:
1) Define SLIs with numerator, denominator, and windows.
2) Define SLO targets and enforcement thresholds.
3) Provide 8 test scenarios including missing measurements.
4) List validation checks for measurability and conflicts.
```

## Template: Data Retention Decision

Required inputs: {{glossary}}, {{policy_sources}}, {{data_categories}},
{{purposes}}, {{legal_requirements}}, {{disposal_methods}}.

Expected outputs: retention table, legal-hold logic, audit alignment, tests,
validation checks.

```text
System:
You specify data retention as decision tables and lifecycle actions.
Do not provide legal advice. Ask for missing requirements.

User:
Glossary: {{glossary}}
Policy sources: {{policy_sources}}
Feature: Data retention and disposal
Data categories: {{data_categories}}
Purposes: {{purposes}}
Legal requirements: {{legal_requirements}}
Disposal methods: {{disposal_methods}}
Tasks:
1) Produce a retention schedule with time periods and triggers.
2) Specify legal-hold precedence and exceptions.
3) Define audit record retention alignment.
4) Provide 8 test scenarios including hold conflicts.
5) List validation checks for lifecycle completeness.
```
