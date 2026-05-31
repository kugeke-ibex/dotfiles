# Karabiner-Elements Keybindings

設定: [karabiner/karabiner.json](../../karabiner/karabiner.json)

> 設定は **初回 nix-darwin 適用時のみ** `~/.config/karabiner/karabiner.json` にコピーされます ([modules/home/karabiner.nix](../../modules/home/karabiner.nix))。Karabiner-Elements UI 経由で書き換えがあっても上書きされません。dotfiles 側を更新したい場合は手動でコピーしてください。

## ルール一覧

### 1. 左 Cmd / 右 Cmd で英かな切替

| キー                   | 動作            |
| ---------------------- | --------------- |
| 左 Cmd タップ (単押し) | `英数` キー     |
| 左 Cmd ホールド        | 通常の Cmd 修飾 |
| 右 Cmd タップ (単押し) | `かな` キー     |
| 右 Cmd ホールド        | 通常の Cmd 修飾 |

判定の hold しきい値: 100ms (`basic.to_if_held_down_threshold_milliseconds`)

### 2. Esc → Esc + 英数 (vim 用)

| キー  | 動作                         |
| ----- | ---------------------------- |
| `Esc` | `Esc` を送出 + 同時に `英数` |

vim でノーマルモードに戻ると同時に IME を英数に戻すための定番設定。

### 3. Ctrl+[ / Ctrl+] → Esc + 英数 (vim 用, ANSI/JIS 自動切替)

| キー     | キーボード種別 | 動作           |
| -------- | -------------- | -------------- |
| `Ctrl+[` | ANSI / ISO     | `Esc` + `英数` |
| `Ctrl+]` | JIS            | `Esc` + `英数` |

ANSI 配列 (US) では `[`、JIS 配列では `]` が `Esc` 相当のホームポジションに位置するための分岐。

### 4. 英数 / かな キーの Option 兼用化

| キー   | 単押し        | 他キーと同時押し     |
| ------ | ------------- | -------------------- |
| `英数` | `英数` を送出 | 左 Option として動作 |
| `かな` | `かな` を送出 | 右 Option として動作 |

判定タイムアウト: 200ms (`basic.to_if_alone_timeout_milliseconds`)

### 5. 左 Ctrl + h/j/k/l → 矢印キー

| キー          | 動作 |
| ------------- | ---- |
| `左 Ctrl + H` | `←`  |
| `左 Ctrl + J` | `↓`  |
| `左 Ctrl + K` | `↑`  |
| `左 Ctrl + L` | `→`  |

vim 慣れの人がブラウザや Slack 等の非 vim アプリでもカーソル移動できるようにするためのルール。

## トラブルシューティング

- **設定が反映されない**: Karabiner-Elements を再起動するか、メニューバーから "Restart Karabiner-Elements"
- **入力ソース許可**: 初回起動時にシステム設定の「プライバシーとセキュリティ → 入力監視」で Karabiner-Elements を許可
- **競合する OS 設定**: macOS の「キーボード → ライブ変換」「キーボードショートカット」と競合する場合は OS 側を OFF
- **IME が英数/かな を認識しない**: 入力ソースに「日本語 - ローマ字入力」などが入っているか確認。Google IME や ATOK でも `japanese_eisuu` / `japanese_kana` のキーコードを認識します。

## 設定の編集フロー

1. Karabiner-Elements の UI で動作確認
2. UI で変更した内容を `~/.config/karabiner/karabiner.json` から取り出して dotfiles の [karabiner/karabiner.json](../../karabiner/karabiner.json) にコピー
3. `git commit && git push` で dotfiles を更新
4. 別マシンでは `darwin-rebuild switch --flake .#<host>` 後に **既存の `~/.config/karabiner/karabiner.json` を退避** してから再度 switch で初回コピー
