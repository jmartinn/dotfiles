-- Options
local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true
opt.numberwidth = 4
opt.signcolumn = "yes"

-- UI
opt.cmdheight = 1
opt.pumblend = 0
opt.showtabline = 1
opt.showcmd = false
opt.ruler = false
opt.title = true
opt.titlelen = 0
opt.guicursor = ""
opt.guifont = "monospace:h17"
opt.fillchars = { eob = " ", stl = " " }

-- Tabs & Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Line wrapping
opt.wrap = false

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

-- Appearance
opt.termguicolors = true
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.showmode = false
opt.laststatus = 3
opt.pumheight = 10

-- Behavior
opt.splitbelow = true
opt.splitright = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.writebackup = false

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300
opt.ttimeoutlen = 10

-- Completion
opt.completeopt = { "menuone", "noselect" }

-- Spelling
opt.spelllang = { "en", "es" }

-- Misc
opt.fileencoding = "utf-8"
opt.conceallevel = 0
opt.shortmess:append("c")
opt.iskeyword:append("-")
