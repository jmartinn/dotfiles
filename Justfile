# Day-to-day task runner. `just --list` to see everything.

# Default: show available recipes
default:
    @just --list

# Run full machine setup (idempotent — safe to re-run)
bootstrap:
    ./scripts/run

# Run a specific setup category (e.g. `just bootstrap-only brew`)
bootstrap-only filter:
    ./scripts/run {{filter}}

# Preview what bootstrap would do without running it
bootstrap-dry:
    ./scripts/run --dry

# Deploy symlinks via stow
stow:
    stow .

# Remove symlinks
unstow:
    stow -D .

# Re-deploy (unstow + stow)
restow:
    stow -R .

# Show what stow would link without touching the filesystem
check:
    stow -n -v .

# Update Homebrew packages from the Brewfile
update:
    brew update
    brew upgrade
    brew bundle --file=brew/Brewfile

# Snapshot current Homebrew state back into the Brewfile
brew-dump:
    brew bundle dump --file=brew/Brewfile --force --no-vscode

# Drop regenerable tool caches (safe — tools repopulate on demand)
clean:
    rm -rf .config/opencode/node_modules
    rm -rf .config/intelephense
    rm -rf .config/mole
    @echo "Cleaned: opencode/node_modules, intelephense, mole"

# Switch Tokyo Night variant across Ghostty, tmux, Nvim, Zed (night|storm|moon|day)
theme variant:
    ./bin/theme-set {{variant}}

# Show repo status
status:
    @git status --short
    @echo ""
    @echo "Branch: $(git branch --show-current)"
    @echo "Ahead/behind: $(git rev-list --left-right --count origin/master...HEAD | awk '{print $2 " ahead, " $1 " behind origin/master"}')"
