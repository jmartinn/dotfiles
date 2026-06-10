# AGENTS.md

Guidance for AI coding agents working in this repository. `CLAUDE.md` points here — this is the single source of truth.

## Repository Overview

Personal dotfiles repository using GNU Stow for symlink management. It manages:

- **Shell**: plain zsh (no framework) with a Starship prompt
- **Terminal**: Ghostty + tmux (Tokyo Night theme across everything)
- **Window manager**: AeroSpace (`.config/aerospace/aerospace.toml`)
- **Editor**: Neovim (Lua config, lazy.nvim)
- **Packages**: Homebrew via `brew/Brewfile`
- **Runtimes**: Node via fnm (`--use-on-cd`), Bun, Go, Rust, PHP, Python

## Key Commands

```bash
# Task runner (preferred entry points)
just bootstrap        # run all setup scripts (./scripts/run)
just bootstrap-dry    # preview without executing
just stow / restow    # deploy/redeploy symlinks
just update           # brew update + upgrade + bundle
just brew-dump        # snapshot installed packages to Brewfile
just theme <variant>  # sync tokyonight variant (night/storm/moon/day) across apps

# Direct equivalents
./scripts/run [--dry] [filter]     # modular, idempotent setup scripts in scripts/runs/
brew bundle --file=brew/Brewfile
stow .                             # respects .stow-local-ignore
```

## Layout

- `.config/` — app configs (nvim, ghostty, tmux, aerospace, starship.toml, ...)
- `.zshrc`, `.gitconfig` — root-level dotfiles, stowed to `$HOME`
- `brew/Brewfile` — package manifest
- `scripts/run` + `scripts/runs/*` — setup automation (filterable, dry-runnable, idempotent)
- `bin/` — small user scripts (`theme-set`, `ghostty` CLI symlink)
- `Justfile` — daily task recipes

## Neovim Configuration

Located in `.config/nvim/`; modular Lua on lazy.nvim:

- `init.lua` — entry point, loads `lua/config/lazy.lua`
- `lua/config/` — `options.lua`, `keymaps.lua`, `autocmds.lua`, `icons.lua`, `lspsettings/` (per-server LSP settings)
- `lua/plugins/` — one file per plugin spec
- `lazy-lock.json` — plugin lockfile

LSP servers/formatters are installed through Mason (`:Mason`), formatting via conform.nvim, plugins via `:Lazy`.

## Environment

Key variables defined in `.zshrc`:

- `REPOS="$HOME/Developer/projects/"` — main development directory
- `DOTFILES="$HOME/dotfiles"` — this repository
- `GITUSER="jmartinn"`
- `EDITOR='nvim'`

## Conventions

- Commits: conventional commits, all lowercase, subject line only (no body), no AI attribution
- Making changes: edit in place (files are stowed symlinks), test in the current environment, commit
- New app config: add to `.config/<app>/`, add the package to `brew/Brewfile`, add a `scripts/runs/` script only if setup is complex, update `.stow-local-ignore` if it must not be symlinked
- Tool-generated dirs (composer, intelephense, opencode, btop, htop, fish completions...) are gitignored — don't track machine-written files
