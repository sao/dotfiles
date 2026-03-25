#!/usr/bin/env zsh
#
# python/install.sh
# Installs uv (Python package manager)
#

set -e

GREEN='\033[0;32m'
RESET='\033[0m'

# Install uv if not present
if ! command -v uv &>/dev/null; then
  echo "  Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
fi
echo "  ${GREEN}✓${RESET} uv $(uv --version)"
