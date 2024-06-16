return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    event = 'UIEnter',
    opts = {
      options = {
        icons_enabled = false,
        component_separators = {},
        section_separators = {},
      },
    },
  },
}
