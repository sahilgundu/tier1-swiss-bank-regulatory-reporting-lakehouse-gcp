#!/usr/bin/env bash
set -Eeuo pipefail

# One-click: collect today's git commands -> commit -> push.
# Safe on Git Bash (Windows). Commits only if git-snippets.sh actually changed.

# --- repo + paths ---
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || { echo "Not inside a git repo"; exit 1; })"
cd "$REPO_ROOT"

SCRIPT_DIR="tools"
COLLECTOR="${SCRIPT_DIR}/log_git_today.sh"
SNIPPETS="${SCRIPT_DIR}/git-snippets.sh"
REMOTE="${REMOTE:-origin}"
BRANCH="${BRANCH:-main}"

# --- sanity checks ---
[ -x "$COLLECTOR" ] || { echo "ERROR: $COLLECTOR not executable"; exit 1; }
[ -f "$SNIPPETS" ]   || { echo "ERROR: $SNIPPETS missing"; exit 1; }

# --- sync + collect ---
git fetch "$REMOTE" || true
git switch "$BRANCH" >/dev/null 2>&1 || git checkout "$BRANCH"
git pull --rebase "$REMOTE" "$BRANCH"

bash "$COLLECTOR"

# --- commit only if file changed ---
if git diff --quiet -- "$SNIPPETS"; then
  echo "No changes in $SNIPPETS. Nothing to commit."
else
  git add -- "$SNIPPETS"
  git commit -m "log: append today's git history (auto via log_and_push.sh)"
  git push "$REMOTE" "$BRANCH"
  echo "Pushed updated $SNIPPETS to $REMOTE/$BRANCH."
fi
