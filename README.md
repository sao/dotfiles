# dotfiles

Personal dotfiles for macOS. Manages shell config, git, editor, agent tooling, and MCP servers.

## Install

```zsh
git clone https://github.com/sao/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
chmod +x install.sh symlinks.sh agent/mcp/install.sh agent/envs/python.sh agent/envs/node.sh macos/defaults.sh
./install.sh
```

Open a new shell when done.

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
├── agent/
│   ├── claude/
│   │   └── settings.json   # → ~/.claude/settings.json
│   ├── mcp/
│   │   ├── manifest.json   # MCP server registry — edit this to add servers
│   │   └── install.sh      # Reads manifest → writes ~/.claude/claude_desktop_config.json
│   ├── envs/
│   │   ├── python.sh       # uv + agent skill venv
│   │   └── node.sh         # nvm + global packages
│   └── skills/
│       ├── python/
│       │   └── requirements.txt   # Python packages for agent skills
│       └── node/
│           └── .nvmrc             # Pinned Node version
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

## Adding MCP Servers

Edit `agent/mcp/manifest.json` and add an entry. Three supported types:

**npx** — remote Node package:
```json
{
  "name": "filesystem",
  "type": "npx",
  "package": "@modelcontextprotocol/server-filesystem",
  "args": ["/Users/account"]
}
```

**uvx** — remote Python package:
```json
{
  "name": "fetch",
  "type": "uvx",
  "package": "mcp-server-fetch"
}
```

**local** — server living in this repo:
```json
{
  "name": "my-tool",
  "type": "local",
  "path": "./servers/my-tool/index.js",
  "runtime": "node"
}
```

Then re-run:
```zsh
./agent/mcp/install.sh
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
