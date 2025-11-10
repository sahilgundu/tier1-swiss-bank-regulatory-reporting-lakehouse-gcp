# Contributing Guidelines

**Repository:** Regulatory Reporting Lakehouse — *Tier‑1 Swiss Bank (GCP)*  
**Scope:** **Docs‑only, sanitized case study.** No executable client code or data.

> TL;DR: Use feature branches, Conventional Commits, and PRs to `main`. Keep content client‑safe and production‑style.

---

## 1) Ground Rules

- **Docs‑only:** This repository intentionally excludes runnable client code. Include **design docs, runbooks, ADRs, data contracts, SQL snippets (illustrative), diagrams, and release notes**.
- **Sanitization:** Never commit real client names, secrets, or proprietary artifacts. Use neutral terms like “Tier‑1 Swiss bank.”
- **Reproducibility:** Prefer deterministic examples, versioned diagrams, and pinned references. Keep diagrams exported under `assets/`.
- **Professional tone:** Assume recruiter's and engineer's eyes on every page.

---

## 2) Branching Model

Create short‑lived branches from `main`:

```
feat/<scope>        # new documentation or sections
fix/<scope>         # corrections (broken links, typos that change meaning)
docs/<scope>        # minor edits (copy/format), READMEs, diagrams
refactor/<scope>    # restructure without content change
release/vX.Y.Z      # tag prep (changelog bump)
```

Examples:
```
feat/bq-datasets-overview
docs/add-quick-facts
fix/security-wording
```

---

## 3) Commit Messages (Conventional Commits)

Format:
```
<type>: <short summary>

[optional body explaining why, constraints, or alternatives]
```

Common types: `feat`, `fix`, `docs`, `refactor`, `chore`, `ci`

Examples:
```
feat: add Composer DAG outline for regulatory batch jobs
docs: add SLO and cost summary table
fix: correct BigQuery dataset retention policy wording
```

---

## 4) Pull Requests

- **Target branch:** `main`  
- **Before opening a PR:**

  ```bash
  git fetch origin
  git checkout main && git pull --ff-only
  git checkout -b feat/<scope>
  # ... edits ...
  git add -A && git commit -m "feat: <message>"
  git push -u origin feat/<scope>
  ```

- **PR Checklist:**
  - Title uses Conventional Commit style.
  - Diagrams updated and exported to `assets/` (PNG/SVG).
  - Links are relative (work in GitHub UI).
  - No client names or secrets.
  - Updated `RELEASE_NOTES.md` if behavior/structure changed.
  - Added/updated an ADR if a decision/trade‑off was made.

---

## 5) Releases & Versioning

- **Semantic versioning for docs:** use `vMAJOR.MINOR.PATCH` to show maturity.
  - `MAJOR`: structural reorganization or breaking conceptual changes.
  - `MINOR`: new sections, diagrams, or significant clarifications.
  - `PATCH`: small fixes and spelling/formatting improvements.
- **Tagging flow:**

  ```bash
  # On main after merge
  git pull --ff-only
  git tag -a vX.Y.Z -m "vX.Y.Z: <highlight>"
  git push origin vX.Y.Z
  ```

- **Release notes:** keep `RELEASE_NOTES.md` with a new section per tag:
  ```markdown
  ## vX.Y.Z — 2025‑11‑10
  - docs: added Quick Facts and L2 overview diagram
  - fix: clarified BQ cost controls and partitioning
  ```

---

## 6) Repository Layout (authoritative small map)

```
.github/workflows/   # CI for linting/markdown checks (docs-only)
ADRs/                # Architecture Decision Records (one ADR per decision)
assets/              # Exported diagrams/images (PNG/SVG)
composer/            # DAG outlines, schedules (non-executable examples)
contracts/           # Data contracts / schemas (illustrative)
dbt/                 # Folder structure & models docs (no secrets)
docs/                # Guides, HOWTOs, deep dives
runbooks/            # Operability docs (SLOs, DQ checks, support playbooks)
samples/deliverables/# Client-safe samples (redacted)
sql/                 # Illustrative SQL patterns and snippets
README.md            # Project overview (recruiter + engineer friendly)
CONTRIBUTING.md      # This file
RELEASE_NOTES.md     # Versioned changes for tags
PROVENANCE.md        # Source-of-truth / credits for diagrams or ideas
SECURITY.md          # Reporting + basic security policies
```

---

## 7) Quality Gates (local)

Before pushing:

```bash
# Basic link and markdown sanity (example, customize as needed)
markdownlint "**/*.md" || echo "Install markdownlint or adjust .markdownlint.json"

# No client names anywhere (rough grep)
git grep -In "Credit Suisse\|Barclays\|Lloyds" && echo "Sanitize names before commit!"
```

Keep diagrams in `assets/` and reference with relative paths:
```markdown
![L2 Overview](assets/l2-overview.png)
```

---

## 8) Security & Compliance

- No credentials, keys, or real endpoints.  
- No screenshots with internal IDs.  
- Use **neutral dataset names**, generic tenants, and placeholder service accounts.  
- If in doubt, redact or move content to `samples/deliverables/` with a disclaimer.

---

## 9) Getting Help

Open a GitHub Issue with the label `question` or `clarification`.  
For structural decisions, propose an ADR using the template in `ADRs/`.

---

## 10) Quick Start (Contributor)

```bash
git clone https://github.com/Sahilg135/tier1-swiss-bank-regulatory-reporting-lakehouse-gcp.git
cd tier1-swiss-bank-regulatory-reporting-lakehouse-gcp
git checkout -b docs/update-readme
# edit files under docs/, assets/, etc.
git add -A && git commit -m "docs: update README Quick Facts"
git push -u origin docs/update-readme
# open PR to main
```
