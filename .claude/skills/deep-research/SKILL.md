---
name: deep-research
description: 'Multi-agent orchestration workflow for deep research: break a research goal into parallelizable sub-goals, run child processes via Claude Code non-interactive mode (`claude -p`); prefer installed skills for networking and collection, then MCP tools; aggregate child results via scripts and polish by section, delivering "final report file path + key findings/recommendations summary." Use for systematic web/material research, competitive/industry analysis, batch link/dataset shard retrieval, long-form writing and evidence synthesis, or when users mention "deep research/Deep Research/Wide Research/multi-agent parallel research/multi-process research."'
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, WebFetch, WebSearch, TodoWrite, mcp__firecrawl__firecrawl_scrape, mcp__firecrawl__firecrawl_search, mcp__firecrawl__firecrawl_map, mcp__firecrawl__firecrawl_crawl, mcp__firecrawl__firecrawl_extract, mcp__firecrawl__firecrawl_agent, mcp__plugin_claude-code-settings_exa__web_search_exa, mcp__plugin_claude-code-settings_exa__get_code_context_exa
---

# Deep Research

Treat deep research as a reusable, parallelized production workflow: the controller
clarifies goals, breaks down sub-goals, schedules child processes, aggregates and polishes;
child processes collect/extract/do localized analysis and output structured Markdown
material; final deliverables must be standalone files, not chat posts.

**Key constraints (must follow)**

- **Keep default models and configuration unchanged**: Do not explicitly override the model
  or override default model/inference settings via extra parameters; only change
  configuration with explicit user authorization.
- **Default to least privilege**: Child processes control allowed tools via `--allowedTools`;
  enable network and other privileges only when necessary.
- **Prefer skills for networked work, then MCP**: Prefer installed skills; if MCP is
  required, use `firecrawl` first, then `exa`; only consider WebFetch/WebSearch when those
  cannot meet the need.
- **Non-interactive friendly**: Child processes do not use the plan tool and do not wait
  for user confirmation/feedback; prioritize file outputs and traceable logs.
- **File delivery first**: Final deliverables must be saved as standalone files; do not
  paste full drafts in chat.
- **Log decisions and progress at each step**: Especially before decomposition, scheduling,
  aggregation, polishing, and delivery.
- **Task scale threshold**: When sub-goal count is >=3, you must start `claude -p` child
  processes; for <3 sub-goals, the main process may execute directly, but still record
  full directory structure and raw data.
- **Must wait for user confirmation**: After scoping, explicitly ask the user
  "start execution?" and do not proceed until the user replies with an affirmative like
  "execute/start/go/yes."

## Goals

1. Derive a parallelizable set of sub-goals from the user's high-level goal, such as link
   lists, data shards, module lists, or time slices.
2. Start a separate `claude -p` child process for each sub-goal and assign appropriate
   permissions via `--allowedTools`.
3. Execute in parallel and produce child reports in natural-language Markdown, with
   optional sections/tables/lists; on failure, output an error explanation with causes and
   follow-up suggestions.
4. Use scripts to aggregate child outputs in order into a unified base draft.
5. Perform sanity checks and **minimal fixes** on the base draft, then provide the final
   artifact path and key findings summary.

## Delivery standards

- Deliverables must be a **structured, insight-driven** complete report; do not simply
  concatenate child-task Markdown as the final output.
- If raw child-task text must be preserved, store it as an internal file such as
  `.research/<name>/aggregated_raw.md`, and only incorporate key insights/evidence in the
  final report.
- Polishing and revision must iterate **by section, paragraph by paragraph**, not by
  deleting and rewriting the whole piece at once; after each change, verify citations,
  data, and context to maintain traceability.
- Default deliverable is a detailed, in-depth analytical report.
- Perform a "double-check quality inspection" before delivery:
  1) Check that the output truly comes from "sectioned, multi-round integration"; if it
     was generated in one pass, redo it section by section.
  2) Assess whether it is sufficiently detailed; if it is thin, determine whether the
     cause is "insufficient child-task material" or "over-compression during synthesis."
     In the first case, add supplementary research; in the second, expand and polish the
     existing material until it meets the detail standard.

