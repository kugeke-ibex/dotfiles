-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

--
-- Window
--
-- 縦分割は右、横分割は下に開く
vim.opt.splitright = true
vim.opt.splitbelow = true

-- 折り返し移動 (h/l, ←/→ で行をまたぐ)
vim.opt.whichwrap = "b,s,h,l,<,>,[,],~"

--
-- Floating window 透過
--
vim.opt.winblend = 20
vim.opt.pumblend = 10

--
-- Spell
--
-- vim 標準スペルチェックから日本語 (CJK) を除外
vim.opt.spelllang:append("cjk")

-- スペル辞書: dotfiles 配下と、ローカル専用の 2 段
--   zg = dotfiles 管理 (config/nvim/spell/en.utf-8.add)
--   2zg = ローカル専用 (~/.local/share/nvim/spell/local.utf-8.add)
vim.opt.spellfile = {
  vim.fn.stdpath("config") .. "/spell/en.utf-8.add",
  vim.fn.stdpath("data") .. "/spell/local.utf-8.add",
}

--
-- Help
--
vim.opt.helplang = "ja"
-- :H で右側に縦分割でヘルプを開く
vim.cmd("cabbrev H belowright vertical help")

--
-- LSP UI
--
-- hover / signature help を rounded border で囲む
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "rounded",
})
