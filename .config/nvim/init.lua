-- Core Setup
require "user.launch" -- Launch sequence or bootstrap logic
require "user.options" -- Core options
require "user.keymaps" -- Key mappings
require "user.autocmds" -- Auto commands

-- UI and Aesthetics
spec "user.colorscheme" -- Theme and colors
spec "user.devicons" -- Icons
spec "user.lualine" -- Status line
spec "user.navic" -- Navigation indicator (LSP)
spec "user.breadcrumbs" -- Breadcrumbs

-- Core Plugins
spec "user.treesitter" -- Syntax highlighting
spec "user.mason" -- LSP, DAP, Linters/Formatters installer
spec "user.schemastore" -- JSON schemas
spec "user.lspconfig" -- LSP configuration
spec "user.cmp" -- Autocompletion

-- Additional Tools and Extensions
spec "user.telescope" -- Fuzzy finder
spec "user.none-ls" -- Null-LS integration (formatters/linters)
spec "user.illuminate" -- Highlight word under cursor
spec "user.gitsigns" -- Git integration
spec "user.whichkey" -- Keybinding hints
spec "user.nvimtree" -- File explorer
spec "user.comment" -- Commenting utility
spec "user.harpoon" -- Quick file navigation
spec "user.neogit" -- Git interface
spec"user.tmux" -- Tmux integration

-- Text Enhancements and Other Utilities
spec "user.autopairs" -- Auto close brackets and quotes
spec "user.alpha" -- Startup screen
spec "user.project" -- Project management
spec "user.indentline" -- Indentation lines
spec "user.toggleterm" -- Terminal management
spec "user.bufdelete" -- Buffer deletion management
spec "user.dap" -- Debugging
spec "user.luvit" -- Lua plugin development
spec "user.lazydev" -- Lazy development utilities

-- Extras
spec "user.extras.colorizer" -- Color highlighter
spec "user.extras.obsidian" -- Obsidian note integration
spec "user.extras.vimtex" -- LaTeX support
spec "user.extras.pomo" -- Pomodoro timer
spec "user.extras.modicator" -- Mode indicator
spec "user.extras.rainbow" -- Rainbow parentheses
spec "user.extras.zen" -- Distraction-free mode
spec "user.extras.bqf" -- Quickfix enhancements
spec "user.extras.dressing" -- UI components
spec "user.extras.eyeliner" -- Motion highlighting
spec "user.extras.navbuddy" -- LSP code navigation
spec "user.extras.surround" -- Surround text manipulation
spec "user.extras.oil" -- Floating terminal/file viewer
-- spec "user.extras.fidget" -- LSP progress indicator
spec "user.extras.neotab" -- Tab management
spec "user.extras.lab" -- Laboratory for testing
spec "user.extras.tabby" -- Tabline plugin
spec "user.extras.tsc" -- TypeScript support
spec "user.extras.gitlinker" -- Git link generator
spec "user.extras.todo-comments" -- Highlight and manage TODOs
spec "user.extras.ufo" -- Code folding
spec "user.extras.cellular-automaton" -- Cellular Automaton simulation
spec "user.extras.discord"
spec"user.extras.llm" -- AI
spec "user.extras.avante"

require "user.lazy" -- Plugin manager
