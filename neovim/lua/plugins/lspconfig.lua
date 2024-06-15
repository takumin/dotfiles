return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufRead', 'BufNewFile' },
    config = function()
      if vim.fn.executable('gopls') == 1 then
        require('lspconfig').gopls.setup({})
      end
    end,
  },
}
