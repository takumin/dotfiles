return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			-- Define your formatters
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "goimports", "gofumpt" },
				python = { "ruff_fix", "isort", "black", stop_after_first = true },
				javascript = { "biome-check", "prettierd", "prettier", stop_after_first = true },
				javascriptreact = { "biome-check", "prettierd", "prettier", stop_after_first = true },
				typescript = { "biome-check", "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "biome-check", "prettierd", "prettier", stop_after_first = true },
				html = { "biome-check", "prettierd", "prettier", stop_after_first = true },
				css = { "biome-check", "prettierd", "prettier", stop_after_first = true },
				json = { "biome-check", "prettierd", "prettier", stop_after_first = true },
				jsonc = { "biome-check", "prettierd", "prettier", stop_after_first = true },
				yaml = { "yamlfmt", "yamlfix", stop_after_first = true },
				toml = { "taplo", stop_after_first = true },
				hcl = { "hcl", stop_after_first = true },
			},
			-- Set default options
			default_format_opts = {
				lsp_format = "fallback",
			},
			-- Set up format-on-save
			format_on_save = {
				timeout_ms = 500,
			},
			-- Customize formatters
			formatters = {
				shfmt = {
					prepend_args = { "-i", "2" },
				},
			},
		},
		init = function()
			-- If you want the formatexpr, here is the place to set it
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},
}
