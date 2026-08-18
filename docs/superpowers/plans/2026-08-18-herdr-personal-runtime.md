# Herdr Personal Runtime Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the existing Herdr installation reproducible from dotfiles, keep only durable configuration under version control, and install the generated user-level Herdr skill without disturbing tmux.

**Architecture:** Keep the current official direct installation at `~/.local/bin/herdr` and use Herdr's own updater; do not add a second Homebrew installation. Track a minimal `config.toml`, ignore all runtime state under `.config/herdr/`, and regenerate the user-level Claude skill from the installed binary so its instructions always match the CLI version.

**Tech Stack:** GNU Stow, Bash, Just, Herdr 0.8.x, Claude Code user skills

**Spec:** `/Users/jmartinn/Developer/projects/github.com/jmartinn/crm-platform/docs/superpowers/specs/2026-08-18-herdr-agent-delivery-workflow-design.md`

## Global Constraints

- Preserve the existing tmux installation and configuration throughout adoption.
- Keep the default Herdr session and the default `Ctrl+B` prefix.
- Track only durable configuration and generated skill instructions; never track logs, sockets, plugin locks, or `session.json`.
- Keep pane-history persistence disabled because terminal output may contain secrets.
- Use the installed Herdr binary as the authority for configuration and skill syntax.
- Do not stop the Herdr server or kill pane processes during setup.
- Preserve unrelated existing changes, including `docs/research/` and `nvim.log`.
- Execute this plan on `codex/herdr-personal-runtime` in the primary dotfiles checkout, not a Git
  worktree. This is an explicit bootstrap exception: `~/.config` resolves to that checkout, so a
  separate worktree cannot validate or reload the live Herdr config and would create a disposable
  target for the user-level skill symlink.
- The primary checkout may leave `master` only with explicit user confirmation. Do not commit,
  clean, stash, move, or delete the pre-existing `docs/research/`, `nvim.log`, or Herdr runtime files.
- Commits use lowercase conventional subjects with no body or AI attribution.

---

## Execution Bootstrap

After explicit user confirmation, create the feature branch in the primary checkout:

```bash
git -C /Users/jmartinn/dotfiles switch -c codex/herdr-personal-runtime
```

Do not create a dotfiles worktree. Initialize this plan's SDD ledger from the primary checkout and
record this ruling before Task 1:

```text
Ruling: execute the dotfiles plan on its feature branch in the primary checkout — ~/.config is a
whole-directory symlink to this checkout, so a worktree cannot exercise the live Herdr config and
would leave ~/.claude/skills/herdr pointing at a disposable directory — if wrong, rollback is to
switch the primary checkout back to master before any durable config is committed.
```

The Lead remains in `CRM Control` and read-only. Each fresh worker receives absolute dotfiles paths,
the task brief, and the instruction to stage only files named by its task.

## File Map

| File | Responsibility |
|---|---|
| `docs/superpowers/plans/2026-08-18-herdr-personal-runtime.md` | Durable execution contract and SDD recovery source. |
| `.gitignore` | Admit only durable Herdr files into Git. |
| `.config/herdr/config.toml` | Minimal personal Herdr behavior and appearance. |
| `scripts/runs/herdr` | Idempotent fresh-machine installation through Herdr's official installer. |
| `.claude/skills/herdr/SKILL.md` | Generated user-level Herdr control contract for Claude Code. |
| `Justfile` | Validation and post-update refresh entry points. |
| `README.md` | Installation ownership and safe update procedure. |

### Task 1: Durable Herdr Configuration and Runtime Hygiene

**Files:**
- Include: `docs/superpowers/plans/2026-08-18-herdr-personal-runtime.md`
- Modify: `.gitignore`
- Create: `.config/herdr/config.toml`

**Interfaces:**
- Consumes: Herdr's resolved config path, `~/.config/herdr/config.toml`.
- Produces: a Stow-managed config accepted by `herdr config check`; ignored runtime files.

- [ ] **Step 1: Record the failing hygiene checks**

Run:

