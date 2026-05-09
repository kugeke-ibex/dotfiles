vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 標準・共通オプション (LazyVim / plugins より先に適用)
require("config.base")
require("config.tabline")
require("config.terminal")

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
