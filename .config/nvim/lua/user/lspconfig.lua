local M = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    {
      "folke/lazydev.nvim",
    },
  },
}

local function lsp_keymaps(bufnr)
  local opts = { buffer = bufnr, noremap = true, silent = true }

  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", function()
    vim.lsp.buf.hover { border = "single", max_height = 25, max_width = 120 }
  end, opts)
  vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "gl", vim.diagnostic.open_float, opts)
end

M.on_attach = function(client, bufnr)
  lsp_keymaps(bufnr)
end

function M.common_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  }
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  return capabilities
end

function M.config()
  local wk = require "which-key"

  -- Combine all which-key mappings into one block
  wk.add {
    { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>",   desc = "Code Action",    mode = { "n", "v" } },
    {
      "<leader>lf",
      "<cmd>lua vim.lsp.buf.format({async = true, filter = function(client) return client.name ~= 'typescript-tools' end})<cr>",
      desc = "Format",
    },
    { "<leader>li", "<cmd>LspInfo<cr>",                         desc = "Info" },
    { "<leader>lj", "<cmd>lua vim.diagnostic.goto_next()<cr>",  desc = "Next Diagnostic" },
    { "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev()<cr>",  desc = "Prev Diagnostic" },
    { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>",      desc = "CodeLens Action" },
    { "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", desc = "Quickfix" },
    { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>",        desc = "Rename" },
  }

  local lspconfig = require "lspconfig"
  local icons = require "user.icons"

  -- NOTE: If you want better TypeScript/JavaScript support, consider replacing
  -- "ts_ls" with "vtsls". Install with: npm install -g @vtsls/language-server
  local servers = {
    "lua_ls",
    "cssls",
    "html",
    "ts_ls",
    "gopls",
    "eslint",
    "pyright",
    "prismals",
    "bashls",
    "jsonls",
    "yamlls",
    "marksman",
    "tailwindcss",
    "intelephense",
  }

  local default_diagnostic_config = {
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
        [vim.diagnostic.severity.WARN] = icons.diagnostics.Warning,
        [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
        [vim.diagnostic.severity.INFO] = icons.diagnostics.Information,
      },
    },
    virtual_text = true,
    update_in_insert = false,
    underline = true,
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

  vim.diagnostic.config(default_diagnostic_config)

  if vim.fn.has "nvim-0.11" == 1 then
    vim.lsp.config("*", {
      float = {
        border = "rounded",
      },
    })
  else
    -- Legacy API for Neovim < 0.11
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
    vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

    pcall(function()
      require("lspconfig.ui.windows").default_options.border = "rounded"
    end)
  end

  -- Setup each language server with error handling
  for _, server in pairs(servers) do
    -- Skip lua_ls as it's auto-configured by lazydev (see lazydev.lua)
    if server == "lua_ls" then
      goto continue
    end

    local opts = {
      on_attach = M.on_attach,
      capabilities = M.common_capabilities(),
    }

    -- Try to load server-specific settings
    local require_ok, settings = pcall(require, "user.lspsettings." .. server)
    if require_ok then
      opts = vim.tbl_deep_extend("force", settings, opts)
    end

    -- Setup the server using the modern approach
    local setup_ok, err = pcall(function()
      if vim.lsp.enable and type(vim.lsp.enable) == "function" and vim.fn.has "nvim-0.11" == 1 then
        local configs = require "lspconfig.configs"
        local default_config = configs[server] and configs[server].default_config or {}

        local final_opts = vim.tbl_deep_extend("force", default_config, opts)

        vim.lsp.config(server, final_opts)
        vim.lsp.enable(server)

        -- Set up FileType autocmds to actually start the LSP on matching files
        local filetypes = final_opts.filetypes or {}
        if #filetypes > 0 then
          vim.api.nvim_create_autocmd("FileType", {
            pattern = filetypes,
            callback = function(args)
              vim.lsp.start({
                name = server,
                cmd = final_opts.cmd,
                root_dir = final_opts.root_dir and final_opts.root_dir(args.file) or vim.fs.root(args.buf, {".git"}),
              })
            end,
          })
        end
      else
        lspconfig[server].setup(opts)
      end
    end)

    if not setup_ok then
      vim.notify(
        string.format("Failed to setup LSP server '%s': %s", server, tostring(err)),
        vim.log.levels.WARN,
        { title = "LSP Config" }
      )
    end

    ::continue::
  end
end

return M
