# Neovim (LazyVim) キーバインド

ベースは [LazyVim 既定の keymaps](https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua)。  
このリポジトリでの **追加・上書き** は `config/nvim/lua/config/keymaps.lua`。

| 項目 | 値 |
|------|-----|
| Leader | `<Space>`（LazyVim 既定） |
| プラグイン一覧 | nvim 内で `:Lazy` |
| カスタム map のソース | `config/nvim/lua/config/keymaps.lua` |
| 実行時の全 map | `keys-nvim --live` または nvim 内で `:map` |

## カスタム map（抜粋）

### Insert

| キー | 動作 |
|------|------|
| `(<Enter>` / `{<Enter>` / `[<Enter>` 等 | 括弧・引用符を閉じてカーソルを内側へ |
| `Ctrl+A` / `Ctrl+E` | 行頭 / 行末 |
| `Ctrl+S` | `\`（バックスラッシュ） |

### Normal

| キー | 動作 |
|------|------|
| `+` / `-` | インクリメント / デクリメント |
| `Tab` / `Shift+Tab` | 次 / 前のタブ |
| `j` / `k` | 表示行単位で下 / 上（折り返し対応） |
| `Esc` | 検索ハイライト解除 |
| 矢印キー | 無効（hjkl 優先） |
| `Space+n` | 行番号トグル |
| `HS` | ヘルプを全画面で開く |
| `ss` / `sv` | 水平 / 垂直分割 |
| `sh` / `sj` / `sk` / `sl` | ウィンドウ移動（左/下/上/右） |
| `Ctrl+W` + 矢印 | ウィンドウリサイズ |
| `Ctrl+J` | 次の diagnostic |
| `zz` → `z` → `z` | スクロール位置を中央 → 上 → 下 と循環（1 秒以内） |

## LazyVim プラグイン由来のキー

`:WhichKey` 相当の一覧はプラグイン構成に依存する。迷ったら nvim 内で **`<Space>` を押して待つ**（which-key が有効な場合）か、`:help lazy` を参照。
