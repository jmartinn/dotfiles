#!/bin/sh

# history
HISTFILE=~/.zsh_history

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Directories
export REPOS="$HOME/Documents/projects/"
export DOTFILES="$HOME/dotfiles"
export SCRIPTS="$HOME/scripts"
export GITUSER="jmartinn"
export GHREPOS="$REPOS/github.com/$GITUSER"
export SECOND_BRAIN="$HOME/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents/personal"

export NVM_DIR="$HOME/.nvm"
export BUN_INSTALL="$HOME/.bun"

# GPG
export GPG_TTY=$(tty)

# Consolidated PATH assignment
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/Users/johnny/Library/Python/3.9/bin:/opt/homebrew/opt/libpq/bin:$SCRIPTS:$BUN_INSTALL/bin/:$HOME/bin:/usr/local/bin:$PATH"

source $(brew --prefix nvm)/nvm.sh

# Set name of the theme to load
ZSH_THEME="robbyrussell"

zstyle ':omz:update' mode auto      # update automatically without asking

# Auto-update frequency
zstyle ':omz:update' frequency 7

# Command autocorrection
ENABLE_CORRECTION="true"

COMPLETION_WAITING_DOTS="true"

# Timestamp
HIST_STAMPS="dd.mm.yyyy"

# Plugin settings
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi

# Functions
function gclone() {
  git clone git@github.com:jmartinn/$1.git
}

# Personal aliases
alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias cl="clear"

alias sb="cd $SECOND_BRAIN"
alias vim="nvim"
alias repos="cd $REPOS"

alias ls="eza"
alias ll="eza -alh"
alias tree="eza --tree"
alias cat="bat"

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

eval "$(/opt/homebrew/bin/brew shellenv)"

# bun completions
[ -s "/Users/johnny/.bun/_bun" ] && source "/Users/johnny/.bun/_bun"
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
