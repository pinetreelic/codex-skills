---
name: session-wrap
description: Close a coding or work session with evidence-backed status, explicit ownership, reconciled follow-ups, and a decisive next step. Use for explicit "session wrap" or "$session-wrap" requests, durable handoffs, deployment or audit closeouts, and generic Korean or English requests such as "마무리", "정리", "wrap", or "what do I need to check?"; use quick chat, a single handoff, or a deep multi-agent audit according to scope and risk.
---

# Session Wrap

Produce a decisive closeout, not a menu of possible closeouts. Preserve verified facts, expose unfinished state, and minimize files and user turns.

## Choose a mode

- `quick`: Use for generic closing questions, status reports, or "what do I need to check?" Do not create files. This is the default when the user did not request an artifact.
- `handoff`: Use for an explicit `$session-wrap`, a requested wrap document, or work another session/person must continue. Create one canonical `wrap-summary.md`.
- `audit`: Use a real two-phase multi-agent analysis when the user requests evidence or the session involved production deployment/rollback, security or permissions, data migration/mutation, multiple repositories/worktrees/services, unresolved external or physical-device checks, or a mismatch between implementation and live verification. Create `wrap-summary.md` plus `evidence.md`.

Do not turn a read-only closing question into workspace writes. Explicit skill invocation or a requested handoff document authorizes the mode's wrap artifact, but not staging, committing, pushing, deploying, messaging, or creating external tasks.

Apply mode precedence:

1. Explicit `quick` or "간단히" → `quick`.
2. Explicit `audit`, "증거까지", or "감사 모드" → `audit`.
3. Explicit `$session-wrap`/"세션랩" plus any audit risk trigger → `audit`.
4. Explicit `$session-wrap`/"세션랩" without an audit trigger → `handoff`.
5. Generic "마무리"/"더 할 일?" without artifact authorization → `quick`, even after complex work. Mention that a deep audit is warranted when applicable, but do not create files without authorization.

## Collect evidence

1. Re-read the user's requested scope and corrections.
2. Treat session notes and prior summaries as leads, not proof. Directly verify cheap local claims such as branch, HEAD, status, changed files, and artifact existence. If a note conflicts with current state, report the verified state and the conflict.
3. Reverify drift-prone deployment, service, account, or external state before calling it current. Do not rerun an expensive test suite only to wrap the session when a trustworthy result from this session exists; label it as a prior run rather than a fresh run.
4. Separate:
   - completed and verified;
   - completed but not live-verified;
   - blocked or externally waiting;
   - optional ideas.
5. For `handoff` or `audit`, run from anywhere inside the workspace:

```bash
"${CODEX_HOME:-$HOME/.codex}/skills/session-wrap/scripts/run_wrap.sh" --mode handoff
```

Use `--mode audit` only when its deeper evidence and independent analysis are justified. The script prints the generated file paths.

6. If a previous wrap exists, reconcile each open item as `resolved`, `carried forward`, or `dropped`. Do not reintroduce it as a new suggestion.

## Analyze quick and handoff modes

Use these lenses while drafting; do not create one file per lens.

- Documentation: durable decisions or runbook/context changes actually justified by the session.
- Automation: steps repeated at least twice or likely to recur, with expected time/risk reduction and implementation difficulty.
- Learning: what worked, failed, and newly constrained future work.
- Follow-up: next actions with owner, dependency, and urgency.

Do not seed generic suggestions such as KPI reports, previews, aliases, or CI unless session evidence supports them.

## Run the audit pipeline

Read `references/audit-agents.md` completely before an audit. Use actual independent agents; do not describe a single-agent pass as multi-agent analysis.

### Phase 1: four independent analyses

1. Build one redacted input packet from the user's scope, verified session facts, `evidence.md`, relevant changed files, existing documentation/automation indexes, and the latest prior wrap when one exists.
2. Start these read-only agents with `fork_turns="none"`:
   - `doc-updater`
   - `automation-scout`
   - `learning-extractor`
   - `followup-suggester`
3. Start all four concurrently when capacity permits. With four total collaboration slots including the root agent, start three immediately and start the fourth as soon as the first slot becomes free; overlap it with any remaining agents when possible. The root agent orchestrates and verifies state but does not substitute for a specialist role.
4. Give every role the same evidence packet and only its role brief. Do not give agents the expected conclusion or another role's output.
5. Wait for all four agents. Condense their outputs into the Phase 1 sections of `evidence.md`; do not create per-agent files.

If subagent tools are unavailable, mark `analysis_method: single-agent-fallback` in `evidence.md` and disclose that the multi-agent audit contract was not met. Never silently simulate independent agents.

### Phase 2: independent validation

1. After Phase 1 is recorded, start a new read-only `duplicate-checker` agent with `fork_turns="none"`.
2. Tell it to read `evidence.md`, relevant `AGENTS.md`/`CLAUDE.md`/`context.md`/README/runbooks, existing skills or automations, the latest prior wrap, and current Git state.
3. Require `add`, `merge`, `skip`, or `conflict` for every documentation and automation proposal. Require it to flag unsupported completion claims, duplicate follow-ups, and conflicts between notes and verified state.
4. Record its search scope and verdicts in the Phase 2 section of `evidence.md`.
5. Integrate only approved or merged items into `wrap-summary.md`. Put conflicts and unresolved validation gaps before optional ideas.

Agents must remain read-only. Only the root agent may update the two audit artifacts. Audit authorization does not authorize documentation changes, automation creation, commit, push, deployment, or external messages.

## Write the canonical summary

For `handoff` and `audit`, replace all placeholders in `wrap-summary.md`. Follow `references/output-template.md`.

Use these action labels:

- `[done]`: completed with evidence.
- `[agent]`: agent can do it within already authorized scope.
- `[user]`: requires the user's judgment, credentials, physical action, or new authorization.
- `[external]`: waiting on another person or external state.
- `[optional]`: useful but not required for completion.

Every remaining item must name its owner and concrete next action. Add an absolute date only when a real deadline exists; otherwise state the dependency instead of inventing a date.

Record mutation state explicitly:

```text
artifact: created | not created
staged: yes | no | not applicable
committed: yes | no | not applicable
pushed: yes | no | not applicable
deployed: yes | no | not applicable
```

Never present a suggested commit message as completed work. Show a commit message only when the user asks for one or when reporting an actual commit.

## Respond decisively

Return the result in this order:

1. `종료 상태`: complete, partial, or blocked.
2. `완료·검증`: the smallest useful list.
3. `남은 일`: required items before optional items, each with a label and owner.
4. `사용자가 지금 해야 할 일`: say `없음` when none.
5. `기록 상태`: artifact link and mutation state when a file exists.
6. `추천`: one recommended next action, including `지금은 종료` when appropriate.
7. `다음 세션의 첫 작업`: one concrete start point.

Do not end with a three-option menu. Ask a question only when a consequential choice is truly unresolved. If the next safe action is already authorized, perform it in the same turn and report the resulting state.

## Output contract

- `quick`: chat response only; zero files.
- `handoff`: `artifacts/wrap/<timestamp>/wrap-summary.md` only.
- `audit`: `artifacts/wrap/<timestamp>/wrap-summary.md` and `evidence.md` only.

Commit only the canonical summary unless the user explicitly wants audit evidence versioned. Keep unrelated user changes untouched and stage only explicitly approved wrap files.

## Resources

- Generator: `scripts/run_wrap.sh`
- Regression test: `scripts/test_run_wrap.sh`
- Output guide: `references/output-template.md`
- Audit role contracts: `references/audit-agents.md`
- Upstream license and attribution: `LICENSE`
