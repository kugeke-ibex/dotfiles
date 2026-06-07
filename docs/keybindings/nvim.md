# Neovim (LazyVim) キーバインド

**日常の vi 操作**（削除・コピー・検索・インデントなど）: [vim-essential.md](vim-essential.md) — `keys-vim` / `kvi`

ベースは [LazyVim 既定の keymaps](https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua)。  
このリポジトリでの **追加・上書き** は `config/nvim/lua/config/keymaps.lua`。

| 項目                  | 値                                                                  |
| --------------------- | ------------------------------------------------------------------- |
| Leader                | `<Space>`（LazyVim 既定）                                           |
| プラグイン一覧        | nvim 内で `:Lazy`                                                   |
| カスタム map のソース | `config/nvim/lua/config/keymaps.lua`                                |
| 実行時の全 map        | `keys-nvim --live` または nvim 内で `:map`                          |
| Undo / Redo           | ノーマルで `u` / `Ctrl+r`（Markdown の render 切替は `<leader>um`） |

## カスタム map（抜粋）

### Insert

| キー                                    | 動作                                 |
| --------------------------------------- | ------------------------------------ |
| `(<Enter>` / `{<Enter>` / `[<Enter>` 等 | 括弧・引用符を閉じてカーソルを内側へ |
| `Ctrl+A` / `Ctrl+E`                     | 行頭 / 行末                          |
| `Ctrl+S`                                | `\`（バックスラッシュ）              |

### Normal

| キー                      | 動作                                              |
| ------------------------- | ------------------------------------------------- |
| `+` / `-`                 | インクリメント / デクリメント                     |
| `Tab` / `Shift+Tab`       | 次 / 前のタブ                                     |
| `j` / `k`                 | 表示行単位で下 / 上（折り返し対応）               |
| `Esc`                     | 検索ハイライト解除                                |
| 矢印キー                  | 無効（hjkl 優先）                                 |
| `Space+n`                 | 行番号トグル                                      |
| `HS`                      | ヘルプを全画面で開く                              |
| `ss` / `sv`               | 水平 / 垂直分割                                   |
| `sh` / `sj` / `sk` / `sl` | ウィンドウ移動（左/下/上/右）                     |
| `Ctrl+W` + 矢印           | ウィンドウリサイズ                                |
| `Ctrl+J`                  | 次の diagnostic                                   |
| `zz` → `z` → `z`          | スクロール位置を中央 → 上 → 下 と循環（1 秒以内） |

## プラグイン操作（LazyVim + 追加プラグイン）

LazyVim 既定キーが大半。迷ったら nvim 内で **`<Space>` を押して待つ**（which-key 一覧）か `:Lazy`。
追加・上書きの定義元は次のとおり。

| プラグイン    | 役割                                     | 定義元                                                                                                                    |
| ------------- | ---------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| neo-tree      | VSCode 風の常駐左サイドバーツリー        | `lazyvim.plugins.extras.editor.neo-tree`（lazy.lua で有効化）+ [explorer.lua](../../config/nvim/lua/plugins/explorer.lua) |
| oil.nvim      | ディレクトリをバッファ編集（netrw 置換） | [explorer.lua](../../config/nvim/lua/plugins/explorer.lua)                                                                |
| grug-far.nvim | ファイル横断の検索・置換                 | LazyVim 既定                                                                                                              |
| snacks picker | ファイル/文字列検索                      | LazyVim 既定                                                                                                              |

### ファイル・文字列検索（snacks picker）

| キー                              | 動作                                 |
| --------------------------------- | ------------------------------------ |
| `<leader><leader>` / `<leader>ff` | ファイル検索（ルート）               |
| `<leader>fF`                      | ファイル検索（カレントディレクトリ） |
| `<leader>fg`                      | git 管理ファイル検索                 |
| `<leader>fr` / `<leader>fR`       | 最近のファイル（ルート / cwd）       |
| `<leader>fb` / `<leader>,`        | バッファ一覧                         |
| `<leader>/` / `<leader>sg`        | プロジェクト全体 grep（ルート）      |
| `<leader>sw`                      | カーソル下の単語 / 選択範囲を grep   |
| `<leader>sb`                      | 現在バッファ内を検索                 |
| `<leader>sk`                      | キーマップ検索                       |
| `<leader>:`                       | コマンド履歴                         |
| `<leader>sR`                      | 直前の picker を再開（Resume）       |

### ファイルエクスプローラー（neo-tree / oil）

| キー                       | 動作                               |
| -------------------------- | ---------------------------------- |
| `<leader>e` / `<leader>fe` | neo-tree（左サイドバー）開閉       |
| `<leader>o`                | oil で親ディレクトリをバッファ編集 |
| `<leader>O`                | oil をフロート表示                 |

- **neo-tree 内**（ツリーにフォーカス時）: `a` 新規 / `d` 削除 / `r` リネーム / `c` コピー / `m` 移動 / `p` 貼付 / `H` 隠しファイル切替 / `<CR>` 開く / `?` ヘルプ一覧。
- **oil 内**: 通常の編集でファイル操作（`dd` 削除 / `p` 追加 / テキスト編集でリネーム）→ **`:w` で実ファイルに反映**。`-` 上の階層へ / `_` cwd へ / `g.` 隠しファイル切替 / `<C-p>` プレビュー / `g?` ヘルプ一覧。
  - 役割分担: **プロジェクト俯瞰 = neo-tree**、**その場のファイル操作 = oil**。

### ファイル横断の検索・置換（grug-far）

| キー         | 動作                                |
| ------------ | ----------------------------------- |
| `<leader>sr` | grug-far 起動（検索・置換バッファ） |

起動後のバッファに **Search / Replace / Files Filter** を書き込み、対象を絞って一括置換する（プロジェクト全体・glob 指定可）。実行や絞り込みのキーは grug-far バッファ上部のヘッダに表示される（`:h grug-far` 参照）。ビジュアル選択してから `<leader>sr` で選択語を初期値にできる。

### コードジャンプ（LSP）

ファイルを開いて LSP が attach したときに有効（LazyVim の `on_attach` 既定）。対象言語は [lsp.lua](../../config/nvim/lua/plugins/lsp.lua) の `servers`。

| キー         | 動作                         |
| ------------ | ---------------------------- |
| `gd`         | 定義へジャンプ               |
| `gr`         | 参照一覧                     |
| `gI`         | 実装へ                       |
| `gy`         | 型定義へ                     |
| `gD`         | 宣言へ                       |
| `K`          | ホバー（ドキュメント表示）   |
| `gK`         | シグネチャヘルプ             |
| `<leader>ca` | コードアクション             |
| `<leader>cr` | リネーム（プロジェクト全体） |
| `<leader>cf` | フォーマット                 |
| `<leader>cl` | LSP 情報                     |

### 診断（diagnostics / Trouble）

| キー         | 動作                        |
| ------------ | --------------------------- |
| `]d` / `[d`  | 次 / 前の diagnostic        |
| `<C-j>`      | 次の diagnostic（カスタム） |
| `<leader>xx` | Diagnostics 一覧（Trouble） |
| `<leader>xX` | バッファの diagnostics      |
| `<leader>cs` | シンボル一覧（Trouble）     |

### バッファ・ウィンドウ移動

| キー                                      | 動作                                                           |
| ----------------------------------------- | -------------------------------------------------------------- |
| `[b` / `]b`                               | 前 / 次のバッファ                                              |
| `[B` / `]B`                               | バッファの並べ替え                                             |
| `<leader>bb` / `<leader>fb` / `<leader>,` | バッファ切替（picker）                                         |
| `<leader>bd`                              | バッファを閉じる                                               |
| `Tab` / `Shift+Tab`                       | タブ切替（カスタム）                                           |
| `sh` / `sj` / `sk` / `sl`                 | ウィンドウ移動（カスタム）                                     |
| `<C-h>` / `<C-k>` / `<C-l>`               | ウィンドウ移動（LazyVim 既定。`<C-j>` は diagnostic に上書き） |
| `ss` / `sv`                               | 水平 / 垂直分割（カスタム）                                    |
