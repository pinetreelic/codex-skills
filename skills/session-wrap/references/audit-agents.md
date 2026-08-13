# Audit Agent Contracts

Use only for `audit` mode. Pass the same redacted evidence packet to every Phase 1 role. Keep all roles read-only and require evidence near every claim.

## Shared rules

- Treat session notes and prior wraps as leads, not proof.
- Verify cheap local claims directly. Label an expensive test or external check as a prior run unless rerun now.
- Do not read or report secrets, credentials, raw prompts, personal data, or sensitive runtime paths.
- Do not change files, Git state, services, external systems, or task trackers.
- Return `none` with a reason when no justified finding exists. Do not invent work to fill a template.
- Keep required findings separate from optional improvements.

## Shared input packet

Provide:

```text
workspace: <absolute root>
user_scope: <requested closeout scope>
verified_state: <branch, HEAD, status, artifacts, current checks>
session_evidence: <facts and prior-run results with sources>
audit_evidence_file: <absolute evidence.md path>
previous_wrap: <absolute path or none>
boundaries: read-only analysis; no mutations
```

## Phase 1 roles

### doc-updater

Determine what future agents or teammates genuinely need in durable documentation.

Inspect relevant `AGENTS.md`, `CLAUDE.md`, `context.md`, README, runbooks, and decision records. Prefer updating an existing section over adding a new document. Exclude temporary experiments, facts already obvious from code, unverified state, and secrets.

Return:

```markdown
## Documentation findings
- proposal: <title or none>
  target: <absolute file and section>
  exact_change: <concise proposed content>
  evidence: <source>
  durability: <why future sessions need it>
  possible_overlap: <file/section or none>
```

### automation-scout

Recommend automation only for a step repeated at least twice, a recurring operational control, or a high-risk check where deterministic execution materially reduces omissions. Search existing skills, scripts, commands, agents, CI, and automations first. Prefer extending an existing mechanism.

Return:

```markdown
## Automation findings
- proposal: <title or none>
  pattern_evidence: <occurrences or recurring control>
  mechanism: <script | skill | command | agent | CI | none>
  existing_overlap: <path/name or none>
  impact: <time or risk reduction>
  difficulty: <low | medium | high>
  priority: <required | optional>
```

### learning-extractor

Capture only reusable knowledge: a proven successful pattern, a failed approach with root cause, a corrected misconception, or a newly discovered constraint. Distinguish observation from inference and session-specific detail from reusable rule.

Return:

```markdown
## Learning findings
- finding: <title or none>
  category: <worked | failed | correction | constraint>
  evidence: <source>
  reusable_rule: <future behavior>
  scope: <where it applies>
```

### followup-suggester

Identify incomplete work from verified state rather than broad code-quality speculation. Required work must have an owner, dependency, concrete next action, and done criterion. Do not assign a date unless a real deadline exists. Put optional improvements after completion gates.

Return:

```markdown
## Follow-up findings
- action: <title or none>
  class: <required | optional>
  owner: <agent | user | named external party/system>
  dependency: <dependency or none>
  next_action: <single concrete action>
  done_when: <observable criterion>
  evidence: <source>
```

## Phase 2 role: duplicate-checker

Validate Phase 1 after all four outputs are recorded in `evidence.md`.

Search documentation proposals against relevant durable documents and automation proposals against existing skills, scripts, commands, agents, CI, and automation definitions. Reconcile learning and follow-up findings against the latest prior wrap and current verified state.

Classify every proposal:

- `add`: new, supported, and correctly scoped.
- `merge`: useful new information belongs in an existing item.
- `skip`: complete duplicate, unsupported, temporary, or unjustified.
- `conflict`: contradicts verified state or another supported finding.

Return:

```markdown
## Phase 2 validation
- search_scope: <files/directories checked>
- proposal: <title>
  source_role: <role>
  verdict: <add | merge | skip | conflict>
  existing_location: <absolute file/section or none>
  evidence: <why>
  canonical_item: <approved or merged wording, or none>

## Validation gaps
- <unverified claim or none>
```

Do not approve a proposal merely because no exact keyword match exists; check functional and semantic overlap. Do not turn optional ideas into completion gates.
