return {
  {
    'lukas-reineke/lsp-format.nvim',
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'lukas-reineke/lsp-format.nvim' },
    event = { 'BufRead', 'BufNewFile' },
    config = function()
      if vim.fn.executable('clangd') == 1 then
        require('lspconfig').clangd.setup({
          on_attach = require("lsp-format").on_attach
        })
      end
      if vim.fn.executable('gopls') == 1 then
        require('lspconfig').gopls.setup({})
      end
      if vim.fn.executable('pylsp') == 1 then
        require('lspconfig').pylsp.setup({
          settings = {
            pylsp = {
              plugins = {
                pycodestyle = {
                  -- ignore = {'W391'},
                  maxLineLength = 100
                }
              }
            }
          }
        })
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
          on_attach = require("lsp-format").on_attach
        })
      end
      if vim.fn.executable('terraform-ls') == 1 then
        require('lspconfig').terraformls.setup({
          on_attach = require("lsp-format").on_attach
        })
      end
      if vim.fn.executable('tsserver') == 1 then
        require('lspconfig').ts_ls.setup({})
      end
      if vim.fn.executable('biome') == 1 then
        require('lspconfig').biome.setup({})
      end
      if vim.fn.executable('yaml-language-server') == 1 then
        require('lspconfig').yamlls.setup({
          settings = {
            yaml = {
              schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
              },
            },
          },
        })
      end
    end,
  },
}
