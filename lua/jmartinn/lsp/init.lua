local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require("jmartinn.lsp.mason")
require("jmartinn.lsp.handlers").setup()
require("jmartinn.lsp.null-ls")
require'lspconfig'.phpactor.setup{}
