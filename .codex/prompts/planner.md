---
description: ⚡⚡ Brainstorm a feature
argument-hint: [question]
MODE: PLAN
---

Goal:
## Answer this question: 
<question>$ARGUMENTS</question>

Context:
- Tech stack: Golang, Clean Architecture (handler → service → repository)
- Project: Simple Todo API
- Constraints: Keep functions small, clean, and testable.

Your job:
1. Restate the problem in your own words.
2. List assumptions.
3. Define success criteria.
4. Propose a high-level design:
   - Functions to add/change
   - Data flow
   - Any new structs or fields
5. Break into a step-by-step task list:
   - Task 1
   - Task 2
   - Task 3
6. List tests needed.
7. Output each task into a `plans` folder at the root
DO NOT write any code.
