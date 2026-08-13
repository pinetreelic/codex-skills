#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf '%s\n' \
    'Usage: run_wrap.sh [--mode quick|handoff|audit] [--out-base PATH]' \
    '' \
    'quick    Print closeout guidance without creating files.' \
    'handoff  Create one canonical wrap-summary.md (default).' \
    'audit    Create wrap-summary.md plus a redacted evidence.md.'
}

MODE="handoff"
OUT_BASE="artifacts/wrap"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --mode)
      [[ $# -ge 2 ]] || { printf 'Missing value for --mode\n' >&2; exit 2; }
      MODE="$2"
      shift 2
      ;;
    --out-base)
      [[ $# -ge 2 ]] || { printf 'Missing value for --out-base\n' >&2; exit 2; }
      OUT_BASE="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown argument: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

case "$MODE" in
  quick|handoff|audit) ;;
  *)
    printf 'Invalid mode: %s\n' "$MODE" >&2
    exit 2
    ;;
esac

if [[ "$MODE" == "quick" ]]; then
  printf '%s\n' \
    '[session-wrap] quick mode creates no files.' \
    '[session-wrap] Report verified outcomes, remaining owners, user action, mutation state, one recommendation, and the next-session first task in chat.'
  exit 0
fi

START_DIR="$(pwd -P)"
IN_GIT=0
ROOT_DIR="$START_DIR"

if ROOT_CANDIDATE="$(git -C "$START_DIR" rev-parse --show-toplevel 2>/dev/null)"; then
  ROOT_DIR="$(cd "$ROOT_CANDIDATE" && pwd -P)"
  IN_GIT=1
fi

case "$OUT_BASE" in
  /*) OUT_ROOT="$OUT_BASE" ;;
  *) OUT_ROOT="$ROOT_DIR/${OUT_BASE#./}" ;;
esac

STAMP="$(date +%Y%m%d-%H%M%S)"
OUT_DIR="${OUT_ROOT%/}/$STAMP"
SUMMARY_FILE="$OUT_DIR/wrap-summary.md"
EVIDENCE_FILE="$OUT_DIR/evidence.md"
WORKSPACE_NAME="$(basename "$ROOT_DIR")"

mkdir -p "$OUT_DIR"

BRANCH="not-applicable"
HEAD_SHA="not-applicable"
UPSTREAM="not-applicable"
DIRTY_COUNT="0"
RAW_STATUS=""

if [[ "$IN_GIT" -eq 1 ]]; then
  BRANCH="$(git -C "$ROOT_DIR" symbolic-ref --quiet --short HEAD 2>/dev/null || printf 'detached')"
  HEAD_SHA="$(git -C "$ROOT_DIR" rev-parse --short=12 HEAD 2>/dev/null || printf 'unborn')"
  UPSTREAM="$(git -C "$ROOT_DIR" rev-parse --abbrev-ref '@{upstream}' 2>/dev/null || printf 'none')"
  RAW_STATUS="$(git -C "$ROOT_DIR" status --porcelain=v1 -uall 2>/dev/null || true)"
  if [[ -n "$RAW_STATUS" ]]; then
    DIRTY_COUNT="$(printf '%s\n' "$RAW_STATUS" | awk 'END { print NR + 0 }')"
  fi
fi

cat > "$SUMMARY_FILE" <<EOF
# Session wrap: $WORKSPACE_NAME

- generated_at: $(date -Iseconds)
- mode: $MODE
- closeout_status: <complete | partial | blocked>

## 완료·검증

- [done] <outcome> — evidence: <test, commit, deployment, readback, or file>

## 남은 일

- <[agent] | [user] | [external] | [optional]> owner: <owner> — <concrete action>; dependency: <dependency or none>

## 사용자가 지금 해야 할 일

<one concise action, or "없음">

## 작업 상태

- artifact: created
- staged: no
- committed: no
- pushed: no
- deployed: not applicable

## 추천

<one recommendation, including "지금은 종료" when nothing is required>

## 다음 세션의 첫 작업

<one concrete first action>
EOF

if [[ "$MODE" == "audit" ]]; then
  {
    printf '# Session wrap evidence\n\n'
    printf '%s\n' \
      "- generated_at: $(date -Iseconds)" \
      "- workspace: $WORKSPACE_NAME" \
      "- analysis_method: pending-multi-agent" \
      "- git_repo: $([[ "$IN_GIT" -eq 1 ]] && printf 'yes' || printf 'no')" \
      "- branch: $BRANCH" \
      "- head: $HEAD_SHA" \
      "- upstream: $UPSTREAM" \
      "- pre_artifact_dirty_entry_count: $DIRTY_COUNT"

    if [[ "$IN_GIT" -eq 1 ]]; then
      printf '\n## Redacted status\n\n```text\n'
      printf '%s\n' "$RAW_STATUS" | awk '
        function sensitive(path, lowered) {
          lowered = tolower(path)
          return lowered ~ /(^|\/|\\)(\.env([^\/\\]*)?|credentials?([^\/\\]*)?|secrets?([^\/\\]*)?|tokens?([^\/\\]*)?|auth\.json|id_rsa([^\/\\]*)?|[^\/\\]*\.(pem|p12|pfx|key))($|[[:space:]]+->[[:space:]]+|\/|\\)/
        }
        {
          state = substr($0, 1, 3)
          path = substr($0, 4)
          if (sensitive(path)) {
            print state "[redacted-sensitive-path]"
          } else {
            print $0
          }
        }
      '
      printf '```\n\n## Recent commits\n\n```text\n'
      git -C "$ROOT_DIR" log --oneline -n 10 2>/dev/null || true
      printf '```\n'
    fi

    printf '\n## Audit pipeline\n\n'
    printf '%s\n' \
      '- phase_1_independent_analysis: pending' \
      '- phase_2_duplicate_validation: pending' \
      '- agents_must_be_read_only: yes' \
      '- root_only_artifact_writes: yes'

    printf '\n## Phase 1 findings\n\n'
    printf '%s\n' \
      '### Documentation findings' \
      '<replace with doc-updater output>' \
      '' \
      '### Automation findings' \
      '<replace with automation-scout output>' \
      '' \
      '### Learning findings' \
      '<replace with learning-extractor output>' \
      '' \
      '### Follow-up findings' \
      '<replace with followup-suggester output>'

    printf '\n## Phase 2 validation\n\n'
    printf '%s\n' \
      '<replace with duplicate-checker verdicts and search scope>' \
      '' \
      '### Validation gaps' \
      '<replace with unverified claims or none>'

    printf '\n## Evidence still required\n\n'
    printf '%s\n' \
      '- [ ] Tests/builds relevant to the changed scope' \
      '- [ ] Commit, PR, push, and merge state kept distinct' \
      '- [ ] Deployment identity and live verification when applicable' \
      '- [ ] External or physical-device checks kept explicitly pending'
  } > "$EVIDENCE_FILE"
fi

printf '[session-wrap] mode=%s\n' "$MODE"
printf '[session-wrap] summary=%s\n' "$SUMMARY_FILE"
if [[ "$MODE" == "audit" ]]; then
  printf '[session-wrap] evidence=%s\n' "$EVIDENCE_FILE"
fi
