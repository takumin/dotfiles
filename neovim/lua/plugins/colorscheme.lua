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
--     config = function()
--       require("onenord").setup({})
--       vim.cmd([[colorscheme onenord]])
--     end,
--   },
-- }

return {
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({})
      vim.cmd([[colorscheme tokyonight-night]])
    end,
  },
}
