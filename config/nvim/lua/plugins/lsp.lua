-- LSP / completion の細かい上書き（外部の LazyVim / lspconfig 例を参考に調整）
-- LazyVim default で nvim-lspconfig / blink.cmp / lazydev.nvim は既に有効。
-- solargraph は ruby_lsp と二重になりやすいため入れない。

local servers = {
  astro = {},
  biome = {},
  cssls = {},
  denols = {},
  dockerls = {},
  emmet_language_server = {},
  eslint = {},
  gopls = {},
  graphql = {},
  html = {},
  jsonls = {},
  nil_ls = {},
  prismals = {},
  ruby_lsp = {},
  rust_analyzer = {},
  sqls = {},
  svelte = {},
  tailwindcss = {},
  terraformls = {},
  ts_ls = {},
  yamlls = {},
}

return {
  -- nvim-lspconfig: diagnostic + Mason 経由で入れたい language server
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local diag = opts.diagnostics or {}
      diag.virtual_text = vim.tbl_deep_extend("force", diag.virtual_text or {}, {
        format = function(diagnostic)
          return string.format("%s (%s)", diagnostic.message, diagnostic.source or "Unknown")
        end,
      })
      diag.float = vim.tbl_deep_extend("force", diag.float or {}, { border = "rounded" })
      opts.diagnostics = diag

      opts.servers = opts.servers or {}
      for name, cfg in pairs(servers) do
        if opts.servers[name] == nil then
          opts.servers[name] = cfg
        end
      end
      return opts
    end,
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
