import { expect, mock, test } from 'claude-code/testing'

const PANE = {
  plugin: 'hud',
  component: 'Pane',
  requestId: 'hud',
  props: {
    title: 'HUD',
    isFocused: false,
    bodyColumns: 34,
    placement: 'dock',
    scroll: { offset: 0, bodyRows: 40 },
    view: {},
  },
} as const

test('tracks lines changed per file, skipping failed calls, and draws them', async ($, on) => {
  mock.clock(on)
  on('tool.call', ($, e) =>
    String(e.tool) === 'Bash'
      ? { result: 'boom', isError: true }
      : { result: 'ok' },
  )

  await $.tool.call({ tool: 'Edit', file_path: '/repo/src/app.ts', old_string: 'a', new_string: 'b\nc\nd' })
  await $.tool.call({ tool: 'Edit', file_path: '/repo/src/app.ts', old_string: 'x\ny', new_string: 'z' })
  await $.tool.call({ tool: 'Bash', command: 'false' })

  for (const surface of ['terminal', 'desktop'] as const) {
    const ui = await $.ui.mount({ ...PANE, surface })
    expect(await ui.find({ text: 'app.ts' })).toBeDefined()
    expect(await ui.find({ text: ' +4' })).toBeDefined()
    expect(await ui.find({ text: ' −3' })).toBeDefined()
    expect(await ui.find({ text: 'idle' })).toBeDefined()
    await ui.unmount()
  }
})

test('shows a running call under NOW while it runs', async ($, on) => {
  mock.clock(on)
  let release = () => {}
  const held = new Promise<void>(resolve => {
    release = resolve
  })
  on('tool.call', async () => {
    await held
    return { result: 'ok' }
  })

  const running = $.tool.call({ tool: 'Bash', command: 'sleep 1\necho done' })
  const ui = await $.ui.mount({ ...PANE, surface: 'terminal' })
  expect(await ui.find({ text: 'sleep 1' })).toBeDefined()
  release()
  await running
  await ui.unmount()
})

test('/hud toggles the pane open and closed', async ($, on) => {
  mock.clock(on)
  const open = new Set<string>()
  on('ui.panes', () => ({
    value: [...open].map(id => ({ id, title: 'HUD', isShown: true, isFocused: false, isPlaced: true, plugin: 'hud' })),
  }))
  on('ui.open', ($, e) => {
    open.add(e.id)
    return { value: { isPlaced: true } }
  })
  on('ui.close', ($, e) => {
    open.delete(e.id)
    return { value: undefined }
  })

  const run = {
    command: 'hud',
    args: '',
    origin: { kind: 'composer' },
    presentation: { isFullscreen: true, columns: 200 },
  } as const
  expect((await $.command.run(run)).text).toBe('opened')
  expect(open.has('hud')).toBe(true)
  expect((await $.command.run(run)).text).toBe('closed')
  expect(open.has('hud')).toBe(false)
})
