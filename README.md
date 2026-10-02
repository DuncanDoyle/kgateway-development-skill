# kgateway-development skill

Agent skill for implementing and reviewing changes in `kgateway-dev/kgateway` and
`solo-io/gloo-gateway`. It emphasizes repository-local design alignment, tests at the behavioral
boundary, alias and index correctness, compatibility coverage, and explicit data-plane costs.

## Layout

The repository root is the skill, matching the other Solo skill repositories.

| Path | Purpose |
|---|---|
| `SKILL.md` | Skill instructions and review checklist |
| `scripts/install-skill.sh` | Installs the runtime skill into the shared skills directory |

## Install

```bash
scripts/install-skill.sh                      # -> ~/.agents/skills/kgateway-development
AGENTS_SKILLS_DIR=/somewhere scripts/install-skill.sh
```

Then symlink it where an agent expects skills, if needed:

```bash
ln -s ~/.agents/skills/kgateway-development ~/.claude/skills/kgateway-development
```

The installer uses `rsync --delete`, so rerunning it after a `git pull` keeps the installed skill
in sync with the repository.

## Validate

With Codex installed, run:

```bash
python3 ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py .
```
