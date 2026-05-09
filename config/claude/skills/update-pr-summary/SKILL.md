---
name: update-pr-summary
description: 現在のブランチとベースとの差分から、PR の説明文を生成または更新する。
disable-model-invocation: true
---

## 手順

1. 対象 PR を特定する：`gh pr view`（現在ブランチ）またはユーザー指定の番号・URL。
2. `git fetch` 済みなら、`gh pr diff` または `git diff` でベースとの差分を把握する。
3. PR 説明に含める内容の例：
   - 背景・目的（WHY）
   - 変更の要約（箇条書き）
   - レビュアー向けの確認ポイント・リスク
   - テストの有無・実行コマンド
4. `gh pr edit <番号> --body-file` または適切な `gh pr edit` で本文を更新する。ユーザーが「案だけ欲しい」の場合はファイルには書き込まずチャットに出力する。