```bash
test -f .config/herdr/config.toml
git check-ignore .config/herdr/herdr-client.log
git check-ignore .config/herdr/herdr-server.log
git check-ignore .config/herdr/session.json
```

Expected: at least the config existence check and runtime ignore checks fail because `.config/herdr/` is currently wholly untracked.

- [ ] **Step 2: Add narrow ignore rules**

Append this block to `.gitignore` after the tool-managed directory section:

```gitignore
# Herdr: keep durable config only; runtime state can contain secrets and machine IDs
.config/herdr/*
!.config/herdr/config.toml
```

- [ ] **Step 3: Create the minimal Herdr config**

Create `.config/herdr/config.toml` with exactly:

```toml
onboarding = false

[theme]
name = "tokyo-night"

[terminal]
new_cwd = "follow"

[ui]
confirm_close = true

[ui.toast]
delivery = "terminal"
delay_seconds = 1

[session]
resume_agents_on_restore = true

[experimental]
pane_history = false
```

- [ ] **Step 4: Validate configuration and ignore boundaries**

Run:

```bash
herdr config check
git check-ignore -q .config/herdr/herdr-client.log
git check-ignore -q .config/herdr/herdr-server.log
git check-ignore -q .config/herdr/session.json
test "$(git check-ignore .config/herdr/config.toml || true)" = ""
git status --short
```

Expected: `config: ok`; runtime files are ignored; `config.toml` is not ignored; unrelated dirty files remain untouched.

- [ ] **Step 5: Reload only the safe live configuration**

Run:

```bash
herdr server reload-config
herdr config check
tmux -V
```

Expected: Herdr reload succeeds without stopping the server, config remains valid, and tmux is still installed.

- [ ] **Step 6: Commit the durable config**

```bash
git add docs/superpowers/plans/2026-08-18-herdr-personal-runtime.md \
  .gitignore .config/herdr/config.toml
git commit -m "feat: add durable herdr config"
```

### Task 2: Reproducible Installation and Generated Skill

**Files:**
- Create: `scripts/runs/herdr`
- Create: `.claude/skills/herdr/SKILL.md`
- Modify: `Justfile`
- Modify: `README.md`

**Interfaces:**
- Consumes: `herdr --skill`, `herdr integration install`, and the direct installer at `https://herdr.dev/install.sh`.
- Produces: `just herdr-check` and `just herdr-refresh`; a fresh-machine installer that leaves an existing binary unchanged and idempotently links the tracked skill into `~/.claude/skills/herdr`.

- [ ] **Step 1: Demonstrate the missing setup surface**

Run:

```bash
test -x scripts/runs/herdr
test -f .claude/skills/herdr/SKILL.md
just --summary | tr ' ' '\n' | grep -Fx herdr-check
```

Expected: the checks fail because the installer, generated skill, and recipes do not exist.

- [ ] **Step 2: Add the idempotent direct installer**

Create `scripts/runs/herdr` with exactly:

```bash
#!/usr/bin/env bash

set -euo pipefail

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
dotfiles_dir=$(cd "$script_dir/../.." && pwd)

if command -v herdr >/dev/null 2>&1; then
  printf 'Herdr already installed: %s\n' "$(herdr --version)"
else
  printf 'Installing Herdr through the official installer...\n'
  curl -fsSL https://herdr.dev/install.sh | sh
  herdr --version
fi

skill_source="$dotfiles_dir/.claude/skills/herdr"
skill_target="$HOME/.claude/skills/herdr"
mkdir -p "$(dirname "$skill_target")"

if [ -L "$skill_target" ]; then
  if [ "$(cd "$(dirname "$skill_target")" && realpath "$(readlink "$skill_target")")" != "$skill_source" ]; then
    printf 'Refusing to replace unrelated Herdr skill symlink: %s\n' "$skill_target" >&2
    exit 1
  fi
elif [ -e "$skill_target" ]; then
  printf 'Refusing to replace existing Herdr skill path: %s\n' "$skill_target" >&2
  exit 1
else
  ln -s "$skill_source" "$skill_target"
fi
```