## Task scale tiers and execution paths

Choose execution path by sub-goal count:

| Scale | Sub-goal count | Execution mode | Directory requirements |
|-------|----------------|----------------|------------------------|
| **Micro** | 1-2 | Main process executes directly | Still need `raw/`, `logs/`, `final_report.md` |
| **Small** | 3-5 | Start child processes; serial or limited parallel | Full directory structure |
| **Medium** | 6-15 | Parallel child processes, default 8 | Full structure + scheduler script |
| **Large** | >15 | GNU Parallel + batch scheduling | Full structure + multi-stage scheduling |

**Note**: Even micro tasks must:
1. Save raw search results to `raw/`
2. Record execution logs in `logs/dispatcher.log`
3. Wait for user confirmation before execution unless the user explicitly says
   "execute directly."

## End-to-end flow (strict order)

0. **Pre-execution planning and scoping (required; controller must do this)**
   - Clarify goals, risks, and resource/permission constraints first, and identify core
     dimensions for later expansion: topic clusters, people/organizations, regions, time
     slices, etc.
   - If there is a public directory/index such as tabs or API lists, minimally fetch and
     cache to count entries; if not, do "desk research" to obtain real samples such as
     news, materials, or datasets, and record sources/timestamps/key points as evidence.
   - Before producing the list, show at least one representative sample from real search
     or browsing; relying only on experience-based guesses is not sufficient scoping.
   - During scoping you must obtain at least one real sample through a "traceable tool
     chain" and record citations: prefer installed skills; if MCP is needed, use
     `firecrawl` first, then `exa`; if neither is available, record the reason and choose
     an alternative, falling back to WebFetch/WebSearch only when necessary.
   - Output an initial or draft list: list discovered dimensions, known options and
     samples per dimension, scale estimates, and mark uncertainties/gaps. If no real
     samples have been obtained, fill the research gap first and do not proceed.
   - Complete an executable plan based on the structure above: decomposition, scripts/tools,
     output formats, permissions, timeout strategy, etc., and report the dimension counts
     and plan in user language; wait until you receive an explicit "execute/start" response.

1. **Initialization and overall planning**
   - Clarify the goal, expected output format, and evaluation criteria.
   - Generate a semantic, unique name `name` for the task, suggested format:
     `<YYYYMMDD>-<short-topic>-<random-suffix>`, all lowercase, hyphen-separated, no spaces.
   - Create the run directory `.research/<name>/` and store **all** artifacts there
     (subdirectories such as `prompts/`, `logs/`, `child_outputs/`, `raw/`, `cache/`, `tmp/`).
   - Keep default model and configuration unchanged; if any model/inference/permission
     settings must change, obtain user consent first and log the reason and scope.

2. **Sub-goal identification**
   - Extract or construct the sub-goal list via scripts/commands.
   - If source data is insufficient, e.g., a page only provides two main links, record the
     reason truthfully and have the main process take over the remaining work.

