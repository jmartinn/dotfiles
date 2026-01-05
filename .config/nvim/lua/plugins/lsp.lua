local M = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
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
        ts_ls = true,
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
    end,
  })

  -- Diagnostic signs
  local signs = {
    { name = "DiagnosticSignError", text = icons.diagnostics.Error },
    { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
    { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
    { name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
  }
  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  -- LspInfo window border
  require("lspconfig.ui.windows").default_options.border = "rounded"

  -- Diagnostic config
  vim.diagnostic.config {
    virtual_text = true,
    signs = {
      active = signs,
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  -- LSP capabilities for completion
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
  if ok then
    capabilities = vim.tbl_deep_extend("force", capabilities, cmp_lsp.default_capabilities())
  end

  -- Mason setup
  require("mason").setup {
    ui = {
      border = "rounded",
    },
  }

  -- Mason-lspconfig setup
  require("mason-lspconfig").setup {
    ensure_installed = {
      "lua_ls",
      "ts_ls",
      "eslint",
      "jsonls",
      "cssls",
      "html",
      "tailwindcss",
      "pyright",
      "gopls",
    },
    handlers = {
      -- Default handler - tries to load custom settings from config/lspsettings/
      function(server_name)
        local opts = {
          capabilities = capabilities,
        }

        -- Try to load server-specific settings
        local has_custom_opts, server_opts = pcall(require, "config.lspsettings." .. server_name)
        if has_custom_opts then
          opts = vim.tbl_deep_extend("force", opts, server_opts)
        end

        -- require("lspconfig")[server_name].setup(opts)
      end,
    },
  }
end

return M
