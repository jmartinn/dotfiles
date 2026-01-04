-- https://luals.github.io/wiki/settings/
-- Note: lazydev.nvim handles vim globals and Neovim library paths
return {
  settings = {
    Lua = {
      format = {
        enable = false,
      },
      diagnostics = {
        globals = { "vim", "spec" },
      },
      runtime = {
        version = "LuaJIT",
        special = {
          spec = "require",
        },
      },
      workspace = {
        checkThirdParty = false,
      },
      hint = {
        enable = true,
        arrayIndex = "Disable",
        await = true,
        paramName = "All",
        paramType = true,
        semicolon = "Disable",
        setType = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