3. **Generate the scheduling script**
   - Create a scheduling script such as `.research/<name>/run_children.sh`, requirements:
     - Accept a sub-goal list (JSON/CSV allowed) and schedule each item.
     - Construct a `claude -p` call for each sub-goal; recommended points:
       - Recommended form: `claude -p "prompt" --allowedTools "Read,Write,Edit,Bash,WebFetch,WebSearch,mcp__firecrawl__*"`
         (defer to `claude --help` for the latest options).
       - State in the prompt: for all network needs, prefer installed skills; if MCP is
         required, prefer `firecrawl` then `exa`; only use WebFetch/WebSearch if unavoidable;
         do not use the plan tool or "human-interaction waiting."
       - Do not pass model parameters unless requested by the user.
       - Specify an output path for each child result, e.g.,
         `.research/<name>/child_outputs/<id>.md`.
       - You may reference the template below; parameters only, no parallelism.
         ```bash
         timeout 600 claude -p "$(cat "$prompt_file")" \
            --allowedTools "Read,Write,Edit,Bash,Glob,Grep,WebFetch,WebSearch,mcp__firecrawl__firecrawl_scrape,mcp__firecrawl__firecrawl_search" \
            --output-format json \
            > "$output_file" 2>&1
         ```
       - If child processes need more tools, add them in `--allowedTools`.
       - Set timeouts by task scale: small tasks get 5 minutes (`timeout 300`), larger tasks
         up to 15 minutes (`timeout 900`), using external `timeout` as a safety net. If the
         5-minute timeout is hit, decide whether to split/adjust parameters and retry; if
         15 minutes still fails, treat it as a prompt or process issue to investigate.
       - For small tasks (<8), use loops + background jobs (or queue control) to run in
         parallel, avoiding command-length limits; for large tasks, use `xargs`/GNU Parallel,
         but validate parameter expansion on a small scale first. Default parallelism is 8,
         adjustable by hardware or quota.
       - Do not replace parallelism with serial one-by-one runs; do not bypass the process
         with "main process quick searching."
       - Capture each child process exit code and write logs to the run directory; use
         `stdbuf -oL -eL claude -p ... 2>&1 | tee .research/<name>/logs/<id>.log` to flush
         output in real time for `tail -f` monitoring.
   - When data volume is sufficient, the controller should avoid doing heavy download/
     parsing work directly; delegate to child processes and focus on prompts, templates,
     and environment setup.

4. **Design child process prompts**
   - Dynamically generate prompt templates that include at least:
     - Sub-goal description, input data, and constraint boundaries.
     - In the planning stage, cap total network search/extraction rounds to X based on
       complexity (typically 10); stop once information is sufficient. Tool priority:
       skills -> MCP (`firecrawl` -> `exa`) -> WebFetch/WebSearch.
     - Output results as natural-language Markdown: include conclusions, key evidence lists,
       and citation links; on errors, provide Markdown-formatted error explanations and
       follow-up suggestions.
     - When generating prompt files, prefer `printf`/line-by-line writes to inject
       variables, avoiding the known Bash 3.2 issue where `cat <<EOF` can truncate variables
       in multi-byte character contexts.
   - Write the template to a file such as `.research/<name>/child_prompt_template.md` for
     auditability and reuse.
   - Before running the scheduler, quickly review each generated prompt file (e.g.,
     `cat .research/<name>/prompts/<id>.md`) to confirm variable substitution and complete
     instructions before dispatching tasks.

5. **Parallel execution and monitoring**
   - Run the scheduling script.
   - Record each child process start/end time, duration, and status.
   - Make explicit decisions for failed/timeout child processes: mark, retry, or explain
     in the final report; if the 15-minute timeout is hit, log the prompt/process for
     investigation. For long tasks, suggest `tail -f .research/<name>/logs/<id>.log` to
     track live output.

6. **Programmatic aggregation (generate base draft)**
   - Use a script such as `.research/<name>/aggregate.py` to read all Markdown files under
     `.research/<name>/child_outputs/` and aggregate them in the preset order into an
     initial master document such as `.research/<name>/final_report.md`.

7. **Interpret aggregation results and design structure**
   - Read `.research/<name>/final_report.md` and key child outputs.
   - Design a polished report outline and "material mapping" (e.g.,
     `.research/<name>/polish_outline.md`), clarifying target audience, section order, and
     core argument per section.

8. **Polish by section and draft final output**
   - Create a polished draft such as `.research/<name>/polished_report.md` and write it
     section by section; after each section, verify facts, citations, and language
     requirements, and cross-check child drafts when needed.
   - Avoid rewriting the whole document in one pass; iterate by section to maintain
     consistency and reduce omission risk, while recording highlights, issues, and
     resolutions per section.
   - Normalize duplicate information, citation formats, and items needing confirmation,
     while preserving core facts and quantitative data.

9. **Finalize and deliver**
   - Confirm the polished draft meets delivery standards (complete structure, consistent
     tone, accurate citations) and use it as the outward-facing report.
   - The final deliverable must be a standalone file under `.research/<name>/`; report back
     with the file path and necessary summary, and do not paste the full draft in chat.
   - In the final response, summarize core conclusions and actionable recommendations; add
     follow-up guidance for items that remain unconfirmed when needed.
   - Do not attach intermediate drafts or internal notes; ensure the user sees only the
     high-quality final artifact.

