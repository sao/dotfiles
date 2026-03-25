# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Personal macOS dotfiles repo. Manages shell (zsh), git, editor (neovim), Homebrew packages, macOS defaults, language toolchains (Node, Python), and AI agent tooling (MCP servers, Claude settings).

## Key Commands

```zsh
./install.sh              # Full bootstrap (idempotent, safe to re-run)
./symlinks.sh             # Re-link dotfiles only
./agent/mcp/install.sh    # Regenerate MCP config from manifest.json
brew bundle --file=Brewfile  # Install/update Homebrew packages only
```

## Architecture

**Bootstrap flow:** `install.sh` runs everything in order: Xcode CLT → Homebrew + Brewfile → symlinks → Python env (uv) → Node env (nvm) → MCP servers → macOS defaults.

**Symlink pattern:** Config files live in this repo and get symlinked to their expected system paths (e.g., `shell/zshrc` → `~/.zshrc`). The `symlinks.sh` script handles this with `ln -sf`.

**Local overrides:** Templates in `templates/` get copied to `~/.*.local` on first install (never overwritten on re-runs). These are gitignored and sourced last in their respective configs. Git identity (`user.name`, `user.email`) must be set in `~/.gitconfig.local`.

**MCP server management:** `agent/mcp/manifest.json` is the source of truth for MCP servers. The `agent/mcp/install.sh` script reads it with `jq` and writes `~/.claude/claude_desktop_config.json`. Three server types: `npx`, `uvx`, `local`.

**Node environment:** `node/install.sh` installs nvm, pins the Node version from `node/.nvmrc`, and installs global npm packages listed in `node/global-packages.txt`.

**Python environment:** `python/install.sh` installs uv (Python package manager).

**Shell loading order:** `zshenv` (all shells, minimal) → `zshrc` (interactive: Homebrew, PATH, plugins, fzf, zoxide, direnv, nvm, uv, starship, aliases) → `*.local` overrides.

## Conventions

- Git commits follow conventional commits: `<type>(<scope>): <subject>` (see `git/gitmessage`)
- Core CLI tools are aliased to modern replacements: `ls`→`eza`, `cat`→`bat`, `find`→`fd`, `grep`→`rg`
- Git uses delta for diffs (side-by-side, line numbers), pull rebases by default, merge is fast-forward only
- All scripts use `set -e` and are idempotent
