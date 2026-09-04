# Herdr spaces, tabs, panes, worktrees, and agents

Research snapshot: 2026-08-28 (Europe/Madrid)
Installed runtime: `herdr 0.8.2`

## Short answer

In the current Herdr UI, a **Space** is the human-facing name for what the CLI and API call a
**workspace**. It is the top-level project or work-context container. A **tab** is one named
terminal layout inside that Space, and a **pane** is one real terminal inside a tab. A Git
**worktree** is not another layout primitive: Herdr opens a Git checkout as an ordinary workspace
with worktree provenance. An **agent** is a process Herdr recognizes inside a pane. ([Herdr
concepts](https://herdr.dev/docs/concepts/), [CLI
reference](https://herdr.dev/docs/cli-reference/), installed `herdr --help`, `herdr workspace`,
`herdr tab`, `herdr pane`, `herdr worktree`, and `herdr agent`)

The naming mismatch is deliberate compatibility rather than two different objects. The UI and
configuration call the sidebar entries **Spaces** (`ui.sidebar.spaces`, `agent_panel_sort =
"spaces"`), while CLI commands and identifiers remain `workspace` / `w1`. The config reference
explicitly says that `"workspaces"` is accepted as an alias for the `"spaces"` sorting value.
([config reference](https://herdr.dev/docs/config-reference/), local
`.config/herdr/config.toml`)

## The hierarchy

```text
Herdr session/server namespace
└── Space (CLI/API: workspace; w1)
    ├── Tab (w1:t1)
    │   ├── Pane (w1:p1) ── shell, test, server, editor, or recognized agent
    │   └── Pane (w1:p2)
    └── Tab (w1:t2)
        └── Pane (w1:p3)
```

| Primitive | What it owns | Use it for |
|---|---|---|
| Space / workspace | Tabs, panes, cwd/work context, rolled-up agent state | One repo, task, or investigation |
| Tab | One pane layout inside a Space | A view or role within that context: agents, logs, server, review |
| Pane | One real persistent terminal | A shell, agent CLI, server, test runner, editor, or log tail |
| Worktree workspace | A normal Space plus Git-checkout provenance | Isolated branch work that must not mutate the canonical checkout |
| Agent | A recognized process occupying a pane | Semantic `blocked`, `working`, `done`, `idle`, or `unknown` state and agent-oriented control |
| Named session | A separate server namespace, socket, panes, and persisted runtime state | Strong separation; not ordinary project organization |

Herdr's first-party decision rule is unusually explicit: “Use one workspace per repo, task, or
investigation”; use tabs for views such as `agents`, `logs`, `server`, or `review`; and “Use
workspaces first” before named sessions. ([concepts](https://herdr.dev/docs/concepts/))

Creating a workspace also creates its first tab and root pane. Creating another tab adds another
layout to the same workspace. Creating a worktree creates or opens a Git checkout, opens it as a
workspace, and groups it with the parent repository workspace. Closing only the Herdr workspace
does not delete the checkout; `herdr worktree remove` is the separate checkout-removal operation.
([CLI reference: workspaces, worktrees, and
tabs](https://herdr.dev/docs/cli-reference/#workspaces))

## Space versus tab: practical rule

Use a **new tab** when the work shares all of these with the existing Space:

- the same repo or operational context;
- the same checkout and mutation boundary;
- the same lifecycle and cleanup moment;
- a different view, tool, or long-running process is all that is needed.

Examples: app server, logs, test shell, read-only review, or a human shell alongside the Lead.

Use a **new Space** when any of these changes:

- it is a distinct task or investigation that should be independently focusable and closable;
- it needs a different repository or checkout;
- it needs a Git worktree and branch;
- it needs its own tabs, agents, attention state, or cleanup lifecycle.

Use a **named session** only when the whole runtime namespace must be separate—different sockets,
panes, and restored state—not merely because the project or task is different. ([Herdr
concepts](https://herdr.dev/docs/concepts/#session))

The generated Herdr agent skill adds a conservative automation default: an agent should normally
create a sibling pane in the current tab and cwd, and should not invent a workspace, tab, worktree,
or different cwd unless the requested topology or location warrants it. That is an automation
guard against unnecessary layout, not a claim that humans should keep every activity in one tab.
(local `.claude/skills/herdr/SKILL.md`, “Start and coordinate an agent”)

## What `CRM Control` means in this project

`CRM Control` is project convention layered on top of Herdr; Herdr itself does not assign meanings
to tab names. It is the persistent control Space rooted at the canonical CRM checkout on clean
`master`. The binding project workflow defines:

| Tab | Project-defined job |
|---|---|
| `Lead` | Long-lived Claude Code coordinator: orient, adjudicate, dispatch, and prepare shipping |
| `Desk` | Human shell for Git, GitHub, Todoist, navigation, and read-only inspection |
| `Ops` | On-demand deployment, recovery, or infrastructure operations |

Sources: CRM
[`docs/workflow/agent-delivery.md`](/Users/jmartinn/Developer/projects/github.com/jmartinn/crm-platform/docs/workflow/agent-delivery.md)
and the binding
[`2026-08-18 design`](/Users/jmartinn/Developer/projects/github.com/jmartinn/crm-platform/docs/superpowers/specs/2026-08-18-herdr-agent-delivery-workflow-design.md).

`Editor` is **not** part of the binding CRM topology. No repository workflow document assigns it a
role. It is therefore a user-created convenience tab unless and until the project contract is
changed. The safest interpretation is a human editor/scratch shell on the canonical checkout—not
an implementation lane. Feature or workflow changes must not be authored there because `CRM
Control` is intentionally kept clean while task work happens in isolated worktree Spaces.

For implementation, `/start-slice <issue-or-meta>` creates an ephemeral worktree Space with these
project-defined tabs:

| Tab | Project-defined job |
|---|---|
| `Plan` | Fresh Planner; sole spec/plan writer |
| `Writer` | Fresh implementation agent; sole source-code writer |
| `Verify` | Serialized tests and quality gates |
| `Runtime` | Optional PHP/Vite server and logs |
| `Review` | Post-freeze read-only Codex reviewer |

These names are roles, not special Herdr tab types. Herdr only supplies the topology and agent
state; the CRM workflow supplies the ownership rules.

## An unrelated task inside the CRM project

The correct home depends on whether it can mutate the CRM repository or only external systems.

### Read-only investigation or external-only administration

Use a separate, explicitly named Space with a fresh agent process so the investigation has its own
attention state and does not consume or contaminate the long-lived Lead's context. Keep it
read-only against the CRM checkout. A tab in `CRM Control` is reasonable only for a small human
shell/view that shares the control context; a substantial investigation deserves a Space under
Herdr's “one workspace per repo, task, or investigation” guidance.

This may run while the delivery lifecycle is active only if it cannot edit the repository, branch,
worktree, test database, or workflow-owned external state. The CRM-specific one-active-writer rule
still governs the project even though Herdr can technically host many agents.

### Anything that changes repository files

Use the CRM lifecycle and an isolated worktree Space. If the task is workflow/tooling rather than a
GitHub product issue, give it an explicitly approved `meta-<slug>` identifier. Under the current
single-Writer policy it should be sequenced after the active slice, not started concurrently.

### Example: migrate project planning from Todoist/GitHub Project to Linear

This is not a casual `Ops` command. The current repository authority contract says GitHub Project
owns stakeholder priority/delivery stage and Todoist owns personal attention. Replacing GitHub
Project changes durable governance and source-of-truth rules, and mirroring boards mutates external
systems. Treat it as two bounded phases:

1. **Independent discovery Space, read-only.** Use a fresh agent to inventory Todoist and GitHub
   Project fields, statuses, automations, issue links, ownership, and archival/rollback needs. It
   should produce a proposed Linear schema and migration/reconciliation plan without creating or
   changing Linear, Todoist, GitHub, or repository data.
2. **Approved execution.** After the mapping and cutover decision are approved, perform the
   external migration with an explicit rollback/reconciliation boundary. If the authority contract
   or workflow docs change, land those repository edits through a sequential meta slice such as
   `meta-linear-migration`; do not edit them in `CRM Control` or in the discovery Space.

That split lets the Linear investigation proceed without interrupting the active code workflow,
while preserving the rule that there is one source-code writer and that authority changes are
reviewable repository changes.

## Commands that reveal the model

The installed 0.8.2 CLI is the syntax authority:

```bash
herdr --version
herdr --help
herdr workspace
herdr tab
herdr pane
herdr worktree
herdr agent
```

Important discovery commands from those help screens:

```bash
herdr workspace list
herdr tab list --workspace <workspace-id>
herdr pane list --workspace <workspace-id>
herdr agent list
herdr worktree list --cwd <repo>
```

Run control commands from a Herdr-managed pane and use returned JSON IDs rather than predicting
them. Workspaces, tabs, and panes have stable opaque IDs such as `w1`, `w1:t1`, and `w1:p1`.
(installed `.claude/skills/herdr/SKILL.md`, “Use IDs and caller context”)

## Sources

- [Herdr concepts](https://herdr.dev/docs/concepts/)
- [Herdr CLI reference](https://herdr.dev/docs/cli-reference/)
- [Herdr configuration reference](https://herdr.dev/docs/config-reference/)
- Installed `herdr 0.8.2` help output and generated
  [Herdr skill](/Users/jmartinn/dotfiles/.claude/skills/herdr/SKILL.md)
- CRM [agent delivery workflow](/Users/jmartinn/Developer/projects/github.com/jmartinn/crm-platform/docs/workflow/agent-delivery.md)
- CRM [workflow design](/Users/jmartinn/Developer/projects/github.com/jmartinn/crm-platform/docs/superpowers/specs/2026-08-18-herdr-agent-delivery-workflow-design.md)
