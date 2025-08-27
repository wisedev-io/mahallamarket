#!/usr/bin/env bash
set -euo pipefail

# Usage: ./push.sh "your commit message"
MSG="${1:-chore: update $(date -u +'%Y-%m-%dT%H:%M:%SZ')}"

# Ensure we're in a git repo
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "Not a git repo"; exit 1; }

# Detect current branch (default to main)
BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$BRANCH" == "HEAD" ]]; then
  BRANCH="main"
  git checkout "$BRANCH" || true
fi

# Pull latest (fast-forward only)
git fetch origin
git pull --ff-only origin "$BRANCH" || echo "⚠️ Could not fast-forward; continuing with local changes."

# Add, commit, push
git add -A
git commit -m "$MSG" || echo "ℹ️ Nothing to commit."
git push -u origin "$BRANCH"
echo "✅ Pushed to origin/$BRANCH"
