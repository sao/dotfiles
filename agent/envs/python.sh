#!/usr/bin/env zsh
#
# agent/envs/python.sh
# Installs uv and sets up the agent skill venv
#

set -e

GREEN='\033[0;32m'
RESET='\033[0m'

DOTFILES="$(cd "$(dirname "$0")/../.." && pwd)"

# Ensure Homebrew is on PATH (needed on fresh installs before shell restart)
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

SKILLS_VENV="$DOTFILES/agent/skills/python/.venv"
REQUIREMENTS="$DOTFILES/agent/skills/python/requirements.txt"

# Install uv if not present
if ! command -v uv &>/dev/null; then
  echo "  Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
fi
echo "  ${GREEN}✓${RESET} uv $(uv --version)"

# Create agent skill venv
if [[ ! -d "$SKILLS_VENV" ]]; then
  echo "  Creating agent skill venv..."
  uv venv "$SKILLS_VENV"
fi
echo "  ${GREEN}✓${RESET} venv at $SKILLS_VENV"

# Install requirements if file exists and has content
if [[ -f "$REQUIREMENTS" ]]; then
  line_count=$(grep -c . "$REQUIREMENTS" 2>/dev/null || echo 0)
  if [[ "$line_count" -gt 0 ]]; then
    echo "  Installing requirements..."
    uv pip install -r "$REQUIREMENTS" --python "$SKILLS_VENV/bin/python"
    echo "  ${GREEN}✓${RESET} Requirements installed"
  fi
fi
