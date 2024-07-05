return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufRead', 'BufNewFile' },
    config = function()
      if vim.fn.executable('gopls') == 1 then
        require('lspconfig').gopls.setup({})
      end
      if vim.fn.executable('terraform-ls') == 1 then
        require('lspconfig').terraformls.setup({})
        vim.api.nvim_create_autocmd({"BufWritePre"}, {
          pattern = {"*.tf", "*.tfvars"},
          callback = function()
            vim.lsp.buf.format()
          end,
        })
      end
    end,
  },
}
