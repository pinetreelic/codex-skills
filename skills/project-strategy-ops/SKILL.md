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

Set the project abbreviation, official task system, and authority policy from the current project. Do not carry assumptions or context across projects.

## Name strategy rooms clearly

When first creating or naming a strategy room, prefix its title with exactly one project-relevant emoji and a space so it is visually distinct from ordinary rooms. Prefer an emoji the user already associates with that project; otherwise choose one recognizable symbol that fits the project's identity or domain. Preserve an existing user-chosen emoji, and do not stack or replace it unless asked. Examples of the intended pattern are `🚀 GetThis 성장 전략실`, `🇺🇸 English Class 전략실`, and `🐣 BuildKidz 전략실`. Keep execution-room titles in their existing bracketed format without this emoji prefix.

## Route work deliberately

Handle only short judgments and simple read-only lookups in the strategy room. Reuse or automatically create a separate Codex execution room for multi-step research, tool work, file, code, or document changes, tests or builds, external work, and anything that would block the strategy conversation.

A user's request to operate a strategy room is standing authority to inspect, reuse or create, name, pin, and reorder the execution rooms needed for that strategy without separate confirmation. This authority covers room organization only; it does not authorize external changes, sending, deployment, deletion, or any other action beyond the user's existing permission.

Before creating an execution room, inspect existing tasks for a related room in the same project. Reuse one only when the new work genuinely continues the same kind of work with the same purpose, authority, and source scope. Create a new room when any of those differ.

Name rooms `[프로젝트약칭실행] 작업명` by default. Use `[공통실행] 작업명` for genuinely shared work.

Whenever creating an execution room or reusing one by making it active, complete this UI sequence before dispatch:

1. Create the room, or select the related existing room for reuse.
2. Pin that execution room.
3. Move it in the pinned list into the originating strategy room's block.

The strategy room must be immediately followed by all of its active execution rooms as one contiguous block. When that block already contains active rooms, place the newly activated room after them unless the user specifies another order. Never interleave a different project's strategy or execution room. If pinning or reordering is unavailable, report that as an organization blocker instead of silently skipping the step.

After creating or selecting, pinning, and moving the room, re-read the task and sidebar state rather than relying only on mutation responses. Confirm that the intended room is active, pinned, inside the correct strategy block, and separated from every other project block. Example: activating `A실행2` changes `[A전략, A실행1, B전략, B실행1]` to `[A전략, A실행1, A실행2, B전략, B실행1]`, not `[A전략, A실행1, B전략, A실행2, B실행1]`.

After dispatch, do not wait at length, duplicate the work, or continue executing it in the strategy room; return immediately to a conversation-ready state.

## Track dispatched work in an optional task system

Before dispatch, check for `~/.codex/project-strategy-ops/task-sync.md`. When it exists, read it as user-local operating policy rather than project context. Do nothing when the policy is absent or disabled. Apply only the provider, strategy-room scope, authority, triggers, and failure behavior that the policy states.

Sync only after a real execution thread ID exists and the initial or resumed instruction was delivered successfully. Merely opening, selecting, or reading an execution room does not count. Keep a temporary client-thread-only room at `준비 중` without a task. Treat the sync as short dispatch bookkeeping in the strategy room; do not create another execution room for it. A task-system failure must not block the dispatched work unless the local policy explicitly requires that, and never report a task as created without authoritative readback.

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

For coding work in a Git repository, create or verify a separate worktree and named `codex/...` branch before the first edit; do not begin editing on a detached HEAD. Keep one purpose per execution room, branch, and worktree. Split any additional request whose purpose, authority, or source scope differs into a separate room, branch, and worktree. Include the branch, worktree, base commit, and scoped change in its contract and concise handoff or report.

## Preserve authority

Choose the narrowest suitable authority for each room:

- read only
- draft only
- external changes after approval
- execution within an explicitly named scope

Do not expand existing authority. Sending messages, changing documents or calendars, or making external commitments requires the authority already granted for that action.

## Keep reports quiet and useful

Use only these execution states:

- `실행 중`: dispatched and working
- `결정 대기`: actually blocked or awaiting a user decision
- `검토 대기`: completed output awaits strategy-room or user review
- `종료`: confirmed complete with no remaining work

An execution room reports to its originating strategy room only when it completes, is actually blocked, or needs a user decision. Ordinary progress and unchanged checks must not interrupt the strategy conversation. On `결정 대기`, the strategy room obtains the decision and resumes the same room only when purpose, authority, and source scope remain unchanged; when resumed, verify that it remains pinned in the correct contiguous block. On `검토 대기`, review the result and either resume it with a bounded follow-up or mark it `종료`. After user confirmation, suggest unpinning or archiving; do not assume confirmation. When an ended room is unpinned or archived, re-read the sidebar and confirm that the strategy room's remaining active execution rooms still form one contiguous block.

Use `결과 / 검증 / 다음 결정` as the default report shape, omitting sections that add no value. Automated checks report only meaningful changes and do not repeat resolved items.

If the project has an official task system, record only meaningful outcomes and follow-up work. Do not add implementation minutiae.