Then make it executable:

```bash
chmod +x scripts/runs/herdr
```

- [ ] **Step 3: Add deterministic maintenance recipes**

Append to `Justfile`:

```just

# Validate Herdr config and installed agent integrations
herdr-check:
    herdr config check
    herdr integration status

# Refresh generated integrations and the user-level skill after `herdr update`
herdr-refresh:
    herdr integration install claude
    herdr integration install codex
    mkdir -p .claude/skills/herdr
    herdr --skill > .claude/skills/herdr/SKILL.md
    herdr config check
```

- [ ] **Step 4: Generate the user-level skill from the installed binary**

Run:

```bash
mkdir -p .claude/skills/herdr
herdr --skill > .claude/skills/herdr/SKILL.md
```

Expected: the generated file begins with `name: herdr`, requires `HERDR_ENV=1`, and documents the installed CLI rather than a handwritten approximation.

- [ ] **Step 5: Document installation and update ownership**

In `README.md`, add Herdr to the Terminal bullet and add this section after "Common tasks":

````markdown
## Herdr

Herdr is installed with its official direct installer into `~/.local/bin`, not Homebrew. The
bootstrap script installs it only when missing, so it does not update or restart a live session.

When ready to update, detach from the UI and run:

```sh
herdr update
just herdr-refresh
just herdr-check
```

`herdr-refresh` reinstalls the version-matched Claude/Codex session integrations and regenerates
the user-level Herdr skill. It does not stop the server. If an update requires a protocol restart,
handle that interactively after confirming no pane process would be lost. tmux remains installed
during the Herdr adoption period.
````

- [ ] **Step 6: Validate the fresh-machine and maintenance paths**

Run:

```bash
shellcheck scripts/runs/herdr
./scripts/run --dry herdr
scripts/runs/herdr
just herdr-check
diff -u .claude/skills/herdr/SKILL.md <(herdr --skill)
test "$(realpath "$HOME/.claude/skills/herdr")" = "$(pwd)/.claude/skills/herdr"
git check-ignore -q .config/herdr/session.json
git status --short
```

Expected: ShellCheck passes; dry-run selects the Herdr setup script without installing; both integrations report `current (v7)` or the installed version's current equivalent; generated skill has no diff; runtime state stays absent from Git status.

- [ ] **Step 7: Commit installation and skill management**

```bash
git add scripts/runs/herdr .claude/skills/herdr/SKILL.md Justfile README.md
git commit -m "feat: manage herdr runtime setup"
```

### Task 3: Dotfiles Acceptance Gate

**Files:**
- Verify only; no expected file changes.

**Interfaces:**
- Consumes: Tasks 1-2.
- Produces: evidence that Herdr is reproducible, current, and isolated from runtime state.

- [ ] **Step 1: Run the complete acceptance gate**

Run:

```bash
herdr --version
herdr config check
herdr integration status --outdated-only
diff -u .claude/skills/herdr/SKILL.md <(herdr --skill)
test "$(realpath "$HOME/.config/herdr/config.toml")" = "$(pwd)/.config/herdr/config.toml"
test "$(realpath "$HOME/.claude/skills/herdr")" = "$(pwd)/.claude/skills/herdr"
git status --short
tmux -V
```

Expected: config is valid; no outdated Herdr integrations are reported; the skill matches the binary; both durable paths resolve into dotfiles; only intentionally committed or pre-existing unrelated changes remain; tmux is intact.

- [ ] **Step 2: Record handoff evidence**

Report:

```text
Herdr version:
Config validation:
Claude integration:
Codex integration:
Generated skill diff:
Runtime files visible to Git:
tmux version:
Pre-existing unrelated changes preserved:
```

Do not create a commit when acceptance produced no file changes.

Keep the primary checkout on `codex/herdr-personal-runtime` until the user chooses the finishing
strategy. After that branch is merged, switch back to `master`, fast-forward it, and rerun
`just herdr-check`; do not delete the branch or change the checkout before the finishing gate.
