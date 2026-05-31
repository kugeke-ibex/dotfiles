local opt = vim.opt

-- エンコーディング設定
opt.encoding = "utf-8"

-- ヘルプ言語を日本語に設定
opt.helplang = "ja"

-- 行番号の表示幅
opt.numberwidth = 6

-- ルーラーを表示
opt.ruler = true

-- インデント設定
opt.shiftwidth = 2
opt.tabstop = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- コマンドを表示
opt.showcmd = true

-- 対応する括弧を表示
opt.showmatch = true
opt.matchtime = 1

-- バックスペースの挙動設定
opt.backspace = "indent,eol,start"

-- カーソルを行末の一つ先まで移動可能にする
opt.virtualedit = "onemore"

-- スワップファイルを無効化
opt.swapfile = false

-- クリップボード共有
opt.clipboard = "unnamedplus"

-- コマンドライン補完を有効化
opt.wildmenu = true

-- コマンド履歴の保存数
opt.history = 5000

-- 行の折り返しを無効化
opt.wrap = false

-- 検索設定
opt.incsearch = true
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Global Status Line を有効にする
-- 画面をスプリットした時に Status LineはSplitされないようにする
opt.laststatus = 3

-- エラーやヒントがある時は行数の部分を上書きして表示する
opt.signcolumn = "number"

-- ログの保存先をtmpに変更
vim.env.XDG_STATE_HOME = "/tmp"

-- マウス操作を無効化
vim.api.nvim_set_option("mouse", "")

-- storybookで使用される可能性あり
-- 拡張子がmdxの時は、*.mdとして扱うことで、markdownとして認識させる
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.mdx", "*.mdc" },
  callback = function()
    vim.bo.filetype = "markdown"
  end,
})

vim.cmd([[
  " 使用しているテーマ関係なく必ず有効にしたい配色の設定
  augroup highlightIdegraphicSpace
    autocmd!
    autocmd Colorscheme * highlight IdeographicSpace term=underline ctermbg=DarkGreen guibg=DarkGreen
    autocmd VimEnter,WinEnter * match IdeographicSpace /　/
  augroup END

  autocmd ColorScheme * highlight StatusLine NONE
  autocmd ColorScheme * highlight SignColumn NONE

  " ターミナルでも True Color を使えるようにする。
  set termguicolors
  set pumblend=20
]])
