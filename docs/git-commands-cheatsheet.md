# Git Commands Cheatsheet — Regulatory Reporting Lakehouse (GCP)

This file summarizes all Git commands run from setup through continuous documentation updates.  
Each command includes its **purpose** and **context** in the current docs-only repo.

---

## 1. Repository Initialization

```bash
cd "C:/LinkedIn 7 Projects/tier1-swiss-bank-regulatory-reporting-lakehouse-gcp"
git init -b main
git add .
git commit -m "v0.1.0: docs-only regulatory reporting lakehouse (GCP) — sanitized, placeholders loaded."
git config user.name "Sahil Gundu"
git config user.email "sahil.gundu@gmail.com"
git remote add origin https://github.com/Sahilg135/tier1-swiss-bank-regulatory-reporting-lakehouse-gcp.git
git push -u origin main
```

**Why:** Initializes your repo, connects it to GitHub, and pushes version `v0.1.0`.

---

## 2. Repo Hygiene & Versioning

```bash
git branch
git remote -v
git tag -a v0.1.0 -m "docs-only regulatory reporting lakehouse (GCP)"
git push origin v0.1.0
git log --oneline
```

**Why:** Confirms repo state, branch tracking, and first tag creation.

---

## 3. Continuous Documentation Update Workflow

```bash
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
```

**Why:** Keeps your workflow clean — all updates via feature branches and PRs.

---

## 4. Study File Organization

```bash
mkdir -p docs tools
mv ~/Downloads/git-commands-cheatsheet.md ./docs/
mv ~/Downloads/git-snippets.sh ./tools/
git add docs/git-commands-cheatsheet.md tools/git-snippets.sh
git commit -m "docs: add Git study cheatsheet and snippets tracker"
git push
```

**Why:** Version-control your Git study material within the repo.

---

## 5. Weekly Maintenance

```bash
git pull
echo "# $(date '+%Y-%m-%d %H:%M') — git fetch --all --prune" >> tools/git-snippets.sh
git add docs/git-commands-cheatsheet.md tools/git-snippets.sh
git commit -m "docs: weekly update of Git logs and command notes"
git push
```

**Why:** Keep the study repo synchronized and up to date.
