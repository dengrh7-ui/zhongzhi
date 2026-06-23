#!/bin/bash
set -euo pipefail

# Only run in Claude Code on the web (ephemeral remote containers).
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

SKILLS_DIR="$HOME/.claude/skills"
SP_REPO="https://github.com/obra/superpowers.git"
SP_CACHE="/tmp/superpowers-skills"

mkdir -p "$SKILLS_DIR"

# Idempotent: skip clone+copy if a marker skill is already present.
if [ ! -d "$SKILLS_DIR/using-superpowers" ]; then
  rm -rf "$SP_CACHE"
  git clone --depth 1 "$SP_REPO" "$SP_CACHE" >/dev/null 2>&1
  cp -r "$SP_CACHE"/skills/* "$SKILLS_DIR"/
  rm -rf "$SP_CACHE"
fi
