local M = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    "saghen/blink.cmp",
  },
}

function M.config()
  local icons = require "config.icons"

  -- LSP keymaps (only when LSP attaches)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)

      -- Disable semantic tokens for servers where treesitter highlighting is better
      local disable_semantic_tokens_for = {
        vtsls = true,
        -- Add other servers here if needed (e.g., gopls = true)
      }

      if client and disable_semantic_tokens_for[client.name] then
        client.server_capabilities.semanticTokensProvider = nil
      end

      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
      end

      map("gd", vim.lsp.buf.definition, "Go to definition")
      map("gD", vim.lsp.buf.declaration, "Go to declaration")
      map("gr", vim.lsp.buf.references, "Go to references")
      map("gI", vim.lsp.buf.implementation, "Go to implementation")
      map("K", function()
        vim.lsp.buf.hover { border = "rounded" }
      end, "Hover documentation")
      map("<leader>la", vim.lsp.buf.code_action, "Code action")
      map("<leader>lr", vim.lsp.buf.rename, "Rename")
      map("gl", vim.diagnostic.open_float, "Line diagnostics")
      map("<leader>ld", vim.diagnostic.open_float, "Line diagnostics")
      map("[d", function()
        vim.diagnostic.jump { count = -1, float = true }
      end, "Previous diagnostic")
      map("]d", function()
        vim.diagnostic.jump { count = 1, float = true }
      end, "Next diagnostic")
      map("<leader>lj", function()
        vim.diagnostic.jump { count = 1, float = true }
      end, "Next diagnostic")
      map("<leader>lk", function()
        vim.diagnostic.jump { count = -1, float = true }
      end, "Previous diagnostic")
      map("<leader>lq", vim.diagnostic.setloclist, "Diagnostics quickfix")
    end,
  })

  -- Diagnostic config
  vim.diagnostic.config {
    virtual_text = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
        [vim.diagnostic.severity.WARN] = icons.diagnostics.Warning,
        [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
        [vim.diagnostic.severity.INFO] = icons.diagnostics.Information,
      },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = true,
      header = "",
      prefix = "",
    },
  }

  -- Completion capabilities for every server
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok, blink = pcall(require, "blink.cmp")
  if ok then
    capabilities = blink.get_lsp_capabilities(capabilities)
  end
  vim.lsp.config("*", { capabilities = capabilities })

  -- Per-server overrides: drop a <server>.lua in config/lspsettings/ and it
  -- extends the nvim-lspconfig defaults via vim.lsp.config()
  local settings_dir = vim.fn.stdpath("config") .. "/lua/config/lspsettings"
  for file in vim.fs.dir(settings_dir) do
    local server = file:gsub("%.lua$", "")
    vim.lsp.config(server, require("config.lspsettings." .. server))
  end

  -- Mason installs servers; mason-lspconfig auto-enables them (vim.lsp.enable)
  require("mason").setup {
    ui = {
      border = "rounded",
    },
  }

  require("mason-lspconfig").setup {
    ensure_installed = {
      "lua_ls",
      "vtsls",
      "eslint",
      "jsonls",
      "cssls",
      "html",
      "tailwindcss",
      "pyright",
      "gopls",
      "intelephense",
      "yamlls",
    },
  }

  -- Servers outside Mason: sourcekit-lsp ships with the Xcode toolchain
  vim.lsp.enable("sourcekit")
end

return M
