#!/usr/bin/env zsh
#
# node/install.sh
# Installs nvm and pins the Node version from .nvmrc
#

set -e

GREEN='\033[0;32m'
RESET='\033[0m'

DOTFILES="$(cd "$(dirname "$0")/.." && pwd)"
export NVM_DIR="$HOME/.nvm"
NODE_VERSION_FILE="$DOTFILES/node/.nvmrc"

# Install nvm if not present
# PROFILE=/dev/null: shell/zshrc already loads nvm, so don't let the installer
# append to it (and ignore its "close and reopen your terminal" hint).
if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
  echo "  Installing nvm..."
  mkdir -p "$NVM_DIR"
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | PROFILE=/dev/null bash
fi

# Load nvm in this script context (--no-use: don't auto-activate a version yet)
source "$NVM_DIR/nvm.sh" --no-use

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
