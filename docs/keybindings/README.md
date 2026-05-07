# Keybindings

アプリケーションごとのキーバインド一覧。

| アプリ | リンク | 設定ファイル |
| --- | --- | --- |
| WezTerm | [wezterm.md](wezterm.md) | [config/wezterm/wezterm.lua](../../config/wezterm/wezterm.lua) |
| Ghostty | [ghostty.md](ghostty.md) | [config/ghostty/config](../../config/ghostty/config) |
| tmux | [tmux.md](tmux.md) | [modules/home/tmux.nix](../../modules/home/tmux.nix) |
| Karabiner-Elements | [karabiner.md](karabiner.md) | [karabiner/karabiner.json](../../karabiner/karabiner.json) |

## 共通設計

WezTerm / Ghostty / tmux で **同じ操作系** をなるべく揃えてあります (筋肉記憶を共有するため)。

| 操作 | WezTerm | Ghostty | tmux |
| --- | --- | --- | --- |
| ペイン分割 (右) | `Cmd+D` | `Cmd+D` | `prefix + \|` |
| ペイン分割 (下) | `Cmd+Shift+D` | `Cmd+Shift+D` | `prefix + -` |
| ペイン移動 | `Cmd+Opt+h/j/k/l` | `Cmd+Opt+h/j/k/l` | `prefix + h/j/k/l` |
| ペインリサイズ | `Ctrl+Shift+←↓↑→` | `Ctrl+Shift+←↓↑→` | `prefix + H/J/K/L` (連打可) |
| ペインズーム | `Cmd+Z` | `Cmd+Z` | `prefix + z` |
| ペイン閉じ | `Cmd+W` | `Cmd+W` | `prefix + x` |
| 設定リロード | `Cmd+Shift+R` | `Cmd+Shift+R` | `prefix + r` |
| クリア | `Cmd+K` | `Cmd+K` | `prefix + Ctrl+L` |
| コピーモード | `Cmd+[` | (右クリック等) | `prefix + [` |

## 階層関係

```text
WezTerm / Ghostty (ターミナル本体のペイン)
└─ zsh
   └─ tmux (tmux のペイン)
      └─ vim / nvim
```

ターミナルのペイン分割と tmux のペイン分割は別物です。WezTerm/Ghostty のペインは GUI ウィンドウ単位、tmux のペインは tmux セッション内 (SSH 越しでも維持)。
