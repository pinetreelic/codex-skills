# Session Wrap Output Guide

Use this structure for the chat closeout and the canonical `wrap-summary.md`.

## Required structure

```markdown
# Session wrap: <scope>

- generated_at: <absolute timestamp>
- closeout_status: complete | partial | blocked

## 완료·검증

- [done] <outcome> — evidence: <test, commit, deployment, readback, or file>

## 남은 일

- [user] owner: user — <action>; dependency: <why only the user can do it>
- [external] owner: <person/system> — <action>; dependency: <external state>
- [optional] owner: agent — <automation or improvement>; impact: <time/risk>; difficulty: <low/medium/high>

## 사용자가 지금 해야 할 일

<one concise action, or "없음">

## 이전 랩업 조정

- resolved: <previous item and evidence>
- carried forward: <previous item and unchanged dependency>
- dropped: <previous item and reason>

## 작업 상태

- artifact: created | not created
- staged: yes | no | not applicable
- committed: yes | no | not applicable
- pushed: yes | no | not applicable
- deployed: yes | no | not applicable

## 추천

<one recommendation, including "지금은 종료" when nothing is required>

## 다음 세션의 첫 작업

<one concrete first action>
```

Omit `이전 랩업 조정` when there is no prior wrap. Omit optional items when none are justified.

## Quality rules

- Put required work before optional improvements.
- Say `사용자가 지금 해야 할 일: 없음` when true.
- Treat health, build, commit, push, deployment, and live verification as different states.
- Treat session notes as leads; verify cheap local state directly and disclose conflicts.
- Use evidence near the claim it supports.
- Never infer a deadline, owner, decision, or successful mutation.
- Never include secrets, credentials, raw prompts, sensitive file names, or private runtime paths.
- Keep the scope summary to three bullets or fewer.
- Prefer one canonical link over links to internal scratch files.
