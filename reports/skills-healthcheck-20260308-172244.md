# OpenClaw Skills Healthcheck Report

- Timestamp: 2026-03-08T17:22:44+08:00
- Host: VM-0-4-ubuntu
- Runner: ubuntu

## 1) Eligibility Snapshot
```bash
│
◇  Doctor warnings ────────────────────────────────────────────────────────╮
│                                                                          │
│  - channels.telegram.groupPolicy is "allowlist" but groupAllowFrom (and  │
│    allowFrom) is empty — all group messages will be silently dropped.    │
│    Add sender IDs to channels.telegram.groupAllowFrom or                 │
│    channels.telegram.allowFrom, or set groupPolicy to "open".            │
│                                                                          │
├──────────────────────────────────────────────────────────────────────────╯
Skills Status Check

Total: 56
✓ Eligible: 18
⏸ Disabled: 0
🚫 Blocked by allowlist: 0
✗ Missing requirements: 38

Ready to use:
  📦 clawhub
  📦 gh-issues
  📦 github
  📦 gog
  📦 healthcheck
  📦 mcporter
  🍌 nano-banana-pro
  📦 nano-pdf
  📦 skill-creator
  📦 summarize
  📦 tmux
  🎞️ video-frames
  📦 weather
  📦 frontend-design
  📦 multi-search-engine
  📦 proactive-agent
  📦 self-improvement
  📦 tavily

Missing requirements:
  🔐 1password (bins: op)
  📝 apple-notes (bins: memo; os: darwin)
  ⏰ apple-reminders (bins: remindctl; os: darwin)
  🐻 bear-notes (bins: grizzly; os: darwin)
  📰 blogwatcher (bins: blogwatcher)
  🫐 blucli (bins: blu)
  🫧 bluebubbles (config: channels.bluebubbles)
  📸 camsnap (bins: camsnap)
  🧩 coding-agent (anyBins: claude, codex, opencode, pi)
  🎮 discord (config: channels.discord.token)
  🎛️ eightctl (bins: eightctl)
  ♊️ gemini (bins: gemini)
  🧲 gifgrep (bins: gifgrep)
  📍 goplaces (bins: goplaces; env: GOOGLE_PLACES_API_KEY)
  📧 himalaya (bins: himalaya)
  📨 imsg (bins: imsg; os: darwin)
  📊 model-usage (bins: codexbar; os: darwin)
  📝 notion (env: NOTION_API_KEY)
  💎 obsidian (bins: obsidian-cli)
  🖼️ openai-image-gen (env: OPENAI_API_KEY)
  🎙️ openai-whisper (bins: whisper)
  ☁️ openai-whisper-api (env: OPENAI_API_KEY)
  💡 openhue (bins: openhue)
  🧿 oracle (bins: oracle)
  🛵 ordercli (bins: ordercli)
  👀 peekaboo (bins: peekaboo; os: darwin)
  🗣️ sag (bins: sag; env: ELEVENLABS_API_KEY)
  📜 session-logs (bins: rg)
  🗣️ sherpa-onnx-tts (env: SHERPA_ONNX_RUNTIME_DIR, SHERPA_ONNX_MODEL_DIR)
  💬 slack (config: channels.slack)
  🌊 songsee (bins: songsee)
  🔊 sonoscli (bins: sonos)
  🎵 spotify-player (anyBins: spogo, spotify_player)
  ✅ things-mac (bins: things; os: darwin)
  📋 trello (env: TRELLO_API_KEY, TRELLO_TOKEN)
  📞 voice-call (config: plugins.entries.voice-call.enabled)
  📱 wacli (bins: wacli)
  𝕏 xurl (bins: xurl)

Tip: use `npx clawhub` to search, install, and sync skills.
```

## 2) Smoke Tests for Critical Ready Skills
- ✅ **clawhub CLI**
  - Command: `clawhub list --workdir /home/ubuntu/.openclaw/workspace --dir skills`
  - Result: PASS
- ✅ **GitHub CLI installed**
  - Command: `gh --version`
  - Result: PASS
- ✅ **GitHub auth**
  - Command: `gh auth status`
  - Result: PASS
- ✅ **gog CLI installed**
  - Command: `gog --help`
  - Result: PASS
- ✅ **mcporter CLI installed**
  - Command: `mcporter --help`
  - Result: PASS
- ✅ **nano-pdf CLI installed**
  - Command: `nano-pdf --help`
  - Result: PASS
- ✅ **summarize CLI installed**
  - Command: `summarize --help`
  - Result: PASS
- ✅ **tmux installed**
  - Command: `tmux -V`
  - Result: PASS
- ✅ **ffmpeg installed (video-frames)**
  - Command: `ffmpeg -version | head -n 1`
  - Result: PASS
- ⚠️ **summarize model call (Gemini)**
  - Command: `[[ -n "${GEMINI_API_KEY:-}" ]] && GEMINI_API_KEY="${GEMINI_API_KEY:-}" summarize /etc/hosts --model google/gemini-3.1-pro-preview --length short >/dev/null`
  - Result: WARN (non-blocking)
  - Error: `Unsupported file type: hosts (application/octet-stream) This build can only send text or images to the model. Try a text-like file, an image, or convert this file to text first. `
- ⚠️ **gog account listing**
  - Command: `[[ -n "${GOG_KEYRING_PASSWORD:-}" ]] && GOG_KEYRING_PASSWORD="${GOG_KEYRING_PASSWORD:-}" gog auth list --json >/dev/null`
  - Result: WARN (non-blocking)
  - Error: `read token for bbbybus2@gmail.com: read token: aes.KeyUnwrap(): integrity check failed. `
- ✅ **tavily search script**
  - Command: `[[ -n "${TAVILY_API_KEY:-}" ]] && TAVILY_API_KEY="${TAVILY_API_KEY:-}" node "$HOME/.openclaw/workspace/skills/tavily-search/scripts/search.mjs" "OpenClaw" -n 1 >/dev/null`
  - Result: PASS

## 3) Summary
- PASS: **10**
- WARN: **2**
- FAIL: **0**
- Final Status: ✅ READY FOR IMPORTANT WORK
