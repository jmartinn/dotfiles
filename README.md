# My Neovim Configuration

This repository contains my personal Neovim configuration, which includes a set of essential plugins and custom keybindings for a productive and efficient coding experience. The configuration is written in Lua and is well-structured, making it a great starting point for anyone looking to customize their Neovim setup.

## Features

## Features

- Language Server Protocol (LSP) support using [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [Telescope](https://github.com/nvim-telescope/telescope.nvim) for powerful and flexible fuzzy finding
- Automatic handling of brackets, quotes, and other pairs with [nvim-autopairs](https://github.com/windwp/nvim-autopairs)
- File explorer integrated into Neovim with [nvim-tree](https://github.com/kyazdani42/nvim-tree.lua)
- Git integration, including signs and blame information, through [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- Debug Adapter Protocol (DAP) integration with [nvim-dap](https://github.com/mfussenegger/nvim-dap), [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui), and [DAPInstall.nvim](https://github.com/ravenxrz/DAPInstall.nvim)
- Completion powered by [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) and various completion sources
- Snippet support with [LuaSnip](https://github.com/L3MON4D3/LuaSnip) and [friendly-snippets](https://github.com/rafamadriz/friendly-snippets)
- Treesitter integration using [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- Bufferline management with [bufferline.nvim](https://github.com/akinsho/bufferline.nvim)
- Status line customization with [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
- Improved Neovim startup time using [impatient.nvim](https://github.com/lewis6991/impatient.nvim)
- Buffer deletion without closing the window via [vim-bbye](https://github.com/moll/vim-bbye)
- Comment management with [Comment.nvim](https://github.com/numToStr/Comment.nvim)
- Project management using [project.nvim](https://github.com/ahmedkhalf/project.nvim)
- Various colorschemes, including [darkplus.nvim](https://github.com/lunarvim/darkplus.nvim), [onedarkpro.nvim](https://github.com/olimorris/onedarkpro.nvim), and [gruvbox](https://github.com/gruvbox-community/gruvbox)
- Illumination of matching text with [vim-illuminate](https://github.com/RRethy/vim-illuminate)
- GitHub Copilot integration using [copilot.vim](https://github.com/github/copilot.vim)
- Support for Prisma schema files with [vim-prisma](https://github.com/pantharshit00/vim-prisma)


## Installation

1. Ensure that you have [Neovim](https://neovim.io/) installed (version 0.5 or higher is recommended).
2. Backup your existing Neovim configuration (if any): `mv ~/.config/nvim ~/.config/nvim.backup`
3. Clone this repository: `git clone https://github.com/jmartinn/neovim-config.git ~/.config/nvim`
4. Install the required plugins. You can do this by opening Neovim and running `:PackerSync` (or the appropriate command for your plugin manager).
5. (Add any additional setup steps or dependencies here)

## Customization

This configuration is designed to be easily customizable. The `init.lua` file is well-structured, with separate Lua files for various settings, keybindings, and plugins. Feel free to explore and modify the configuration to suit your preferences.

### Keybindings

(Include a brief overview of your custom keybindings here, or refer users to a separate file with keybinding documentation)

## Contributing

If you have any suggestions or improvements for this configuration, feel free to submit a pull request or create an issue on GitHub. I'm always open to feedback and collaboration!

## License

This Neovim configuration is released under the [MIT License](LICENSE).
