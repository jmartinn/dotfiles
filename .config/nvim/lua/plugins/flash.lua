local M = {
  "folke/flash.nvim",
  event = "VeryLazy",
  keys = {
    {
      "s",
      function()
        require("flash").jump()
      end,
      -- normal mode only: visual S belongs to nvim-surround
      mode = "n",
      desc = "Flash",
    },
    {
      "S",
      function()
        require("flash").treesitter()
      end,
      mode = "n",
      desc = "Flash treesitter",
    },
    {
      "r",
      function()
        require("flash").remote()
      end,
      mode = "o",
      desc = "Remote flash",
    },
    {
      "<C-s>",
      function()
        require("flash").toggle()
      end,
      mode = "c",
      desc = "Toggle flash search",
    },
  },
}

function M.config()
  require("flash").setup({
    modes = {
      -- keep f/F/t/T native, flash only on explicit s/S
      char = { enabled = false },
      search = { enabled = false },
    },
  })
end

return M
