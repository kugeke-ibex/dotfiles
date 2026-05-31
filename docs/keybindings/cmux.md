# cmux Keybindings

## 概要

[cmux](https://cmux.com/) は AI agent 向け macOS native ターミナル (Swift/AppKit + libghostty)。
libghostty を内蔵しており、[`~/.config/ghostty/config`](../../config/ghostty/config) を Ghostty
と共有する。multiplexer 機能 (tabs / splits / 永続セッション) を本体に内蔵しているため tmux は不要。

## 設定ファイル

| 対象 | 場所 | 共有 |
| --- | --- | --- |
| フォント / カラー / ペイン keybind | `~/.config/ghostty/config` | Ghostty と共有 |
| cmux 固有 (vertical tabs, embedded browser, socket API 等) | アプリ内 Settings (`Cmd+,`) | cmux 単独 |

## キーバインド (ghostty.config 流用分)

ghostty.config の keybind がそのまま動く。主な操作:

| キー | 動作 |
| --- | --- |
| `Cmd+D` | 右に split (`new_split:right`) |
| `Cmd+Shift+D` | 下に split (`new_split:down`) |
| `Cmd+Opt+h/j/k/l` | split 間フォーカス移動 |
| `Ctrl+Shift+←/↓/↑/→` | split リサイズ |
| `Cmd+Z` | split zoom 切替 |
| `Cmd+Enter` | フルスクリーン |
| `Cmd+K` | クリア |
| `Cmd+Shift+R` | 設定リロード |
| `Cmd+T` | 新規タブ |
| `Cmd+W` | タブ/split 閉じ |
| `Cmd+Shift+[` / `Cmd+Shift+]` | タブ切替 |
| `Cmd+1..9` | タブ番号でジャンプ |
| `Cmd++/-/0` | フォントサイズ |

詳細は [ghostty.md](ghostty.md) を参照 (cmux と Ghostty は同じ keybind が動く)。

## tmux からの移行ポイント

| tmux | cmux |
| --- | --- |
| `prefix + ...` で操作 | `Cmd` / `Cmd+Shift` で直接 (前置キー不要) |
| `tmux attach` でセッション復帰 | cmux 本体がアプリ単位で永続化 (アプリ再起動で復元) |
| `~/.config/tmux/tmux.conf` | `~/.config/ghostty/config` (split 系) + Settings (cmux 独自) |
| `prefix + [` でコピーモード | マウスでドラッグ選択 (Ghostty の挙動を継承) |
| `prefix + d` でデタッチ | cmux ではタブ/window を閉じる |

## SSH 先での扱い

cmux はクライアント側 GUI なので、 SSH 先の永続セッションには使えない。SSH 先で
multiplexer が必要なら手元で `brew install tmux` する (このリポジトリでは管理外、
必要時に手動で導入する想定)。

## インストール

[modules/darwin/homebrew-common.nix](../../modules/darwin/homebrew-common.nix) の `casks`
に `"cmux"` を追加済み。実機適用後に Applications/cmux.app が入る。

公式 DMG が必要なら <https://cmux.com/> から直接ダウンロード可。
