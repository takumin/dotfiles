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
				python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
				javascript = { "biome", "prettierd", "prettier", stop_after_first = true },
				javascriptreact = { "biome", "prettierd", "prettier", stop_after_first = true },
				typescript = { "biome", "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "biome", "prettierd", "prettier", stop_after_first = true },
				html = { "biome", "prettierd", "prettier", stop_after_first = true },
				css = { "biome", "prettierd", "prettier", stop_after_first = true },
				json = { "biome", "prettierd", "prettier", stop_after_first = true },
				jsonc = { "biome", "prettierd", "prettier", stop_after_first = true },
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
				biome = {
					args = { "check", "--write", "--stdin-file-path", "$FILENAME" },
				},
			},
		},
		init = function()
			-- If you want the formatexpr, here is the place to set it
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},
}
