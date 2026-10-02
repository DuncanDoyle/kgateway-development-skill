#!/usr/bin/env bash
# install-skill.sh — sync the kgateway-development skill from this repo into the
# shared skills dir used by both Claude Code and Codex. Copies runtime files only
# (currently SKILL.md), not repository metadata or development-only files.
#
#   scripts/install-skill.sh            # installs to ~/.agents/skills/kgateway-development
#   AGENTS_SKILLS_DIR=/path scripts/install-skill.sh
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/.." && pwd)
dest="${AGENTS_SKILLS_DIR:-$HOME/.agents/skills}/kgateway-development"

mkdir -p "$dest"
# --delete keeps the installation in sync when runtime files are removed.
rsync -a --delete \
  --exclude '.git/' --exclude 'scripts/' \
  "$ROOT/SKILL.md" \
  "$dest/"

echo "Installed kgateway-development skill to $dest"
