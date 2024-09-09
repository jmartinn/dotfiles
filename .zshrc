#!/bin/zsh

# History
HISTFILE=~/.zsh_history
HIST_STAMPS="dd.mm.yyyy"

# Oh-My-Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 7
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
plugins=(git)

# Directories
export REPOS="$HOME/Documents/projects/"
export DOTFILES="$HOME/dotfiles"
export SCRIPTS="$HOME/scripts"
export GITUSER="YOUR_GITHUB_USERNAME"
export GHREPOS="$REPOS/github.com/$GITUSER"
export SECOND_BRAIN="$HOME/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents/personal"

# Environment variables
export NVM_DIR="$HOME/.nvm"
export BUN_INSTALL="$HOME/.bun"
export GPG_TTY=$(tty)
export EDITOR='nvim'

# PATH management
typeset -U path
path=(
    /opt/homebrew/bin
    /opt/homebrew/sbin
    $HOME/Library/Python/3.9/bin
    /opt/homebrew/opt/libpq/bin
    $SCRIPTS
    $BUN_INSTALL/bin
    $HOME/bin
    /usr/local/bin
    /opt/homebrew/opt/openjdk@17/bin
    $path
)

# Homebrew
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

# Source Oh-My-Zsh
source $ZSH/oh-my-zsh.sh

# Functions
function gclone() {
    git clone git@github.com:$GITUSER/$1.git
}

# Aliases
alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias cl="clear"
alias sb="cd $SECOND_BRAIN"
alias vim="nvim"
alias repos="cd $REPOS"
alias dots="cd $DOTFILES"
alias ls="eza"
alias ll="eza -alh"
alias tree="eza --tree"
alias cat="bat"

# Load NVM
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Performance-intensive operations (consider lazy-loading or caching)
eval "$(fzf --zsh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
