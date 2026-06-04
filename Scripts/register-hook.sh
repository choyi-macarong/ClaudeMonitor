#!/bin/bash
INPUT="$(cat)"
CWD="$(pwd)"
NAME="$(basename "$CWD")"
TTY="$("$(dirname "$0")/claude-tty.sh")"
# session_id uniquely identifies a session even when it has no controlling tty
# (e.g. Claude Code running inside the Claude desktop app), so the overlay can
# route bubbles correctly without relying on tty or cwd.
SID="$(printf '%s' "$INPUT" | python3 -c 'import json,sys
try:
    print((json.load(sys.stdin) or {}).get("session_id", ""))
except Exception:
    print("")' 2>/dev/null)"
curl -s -X POST http://localhost:9877/register \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"$NAME\",\"cwd\":\"$CWD\",\"tty\":\"$TTY\",\"isAuto\":true,\"sessionId\":\"$SID\"}" \
  > /dev/null 2>&1
