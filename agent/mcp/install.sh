#!/usr/bin/env zsh
#
# agent/mcp/install.sh
# Reads manifest.json and writes ~/.claude/claude_desktop_config.json
#
# Manifest server types:
#   npx   — remote Node package  → run via npx -y <package> <args>
#   uvx   — remote Python pkg    → run via uvx <package> <args>
#   local — local server in repo → run via node/python <path>
#

set -e

DOTFILES="$(cd "$(dirname "$0")/../.." && pwd)"
MANIFEST="$DOTFILES/agent/mcp/manifest.json"
CLAUDE_CONFIG_DIR="$HOME/.claude"
CLAUDE_CONFIG="$CLAUDE_CONFIG_DIR/claude_desktop_config.json"

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

mkdir -p "$CLAUDE_CONFIG_DIR"

# Require jq
if ! command -v jq &>/dev/null; then
  echo "  jq not found — skipping MCP install (install jq via brew)" >&2
  exit 0
fi

server_count=$(jq '.servers | length' "$MANIFEST")

if [[ "$server_count" -eq 0 ]]; then
  echo "  ${YELLOW}No servers in manifest — skipping${RESET}"
  exit 0
fi

# Build the mcpServers object from the manifest
mcp_servers=$(jq '
  .servers | map({
    key: .name,
    value: (
      if .type == "npx" then {
        command: "npx",
        args: (["-y", .package] + (.args // []))
      }
      elif .type == "uvx" then {
        command: "uvx",
        args: ([.package] + (.args // []))
      }
      elif .type == "local" then {
        command: (if .runtime == "python" then "python3" else "node" end),
        args: ([.path] + (.args // []))
      }
      else error("Unknown server type: \(.type)")
      end
      + (if .env then { env: .env } else {} end)
    )
  }) | from_entries
' "$MANIFEST")

# Merge into existing config (preserves other fields)
if [[ -f "$CLAUDE_CONFIG" ]]; then
  existing=$(cat "$CLAUDE_CONFIG")
else
  existing="{}"
fi

echo "$existing" | jq --argjson servers "$mcp_servers" \
  '. + { mcpServers: $servers }' > "$CLAUDE_CONFIG"

echo "  ${GREEN}✓${RESET} Wrote $server_count server(s) to $CLAUDE_CONFIG"
