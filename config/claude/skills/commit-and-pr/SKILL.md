---
name: commit-and-pr
description: コミットと push のあと、`gh` でドラフトの Pull Request を作成する。
disable-model-invocation: true
---

## 前提

- `gh` が認証済みであること。
- 権限により `gh pr create` が許可されていること。

## 手順

1. `/commit-and-push` と同様にコミットまで完了させる（または既存コミットを push のみにするかはユーザー指示に従う）。
2. `git push` でブランチをリモートに載せる。
3. `gh pr create --draft` でドラフト PR を作成する。タイトル・本文は変更内容と WHY が伝わるように書く。ベースブランチが不明なら `gh repo view` やデフォルトブランチを確認する。
4. 作成した PR の URL をユーザーに返す。
