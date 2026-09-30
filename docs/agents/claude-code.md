# Lean Claude Code

Run `just claude-preview` to inspect the cleanup, then `just claude-lean` to apply
it. This is intentionally separate from bootstrap. Requires Claude Code 2.1.286
or newer for the settings used here, Python 3, and the retained skills in
`~/.agents/skills/` (Herdr comes from this repo).

The baseline lives in `.claude/user-settings.json`; global preferences live in
`.claude/CLAUDE.user.md`. The command copies them into the live user config,
preserving the model, permission mode, status line, hooks, marketplace definitions,
and custom denial rules. It removes the CRM-specific global auto-mode environment
and accumulated dotfiles permission approvals. Do not store project environment
facts in user settings: use that project's `.claude/settings.local.json` instead.

Only `code-review`, `diagnose`, `herdr`, `research`, and `tdd` remain in the user
skills directory. They are manual commands, so their descriptions do not enter
the model's context. Other skill entries are archived, without modifying their
shared sources or Pi. Plugins are disabled, not uninstalled. Bundled skills,
claude.ai skill sync and automatically fetched connectors are disabled; native
file, shell, search, web tools and compaction remain available. Existing sessions
retain already loaded context: start a fresh session after applying.

## Add capabilities where needed

Enable an installed plugin in a project's personal settings:

```sh
claude plugin enable playwright@claude-plugins-official --scope local
claude plugin enable php-lsp@claude-plugins-official --scope local
```

Use `--scope project` for a team-shared configuration. Choose one browser
integration per project. Prefer `git`/`gh` and other installed CLIs when they cover
the task. Link specialized skills into that project's `.claude/skills/` instead
of adding them globally. Reapplying the baseline disables user plugins again;
project overrides are left alone.

Use `/context`, `/skills`, and `/mcp` in a fresh session to inspect what actually
loaded. `/doctor` remains available with bundled skills disabled. Skill bodies
normally load on demand; the savings here come from fewer advertised descriptions,
plugin tools, hooks, and overlapping workflows, not from deleting skill text.

For long tasks, keep a short handoff with decisions, relevant files, checks and
next steps before `/compact`. Start a new session for a different task. Keep
`CLAUDE.md` focused on facts and durable conventions; put procedures in explicit
skills or reference docs. Automatic compaction stays capped at 200k tokens and
automatic memory stays off.

## Undo

Each application prints a private `~/.claude/backups/lean-<timestamp>/` directory.
Restore `settings.json` and `CLAUDE.md` from it to `~/.claude/`. Move the entries
under its `skills/` back to `~/.claude/skills/` (their archived symlinks use absolute
targets). Restore `dotfiles-settings.local.json` to this repo's
`.claude/settings.local.json` if needed. The original skill sources, installed
plugins, authentication and session history remain available.

References: [skill visibility](https://code.claude.com/docs/en/skills#override-skill-visibility-from-settings),
[plugin scopes](https://code.claude.com/docs/en/discover-plugins),
[connector controls](https://code.claude.com/docs/en/mcp#disable-claudeai-connectors).
