---
name: project-strategy-ops
description: Operate an explicitly designated or previously confirmed 프로젝트 전략실 or 성장 전략실 while automatically coordinating separate 실행실 tasks. Do not use merely because a chat title or request mentions 전략실 or 실행실, or for standalone implementation, skill maintenance, or status lookup outside a strategy room.
---

# Project Strategy Ops

Keep the strategy room available for continued conversation with the user. It owns project context, priorities, and judgment; execution rooms own bounded work.

Activate this workflow only when the user explicitly designates the current chat as a strategy room or it was already confirmed as one. Do not infer that status from the chat title, folder, project, or a request to create, review, or update this skill.

## Keep a compact project brief

Maintain a one-screen brief with only:

- goal
- current state
- confirmed decisions
- active execution rooms and status
- blockers
- next priority

Set one stable project abbreviation, the official task system, and the authority policy from the current project. Reuse that abbreviation in every execution-room title for the project. Do not carry assumptions or context across projects.

## Name strategy rooms clearly

When first creating or naming a strategy room, prefix its title with exactly one project-relevant emoji and a space so it is visually distinct from ordinary rooms. Prefer an emoji the user already associates with that project; otherwise choose one recognizable symbol that fits the project's identity or domain. Preserve an existing user-chosen emoji, and do not stack or replace it unless asked. Examples of the intended pattern are `🚀 GetThis 성장 전략실`, `🇺🇸 English Class 전략실`, and `🐣 BuildKidz 전략실`. Keep execution-room titles in their existing bracketed format without this emoji prefix.

A request to create or designate the current chat as a strategy room is standing authority to apply its strategy-room title and pin it. On first setup, treat the current chat as an organized strategy room only after confirming that it is a user-visible top-level Codex thread with a real thread ID, applying the intended emoji title, pinning it, and re-reading the sidebar to verify the title and pinned placement. If any required capability or readback is unavailable, record `방 관리 기능 미노출` under blockers and report the setup as incomplete rather than organized.

## Route work deliberately

Handle only short judgments and simple read-only lookups in the strategy room. Reuse or automatically create a separate Codex execution room for multi-step research, tool work, file, code, or document changes, tests or builds, external work, and anything that would block the strategy conversation.

Before strategy-room setup or execution-room activation, check once for the capabilities needed by the current operation: existing-room search, real room creation or selection, title update, pinning, pinned-list reordering, instruction delivery, and task/sidebar readback with real thread IDs. Inspect names and schemas narrowly; do not dump a full tool catalog. If a required capability is missing, record the exact capability under blockers and stop the room operation. Do not substitute a collaboration subagent, continue the substantive work in the strategy room, or fall back to coordinate-based UI automation.

A Codex execution room is a user-visible top-level Codex thread with a real thread ID. A `spawn_agent` or other collaboration subagent is an internal worker, not an execution room. Never use a subagent ID, result, or completion as evidence that an execution room was created, reused, instructed, or made active.

A user's request to operate a strategy room is standing authority to inspect, reuse or create, name, pin, and reorder the execution rooms needed for that strategy without separate confirmation. This authority covers room organization only; it does not authorize external changes, sending, deployment, deletion, or any other action beyond the user's existing permission.

Before creating an execution room, inspect existing tasks and pending creation attempts for related work in the same project. Reuse a real room only when the new work genuinely continues the same kind of work with the same purpose, authority, and source scope. Create a new room when any of those differ, but never duplicate an unresolved pending creation.

Name rooms `[프로젝트약칭실행] 작업명` by default. Use `[공통실행] 작업명` for genuinely shared work.

Use `📋 통합 일정·할 일 운영실` as the canonical shared room for schedule and task management across all projects. Keep it independently pinned in the lower part of the pinned list rather than inside any strategy-room block, and reuse it instead of creating or reactivating project-specific schedule or task rooms. Track status per dispatched request. Each dispatch must still identify its originating strategy room and preserve that project's context, authority, and source scope.

