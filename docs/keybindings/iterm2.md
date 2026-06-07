# iTerm2 キーバインド・設定

iTerm2 は **WezTerm / Ghostty の補助**として personal / work 共通で cask インストールする。設定は `config/iterm2/com.googlecode.iterm2.plist` を iTerm2 の **「Load preferences from a custom folder」** 機能で直接読み書きさせる（`~/Library/Preferences/` には「このフォルダから読め」というポインタだけを置く）。

> **方式変更（旧 symlink からの移行）**: 以前は plist を `~/Library/Preferences/` に symlink していたが、iTerm2 は cfprefsd 経由で設定を読むため、新しい Mac では symlink が無視されフォント・ウィンドウ位置・Hotkey が反映されない（既定 Monaco でグリフが豆腐になる）問題があった。現在は [modules/home/iterm2.nix](../../modules/home/iterm2.nix) の activation が `PrefsCustomFolder` / `LoadPrefsFromCustomFolder` を設定する。**反映には iTerm2 を終了した状態で switch する**こと（起動中はスキップされる）。

**見た目**: Warm / Hotkey 用 — **Gruvbox Rainbow** 配色・Meslo 19pt・透明度は plist のまま。プロンプトは Starship `gruvbox-rainbow`（[starship-iterm.toml](../../config/starship-iterm.toml)）。3 ターミナル全体の表は [terminals-appearance.md](../terminals-appearance.md)。

## 管理ファイル

| 項目               | パス                                                                                         |
| ------------------ | -------------------------------------------------------------------------------------------- |
| 設定本体           | [config/iterm2/com.googlecode.iterm2.plist](../../config/iterm2/com.googlecode.iterm2.plist) |
| Gruvbox Rainbow 色 | plist 内蔵（Starship gruvbox-rainbow パレット準拠）                                          |
| Home Manager       | [modules/home/iterm2.nix](../../modules/home/iterm2.nix)                                     |
| cask               | `modules/darwin/homebrew-common.nix` の `iterm2`                                             |

## Hotkey Window（グローバル）

plist 上で Hotkey Window が有効。プロファイルは **MesloLGS-NF 19**、デフォルト GUID `8D68D298-6D99-4642-8C3C-998962D33809`。

| 項目                                        | 値（plist）                          |
| ------------------------------------------- | ------------------------------------ |
| `Hotkey`                                    | 有効                                 |
| `HotkeyWindowFloatsAboveOtherWindows`       | 有効                                 |
| プロファイル `HotKey Activated By Modifier` | 有効（修飾キーで表示/非表示）        |
| `hotKeyDoubleTapMaxDelay`                   | 0.5 秒（連打と認める上限間隔）       |
| `hotKeyDoubleTapMinDelay`                   | 0.0 秒（速すぎる連打を弾かない下限） |

Control の 2 連打で Hotkey Window を出す設定。**この Mac では Karabiner が Caps Lock ↔ 左 Control をスワップ**しているため（[karabiner/karabiner.json](../../karabiner/karabiner.json) の `simple_modifications`）、実際に 2 連打するのは Control として振る舞う **物理 Caps Lock キー**。Control 系イベントは Karabiner の仮想キーボードを経由するぶん 2 連打の 2 つの `flagsChanged` 間にレイテンシ/ジッタが入り、iTerm2 既定（≈0.3 秒）の判定窓を**たまに超えて**取りこぼす。これが「たまに効かない」根本原因で、対処として隠し詳細設定で判定窓を **0.5 秒**（上限）／**0.0 秒**（下限）に広げ plist へ焼き込んでいる。

打鍵タイミング以外の断続要因として、他アプリのセキュア入力（ロック画面 / 1Password / 別端末の sudo パスワード欄など）が有効な間はグローバル監視が一時的に握りつぶされる（欄からフォーカスを外すと復帰）。0.5 秒でも頻発する場合は、`hotKeyDoubleTapMaxDelay` をさらに広げるか、Karabiner 側で Control を経由させない構成（例: Hotkey を修飾キー 2 連打でなく明示キー組み合わせにして Karabiner から発火）に切り替える。

WezTerm / Ghostty 側の Hotkey 相当は Karabiner の `Ctrl+Opt+W` / `Ctrl+Opt+G`（[README](README.md) の Hotkey Window 節）。

### 新しい Mac でホットキーが効かないとき（権限）

plist（Hotkey 設定込み）は全ホストで共有しているため**設定内容は同一**。新しい Mac で「ホットキーを押しても窓が出ない」場合は、次の順で確認する:

1. **そもそも設定が読み込まれているか**: フォント（MesloLGS NF）やウィンドウ位置が個人 PC と同じか確認。違う＝plist 未読込なので、**iTerm2 を終了してから** `switch` し直す（custom folder 方式が反映される。起動中は activation がスキップされる）。
2. **アクセシビリティ権限**: グローバルホットキーはキー入力をグローバル監視するため **macOS の権限が必要**（TCC 保護のため Nix/dotfiles では付与できず、マシンごとに手動許可）。システム設定 → プライバシーとセキュリティ → **アクセシビリティ** で **iTerm** を ON（必要なら**入力監視**も）。
3. iTerm2 を完全終了して再起動:

   ```bash
   osascript -e 'quit app "iTerm"' 2>/dev/null; open -a iTerm
   ```

## 設定の取り込み・反映

iTerm2 の **「Load preferences from a custom folder」** が `config/iterm2/` を指すため、iTerm2 は dotfiles 内の plist を直接読み書きする（[modules/home/iterm2.nix](../../modules/home/iterm2.nix) の activation がポインタを設定）。

**日常**: iTerm2 の Preferences で変更 → 終了時に **`config/iterm2/com.googlecode.iterm2.plist` へ直接書き戻される**（rebuild 不要）。`git diff` で確認してコミット。binary plist で書かれた場合は XML に変換:

```bash
plutil -convert xml1 config/iterm2/com.googlecode.iterm2.plist
git add config/iterm2/com.googlecode.iterm2.plist
```

**新しい Mac での初回反映**: **iTerm2 を終了した状態で** `nix run '.#switch' -- <host>`。activation が `PrefsCustomFolder` / `LoadPrefsFromCustomFolder` を設定する。起動中だった場合は終了して再度 switch。

## シェルで確認

```bash
keys-iterm   # または ki
```
