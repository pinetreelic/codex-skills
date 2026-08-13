# Codex Skills

Reusable skills for OpenAI Codex, maintained by [pinetreelic](https://github.com/pinetreelic).

## Available skills

### session-wrap

Close a coding or work session with evidence-backed status, explicit ownership, reconciled follow-ups, and one decisive next step.

- `quick`: chat-only closeout with no files
- `handoff`: one canonical `wrap-summary.md`
- `audit`: four independent analysis roles followed by a separate duplicate and conflict validator

The audit workflow adapts the multi-agent session-wrap design from [Team Attention's plugins-for-claude-natives](https://github.com/team-attention/plugins-for-claude-natives/tree/main/plugins/session-wrap). Its original MIT notice is preserved in [`skills/session-wrap/LICENSE`](skills/session-wrap/LICENSE).

## Install

Install the `session-wrap` skill with the Skills CLI:

```bash
npx skills add pinetreelic/codex-skills --skill session-wrap --agent codex --global --yes
```

Or clone the repository and copy `skills/session-wrap` into `${CODEX_HOME:-$HOME/.codex}/skills/session-wrap`.

Restart Codex or reload skills if the new skill is not discovered immediately.

## Use

Invoke `$session-wrap`, or ask Codex to wrap up, create a handoff, or perform an evidence-backed audit. The skill selects the lightest mode that fits the request and risk.

## Validate

From the repository root:

```bash
bash skills/session-wrap/scripts/test_run_wrap.sh
python3 /path/to/skill-creator/scripts/quick_validate.py skills/session-wrap
```

The regression test is self-contained. The second command uses Codex's bundled `skill-creator` validator when available.

## License

Repository-original material is available under the [MIT License](LICENSE). Derived skill material retains its upstream attribution and license notice.
