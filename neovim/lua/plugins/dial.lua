return {
	{
		"monaqa/dial.nvim",
		event = { "BufNewFile", "BufReadPre" },
		keys = {
			{ "<C-a>", "<Plug>(dial-increment)" },
			{ "<C-x>", "<Plug>(dial-decrement)" },
			{ "g<C-a>", "g<Plug>(dial-increment)" },
			{ "g<C-x>", "g<Plug>(dial-decrement)" },
		},
		config = function()
			local augend = require("dial.augend")
			require("dial.config").augends:register_group({
				default = {
					augend.integer.alias.decimal,
					augend.integer.alias.hex,
					augend.date.alias["%Y/%m/%d"],
					augend.date.alias["%Y-%m-%d"],
					augend.date.alias["%Y年%-m月%-d日"],
					augend.date.alias["%Y年%-m月%-d日(%ja)"],
					augend.date.alias["%H:%M:%S"],
					augend.constant.alias.ja_weekday,
					augend.constant.alias.ja_weekday_full,
					augend.constant.alias.bool,
					augend.semver.alias.semver,
				},
			})
		end,
	},
}
