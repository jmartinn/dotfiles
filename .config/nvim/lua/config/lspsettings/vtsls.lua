-- vtsls speaks VS Code-shaped settings: https://github.com/yioneko/vtsls
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
