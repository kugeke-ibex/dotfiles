# Ghostty Keybindings

設定: [config/ghostty/config](../../config/ghostty/config)

## ウィンドウ

| 項目 | 値 |
| ---- | -- |
| 通常ウィンドウ起動 | `maximize = true`（画面いっぱい。ネイティブ FS は `Cmd+Enter`） |
| 背景透過 | `background-opacity = 0.55` |

## Hotkey Window (Quick Terminal)

iTerm2 の Hotkey Window 相当。通常ウィンドウとは別のオーバーレイ端末。

| キー | 動作 |
| ---- | ---- |
| `Ctrl+Opt+G` (`global:ctrl+alt+g`) | Quick Terminal を表示/非表示（他アプリ前面でも有効） |

| 設定 | 値 |
| ---- | -- |
| 位置 | `quick-terminal-position = top` |
| 高さ | `quick-terminal-size = 40%` |
| フォーカス外 | `quick-terminal-autohide = true`（自動で隠れる） |

**初回:** システム設定 → プライバシーとセキュリティ → **アクセシビリティ** で Ghostty を許可。Ghostty アプリ本体が起動している必要がある。設定変更後は `Cmd+Shift+R` または再起動。

## カスタム (このリポジトリで追加)

### ペイン (split)

| キー           | 動作                         |
| -------------- | ---------------------------- |
| `Cmd+D`        | 右に分割 (`new_split:right`) |
| `Cmd+Shift+D`  | 下に分割 (`new_split:down`)  |
| `Cmd+Opt+H`    | 左の split へフォーカス      |
| `Cmd+Opt+J`    | 下の split へフォーカス      |
| `Cmd+Opt+K`    | 上の split へフォーカス      |
| `Cmd+Opt+L`    | 右の split へフォーカス      |
| `Ctrl+Shift+←` | split を左に10リサイズ       |
| `Ctrl+Shift+↓` | split を下に10リサイズ       |
| `Ctrl+Shift+↑` | split を上に10リサイズ       |
| `Ctrl+Shift+→` | split を右に10リサイズ       |
| `Cmd+Z`        | split ズーム切替             |

### ウィンドウ・表示

| キー          | 動作               |
| ------------- | ------------------ |
| `Cmd+Enter`   | フルスクリーン切替 |
| `Cmd+K`       | 画面クリア         |
| `Cmd+Shift+R` | 設定リロード       |

## デフォルト (Ghostty 標準)

### タブ

| キー             | 動作               |
| ---------------- | ------------------ |
| `Cmd+T`          | 新規タブ           |
| `Cmd+W`          | タブ/split 閉じ    |
| `Cmd+Shift+[`    | 前のタブへ         |
| `Cmd+Shift+]`    | 次のタブへ         |
| `Cmd+1`〜`Cmd+9` | タブ番号でジャンプ |

### ウィンドウ

| キー    | 動作           |
| ------- | -------------- |
| `Cmd+N` | 新規ウィンドウ |
| `Cmd+M` | ミニマイズ     |
| `Cmd+H` | アプリ非表示   |
| `Cmd+Q` | アプリ終了     |

### 編集 / 検索

| キー    | 動作     |
| ------- | -------- |
| `Cmd+C` | コピー   |
| `Cmd+V` | ペースト |
| `Cmd+F` | 検索     |
| `Cmd+A` | 全選択   |

### フォント

| キー    | 動作                   |
| ------- | ---------------------- |
| `Cmd++` | フォントサイズ拡大     |
| `Cmd+-` | フォントサイズ縮小     |
| `Cmd+0` | フォントサイズリセット |

## マウス

`config` で `copy-on-select = clipboard` 設定済みなので、マウスでドラッグ選択するだけでクリップボードに入ります。
