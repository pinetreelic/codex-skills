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

## Route work deliberately

Handle only short judgments and simple read-only lookups in the strategy room. Reuse or automatically create a separate Codex execution room for multi-step research, tool work, file, code, or document changes, tests or builds, external work, and anything that would block the strategy conversation.

A user's request to operate a strategy room is standing authority to inspect, reuse or create, name, pin, and reorder the execution rooms needed for that strategy without separate confirmation. This authority covers room organization only; it does not authorize external changes, sending, deployment, deletion, or any other action beyond the user's existing permission.

Before creating an execution room, inspect existing tasks for a related room in the same project. Reuse one only when the new work genuinely continues the same kind of work with the same purpose, authority, and source scope. Create a new room when any of those differ.

Name rooms `[프로젝트약칭실행] 작업명` by default. Use `[공통실행] 작업명` for genuinely shared work. Pin active rooms when possible. In a reorderable pinned list, use drag ordering to keep each strategy room immediately followed by its active execution rooms; do not interleave another project's rooms. Place each newly pinned execution room inside its project's existing block.

After creating, pinning, reordering, or ending a room, re-read current task or sidebar state to confirm the change. After dispatch, do not wait at length, duplicate the work, or continue executing it in the strategy room; return immediately to a conversation-ready state.

## Dispatch with an execution contract

Give an execution room only the context it needs. Include:

- originating strategy room name and thread ID
- objective and completion conditions
- inputs and their latest-known or last-verified state
- allowed and prohibited scope
- conditions that require stopping

Never mix in another project's context.

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

An execution room reports to its originating strategy room only when it completes, is actually blocked, or needs a user decision. Ordinary progress and unchanged checks must not interrupt the strategy conversation. On `결정 대기`, the strategy room obtains the decision and resumes the same room only when purpose, authority, and source scope remain unchanged. On `검토 대기`, review the result and either resume it with a bounded follow-up or mark it `종료`. After user confirmation, suggest unpinning or archiving; do not assume confirmation.

Use `결과 / 검증 / 다음 결정` as the default report shape, omitting sections that add no value. Automated checks report only meaningful changes and do not repeat resolved items.

If the project has an official task system, record only meaningful outcomes and follow-up work. Do not add implementation minutiae.
