#!/usr/bin/env zsh
#
# symlinks.sh — create symlinks from dotfiles repo to expected system paths
# Idempotent: uses ln -sf (overwrites stale links safely)
#

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

GREEN='\033[0;32m'
RESET='\033[0m'

link() {
  local src="$1"
  local dst="$2"
  local dst_dir
  dst_dir="$(dirname "$dst")"
  mkdir -p "$dst_dir"
  ln -sf "$src" "$dst"
  echo "  ${GREEN}→${RESET} $dst"
}

echo "Linking shell configs..."
link "$DOTFILES/shell/zshrc"   "$HOME/.zshrc"
link "$DOTFILES/shell/zshenv"  "$HOME/.zshenv"
link "$DOTFILES/shell/aliases.sh" "$HOME/.aliases"

echo "Linking git configs..."
link "$DOTFILES/git/gitconfig"   "$HOME/.gitconfig"
link "$DOTFILES/git/gitignore"   "$HOME/.gitignore"
link "$DOTFILES/git/gitmessage"  "$HOME/.gitmessage"

echo "Linking agent configs..."
link "$DOTFILES/agent/claude/settings.json" "$HOME/.claude/settings.json"

echo "Linking misc..."
link "$DOTFILES/misc/hushlogin"  "$HOME/.hushlogin"
link "$DOTFILES/misc/rgignore"   "$HOME/.rgignore"

echo "Linking starship config..."
mkdir -p "$HOME/.config"
link "$DOTFILES/shell/starship.toml" "$HOME/.config/starship.toml"

echo "Linking ghostty config..."
mkdir -p "$HOME/.config/ghostty"
link "$DOTFILES/shell/ghostty.config" "$HOME/.config/ghostty/config"

echo "Linking wezterm config..."
link "$DOTFILES/shell/wezterm.lua" "$HOME/.wezterm.lua"
