-- テキスト編集系の追加プラグイン。
-- 競合のため除外したもの: telescope (snacks picker と重複) / nvim-autopairs (mini.pairs と競合)
-- / vim-commentary (native gc + ts-comments + Comment.nvim と重複)。

return {
  -- kana 製 operator フレームワーク (operator-replace / convert-case の土台)
  {
    "kana/vim-operator-user",
    lazy = false,
  },

  -- operator-replace: レジスタの内容で「テキストオブジェクト分を置換」する operator。
  -- 例: "0_iw で yank した語をカーソル下の単語に上書き。
  -- native `_` motion (Nth 行下の非空白先頭) を上書きする (ほぼ使わないため許容)。
  {
    "kana/vim-operator-replace",
    dependencies = { "kana/vim-operator-user" },
    keys = {
      { "_", "<Plug>(operator-replace)", mode = { "n", "x" }, desc = "Operator replace (register)" },
    },
  },

  -- operator-convert-case: テキストオブジェクト分を snake_case / camelCase 等へ変換。
  -- <Plug> 名は clone 後に確認して下のキーに割り当てる。
  {
    "mopp/vim-operator-convert-case",
    dependencies = { "kana/vim-operator-user" },
    keys = {
      { "<leader>cu", "<Plug>(operator-convert-case-loop)", mode = { "n", "x" }, desc = "Convert case (loop)" },
    },
  },

  -- nvim-surround: ys/ds/cs で囲み追加・削除・変更（normal の既定はそのまま）。
  -- v4 では setup の keymaps 指定が廃止。ビジュアルの既定 `S` は flash(Treesitter) と
  -- 衝突するため、visual 既定だけ無効化し <Plug> を gs/gS に割り当てる。
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    init = function()
      -- プラグイン読込前に visual 既定 (S) を無効化
      vim.g.nvim_surround_no_visual_mappings = true
    end,
    keys = {
      { "gs", "<Plug>(nvim-surround-visual)", mode = "x", desc = "Surround selection" },
      { "gS", "<Plug>(nvim-surround-visual-line)", mode = "x", desc = "Surround selection (line)" },
    },
    opts = {},
  },

  -- treesj: treesitter ベースで配列/引数/テーブル等を 1 行 <-> 複数行に split/join。
  -- gJ は native (空白なし join) のため避け、<leader>m (toggle) と gS は使わず TSJ コマンドに寄せる。
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      { "<leader>m", "<cmd>TSJToggle<cr>", desc = "Split/Join toggle (treesj)" },
      { "<leader>cJ", "<cmd>TSJJoin<cr>", desc = "Join to one line (treesj)" },
      { "<leader>cS", "<cmd>TSJSplit<cr>", desc = "Split to multi-line (treesj)" },
    },
    opts = { use_default_keymaps = false },
  },

  -- nvim-hlslens: n/N/*/# の検索でマッチ位置・件数をレンズ表示。
  {
    "kevinhwang91/nvim-hlslens",
    keys = {
      {
        "n",
        [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
        desc = "Next search (hlslens)",
      },
      {
        "N",
        [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
        desc = "Prev search (hlslens)",
      },
      { "*", [[*<Cmd>lua require('hlslens').start()<CR>]], desc = "Search word fwd (hlslens)" },
      { "#", [[#<Cmd>lua require('hlslens').start()<CR>]], desc = "Search word back (hlslens)" },
      { "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], desc = "Search word fwd partial (hlslens)" },
      { "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], desc = "Search word back partial (hlslens)" },
    },
    opts = {},
  },

  -- comment-box.nvim: コメントを枠線/見出しで装飾。デフォルトキーは無いので明示割当。
  {
    "LudoPinelli/comment-box.nvim",
    keys = {
      { "<leader>cb", "<cmd>CBccbox<cr>", mode = { "n", "v" }, desc = "Comment box (centered)" },
      { "<leader>cB", "<cmd>CBline<cr>", mode = { "n", "v" }, desc = "Comment line" },
    },
    opts = {},
  },

  -- modes.nvim: モード (insert/visual/...) に応じて行をハイライト。見た目のみ。
  {
    "mvllow/modes.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
