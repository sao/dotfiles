# aliases.sh
# Sourced by ~/.zshrc

# ── Navigation ────────────────────────────────────────────────────────────────
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"

# ── Core utils (modernized) ───────────────────────────────────────────────────
alias ll="eza -la --git --icons"
alias ls="eza --icons"
alias lt="eza --tree --icons -L 2"
alias cat="bat --style=plain"
alias find="fd"
alias grep="rg"
alias mkdir="mkdir -p"
alias path='echo $PATH | tr -s ":" "\n"'

# ── Editor ────────────────────────────────────────────────────────────────────
alias e="$EDITOR"
alias v="$VISUAL"

# ── Git ───────────────────────────────────────────────────────────────────────
alias g="git"
alias gs="git status"
alias gd="git diff"
alias gl="git log --oneline --graph --decorate"
alias gc="git commit -v"
alias gco="git checkout"
alias gaa="git add --all"
alias gap="git add --patch"
alias gpf="git push --force-with-lease"
alias gup="git fetch origin && git rebase origin/main"

# ── Python / uv ───────────────────────────────────────────────────────────────
alias python="python3"
alias pip="pip3"
alias venv="uv venv"
alias pi="uv pip install"
alias pr="uv pip install -r"

# ── Node ──────────────────────────────────────────────────────────────────────
alias ni="npm install"
alias nr="npm run"
alias pn="pnpm"

# ── Agent / Claude ────────────────────────────────────────────────────────────
alias cc="claude --dangerously-skip-permissions"

# ── Network / HTTP ────────────────────────────────────────────────────────────
alias serve="python3 -m http.server"
alias flushdns="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder"

# ── Misc ──────────────────────────────────────────────────────────────────────
alias mcd='(){mkdir -p "$1" && cd "$1"}'
alias reload="source ~/.zshrc"
alias dotfiles="cd ~/.dotfiles"

# ── Local overrides ───────────────────────────────────────────────────────────
[[ -f ~/.aliases.local ]] && source ~/.aliases.local
