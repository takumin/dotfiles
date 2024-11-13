return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufRead', 'BufNewFile' },
    config = function()
      if vim.fn.executable('gopls') == 1 then
        require('lspconfig').gopls.setup({})
      end
      if vim.fn.executable('rust-analyzer') == 1 then
        require('lspconfig').rust_analyzer.setup({
          settings = {
            ["rust-analyzer"] = {
              check = {
                command = "clippy",
              },
            },
          },
          on_attach = function(client, bufnr)
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end,
        })
        vim.api.nvim_create_autocmd({"BufWritePre"}, {
          pattern = {"*.rs"},
          callback = function()
            vim.lsp.buf.format()
          end,
        })
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
      if vim.fn.executable('tsserver') == 1 then
        require('lspconfig').ts_ls.setup({})
      end
      if vim.fn.executable('biome') == 1 then
        require('lspconfig').biome.setup({})
      end
    end,
  },
}
