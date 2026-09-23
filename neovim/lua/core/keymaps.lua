-- Neovim標準のコメント機能(gc/gcc)をCtrl-Kに割り当てる
vim.keymap.set("n", "<C-K>", "gcc", { remap = true, desc = "Toggle comment line" })
vim.keymap.set("x", "<C-K>", "gc", { remap = true, desc = "Toggle comment" })
