---
name: commit-and-push
description: 変更をレビューしたうえでコミットし、現在のブランチへ push する。
disable-model-invocation: true
---

## 手順

1. `git status` と diff で内容を確認する。意図しないファイルが含まれていれば除外またはユーザーに確認する。
2. `/git-commit` スキルと同様の方針で Conventional Commits 形式のメッセージを用意する（WHY を中心に）。
3. ユーザーが明示していない限り、勝手に `--force` や main への強制 push はしない（権限設定でも禁止されている）。
4. `git add` → `git commit` → `git push` を順に実行する。リモートやブランチ名が不明なときは確認する。
