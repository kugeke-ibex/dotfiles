# ターミナル別の見た目（役割イメージ）

Hotkey 取り違え防止のため、**配色 + Starship プリセット** で判別する。透明度は各ターミナルの現状設定のまま。

| ターミナル  | 役割                 | 配色 / プリセット                              | フォント        | Starship                                                                                 |
| ----------- | -------------------- | ---------------------------------------------- | --------------- | ---------------------------------------------------------------------------------------- |
| **iTerm2**  | Warm / Big / Hotkey  | **Gruvbox Rainbow**（plist）                   | Meslo **19pt**  | `starship preset gruvbox-rainbow` → [starship-iterm.toml](../config/starship-iterm.toml) |
| **WezTerm** | Tokyo / Main / Glass | **Tokyo Night**                                | Meslo 14        | `starship preset tokyo-night` → [starship.toml](../config/starship.toml)                 |
| **Ghostty** | Jetpack / Native     | **Jetpack**（`config/ghostty/themes/Jetpack`） | Ricty 優先 14pt | `starship preset jetpack` → [starship-ghostty.toml](../config/starship-ghostty.toml)     |

## 設定ファイル

| 項目                   | パス                                                                                      |
| ---------------------- | ----------------------------------------------------------------------------------------- |
| iTerm2 plist           | [config/iterm2/com.googlecode.iterm2.plist](../config/iterm2/com.googlecode.iterm2.plist) |
| WezTerm                | [config/wezterm/wezterm.lua](../config/wezterm/wezterm.lua)                               |
| Ghostty                | [config/ghostty/config](../config/ghostty/config)                                         |
| Ghostty テーマ Jetpack | [config/ghostty/themes/Jetpack](../config/ghostty/themes/Jetpack)                         |
| Starship 切替          | [config/zsh/terminal-appearance.zsh](../config/zsh/terminal-appearance.zsh)               |

## Starship プリセットの再生成

```bash
starship preset gruvbox-rainbow -o config/starship-iterm.toml
starship preset tokyo-night    -o config/starship.toml
starship preset jetpack        -o config/starship-ghostty.toml
```

## Ghostty の注意

スペース入りの値はダブルクォート必須（例: `font-family = "Ricty Diminished"`）。`theme = Jetpack` は `config/ghostty/themes/Jetpack` を参照する。

## 反映方法

- **Ghostty / WezTerm**: symlink 先を編集済みなら `Cmd+Shift+R` または再起動。
- **iTerm2**: plist 変更後は iTerm2 再起動。
- **Starship**: `nix run '.#switch' -- personal`（別名 `nix-switch`）後、**新しい zsh タブ**を開く。

## 動作確認

```bash
echo "app=$(_dotfiles_terminal_app) STARSHIP=$STARSHIP_CONFIG"
```

| ターミナル | 期待する `app` | 期待する `STARSHIP_CONFIG`         |
| ---------- | -------------- | ---------------------------------- |
| iTerm2     | `iterm2`       | `.../config/starship-iterm.toml`   |
| WezTerm    | `wezterm`      | `.../config/starship.toml`         |
| Ghostty    | `ghostty`      | `.../config/starship-ghostty.toml` |

`app=n/a` や `STARSHIP=~/.config/starship.toml` のときは、次を実行してから **新しいタブ**で再確認する。

```bash
nix run '.#switch' -- personal   # または nix-switch
source "${DOTFILES_ROOT:-$HOME/Development/dotfiles}/config/zsh/common.zsh"
_dotfiles_setup_starship_config
```
