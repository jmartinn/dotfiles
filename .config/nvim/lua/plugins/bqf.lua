local M = {
  "kevinhwang91/nvim-bqf",
  ft = "qf",
}

function M.config()
  require("bqf").setup({
    auto_enable = true,
    auto_resize_height = true,
    preview = {
      auto_preview = true,
      show_title = true,
      delay_syntax = 50,
      wrap = false,
      border = "rounded",
    },
    func_map = {
      tab = "t",
      openc = "o",
      drop = "O",
      split = "s",
      vsplit = "v",
      stoggleup = "M",
      stoggledown = "m",
      stogglevm = "m",
      filterr = "f",
      filter = "F",
      prevhist = "<",
      nexthist = ">",
      sclear = "c",
      ptoggleitem = "p",
      ptoggleauto = "P",
      ptogglemode = "zp",
    },
  })
end

return M
