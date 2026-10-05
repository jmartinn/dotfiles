export type Activity = { id: string; tool: string; target: string; startedAt: number; isAgent: boolean }

export type Change = { added: number; removed: number }

export type Tokens = { input: number; output: number; cacheRead: number; cacheWrite: number }

export type Usage = {
  model: string
  startedAt: number
  contextTokens: number | null
  contextWindow: number
  contextPercent: number | null
  limits: { kind: string; percentUsed: number }[]
}

export type Disk = { usedPercent: number; freeGb: number }

declare module 'claude-code' {
  interface PluginState {
    hud: {
      active: Activity[]
      changes: Record<string, Change>
      tokens: Tokens
      turns: number[]
      usage: Usage | null
      disk: Disk | null
      cwd: string
      now: number
    }
  }
}
