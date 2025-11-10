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

```

## 6. Daily routine

### Option 1 - One click (recommended)
```bash
bash tools/log_and_push.sh

```
This does: pull -> collect -> commit (if changed) -> push.

### Option 2 - Manual 
```bash
bash tools/log_git_today.sh
tail -n 30 tools/git-snippets.sh   # verify
git add tools/git-snippets.sh
git commit -m "log: append today's git history"
git push

```

## 7) Customize what gets logged (exclude noise)
If you want to hide chatty commands (e.g., git status, git log, git diff --stat), add an exclude filter inside tools/log_git_today.sh before it appends lines.

```bash
# Example: hide frequent noise
EXCLUDE_REGEX='^(git status|git log|git diff --stat)$'

# When selecting candidate lines, filter with awk:
# ... | awk -v ex="$EXCLUDE_REGEX" '$0 !~ ex' | ...

```

- Add more commands by extending the regex with |, e.g. |git branch -v|git fetch origin.
- Keep the pattern anchored (^ at start, $ at end) so only full-command matches are excluded.

## 8) Troubleshooting
### Nothing appended today
- You may not have run any git ... commands yet today. Run a couple and re-run the collector.
- On the first run after enabling timestamps, you might see a small “fallback” note; later sessions will append with exact dates.
  
### “not executable” errors
```bash
git update-index --chmod=+x tools/log_git_today.sh
git update-index --chmod=+x tools/log_and_push.sh
git commit -m "chore: mark scripts executable"
git push

```

## 9) Design choices (snapshot)
- Read the history file (~/.bash_history) instead of the interactive builtin.
- Support both timestamped and plain histories.
- Guarantee one header per day and de-duplicate appended lines.
- Keep everything repo-native and Windows-friendly.

  
## 10) Security & privacy
- The log captures only the commands you typed, not their output.
- Avoid running or committing commands that include secrets (tokens, passwords, keys) in plain text.
- If a command might reveal sensitive data, exclude it in the collector (see section 7’s EXCLUDE_REGEX).
- Review tools/git-snippets.sh before pushing; remove any accidental sensitive lines.
- This is a repo-visible log. Assume teammates and reviewers can read it.
