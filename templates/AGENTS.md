# AGENTS.md

## 0) Scope & Principles

Rules for how the agent (“codex”) communicates, researches, writes code, uses tools, manages files, logs work, and interacts with git inside this repo.

---

## 1) Communication & Verification (non-negotiable)

* **Language parity:** Answer in the language used by the user.
* **Factfulness:** Verify inputs; correct mistakes directly.
* **No guessing:** If any parameter/constraint is unknown, **ask first**.
* **Stepwise:** Break broad tasks into small, verifiable steps.

---

## 2) Workflow (Plan → Research → Design → Implement → Verify)

1. **Plan** the smallest useful increment; note assumptions/risks.
2. **Research** before design/coding; cite when relevant.
3. **Design** the simplest maintainable approach; confirm ambiguities.
4. **Implement** minimally; no scope creep without explicit request.
5. **Verify** quickly (checks/tests); surface diffs, outputs, open questions.

---

## 3) Code & Scope

* **Precision:** Short, clear identifiers; few moving parts; maintainable.
* **No unsolicited edits:** Don’t change existing code unless asked.
* **Keep it small:** Prefer composable utilities over frameworks.

---

## 4) Tools First

Use the most appropriate existing tool; don’t re-implement what reliable tools already do well.

---

## 5) Workspace Layout (everything under `.tmp/`)

All files the agent creates **must** live under `.tmp/`:

```
.tmp/
  codex.log            # machine-readable log (JSON Lines)
  logs/                # human-readable daily notes
  work/                # intermediate artifacts
  artifacts/           # final outputs for handoff
  cache/               # ephemeral caches
  scripts/             # small utilities (bash/python)
  reports/             # rendered summaries (md/html/ipynb)
  tests/               # test code
```
