#!/usr/bin/env bash
set -Eeuo pipefail
# ---------------------------------------------------------------------
# Git Daily Command Collector — Git Bash (Windows) tolerant
# Appends commands from TODAY (00:00–23:59 local) to git-snippets.sh.
# Sources:
#  A) ~/.bash_history with "# <epoch>" lines (best)
#  B) history output with forced timestamps (good)
#  C) last 300 plain history lines filtered to "git " (fallback)
# De-duplicates against today's section.
# ---------------------------------------------------------------------

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${SCRIPT_DIR}/git-snippets.sh"
TODAY="$(date +%F)"   # e.g., 2025-11-11

mkdir -p "${SCRIPT_DIR}"
touch "${LOG_FILE}"

# Ensure today's header exists once
if ! grep -q "^# ===== ${TODAY} =====" "${LOG_FILE}"; then
  printf '\n# ===== %s =====\n' "${TODAY}" >> "${LOG_FILE}"
fi

# --- helper: read existing lines for today (for de-dupe) ---
existing_today() {
  awk -v t="${TODAY}" '
    BEGIN{block=0}
    /^# ===== /{block = ($0 ~ t) }
    block && !/^# ===== / && length($0)>0 {print}
  ' "${LOG_FILE}" | sed 's/\r$//'
}

# --- Source A: ~/.bash_history epoch pairs (# <epoch> then command) ---
from_histfile=""
if [ -f "${HOME}/.bash_history" ]; then
  from_histfile="$(awk -v t="${TODAY}" '
    /^# [0-9]+$/ { ts = substr($0,3); next }
    {
      if (ts != "") {
        if (strftime("%Y-%m-%d", ts) == t) print $0
        ts = ""
      }
    }
  ' "${HOME}/.bash_history" | sed 's/\r$//')"
fi

# --- Source B: in-memory history with forced timestamps ---
from_inmem="$(HISTTIMEFORMAT="%F %T " history 2>/dev/null \
  | awk -v t="${TODAY}" '
      # " 123  2025-11-11 01:02:03  git commit -m x"
      match($0, /^[[:space:]]*[0-9]+[[:space:]]+([0-9]{4}-[0-9]{2}-[0-9]{2})[[:space:]]+[0-9]{2}:[0-9]{2}:[0-9]{2}[[:space:]]+(.*)$/, m) {
        if (m[1]==t) print m[2]
      }
    ' | sed 's/\r$//')"

# --- Source C: plain history (no timestamps): take last 300, keep "git " only ---
from_plain="$(history 2>/dev/null | tail -n 300 \
  | sed -E 's/^[[:space:]]*[0-9]+[[:space:]]+//' \
  | awk '/^git /' | sed 's/\r$//')"

# If A or B yielded non-empty, prefer A∪B; else use C.
choose_and_append() {
  tmp_exist="$(mktemp)"; existing_today > "${tmp_exist}"

  if [ -n "${from_histfile}" ] || [ -n "${from_inmem}" ]; then
    printf "%s\n%s\n" "${from_histfile}" "${from_inmem}" \
      | awk 'NF' | awk '!seen[$0]++' \
      | grep -Fvx -f "${tmp_exist}" - 2>/dev/null \
      >> "${LOG_FILE}"
  else
    # Fallback: assume last 300 "git " lines are today's (first run after enabling timestamps)
    echo "# (fallback appended from recent session — timestamps were not yet enabled)" >> "${LOG_FILE}"
    printf "%s\n" "${from_plain}" \
      | awk 'NF' | awk '!seen[$0]++' \
      | grep -Fvx -f "${tmp_exist}" - 2>/dev/null \
      >> "${LOG_FILE}"
  fi

  rm -f "${tmp_exist}"
}

choose_and_append

# Report
count_today="$(awk -v t="${TODAY}" 'f{c++} /^# ===== /{f=($0 ~ t)} END{print c+0}' "${LOG_FILE}")"
printf 'Appended commands for %s → %s (today total lines: %s)\n' "${TODAY}" "${LOG_FILE}" "${count_today}"
