---
name: nix-settings-drift
description: Detect and reconcile drift between ~/.claude/settings.json and the dotfiles template at config/claude/settings.json. Use when settings.json has been modified outside Nix (plugin install, /config edits) and needs to be persisted to the template so it survives a re-install on another machine.
allowed-tools: Read, Bash, Edit, Write, Grep, Glob
---

## 概要

`~/.claude/settings.json` が dotfiles のテンプレ (`config/claude/settings.json`) から
変更されていないか確認し、差分をテンプレに反映する。

このリポジトリの `modules/home/claude-code.nix` は **初回のみ** テンプレを実機にコピーする戦略のため、
通常の `darwin-rebuild switch` ではテンプレ更新が実機に降りてこない (`config-drift-warnings.nix` が
通知のみ)。本 skill はその逆方向 — **実機 → テンプレ** の取り込みを補助する。

## 手順

1. 差分確認

   ```bash
   diff <(jq -S . ~/.claude/settings.json) \
        <(jq -S . ~/Development/dotfiles/config/claude/settings.json)
   ```

2. 差分がなければ「差分なし」と報告して終了。
3. 差分がある場合、 種別ごとに反映先を判断する。

## 反映先の判定

| 変更内容                                                     | 反映先                                                                                         |
| ------------------------------------------------------------ | ---------------------------------------------------------------------------------------------- |
| `permissions.allow` / `permissions.deny` の追加              | `config/claude/settings.json`                                                                  |
| `hooks` の登録 / 解除                                        | 同上                                                                                           |
| `model` / `theme` / `preferredNotifChannel` 等の項目         | 同上                                                                                           |
| `enabledPlugins` / `extraKnownMarketplaces` (公開可能なもの) | 同上                                                                                           |
| 機密情報 (業務 marketplace の token / private repo URL 等)   | テンプレに入れず `~/.claude/settings.local.json` に手動配置 (このリポジトリは sops-nix 未採用) |
| 一時的な調整 (temperature / maxTokens の試行錯誤)            | 無視してよい                                                                                   |

## 重要

- `darwin-rebuild switch` の実行は **ユーザーに任せる** (skill 側で自動実行しない)。
- 取り込み完了後は **何を反映したか** と **次のアクション (`git diff config/claude/settings.json` で確認 → commit)** を明示してユーザーに報告すること。
- テンプレ側 `config/claude/settings.json` を更新するだけでは実機 `~/.claude/settings.json` は変わらない。
  実機にも変更を入れたい場合は、 既に実機の方を編集しているはずなのでそのまま放置で OK。
  別マシンでセットアップし直すと `home.activation.installClaudeSettings` でテンプレが反映される。
