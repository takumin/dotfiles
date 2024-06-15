-- 改行時にコメントが自動的に挿入されないようにする
--   r             : 挿入モードで<return>を打った後に、
--                 : 現在のコメント指示を自動的に挿入する。
--   o             : ノーマルモードで'o'、'O'を打った後に、
--                 : 現在のコメント指示を自動的に挿入する。
vim.api.nvim_create_autocmd({'BufEnter'}, {
  pattern = '*',
  callback = function()
    vim.opt.formatoptions:remove('r')
    vim.opt.formatoptions:remove('o')
  end
})

-- ファイルタイプ毎の設定
vim.api.nvim_create_autocmd({'FileType'}, {
  pattern = 'make',
  callback = function()
    vim.opt.tabstop = 8
    vim.opt.softtabstop = 8
    vim.opt.shiftwidth = 8
    vim.opt.expandtab = false
  end
})
vim.api.nvim_create_autocmd({'FileType'}, {
  pattern = 'cs',
  callback = function()
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.shiftwidth = 4
  end
})
vim.api.nvim_create_autocmd({'FileType'}, {
  pattern = 'go',
  callback = function()
    vim.opt.expandtab = false
  end
})
vim.api.nvim_create_autocmd({'FileType'}, {
  pattern = {'sh', 'bash', 'zsh'},
  callback = function()
    vim.opt.expandtab = false
  end
})