For ordinary project-scoped execution rooms, whenever creating one or reusing one by making it active, complete this activation sequence before reporting it dispatched:

1. Create the room, or select the related existing room for reuse.
2. Confirm a real top-level thread ID and apply the intended bracketed title.
3. Pin that execution room.
4. Move it in the pinned list into the originating strategy room's block.
5. Deliver the initial or resumed execution instruction.
6. Re-read the task and sidebar state with message bodies included.

If execution-room creation returns only a temporary client thread ID, record one pending creation keyed by project, intended title, purpose, authority, and source scope, and treat it as `준비 중`, not as fully dispatched. A bounded wait or absence from the task list is not terminal failure. While that key is pending, do not retry creation, switch environments, or create another room for the same work. Resolve it through the official setup or status path when available. When a real thread ID appears, finish the activation sequence and confirm the placement through task and sidebar readback before reporting it active or organized. Retry creation only after terminal setup failure is confirmed and the failed placeholder is cancelled or otherwise accounted for. Prefer the official cancel or archive path; if no API identifies or removes the placeholder, report the exact UI-cleanup blocker and keep the key pending instead of creating a duplicate.

The strategy room must be immediately followed by all of its active execution rooms as one contiguous block. When that block already contains active rooms, place the newly activated room after them unless the user specifies another order. Never interleave a different project's strategy or execution room. If pinning or reordering is unavailable, report that as an organization blocker instead of silently skipping the step.

After creating or selecting, pinning, and moving the room, re-read the task and sidebar state rather than relying only on mutation responses. Confirm that the intended room is active, pinned, inside the correct strategy block, and separated from every other project block. Example: activating `A실행2` changes `[A전략, A실행1, B전략, B실행1]` to `[A전략, A실행1, A실행2, B전략, B실행1]`, not `[A전략, A실행1, B전략, A실행2, B실행1]`.

A navigation acknowledgement, screenshot, or coordinate-based click or drag is inconclusive and must not be used as authoritative proof of room identity, title, pinning, placement, or instruction delivery. If authoritative readback is unavailable, report the room operation as incomplete.

After dispatch and any configured task-system bookkeeping, do not wait at length, duplicate the work, or continue executing it in the strategy room; use the task wait mechanism for a bounded snapshot after the real thread ID is available, then return to a conversation-ready state rather than busy-polling setup.

## Track dispatched work in an optional task system

Before dispatch, check for `~/.codex/project-strategy-ops/task-sync.md`. When it exists, read it as user-local operating policy rather than project context. Do nothing when the policy is absent or disabled. Apply only the provider, strategy-room scope, authority, triggers, and failure behavior that the policy states.

Sync only after the activation sequence confirms a user-visible top-level execution room with a real thread ID, successful instruction delivery, the intended title, pinning, contiguous placement, and task/sidebar readback. Merely opening, selecting, navigating to, or reading a room does not count. Keep a temporary client-thread-only room at `준비 중` without a task. Treat the sync as short dispatch bookkeeping in the strategy room; do not create another execution room for it. A task-system failure must not block the dispatched work unless the local policy explicitly requires that, and never report a task as created without authoritative readback.

When the policy selects GetThis, read [references/getthis-task-sync.md](references/getthis-task-sync.md) and use the `getthis-tasks` skill. Do not duplicate its credential or API procedures here.

## Dispatch with an execution contract

Give an execution room only the context it needs. Include:

- originating strategy room name and thread ID
- objective and completion conditions
- inputs and their latest-known or last-verified state
- allowed and prohibited scope
- conditions that require stopping
- selected model, reasoning effort, and a short routing reason

Never mix in another project's context.

## Route execution-room models

The user's approval of this policy is standing authorization to specify a model and reasoning effort when creating future execution rooms. A model or effort explicitly requested for a specific room always wins. Otherwise:

- For ordinary execution work, omit `model` and `thinking` so the configured Codex default applies.
- For demanding multistep research or synthesis across papers, PDFs, code, apps, or other sources, use `gpt-6-astra` with `medium` reasoning.
- For the hardest cross-system work or material-risk work involving architecture, integrations, authentication, payments, secrets, RLS, destructive data changes, migrations, production releases, or security, use `gpt-6-astra` with `high` reasoning.

