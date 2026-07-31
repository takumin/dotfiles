-- Formatter groups shared by several filetypes.
-- A stop_after_first group is a set of alternatives and only needs one of its
-- members; the members of any other group run in sequence and are all required.
-- oxlint fixes lint errors instead of formatting, so it cannot share a
-- stop_after_first chain and always has to run alongside oxfmt.
local oxc_script = { "oxlint", "oxfmt" }
local oxc_only = { "oxfmt" }
-- stop_after_first picks the first *available* formatter regardless of whether it
-- handles the filetype, so biome may only front the filetypes it actually supports.
local biome_chain = { "biome", "prettierd", "prettier", stop_after_first = true }
local prettier_chain = { "prettierd", "prettier", stop_after_first = true }
local yaml_chain = { "yamlfmt", "yamlfix", stop_after_first = true }

-- Single source of truth for every filetype. `run` is used as is; `chain` lists
-- the groups to try in preference order when a project config pins nothing, and
-- only chain entries can be pinned.
local filetypes = {
	{ fts = { "lua" }, run = { "stylua" } },
	{ fts = { "go" }, run = { "goimports", "gofumpt" } },
	{ fts = { "python" }, run = { "ruff_fix", "ruff_format", "ruff_organize_imports" } },
	{ fts = { "cs" }, run = { "csharpier" } },
	{ fts = { "toml" }, run = { "taplo", stop_after_first = true } },
	{ fts = { "hcl" }, run = { "hcl", stop_after_first = true } },
	{ fts = { "sh" }, run = { "shfmt" } },
	{ fts = { "javascript", "javascriptreact" }, chain = { oxc_script, biome_chain } },
	{ fts = { "typescript", "typescriptreact" }, chain = { oxc_script, biome_chain } },
	{ fts = { "html" }, chain = { oxc_only, biome_chain } },
	{ fts = { "json", "jsonc" }, chain = { oxc_only, biome_chain } },
	{ fts = { "css" }, chain = { oxc_only, biome_chain } },
	{ fts = { "yaml" }, chain = { yaml_chain, oxc_only } },
}

-- A project config file pins the toolchain regardless of what else is installed.
-- Entries without a chain are outside the toolchain and must stay untouched.
local function pinned_by_ft(pick)
	local by_ft = {}
	for _, entry in ipairs(filetypes) do
		if entry.chain then
			for _, ft in ipairs(entry.fts) do
				by_ft[ft] = pick(entry)
			end
		end
	end
	return by_ft
end

-- Listed in priority order: an earlier entry wins every filetype it pins, so a
-- narrow entry has to come before the broad ones it is meant to carve out of.
local projects = {
	{
		detects = {
			".yamlfmt",
			".yamlfmt.yml",
			".yamlfmt.yaml",
			"yamlfmt.yml",
			"yamlfmt.yaml",
		},
		-- yamlfmt only owns yaml, so it carves that one filetype out of whatever
		-- broader toolchain the project also declares.
		formatters_by_ft = { yaml = yaml_chain },
	},
	{
		detects = {
			".oxlintrc.json",
			".oxlintrc.jsonc",
			"oxlint.config.ts",
			"oxlint.config.mts",
			".oxfmtrc.json",
			".oxfmtrc.jsonc",
			"oxfmt.config.ts",
			"oxfmt.config.mts",
		},
		-- An oxc project pins the oxc group, which is not always the preferred one:
		-- yaml prefers yamlfmt by default and only falls back to oxfmt.
		formatters_by_ft = pinned_by_ft(function(entry)
			for _, group in ipairs(entry.chain) do
				if group == oxc_script or group == oxc_only then
					return group
				end
			end
		end),
	},
	{
		-- package.yaml is also a prettier config host, but it needs a yaml parser,
		-- so only the package.json key is honoured here.
		detect_keys = { ["package.json"] = "prettier" },
		detects = {
			".prettierrc",
			".prettierrc.json",
			".prettierrc.json5",
			".prettierrc.yml",
			".prettierrc.yaml",
			".prettierrc.toml",
			".prettierrc.js",
			".prettierrc.mjs",
			".prettierrc.cjs",
			".prettierrc.ts",
			".prettierrc.mts",
			".prettierrc.cts",
			"prettier.config.js",
			"prettier.config.mjs",
			"prettier.config.cjs",
			"prettier.config.ts",
			"prettier.config.mts",
			"prettier.config.cts",
		},
		formatters_by_ft = pinned_by_ft(function()
			return prettier_chain
		end),
	},
}

-- A config that lives under a key of a shared file only counts when the key is
-- actually there, so the file has to be decoded.
local function has_json_key(path, key)
	if vim.fn.filereadable(path) ~= 1 then
		return false
	end

	local ok, decoded = pcall(vim.json.decode, table.concat(vim.fn.readfile(path), "\n"))
	return ok and type(decoded) == "table" and decoded[key] ~= nil
end

local function detected(project, root)
	for _, marker in ipairs(project.detects) do
		if vim.fn.filereadable(root .. "/" .. marker) == 1 then
			return true
		end
	end

	for file, key in pairs(project.detect_keys or {}) do
		if has_json_key(root .. "/" .. file, key) then
			return true
		end
	end

	return false
end

-- Look for toolchain markers at the repository root of the buffer. A repository
-- may declare several toolchains at once, so every match contributes and the
-- earliest one to claim a filetype keeps it.
local function detect_project(bufnr)
	local root = vim.fs.root(bufnr, ".git")
	if not root then
		return nil
	end

	local pinned = nil
	for _, project in ipairs(projects) do
		if detected(project, root) then
			pinned = pinned or {}
			for ft, group in pairs(project.formatters_by_ft) do
				if pinned[ft] == nil then
					pinned[ft] = group
				end
			end
		end
	end

	return pinned
end

local function available(name, bufnr)
	return require("conform").get_formatter_info(name, bufnr).available
end

-- Alternatives need a single member installed, sequences need all of them.
local function usable(group, bufnr)
	if group.stop_after_first then
		for _, name in ipairs(group) do
			if available(name, bufnr) then
				return true
			end
		end
		return false
	end

	for _, name in ipairs(group) do
		if not available(name, bufnr) then
			return false
		end
	end
	return true
end

-- Resolve per buffer so a project-pinned toolchain wins over what is installed
-- globally, without mutating the shared formatters_by_ft table. Otherwise take
-- the first usable group, falling back to the last one unconditionally.
local function resolve(ft, chain)
	return function(bufnr)
		local project = detect_project(bufnr)
		if project and project[ft] then
			return project[ft]
		end

		for i, group in ipairs(chain) do
			if i == #chain or usable(group, bufnr) then
				return group
			end
		end
	end
end

---@type table<string, string[]|fun(bufnr: integer): string[]>
local formatters_by_ft = {}

for _, entry in ipairs(filetypes) do
	for _, ft in ipairs(entry.fts) do
		formatters_by_ft[ft] = entry.run or resolve(ft, entry.chain)
	end
end

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
			formatters_by_ft = formatters_by_ft,
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
		end,
	},
}
