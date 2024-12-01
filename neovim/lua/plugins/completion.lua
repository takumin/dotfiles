return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		event = { "BufRead", "BufNewFile" },
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
						vim.snippet.expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "path" },
				}, {
					{ name = "buffer" },
				}),
			})

			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
				matching = { disallow_symbol_nonprefix_matching = false },
			})

			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local vscode_server_capabilities = capabilities
			vscode_server_capabilities.textDocument.completion.completionItem.snippetSupport = true

			if vim.fn.executable("lua-language-server") == 1 then
				-- see also: https://zenn.dev/uga_rosa/articles/afe384341fc2e1

				---@param names string[]
				---@return string[]
				local function get_plugin_paths(names)
					local plugins = require("lazy.core.config").plugins
					local paths = {}
					for _, name in ipairs(names) do
						if plugins[name] then
							table.insert(paths, plugins[name].dir .. "/lua")
						else
							vim.notify("Invalid plugin name: " .. name)
						end
					end
					return paths
				end

				---@param plugins string[]
				---@return string[]
				local function library(plugins)
					local paths = get_plugin_paths(plugins)
					table.insert(paths, vim.fn.stdpath("config") .. "/lua")
					table.insert(paths, vim.env.VIMRUNTIME .. "/lua")
					table.insert(paths, "${3rd}/luv/library")
					-- for plugin developer
					-- table.insert(paths, "${3rd}/busted/library")
					-- table.insert(paths, "${3rd}/luassert/library")
					return paths
				end

				require("lspconfig").lua_ls.setup({
					capabilities = capabilities,

					settings = {
						Lua = {
							runtime = {
								version = "LuaJIT",
								pathStrict = true,
								path = { "?.lua", "?/init.lua" },
							},
							workspace = {
								library = library({ "lazy.nvim" }),
								checkThirdParty = "Disable",
							},
						},
					},
				})
			end

			if vim.fn.executable("bash-language-server") == 1 then
				require("lspconfig").bashls.setup({
					capabilities = capabilities,
				})
			end

			if vim.fn.executable("clangd") == 1 then
				require("lspconfig").clangd.setup({
					capabilities = capabilities,
				})
			end

			if vim.fn.executable("gopls") == 1 then
				require("lspconfig").gopls.setup({
					capabilities = capabilities,

					settings = {
						gopls = {
							gofumpt = true,
						},
					},
				})
			end

			if vim.fn.executable("rust-analyzer") == 1 then
				require("lspconfig").rust_analyzer.setup({
					capabilities = capabilities,

					settings = {
						["rust-analyzer"] = {
							check = {
								command = "clippy",
							},
						},
					},
				})
			end

			if vim.fn.executable("ruby-lsp") == 1 then
				require("lspconfig").ruby_lsp.setup({
					capabilities = capabilities,

					init_options = {
						formatter = "standard",
						linters = { "standard" },
					},
				})
			end

			if vim.fn.executable("pylsp") == 1 then
				require("lspconfig").pylsp.setup({
					capabilities = capabilities,

					settings = {
						pylsp = {
							plugins = {
								pycodestyle = {
									-- ignore = {'W391'},
									maxLineLength = 100,
								},
							},
						},
					},
				})
			end

			if vim.fn.executable("terraform-ls") == 1 then
				require("lspconfig").terraformls.setup({
					capabilities = capabilities,
				})
			end

			if vim.fn.executable("typescript-language-server") == 1 then
				require("lspconfig").ts_ls.setup({
					capabilities = capabilities,
				})
			end

			if vim.fn.executable("biome") == 1 then
				require("lspconfig").biome.setup({
					capabilities = capabilities,
				})
			end

			if vim.fn.executable("yaml-language-server") == 1 then
				require("lspconfig").yamlls.setup({
					capabilities = capabilities,

					settings = {
						yaml = {
							schemas = {
								["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
							},
						},
					},
				})
			end

			if vim.fn.executable("vscode-json-language-server") == 1 then
				require("lspconfig").jsonls.setup({
					capabilities = vscode_server_capabilities,
				})
			end

			if vim.fn.executable("vscode-html-language-server") == 1 then
				require("lspconfig").html.setup({
					capabilities = vscode_server_capabilities,
				})
			end

			if vim.fn.executable("vscode-css-language-server") == 1 then
				require("lspconfig").cssls.setup({
					capabilities = vscode_server_capabilities,
				})
			end

			if vim.fn.executable("vscode-eslint-language-server") == 1 then
				require("lspconfig").eslint.setup({
					capabilities = vscode_server_capabilities,

					on_attach = function(_, bufnr)
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = bufnr,
							command = "EslintFixAll",
						})
					end,
				})
			end
		end,
	},
}
