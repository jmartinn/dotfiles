# Herdr foundations for a long-time tmux user

Research snapshot: 2026-08-17 (Europe/Madrid)

## Short answer

Herdr is a terminal multiplexer and agent runtime. Like tmux, a background server owns real terminal processes while clients attach and detach. Its distinctive layer is that it recognizes coding agents inside panes, labels them `working`, `blocked`, `done`, or `idle`, rolls that state up by project, and exposes agent-oriented operations such as start, prompt, read, and wait through a CLI and local socket API. Herdr explicitly says that it does not replace Claude Code, Codex, or other agent harnesses; it owns the terminals in which they run. ([Herdr README](https://github.com/herdrdev/herdr), [concepts](https://herdr.dev/docs/concepts/), [agent automation](https://herdr.dev/docs/agent-automation/))

The DHH screenshots show Claude Code's own subagent machinery, not evidence that Herdr caused Claude and Codex to communicate. DHH's prompt tells Claude to "Use subagents" and later to "review with codex xhigh"; his follow-up screenshot shows six `general-purpose` workers in Claude Code's background-agent panel. Claude Code documents `general-purpose` as a built-in subagent and documents that background subagents run concurrently and report results to the parent session. ([DHH's post](https://x.com/dhh/status/2088540579118403778), [DHH's follow-up](https://x.com/dhh/status/2088541368628994529), [Claude Code subagents](https://code.claude.com/docs/en/sub-agents), [parallel agents](https://code.claude.com/docs/en/agents))

The exact Claude-to-Codex bridge is **not visible in the post**. DHH has separately confirmed that Herdr is now his multiplexer and agent-wrangling environment, so Herdr likely hosts the cropped Claude session, but that still does not establish how its later Codex review is invoked. Codex officially supports non-interactive use with `codex exec PROMPT`, so Claude Code's Bash tool is sufficient; MCP, a skill, or Herdr are other possible bridges. No public configuration is linked in the thread, so claiming the exact mechanism would be guesswork. ([DHH on Herdr](https://x.com/dhh/status/2086800941173416282), [DHH's Herdr setup](https://x.com/dhh/status/2087558655818289629), [Codex non-interactive mode](https://github.com/openai/codex/blob/main/codex-rs/README.md#codex-exec-to-run-codex-programmaticallynon-interactively), [Claude Code tool model](https://code.claude.com/docs/en/agent-sdk/agent-loop#tool-execution))

## The layers people conflate

| Layer | Job | Examples here |
| --- | --- | --- |
| Model | Produces reasoning and language/tool decisions | Claude; an OpenAI GPT/Codex model |
| Agent harness | Runs the model in a tool-use loop with permissions, repository context, session state, and UI | Claude Code; Codex CLI |
| Orchestrator | Splits work, launches workers, waits, combines results, and may route between different harnesses | Claude Code subagents; a shell script; an MCP tool; a Herdr-aware agent |
| Terminal runtime | Owns PTYs and keeps interactive processes available | tmux; Herdr |

Claude Code's documented agent loop is: evaluate the prompt, request tools, execute them, feed results back, and repeat until the model returns without another tool call. Herdr sits beneath that loop and keeps its terminal process alive and observable; it is not itself the model or the loop. ([Claude Code agent loop](https://code.claude.com/docs/en/agent-sdk/agent-loop), [Herdr runtime position](https://herdr.dev/blog/coding-agents-are-becoming-runtimes/))

## Translating the tmux mental model

The mapping is approximate because Herdr adds a project layer and does not reproduce tmux's object model exactly. tmux officially groups panes into windows and windows into sessions; Herdr recommends workspaces first and reserves named sessions for separate runtime namespaces. ([tmux concepts](https://github.com/tmux/tmux/wiki/Getting-Started#sessions-windows-and-panes), [Herdr concepts](https://herdr.dev/docs/concepts/))

| tmux concept | Closest Herdr concept | Important difference |
| --- | --- | --- |
| server | server | Both own terminal processes in the background. |
| session used as a project | workspace | A workspace is Herdr's top-level repo/task container and carries rolled-up agent state. |
| window | tab | A tab is a pane layout inside one workspace. |
| pane | pane | Both are real terminals containing running programs. |
| attached client | client | Detaching the UI leaves server-owned processes running. |
| separate tmux server/socket | named Herdr session | A Herdr session is a separate server namespace with its own panes, socket, and persisted runtime state; the docs recommend workspaces for ordinary project separation. |
| no native equivalent | agent | A recognized process inside a pane, with semantic state and an addressable API target. |

The default interaction is deliberately familiar: `ctrl+b` is the prefix; `prefix+c` creates a tab, `prefix+n`/`prefix+p` change tabs, `prefix+v` splits right, `prefix+-` splits down, `prefix+w` opens workspace navigation, and `prefix+q` detaches. Herdr also makes click, drag, selection, and right-click menus first-class. ([quick start](https://herdr.dev/docs/quick-start/), [keyboard guide](https://herdr.dev/docs/keyboard/))

## How Herdr works

1. `herdr` launches or attaches a client to a background session. The server owns PTYs, panes, and processes; closing or detaching the client does not stop them. ([concepts](https://herdr.dev/docs/concepts/#client-and-server), [quick start](https://herdr.dev/docs/quick-start/#detach-and-come-back))
2. Workspaces contain tabs; tabs contain pane layouts; panes contain shells, servers, tests, or agent CLIs. ([concepts](https://herdr.dev/docs/concepts/))
3. Herdr detects a supported agent from the foreground process, then derives state from lifecycle integrations where available or from the live bottom of the terminal screen. ([agents](https://herdr.dev/docs/agents/#status-authority))
4. State rolls upward, so one blocked agent marks its pane, tab, and workspace as needing attention. ([agents](https://herdr.dev/docs/agents/#state-rollups))
5. Humans, scripts, or agents can use the same local control surface to create layout, send input, read output, and wait for an agent state or output match. ([agent automation](https://herdr.dev/docs/agent-automation/), [socket API](https://herdr.dev/docs/socket-api/))

For Claude Code and Codex specifically, Herdr currently uses terminal-screen manifests—not complete lifecycle hooks—as the authority for `idle`, `working`, and `blocked`. Their optional integrations report native session identity so Herdr can resume the correct conversation after a cold server restart. A new or unusual prompt can therefore be shown as `idle` instead of `blocked` until the detection manifest understands that screen shape. ([agent support matrix and blocked-state caveat](https://herdr.dev/docs/agents/#supported-agents), [integrations](https://herdr.dev/docs/integrations/#how-herdr-uses-integrations))

## What Herdr adds over tmux

| Area | tmux | Herdr |
| --- | --- | --- |
| Persistent terminals | Yes | Yes |
| Detach, reattach, SSH | Yes | Yes |
| Sees an agent semantically | No; it sees a program in a pane | Recognizes supported agents and classifies attention state |
| Fleet overview | Tree/status can show terminal metadata | Sidebar rolls agent state up by tab and workspace |
| Automation primitive | General terminal scripting such as send/capture | Raw pane operations plus agent start, prompt, read, attach, and semantic wait |
| Project isolation | User-defined session/window convention | First-class workspaces and Git worktree creation/opening |
| Agent cold restore | User scripting | Official integrations can resume native Claude Code and Codex session IDs |

The persistence row is not the differentiator: both tools already solve it. Herdr's value begins when several long-running agents make "which terminal needs me?" more important than "which pane exists?" Its official comparison frames the difference the same way: tmux persists terminals, while Herdr adds agent identity, state, waits, and API control. ([Herdr comparison](https://herdr.dev/compare/), [tmux architecture](https://github.com/tmux/tmux/wiki/Getting-Started))

## Costs and limits worth knowing before switching

- It is not a drop-in tmux configuration replacement. Herdr has its own TOML config, commands, hierarchy, sidebar, and keybinding schema; a decade of `.tmux.conf` formats, hooks, scripts, and plugins must be evaluated and translated individually. Herdr's own agent guide explicitly warns not to give tmux commands or tmux config syntax for Herdr. ([configuration](https://herdr.dev/docs/configuration/), [agent guide](https://github.com/herdrdev/herdr/blob/master/website/agent-guide.md))
- Agent status is only as strong as the signal. Claude Code and Codex state is currently inferred from their visible terminal UI, so UI changes can temporarily cause a false `idle`; the session integration improves restoration but does not make their lifecycle status authoritative. ([agents](https://herdr.dev/docs/agents/#status-authority))
- Detach is strong persistence; a cold server restart is reconstruction. The original arbitrary shell, test, and server processes are gone after a server stop. Herdr restores layout, and only supported agents with current integrations can resume their native conversations. ([session state](https://herdr.dev/docs/session-state/))
- Live server handoff is experimental and opt-in. It does not apply to Homebrew, mise, or Nix upgrades, and in-flight waits/API calls may be interrupted even when process handoff succeeds. ([session state](https://herdr.dev/docs/session-state/#live-handoff), [install/update behavior](https://herdr.dev/docs/install/))
- Integrations mutate other tools' configuration. The Claude installer writes a hook and updates `settings.json`; the Codex installer writes a hook, updates `hooks.json`, and enables Codex hooks in `config.toml`. Review those changes instead of treating integration install as a no-op. ([Claude and Codex integration details](https://herdr.dev/docs/integrations/#claude-code))
- Herdr is currently a pre-1.0 project; the current stable release in this snapshot is v0.8.0. That is not evidence of poor quality, but it is a sensible reason to trial it alongside a mature tmux setup before migrating every customization. ([v0.8.0 release](https://github.com/herdrdev/herdr/releases/tag/v0.8.0))

Herdr can be run from inside an outer tmux environment, which makes a gradual trial possible. The reverse nesting is problematic for agent awareness: if a Herdr pane launches tmux, Herdr sees `tmux` as the foreground process and does not inspect the inner tmux session for agents. ([agent detection and tmux nesting](https://herdr.dev/docs/agents/#detection-manifests))

## What DHH's screenshots establish—and what they do not

The first image is a Claude Code prompt asking one parent session to triage issues with subagents, isolate fixes, have Codex review at `xhigh`, and open pull requests. The self-reply shows Claude reporting background agents, including a list of `general-purpose` workers. That matches Claude Code's documented native subagent behavior: separate contexts, concurrent background execution, and summaries returned to the parent. ([DHH's post](https://x.com/dhh/status/2088540579118403778), [follow-up image](https://x.com/dhh/status/2088541368628994529), [subagent documentation](https://code.claude.com/docs/en/sub-agents))

The prompt image says "subtree," but Claude's follow-up says it is setting up a worktree, and DHH later clarifies "One tree per agent" as the point of worktrees. The intended isolation mechanism is therefore Git worktrees: separate checkouts for concurrent writers, not Git's unrelated subtree feature. ([DHH's worktree clarification](https://x.com/dhh/status/2088547601536700431), [Claude parallel worktree guidance](https://code.claude.com/docs/en/agents))

`xhigh` is a reasoning-effort setting, not a separate agent or communication protocol. OpenAI's model guidance treats higher effort as a quality/latency/cost tradeoff and recommends `high` or `xhigh` only where representative evaluation shows a gain. ([OpenAI model guidance](https://developers.openai.com/api/docs/guides/latest-model))

The screenshots do **not** show:

- Herdr's sidebar, CLI, socket API, or an agent running in a separate Herdr pane.
- The command, skill, MCP server, or config that turns "review with codex xhigh" into an actual Codex invocation.
- Codex participating in the six initial triage workers; those workers are labeled as Claude Code `general-purpose` agents.

Therefore the careful conclusion is: native Claude Code created the visible triage fan-out; a later Codex review was requested, but the bridge is undisclosed. Herdr may have been the outer terminal runtime off-screen, but nothing in the post requires it.

There is strong first-party evidence for the narrower claim that Herdr is DHH's current outer environment: he said he was bringing Herdr to parity with his tmux configuration for Omarchy, answered "Herdr, now" when asked about the pictured terminal setup, and called Foot plus Herdr his agent-wrangling setup. This makes off-screen Herdr hosting likely, while leaving the Codex invocation mechanism unresolved. ([Herdr/tmux parity post](https://x.com/dhh/status/2086539415682224565), ["Herdr, now" post](https://x.com/dhh/status/2086800941173416282), [Foot + Herdr post](https://x.com/dhh/status/2087558655818289629))

Herdr **can** implement such a bridge. Its official automation recipe creates another pane, starts a named Codex reviewer, prompts it, waits for its semantic state, and reads the result. That is explicit terminal-level orchestration: one agent or script calls Herdr's control surface; Herdr does not make heterogeneous agents discover or converse with each other spontaneously. ([Herdr agent automation recipe](https://herdr.dev/docs/agent-automation/#recipes))

## Crons, loops, and graphs in this context

These are automation concepts, not Herdr hierarchy objects. They come directly from the same X thread: after someone suggested putting the morning workflow in cron, DHH replied, "Crons -> Loops -> Graphs!!" and said it would eventually be automated. The definitions below interpret that progression; DHH did not publish an implementation in the thread. ([DHH's reply](https://x.com/dhh/status/2088547757480960450))

### Agent loop

An agent loop is the inner execution cycle of one agent task: model evaluates state, requests a tool, the harness executes it, the result returns to the model, and the cycle repeats until a final response or limit. Claude Code and the OpenAI Agents SDK both document this pattern. ([Claude Code agent loop](https://code.claude.com/docs/en/agent-sdk/agent-loop), [OpenAI runner loop](https://openai.github.io/openai-agents-python/running_agents/#the-agent-loop))

### `/loop` and cron scheduling

In current Claude Code, `/loop` means something different: re-run a prompt on a recurring cadence. With an explicit interval, Claude converts it to a five-field cron expression and uses its session scheduler; without an interval, Claude can choose the next delay dynamically. These tasks require an open local session, recurring jobs expire after seven days, and they are restored on resume only while unexpired. Claude's cloud routines and Desktop scheduled tasks are the durable alternatives. ([Claude Code scheduled tasks](https://code.claude.com/docs/en/scheduled-tasks))

So:

- **cron** is the schedule: *when should this prompt/job fire?*
- **agent loop** is execution within one run: *what should the model/tool cycle do next?*
- **`/loop`** is repeated scheduling of new Claude turns: *run this prompt again later.*

Herdr can keep the terminal containing a session-scoped `/loop` alive when its UI detaches, but it does not turn that loop into a durable cloud scheduler. That conclusion follows from Herdr owning the terminal process and Claude requiring the session to remain running. ([Herdr persistence](https://herdr.dev/docs/session-state/#live-persistence), [Claude scheduling limits](https://code.claude.com/docs/en/scheduled-tasks/#limitations))

### Workflow graph

A workflow graph represents orchestration structure. Nodes are agents, tools, MCP servers, or processing steps; directed edges represent possible calls, dependencies, or handoffs. It answers *what can run after what, what can branch or run in parallel, and where results converge*. A graph with no cycles is a DAG; graphs may also contain feedback cycles. For DHH's example, a plausible graph is `fetch issues -> parallel triage -> isolated worktree fix -> tests -> Codex review -> PR`, with failure edges returning to implementation. That graph is an inference, not a disclosed DHH implementation. OpenAI's official visualization renders agents, tools, MCP servers, and handoffs as a directed graph, while its orchestration guide distinguishes letting an LLM choose the route from encoding the route in deterministic application code. ([OpenAI agent visualization](https://openai.github.io/openai-agents-python/visualization/), [agent orchestration](https://openai.github.io/openai-agents-js/guides/multi-agent/))

A graph is useful when a workflow has stable stages—for example `triage -> parallel fixes -> tests -> Codex review -> PR`—and you want explicit dependencies, retries, or auditability. For a one-off exploratory coding task, a parent agent delegating dynamically is usually less machinery. Herdr can host and expose every terminal involved, but it is not itself a general graph engine. Its documented orchestration primitives are layout, pane control, agent control, and waits. ([Herdr agent automation](https://herdr.dev/docs/agent-automation/), [OpenAI code-versus-LLM orchestration](https://openai.github.io/openai-agents-js/guides/multi-agent/#orchestrating-via-code))

## A low-risk learning path

1. Keep tmux intact. Run Herdr for one project and learn only `workspace -> tab -> pane -> agent`, plus detach/reattach. Herdr works without a config file. ([quick start](https://herdr.dev/docs/quick-start/), [configuration](https://herdr.dev/docs/configuration/))
2. Run one Claude Code and one Codex pane manually. Observe state changes and decide whether the sidebar actually reduces attention-switching for your workload. No cross-agent automation is required for this experiment. ([agents](https://herdr.dev/docs/agents/))
3. Translate only the tmux bindings you use constantly. Do not port the status line or plugin ecosystem until Herdr has earned a permanent place in the workflow.
4. After reviewing the documented config mutations, install the Claude and Codex integrations if cold-session restore matters. Detection works without them; the integrations primarily add native session identity for these two harnesses. ([integrations](https://herdr.dev/docs/integrations/#how-herdr-uses-integrations))
5. Reproduce the valuable part of DHH's pattern before building a graph: ask Claude to fan out independent triage with native subagents, isolate writers in Git worktrees, and invoke `codex exec` as an independent read-only reviewer. Claude Code warns that parallel workers multiply token usage and recommends worktrees when tasks touch the same files. ([parallel-agent guidance](https://code.claude.com/docs/en/agents), [Codex exec](https://github.com/openai/codex/blob/main/codex-rs/README.md#codex-exec-to-run-codex-programmaticallynon-interactively))
6. Move the reviewer into a Herdr-managed pane only if you benefit from watching it, attaching interactively, preserving it across UI detach, or waiting on semantic agent state. ([agent automation](https://herdr.dev/docs/agent-automation/))

The practical decision rule is simple: if your pain is managing terminals, tmux remains excellent; if your pain is supervising many autonomous terminal agents and noticing which one needs attention, Herdr adds a purpose-built layer. You can adopt that layer incrementally without committing to a wholesale tmux migration.
