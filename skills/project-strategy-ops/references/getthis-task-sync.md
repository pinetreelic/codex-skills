# GetThis execution-task sync

Read this reference only when the user-local task-sync policy enables GetThis.

## Trigger and authority

- Apply the policy to exactly the strategy-room scope it names.
- Create a Task only after a new execution room receives its initial instruction or an existing room receives a new instruction that actually starts or resumes bounded work.
- Do not create on room inspection, status lookup, an unresolved temporary client thread ID, or a failed dispatch.
- Creation authority does not imply authority to update, complete, cancel, archive, or delete a Task.

## Identify and reuse Tasks

Build a searchable base marker from `codex-exec:`, the originating strategy thread ID, the real execution thread ID, and a whitespace-normalized objective truncated to 80 characters. Keep the marker within GetThis's 200-character query limit.

Before creation, run GetThis `doctor` once for the strategy-room session, then search all Task statuses for the base marker. Reuse an existing `todo` or `in_progress` Task. If more than one active match exists, do not create another; retain the newest exact match and surface the duplicate only when it affects the work. A terminal match does not prevent creating a Task for a genuinely new dispatch cycle.

For a new cycle, generate one idempotency key from the execution thread ID and dispatch timestamp, and preserve it for every retry of that create. Do not generate a second key after an ambiguous response; search by the base marker first.

## Create and verify

Use a concise human title such as `프로젝트약칭 · 작업명`. Put the strategy-room name, execution-room name, base marker, and dispatch timestamp in `notes`; do not add implementation minutiae.

Create one all-day Task for the current local date with `itemKind: task`, `category: do`, `timeSemantics: date_only`, `localDate: YYYY-MM-DD`, and `isAllDay: true`. Omit `timeZone` from date-only data. Use a batch create with `confirmationMode: auto` and the stable idempotency key.

After creation, query GetThis again and verify the returned Task ID, title, `status`, `localDate`, `isAllDay: true`, and `timeZone: null`. Record the Task ID beside the active execution room in the compact strategy brief. Never infer success from prose or the mutation response alone.

Retry once only for an ambiguous transient response, using the same idempotency key. For authentication, validation, or confirmed failures, do not retry. Follow the local failure policy and never substitute another task manager or a local ledger.
