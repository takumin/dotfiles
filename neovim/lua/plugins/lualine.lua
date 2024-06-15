return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    event = 'BufReadPost',
    opts = {
      options = {
        theme = 'iceberg_dark',
        icons_enabled = false,
        component_separators = {},
        section_separators = {},
      },
    },
  },
}
