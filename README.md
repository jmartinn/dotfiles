# dotfiles

Personal macOS development environment, managed with [GNU Stow](https://www.gnu.org/software/stow/) for symlink deployment.

## What's in here

- **Shell** — zsh + [Starship](https://starship.rs/) prompt
- **Terminal** — [Ghostty](https://ghostty.org/) (primary) + [tmux](https://github.com/tmux/tmux)
- **Editor** — [Neovim](https://neovim.io/) with a Lua-based config
- **WM** — [AeroSpace](https://github.com/nikitabobko/AeroSpace) tiling window manager
- **Tooling** — Homebrew for packages, [fnm](https://github.com/Schniz/fnm) for Node, [Bun](https://bun.sh/) for JS runtime, [Just](https://github.com/casey/just) for task running

## Fresh-machine setup

```sh
# 1. Clone into ~/dotfiles
git clone git@github.com:jmartinn/dotfiles.git ~/dotfiles && cd ~/dotfiles

# 2. Bootstrap (installs Homebrew, runs all setup scripts)
./scripts/run

# 3. Deploy symlinks
stow .
```

Once `just` is installed (from step 2), prefer `just <verb>` for everyday tasks — see `just --list`.

## Layout

```
.config/         Application configs (nvim, ghostty, tmux, aerospace, …)
.zshrc           Shell config
brew/Brewfile    Homebrew package definitions
scripts/         Setup orchestration
  run            Entrypoint, supports filter + --dry
  runs/          Modular setup scripts (homebrew, fonts, ssh-gpg, …)
Justfile         Day-to-day task runner
CLAUDE.md        Guidance for Claude Code sessions
```

## Common tasks

| Command | What it does |
|---|---|
| `just bootstrap` | Run full machine setup |
| `just stow` | Deploy symlinks |
| `just check` | Dry-run stow (see what would change) |
| `just update` | brew update + upgrade + bundle install |
| `just brew-dump` | Refresh `brew/Brewfile` from current state |
| `just clean` | Clear caches / regenerable tool dirs |

## License

See `.config/nvim/LICENSE` for the Neovim config; the rest is MIT-style "do what you want."
