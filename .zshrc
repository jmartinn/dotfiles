#!/bin/zsh

# Use emacs keybindings (Ctrl+A/E/B/F, etc.) regardless of $EDITOR
bindkey -e

# History
HISTFILE=~/.zsh_history
HIST_STAMPS="dd.mm.yyyy"

# Directories
export REPOS="$HOME/Developer/projects/"
export DOTFILES="$HOME/dotfiles"
export SCRIPTS="$HOME/scripts"
export GITUSER="jmartinn"
export GHREPOS="$REPOS/github.com/$GITUSER"
export SECOND_BRAIN="$HOME/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents/personal"

# Environment variables
export NVM_DIR="$HOME/.nvm"
export BUN_INSTALL="$HOME/.bun"
export GPG_TTY=$(tty)
export EDITOR='nvim'
export PNPM_HOME="$HOME/Library/pnpm"

# Homebrew prefix (hardcoded for performance - Apple Silicon is always /opt/homebrew)
HOMEBREW_PREFIX="/opt/homebrew"

# PATH management
typeset -U path
path=(
    $HOMEBREW_PREFIX/bin
    $HOMEBREW_PREFIX/sbin
    $HOMEBREW_PREFIX/opt/libpq/bin
    $HOMEBREW_PREFIX/opt/openjdk@17/bin
    $SCRIPTS
    $BUN_INSTALL/bin
    $PNPM_HOME
    $HOME/bin
    $HOME/.local/bin
    $HOME/.cargo/bin
    $HOME/go/bin
    $HOME/.opencode/bin
    /usr/local/bin
    $path
)

# Homebrew completions (using cached prefix)
FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:${FPATH}"

# Functions
function gclone() {
    git clone git@github.com:$GITUSER/$1.git
}

# Lazy-load NVM (loads only when nvm/node/npm/npx is called)
_nvm_lazy_load() {
    unset -f nvm node npm npx
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

nvm() {
    _nvm_lazy_load
    nvm "$@"
}

node() {
    _nvm_lazy_load
    node "$@"
}

npm() {
    _nvm_lazy_load
    npm "$@"
}

npx() {
    _nvm_lazy_load
    npx "$@"
}

# Aliases
alias zshconfig="nvim ~/.zshrc"
alias cl="clear"
alias sb="cd $SECOND_BRAIN"
alias vim="nvim"
alias repos="cd $REPOS"
alias dots="cd $DOTFILES"
alias ls="eza"
alias l="ls"
alias ll="eza -alh"
alias tree="eza --tree"
alias pn="pnpm"

# Bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# fzf integration
eval "$(fzf --zsh)"

# Starship prompt (must be last)
eval "$(starship init zsh)"
