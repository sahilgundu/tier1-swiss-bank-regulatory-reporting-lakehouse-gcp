#!/usr/bin/env bash
set -Eeuo pipefail
# ---------------------------------------------------------------------
# Git Daily Command Collector — Git Bash (Windows) safe
# Appends all commands from TODAY (00:00–23:59 local) to git-snippets.sh.
# Looks at both current in-memory history and ~/.bash_history.
# ---------------------------------------------------------------------

# Resolve log file path relative to this script (tools/git-snippets.sh)
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${SCRIPT_DIR}/git-snippets.sh"

TODAY="$(date +%F)"   # e.g. 2025-11-11

mkdir -p "${SCRIPT_DIR}"
touch "${LOG_FILE}"

# Ensure today's header exists once
if ! grep -q "^# ===== ${TODAY} =====" "${LOG_FILE}"; then
  printf '\n# ===== %s =====\n' "${TODAY}" >> "${LOG_FILE}"
fi

# --- helper: extract today's existing lines from the log (for de-dup) ---
extract_existing_today() {
  awk -v t="${TODAY}" '
    BEGIN{inblk=0}
    /^# ===== /{
      inblk = ($0 ~ t) ? 1 : 0
      next
    }
    inblk && length($0)>0 { print }
  ' "${LOG_FILE}" | sed 's/\r$//'   # normalize CRLF if any
}

# --- source A: from ~/.bash_history with "# <epoch>" timestamps ---
from_histfile=""
if [ -f "${HOME}/.bash_history" ]; then
  # This reads pairs: "# <epoch>" followed by the command.
  # If HISTTIMEFORMAT was enabled when the command ran, the timestamp line exists.
  from_histfile="$(awk -v t="${TODAY}" '
    /^# [0-9]+$/ { ts = substr($0,3); next }
    {
      if (ts != "") {
        d = strftime("%Y-%m-%d", ts)
        if (d == t) print $0
        ts = ""
      }
    }
  ' "${HOME}/.bash_history" | sed "s/\r$//")"
fi

# --- source B: in-memory history via builtin history with a forced format ---
# This works even if histfile lacks "# <epoch>" lines.
from_inmemory="$(HISTTIMEFORMAT="%F %T " builtin history 2>/dev/null \
  | awk -v t="${TODAY}" '
      # Example line: " 123  2025-11-11 01:02:03  git commit -m x"
      match($0, /^[[:space:]]*[0-9]+[[:space:]]+([0-9]{4}-[0-9]{2}-[0-9]{2})[[:space:]]+[0-9]{2}:[0-9]{2}:[0-9]{2}[[:space:]]+(.*)$/, m) {
        if (m[1]==t) print m[2]
      }
    ' | sed "s/\r$//")"

# Combine sources, drop blank lines, remove duplicates already in file and within batch.
combine_and_append() {
  existing_file="$(mktemp)"
  extract_existing_today > "${existing_file}"

  printf "%s\n%s\n" "${from_histfile}" "${from_inmemory}" \
    | awk 'NF' | awk '!seen[$0]++' \
    | grep -Fvx -f "${existing_file}" - 2>/dev/null \
    >> "${LOG_FILE}"

  rm -f "${existing_file}"
}

combine_and_append

# Report summary
count_today="$(awk -v t="${TODAY}" 'f{c++} /^# ===== /{f=($0 ~ t)} END{print c+0}' "${LOG_FILE}")"
printf 'Appended commands for %s → %s (today total lines: %s)\n' "${TODAY}" "${LOG_FILE}" "${count_today}"
