# Keybindings

アプリケーションごとのキーバインド一覧。

| アプリ             | リンク                               | 設定ファイル                                                                                                                                                 | シェルで開く                             |
| ------------------ | ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------- |
| （一覧）           | 本 README                            | —                                                                                                                                                            | `keys`                                   |
| WezTerm            | [wezterm.md](wezterm.md)             | [config/wezterm/wezterm.lua](../../config/wezterm/wezterm.lua)                                                                                               | `keys-wezterm` / `kw`                    |
| Ghostty            | [ghostty.md](ghostty.md)             | [config/ghostty/config](../../config/ghostty/config)                                                                                                         | `keys-ghostty` / `kg`                    |
| herdr              | [herdr.md](herdr.md)                 | [modules/darwin/homebrew-common.nix](../../modules/darwin/homebrew-common.nix) (`brews`、端末内で起動)                                                       | `keys-herdr` / `kh`                      |
| iTerm2             | [iterm2.md](iterm2.md)               | [config/iterm2/com.googlecode.iterm2.plist](../../config/iterm2/com.googlecode.iterm2.plist)                                                                 | `keys-iterm` / `ki`                      |
| Karabiner-Elements | [karabiner.md](karabiner.md)         | [karabiner/karabiner.json](../../karabiner/karabiner.json)                                                                                                   | `keys-karabiner` / `kk`                  |
| Vim 日常操作       | [vim-essential.md](vim-essential.md) | —（[Zenn 参考](https://zenn.dev/yuuzan_kaibara/articles/e8d3630b677e68)）                                                                                    | `keys-vim` / `kvi`                       |
| Neovim (LazyVim)   | [nvim.md](nvim.md)                   | [config/nvim/lua/config/keymaps.lua](../../config/nvim/lua/config/keymaps.lua)                                                                               | `keys-nvim` / `kn`（`--live` で `:map`） |
| Cursor             | —                                    | [config/cursor/keybindings.json](../../config/cursor/keybindings.json)                                                                                       | `keys-cursor` / `kcur`                   |
| VS Code            | —                                    | [config/vscode/keybindings.json](../../config/vscode/keybindings.json)                                                                                       | `keys-vscode` / `kvs`                    |
| Raycast            | [raycast.md](raycast.md)             | Raycast SQLite DB（[config/raycast/](../../config/raycast/) の `.rayconfig` で一括同期）                                                                     | `keys-raycast` / `kr`                    |
| AI エージェント    | [ai-agents.md](ai-agents.md)         | [config/ghostty/config](../../config/ghostty/config) + [config/wezterm/modules/agents.lua](../../config/wezterm/modules/agents.lua) (`Cmd+Shift+A` 起動キー) | `keys-agents` / `ka`                     |

## 共通設計

Karabiner で **Caps Lock ↔ 左 Control** を入れ替えている（[karabiner.md](karabiner.md) ルール 0）。vim 流の `Ctrl+h/j/k/l` は Caps Lock 位置から使える。

WezTerm / Ghostty で **同じ操作系** をなるべく揃えてあります (筋肉記憶を共有するため)。
AI エージェントの並列管理は端末内マルチプレクサ [herdr](herdr.md) に委ねる。

| 操作            | WezTerm           | Ghostty           |
| --------------- | ----------------- | ----------------- |
| ペイン分割 (右) | `Cmd+D`           | `Cmd+D`           |
| ペイン分割 (下) | `Cmd+Shift+D`     | `Cmd+Shift+D`     |
| ペイン移動      | `Cmd+[` / `Cmd+]` | `Cmd+[` / `Cmd+]` |
| ペインリサイズ  | `Ctrl+Shift+←↓↑→` | `Ctrl+Shift+←↓↑→` |
| ペインズーム    | `Cmd+Z`           | `Cmd+Z`           |
| ペイン閉じ      | `Cmd+W`           | `Cmd+W`           |
| 設定リロード    | `Cmd+Shift+R`     | `Cmd+Shift+R`     |
| クリア          | `Cmd+K`           | `Cmd+K`           |
| コピーモード    | `Cmd+Opt+[`       | (右クリック等)    |

## Hotkey Window（iTerm2 相当）

通常ターミナルとは別のオーバーレイ端末を、グローバルショートカットで表示/非表示。

| キー         | アプリ  | 仕組み                                   |
| ------------ | ------- | ---------------------------------------- |
| `Ctrl+Opt+W` | WezTerm | Karabiner → hotkey ウィンドウ表示/非表示 |
| `Ctrl+Opt+G` | Ghostty | Karabiner → ウィンドウ表示/非表示        |

詳細は [karabiner.md](karabiner.md)、[wezterm.md](wezterm.md)、[ghostty.md](ghostty.md)。

## 階層関係

```text
WezTerm / Ghostty (ターミナルエミュレータ)
└─ herdr (端末内 AI エージェントマルチプレクサ。tabs / splits / 永続セッション)
   └─ zsh
      └─ vim / nvim
```

herdr が multiplexer 層 (tabs / splits / 永続セッション / agent 状態表示) を担うため
tmux は不要。SSH 先でも herdr をリモート側に入れて再アタッチできる（cmux と違い SSH 対応）。
軽量なフォールバックが欲しいときのみリモートで `tmux` を手動導入する（当リポジトリ管理外）。
