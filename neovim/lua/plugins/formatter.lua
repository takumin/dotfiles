return {
	{
		"stevearc/conform.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
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
				cs = { "csharpier" },
				html = { "biome", "prettierd", "prettier", stop_after_first = true },
				css = { "biome", "prettierd", "prettier", stop_after_first = true },
				json = { "biome", "prettierd", "prettier", stop_after_first = true },
				jsonc = { "biome", "prettierd", "prettier", stop_after_first = true },
				yaml = { "yamlfmt", "yamlfix", stop_after_first = true },
				toml = { "taplo", stop_after_first = true },
				hcl = { "hcl", stop_after_first = true },
				sh = { "shfmt" },
			},
			-- Set default options
			default_format_opts = {
				lsp_format = "fallback",
			},
			-- Set up format-on-save
			format_on_save = {
				timeout_ms = 1000,
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

			-- Replace default formatter to project formatter
			vim.api.nvim_create_autocmd("BufEnter", {
				callback = function(args)
					local bufnr = args.buf
					local filepath = vim.api.nvim_buf_get_name(bufnr)
					local root = require("lspconfig.util").root_pattern(".git")(filepath)

					if not root then
						return
					end

					local formatters = {
						{
							detects = {
								".prettierrc",
								".prettierrc.json",
								".prettierrc.yaml",
							},
							comformers = {
								javascript = { "prettierd", "prettier", stop_after_first = true },
								javascriptreact = { "prettierd", "prettier", stop_after_first = true },
								typescript = { "prettierd", "prettier", stop_after_first = true },
								typescriptreact = { "prettierd", "prettier", stop_after_first = true },
								html = { "prettierd", "prettier", stop_after_first = true },
								css = { "prettierd", "prettier", stop_after_first = true },
								json = { "prettierd", "prettier", stop_after_first = true },
								jsonc = { "prettierd", "prettier", stop_after_first = true },
								yaml = { "prettierd", "prettier", stop_after_first = true },
							},
						},
					}

					for _, v in pairs(formatters) do
						for _, f in pairs(v.detects) do
							if vim.fn.filereadable(root .. "/" .. f) == 1 then
								require("conform").formatters_by_ft = v.comformers
								return
							end
						end
					end
				end,
			})
		end,
	},
}
