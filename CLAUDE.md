# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository using GNU Stow for symlink management. The structure manages configuration for:
- **Shell environment** (zsh with Oh-My-Zsh)
- **Terminal applications** (Ghostty, Wezterm, Tmux)
- **Development tools** (Neovim, various CLI tools)
- **Package management** (Homebrew via Brewfile)
- **Development environments** (Node.js via NVM, Bun, Python)

## Key Commands

### Setup and Installation
```bash
# Run all setup scripts
./scripts/run

# Run specific setup categories
./scripts/run --dry  # Dry run to see what would be executed
./scripts/run brew   # Filter to run only homebrew-related scripts

# Individual setup scripts (located in scripts/runs/)
./scripts/runs/setup           # Main environment setup
./scripts/runs/homebrew        # Install Homebrew packages
./scripts/runs/neovim          # Build Neovim from source
./scripts/runs/shell-setup     # Configure shell environment
```

### Package Management
```bash
# Install/update Homebrew packages
brew bundle --file=brew/Brewfile

# Generate current package lists
brew bundle dump --file=brew/Brewfile --force
brew leaves > brew/formulae.txt
brew list --cask > brew/casks.txt
```

### Stow Management
```bash
# Deploy configurations (from dotfiles directory)
stow .  # Deploy all configs using .stow-local-ignore

# Files ignored by stow: homebrew, .git, .gitignore, .DS_Store, scripts
```

## Architecture Overview

### Configuration Structure
- `.config/` - Application configurations (nvim, ghostty, tmux, etc.)
- `.zshrc` - Shell configuration with environment variables and aliases
- `brew/` - Homebrew package definitions and lists
- `scripts/` - Setup automation scripts with modular execution

### Neovim Configuration Architecture
Located in `.config/nvim/`, this is a modular Lua-based configuration:

**Core Structure:**
- `init.lua` - Main entry point with plugin specifications
- `lua/user/` - Configuration modules organized by functionality
- `lua/user/extras/` - Optional/experimental plugins
- `lazy-lock.json` - Plugin version lockfile

**Key Configuration Modules:**
- `options.lua`, `keymaps.lua`, `autocmds.lua` - Core Neovim settings
- `lspconfig.lua` + `lspsettings/` - LSP configurations per language
- `treesitter.lua`, `cmp.lua`, `telescope.lua` - Core functionality
- `mason.lua` - LSP/formatter/linter management

### Environment Management
**Key Environment Variables (defined in .zshrc):**
- `REPOS="$HOME/Developer/projects/"` - Main development directory
- `DOTFILES="$HOME/dotfiles"` - This repository location
- `GITUSER="jmartinn"` - Git username for repository operations
- `EDITOR='nvim'` - Default editor

**Development Tools:**
- Node.js via NVM (lazy-loaded)
- Bun runtime with completions
- Python 3.9 user packages
- Homebrew-managed CLI tools (eza, fzf, etc.)

### Script Execution System
The `scripts/run` system provides:
- **Filtering**: Run specific script categories
- **Dry-run mode**: Preview operations without execution  
- **Modular execution**: Each script in `runs/` handles one setup aspect
- **Idempotent operations**: Scripts can be safely re-run

## Development Workflow

### Making Configuration Changes
1. Edit configuration files in `.config/` or root-level dotfiles
2. Test changes in current environment
3. Commit changes to track configuration evolution
4. Use `stow .` to deploy changes if working from a different location

### Adding New Applications
1. Add configuration to `.config/[app-name]/`
2. Add package to `brew/Brewfile` if needed
3. Create setup script in `scripts/runs/` if complex setup required
4. Update `.stow-local-ignore` if files should not be symlinked

### Neovim Plugin Management
- Plugins defined via `spec` calls in `init.lua`
- Plugin configurations in `lua/user/[plugin-name].lua`
- Experimental plugins in `lua/user/extras/`
- Run `:Lazy` in Neovim to manage plugins
- LSP servers managed through Mason (`:Mason` command)