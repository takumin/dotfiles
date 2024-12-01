-- https://neovim.io/doc/user/lua.html#vim.loader.enable()
vim.loader.enable()
-- load lua files
require("core.opts")
require("core.cmds")
require("core.lazy")
