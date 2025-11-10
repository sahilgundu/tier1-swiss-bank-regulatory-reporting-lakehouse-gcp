# Git command snippets — append-only log
# Auto-managed by tools/log_git_today.sh

# ===== 2025-11-10 — Study Files Setup =====
mkdir -p docs tools
mv ~/Downloads/git-commands-cheatsheet.md ./docs/
mv ~/Downloads/git-snippets.sh ./tools/
git add docs/git-commands-cheatsheet.md tools/git-snippets.sh
git commit -m "docs: add Git study cheatsheet and snippets tracker"
git push

# ===== 2025-11-10 — Weekly Maintenance =====
git pull --ff-only
echo "# $(date '+%Y-%m-%d %H:%M') — git fetch --all --prune" >> tools/git-snippets.sh
git add docs/git-commands-cheatsheet.md tools/git-snippets.sh
git commit -m "docs: weekly update of Git logs and command notes"
git push

# ===== 2025-11-11 =====
# (auto-appended entries for this date will appear below)
# (fallback appended from recent session — timestamps were not yet enabled)
# (fallback appended from recent session — timestamps were not yet enabled)
# (fallback appended from recent session — timestamps were not yet enabled)
git status
git add tools/git-snippets.sh
git commit -m "log: append today's git history (auto via log_git_today.sh)"
git push
git pull origin main --rebase
git push origin main
git log --oneline -5
git diff --stat
git branch -v
git log --oneline -3
git fetch origin
git switch main
git pull --rebase origin main   # fast-forward or rebase to match GitHub
git update-index --chmod=+x tools/log_git_today.sh
git commit -m "chore: mark log_git_today.sh executable"
git add .gitattributes
git commit -m "chore: enforce LF for *.sh"
git pull --rebase
git add -A && git commit -m "fix: robust daily collector (A/B/C sources)"; git push
git add -A
git commit -m "snippets: test capture"
git add tools/log_git_today.sh .gitattributes
git commit -m "fix: script-safe daily collector (no history builtin); enforce LF"
git update-index --chmod=+x tools/log_and_push.sh
git add tools/log_and_push.sh
git commit -m "chore: add one-click log_and_push.sh"
git fetch "$REMOTE" || true
git switch "$BRANCH" >/dev/null 2>&1 || git checkout "$BRANCH"
git pull --rebase "$REMOTE" "$BRANCH"
git add -- "$SNIPPETS"
git commit -m "log: append today's git history (auto via log_and_push.sh)"
git push "$REMOTE" "$BRANCH"
git add tools/log_and_push.sh .gitattributes
git commit -m "chore: add one-click tools/log_and_push.sh"
