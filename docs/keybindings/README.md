# Keybindings

アプリケーションごとのキーバインド一覧。

| アプリ             | リンク                       | 設定ファイル                                                                     |
| ------------------ | ---------------------------- | -------------------------------------------------------------------------------- |
| WezTerm            | [wezterm.md](wezterm.md)     | [config/wezterm/wezterm.lua](../../config/wezterm/wezterm.lua)                   |
| Ghostty            | [ghostty.md](ghostty.md)     | [config/ghostty/config](../../config/ghostty/config)                             |
| cmux               | [cmux.md](cmux.md)           | [config/ghostty/config](../../config/ghostty/config) (libghostty 内蔵のため共有) |
| Karabiner-Elements | [karabiner.md](karabiner.md) | [karabiner/karabiner.json](../../karabiner/karabiner.json)                       |

## 共通設計

Karabiner で **Caps Lock ↔ 左 Control** を入れ替えている（[karabiner.md](karabiner.md) ルール 0）。vim 流の `Ctrl+h/j/k/l` は Caps Lock 位置から使える。

WezTerm / Ghostty / cmux で **同じ操作系** をなるべく揃えてあります (筋肉記憶を共有するため)。
cmux は libghostty を内蔵していて Ghostty の keybind がそのまま流用される。

| 操作            | WezTerm           | Ghostty / cmux    |
| --------------- | ----------------- | ----------------- |
| ペイン分割 (右) | `Cmd+D`           | `Cmd+D`           |
| ペイン分割 (下) | `Cmd+Shift+D`     | `Cmd+Shift+D`     |
| ペイン移動      | `Cmd+Opt+h/j/k/l` | `Cmd+Opt+h/j/k/l` |
| ペインリサイズ  | `Ctrl+Shift+←↓↑→` | `Ctrl+Shift+←↓↑→` |
| ペインズーム    | `Cmd+Z`           | `Cmd+Z`           |
| ペイン閉じ      | `Cmd+W`           | `Cmd+W`           |
| 設定リロード    | `Cmd+Shift+R`     | `Cmd+Shift+R`     |
| クリア          | `Cmd+K`           | `Cmd+K`           |
| コピーモード    | `Cmd+[`           | (右クリック等)    |

## Hotkey Window（iTerm2 相当）

通常ターミナルとは別のオーバーレイ端末を、グローバルショートカットで表示/非表示。

| キー         | アプリ   | 仕組み |
| ------------ | -------- | ------ |
| `Ctrl+Opt+W` | WezTerm  | Karabiner → hotkey ウィンドウ表示/非表示 |
| `Ctrl+Opt+G` | Ghostty  | Karabiner → ウィンドウ表示/非表示 |

詳細は [karabiner.md](karabiner.md)、[wezterm.md](wezterm.md)、[ghostty.md](ghostty.md)。

## 階層関係

```text
WezTerm / Ghostty / cmux (ターミナル本体 + multiplexer)
└─ zsh
   └─ vim / nvim
```

cmux は multiplexer (tabs / splits / 永続セッション) を本体に内蔵しているため tmux 層は不要。
SSH 先で multiplexer が必要な場合のみ、 リモート側で別途 tmux 等を使う運用とする。
