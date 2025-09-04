return {
  -- Command to start the server
  cmd = { "typescript-language-server", "--stdio" },
  
  -- Server initialization options
  init_options = {
    hostInfo = "neovim",
    -- For Vue.js support, uncomment and configure:
    -- plugins = {
    --   {
    --     name = "@vue/typescript-plugin",
    --     location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
    --     languages = { "javascript", "typescript", "vue" },
    --   },
    -- },
    -- TSServer process options
    tsserver = {
      -- Path to tsserver log directory (useful for debugging)
      -- logDirectory = vim.fn.stdpath("cache") .. "/tsserver",
      -- Verbosity: 'off' | 'messages' | 'verbose'
      -- trace = "messages",
      -- Syntax server: 'auto' | 'never' | 'always'
      useSyntaxServer = "auto",
      -- Memory limit in MB (increase for large projects)
      maxTsServerMemory = 4096,
    },
  },
  
  -- Server settings
  settings = {
    typescript = {
      -- Inlay Hints configuration
      inlayHints = {
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayVariableTypeHints = false,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
      },
      -- Suggest configuration
      suggest = {
        includeCompletionsForModuleExports = true,
        includeCompletionsForImportStatements = true,
      },
      -- Preferences
      preferences = {
        includePackageJsonAutoImports = "auto", -- 'auto' | 'on' | 'off'
        importModuleSpecifier = "shortest", -- 'shortest' | 'relative' | 'non-relative' | 'auto'
        quoteStyle = "auto", -- 'auto' | 'single' | 'double'
      },
      -- Format settings
      format = {
        enable = true,
        insertSpaceAfterCommaDelimiter = true,
        insertSpaceAfterSemicolonInForStatements = true,
        insertSpaceAfterKeywordsInControlFlowStatements = true,
        insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
        insertSpaceBeforeAndAfterBinaryOperators = true,
        placeOpenBraceOnNewLineForFunctions = false,
        placeOpenBraceOnNewLineForControlBlocks = false,
        semicolons = "insert", -- 'ignore' | 'insert' | 'remove'
      },
      -- Update imports on file move
      updateImportsOnFileMove = {
        enabled = "always", -- 'prompt' | 'always' | 'never'
      },
      -- Diagnostics
      validate = {
        enable = true,
      },
    },
    javascript = {
      -- Same settings structure applies to JavaScript
      inlayHints = {
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayVariableTypeHints = false,
      },
      suggest = {
        includeCompletionsForModuleExports = true,
        includeCompletionsForImportStatements = true,
      },
      preferences = {
        includePackageJsonAutoImports = "auto",
        importModuleSpecifier = "shortest",
        quoteStyle = "auto",
      },
      format = {
        enable = true,
        insertSpaceAfterCommaDelimiter = true,
        insertSpaceAfterSemicolonInForStatements = true,
        insertSpaceAfterKeywordsInControlFlowStatements = true,
        insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
        insertSpaceBeforeAndAfterBinaryOperators = true,
        placeOpenBraceOnNewLineForFunctions = false,
        placeOpenBraceOnNewLineForControlBlocks = false,
        semicolons = "insert",
      },
      updateImportsOnFileMove = {
        enabled = "always",
      },
      validate = {
        enable = true,
      },
    },
  },
}
