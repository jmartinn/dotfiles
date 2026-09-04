# Mac mini as a persistent coding-agent host

Research snapshot: 2026-08-25 (Europe/Madrid)

Scope: first-party documentation for Herdr, Codex, Claude Code, Tailscale, and macOS. “Verified” means the vendor explicitly documents the behavior. “Inference” marks an operational conclusion assembled from those facts rather than a vendor guarantee.

## Bottom line

The M2 Mac mini can be a useful persistent **execution host** rather than another Kubernetes server. This is now a first-party-supported pattern for Codex: OpenAI explicitly recommends a “dedicated always-on computer,” lets ChatGPT on iPhone control projects and chats on that Mac, and lets another Mac continue the same work or connect to it over SSH. Claude Code likewise has Remote Control for steering a locally running CLI session from the Claude mobile app or `claude.ai/code`. Herdr supplies the third, vendor-neutral lane: keep Codex, Claude Code, shells, tests, and servers in persistent PTYs, then attach from the MacBook or an iPhone SSH client. ([OpenAI remote connections](https://developers.openai.com/codex/remote-connections), [Claude Code Remote Control](https://code.claude.com/docs/en/remote-control), [Herdr remote workflow](https://herdr.dev/docs/how-to-work/))

The practical design is:

- The Mac mini owns canonical working checkouts, credentials, MCP servers, skills, build caches, and the running agent processes.
- The MacBook is the primary control surface: use Codex/ChatGPT “Control other devices” where available, Codex Remote SSH, `herdr --remote mac-mini`, or ordinary SSH. When work truly needs to move back to the laptop, Codex has a documented chat-and-Git handoff instead of relying on two independently edited clones. ([OpenAI remote connections and handoff](https://developers.openai.com/codex/remote-connections))
- The iPhone uses the first-party ChatGPT Remote or Claude Code Remote Control interfaces for rich agent interaction, and Tailscale plus an SSH client for the universal Herdr/terminal fallback. ([OpenAI “Work with Codex from anywhere”](https://openai.com/index/work-with-codex-from-anywhere/), [Claude Code Remote Control](https://code.claude.com/docs/en/remote-control), [Herdr phone workflow](https://herdr.dev/docs/how-to-work/#work-from-your-phone))
- The existing Ubuntu/MicroK8s server should keep cluster-native workloads, public services, Flux, and infrastructure automation. The Mac mini earns its keep where macOS, Apple tooling, a logged-in GUI, local Keychain/browser state, and ARM64 macOS builds matter.

The largest weakness is not agent software; it is **cold-boot recovery on Sequoia**. A sleeping Mac stops local work, and after a reboot FileVault requires the startup disk to be unlocked. Apple documents remote FileVault unlock over SSH only for Apple-silicon Macs on macOS 26 or later—not Sequoia 15. Therefore an unattended Sequoia host with FileVault enabled still needs a person at the machine after a cold restart before its user-session apps and repositories become available. ([Apple FileVault recovery](https://support.apple.com/guide/mac-help/mh35881/mac), [Apple FileVault management](https://support.apple.com/guide/security/managing-filevault-sec8447f5049/web))

## Capability matrix

| Control path | Where work runs | iPhone | MacBook | Survives client disconnect | Survives host reboot |
| --- | --- | --- | --- | --- | --- |
| Codex/ChatGPT Remote | Mac mini desktop host | First-party Remote UI | First-party “Control other devices” where rolled out | Yes, while host is awake, online, signed in, and the app remains open | No documented pre-login recovery; app/user session must return |
| Experimental `codex remote-control` | Mac mini Codex app-server daemon | Pairing is documented; client availability may vary | Managed remote-control clients | Daemon mode is explicit | Must be restarted after host reboot |
| Codex Remote SSH | Mac mini over SSH | Indirectly through a connected desktop host | First-party desktop integration | Remote commands execute on mini; no promise that an active response outlives loss of the controlling app | Remote app server must be restarted over SSH |
| Claude Code Remote Control | Mac mini CLI/VS Code | First-party Claude Code UI | Browser or Claude UI | Yes while the local Claude process/terminal stays open; reconnects after temporary network interruption | No; restart and re-register/resume |
| Claude Code on the web | Anthropic cloud VM | First-party | First-party | Yes | Host-independent; the mini is not used |
| Herdr over SSH | Mac mini | Any SSH client | `herdr --remote` or SSH then `herdr` | Yes; the Herdr server owns the live PTYs | Processes do not survive; layout returns and supported agent conversations can be resumed |
| macOS Screen Sharing over the tailnet | Mac mini GUI | Requires a separate iOS VNC-capable client | Built-in Screen Sharing app | Session can reconnect; target must stay awake | Requires macOS/user/network recovery after reboot |

## Herdr: persistence and remote/client architecture

### Verified

Herdr is a background session server with thin terminal clients. The server owns PTYs and their processes; detaching a client with `ctrl+b q` leaves agents, shells, tests, and servers running. A later `herdr` attaches to that same live state. Named sessions create independent server namespaces with their own panes, sockets, and runtime state. ([Herdr concepts](https://herdr.dev/docs/concepts/), [persistence and remote access](https://herdr.dev/docs/persistence-remote/))

There are two documented remote modes:

1. SSH to the host and run `herdr`. This is the simplest phone/tablet path, and Herdr’s TUI adapts to narrow screens.
2. Run `herdr --remote <ssh-host>` locally. The local binary acts as a thin client, starts or attaches to the remote server over normal OpenSSH, uses SSH config and authentication, and can bridge local clipboard image paste to a remote temporary file. Remote attach supports macOS or Linux hosts on `aarch64` and `x86_64`. ([Herdr workflow](https://herdr.dev/docs/how-to-work/), [remote attach details](https://herdr.dev/docs/persistence-remote/#remote-attach-over-ssh))

Detach persistence and cold restart restoration are different:

- Detach/reattach keeps the original processes alive.
- A Herdr server restart kills the original processes. Herdr restores workspace/tab/pane layout, working directories, and focus, but arbitrary shells, tests, and servers restart as fresh shells.
- With current official integrations, Claude Code and Codex panes that reported a valid native session ID can restart as `claude --resume <id>` or `codex resume <id>`. That resumes conversation state, not the exact process or an in-flight tool call.
- Pane screen-history persistence is off by default because terminal output may contain tokens, prompts, and secrets. Experimental live handoff is best-effort and can still interrupt requests, waits, and client connections. ([Herdr session state](https://herdr.dev/docs/session-state/), [Herdr integrations](https://herdr.dev/docs/integrations/))

`herdr server` explicitly runs the headless server and is described as suitable for supervised or service-style setups. The documentation does not currently provide a canonical macOS `launchd` service recipe. ([Herdr CLI reference](https://herdr.dev/docs/cli-reference/#server))

### Operational inference

Herdr is a strong **live-session durability** layer for the Mac mini, especially when `claude remote-control` or ordinary agent CLIs run inside its panes. It is not a reboot-proof job scheduler. A proper always-on setup should supervise the Herdr server and separately decide which non-agent services restart after boot; the Claude/Codex integrations only reconstruct supported agent conversations after Herdr and the user environment are available again.

There is no Herdr mobile app or web dashboard. On iPhone the supported mechanism is an SSH app connecting to the mini and launching `herdr`. This is viable over Tailscale because Herdr needs only normal SSH; it does not require Herdr-specific public ports.

## Codex / ChatGPT: native remote host, Remote SSH, handoff, and cloud

### Verified: Remote control of an always-on Mac

OpenAI now documents this use case directly. ChatGPT Remote can access chats and Codex work on a connected macOS host. From iOS it can start or continue chats, steer active work, approve actions, review diffs/tests/terminal output/screenshots, receive notifications, and switch between hosts. Files, credentials, permissions, plugins, MCP servers, tools, browser state, and sandbox policy remain on the host; a secure relay keeps it reachable without exposing it publicly. ([OpenAI remote connections](https://developers.openai.com/codex/remote-connections), [product announcement](https://openai.com/index/work-with-codex-from-anywhere/))

The host requirements are explicit: the latest ChatGPT desktop app must be **running, awake, online, and signed into the same account and workspace**. Setup starts in the desktop app at Settings → Connections → Control this Mac or PC and pairs the phone by QR code; it cannot be set up from Codex CLI or the IDE extension. Workspace admins may need to enable Remote Control, and SSO, MFA, or passkeys may apply. The host UI also offers “Keep this Mac awake” while plugged in and remote access is enabled. ([OpenAI remote setup](https://developers.openai.com/codex/remote-connections#before-you-set-up-remote))

Another supported Mac or Windows desktop app can control the host when “Control other devices” is available; OpenAI notes rollout can vary. A device can be both a host and a controller. This is the direct answer to “how do I work from the MacBook?”: connect the MacBook’s ChatGPT desktop app to the mini and keep the execution environment on the mini. ([OpenAI pick-up workflow](https://developers.openai.com/codex/remote-connections#pick-up-work-from-another-device))

Codex Remote is currently in preview on iOS and Android across all plans, including Free and Go, in supported regions. Remote SSH is documented as available on all plans. Managed workspaces can gate Remote Control access. ([OpenAI availability](https://openai.com/index/work-with-codex-from-anywhere/#availability), [Codex plan and workspace controls](https://help.openai.com/en/articles/11369540-codex-in-chatgpt))

### Verified: use the mini as an SSH environment from the MacBook

The desktop app can discover concrete hosts in `~/.ssh/config`, connect with OpenSSH, and run projects against the remote filesystem and shell. The remote host must have an authenticated `codex` command on the login shell’s `PATH`; the app starts the remote Codex app server through SSH. OpenAI recommends trusted keys, a least-privilege account, and a VPN or mesh network for off-LAN access, and explicitly says not to expose app-server transports on a public/shared network. ([OpenAI SSH-host setup](https://developers.openai.com/codex/remote-connections#connect-to-an-ssh-host), [authentication and exposure](https://developers.openai.com/codex/remote-connections#authentication-and-network-exposure))

Codex can hand off an existing chat and its Git state between the MacBook and a connected remote host. Both ends need a saved project for the same repository; Codex creates or reuses a destination worktree and transfers the chat and Git state. An active response is interrupted before handoff, and handoff to a Codex cloud environment is not supported. ([OpenAI chat handoff](https://developers.openai.com/codex/remote-connections#hand-off-a-chat-between-hosts))

### Codex CLI remote control: available, but experimental and app-server based

The current CLI reference lists `codex remote-control` as experimental. Running it directly starts remote control in the foreground; `codex remote-control start` launches a local app-server daemon with remote control enabled, `stop` stops it, and `pair` prints a short-lived manual pairing code. OpenAI says managed remote-control clients and SSH workflows use this daemon. ([Codex CLI remote-control reference](https://learn.chatgpt.com/docs/developer-commands?surface=cli#codex-remote-control))

This is a first-party CLI-hosted remote lane, but it is not documented as attaching to the live PTY of an arbitrary already-running interactive `codex` process inside Herdr. The stable mobile setup guide still says its desktop-host pairing cannot be initialized from Codex CLI or the IDE extension, while the CLI command is explicitly marked experimental. For an exact existing Herdr pane, use Herdr over SSH; for a managed Codex remote environment, trial the experimental daemon and pairing flow. Stable `codex resume` can continue a saved conversation after process loss, but is reconstruction rather than control of the old process. ([OpenAI Remote setup](https://developers.openai.com/codex/remote-connections#before-you-set-up-remote), [Codex CLI maturity table](https://learn.chatgpt.com/docs/developer-commands?surface=cli))

### Cloud alternative

Codex cloud tasks run in isolated OpenAI environments and therefore do not require the mini to remain awake. They are useful for repository-scoped work that does not need the mini’s local Keychain, macOS GUI, private LAN, or machine-specific toolchain. They also avoid turning the Mac mini into a prerequisite for every unattended task. The experimental `codex cloud` / `codex cloud-tasks` command can browse, submit, and list cloud chats from a terminal; stable `codex apply <TASK_ID>` applies a cloud chat’s latest diff to the current local working tree. ([Introducing Codex](https://openai.com/index/introducing-codex/), [Codex cloud](https://developers.openai.com/codex/cloud), [Codex CLI cloud commands](https://learn.chatgpt.com/docs/developer-commands?surface=cli#codex-cloud))

Codex cloud requires ChatGPT sign-in; API-key authentication supports local workflows but does not provide Codex cloud. Email/password accounts must enable MFA for cloud access, while managed workspaces apply their own roles and permissions. ([OpenAI authentication](https://learn.chatgpt.com/docs/auth))

## Claude Code: local Remote Control, cloud sessions, and teleport

### Verified: Remote Control of a local CLI session

Claude Code Remote Control connects `claude.ai/code` or the Claude app for iOS/Android to a Claude Code session running on the Mac mini. The CLI, filesystem, MCP servers, tools, project config, and network access stay local; mobile/web is a synchronized window into that session. It can be started as a waiting server with `claude remote-control`, on an interactive session with `claude --remote-control`, or from an existing session with `/remote-control`. A configuration switch can enable it for all interactive sessions. ([Claude Code Remote Control](https://code.claude.com/docs/en/remote-control))

The local process makes outbound HTTPS connections only and opens no inbound port. Messages are relayed through the Anthropic API over TLS with short-lived, purpose-scoped credentials. Temporary network loss or host sleep reconnects when the machine returns, but the terminal process must stay open; the comparison table explicitly says Remote Control keeps running “while terminal stays open.” Mobile push notifications are available when Claude finishes long work or needs a decision. ([Claude Remote Control security and comparison](https://code.claude.com/docs/en/remote-control#connection-and-security))

Remote Control requires Claude Code 2.1.51 or later, a claude.ai login, workspace trust, and a Pro, Max, Team, or Enterprise subscription; API-key authentication is unsupported. Team and Enterprise admins must enable it because it is off by default there. Long-lived `setup-token`/`CLAUDE_CODE_OAUTH_TOKEN` credentials are insufficient; the feature needs a full-scope login token. ([Claude Remote Control requirements](https://code.claude.com/docs/en/remote-control#requirements))

### Operational fit with Herdr

Running `claude remote-control` inside a Herdr pane combines complementary properties: Herdr keeps the terminal process alive when SSH clients detach, while Anthropic supplies the phone/web UI and relay. No inbound firewall rule or Tailscale route is needed for the Claude UI itself. If the Herdr server or Mac reboots, however, Herdr may resume the native Claude conversation, but Anthropic does not document preservation of the prior Remote Control registration; expect to start/reselect a Remote Control session again.

### Verified: cloud session alternative

`claude --remote "task"` creates a new Claude Code cloud session. Cloud sessions persist when the local computer closes and are available from the web or Claude mobile app. `--teleport` can pull a cloud session into the terminal, but CLI handoff is one-way: an existing terminal session cannot be pushed to the web (the Desktop app has a separate Continue in mechanism). When GitHub is connected, the cloud environment clones the current branch, so local commits must be pushed; a non-GitHub fallback can upload a Git bundle with documented size and untracked-file limits. ([Claude Code on the web and handoff](https://code.claude.com/docs/en/claude-code-on-the-web))

Claude Code on the web is a research preview for Pro, Max, and Team users and eligible Enterprise seats. It runs in Anthropic-managed infrastructure and is the better choice when the task should continue independently of the mini; local Remote Control is the better choice when the task needs the mini’s exact environment. ([Claude web quickstart](https://code.claude.com/docs/en/web-quickstart))

## Tailscale, SSH, and GUI access

### Tailscale is the private transport, not the terminal or desktop service

Tailscale gives devices stable tailnet IPs and MagicDNS names, but its documentation is explicit that the destination must still run a service such as SSH, SFTP, VNC, or a web server. For this Mac mini, turn on macOS Remote Login for a restricted user and use ordinary SSH over the tailnet; there is no reason to publish TCP/22 to the internet. ([Tailscale connect-to-devices](https://tailscale.com/docs/how-to/connect-to-devices), [Apple Remote Login](https://support.apple.com/guide/mac-help/mchlp1066/mac))

The important macOS packaging nuance is:

- The recommended Standalone Tailscale app and the App Store app do **not** run before user login and cannot be Tailscale SSH servers. The Standalone app can use the regular `ssh` client and can carry ordinary macOS SSH traffic.
- Only the open-source CLI-only `tailscale` + `tailscaled` variant runs before login and can be a Tailscale SSH server on macOS. It has no GUI or automatic updates and is recommended only for unattended installs managed by experienced macOS administrators.
- Do not install multiple variants together. ([Tailscale macOS variants](https://tailscale.com/docs/concepts/macos-variants))

Therefore the lowest-friction choice is usually **Standalone Tailscale + Apple Remote Login + SSH keys + restrictive tailnet grants**. Built-in Tailscale SSH is available on all plans and adds identity-aware authorization/check mode, but adopting it on macOS requires switching to the CLI-only daemon variant. Tailscale also warns that its SSH model may be a poor fit for multi-user source machines because any local OS user can use the device’s tailnet identity, and restarting `tailscaled` terminates existing Tailscale SSH sessions. ([Tailscale SSH](https://tailscale.com/docs/features/tailscale-ssh))

### iPhone terminal lane

Tailscale has an iOS client but no iOS CLI. On iPhone, enable Tailscale, open a separate SSH client, connect to the mini’s MagicDNS name/tailnet IP, and run `herdr`. Herdr explicitly supports this phone workflow and its narrow-screen UI. ([Tailscale CLI platform limits](https://tailscale.com/docs/reference/tailscale-cli), [Herdr phone workflow](https://herdr.dev/docs/how-to-work/#work-from-your-phone))

The browser-based Tailscale SSH Console is another first-party option, but it is a beta administrative console rather than a normal standalone mobile terminal. It requires Owner/Admin/IT admin/Network admin role, must start from the Tailscale admin console, ends with the browser session, and always uses DERP relays. It is useful as an emergency path, not the primary Herdr client. ([Tailscale SSH Console](https://tailscale.com/docs/features/tailscale-ssh/tailscale-ssh-console))

### MacBook GUI lane

Apple’s built-in Screen Sharing app can view and control another Mac, authenticate by user, transfer clipboard contents/files, and—on Apple silicon with macOS Sonoma 14 or later—create one or two high-performance virtual displays. That makes a physical display or HDMI dummy unnecessary for the documented high-performance path. The target must remain awake. ([Apple Screen Sharing client](https://support.apple.com/guide/mac-help/mh14066/mac), [turn on Screen Sharing](https://support.apple.com/guide/mac-help/mh11848/mac), [sleep prerequisite](https://support.apple.com/guide/mac-help/mh14070/mac))

**Inference:** because Screen Sharing is VNC-compatible TCP/IP and Tailscale provides private IP connectivity governed by tailnet policy, the MacBook can connect the Screen Sharing app to the mini’s tailnet IP/MagicDNS name. Tailscale itself does not provide the GUI viewer. Apple does not document an equivalent unattended Screen Sharing client for iPhone; an iOS GUI lane therefore requires a separate VNC-capable client and is outside this first-party-only comparison. The agent-native mobile UIs or Herdr over SSH are likely better on a phone-sized screen anyway.

## macOS Sequoia: always-on and headless constraints

### Sleep

For a desktop Mac, Apple exposes “Prevent automatic sleeping when the display is off,” “Wake for network access,” and “Start up automatically after a power failure” under Energy settings. Preventing sleep is the correct setting for live agents; wake-on-network only lets a sleeping Mac wake briefly for supported shared services and does not promise continuous agent execution. OpenAI’s own Remote setting can also keep a plugged-in host awake while remote access is enabled. ([Apple sleep/wake settings](https://support.apple.com/guide/mac-help/mchle41a6ccd/mac), [Apple Energy settings](https://support.apple.com/guide/mac-help/mchlp1168/mac), [OpenAI host settings](https://developers.openai.com/codex/remote-connections#choose-what-to-connect))

### Reboot and power failure

Apple documents both the Energy setting and `systemsetup -setrestartpowerfailure on` / `-setWaitForStartupAfterPowerFailure` for desktop Macs. This can power the mini back on after an outage, but it does not unlock FileVault or log in the user. A UPS reduces the most important unattended-recovery risk. ([Apple `systemsetup`](https://support.apple.com/guide/remote-desktop/apd95406b8d/mac), [Apple Energy settings](https://support.apple.com/guide/mac-help/mchlp1168/mac))

The newer “start whenever power is connected” feature requires macOS 26.5 and a Mac mini introduced in 2024 or later, so it does not apply to an M2 Mac mini on Sequoia. The older “restart after power failure if it was running” setting is the relevant option. ([Apple start-on-power requirements](https://support.apple.com/en-us/125517))

### FileVault and login

With FileVault enabled, the startup disk’s information is unavailable until an authorized password unlocks it. Automatic login is disabled when FileVault is on. Apple added SSH FileVault unlock after restart only for Apple-silicon Macs on macOS 26 or later. On Sequoia, a cold restart therefore creates a physical-unlock dependency before user-session apps such as ChatGPT/Codex, Claude Code, browser sessions, and the recommended Tailscale GUI variants can return. ([Apple FileVault](https://support.apple.com/guide/mac-help/mh11785/mac), [automatic login limitation](https://support.apple.com/guide/mac-help/mchlp1158/mac), [SSH unlock version requirement](https://support.apple.com/guide/security/managing-filevault-sec8447f5049/web))

Disabling FileVault and enabling automatic login would improve unattended recovery but materially weakens physical security; it is not a good default recommendation for a machine holding source, credentials, and agent permissions. A safer Sequoia posture is FileVault on, UPS-backed power, automatic restart configured, planned/manual unlock after OS updates, and acceptance that rare cold boots need local intervention. Upgrading the host to macOS 26 would remove one recovery limitation, but conflicts with the stated preference for Sequoia and should not be treated as mandatory.

### User-session and service boundaries

Codex/ChatGPT Remote is explicitly an app-hosted feature and stops if the app closes, the host sleeps, or network connectivity is lost. Claude Remote Control requires its CLI process and terminal to remain open. Herdr can supervise those terminal processes after login, while the CLI-only Tailscale daemon can start before login. None of those facts eliminate FileVault’s preboot boundary on Sequoia. ([OpenAI troubleshooting](https://developers.openai.com/codex/remote-connections#the-remote-session-disconnects), [Claude comparison](https://code.claude.com/docs/en/remote-control#remote-control-vs-claude-code-on-the-web), [Tailscale variants](https://tailscale.com/docs/concepts/macos-variants))

## Recommended supported workflow to trial

1. Make the mini the execution authority for a small set of active repositories; do not bidirectionally sync mutable working trees through iCloud or Dropbox.
2. Keep FileVault enabled, enable automatic restart after power failure, prevent automatic sleep, use Ethernet if practical, and add a UPS if unattended availability matters.
3. Enable Apple Remote Login only for the intended standard/developer account. Keep SSH private to the tailnet and use keys plus restrictive Tailscale grants.
4. Keep the recommended Standalone Tailscale app initially. Ordinary SSH over Tailscale is sufficient for Herdr and Codex Remote SSH; switch to CLI-only `tailscaled` only if pre-login tailnet presence and identity-aware Tailscale SSH justify its operational cost.
5. Run Herdr on the mini for persistent terminal-native work. From the MacBook, attach with `herdr --remote <ssh-alias>`; from iPhone, Tailscale → SSH client → `herdr`.
6. Pair the mini’s ChatGPT desktop app directly with the iPhone. Pair the MacBook as another controller when the rollout exposes “Control other devices.” This keeps mobile access independent of whether the MacBook is awake.
7. For Claude, run `claude remote-control` in a Herdr pane for projects that need the mini’s environment. Use Claude cloud sessions for genuinely host-independent asynchronous tasks.
8. Enable Apple Screen Sharing for occasional GUI recovery/inspection from the MacBook, not as the everyday agent interface.

## What remains inference or needs a live probe

- Whether the current ChatGPT desktop build and account in Spain expose both “Control this Mac” and “Control other devices”; OpenAI says availability can vary by rollout.
- Whether Codex Computer Use and locked-computer behavior are available for this account/region and work without a physical display in the desired apps.
- Whether the installed macOS Tailscale is Standalone, App Store, or CLI-only; this changes pre-login and Tailscale SSH behavior.
- Whether Herdr is currently launched automatically and which environment variables/Keychain items its agent processes inherit under a supervised launch.
- Whether Screen Sharing accepts the mini’s MagicDNS name directly in the current tailnet; the tailnet IP is the deterministic fallback.
- Actual post-reboot behavior of every login item and credential. A planned power-loss/reboot drill is the only reliable end-to-end validation.
