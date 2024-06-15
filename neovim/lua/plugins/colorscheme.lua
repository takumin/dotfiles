-- return {
--   {
--     'neozenith/estilo-xoria256',
--     lazy = false, -- make sure we load this during startup if it is your main colorscheme
--     priority = 1000, -- make sure to load this before all the other start plugins
--     config = function()
--       -- load the colorscheme here
--       vim.cmd([[colorscheme xoria256]])
--     end,
--   },
-- }

-- return {
--   {
--     'sainnhe/everforest',
--     lazy = false, -- make sure we load this during startup if it is your main colorscheme
--     priority = 1000, -- make sure to load this before all the other start plugins
--     config = function()
--       -- load the colorscheme here
--       vim.cmd([[colorscheme everforest]])
--     end,
--   },
-- }

-- return {
--   {
--     'cocopon/iceberg.vim',
--     lazy = false, -- make sure we load this during startup if it is your main colorscheme
--     priority = 1000, -- make sure to load this before all the other start plugins
--     config = function()
--       -- load the colorscheme here
--       vim.cmd([[colorscheme iceberg]])
--     end,
--   },
-- }

-- return {
--   {
--     'rmehri01/onenord.nvim',
--     lazy = false, -- make sure we load this during startup if it is your main colorscheme
--     priority = 1000, -- make sure to load this before all the other start plugins
--     opts = {},
--   },
-- }

return {
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight-night]])
    end,
  },
}
