# iTerm2 キーバインド・設定

iTerm2 は **WezTerm / Ghostty の補助**として personal / work 共通で cask インストールし、設定は `config/iterm2/com.googlecode.iterm2.plist` を Nix で `~/Library/Preferences/` に symlink する。

**見た目**: Warm / Hotkey 用 — **Gruvbox Rainbow** 配色・Meslo 19pt・透明度は plist のまま。プロンプトは Starship `gruvbox-rainbow`（[starship-iterm.toml](../../config/starship-iterm.toml)）。3 ターミナル全体の表は [terminals-appearance.md](../terminals-appearance.md)。

## 管理ファイル

| 項目 | パス |
|------|------|
| 設定本体 | [config/iterm2/com.googlecode.iterm2.plist](../../config/iterm2/com.googlecode.iterm2.plist) |
| Gruvbox Rainbow 色 | plist 内蔵（Starship gruvbox-rainbow パレット準拠） |
| Home Manager | [modules/home/iterm2.nix](../../modules/home/iterm2.nix) |
| cask | `modules/darwin/homebrew-common.nix` の `iterm2` |

## Hotkey Window（グローバル）

plist 上で Hotkey Window が有効。プロファイルは **MesloLGS-NF 19**、デフォルト GUID `8D68D298-6D99-4642-8C3C-998962D33809`。

| 項目 | 値（plist） |
|------|-------------|
| `Hotkey` | 有効 |
| `HotkeyWindowFloatsAboveOtherWindows` | 有効 |
| プロファイル `HotKey Activated By Modifier` | 有効（修飾キーで表示/非表示） |

WezTerm / Ghostty 側の Hotkey 相当は Karabiner の `Ctrl+Opt+W` / `Ctrl+Opt+G`（[README](README.md) の Hotkey Window 節）。

### 新しい Mac でホットキーが効かないとき（権限）

plist（Hotkey 設定込み）は全ホストで symlink 共有しているため**設定内容は同一**だが、グローバルホットキーはキー入力をグローバル監視するため **macOS の権限が必要**で、これは TCC 保護のため **Nix/dotfiles では宣言的に付与できない**（マシンごとに手動許可）。新しい Mac で「ホットキーを押しても窓が出ない」場合はこれが原因:

1. **システム設定 → プライバシーとセキュリティ → アクセシビリティ** で **iTerm** を ON（必要なら**入力監視**も）。
2. plist が確実に読み込まれるよう、いったん iTerm2 を完全終了し、prefs キャッシュを破棄してから再起動:

   ```bash
   osascript -e 'quit app "iTerm"' 2>/dev/null
   killall cfprefsd 2>/dev/null   # symlink した plist を cfprefsd に読み直させる
   open -a iTerm
   ```

3. それでも出ない場合は plist 自体が読まれていない可能性（cfprefsd の symlink 問題）。その場合は iTerm2 の「Load preferences from a custom folder」方式への切替を検討する。

## 設定の取り込み・反映

**日常**: iTerm2 の Preferences で変更 → 保存すると **symlink 先の `config/iterm2/` に直接書き込まれる**（rebuild 不要）。iTerm2 を再起動すれば反映。

**別マシンから初回取り込み**（symlink 適用前に Library 側だけ編集している場合）:

```bash
plutil -convert xml1 -o config/iterm2/com.googlecode.iterm2.plist \
  ~/Library/Preferences/com.googlecode.iterm2.plist
git add config/iterm2/com.googlecode.iterm2.plist
```

**初回 symlink 適用**（`Library/Preferences` が実ファイルのままのとき）:

```bash
cd ~/Development/dotfiles
darwin-rebuild build --flake '.#personal'
sudo darwin-rebuild activate
```

## シェルで確認

```bash
keys-iterm   # または ki
```
