#!/usr/bin/env bash
set -euo pipefail

# OpenClaw Skills Healthcheck Workflow
# Usage:
#   bash scripts/run_skills_healthcheck.sh
#   GOG_KEYRING_PASSWORD=xxx TAVILY_API_KEY=xxx GEMINI_API_KEY=xxx bash scripts/run_skills_healthcheck.sh

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
REPORT_DIR="$ROOT_DIR/reports"
TS="$(date +%Y%m%d-%H%M%S)"
REPORT_MD="$REPORT_DIR/skills-healthcheck-$TS.md"
REPORT_JSON="$REPORT_DIR/skills-healthcheck-$TS.json"

mkdir -p "$REPORT_DIR"

has() { command -v "$1" >/dev/null 2>&1; }

ok=0
warn=0
fail=0

json_escape() {
  python3 - <<'PY' "$1"
import json,sys
print(json.dumps(sys.argv[1]))
PY
}

log_md() {
  echo -e "$1" >> "$REPORT_MD"
}

log_json_row() {
  local name="$1" status="$2" detail="$3"
  printf '  {"name": %s, "status": %s, "detail": %s},\n' \
    "$(json_escape "$name")" "$(json_escape "$status")" "$(json_escape "$detail")" >> "$REPORT_JSON.tmp"
}

run_check() {
  local name="$1" cmd="$2" severity="${3:-fail}"
  local out rc
  set +e
  out="$(bash -lc "$cmd" 2>&1)"
  rc=$?
  set -e

  if [[ $rc -eq 0 ]]; then
    ok=$((ok+1))
    log_md "- ✅ **$name**\n  - Command: \`$cmd\`\n  - Result: PASS"
    log_json_row "$name" "PASS" "$(echo "$out" | head -n 4 | tr '\n' ' ')"
  else
    if [[ "$severity" == "warn" ]]; then
      warn=$((warn+1))
      log_md "- ⚠️ **$name**\n  - Command: \`$cmd\`\n  - Result: WARN (non-blocking)\n  - Error: \`$(echo "$out" | head -n 2 | tr '\n' ' ' | sed 's/`/\"/g')\`"
      log_json_row "$name" "WARN" "$(echo "$out" | head -n 4 | tr '\n' ' ')"
    else
      fail=$((fail+1))
      log_md "- ❌ **$name**\n  - Command: \`$cmd\`\n  - Result: FAIL (blocking)\n  - Error: \`$(echo "$out" | head -n 2 | tr '\n' ' ' | sed 's/`/\"/g')\`"
      log_json_row "$name" "FAIL" "$(echo "$out" | head -n 4 | tr '\n' ' ')"
    fi
  fi
}

# Header
cat > "$REPORT_MD" <<EOF
# OpenClaw Skills Healthcheck Report

- Timestamp: $(date -Iseconds)
- Host: $(hostname)
- Runner: $(whoami)

## 1) Eligibility Snapshot
EOF

log_md '```bash'
if has openclaw; then
  openclaw skills check >> "$REPORT_MD" 2>&1 || true
else
  log_md 'openclaw CLI not found'
fi
log_md '```'

log_md "\n## 2) Smoke Tests for Critical Ready Skills"

# Core CLI checks
run_check "clawhub CLI" "clawhub list --workdir $HOME/.openclaw/workspace --dir skills"
run_check "GitHub CLI installed" "gh --version"
run_check "GitHub auth" "gh auth status"
run_check "gog CLI installed" "gog --help"
run_check "mcporter CLI installed" "mcporter --help"
run_check "nano-pdf CLI installed" "nano-pdf --help"
run_check "summarize CLI installed" "summarize --help"
run_check "tmux installed" "tmux -V"
run_check "ffmpeg installed (video-frames)" "ffmpeg -version | head -n 1"

# Integration checks (depends on env)
run_check "summarize model call (Gemini)" '[[ -n "${GEMINI_API_KEY:-}" ]] && echo "OpenClaw summarize smoke test" > /tmp/summarize-smoke.txt && GEMINI_API_KEY="${GEMINI_API_KEY:-}" summarize /tmp/summarize-smoke.txt --model google/gemini-3.1-pro-preview --length short >/dev/null' "warn"
run_check "gog account listing" '[[ -n "${GOG_KEYRING_PASSWORD:-}" ]] && GOG_KEYRING_PASSWORD="${GOG_KEYRING_PASSWORD:-}" gog auth list --json >/dev/null' "warn"
run_check "tavily search script" '[[ -n "${TAVILY_API_KEY:-}" ]] && TAVILY_API_KEY="${TAVILY_API_KEY:-}" node "$HOME/.openclaw/workspace/skills/tavily-search/scripts/search.mjs" "OpenClaw" -n 1 >/dev/null' "warn"

log_md "\n## 3) Summary"
log_md "- PASS: **$ok**"
log_md "- WARN: **$warn**"
log_md "- FAIL: **$fail**"

if [[ $fail -eq 0 ]]; then
  log_md "- Final Status: ✅ READY FOR IMPORTANT WORK"
else
  log_md "- Final Status: ❌ NOT READY (blocking failures exist)"
fi

# JSON report
{
  echo '{'
  echo "  \"timestamp\": $(json_escape "$(date -Iseconds)"),"
  echo "  \"host\": $(json_escape "$(hostname)"),"
  echo "  \"runner\": $(json_escape "$(whoami)"),"
  echo "  \"summary\": {\"pass\": $ok, \"warn\": $warn, \"fail\": $fail},"
  echo '  "checks": ['
} > "$REPORT_JSON"

cat "$REPORT_JSON.tmp" >> "$REPORT_JSON"
rm -f "$REPORT_JSON.tmp"
# remove last trailing comma safely
python3 - <<'PY' "$REPORT_JSON"
import json,sys
p=sys.argv[1]
text=open(p).read().rstrip()
# add closing bracket for checks array
text += '\n  ]'
# quick cleanup for trailing comma before ]
text=text.replace(',\n  ]','\n  ]')
text += '\n}\n'
open(p,'w').write(text)
# validate
json.loads(open(p).read())
PY

echo "Report generated:"
echo "- $REPORT_MD"
echo "- $REPORT_JSON"
