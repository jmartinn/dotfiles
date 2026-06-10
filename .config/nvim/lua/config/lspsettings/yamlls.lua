return {
  settings = {
    yaml = {
      schemaStore = {
        -- schemastore.nvim provides the catalog; disable the built-in one
        enable = false,
        url = "",
      },
      schemas = require("schemastore").yaml.schemas(),
    },
  },
}
