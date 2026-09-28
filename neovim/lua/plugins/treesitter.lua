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

			-- "yaml.jinja"のようなjinjaテンプレートを表すドット区切りのfiletypeから、
			-- jinja以外の部分をテンプレートが生成する言語として取り出す
			local function jinja_host(filetype)
				local parts = vim.split(filetype, ".", { plain = true })
				if not vim.list_contains(parts, "jinja") then
					return nil
				end
				for _, ft in ipairs(parts) do
					if ft ~= "jinja" then
						return vim.treesitter.language.get_lang(ft)
					end
				end
			end

			-- jinjaのテンプレート外の本文をバッファのfiletypeが示す言語として解析させる
			vim.treesitter.query.add_directive("set-jinja-host!", function(_, _, source, _, metadata)
				if type(source) == "number" then
					metadata["injection.language"] = jinja_host(vim.bo[source].filetype)
				end
			end, { force = true })

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
					local host = jinja_host(args.match)
					local lang = host and "jinja" or vim.treesitter.language.get_lang(args.match)
					if not lang then
						return
					end
					-- 注入先の言語も揃っていないと本文がハイライトされない
					local langs = vim.tbl_filter(function(l)
						return vim.list_contains(ts.get_available(), l)
					end, { lang, host })
					local missing = vim.tbl_filter(function(l)
						return not vim.list_contains(ts.get_installed(), l)
					end, langs)
					if #missing == 0 then
						attach(args.buf, lang)
					elseif vim.list_contains(langs, lang) then
						ts.install(missing):await(function()
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
