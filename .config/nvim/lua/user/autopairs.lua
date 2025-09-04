local M = {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	dependencies = { "hrsh7th/nvim-cmp" },
}

M.config = function()
	local npairs = require("nvim-autopairs")
	local Rule = require('nvim-autopairs.rule')
	
	npairs.setup({
		check_ts = true,
		ts_config = {
			lua = {'string', 'source'},
			javascript = {'string', 'template_string'},
			typescript = {'string', 'template_string'},
			java = false,
		},
		disable_filetype = { "TelescopePrompt", "spectre_panel" },
		disable_in_macro = true,
		disable_in_visualblock = false,
		disable_in_replace_mode = true,
		ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
		enable_moveright = true,
		enable_afterquote = true,
		enable_check_bracket_line = true,
		enable_bracket_in_quote = true,
		enable_abbr = false,
		break_undo = true,
		check_comma = true,
		map_cr = true,
		map_bs = true,
		map_c_h = false,
		map_c_w = false,
	})

	-- Integration with nvim-cmp
	local cmp_autopairs = require('nvim-autopairs.completion.cmp')
	local cmp = require('cmp')
	cmp.event:on(
		'confirm_done',
		cmp_autopairs.on_confirm_done()
	)

	-- Add spaces between parentheses
	local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
	npairs.add_rules {
		Rule(' ', ' ')
			:with_pair(function (opts)
				local pair = opts.line:sub(opts.col - 1, opts.col)
				return vim.tbl_contains({
					brackets[1][1]..brackets[1][2],
					brackets[2][1]..brackets[2][2],
					brackets[3][1]..brackets[3][2],
				}, pair)
			end)
	}
	for _,bracket in pairs(brackets) do
		npairs.add_rules {
			Rule(bracket[1]..' ', ' '..bracket[2])
				:with_pair(function() return false end)
				:with_move(function(opts)
					return opts.prev_char:match('.%'..bracket[2]) ~= nil
				end)
				:use_key(bracket[2])
		}
	end
end

return M
