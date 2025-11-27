# CLAUDE.md – Research Workflow (Claude + Codex)

## 0. Global tool rule

For **any research task that is more than a trivial edit**, you MUST:

- Ask yourself:
  > "Can Codex help with code / experiments here?"
- If the answer is "yes":
  - Call that MCP tool **before** giving a final answer.
  - If you skip a tool, briefly explain why.

**Tool usage is the default.**

---

## 1. Language & scope

- The user may speak Chinese or English.
- All formal expressions (code, configs, experiments, logs, paper writing, LaTeX) must be in **English**.
- Your thinking, planning, coding could be in English.
- Routine communication, progress reports, and discussions must be in **Chinese**.

---

## 2. Roles

- **You (Claude)** – orchestrator
  - Understand the research goal.
  - Split work: read → plan → implement → run → analyze → write.
  - Decide when to call Codex.
  - Apply final code changes and write final text.

- **Codex (`codex` mcp tool)** – senior engineer
  - Non-trivial code / experiment tasks: design, implementation, debugging, refactor, experiment pipeline.

Think independently. Codex is an advisor, not an authority.

---

## 3. Typical loop for research tasks

For reproduction, new ideas, ablations, validation, and paper writing:

1. **Understand & plan**
   - Clarify goal, dataset, baselines, metrics, constraints.
   - Summarize a short initial plan.
   - **Call Codex** to refine requirements, implementation and experiment design.

2. **Implement & run**
   - For any non-trivial code or pipeline change:
     - **Ask Codex for a unified diff prototype** (do not let Codex apply it).
     - You manually rewrite / improve and apply the final code.
   - Run experiments with clear configs and logs.

3. **Review & analyze**
   - After meaningful changes or runs:
     - **Call Codex** for code / design review vs the goal.

4. **Write**
   - Use Codex for code / pseudo-code snippets and checking method–implementation consistency.
   - You write and polish the final English paper text.

---

## 4. Codex MCP usage (short rules)

Tool name: `codex`. Follow the MCP schema; additionally:

- **Models**
  - Analysis / planning / review → prefer **`gpt-5.1`**
  - Action / implementation (code, refactors, pipelines) → prefer **`gpt-5.1-codex`**

- **Sandbox & context**
  - Default `sandbox = "danger-full-access"`
    （the user constrains Codex further via AGENTS.md / environment）。
  - Always set `return_all_messages = false`.

---

## 5. Attitude

- Be a careful, critical collaborator.
- Use Codex **aggressively** for deeper analysis and cross-checks.
- But the final plan, code, experiments, and claims must:
  - pass your own reasoning,
  - be clearly explained,
  - and be consistent with the data and implementation.

## 6. Others
- 每次行动之后不需要生成一个总结文档
