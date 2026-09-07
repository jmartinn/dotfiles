local M = {
  "github/copilot.vim",
  branch = "release",
  event = "InsertEnter",
  cmd = "Copilot",
}

function M.init()
  -- Blink owns <Tab>; keep Copilot suggestions as independent ghost text.
  vim.g.copilot_no_tab_map = true
  vim.g.copilot_hide_during_completion = false
end

function M.config()
  vim.keymap.set("i", "<C-y>", 'copilot#Accept("")', {
    desc = "Accept Copilot suggestion",
    expr = true,
    replace_keycodes = false,
  })
end

return M
