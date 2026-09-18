local default_config = vim.lsp.config.tsc
local typescript = require "config.typescript"

return {
  -- Keep cmd paired with root_dir: upstream shares its binary cache between them.
  cmd = default_config.cmd,
  -- Only probe for a native binary in projects that use TypeScript 7+.
  -- Other projects use vtsls and should not emit a missing-native-LSP warning.
  root_dir = function(bufnr, on_dir)
    typescript.root_dir(bufnr, function(root_dir)
      if typescript.uses_native_typescript(root_dir) then
        default_config.root_dir(bufnr, on_dir)
      end
    end)
  end,
  -- TypeScript's native LSP currently registers watchers for bundled:// URIs,
  -- which Neovim cannot represent as filesystem globs. Project files are still
  -- refreshed through normal buffer notifications; restart the LSP after
  -- changing tsconfig.json or package metadata.
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = false,
      },
    },
  },
}
