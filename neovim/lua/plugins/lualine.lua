return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    event = 'UIEnter',
    opts = {
      options = {
        -- theme = 'iceberg_dark',
        -- theme = 'onenord',
        theme = 'tokyonight',
        icons_enabled = false,
        component_separators = {},
        section_separators = {},
      },
    },
  },
}
