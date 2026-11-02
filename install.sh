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

# ── sudo (ask once) ───────────────────────────────────────────────────────────
# Prompt for the password a single time, then keep the sudo timestamp fresh
# in the background so Homebrew etc. don't re-prompt during long steps.
header "Administrator access"
info "You may be asked for your password once."
sudo -v
while true; do sudo -n true; sleep 50; kill -0 "$$" 2>/dev/null || exit; done 2>/dev/null &
SUDO_KEEPALIVE_PID=$!
trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null' EXIT

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
  # NONINTERACTIVE: skip the "Press RETURN" prompt; sudo is already cached above
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  success "Installed"
fi

# Ensure Homebrew is on PATH for the rest of this script
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
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
"$DOTFILES/python/install.sh"

# ── Node environment (nvm) ────────────────────────────────────────────────────
header "Node (nvm)"
"$DOTFILES/node/install.sh"

# ── macOS defaults ────────────────────────────────────────────────────────────
header "macOS Defaults"
"$DOTFILES/macos/defaults.sh"

echo "\n${GREEN}${BOLD}Done.${RESET} Starting a fresh shell to pick up all changes...\n"

# Replace this process with a new login shell so nvm, node, uv, etc. are
# available immediately (only when run interactively from a terminal).
if [[ -t 0 && -t 1 ]]; then
  kill "$SUDO_KEEPALIVE_PID" 2>/dev/null
  exec zsh -l
fi
