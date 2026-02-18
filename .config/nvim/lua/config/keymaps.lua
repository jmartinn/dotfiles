-- Keymaps
local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Window navigation handled by vim-tmux-navigator (see plugins/tmux.lua)

-- Resize windows
map("n", "<C-Up>", ":resize -2<CR>", opts)
map("n", "<C-Down>", ":resize +2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Close buffer without destroying window layout
local function bufdelete(force)
  local buf = vim.api.nvim_get_current_buf()
  if not force and vim.bo[buf].modified then
    vim.notify("Buffer has unsaved changes", vim.log.levels.WARN)
    return
  end
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.api.nvim_win_call(win, function()
      if not vim.api.nvim_win_is_valid(win) then return end
      local alt = vim.fn.bufnr "#"
      if alt > 0 and alt ~= buf and vim.fn.buflisted(alt) == 1 then
        vim.api.nvim_win_set_buf(win, alt)
      else
        vim.cmd "bprevious"
      end
      if vim.api.nvim_win_get_buf(win) == buf then
        vim.cmd "enew"
      end
    end)
  end
  vim.api.nvim_buf_delete(buf, { force = force })
end

-- Buffer navigation
map("n", "<S-l>", ":bnext<CR>", opts)
map("n", "<S-h>", ":bprevious<CR>", opts)
map("n", "<leader>bd", function() bufdelete(false) end, { desc = "Delete buffer" })
map("n", "Q", function() bufdelete(false) end, opts)

-- Clear search highlight
map("n", "<Esc>", ":nohlsearch<CR>", opts)

-- Better indenting (stay in visual mode)
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Move lines up/down
map("n", "<A-j>", ":m .+1<CR>==", opts)
map("n", "<A-k>", ":m .-2<CR>==", opts)
map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Keep cursor centered when scrolling
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

-- Paste without yanking selection
map("v", "p", '"_dP', opts)

-- Quick save/quit
map("n", "<leader>w", ":w<CR>", { desc = "Save" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit" })

-- Split windows
map("n", "<leader>sv", ":vsplit<CR>", { desc = "Split vertical" })
map("n", "<leader>sh", ":split<CR>", { desc = "Split horizontal" })
