local util = require "lspconfig.util"
return {
  cmd = { "tailwindcss-language-server", "--stdio" },
  -- filetypes copied and adjusted from tailwindcss-intellisense
  filetypes = {
    "typescript-react",
  },
  settings = {
    tailwindcss = {
      validate = true,
      lint = {
        cssConflict = "warning",
        invalidApply = "error",
        invalidScreen = "error",
        invalidVariant = "error",
        invalidConfigPath = "error",
        invalidTailwindDirective = "error",
        recommendedVariantOrder = "warning",
      },
      classAttributes = {
        "class",
        "className",
        "class:list",
        "classList",
        "ngClass",
      },
      includeLanguages = {
        eelixir = "html-eex",
        eruby = "erb",
        templ = "html",
        htmlangular = "html",
      },
    },
  },
  on_new_config = function(new_config)
    if not new_config.settings then
      new_config.settings = {}
    end
    if not new_config.settings.editor then
      new_config.settings.editor = {}
    end
    if not new_config.settings.editor.tabSize then
      -- set tab size for hover
      new_config.settings.editor.tabSize = vim.lsp.util.get_effective_tabstop()
    end
  end,
  root_dir = function(fname)
    return util.root_pattern(
      "tailwind.config.js",
      "tailwind.config.cjs",
      "tailwind.config.mjs",
      "tailwind.config.ts",
      "postcss.config.js",
      "postcss.config.cjs",
      "postcss.config.mjs",
      "postcss.config.ts"
    )(fname) or util.find_package_json_ancestor(fname) or util.find_node_modules_ancestor(fname) or util.find_git_ancestor(
      fname
    )
  end,
}
