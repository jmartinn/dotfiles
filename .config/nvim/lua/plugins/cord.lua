return {
  "vyfor/cord.nvim",
  event = "VeryLazy",
  cmd = "Cord",
  opts = {
    editor = {
      tooltip = "Neovim",
    },
    idle = {
      timeout = 300000,
    },
    advanced = {
      discord = {
        reconnect = {
          enabled = true,
        },
      },
    },
  },
}
