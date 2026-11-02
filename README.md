# dotfiles

Personal dotfiles for macOS. Manages shell config, git, editor, Homebrew packages, and Node/Python toolchains.

## Install

```zsh
git clone https://github.com/sao/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x install.sh symlinks.sh node/install.sh python/install.sh macos/defaults.sh
./install.sh
```

When it finishes, it drops you into a fresh shell with everything loaded.

## Structure

```
~/.dotfiles/
├── install.sh              # Main bootstrap — run this
├── symlinks.sh             # Idempotent symlink runner
├── Brewfile                # Homebrew packages
│
├── shell/
│   ├── zshrc               # → ~/.zshrc
│   ├── zshenv              # → ~/.zshenv
│   ├── aliases.sh          # → ~/.aliases
│   ├── starship.toml       # → ~/.config/starship.toml
│   └── wezterm.lua         # → ~/.wezterm.lua
│
├── git/
│   ├── gitconfig           # → ~/.gitconfig
│   ├── gitignore           # → ~/.gitignore
│   └── gitmessage          # → ~/.gitmessage
│
├── node/
│   ├── .nvmrc              # Pinned Node version (nvm)
│   └── install.sh          # Installs nvm + Node
│
├── python/
│   └── install.sh          # Installs uv
│
├── templates/
│   ├── gitconfig.template   # → ~/.gitconfig.local (copied on first install)
│   ├── zshrc.template       # → ~/.zshrc.local
│   ├── aliases.template     # → ~/.aliases.local
│   └── zshenv.template      # → ~/.zshenv.local
│
├── macos/
│   └── defaults.sh         # macOS system preferences
│
└── misc/
    ├── hushlogin           # → ~/.hushlogin (silences login banner)
    └── rgignore            # → ~/.rgignore (global ripgrep ignores)
```

## Local Overrides

These files are **copied from templates on first install** and never overwritten on re-runs. They are gitignored — safe for machine-specific or secret config:

| File | Template | Purpose |
|---|---|---|
| `~/.gitconfig.local` | `templates/gitconfig.template` | Git identity (`user.name`, `user.email`) |
| `~/.zshrc.local` | `templates/zshrc.template` | Shell config overrides |
| `~/.aliases.local` | `templates/aliases.template` | Alias overrides |
| `~/.zshenv.local` | `templates/zshenv.template` | Env vars (no PATH changes) |

After install, edit `~/.gitconfig.local` to set your identity:
```ini
[user]
  name  = Your Name
  email = you@example.com
```

## Updating

```zsh
cd ~/.dotfiles
git pull
./install.sh
```

`install.sh` is fully idempotent — safe to re-run at any time.
