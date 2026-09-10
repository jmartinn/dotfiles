-- vtsls speaks VS Code-shaped settings: https://github.com/yioneko/vtsls
local default_root_dir = vim.lsp.config.vtsls.root_dir

local function uses_native_typescript(root_dir)
  local package_json_path = vim.fs.joinpath(root_dir, "node_modules", "typescript", "package.json")
  local read_ok, lines = pcall(vim.fn.readfile, package_json_path)
  if not read_ok or #lines == 0 then
    return false
  end

  local decode_ok, package_json = pcall(vim.json.decode, table.concat(lines, "\n"))
  if not decode_ok or type(package_json.version) ~= "string" then
    return false
  end

  local version = vim.version.parse(package_json.version)
  return version ~= nil and version.major >= 7
end

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
    default_root_dir(bufnr, function(root_dir)
      if not uses_native_typescript(root_dir) then
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