## Notes

- Keep the process idempotent: each run generates a new `.research/<name>/` to avoid
  overwriting old files.
- All structured outputs must be valid UTF-8 text.
- Only elevate permissions when authorized or truly necessary; avoid abuse.
- Be careful when cleaning temporary resources to keep logs and outputs traceable.
- Provide a degradation path for failed workflows: for scraping tasks, try at least twice;
  if still failing, add a "failure reasons/follow-up suggestions" section in Markdown to
  avoid gaps during aggregation.
- **Cache first**: For raw materials obtained via skills/MCP, write to `.research/<name>/raw/`
  and other cache directories first; later processing should read from local cache to
  reduce repeat requests.
- **Understand fully before summarizing**: Before summarizing, process the full original
  text; do not mechanically truncate to a fixed length (e.g., first 500 characters). Scripts
  may parse full text, extract key sentences, or generate bullet points, but must not rely
  on hard truncation.
- **Temporary directory isolation**: Intermediate artifacts such as script logs, parse
  results, caches, and debug output should live under `.research/<name>/tmp/`,
  `.research/<name>/raw/`, `.research/<name>/cache/`, etc.; clean up as needed after the
  workflow ends.
- **Search service priority**: For network operations, prioritize installed skills; if MCP
  is required, check available MCP tools and prefer `firecrawl`, then `exa`; if MCP is
  unavailable, fall back to WebFetch/WebSearch.
- **MCP parameters and output control**: For tools that can return overly large payloads,
  avoid requesting "full raw text" fields that bloat responses; extract in segments, list
  directories first, then drill down.
- **Image search**: If MCP supports image search/description, enable it unless the user
  explicitly requests "text only," and present image clues alongside textual evidence.

## Claude Code non-interactive mode reference

### Basic usage

```bash
# Basic non-interactive invocation
claude -p "Your prompt here"

# Specify allowed tools (no manual confirmation)
claude -p "Your prompt" --allowedTools "Read,Write,Edit,Bash"

# JSON output format (for script parsing)
claude -p "Your prompt" --output-format json

# Streaming JSON output
claude -p "Your prompt" --output-format stream-json

# Continue previous conversation
claude -p "Follow up question" --continue

# Continue specified session
claude -p "Follow up" --resume <session_id>
```

### Child process scheduling template

```bash
#!/bin/bash
# Child process scheduling example

prompt_file="$1"
output_file="$2"
log_file="$3"

# Read prompt and execute
timeout 600 claude -p "$(cat "$prompt_file")" \
    --allowedTools "Read,Write,Edit,Bash,Glob,Grep,WebFetch,WebSearch,mcp__firecrawl__firecrawl_scrape,mcp__firecrawl__firecrawl_search,mcp__firecrawl__firecrawl_map" \
    --output-format json \
    2>&1 | tee "$log_file" > "$output_file"

exit_code=${PIPESTATUS[0]}
echo "Exit code: $exit_code" >> "$log_file"
```

### Parallel execution example

```bash
#!/bin/bash
# Execute multiple child tasks in parallel

max_parallel=8
research_dir=".research/$name"

# Use GNU Parallel (recommended)
cat "$research_dir/tasks.txt" | parallel -j $max_parallel \
    "timeout 600 claude -p \"\$(cat $research_dir/prompts/{}.md)\" \
    --allowedTools 'Read,Write,Edit,Bash,WebFetch,WebSearch' \
    --output-format json > $research_dir/child_outputs/{}.json 2>&1"

# Or use background tasks
for task_id in $(cat "$research_dir/task_ids.txt"); do
    (
        timeout 600 claude -p "$(cat "$research_dir/prompts/$task_id.md")" \
            --allowedTools "Read,Write,Edit,Bash,WebFetch,WebSearch" \
            --output-format json \
            > "$research_dir/child_outputs/$task_id.json" 2>&1
    ) &

    # Control parallelism
    while [ $(jobs -r | wc -l) -ge $max_parallel ]; do
        sleep 1
    done
done

wait  # Wait for all background tasks
```

