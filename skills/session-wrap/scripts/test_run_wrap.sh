#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd -P)"
WRAP_SCRIPT="$SCRIPT_DIR/run_wrap.sh"
TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/session-wrap-test.XXXXXX")"

cleanup() {
  rm -rf "$TEST_ROOT"
}
trap cleanup EXIT

REPO_DIR="$TEST_ROOT/repo"
mkdir -p "$REPO_DIR/nested/work"
git -C "$REPO_DIR" init -q
git -C "$REPO_DIR" config user.email "session-wrap-test@example.invalid"
git -C "$REPO_DIR" config user.name "Session Wrap Test"
printf 'fixture\n' > "$REPO_DIR/tracked.txt"
git -C "$REPO_DIR" add tracked.txt
git -C "$REPO_DIR" commit -qm "init fixture"

QUICK_OUT="$TEST_ROOT/quick-output"
mkdir -p "$QUICK_OUT"
(
  cd "$REPO_DIR/nested/work"
  "$WRAP_SCRIPT" --mode quick --out-base "$QUICK_OUT"
)
if find "$QUICK_OUT" -mindepth 1 -print -quit | grep -q .; then
  printf 'quick mode unexpectedly created files\n' >&2
  exit 1
fi

HANDOFF_LOG="$TEST_ROOT/handoff.log"
(
  cd "$REPO_DIR/nested/work"
  "$WRAP_SCRIPT" --mode handoff --out-base test-wraps
) > "$HANDOFF_LOG"

SUMMARY_FILE="$(sed -n 's/^\[session-wrap\] summary=//p' "$HANDOFF_LOG")"
[[ -f "$SUMMARY_FILE" ]]
[[ "$(find "$(dirname "$SUMMARY_FILE")" -maxdepth 1 -type f | wc -l | tr -d ' ')" == "1" ]]
grep -q '^## 작업 상태$' "$SUMMARY_FILE"
grep -q '^## 사용자가 지금 해야 할 일$' "$SUMMARY_FILE"
if grep -Eqi 'weekly kpi|local preview|three selectable actions' "$SUMMARY_FILE"; then
  printf 'handoff summary contains generic seeded suggestions\n' >&2
  exit 1
fi

printf 'secret\n' > "$REPO_DIR/.env.production"
printf 'secret\n' > "$REPO_DIR/credentials.json"
printf 'safe\n' > "$REPO_DIR/notes.md"

AUDIT_LOG="$TEST_ROOT/audit.log"
(
  cd "$REPO_DIR/nested/work"
  "$WRAP_SCRIPT" --mode audit --out-base audit-wraps
) > "$AUDIT_LOG"

AUDIT_SUMMARY="$(sed -n 's/^\[session-wrap\] summary=//p' "$AUDIT_LOG")"
EVIDENCE_FILE="$(sed -n 's/^\[session-wrap\] evidence=//p' "$AUDIT_LOG")"
[[ -f "$AUDIT_SUMMARY" ]]
[[ -f "$EVIDENCE_FILE" ]]
[[ "$(find "$(dirname "$AUDIT_SUMMARY")" -maxdepth 1 -type f | wc -l | tr -d ' ')" == "2" ]]
grep -q 'analysis_method: pending-multi-agent' "$EVIDENCE_FILE"
grep -q 'pre_artifact_dirty_entry_count:' "$EVIDENCE_FILE"
grep -q '^### Documentation findings$' "$EVIDENCE_FILE"
grep -q '^### Automation findings$' "$EVIDENCE_FILE"
grep -q '^### Learning findings$' "$EVIDENCE_FILE"
grep -q '^### Follow-up findings$' "$EVIDENCE_FILE"
grep -q '^## Phase 2 validation$' "$EVIDENCE_FILE"
grep -q '\[redacted-sensitive-path\]' "$EVIDENCE_FILE"
grep -q 'notes.md' "$EVIDENCE_FILE"
if grep -Eq '\.env\.production|credentials\.json' "$EVIDENCE_FILE"; then
  printf 'audit evidence leaked a sensitive path\n' >&2
  exit 1
fi
if grep -Eq 'audit-wraps' "$EVIDENCE_FILE"; then
  printf 'audit evidence included its own generated artifacts\n' >&2
  exit 1
fi

if "$WRAP_SCRIPT" --mode invalid > /dev/null 2>&1; then
  printf 'invalid mode unexpectedly succeeded\n' >&2
  exit 1
fi

[[ -f "$SCRIPT_DIR/../references/audit-agents.md" ]]
[[ -f "$SCRIPT_DIR/../LICENSE" ]]

printf 'session-wrap regression tests passed\n'
