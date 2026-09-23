return {
  "vyfor/cord.nvim",
  event = "VeryLazy",
  cmd = "Cord",
  opts = function()
    local async = require "cord.core.async"
    local process = require "cord.core.uv.process"

    return {
      display = {
        theme = "classic",
      },
      editor = {
        tooltip = "Neovim",
      },
      idle = {
        timeout = 300000,
      },
      text = {
        editing = function(opts)
          return "Editing " .. opts.filename .. (vim.bo.modified and " [+]" or "")
        end,
        workspace = async.wrap(function(opts)
          local workspace = opts.workspace or ""
          if not opts.workspace_dir then
            return workspace
          end

          -- Cache per project so buffer changes do not repeatedly spawn Git.
          local branch = opts.cache:get_or_compute(opts.workspace_dir .. ":git_branch", 30, function()
            local result, err = process
              .spawn({
                cmd = "git",
                args = { "branch", "--show-current" },
                cwd = opts.workspace_dir,
              })
              :await()

            if err or not result or result.code ~= 0 then
              return false
            end
            local name = vim.trim(result.stdout or "")
            return name ~= "" and name or false
          end)

          return branch and (workspace .. " · " .. branch) or workspace
        end),
      },
      extensions = {
        tmux = {
          on_attach = "show",
          on_detach = "hide",
        },
      },
      advanced = {
        discord = {
          reconnect = {
            enabled = true,
          },
        },
      },
    }
  end,
}
