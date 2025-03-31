-- https://neovim.io/doc/user/lua.html#vim.loader.enable()
vim.loader.enable()
-- load lua files
require("core.opts")
require("core.cmds")
-- neovim only
if not vim.g.vscode then
	require("core.lazy")
end
