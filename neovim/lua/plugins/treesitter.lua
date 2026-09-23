return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")
			ts.install({
				-- Vimdocを開く時エラーになるため
				"vimdoc",
				-- neovimのLua設定ファイルを開く時、自動でインストールされないため
				"lua",
				-- gitcommitでdiff表示している場合、自動でインストールされないため
				"diff",
				-- markdownでWiki Link表示している場合、自動でインストールされないため
				"markdown_inline",
			})

			local function attach(buf, lang)
				if not pcall(vim.treesitter.start, buf, lang) then
					return
				end
				vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				if lang == "markdown" then
					vim.bo[buf].syntax = "on"
				end
			end

			-- mainブランチにはauto_installが無いため、FileType毎に不足しているparserを入れる
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local lang = vim.treesitter.language.get_lang(args.match)
					if not lang then
						return
					end
					if vim.list_contains(ts.get_installed(), lang) then
						attach(args.buf, lang)
					elseif vim.list_contains(ts.get_available(), lang) then
						ts.install(lang):await(function()
							vim.schedule(function()
								if vim.api.nvim_buf_is_valid(args.buf) then
									attach(args.buf, lang)
								end
							end)
						end)
					end
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		lazy = false,
		opts = {
			enable = true,
			multiwindow = false,
			max_lines = 0,
			min_window_height = 0,
			line_numbers = true,
			multiline_threshold = 20,
			trim_scope = "outer",
			mode = "cursor",
			separator = nil,
			zindex = 20,
			on_attach = nil,
		},
	},
	{
		"RRethy/nvim-treesitter-endwise",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		lazy = false,
	},
	{
		"windwp/nvim-autopairs",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		lazy = false,
		opts = {
			check_ts = true,
		},
	},
}
