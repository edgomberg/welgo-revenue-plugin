#!/bin/bash
# Session-start hook for the welgo-cfo-plugin.
# Pulls the bookkeeper queue count and surfaces it in stderr so Angela sees it on launch.

set -euo pipefail

WELGO_BRAIN_URL="${WELGO_BRAIN_URL:-https://mac-mini-brain.tail59326c.ts.net:3000}"
TOKEN="${WELGO_BRAIN_TOKEN:-}"

if [ -z "$TOKEN" ]; then
  echo "[welgo-cfo-plugin] WELGO_BRAIN_TOKEN not set. MCP connection will fail. Ask Ed for your token." >&2
  exit 0
fi

# Quick health + queue count via the MCP server's list_tasks endpoint.
COUNT=$(curl -fsS -m 5 \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  "$WELGO_BRAIN_URL/api/tasks?filter=bookkeeper_review&count_only=true" 2>/dev/null \
  | grep -oE '"count":[0-9]+' | head -1 | cut -d: -f2 || echo "?")

if [ "$COUNT" = "?" ] || [ -z "$COUNT" ]; then
  echo "[welgo-cfo-plugin] Could not reach Welgo Brain. Tailscale on? Token current?" >&2
  exit 0
fi

if [ "$COUNT" -gt 0 ]; then
  echo "[welgo-cfo-plugin] ${COUNT} items in your bookkeeper review queue. Run /bookkeeper-morning." >&2
fi

exit 0
