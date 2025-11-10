
# ===== 2025-11-10 =====

#!/usr/bin/env bash
# Git Snippets Log — Regulatory Reporting Lakehouse (GCP)
# Chronological record of commands Sahil has run or learned.

# ----------------------------------------------------------------------
# 2025-11-10 — Initial Repository Setup
# ----------------------------------------------------------------------
cd "C:/LinkedIn 7 Projects/tier1-swiss-bank-regulatory-reporting-lakehouse-gcp"
git init -b main
git add .
git commit -m "v0.1.0: docs-only regulatory reporting lakehouse (GCP) — sanitized, placeholders loaded."
git config user.name "Sahil Gundu"
git config user.email "sahil.gundu@gmail.com"
git remote add origin https://github.com/Sahilg135/tier1-swiss-bank-regulatory-reporting-lakehouse-gcp.git
git push -u origin main

# ----------------------------------------------------------------------
# 2025-11-10 — Hygiene and Versioning
# ----------------------------------------------------------------------
git branch
git remote -v
git tag -a v0.1.0 -m "docs-only regulatory reporting lakehouse (GCP)"
git push origin v0.1.0
git log --oneline

# ----------------------------------------------------------------------
# 2025-11-10 — CONTRIBUTING.md Workflow
# ----------------------------------------------------------------------
git fetch origin
git pull --ff-only
git checkout -b docs/update-contributing
git add CONTRIBUTING.md
git commit -m "docs: add CONTRIBUTING.md with guidelines and CI info"
git push -u origin docs/update-contributing
git checkout main
git pull --ff-only
git branch -d docs/update-contributing
git push origin --delete docs/update-contributing

# ----------------------------------------------------------------------
# 2025-11-10 — Study Files Setup
# ----------------------------------------------------------------------
mkdir -p docs tools
mv ~/Downloads/git-commands-cheatsheet.md ./docs/
mv ~/Downloads/git-snippets.sh ./tools/
git add docs/git-commands-cheatsheet.md tools/git-snippets.sh
git commit -m "docs: add Git study cheatsheet and snippets tracker"
git push

# ----------------------------------------------------------------------
# 2025-11-10 — Weekly Maintenance
# ----------------------------------------------------------------------
git pull
echo "# $(date '+%Y-%m-%d %H:%M') — git fetch --all --prune" >> tools/git-snippets.sh
git add docs/git-commands-cheatsheet.md tools/git-snippets.sh
git commit -m "docs: weekly update of Git logs and command notes"
git push
>>>>>>> origin/main

# ===== 2025-11-11 =====
