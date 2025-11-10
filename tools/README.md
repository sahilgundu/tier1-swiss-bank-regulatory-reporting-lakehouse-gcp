# Git Snippets - Daily Git Command Logger (Windows Git Bash-safe)

This folder contains a small system that **collects today’s Git commands** from your shell history and appends them to an in-repo, append-only log. A one-click wrapper can then **commit & push** the update.

---

## 1) Why this exists (and why it works)

On Windows (Git Bash), calling the interactive `history` builtin from a script is unreliable in non-interactive shells.
This collector reads the **history file** (`~/.bash_history`) instead and supports both formats:

- **Timestamped history** (`# <epoch>` before each command) -> accurate "today" filter
- **Plain history** (no timestamps) -> **fallback** to recent `git ...` commands

It also **de-duplicates** each day and guarantees a single daily header.

---

## 2) Invention & value add

- **Windows-ready, script-safe**: parses the history file directly; no fragile shell builtins.
- **Zero friction**: one command updates, commits, and pushes a dated log.
- **Traceable & reviewable**: append-only, de-duplicated sections make daily activity easy to audit.
- **Backward-compatible**: works with both plain and timestamped histories.
- **Repo-native**: the log lives with the code; no external tooling.

---

## 3) Files in this folder

| File | Purpose |
| --- | --- |
| `git-snippets.sh` | **Append-only output log.** Commands grouped under headers like `# ===== YYYY-MM-DD =====`. |
| `log_git_today.sh` | **Collector.** Reads `~/.bash_history` and appends **today’s** `git ...` commands under the current date header. Works with timestamped and non-timestamped history. De-duplicates. |
| `log_and_push.sh` | **One-click wrapper.** Pull -> run collector -> commit `git-snippets.sh` if changed -> push. |

---

## 4) How it works (under the hood)

1. **Header guard**: creates `# ===== YYYY-MM-DD =====` once per day.
2. **Source A (preferred)**: if `~/.bash_history` has epoch timestamps, filter by **today** and append those commands.
3. **Source B (fallback)**: if no timestamps exist, take the **last ~200** lines and keep only those starting with `git `.
4. **De-duplication**: skip anything already written under today’s header.
5. **Windows-safe**: never relies on `history` inside scripts; avoids Git Bash prompt quirks.

---

## 5) First-time setup

```bash
# Make scripts executable (GitHub UI cannot set +x)
git update-index --chmod=+x tools/log_git_today.sh
git update-index --chmod=+x tools/log_and_push.sh

# Enforce LF for shell scripts (avoid CRLF parsing issues on Windows)
echo "*.sh text eol=lf" >> .gitattributes
git add .gitattributes
git commit -m "chore: enforce LF for *.sh"
git push
