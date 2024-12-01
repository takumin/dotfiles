-- return {
-- 	{
-- 		"sainnhe/everforest",
-- 		lazy = false,
-- 		priority = 1000,
-- 		config = function()
-- 			vim.cmd([[colorscheme everforest]])
-- 		end,
-- 	},
-- }

-- return {
-- 	{
-- 		"rmehri01/onenord.nvim",
-- 		lazy = false,
-- 		priority = 1000,
-- 		config = function()
-- 			require("onenord").setup({})
-- 			vim.cmd([[colorscheme onenord]])
-- 		end,
-- 	},
-- }

-- return {
-- 	{
-- 		"navarasu/onedark.nvim",
-- 		lazy = false,
-- 		priority = 1000,
-- 		config = function()
-- 			require("onedark").setup({})
-- 			vim.cmd([[colorscheme onedark]])
-- 		end,
-- 	},
-- }

-- return {
-- 	{
-- 		"EdenEast/nightfox.nvim",
-- 		lazy = false,
-- 		priority = 1000,
-- 		config = function()
-- 			require("nightfox").setup({})
-- 			vim.cmd([[colorscheme nightfox]])
-- 		end,
-- 	},
-- }

return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({})
			vim.cmd([[colorscheme tokyonight-night]])
		end,
	},
}
