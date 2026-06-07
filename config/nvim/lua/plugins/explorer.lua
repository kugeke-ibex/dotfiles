-- ファイルエクスプローラー関連の追加・調整。
--
-- 構成:
--   - neo-tree  : VSCode 風の常駐左サイドバーツリー (LazyVim extra editor.neo-tree を
--                 config/lazy.lua で有効化済み)。<leader>e / <leader>fe で開閉。
--   - oil.nvim  : ディレクトリを「バッファとして編集」するエクスプローラー。netrw を置換し、
--                 ファイルのリネーム/移動/作成/削除を通常の編集操作 (i/dd/p/:w) で行える。
--   - grug-far  : ファイル横断の検索置換 (LazyVim 既定。<leader>sr)。ここでは設定しない。
--
-- 役割分担: プロジェクト俯瞰=neo-tree / その場のファイル操作=oil。

return {
  -- oil.nvim: ディレクトリをバッファ編集するエクスプローラー
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-mini/mini.icons" }, -- 既に導入済み (mini.icons)
    -- 公式 README: lazy loading は非推奨 (全状況で正しく動かすのが難しいため)
    lazy = false,
    keys = {
      -- 慣習の `-` は keymaps.lua でデクリメント (<C-x>) に割当済みのため <leader>o を使う
      { "<leader>o", "<cmd>Oil<cr>", desc = "Open parent dir (oil)" },
      { "<leader>O", "<cmd>Oil --float<cr>", desc = "Open parent dir (oil float)" },
    },
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      -- netrw を置換し、`nvim .` やディレクトリを開いたとき oil を使う
      default_file_explorer = true,
      -- 隠しファイルも表示 (g. でトグル)
      view_options = {
        show_hidden = true,
      },
      -- フロート (<leader>O) の見た目
      float = {
        border = "rounded",
        preview_split = "auto",
      },
    },
  },

  -- neo-tree: ディレクトリ展開 (netrw hijack) は oil に任せるため無効化し、衝突を避ける。
  -- これでサイドバー常駐は neo-tree、`nvim <dir>` 等のディレクトリ展開は oil、という分担になる。
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        hijack_netrw_behavior = "disabled",
      },
    },
  },
}
