-- vtsls speaks VS Code-shaped settings: https://github.com/yioneko/vtsls
local typescript = require "config.typescript"

local ts_settings = {
  inlayHints = {
    enumMemberValues = { enabled = true },
    functionLikeReturnTypes = { enabled = false },
    parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = true },
    parameterTypes = { enabled = false },
    propertyDeclarationTypes = { enabled = false },
    variableTypes = { enabled = false },
  },
  suggest = {
    autoImports = true,
    completeFunctionCalls = true,
    includeCompletionsForImportStatements = true,
  },
  preferences = {
    includePackageJsonAutoImports = "auto", -- 'auto' | 'on' | 'off'
    importModuleSpecifier = "shortest", -- 'shortest' | 'relative' | 'non-relative' | 'auto'
    quoteStyle = "auto", -- 'auto' | 'single' | 'double'
  },
  updateImportsOnFileMove = {
    enabled = "always", -- 'prompt' | 'always' | 'never'
  },
  tsserver = {
    useSyntaxServer = "auto", -- 'auto' | 'never' | 'always'
    maxTsServerMemory = 4096,
  },
}

return {
  -- TypeScript 7 ships a native LSP. Let the `tsc` config handle those
  -- projects and reserve vtsls for the JavaScript-based TypeScript server.
  root_dir = function(bufnr, on_dir)
    typescript.root_dir(bufnr, function(root_dir)
      if not typescript.uses_native_typescript(root_dir) then
        on_dir(root_dir)
      end
    end)
  end,
  settings = {
    typescript = ts_settings,
    javascript = ts_settings,
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
    },
  },
}
