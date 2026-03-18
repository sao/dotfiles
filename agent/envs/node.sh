#!/usr/bin/env zsh
#
# agent/envs/node.sh
# Installs nvm and pins the Node version from .nvmrc
#

set -e

GREEN='\033[0;32m'
RESET='\033[0m'

DOTFILES="$(cd "$(dirname "$0")/../.." && pwd)"
NVM_DIR="$HOME/.nvm"
NODE_VERSION_FILE="$DOTFILES/agent/skills/node/.nvmrc"

# Install nvm if not present
if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
  echo "  Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

# Load nvm in this script context
export NVM_DIR="$NVM_DIR"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"

echo "  ${GREEN}✓${RESET} nvm $(nvm --version)"

# Pin node version from .nvmrc if present, otherwise use LTS
if [[ -f "$NODE_VERSION_FILE" ]]; then
  NODE_VERSION=$(cat "$NODE_VERSION_FILE")
  echo "  Installing Node $NODE_VERSION..."
  nvm install "$NODE_VERSION"
  nvm use "$NODE_VERSION"
  nvm alias default "$NODE_VERSION"
else
  echo "  Installing Node LTS..."
  nvm install --lts
  nvm use --lts
  nvm alias default 'lts/*'
fi

echo "  ${GREEN}✓${RESET} Node $(node --version)"

# Global packages from global-packages.txt
GLOBAL_PACKAGES_FILE="$DOTFILES/agent/skills/node/global-packages.txt"
if [[ -f "$GLOBAL_PACKAGES_FILE" ]]; then
  echo "  Installing global Node packages..."
  grep -v '^\s*#' "$GLOBAL_PACKAGES_FILE" | grep -v '^\s*$' | xargs npm install -g 2>/dev/null
  echo "  ${GREEN}✓${RESET} Global packages installed"
else
  echo "  No global-packages.txt found, skipping"
fi
