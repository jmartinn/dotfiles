local M = {}

-- Share vtsls's project-root and Deno detection before either server overrides it.
M.root_dir = vim.lsp.config.vtsls.root_dir

function M.uses_native_typescript(root_dir)
  local package_json_path = vim.fs.joinpath(root_dir, "node_modules", "typescript", "package.json")
  local read_ok, lines = pcall(vim.fn.readfile, package_json_path)
  if not read_ok or #lines == 0 then
    return false
  end

  local decode_ok, package_json = pcall(vim.json.decode, table.concat(lines, "\n"))
  if not decode_ok or type(package_json) ~= "table" or type(package_json.version) ~= "string" then
    return false
  end

  local version = vim.version.parse(package_json.version)
  return version ~= nil and version.major >= 7
end

return M
