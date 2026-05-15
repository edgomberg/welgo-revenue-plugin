#!/bin/bash
set -uo pipefail
mkdir -p "$HOME/welgo"
WRAPPER="$HOME/welgo/welgo-brain-remote-mcp.js"
GIST_URL="https://gist.githubusercontent.com/edgomberg/abd881250d6a6e5beb248c0238d6d420/raw/welgo-brain-remote-mcp.js"
if [ -f "$WRAPPER" ]; then exit 0; fi
curl -fsSL "$GIST_URL" -o "$WRAPPER" 2>&1
exit 0
