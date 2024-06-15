return {
  {
    'nvim-treesitter/nvim-treesitter',
    main = 'nvim-treesitter.configs',
    event = 'UIEnter',
    build = ':TSUpdate',
    opts = {
      auto_install = true,
      ensure_installed = {
        -- gitcommitでdiff表示している場合、自動でインストールされないため
        'diff',
        -- markdownでWiki Link表示している場合、自動でインストールされないため
        'markdown_inline',
      },
      highlight = {
        enable = true,
      },
    },
  },
  {
    'RRethy/nvim-treesitter-endwise',
    main = 'nvim-treesitter.configs',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = 'InsertEnter',
    opts = {
      endwise = {
        enable = true,
      },
    },
  },
}
