---
name: git-commit
description: Conventional Commits 形式で、WHY（なぜその変更が必要か）に焦点を当てたコミットメッセージを作成する。
disable-model-invocation: true
---

## 手順

1. `git status` と `git diff`（必要なら `git diff --staged`）で変更内容を把握する。
2. コミットメッセージは [Conventional Commits](https://www.conventionalcommits.org/) に従う：`type(scope): subject`（scope は省略可）。
3. **subject と本文で WHY を優先**する（何をしたかより、なぜそうしたか・どんな問題を解くか）。
4. ユーザーが既にステージしている場合はそのままコミット案を提示し、していない場合は `git add` の提案まで含める。

## 出力形式

- 推奨メッセージ全文（タイトル + 空行 + 本文）
- 変更が複数の論理単位に分かれる場合は、コミットを分割する提案も書く
