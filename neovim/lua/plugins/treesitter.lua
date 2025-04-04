return {
	{
		"nvim-treesitter/nvim-treesitter",
		main = "nvim-treesitter.configs",
		event = { "BufRead", "BufNewFile" },
		build = ":TSUpdate",
		opts = {
			auto_install = true,
			ensure_installed = {
				-- Vimdocを開く時エラーになるため
				"vimdoc",
				-- neovimのLua設定ファイルを開く時、自動でインストールされないため
				"lua",
				-- gitcommitでdiff表示している場合、自動でインストールされないため
				"diff",
				-- markdownでWiki Link表示している場合、自動でインストールされないため
				"markdown_inline",
			},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "markdown" },
			},
			indent = {
				enable = true,
				disable = {},
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = { "BufNewFile", "BufReadPre" },
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
		main = "nvim-treesitter.configs",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = "InsertEnter",
		opts = {
			endwise = {
				enable = true,
			},
		},
	},
	{
		"windwp/nvim-autopairs",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = "InsertEnter",
		opts = {
			check_ts = true,
		},
	},
}
