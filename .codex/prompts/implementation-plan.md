Using the final recommended solution from the brainstorming phase, generate a complete and detailed Implementation Plan.

You MUST follow this exact structure and order:

# 1. Final Decision Summary
- Summarize the chosen solution in 3–5 sentences.
- Explain why it was selected over other options.
- State key constraints and assumptions.

# 2. Architecture Overview
- List all impacted services/modules.
- List newly introduced components (if any).
- Describe high-level data flow and request flow.
- Mention integration points with other systems.
- Include any important sequence of operations.

# 3. API / Contract Changes
For each change, specify:
- New/updated endpoints, routes, or RPC methods
- Request/response schema changes
- Event schema changes (if using event-driven design)
- Backward compatibility considerations
- Versioning needs (if applicable)

# 4. Database Changes
- New tables, columns, indexes, constraints
- Migration plan (up + down)
- Data backfill or clean-up requirements
- Impact on existing queries or foreign key relationships

# 5. Step-by-Step Implementation Tasks
Break into small, PR-sized tasks.  
Each task must include:

- Task name  
- Purpose  
- Files/modules to modify  
- Dependencies  
- Owner agent (e.g., coder, docs-manager, reviewer)

Example structure:
### Phase 1 — Preparation
- [ ] Task 1  
- [ ] Task 2

### Phase 2 — Core Implementation
- [ ] Task 3  
- [ ] Task 4

### Phase 3 — Integration
- [ ] Task 5  
- [ ] Task 6

### Phase 4 — Testing
- [ ] Unit tests  
- [ ] Integration tests  
- [ ] Edge case coverage

### Phase 5 — Deployment & Rollout
- [ ] Feature flags  
- [ ] Migrations  
- [ ] Monitoring & alerting  
- [ ] Post-deploy verification

# 6. Integration Details
- Describe how the new logic interacts with existing modules.
- List cross-service communication details.
- Note changes to authentication, authorization, or shared libraries.
- Clarify how the feature integrates with:
  - notifications
  - email
  - workflow engines
  - background jobs
  - event buses / message queues (if any)

# 7. Testing Plan
- Unit testing strategy  
- Integration tests with mock/stubs  
- Contract testing (if applicable)  
- End-to-end testing (if multiple services involved)  
- Negative scenarios  
- Edge cases  
- Performance/load concerns  

# 8. Deployment & Rollout Strategy
- Migration order  
- Feature flags / toggles  
- Backward compatibility window  
- Monitoring points  
- Rollback strategy  
- Communication to team/users (if needed)  

# 9. Risks & Mitigations
List each risk explicitly:
- Risk → Impact → Mitigation

# 10. Open Questions
Include anything needing clarification:
- External dependencies  
- Missing pieces from the brainstorming  
- Unknowns about business logic  
- Uncertain flows or data requirements  

----------------------------------------------
Rules:
- Do NOT re-brainstorm; only base the plan on the chosen solution.
- Do NOT write code.
- Tasks must be realistically small (PR-sized).
- Prioritize YAGNI, KISS, and DRY principles.
- The output MUST strictly follow the structure above.
----------------------------------------------

Start with:

## 1. Final Decision Summary
