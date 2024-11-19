return {
  {
    'nvim-treesitter/nvim-treesitter',
    main = 'nvim-treesitter.configs',
    event = { 'BufRead', 'BufNewFile' },
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
    -- see also: https://github.com/RRethy/nvim-treesitter-endwise/pull/42
    'metiulekm/nvim-treesitter-endwise',
    main = 'nvim-treesitter.configs',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = 'InsertEnter',
    opts = {
      endwise = {
        enable = true,
      },
    },
  },
  {
    'windwp/nvim-autopairs',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = 'InsertEnter',
    opts = {
      check_ts = true,
    },
  },
}
