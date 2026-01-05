local M = {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
}

function M.config()
  require("nvim-treesitter-textobjects").setup({
    select = {
      lookahead = true,
      include_surrounding_whitespace = false,
    },
    move = {
      set_jumps = true,
    },
  })

  local select = require("nvim-treesitter-textobjects.select")
  local move = require("nvim-treesitter-textobjects.move")

  -- Select textobjects
  local function map_select(key, query, desc)
    vim.keymap.set({ "x", "o" }, key, function()
      select.select_textobject(query, "textobjects")
    end, { desc = desc })
  end

  -- Functions
  map_select("af", "@function.outer", "around function")
  map_select("if", "@function.inner", "inside function")

  -- Classes
  map_select("at", "@class.outer", "around class")
  map_select("it", "@class.inner", "inside class")

  -- Calls
  map_select("ac", "@call.outer", "around call")
  map_select("ic", "@call.inner", "inside call")

  -- Parameters/arguments
  map_select("aa", "@parameter.outer", "around parameter")
  map_select("ia", "@parameter.inner", "inside parameter")

  -- Loops
  map_select("al", "@loop.outer", "around loop")
  map_select("il", "@loop.inner", "inside loop")

  -- Conditionals
  map_select("ai", "@conditional.outer", "around conditional")
  map_select("ii", "@conditional.inner", "inside conditional")

  -- Comments
  map_select("a/", "@comment.outer", "around comment")
  map_select("i/", "@comment.inner", "inside comment")

  -- Blocks
  map_select("ab", "@block.outer", "around block")
  map_select("ib", "@block.inner", "inside block")

  -- Statements
  map_select("as", "@statement.outer", "around statement")

  -- Attributes
  map_select("aA", "@attribute.outer", "around attribute")
  map_select("iA", "@attribute.inner", "inside attribute")

  -- Movement between functions
  local function map_move(key, func, query, desc)
    vim.keymap.set({ "n", "x", "o" }, key, function()
      func(query, "textobjects")
    end, { desc = desc })
  end

  map_move("]f", move.goto_next_start, "@function.outer", "Next function start")
  map_move("]F", move.goto_next_end, "@function.outer", "Next function end")
  map_move("[f", move.goto_previous_start, "@function.outer", "Previous function start")
  map_move("[F", move.goto_previous_end, "@function.outer", "Previous function end")

  map_move("]c", move.goto_next_start, "@class.outer", "Next class start")
  map_move("]C", move.goto_next_end, "@class.outer", "Next class end")
  map_move("[c", move.goto_previous_start, "@class.outer", "Previous class start")
  map_move("[C", move.goto_previous_end, "@class.outer", "Previous class end")

  -- Make movements repeatable with ; and ,
  local ts_repeat = require("nvim-treesitter-textobjects.repeatable_move")
  vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat.repeat_last_move_next)
  vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat.repeat_last_move_previous)
end

return M
