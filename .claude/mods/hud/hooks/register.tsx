import { atom, read, update } from 'claude-code'
import type { EngineInterface, Register } from 'claude-code'

import type { Activity, Change, Disk, Tokens, Usage } from '../types'

const PANE = 'hud'
const TITLE = 'HUD'
const WIDTH = 34

// Tokyo Night: one accent (blue), status colors only where they carry meaning.
const C = {
  bg: '#1a1b26',
  fg: '#c0caf5',
  sub: '#a9b1d6',
  dim: '#565f89',
  rule: '#3b4261',
  blue: '#7aa2f7',
  green: '#9ece6a',
  yellow: '#e0af68',
  red: '#f7768e',
  magenta: '#bb9af7',
}

const active = atom({ plugin: 'hud', key: 'active' } as const, [] as Activity[])
const changes = atom({ plugin: 'hud', key: 'changes' } as const, {} as Record<string, Change>)
const tokens = atom(
  { plugin: 'hud', key: 'tokens' } as const,
  {
    input: 0,
    output: 0,
    cacheRead: 0,
    cacheWrite: 0,
  } as Tokens,
)
const turns = atom({ plugin: 'hud', key: 'turns' } as const, [] as number[])
const usage = atom({ plugin: 'hud', key: 'usage' } as const, null as Usage | null)
const disk = atom({ plugin: 'hud', key: 'disk' } as const, null as Disk | null)
const cwd = atom({ plugin: 'hud', key: 'cwd' } as const, '')
const now = atom({ plugin: 'hud', key: 'now' } as const, 0)

const SPINNER = '⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
const SPARKS = '▁▂▃▄▅▆▇█'

function str(value: unknown): string {
  return typeof value === 'string' ? value : ''
}

function base(path: string): string {
  return path.split('/').filter(Boolean).pop() ?? path
}

function lines(text: string): number {
  return text === '' ? 0 : text.split('\n').length
}

