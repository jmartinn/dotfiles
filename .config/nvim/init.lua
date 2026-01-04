-- Minimal Neovim Config
-- Structure: lua/config/ for settings, lua/plugins/ for plugin specs

-- Load core settings first (before plugins)
require("config.options")
require("config.keymaps")

-- Bootstrap and load plugins
require("config.lazy")

-- Load autocommands after plugins
require("config.autocmds")