Do not choose `xhigh`, `max`, or `ultra` by default. If Astra is unavailable on the target host, use the strongest suitable available model and record the fallback. Do not recreate or restart an already-running room solely to change its model; apply this routing to newly created rooms.

Carry any explicit user approval into the contract as the authority basis. Do not ask for the same approval again unless the target, action, or scope changed.

Skill changes do not alter rooms that were already dispatched. When this operating contract changes, inspect active rooms and send each affected room only the changed completion or reporting conditions before relying on the new rule; preserve its scope and do not restart or duplicate its work.

For coding work in a Git repository, create or verify a separate worktree and named `codex/...` branch before the first edit; do not begin editing on a detached HEAD. Keep one purpose per execution room, branch, and worktree. Split any additional request whose purpose, authority, or source scope differs into a separate room, branch, and worktree. Include the branch, worktree, base commit, and scoped change in its contract and concise handoff or report.

## Preserve authority

Choose the narrowest suitable authority for each room:

- read only
- draft only
- external changes after approval
- execution within an explicitly named scope

Do not expand existing authority. Sending messages, changing documents or calendars, or making external commitments requires the authority already granted for that action.

For an external change, a successful action call is not completion. Verify the resulting state from the authoritative external source; for a send, verify the final permission or sharing state and the sent-item record, including sender, recipient, and provider message ID when available.

## Keep reports quiet and useful

Use only these execution states:

- `실행 중`: dispatched and working
- `결정 대기`: actually blocked or awaiting a user decision
- `검토 대기`: completed output awaits strategy-room or user review
- `종료`: confirmed complete with no remaining work

A completed Codex turn does not by itself mean the execution objective completed. Classify the state from the room's visible outcome and its completion conditions; a question or missing receipt remains `결정 대기` or `실행 중`.

An execution room reports to its originating strategy room only when it completes, is actually blocked, or needs a user decision. Make successful report delivery and strategy-room readback part of the execution completion conditions: a final answer left only inside the execution room is not a report, and the room must not enter `종료` until the intended report body is visible in the originating room. Ordinary progress and unchanged checks must not interrupt the strategy conversation. On `결정 대기`, the strategy room obtains the decision and resumes the same room only when purpose, authority, and source scope remain unchanged; when resumed, verify that it remains pinned in the correct contiguous block. On `검토 대기`, review the result and either resume it with a bounded follow-up or mark it `종료`. After user confirmation, suggest unpinning or archiving; do not assume confirmation. When an ended room is unpinned or archived, re-read the sidebar and confirm that the strategy room's remaining active execution rooms still form one contiguous block.

Treat an incoming execution-room report as an immediate side event, not as a replacement for unrelated strategy-room work already in progress. Preserve a compact resume marker for the active work: its name, current checkpoint, and next action. Display the report immediately as `📨 [실행 작업] 상태 — 핵심 결과`, assess it, and send any needed follow-up to that execution room. Unless the report requires a user decision or a priority change, immediately display `↩️ [기존 작업] 계속 — 현재 단계: ...` and continue the original work and its progress updates. If a decision must pause the original work, say so explicitly and retain the resume marker. Do not delay the report, create a separate report room, or silently make the reported task the active objective.

Use `결과 / 검증 / 다음 결정` as the default report shape, omitting sections that add no value. For an external change, `결과` and `검증` must be non-empty and include the authority basis plus authoritative readback. After reporting, re-read the originating strategy room with message outputs included and confirm that the intended body is visible. Metadata-only reads or empty omitted-item lists are inconclusive, not proof that a report body is empty. If the report is actually missing or empty, resend the full report once and verify it; if that still fails, report the delivery blocker without claiming success. Automated checks report only meaningful changes and do not repeat resolved items.

If the project has an official task system, record only meaningful outcomes and follow-up work. Do not add implementation minutiae.
