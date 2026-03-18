#!/usr/bin/env zsh
#
# install.sh — dotfiles bootstrap
# Idempotent. Safe to run multiple times.
#

set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

# ── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

info()    { echo "${BLUE}▸${RESET} $*"; }
success() { echo "${GREEN}✓${RESET} $*"; }
warn()    { echo "${YELLOW}⚠${RESET} $*"; }
error()   { echo "${RED}✗${RESET} $*" >&2; }
header()  { echo "\n${BOLD}$*${RESET}"; }

# ── Xcode Command Line Tools ───────────────────────────────────────────────────
header "Xcode Command Line Tools"
if xcode-select -p &>/dev/null; then
  success "Already installed"
else
  info "Installing..."
  xcode-select --install
  # Wait for user to complete the GUI installer
  until xcode-select -p &>/dev/null; do sleep 5; done
  success "Installed"
fi

# ── Homebrew ──────────────────────────────────────────────────────────────────
header "Homebrew"
if command -v brew &>/dev/null; then
  success "Already installed"
else
  info "Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  success "Installed"
fi

info "Running brew bundle..."
brew bundle --file="$DOTFILES/Brewfile"
success "Brewfile applied"

# ── Symlinks ──────────────────────────────────────────────────────────────────
header "Symlinks"
"$DOTFILES/symlinks.sh"

# ── Local overrides (copy templates, never overwrite) ────────────────────────
header "Local Overrides"
copy_template() {
  local src="$1" dst="$2"
  if [[ -f "$dst" ]]; then
    success "Already exists: $dst"
  else
    cp "$src" "$dst"
    info "Created $dst — edit to add your personal config"
  fi
}

copy_template "$DOTFILES/templates/gitconfig.template" "$HOME/.gitconfig.local"
copy_template "$DOTFILES/templates/zshrc.template"     "$HOME/.zshrc.local"
copy_template "$DOTFILES/templates/aliases.template"    "$HOME/.aliases.local"
copy_template "$DOTFILES/templates/zshenv.template"     "$HOME/.zshenv.local"

# ── Python environment (uv) ───────────────────────────────────────────────────
header "Python (uv)"
"$DOTFILES/agent/envs/python.sh"

# ── Node environment (nvm) ────────────────────────────────────────────────────
header "Node (nvm)"
"$DOTFILES/agent/envs/node.sh"

# ── MCP servers ───────────────────────────────────────────────────────────────
header "MCP Servers"
"$DOTFILES/agent/mcp/install.sh"

# ── macOS defaults ────────────────────────────────────────────────────────────
header "macOS Defaults"
"$DOTFILES/macos/defaults.sh"

echo "\n${GREEN}${BOLD}Done.${RESET} Open a new shell to pick up all changes.\n"
