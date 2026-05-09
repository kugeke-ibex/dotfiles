-- LSP / completion の細かい上書き (mozumasu/dotfiles の lua/plugins/lsp/ 参考)
-- LazyVim default で nvim-lspconfig / blink.cmp / lazydev.nvim は既に有効。
-- ここでは diagnostic / 補完メニューの見た目とキーマップだけ調整する。

return {
  -- nvim-lspconfig: diagnostic の表示調整
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = {
          format = function(diagnostic)
            -- どの LSP からの診断かを末尾に括弧で添える
            return string.format("%s (%s)", diagnostic.message, diagnostic.source or "Unknown")
          end,
        },
        float = { border = "rounded" },
      },
    },
  },

  -- blink.cmp: 補完メニューの見た目とキーマップ
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        menu = {
          border = "rounded",
        },
        documentation = {
          window = {
            border = "rounded",
          },
        },
      },
      keymap = {
        -- Enter は改行に専念させる。補完確定は Tab / Ctrl-y で行う
        ["<CR>"] = {},
      },
      sources = {
        default = {
          -- cmdline 補完は Snacks picker と競合するため無効化
          cmdline = {},
        },
      },
    },
  },

  -- lazydev: dotfiles で書く Lua (config/nvim, config/wezterm) の補完を強化
  {
    "folke/lazydev.nvim",
    opts = {
      library = {
        -- WezTerm 設定 (config/wezterm/wezterm.lua) のために型定義を読み込む
        { path = "wezterm-types", mods = { "wezterm" } },
      },
    },
  },

  -- WezTerm 型定義ライブラリ (lazydev が参照するだけなので lazy = true)
  {
    "justinsgithub/wezterm-types",
    lazy = true,
  },
}