/** One short line saying what a call is about. */
function targetOf(tool: string, input: Record<string, unknown>): string {
  switch (tool) {
    case 'Bash':
      return str(input.command).split('\n')[0] ?? ''
    case 'Read':
    case 'Edit':
    case 'Write':
    case 'MultiEdit':
    case 'NotebookEdit':
      return base(str(input.file_path) || str(input.notebook_path))
    case 'Grep':
    case 'Glob':
      return str(input.pattern)
    case 'Agent':
    case 'Task':
      return str(input.description)
    case 'WebFetch':
      return (
        str(input.url)
          .replace(/^https?:\/\//, '')
          .split('/')[0] ?? ''
      )
    case 'WebSearch':
      return str(input.query)
    case 'Skill':
      return str(input.skill)
    default:
      return ''
  }
}

/** Lines an edit adds and removes, as its input states them. */
function changeOf(tool: string, input: Record<string, unknown>): Change | null {
  if (tool === 'Edit') {
    return {
      added: lines(str(input.new_string)),
      removed: lines(str(input.old_string)),
    }
  }
  if (tool === 'Write') return { added: lines(str(input.content)), removed: 0 }
  if (tool === 'MultiEdit' && Array.isArray(input.edits)) {
    return (input.edits as Record<string, unknown>[]).reduce<Change>(
      (sum, one) => ({
        added: sum.added + lines(str(one.new_string)),
        removed: sum.removed + lines(str(one.old_string)),
      }),
      { added: 0, removed: 0 },
    )
  }
  return null
}

function compact(n: number): string {
  if (n >= 1e6) return `${(n / 1e6).toFixed(1)}M`
  if (n >= 1e3) return `${Math.round(n / 1e3)}k`
  return String(n)
}

function elapsed(ms: number): string {
  const s = Math.max(0, Math.floor(ms / 1000))
  if (s < 60) return `${s}s`
  const m = Math.floor(s / 60)
  if (m < 60) return `${m}m${String(s % 60).padStart(2, '0')}s`
  return `${Math.floor(m / 60)}h${String(m % 60).padStart(2, '0')}m`
}

function heat(percent: number): string {
  return percent >= 85 ? C.red : percent >= 60 ? C.yellow : C.green
}

function sparkline(values: number[]): string {
  const max = Math.max(...values, 1)
  return values.map(v => SPARKS[Math.min(7, Math.floor((v / max) * 7))]).join('')
}

function limitLabel(kind: string): string {
  if (kind === 'five_hour') return '5h'
  if (kind === 'seven_day') return '7d'
  return kind.replace(/_/g, ' ')
}

/** `claude-opus-5-5` reads as `opus 5.5`. */
function modelName(id: string): string {
  return id
    .replace(/^claude-/, '')
    .replace(/-(\d+)-(\d+)(-.*)?$/, ' $1.$2')
    .replace(/-(\d+)$/, ' $1')
}

function relative(path: string, root: string): string {
  return root !== '' && path.startsWith(`${root}/`) ? path.slice(root.length + 1) : base(path)
}

async function refreshUsage($: EngineInterface): Promise<void> {
  const [u, model, t] = await Promise.all([$.session.usage(), $.session.model(), $.clock.now()])
  await update($, usage, () => ({
    model,
    startedAt: u.startedAt,
    contextTokens: u.context.tokens ?? null,
    contextWindow: u.context.window,
    contextPercent: u.context.percent ?? null,
    limits: u.rateLimits.map(l => ({
      kind: l.kind,
      percentUsed: l.percentUsed,
    })),
  }))
  await update($, now, () => t)
}

async function refreshDisk($: EngineInterface): Promise<void> {
  // The writable APFS volume; `/` is the sealed system snapshot.
  const { exitCode, stdout } = await $.process.run(['df', '-k', '/System/Volumes/Data'])
  if (exitCode !== 0) return
  const fields = stdout.trim().split('\n').pop()?.split(/\s+/) ?? []
  const used = Number(fields[2])
  const available = Number(fields[3])
  if (!Number.isFinite(used) || !Number.isFinite(available)) return
  await update($, disk, () => ({
    usedPercent: Math.round((used / (used + available)) * 100),
    freeGb: Math.round((available * 1024) / 1e9),
  }))
}

export const register: Register = on => {
  on('session.start', async ($, e, next) => {
    await $.command.register({
      name: 'hud',
      description: 'Toggle the session HUD',
    })
    const root = await $.session.cwd()
    await update($, cwd, () => root)
    void refreshUsage($)
    void refreshDisk($)
    $.clock.every(5_000, () => void refreshUsage($))
    $.clock.every(60_000, () => void refreshDisk($))
    // Fast ticks only while something runs: the spinner turns, idle stays still.
    $.clock.every(150, () => {
      void (async () => {
        if ((await read($, active)).length > 0) {
          const t = await $.clock.now()
          await update($, now, () => t)
        }
      })()
    })

    return next(e)
  })

  on('command.run', { command: 'hud' }, async $ => {
    const isOpen = (await $.ui.panes()).some(pane => pane.id === PANE)
    if (isOpen) {
      await $.ui.close({ id: PANE })
      return { text: 'closed' }
    }

    await $.ui.open({ id: PANE, title: TITLE, columns: WIDTH + 2, rows: 14 })
    return { text: 'opened' }
  })

  on('tool.call', async ($, e, next) => {
    const tool = String(e.tool)
    const input = e as unknown as Record<string, unknown>
    const startedAt = await $.clock.now()
    const call: Activity = {
      id: e.tool_use_id,
      tool,
      target: targetOf(tool, input),
      startedAt,
      isAgent: e.agentId !== undefined,
    }
    await update($, active, list => [...list, call])
    await update($, now, () => startedAt)

    try {
      const ran = await next(e)
      const change = changeOf(tool, input)
      const path = str(input.file_path)
      if (ran.deny === undefined && ran.isError !== true && change !== null && path !== '') {
        await update($, changes, all => {
          const was = all[path] ?? { added: 0, removed: 0 }
          return {
            ...all,
            [path]: {
              added: was.added + change.added,
              removed: was.removed + change.removed,
            },
          }
        })
      }

      return ran
    } finally {
      await update($, active, list => list.filter(one => one.id !== call.id))
    }
  })

  on('turn.complete', async ($, e, next) => {
    const spent = e.usage
    if (spent !== undefined) {
      await update($, tokens, t => ({
        input: t.input + spent.input_tokens,
        output: t.output + spent.output_tokens,
        cacheRead: t.cacheRead + spent.cache_read_input_tokens,
        cacheWrite: t.cacheWrite + spent.cache_creation_input_tokens,
      }))
    }
    if (e.agentId === undefined && !e.isAborted) {
      await update($, turns, list => [...list, e.durationMs].slice(-40))
    }
    void refreshUsage($)

    return next(e)
  })

  // /hud: a narrow sidebar of aligned rows, quiet until something needs a look.
  on('ui.render', { component: 'Pane', requestId: PANE }, async ($, e) => {
    const { Box, Text } = $.ui.resolve(e)
    const width = Math.max(24, Math.min(WIDTH, e.props.bodyColumns))
    const [list, files, tok, durations, u, d, root, tick] = await Promise.all([
      read($, active),
      read($, changes),
      read($, tokens),
      read($, turns),
      read($, usage),
      read($, disk),
      read($, cwd),
      read($, now),
    ])

    const row = (label: string, value: JSX.Element) => (
      <Box>
        <Box width={9}>
          <Text color={C.dim}>{label}</Text>
        </Box>
        {value}
      </Box>
    )
    const gap = <Text> </Text>

    const pct = u?.contextPercent ?? null
    const cells = width - 9 - 5
    const lit = pct === null ? 0 : Math.round((Math.min(100, pct) / 100) * cells)
    const totalIn = tok.input + tok.cacheRead + tok.cacheWrite
    const hit = totalIn > 0 ? Math.round((tok.cacheRead / totalIn) * 100) : null
    const fileRows = Object.entries(files)
      .sort((a, b) => b[1].added + b[1].removed - (a[1].added + a[1].removed))
      .slice(0, 6)
    const spin = SPINNER[Math.floor(tick / 150) % SPINNER.length]

    const isDocked = e.props.placement === 'dock'

    return (
      <Box
        flexDirection="column"
        width={isDocked ? e.props.bodyColumns : width}
        minHeight={isDocked ? e.props.scroll.bodyRows : undefined}
        backgroundColor={isDocked ? C.bg : undefined}
      >
        <Box flexDirection="column" width={width}>
          <Box justifyContent="space-between">
            <Text color={C.fg} bold>
              {u === null ? 'claude' : modelName(u.model)}
            </Text>
            <Text color={C.dim}>
              {u === null ? '' : elapsed(Math.max(tick, u.startedAt) - u.startedAt)}
            </Text>
          </Box>
          <Text color={C.rule}>{'─'.repeat(width)}</Text>

          {list.length === 0 ? (
            <Text color={C.dim}>idle</Text>
          ) : (
            list.slice(-4).map((call, i) => (
              <Box justifyContent="space-between">
                <Text wrap="truncate-end">
                  <Text color={i === 0 ? C.blue : C.dim}>{i === 0 ? spin : '·'} </Text>
                  <Text color={call.isAgent ? C.magenta : C.sub}>{call.tool.toLowerCase()} </Text>
                  <Text color={C.dim}>{call.target}</Text>
                </Text>
                <Text color={C.dim}>
                  {' '}
                  {elapsed(Math.max(tick, call.startedAt) - call.startedAt)}
                </Text>
              </Box>
            ))
          )}
          {gap}

          {row(
            'context',
            pct === null ? (
              <Text color={C.dim}>…</Text>
            ) : (
              <Text>
                <Text color={pct >= 60 ? heat(pct) : C.blue}>{'━'.repeat(lit)}</Text>
                <Text color={C.rule}>{'━'.repeat(cells - lit)}</Text>
                <Text color={pct >= 60 ? heat(pct) : C.sub}> {String(pct).padStart(3)}%</Text>
              </Text>
            ),
          )}
          {u !== null &&
            u.contextTokens !== null &&
            row(
              '',
              <Text color={C.dim}>
                {compact(u.contextTokens)} of {compact(u.contextWindow)}
              </Text>,
            )}
          {hit !== null &&
            row(
              'cache',
              <Text color={C.sub}>
                {hit}% <Text color={C.dim}>hit</Text>
              </Text>,
            )}
          {u !== null &&
            u.limits.length > 0 &&
            row(
              'limits',
              <Text>
                {u.limits.map((l, i) => (
                  <Text>
                    {i > 0 && <Text>{'  '}</Text>}
                    <Text color={C.dim}>{limitLabel(l.kind)} </Text>
                    <Text color={l.percentUsed >= 60 ? heat(l.percentUsed) : C.sub}>
                      {Math.round(l.percentUsed)}%
                    </Text>
                  </Text>
                ))}
              </Text>,
            )}
          {durations.length > 1 &&
            row(
              'turns',
              <Text>
                <Text color={C.blue}>{sparkline(durations.slice(-(width - 9 - 6)))}</Text>
                <Text color={C.dim}> {elapsed(durations[durations.length - 1] ?? 0)}</Text>
              </Text>,
            )}
          {d !== null &&
            row(
              'disk',
              <Text color={d.usedPercent >= 80 ? heat(d.usedPercent) : C.sub}>
                {d.freeGb} GB <Text color={C.dim}>free</Text>
              </Text>,
            )}

          {fileRows.length > 0 && gap}
          {fileRows.length > 0 && <Text color={C.dim}>modified</Text>}
          {fileRows.map(([path, change]) => (
            <Box justifyContent="space-between">
              <Text color={C.sub} wrap="truncate-start">
                {relative(path, root)}
              </Text>
              <Text>
                {change.added > 0 && <Text color={C.green}> +{change.added}</Text>}
                {change.removed > 0 && <Text color={C.red}> −{change.removed}</Text>}
              </Text>
            </Box>
          ))}
        </Box>
      </Box>
    )
  })
}
