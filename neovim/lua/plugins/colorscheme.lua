-- return {
--   {
--     'sainnhe/everforest',
--     lazy = false,
--     priority = 1000,
--     config = function()
--       vim.cmd([[colorscheme everforest]])
--     end,
--   },
-- }

-- return {
--   {
--     'rmehri01/onenord.nvim',
--     lazy = false,
--     priority = 1000,
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