## General experience and best practices

- **Validate environment assumptions first**: Before writing the scheduler, use
  `realpath`/`test -d` to confirm key paths (e.g., `venv`, resource directories) exist; if
  needed, derive repo root via `dirname "$0"` and pass it in, avoiding hardcoding.
- **Make extraction logic configurable**: Do not assume pages share the same DOM; parsing
  scripts should provide configurable selectors/boundary conditions/readability parsers so
  cross-site reuse only needs config changes.
- **Validate small scale before parallelizing**: Before full parallelization, run 1-2
  sub-goals serially to validate agent configuration, skills/MCP toolchain, and output
  paths; only increase concurrency once stable, to avoid errors you cannot see after
  takeoff.
- **Layered logs for traceability**: Write `.research/<name>/dispatcher.log` for the
  scheduler; each child task writes `.research/<name>/logs/<id>.log`; on failure, `tail`
  the relevant log to locate MCP/call details.
- **Failure isolation and retries**: When parallel runs fail, record failure IDs and logs
  first, then retry individual failed tasks; maintain a `failed_ids` list and provide
  consolidated follow-up suggestions at the end.
- **Avoid duplicate fetching**: Before retrying, check whether
  `.research/<name>/child_outputs/<id>.md` already exists and is valid; if so, skip to
  reduce quota usage and duplicate access.
- **Final review and polishing**: Before delivery, review the aggregated and polished
  drafts to ensure language requirements are met, and verify citations/data points against
  source files; during polishing, keep key facts and quantitative data so the output
  provides insight rather than a pile of facts.
- **Inline citations**: Present sources inline with Markdown links after each point
  (e.g., `[source](https://example.com)`), rather than collecting them at the end, to enable
  quick verification.
- **Coverage validation scripts**: After batch generation, use lightweight scripts to count
  missing items, empty fields, or tag counts, ensuring issues are discovered and fixed
  before reporting.
- **Boundary constraints for child processes**: Explicitly bound child prompts to allowed
  access scopes (specific URLs/directories) and tools to reduce out-of-bounds and duplicate
  fetching risk, keeping the workflow safe and controllable across sites.

## Thinking and writing guidance

Think before acting: aim for deep, independent insights that exceed expectations (but do
not mention "surprise" in the answer); infer why the user is asking, what assumptions are
behind it, and whether there is a more fundamental way to ask; define the success criteria
your answer must meet, then organize content around those criteria.

Stay collaborative: your goal is not to mechanically execute instructions or force a
certain answer when information is insufficient; it is to work with the user to converge
on better questions and more reliable conclusions.

Writing style requirements:

- Do not overuse bullet points; keep them at the top level when possible; use natural
  language paragraphs where you can.
- Do not use quotation marks unless directly quoting.
- Maintain a friendly, clear, and rationally restrained tone.

When executing this skill, output clear decision and progress logs at each step.

## Pre-delivery checklist

Before submitting the final report, verify the checklist below:

### Directory structure checks
- [ ] `.research/<name>/` directory created
- [ ] `logs/dispatcher.log` contains full execution records, not written after the fact
- [ ] `raw/` directory contains raw search/scrape results
- [ ] When sub-goal count >=3, `prompts/` and `child_outputs/` exist and have content

### Process compliance checks
- [ ] Real samples were shown during scoping, not just experience-based guesses
- [ ] Execution starts only after explicit user confirmation unless they said "execute directly"
- [ ] `claude -p` child processes were started when sub-goal count >=3
- [ ] Logs were recorded in real time, not written afterward

### Report quality checks
- [ ] Report was produced via sectioned, multi-round integration, not a one-pass output
- [ ] Each key conclusion has traceable citations
- [ ] Citation links were actually visited, not inferred from search results
- [ ] Report is a standalone file and was not pasted fully in chat

### Quick failure checks
If any of the following occur, explicitly state them in the report:
- [ ] Some sub-tasks failed/timed out: record failure IDs and reasons
- [ ] Data sources limited/inaccessible: record alternative attempts
- [ ] Information incomplete: mark items to confirm and follow-up recommendations
