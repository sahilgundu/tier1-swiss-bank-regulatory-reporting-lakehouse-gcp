#!/usr/bin/env bash
set -Eeuo pipefail
# ---------------------------------------------------------------------
# Git Daily Command Collector — no use of `history` builtin (script-safe)
# Reads ~/.bash_history only. Supports:
#  - Timestamped entries (# <epoch> line before command)  -> filter "today".
#  - Plain entries (no timestamps)                         -> take last 200.
# Appends under "# ===== YYYY-MM-DD =====" in tools/git-snippets.sh
# and de-duplicates within the day's section.
# ---------------------------------------------------------------------

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${SCRIPT_DIR}/git-snippets.sh"
HIST_FILE="${HOME}/.bash_history"
TODAY="$(date +%F)"  # e.g., 2025-11-11

mkdir -p "${SCRIPT_DIR}"
touch "${LOG_FILE}"

# Ensure today's header once
if ! grep -q "^# ===== ${TODAY} =====" "${LOG_FILE}"; then
  printf '\n# ===== %s =====\n' "${TODAY}" >> "${LOG_FILE}"
fi

# Get existing lines for today (for de-dup)
existing_today="$(awk -v t="${TODAY}" '
  BEGIN{blk=0}
  /^# ===== /{blk = ($0 ~ t); next}
  blk && NF { print }
' "${LOG_FILE}" | sed "s/\r$//")"

have_ts=0
buf="$(mktemp)"; : > "${buf}"

# Parse ~/.bash_history
# With timestamps: lines like "# 1731300000" followed by the command
if [ -f "${HIST_FILE}" ]; then
  awk -v t="${TODAY}" '
    /^# [0-9]+$/ { ts = substr($0,3); next }
    {
      if (ts != "") {
        d = strftime("%Y-%m-%d", ts)
        if (d == t) print $0
        ts = ""
      }
    }
  ' "${HIST_FILE}" > "${buf}"

  if [ -s "${buf}" ]; then
    have_ts=1
  fi
fi

# If no timestamped matches, fallback: last 200 non-# lines from hist file
if [ "${have_ts}" -eq 0 ]; then
  # Note marker once per day (only if today section has no commands yet)
  if [ -z "${existing_today}" ]; then
    echo "# (fallback from ~/.bash_history — timestamps not present)" >> "${LOG_FILE}"
  fi

  # Take recent commands only, filter "git " lines
  if [ -f "${HIST_FILE}" ]; then
    grep -vE '^# [0-9]+' "${HIST_FILE}" | tail -n 200 \
      | sed -E 's/^\s+//' | awk '/^git /' > "${buf}" || true
  fi
fi

# De-duplicate: drop lines already in today’s block and within this batch
append_tmp="$(mktemp)"
printf "%s\n" "${existing_today}" > "${append_tmp}"   # seed with existing

awk '
  FNR==NR { seen[$0]=1; next }          # load existing
  NF && !seen[$0]++ { print }           # print unique new lines
' "${append_tmp}" "${buf}" >> "${LOG_FILE}"

rm -f "${buf}" "${append_tmp}"

# Report
count_today="$(awk -v t="${TODAY}" 'blk && NF{c++} /^# ===== /{blk=($0~t)} END{print c+0}' "${LOG_FILE}")"
printf 'Appended commands for %s → %s (today total lines: %s)\n' "${TODAY}" "${LOG_FILE}" "${count_today}"
