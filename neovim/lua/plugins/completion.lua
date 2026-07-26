return {
	{
		"garymjr/nvim-snippets",
		dependencies = { "rafamadriz/friendly-snippets" },
		event = { "BufRead", "BufNewFile" },
		config = function()
			require("snippets").setup({
				friendly_snippets = true,
			})
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"garymjr/nvim-snippets",
			"rafamadriz/friendly-snippets",
		},
		event = { "BufRead", "BufNewFile" },
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				completion = {
					completeopt = "menu,menuone,noinsert",
				},

				snippet = {
					expand = function(args)
						vim.snippet.expand(args.body)
					end,
				},

				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},

				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-e>"] = cmp.mapping.abort(),

					["<CR>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.confirm({
								select = true,
							})
						else
							fallback()
						end
					end),

					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
						else
							fallback()
						end
					end, { "i", "s" }),
				}),

				sources = cmp.config.sources({
					{ name = "snippets" },
					{ name = "nvim_lsp" },
				}, {
					{ name = "path" },
				}, {
					{ name = "buffer" },
				}),
			})

			cmp.setup.cmdline({ "/", "?" }, {
				completion = {
					completeopt = "menu,menuone,noinsert,noselect",
				},
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			cmp.setup.cmdline(":", {
				completion = {
					completeopt = "menu,menuone,noinsert,noselect",
				},
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
				matching = { disallow_symbol_nonprefix_matching = false },
			})

			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local vscode_server_capabilities = vim.deepcopy(capabilities)
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

				vim.lsp.config("lua_ls", {
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
				vim.lsp.enable("lua_ls")
			end

			if vim.fn.executable("bash-language-server") == 1 then
				vim.lsp.config("bashls", {
					capabilities = capabilities,
				})
				vim.lsp.enable("bashls")
			end

			if vim.fn.executable("clangd") == 1 then
				vim.lsp.config("clangd", {
					capabilities = capabilities,
				})
				vim.lsp.enable("clangd")
			end

			if vim.fn.executable("gopls") == 1 then
				vim.lsp.config("gopls", {
					capabilities = capabilities,

					settings = {
						gopls = {
							gofumpt = true,
						},
					},
				})
				vim.lsp.enable("gopls")
			end

			if vim.fn.executable("rust-analyzer") == 1 then
				vim.lsp.config("rust_analyzer", {
					capabilities = capabilities,

					settings = {
						["rust-analyzer"] = {
							check = {
								command = "clippy",
							},
						},
					},
				})
				vim.lsp.enable("rust_analyzer")
			end

			if vim.fn.executable("ruby-lsp") == 1 then
				vim.lsp.config("ruby_lsp", {
					capabilities = capabilities,

					init_options = {
						formatter = "standard",
						linters = { "standard" },
					},
				})
				vim.lsp.enable("ruby_lsp")
			end

			if vim.fn.executable("ruff") == 1 then
				vim.lsp.config("ruff", {
					capabilities = capabilities,

					init_options = {
						settings = {
							lineLength = 120,
						},
					},
				})
				vim.lsp.enable("ruff")
			end

			if vim.fn.executable("pylsp") == 1 then
				vim.lsp.config("pylsp", {
					capabilities = capabilities,

					settings = {
						pylsp = {
							plugins = {
								pycodestyle = {
									maxLineLength = 120,
								},
							},
						},
					},
				})
				vim.lsp.enable("pylsp")
			end

			if vim.fn.executable("csharp-ls") == 1 then
				vim.lsp.config("csharp_ls", {
					capabilities = capabilities,
				})
				vim.lsp.enable("csharp_ls")
			end

			if vim.fn.executable("terraform-ls") == 1 then
				vim.lsp.config("terraformls", {
					capabilities = capabilities,
				})
				vim.lsp.enable("terraformls")
			end

			-- TypeScript 7 replaced `tsserver.js` with a native (Go) binary that speaks LSP
			-- directly, so `typescript-language-server` cannot serve such a workspace and
			-- `tsgo` cannot serve a TypeScript 5 one. Decide from what the workspace ships.

			---@param dir string
			---@return "tsserver"|"native"|nil
			local function typescript_flavor(dir)
				if vim.fn.isdirectory(dir .. "/node_modules/typescript") == 0 then
					return nil
				end
				if vim.fn.filereadable(dir .. "/node_modules/typescript/lib/tsserver.js") == 1 then
					return "tsserver"
				end
				return "native"
			end

			---Wrap a server's default `root_dir` so it only attaches where `accept` holds.
			---@param name string
			---@param accept fun(dir: string): boolean
			---@return fun(bufnr: integer, on_dir: fun(dir: string))
			local function root_dir_filter(name, accept)
				local default = vim.lsp.config[name].root_dir
				return function(bufnr, on_dir)
					default(bufnr, function(dir)
						if accept(dir) then
							on_dir(dir)
						end
					end)
				end
			end

			if vim.fn.executable("typescript-language-server") == 1 then
				vim.lsp.config("ts_ls", {
					capabilities = capabilities,

					root_dir = root_dir_filter("ts_ls", function(dir)
						return typescript_flavor(dir) ~= "native"
					end),
				})
				vim.lsp.enable("ts_ls")
			end

			-- `tsgo` ships inside the workspace, so there is no global executable to probe.
			vim.lsp.config("tsgo", {
				capabilities = capabilities,

				-- `@typescript/native-preview` installs it as `tsgo`; TypeScript 7 as `tsc`.
				cmd = function(dispatchers, config)
					local root = (config or {}).root_dir or vim.fn.getcwd()
					local bin = root .. "/node_modules/.bin/tsgo"
					if vim.fn.executable(bin) == 0 then
						bin = root .. "/node_modules/.bin/tsc"
					end
					return vim.lsp.rpc.start({ bin, "--lsp", "--stdio" }, dispatchers)
				end,

				root_dir = root_dir_filter("tsgo", function(dir)
					return typescript_flavor(dir) == "native"
				end),
			})
			vim.lsp.enable("tsgo")

			if vim.fn.executable("biome") == 1 then
				vim.lsp.config("biome", {
					capabilities = capabilities,
				})
				vim.lsp.enable("biome")
			end

			if vim.fn.executable("yaml-language-server") == 1 then
				vim.lsp.config("yamlls", {
					capabilities = capabilities,

					settings = {
						yaml = {
							schemas = {
								["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
							},
						},
					},
				})
				vim.lsp.enable("yamlls")
			end

			if vim.fn.executable("vscode-json-language-server") == 1 then
				vim.lsp.config("jsonls", {
					capabilities = vscode_server_capabilities,
				})
				vim.lsp.enable("jsonls")
			end

			if vim.fn.executable("vscode-html-language-server") == 1 then
				vim.lsp.config("html", {
					capabilities = vscode_server_capabilities,
				})
				vim.lsp.enable("html")
			end

			if vim.fn.executable("vscode-css-language-server") == 1 then
				vim.lsp.config("cssls", {
					capabilities = vscode_server_capabilities,
				})
				vim.lsp.enable("cssls")
			end

			if vim.fn.executable("vscode-eslint-language-server") == 1 then
				vim.lsp.config("eslint", {
					capabilities = vscode_server_capabilities,

					on_attach = function(_, bufnr)
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = bufnr,
							command = "EslintFixAll",
						})
					end,
				})
				vim.lsp.enable("eslint")
			end
		end,
	},
}
